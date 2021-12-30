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
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
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

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.mulungushi.data.CourseDao;
import org.uci.opus.mulungushi.data.ProgrammeDao;
import org.uci.opus.mulungushi.domain.Course;
import org.uci.opus.mulungushi.domain.ProgCourse;
import org.uci.opus.mulungushi.domain.Programme;

public class CourseMigrator {

	public static final String EXAMINATION_TYPE_EXAM = "2";
	public static final String EXAMINATION_TYPE_CA = "102";

    private static Logger log = LoggerFactory.getLogger(CourseMigrator.class);
	
	@Autowired private DataSource dataSource;
	@Autowired private ExaminationManagerInterface examinationManager;
	@Autowired private SubjectManagerInterface subjectManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private CourseDao courseDao;
	@Autowired private ProgrammeDao programDao;
	@Autowired private StaffMigrator staffMigrator;
	@Autowired private ProgrammeMigrator programmeMigrator;
	
	private Map<String, Study> programNoToStudyMap;

	public CourseMigrator() {
	}

	public void convertCourses() throws SQLException {
    	log.info("Starting conversion of Courses");
    	log.info("Going to delete course related data in DB");

        dbUtil.truncateTable("testteacher");
        dbUtil.truncateTable("test");
        dbUtil.truncateTable("examinationteacher");
        dbUtil.truncateTable("examination");
        dbUtil.truncateTable("subjectteacher");
		dbUtil.truncateTable("subjectstudygradetype");
		dbUtil.truncateTable("subject");
		
		this.programNoToStudyMap = programmeMigrator.getProgramNoToStudyMap();

		for (Course course : courseDao.getCourses()) {
			
			if (course.getSchool() == null || course.getSchool().isEmpty()) {
				log.warn("No school set for course " + course.getCourseNo() + " / " + course.getCourseName());
			} else if (course.getProgCourses().isEmpty()) {
				log.warn("No 'progcourses' entry for course " + course.getCourseNo() + " / " + course.getCourseName());
			} else {

				Study primaryStudy = findPrimaryStudy(course);
				if (primaryStudy == null) {
					log.warn("No related study in same school found for course " + course.getCourseNo() + " / " + course.getCourseName());
				} else {

					for (AcademicYear year : getAcademicYears()) {
						
						Subject subject = new Subject();
						subject.setCurrentAcademicYearId(year.getId());
						subject.setSubjectCode(course.getCourseNo());
						subject.setSubjectDescription(course.getCourseName());
						subject.setActive("Y");
						subject.setPrimaryStudyId(primaryStudy.getId());
						subject.setFreeChoiceOption("N");
						subject.setCreditAmount(new BigDecimal("1.0"));
						subject.setHoursToInvest(0);
						subject.setStudyTimeCode("1");
						subject.setMaximumParticipants(0);
						subject.setResultType("");
						subjectManager.addSubject(subject);
						
						SubjectTeacher subjectTeacher = new SubjectTeacher();
						subjectTeacher.setSubjectId(subject.getId());
						StaffMember staffMember = staffMigrator.getDepartmentIdToStaffMemberMap().get(primaryStudy.getOrganizationalUnitId());
						subjectTeacher.setStaffMemberId(staffMember.getStaffMemberId());
						subjectTeacher.setActive("Y");
						subjectManager.addSubjectTeacher(subjectTeacher);
						
						for (ProgCourse progCourse : course.getProgCourses()) {
							StudyGradeType studyGradeType = programmeMigrator.getStudyGradeType(progCourse.getProgramNo(), year.getId());
							if (studyGradeType == null) {
								log.warn("No study program in Opus for programNo = " + progCourse.getProgramNo());
							} else {
								SubjectStudyGradeType ssgt = new SubjectStudyGradeType();
								ssgt.setSubjectId(subject.getId());
								ssgt.setStudyGradeTypeId(studyGradeType.getId());
								ssgt.setActive("Y");
								ssgt.setCardinalTimeUnitNumber(getCTUnr(course.getCourseNo()));
								ssgt.setRigidityTypeCode(progCourse.isElective() ? "3" : "1");		// 1 = mandatory, 3 = elective
								subjectManager.addSubjectStudyGradeType(ssgt);
							}
						}
						
						// Create the 40% CA and 60% Exam structure -> make two Examinations
						Examination ca = new Examination();
						ca.setSubjectId(subject.getId());
						ca.setActive("Y");
						ca.setExaminationCode(subject.getSubjectCode() + "_CA");
						ca.setExaminationDescription("Continuous Assessment");
						ca.setExaminationTypeCode(EXAMINATION_TYPE_CA);
						ca.setNumberOfAttempts(1);
						ca.setWeighingFactor(40);
						examinationManager.addExamination(ca);
						
						ExaminationTeacher caTeacher = new ExaminationTeacher(ca.getId(), staffMember.getStaffMemberId());
						examinationManager.addExaminationTeacher(caTeacher);
						
                        Examination exam = new Examination();
                        exam.setSubjectId(subject.getId());
                        exam.setActive("Y");
                        exam.setExaminationCode(subject.getSubjectCode() + "_EX");
                        exam.setExaminationDescription("Exam");
                        exam.setExaminationTypeCode(EXAMINATION_TYPE_EXAM);
                        exam.setNumberOfAttempts(2);
                        exam.setWeighingFactor(60);
                        examinationManager.addExamination(exam);

                        ExaminationTeacher examTeacher = new ExaminationTeacher(exam.getId(), staffMember.getStaffMemberId());
                        examinationManager.addExaminationTeacher(examTeacher);
                        
					}
				}
			}
		}
	}

	private int getCTUnr(String courseNo) {

	    // in case last character is 'A', cut it away for the sake of determining year/semester
	    // Example: BCM432A -> BCM432
	    if (courseNo.endsWith("A")) {
	        courseNo = courseNo.substring(0, courseNo.length() - 1);
	    }

		try {
			int year = Integer.parseInt(courseNo.substring(courseNo.length()-3, courseNo.length()-2));
			int semester = Integer.parseInt(courseNo.substring(courseNo.length()-1));
			return (year - 1) * 2 + semester;
		} catch (Exception e) {
			log.warn("Cannot deduce year / semester for courseNo " + courseNo + ". Using CTUnr = 1");
			return 1;
		}
		
	}
	
	private Study findPrimaryStudy(Course course) {
		
		Programme primaryProgram = null;
		
		for (ProgCourse progCourse : course.getProgCourses()) {
		    String programNo = progCourse.getProgramNo();
			Programme program = getProgram(programNo);
			if (program != null) {
				if (course.getSchool().equalsIgnoreCase(program.getSchool())) {
					primaryProgram = program;
					break;
				}
			}
		}
		
		// If nothing in same school, just take the first program
		if (primaryProgram == null && !course.getProgCourses().isEmpty()) {
			primaryProgram = getProgram(course.getProgCourses().get(0).getProgramNo());
		}

		Study primaryStudy = null;
		if (primaryProgram != null) {
			primaryStudy = programNoToStudyMap.get(primaryProgram.getProgrammeNumber());
		}

		return primaryStudy;
	}

	public Programme getProgram(String programNo) {
//		int spaceIdx = programNo.indexOf(" ");
//		String generalProgramNo = programNo.substring(0, spaceIdx);
//		Programme program = codeToProgramMap.get(generalProgramNo);
//		return program;
		return programmeMigrator.getProgram(programNo);
	}

	private List<AcademicYear> getAcademicYears() {
		return programmeMigrator.getAcademicYears();
	}

}
