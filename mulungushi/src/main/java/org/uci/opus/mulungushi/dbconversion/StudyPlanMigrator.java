/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College cbu module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/
package org.uci.opus.mulungushi.dbconversion;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.factory.AddressFactory;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.mulungushi.data.MuGradesDao;
import org.uci.opus.mulungushi.data.MuStudentDao;
import org.uci.opus.mulungushi.domain.MuGrade;

public class StudyPlanMigrator {

	private static Logger log = LoggerFactory.getLogger(StudyPlanMigrator.class);
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private ResultManagerInterface resultManager;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private DataSource dataSource;
	@Autowired private DBUtil dbUtil;
	@Autowired private CourseMigrator courseMigrator;
	@Autowired private ProgrammeMigrator programmeMigrator;
	@Autowired private MuStudentDao studentDao;
	@Autowired private LookupManagerInterface lookupManager;
	@Autowired private AddressFactory addressFactory;
	@Autowired private AddressManagerInterface addressManager;
	@Autowired private MuGradesDao muGradesDao;
	@Autowired private StudentMigrator studentMigrator;
	@Autowired private SubjectManagerInterface subjectManager;
	
    static private SimpleDateFormat df = (SimpleDateFormat) DateFormat.getDateInstance();
	static private HttpServletRequest request = new MockHttpServletRequest();

    static {
        df.applyPattern("yyyy-MM-dd");
        request.setAttribute("writeWho", "migration");
    }

	public void deleteStudyPlanData() {
		log.info("Going to delete student related data in DB");
		dbUtil.truncateTable("testresult");
		dbUtil.truncateTable("examinationresult");
		dbUtil.truncateTable("subjectresult");
		dbUtil.truncateTable("studyplandetail");
		dbUtil.truncateTable("studyplancardinaltimeunit");
		dbUtil.truncateTable("studyplan");
	}

	public void convertStudyPlans() throws Exception {
    	log.info("Starting conversion of study plans");

    	deleteStudyPlanData();

		for (MuGrade muGrade : muGradesDao.getGrades()) {

			Study study = programmeMigrator.getStudy(muGrade.getProgramNo());
			if (study == null) {
				log.warn("No study for programNo = " + muGrade.getProgramNo());
			} else {
				
				AcademicYear year = programmeMigrator.getAcademicYear(muGrade.getAcademicYear());
				if (year == null) {
					log.warn("No academic year '" + muGrade.getAcademicYear() + "' exists as given in grades record " + muGrade);
				} else {

					Student student = studentMigrator.getStudent(Integer.toString(muGrade.getStudentNo()));
					if (student == null) {
						log.warn("No student found with studentNo " + muGrade.getStudentNo() + " as given in grades record " + muGrade);
					} else {
						StudyGradeType sgt = programmeMigrator.getStudyGradeType(muGrade.getProgramNo(), year.getId());
						StudyPlan studyPlan = findOrCreateStudyPlan(student, sgt);

						for (Integer ctunr : getCardinalTimeUnitNumbers(muGrade.getProgramNo(), muGrade.getSemester())) {

							// Only add spctu once; there are several grades records, one per subscribed course
							StudyPlanCardinalTimeUnit spctu = findOrCreateSPCTU(sgt, studyPlan, ctunr);

							// StudyPlanDetails
							Subject subject = findSubject(muGrade.getCourseNo(), year);
							if (subject == null) {
								log.warn("Cannot add course to studyplan, because no subject found in Opus database for courseNo = " + muGrade.getCourseNo() + " and year " + year.getDescription());
							} else {
								StudyPlanDetail spd = findOrCreateStudyPlanDetail(spctu, sgt, subject.getId());
                                String passed = getPassed(muGrade);
                                int staffMemberId = subject.getSubjectTeachers().get(0).getStaffMemberId();

                                String caMark = muGrade.getCaMarks() != null && muGrade.getCaMarks().doubleValue() != 0.0 ? muGrade.getCaMarks().toString() : null;
                                if (caMark != null && !"0".equals(caMark)) {
                                    Examination ca = findCA(subject);
                                    ExaminationResult caResult = new ExaminationResult(ca.getId(), subject.getId(), spd.getId(), staffMemberId, caMark, passed);
                                    caResult.setAttemptNr(nextAttemptNumber(ca, spd.getId()));
                                    resultManager.addExaminationResult(caResult, request);
                                }

                                String examMark = muGrade.getExamMarks() != null && muGrade.getExamMarks().doubleValue() != 0.0 ? muGrade.getExamMarks().toString() : null;
                                if (examMark != null) {
                                    Examination exam = findExam(subject);
                                    ExaminationResult examResult = new ExaminationResult(exam.getId(), subject.getId(), spd.getId(), staffMemberId, examMark, passed);
                                    examResult.setAttemptNr(nextAttemptNumber(exam, spd.getId()));
                                    resultManager.addExaminationResult(examResult, request);
                                }

                                // subject result
                                String subjectMark = muGrade.getTotalMarks() != null && muGrade.getTotalMarks().doubleValue() != 0.0 ? muGrade.getTotalMarks().toString() : null;
                                if (subjectMark != null) {
    								SubjectResult sr = new SubjectResult();
    								sr.setActive("Y");
    								sr.setStudyPlanDetailId(spd.getId());
    								sr.setSubjectId(spd.getSubjectId());
                                    sr.setMark(subjectMark);
    								sr.setEndGradeComment(muGrade.getGrade());
                                    sr.setPassed(passed);
                                    sr.setStaffMemberId(staffMemberId);
    								sr.setSubjectResultDate(new Date());
    								resultManager.addSubjectResult(sr, request);
                                }
							}
						}
					}
				}
			}
		}

	}
	
	/**
	 * In case there are several examinations (CA or exam) for the same student / examination, then increase the attempt nr
	 * and issue a warning, because theoretically it should never happen that there are more than one result.
	 * @param examinationId
	 * @param studyPlanDetailId
	 * @return
	 */
	private int nextAttemptNumber(Examination examination, int studyPlanDetailId) {
	    
	    int nextAttemptNr = 1;
	    
	    Map<String, Object> map = new HashMap<>();
	    map.put("studyPlanDetailId", studyPlanDetailId);
	    map.put("examinationId", examination.getId());
	    List<ExaminationResult> examinationResults = resultManager.findExaminationResultsByParams(map);
	    if (!examinationResults.isEmpty()) {
	        
	        // examinationResults ordered by attemptNr, so take the last one and add 1
	        ExaminationResult lastEr = examinationResults.get(examinationResults.size() - 1);
	        nextAttemptNr = lastEr.getAttemptNr() + 1;

	        log.warn("Duplicate result (" + nextAttemptNr + ") for examination " + examination.getExaminationCode() + " / " + examination.getExaminationDescription());
	    }
	    
	    return nextAttemptNr;
	}
	
	private String getPassed(MuGrade muGrade) {
		String passed = "N";
		
		String grade = muGrade.getGrade();
		if (grade != null && !grade.isEmpty()) {

			String first = grade.substring(0, 1);
			if ("A".equalsIgnoreCase(first) || "B".equalsIgnoreCase(first)
					|| "C".equalsIgnoreCase(first) || "D".equalsIgnoreCase(first)
					|| "P".equalsIgnoreCase(first)) {
				passed = "Y";
			}
		}

		return passed;
	}

	private Subject findSubject(String subjectCode, AcademicYear year) {
		Map<String, Object> map = new HashMap<>();
		map.put("subjectCode", subjectCode);
		map.put("academicYearId", year.getId());
		return subjectManager.findSubjectByCode(map);
	}
	
	private Examination findCA(Subject subject) {
	    return findExamination(subject, CourseMigrator.EXAMINATION_TYPE_CA);
	}

    private Examination findExam(Subject subject) {
        return findExamination(subject, CourseMigrator.EXAMINATION_TYPE_EXAM);
    }

    private Examination findExamination(Subject subject, String examTypeCode) {
        return DomainUtil.getObjectByPropertyValue(subject.getExaminations(), "examinationTypeCode", examTypeCode);
    }
    
	private StudyPlanDetail findOrCreateStudyPlanDetail(StudyPlanCardinalTimeUnit spctu, StudyGradeType sgt, int subjectId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("studyPlanCardinalTimeUnitId", spctu.getId());
		map.put("studyGradeTypeId", sgt.getId());
		map.put("subjectId", subjectId);
		StudyPlanDetail spd = studentManager.findStudyPlanDetailByParams(map);
		
		if (spd == null) {
			spd = new StudyPlanDetail();
			spd.setActive("Y");
			spd.setStudyPlanId(spctu.getStudyPlanId());
			spd.setStudyPlanCardinalTimeUnitId(spctu.getId());
			spd.setStudyGradeTypeId(sgt.getId());
			spd.setSubjectId(subjectId);
			studentManager.addStudyPlanDetail(spd, null);
		}
		
		return spd;
	}
	
	private StudyPlanCardinalTimeUnit findOrCreateSPCTU(StudyGradeType studyGradeType, StudyPlan studyPlan, Integer ctunr) {
		
		StudyPlanCardinalTimeUnit spctu = studentManager.findStudyPlanCardinalTimeUnitByParams(studyPlan.getId(), studyGradeType.getId(), ctunr);
		
		if (spctu == null) {
			spctu = new StudyPlanCardinalTimeUnit();
			spctu.setActive("Y");
			spctu.setStudyPlanId(studyPlan.getId());
			spctu.setStudyGradeTypeId(studyGradeType.getId());
			spctu.setCardinalTimeUnitNumber(ctunr);
			spctu.setCardinalTimeUnitStatusCode(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
			spctu.setStudyIntensityCode("");
			// For last semester (in academic year 2014/15) set progress status to "Waiting for results", otherwise "proceed"
			spctu.setProgressStatusCode(programmeMigrator.getYear1415().getId() == studyGradeType.getCurrentAcademicYearId() ? "54" : "04");
			spctu.setTuitionWaiver("N");
			studentManager.addStudyPlanCardinalTimeUnit(spctu, null, null);
		}
		
		return spctu;
	}

	private StudyPlan findOrCreateStudyPlan(Student student, StudyGradeType sgt) {

		Map<String, Object> map = new HashMap<>();
		map.put("studentId", student.getStudentId());
		map.put("studyId", sgt.getStudyId());
		map.put("gradeTypeCode", sgt.getGradeTypeCode());
		StudyPlan studyPlan = studentManager.findStudyPlanByParams2(map);

		if (studyPlan == null) {
			studyPlan = new StudyPlan();
			studyPlan.setStudentId(student.getStudentId());
			studyPlan.setActive("Y");
			studyPlan.setStudyId(sgt.getStudyId());
			studyPlan.setGradeTypeCode(sgt.getGradeTypeCode());
			studyPlan.setStudyPlanDescription(programmeMigrator.getStudy(sgt.getStudyId()).getStudyDescription() + " - " + programmeMigrator.getGradeType(sgt.getGradeTypeCode()).getDescription());
			studyPlan.setStudyPlanStatusCode(OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION);
	
			// store the new study plan
			studentManager.addStudyPlanToStudent(studyPlan, "migration");
		}
		return studyPlan;
	}

	/**
	 * Calculate the time unit number, ie. number of semesters, based on the parameters.
	 * @param programNoWithSpace e.g. "BABM II"
	 * @param semester e.g. "Semester I"
	 */
	public List<Integer> getCardinalTimeUnitNumbers(String programNoWithSpace, String semester) {
		List<Integer> n = new ArrayList<>();
		
		Integer yearNumber = programmeMigrator.getProgramYearNumber(programNoWithSpace);
		if (yearNumber != null) {
			List<Integer> semesters = getSemesterNumbers(semester);
			for (int semesterNumber : semesters) {
				int ctunr = ((yearNumber - 1) * 2) + semesterNumber;
				n.add(ctunr);
			}
		}
		
		return n;
	}

	/**
	 * Convert the semester string to one or two numbers
	 * @param semester e.g. "Semester I", "Year"
	 * @return either 1 or 2, or null if no conversion possible
	 */
	public List<Integer> getSemesterNumbers(String semester) {
		List<Integer> n = new ArrayList<>();
		
		semester = semester.trim().toLowerCase();
		if (semester.startsWith("year")) {
			n.add(1);
			n.add(2);
		} else if ("semester ii".equalsIgnoreCase(semester)) {
			n.add(2);
		} else if ("semester i".equalsIgnoreCase(semester)) {
			n.add(1);
		} else {
			log.warn("No semester information available from " + semester);
		}
		
		return n;
	}
}
