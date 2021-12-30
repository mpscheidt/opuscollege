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
package org.uci.opus.cbu.dbconversion;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;
import org.uci.opus.cbu.data.ProgrammeDao;
import org.uci.opus.cbu.data.StudentDao;
import org.uci.opus.cbu.domain.Programme;
import org.uci.opus.cbu.domain.Results;
import org.uci.opus.cbu.domain.SecondarySchoolSubjectResult;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentStudentStatus;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.StudentUtil;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;

public class StudentMigrator {

	private static Logger log = LoggerFactory.getLogger(StudentMigrator.class);
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private ResultManagerInterface resultManager;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private DataSource dataSource;
	@Autowired private DBUtil dbUtil;
	@Autowired private StudentDao studentDao;
	@Autowired private ProgrammeDao programmeDao;
	@Autowired private CourseMigrator courseMigrator;
	@Autowired private ProgrammeMigrator programmeMigrator;
	
    MockHttpServletRequest request = new MockHttpServletRequest();

	public void convertStudents() throws Exception {
		//dbUtil.truncateTable("student");
		//dbUtil.truncateTable("studyplan");
		//dbUtil.truncateTable("studyplandetail");
		//dbUtil.truncateTable("studyplancardinaltimeunit");
		//dbUtil.truncateTable("subjectresult");
		//dbUtil.truncateTable("cardinaltimeunitresult");
		
		List<Programme> programmes=programmeDao.getProgrammes();
		for(Programme programme:programmes){
			int organizationalUnitId=getOrganizationalUnitId(programme.getDepartment().getCode());
			
			List<org.uci.opus.cbu.domain.Student> cbuStudents=studentDao.getStudents(programme.getCode());
			if(cbuStudents!=null){
				for(org.uci.opus.cbu.domain.Student cbuStudent:cbuStudents){
					
					if(log.isInfoEnabled())
						log.info(cbuStudent.toString());
					
					Student student = new Student();
					setStudentPersonalDetails(student, cbuStudent);
					StudentUtil.setDefaultValues(student); // DB expects certain values
					
					String preferredLanguage = "en_ZM";
					OpusUserRole opusUserRole = new OpusUserRole();
					OpusUser opusUser = new OpusUser();
					opusUser.setLang(preferredLanguage);
					Locale currentLocale = new Locale("en_ZM");
					
					student.setPrimaryStudyId(getStudyID(programmeDao.getStudyDescription(cbuStudent.getProgramme().getName()),organizationalUnitId));
					
					if (getOrganisationUnitID(student.getPrimaryStudyId()) != 0) {
						deletePerson(cbuStudent.getStudentNo());
						if (student.getStudentId()==0 && studentManager.validateNewStudent(student, currentLocale).equals("")){
							studentManager.addStudent(student, opusUserRole,opusUser);
							//add student status
							StudentStudentStatus studentStudentStatus=new StudentStudentStatus();
							studentStudentStatus.setStudentStatusCode("1");
							studentStudentStatus.setStudentId(student.getStudentId());
							studentStudentStatus.setStartDate(student.getDateOfEnrolment());
							
							studentManager.addStudentStudentStatus(studentStudentStatus);
						}else{
							Student stud=studentManager.findStudentByCode(cbuStudent.getStudentNo());
							student.setStudentId(stud.getStudentId());
							studentManager.updateStudent(student, opusUserRole, opusUser, null);
						}
						
						if(log.isInfoEnabled())
							log.info(cbuStudent.getProgramme().toString());
						
						//Transfer from various tables
						transferResults(student,programme.getCode());
												
						//Transfer secondary School subject for a student
						transferSecondarySchoolResults(student, programme.getCode(), cbuStudent.getYearOfEntry());
					}
				}
			}
		}
	}
	
	private void transferSecondarySchoolResults(Student student, String programmeCode,int yearOfEntry){
		Programme programme=programmeDao.getProgramme(programmeCode, yearOfEntry);
		List<SecondarySchoolSubjectResult> results=studentDao.getSecondarySchoolResults(student.getStudentCode());
		int organizationUnitId=getOrganizationalUnitId(programme.getDepartment().getCode());
		String programmeName=programme.getName();
		String studyTimeCode=getStudyTimeCode(programmeDao.getStudyTimeDescription(programmeName));
		int academicYearId=getAcademicYearId(String.valueOf(yearOfEntry));
		String gradeTypeCode=programmeDao.getGradeTypeCode(programmeName);
		String studyDescription=programmeDao.getStudyDescription(programmeName);
		
		int studyGradeTypeId=getStudyGradeTypeId(gradeTypeCode, studyDescription,academicYearId,studyTimeCode,organizationUnitId);
		
		if(results!=null && studyGradeTypeId!=0){
			int studyId=getStudyID(programmeDao.getStudyDescription(programmeName),getOrganizationalUnitId(programme.getDepartment().getCode()));
			for(SecondarySchoolSubjectResult result:results){
				int subjectId=getSecondarySubjectId(result.getSubjectName());
				StudyPlan studyPlan=getStudyPlan(student.getStudentId(),studyId, programmeDao.getGradeTypeCode(programmeName));
				if(result.getGrade()!=null){
					//add studyplan for students did not report for their study
					if(studyPlan==null){
						addStudyPlanToStudent(student,studyGradeTypeId);
						studyPlan=getStudyPlan(student.getStudentId(),studyId, programmeDao.getGradeTypeCode(programmeName));
					}
					addGradedSecondarySchoolSubject(subjectId,studyPlan.getId(),studyGradeTypeId,String.valueOf(result.getGrade()));
				}
			}
		}
	}
	
	/**
	 * Transfer results 
	 * 
	 * @param student
	 * @param programme
	 * @throws Exception
	 */
	private void transferResults(Student student,String programmeCode)	throws Exception {
		List<Results> results;
		//transfer results from core tables
		for(int cardinalTimeUnitNumber=1; cardinalTimeUnitNumber<=8;cardinalTimeUnitNumber++){
			results=studentDao.getResults(student.getStudentCode(),programmeCode, cardinalTimeUnitNumber);
			saveResults(student,results,cardinalTimeUnitNumber);
		}
		
		//transfer results from results_details
		for(int yearRegistered=2010; yearRegistered<=2012;yearRegistered++){
			results=studentDao.getResults(student.getStudentCode(),yearRegistered);
			int cardinalTimeUnitNumber = studentDao.getYearOfStudy(student.getStudentCode(),yearRegistered);
			saveResults(student,results,cardinalTimeUnitNumber);
		}
	}
	
	private void saveResults(Student student,List<Results> results,int cardinalTimeUnitNumber){
		Collection<Integer> subjectIds = new ArrayList<Integer>();
		if(results!=null && cardinalTimeUnitNumber!=0){
			
			SubjectResult subjectResult=new SubjectResult();
			
			for(Results result:results){
				int studyPlanId=0;
				Programme programme=programmeDao.getProgramme(result.getCourse().getProgramme().getCode(),result.getYear());
				
				int organizationUnitId=getOrganizationalUnitId(programme.getDepartment().getCode());
				String programmeName=programme.getName();
				String studyTimeCode=getStudyTimeCode(programmeDao.getStudyTimeDescription(programmeName));
				int academicYearId=getAcademicYearId(String.valueOf(result.getYear()));
				String gradeTypeCode=programmeDao.getGradeTypeCode(programmeName);
				String studyDescription=programmeDao.getStudyDescription(programmeName);
				
				//System.out.println(programmeName);
				//courseMigrator.addSubject(result.getCourse().getProgramme().getCode(), result.getCourse().getCode(), result.getCourse().getName(), result.getCourse().getYearOfStudy(), academicYearId, result.getCourse().isActive()?"Y":"n");
				int studyGradeTypeId=getStudyGradeTypeId(gradeTypeCode, studyDescription,academicYearId,studyTimeCode,organizationUnitId);
				int subjectId = getSubjectId(result.getCourse().getCode(),result.getCourse().getName(), academicYearId);
				String programmeCode=programme.getCode();
				
				AcademicYear academicYear=academicYearManager.findAcademicYear(academicYearId);
					
				//if studyGradeType is not found then add a new one
				if(studyGradeTypeId==0){
					
					String studyFormCode=programmeMigrator.getStudyFormCode(programmeDao.getStudyFormDescription(programmeName));
					int studyDuration=programme.getProgrammeDuration();
					String cardinalTimeUnit=programmeMigrator.getCardinalTimeUnit(programmeCode);
					int organizationalUnitId=programmeMigrator.getOrganizationalUnitId(programme.getDepartment().getCode());
	
					programmeMigrator.addStudyGradeType(programmeCode, studyDescription, gradeTypeCode, studyDuration, studyTimeCode, studyFormCode, cardinalTimeUnit, organizationalUnitId, academicYearId);
					studyGradeTypeId=getStudyGradeTypeId(gradeTypeCode, studyDescription,academicYearId,studyTimeCode,organizationUnitId);
					studyPlanId = addStudyPlanToStudent(student,studyGradeTypeId);
				}else{
					studyPlanId=addStudyPlanToStudent(student,studyGradeTypeId);
				}
				
				//wait for the studygradetype to be added and then add the subject
				if(subjectId==0 && result.getCourse().getName()!=null){
					if(result.getCourse().getCode()!=null && result.getCourse().getCode().length()>5){
						try{
							String courseCode=result.getCourse().getCode().trim();
							int yearOfStudy=Integer.valueOf(courseCode.substring(courseCode.length()-3,courseCode.length()-2));
							courseMigrator.addSubject(programmeCode, result.getCourse().getCode(), result.getCourse().getName(), yearOfStudy, result.getYear(), "N");
							subjectId = getSubjectId(result.getCourse().getCode(),result.getCourse().getName(), academicYearId);
						}catch(Exception ex){
							System.out.println("Failed to extract first digit from course =>"+result.getCourse().getCode() +", studentCode=>"+student.getStudentCode());
						}
					}
				}
				
				if(subjectId>0 && studyGradeTypeId!=0){
					subjectIds.add(subjectId);
					
					addStudyPlanCardinalTimeUnit(studyPlanId, studyGradeTypeId, cardinalTimeUnitNumber,getProgressStatusCode(result.getComment(),studyGradeTypeId,cardinalTimeUnitNumber));
					StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(studyPlanId,	studyGradeTypeId,cardinalTimeUnitNumber);
					addStudyPlanDetail(studyPlanId,subjectId,studyPlanCardinalTimeUnit.getId(),studyGradeTypeId);
					
					if(result.getGrade()!=null && !result.getGrade().trim().equals("")){
						subjectResult.setMark(String.valueOf(result.getMark()));
						subjectResult.setActive("Y");
						subjectResult.setSubjectId(subjectId);
						String passed = passedCourse(result.getGrade());
						subjectResult.setPassed(passed);
						subjectResult.setEndGradeComment(result.getGrade());
						subjectResult.setSubjectResultDate(academicYear.getEndDate());
						
						CardinalTimeUnitResult ctResult=new CardinalTimeUnitResult();
						//ctResult.setMark(String.valueOf(result.getMark()));
						//ctResult.setEndGrade(result.getGrade());
						ctResult.setPassed(passed(result.getComment()));
						ctResult.setEndGradeComment(result.getComment());
						ctResult.setActive("Y");
						ctResult.setWriteWho("opuscollege");
						
						addSubjectResult(studyPlanId, studyGradeTypeId, cardinalTimeUnitNumber, subjectId, subjectResult,ctResult);
					}
				}
			}
		}
	}
	
	/**
	 * 
	 * @param student
	 * @param studyGradeTypeId
	 * @return StudyPlanID
	 */
	private int addStudyPlanToStudent(Student student, int studyGradeTypeId) {
		StudyPlan studyPlan = new StudyPlan();
		StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
		if(studyGradeType!=null){
			String studyPlanDescription = studyGradeType.getStudyDescription() + " - " + studyGradeType.getGradeTypeDescription();
	
			int studentId = student.getStudentId();
			
			studyPlan.setActive("Y");
			studyPlan.setStudentId(studentId);
			studyPlan.setStudyId(studyGradeType.getStudyId());
			studyPlan.setGradeTypeCode(studyGradeType.getGradeTypeCode());
			studyPlan.setStudyPlanDescription(studyPlanDescription);
			studyPlan.setStudyPlanStatusCode("3"); // 3 .. actively registered
			
			StudyPlan studyPlanTemp=getStudyPlan(studentId, studyPlan.getStudyId(), studyPlan.getGradeTypeCode());
			if(studyPlanTemp==null){
				// add study plan to the database , so it will be assigned an id
			    studentManager.addStudyPlanToStudent(studyPlan, "migration");
				return studyPlan.getId();
			}else{
				return studyPlanTemp.getId();
			}
		}else{
			//log.error("No StudyGradeType With Id => "+ studyGradeTypeId);
			return 0;
		}
	}

	private void addStudyPlanDetail(int studyPlanId, int subjectId,int studyPlanCardinalTimeUnitId,int studyGradeTypeId){
		StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
		studyPlanDetail.setActive("Y");
		studyPlanDetail.setStudyPlanId(studyPlanId);
		studyPlanDetail.setSubjectId(subjectId);
		studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
		studyPlanDetail.setStudyGradeTypeId(studyGradeTypeId);
		
		// save the study plan
		int studyPlanDetailId= getStudyPlanDetailId(studyPlanId, subjectId,studyPlanCardinalTimeUnitId);
		
		if(studyPlanDetailId==0){
			studentManager.addStudyPlanDetail(studyPlanDetail,null);
			studyPlanDetailId= getStudyPlanDetailId(studyPlanId, subjectId,studyPlanCardinalTimeUnitId);
		}else{
			studyPlanDetail.setId(studyPlanDetailId);
			studentManager.updateStudyPlanDetail(studyPlanDetail);
		}
	}
	
	private void addSubjectResult(int studyPlanId, int studyGradeTypeId,int cardinalTimeUnitNumber, int subjectId,SubjectResult subjectResult,CardinalTimeUnitResult ctResult) {
		//System.out.println("cardinal Time Unit Number =>" + cardinalTimeUnitNumber);
		if(studyPlanId!=0){
			StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(
					studyPlanId,
					studyGradeTypeId,
					cardinalTimeUnitNumber);
			
			//Get studyPlanDetailId
			int studyPlanDetailId= getStudyPlanDetailId(studyPlanId, subjectId,studyPlanCardinalTimeUnit.getId());
			
			subjectResult.setStudyPlanDetailId(studyPlanDetailId);
			subjectResult.setStaffMemberId(getStaffMemberID());
			subjectResult.setWriteWho("opuscollege");
			// save the results
			
			int subjectResultId=getSubjectResultId(subjectId, studyPlanDetailId);
			if(studyGradeTypeId!=0){
				if(subjectResult.getEndGradeComment()!=null && !subjectResult.getEndGradeComment().trim().equals("")){
					if(subjectResultId==0){
						resultManager.addSubjectResult(subjectResult, request);
					}else{
						subjectResult.setId(subjectResultId);
						resultManager.updateSubjectResult(subjectResult, request);
					}
				}
			}
			
			ctResult.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());
			ctResult.setStudyPlanId(studyPlanId);
			
			//if(subjectResult.getSubjectResultDate().getYear()==2007) System.out.println("subjectId=>"+subjectId +", studyPlandDetailId=>"+studyPlanDetailId);

			CardinalTimeUnitResult ctResult2=getCardinalTimeUnitResult(studyPlanId, studyPlanCardinalTimeUnit.getId());
			if(ctResult2==null){
				resultManager.addCardinalTimeUnitResult(ctResult, "opuscollege");
			}else{
				ctResult.setId(ctResult2.getId());
				resultManager.updateCardinalTimeUnitResult(ctResult, "opuscollege");
			}
			
			if(log.isInfoEnabled())
				log.info("addSubjectResults => " + subjectResult);
		}
	}
	
	private void addStudyPlanCardinalTimeUnit(int studyPlanId,int studyGradeTypeId,int cardinalTimeUnitNumber,String progressStatusCode){
		boolean studyPlanCTUNotExist=false; 
		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(
				studyPlanId,
				studyGradeTypeId,
				cardinalTimeUnitNumber);
		
		if(studyPlanCardinalTimeUnit==null){
			studyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
			studyPlanCTUNotExist=true;
			//System.out.println("Not Found =>"+cardinalTimeUnitNumber);
		}else{
			//System.out.println("Found =>"+cardinalTimeUnitNumber);
		}
		
		studyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
		studyPlanCardinalTimeUnit.setStudyGradeTypeId(studyGradeTypeId);
		studyPlanCardinalTimeUnit.setStudyPlanId(studyPlanId);
		studyPlanCardinalTimeUnit.setTuitionWaiver("N");
		studyPlanCardinalTimeUnit.setActive("Y");
		studyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode("10"); // Actively Registered
		studyPlanCardinalTimeUnit.setProgressStatusCode(progressStatusCode);
		
		if(studyPlanCTUNotExist){
			studentManager.addStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, null, request);
		}else{
			studentManager.updateStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
		}
	}
	
	private String getSecondarySchoolSubjectCode(String subjectName) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		subjectName=(subjectName.trim().toLowerCase().indexOf("bible knowledge")!=-1 || subjectName.trim().toLowerCase().indexOf("religious education")!=-1)?"Bible Knowledge / Religious Education":subjectName;
		subjectName=(subjectName.trim().toLowerCase().indexOf("p/accounts")!=-1)?"Principles of Accounts":subjectName;
						
		List<Map<String, Object>> result = opus.queryForList("SELECT code FROM opuscollege.secondaryschoolsubject WHERE trim(lower(description))='" + subjectName.trim().toLowerCase() + "'");
		return result.toString().equals("[]")?null:result.get(0).get("code").toString();
	}
	
	private String getGradeCode(String endGradeTypeCode, String mark) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		List<Map<String, Object>> result = opus.queryForList("SELECT code FROM opuscollege.endgrade WHERE endgradetypecode='" + endGradeTypeCode + "' AND percentagemin>='"+mark+"' percentagemax<='"+mark+"'");
		return result.toString().equals("[]")?"":result.get(0).get("code").toString();
	}
	
	private CardinalTimeUnitResult getCardinalTimeUnitResult(int studyPlanId, int studyPlanCardinalTimeUniId) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		List<Map<String, Object>> result = opus.queryForList("SELECT id FROM opuscollege.cardinaltimeunitresult WHERE studyplanid='" + studyPlanId + "' AND studyplancardinaltimeunitid='"+studyPlanCardinalTimeUniId+"'");
		return resultManager.findCardinalTimeUnitResult(Integer.valueOf(result.toString().equals("[]")?"0":result.get(0).get("id").toString()));
	}
	
	
	/**
	 * This method is used to retrieve studyGradeTypeCode using studyTimeDescription as the parameter
	 * @param studyTimeDescription
	 * @return
	 */
	private String getStudyTimeCode(String studyTimeDescription) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyTimeObject = opus.queryForList("SELECT code FROM opuscollege.studytime WHERE description='" + studyTimeDescription + "'");
		return studyTimeObject.toString().equals("[]")?"D":studyTimeObject.get(0).get("code").toString();
	}
	
	private int getStudyID(String studyDescription, int organizationalUnitId) {

		JdbcTemplate temp = new JdbcTemplate(dataSource);
		String sql="SELECT id FROM opuscollege.study WHERE studydescription='"+ studyDescription + "' AND organizationalunitid='"+organizationalUnitId+"'";
		List<Map<String, Object>> studyObject = temp.queryForList(sql);
		
		if(log.isInfoEnabled())
			log.info("Executing in study => "+sql);
		if (!studyObject.toString().equals("[]"))
			return Integer.valueOf(studyObject.get(0).get("id").toString());
		else
			return 0;

	}

	private int getOrganisationUnitID(int studyID) {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyObject = temp.queryForList("SELECT organizationalunit.id FROM opuscollege.organizationalunit WHERE id= (SELECT organizationalunitid FROM opuscollege.study WHERE id='"+ studyID + "')");
		
		if(log.isInfoEnabled())
			log.info(studyObject.toString());
		if (!studyObject.toString().equals("[]"))
			return Integer.valueOf(studyObject.get(0).get("id").toString());
		else
			return 0;

	}
	
	private int getOrganizationalUnitId(String departmentCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstDepartment = opusTemplate
				.queryForList("SELECT * FROM opuscollege.organizationalunit where organizationalunitcode='"+ departmentCode+"'");
		if(lstDepartment.size() > 0){
			return Integer.parseInt(lstDepartment.get(0).get("id").toString());
		}
		return 0;
	}
	
	private String passedCourse(String grade) {
		String[] passedGrades = { "A+", "A", "B+", "B", "C+", "C", "P", "S" };
		String passed = "N";
		
		if (grade==null || grade.equals(""))
			return "";

		for (String g : passedGrades) {
			if (g.equals(grade)) {
				passed = "Y";
				break;
			}
		}

		return passed;
	}

	private Address getStudentAddress(org.uci.opus.cbu.domain.Student cbuStudent,
			String addressType) {
		Address address = new Address();
		address.setCity(cbuStudent.getTown() == null ? "" : cbuStudent.getTown());
		address.setPOBox(cbuStudent.getBoxNo() == null ? "" : cbuStudent.getBoxNo());
		address.setTelephone(cbuStudent.getTelephoneNo() == null ? "" :cbuStudent.getTelephoneNo());
		address.setEmailAddress(cbuStudent.getEmail() == null ? "" : cbuStudent.getEmail());
		address.setFaxNumber(cbuStudent.getFaxNo()== null ? "" : cbuStudent.getFaxNo());
		address.setStreet(cbuStudent.getStreet() == null ? "" : cbuStudent.getStreet());
		address.setMobilePhone(address.getTelephone());

		if (getAddressTypeCode(addressType) != null)
			address.setAddressTypeCode(getAddressTypeCode(addressType));

		if (address.getCity()!=null && getDistrictCode(address.getCity())!=null)
			address.setDistrictCode(getDistrictCode(address.getCity()));

		if (cbuStudent.getProvince()!=null && getProvinceCode(cbuStudent.getProvince()) != null)
			address.setProvinceCode(getProvinceCode(cbuStudent.getProvince()));

		if (cbuStudent.getProvince()!=null && getCountryCode(cbuStudent.getProvince())!=null)
			address.setCountryCode(getCountryCode(cbuStudent.getProvince()));

		return address;
	}

	private int getAcademicYearId(String academicYearDescription) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstAcademicYear = jdbc
				.queryForList("SELECT id FROM opuscollege.academicyear WHERE description='"
						+ academicYearDescription + "'");
		return lstAcademicYear.toString().equals("[]") ? 0 : Integer
				.valueOf(lstAcademicYear.get(0).get("id").toString());
	}

	private void deletePerson(String personCode) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		jdbc.execute("DELETE FROM opuscollege.person WHERE personcode='"
				+ personCode + "'");
	}

	private int getSubjectId(String subjectCode, String subjectDescription,int academicYearId) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		String sql="SELECT id FROM opuscollege.subject WHERE subjectcode='"+ subjectCode+ "' AND subjectdescription='"+ subjectDescription+ "' AND currentacademicyearid='"	+ academicYearId + "'";
		List<Map<String, Object>> lstSubject = jdbc.queryForList(sql);
		int id=lstSubject.toString().equals("[]") ? 0 : Integer	.valueOf(lstSubject.get(0).get("id").toString());
		
		return id;
	}
	
	private String passed(String comment){
		String passed="";
		if(comment!=null)
			if(comment.toLowerCase().indexOf("pt")==0 || comment.toLowerCase().indexOf("part-time")==0 || comment.toLowerCase().indexOf("part time")==0
				|| comment.toLowerCase().indexOf("ex")==0 || comment.toLowerCase().indexOf("sus")==0)
				passed="N";
			else
				passed="Y";
		
		return passed;
	}

	private String getAddressTypeCode(String param) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstAddressTypeCode = jdbc
				.queryForList("SELECT * FROM opuscollege.addresstype WHERE description='"
						+ param + "'");
		return lstAddressTypeCode.toString().equals("[]") ? null
				: lstAddressTypeCode.get(0).get("code").toString();
	}

	private String getDistrictCode(String param) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstDistrictCode = jdbc
				.queryForList("SELECT * FROM opuscollege.district WHERE lower(description)='"
						+ param.toString().toLowerCase() + "'");
		return lstDistrictCode.toString().equals("[]") ? null : lstDistrictCode
				.get(0).get("code").toString();
	}

	private String getProvinceCode(String param) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstProvinceCode = jdbc
				.queryForList("SELECT * FROM opuscollege.province WHERE lower(description)='"
						+ param.toString().toLowerCase() + "'");
		return lstProvinceCode.toString().equals("[]") ? null : lstProvinceCode
				.get(0).get("code").toString();
	}

	private String getCountryCode(String param) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstCountryCode = jdbc
				.queryForList("SELECT c.code FROM opuscollege.country AS c INNER JOIN opuscollege.province AS p ON c.code=p.countryCode WHERE lower(p.description)='"
						+ param.toString().toLowerCase() + "'");
		return lstCountryCode.toString().equals("[]") ? null : lstCountryCode
				.get(0).get("code").toString();
	}

	private int getStaffMemberID() {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> idList = jdbc
				.queryForList("SELECT staffmemberid FROM opuscollege.staffmember");
		return idList.toString().equals("[]") ? 0 : (Integer) idList.get(0)
				.get("staffmemberid");
	}

	private void setStudentPersonalDetails(Student student,org.uci.opus.cbu.domain.Student cbuStudent) throws ParseException {

		student.setSurnameFull(cbuStudent.getLastName());
		student.setFirstnamesFull(cbuStudent.getFirstName());
		student.setStudentCode(cbuStudent.getStudentNo());
		student.setPersonCode(cbuStudent.getStudentNo());
		student.setFirstnamesAlias(cbuStudent.getOtherNames());
		student.setGenderCode(getGenderCode(cbuStudent.getGender()));
		student.setNationalRegistrationNumber(cbuStudent.getNrcNo());
		student.setNationalityCode(cbuStudent.getNationality().getCode());
		student.setIdentificationNumber(cbuStudent.getPassportNo());
		student.setCivilTitleCode(getCiviltitleCode(cbuStudent.getMaritalStatus(),cbuStudent.getGender()));
		student.setBirthdate(cbuStudent.getDateOfBirth());
		if(cbuStudent.getTown()!=null) student.setCityOfOrigin(cbuStudent.getTown());
		student.setContactPersonEmergenciesName(cbuStudent.getNameOfGuardian());
		if(cbuStudent.getNationality()!=null && cbuStudent.getNationality().getName()!=null)student.setCountryOfOriginCode(getCountryCode(cbuStudent.getNationality().getName()));
		student.setDateOfEnrolment(cbuStudent.getDateOfEnrollment());
	
		//System.out.println("Date of Enrollment =>"+cbuStudent.getDateOfEnrollment());
		// sponsorship information to be added here
		//student.setPreviousInstitutionCountryCode(cbuStudent.get);
		student.setPrimaryStudyId(getStudyID(programmeDao.getStudyDescription(cbuStudent.getProgramme().getName()),getOrganizationalUnitId(cbuStudent.getProgramme().getDepartment().getCode())));
		if(cbuStudent.getProvince()!=null) student.setProvinceOfOriginCode(getProvinceCode(cbuStudent.getProvince()));

		List<Address> lstAddress = new ArrayList<Address>();
		Address homeAddress = getStudentAddress(cbuStudent, "home");
		Address formalAddress = getStudentAddress(cbuStudent,"formal communication address student");
		lstAddress.add(homeAddress);
		lstAddress.add(formalAddress);

		student.setAddresses(lstAddress);
	}

	private String getGenderCode(String gender) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstGender = jdbc
				.queryForList("SELECT code FROM opuscollege.gender WHERE description = '" + gender.toLowerCase().trim() + "'");
		if (lstGender.toString().equals("[]"))
			return null;
		else
			return lstGender.get(0).get("code").toString();

	}
	
	private String getCiviltitleCode(String maritalStatus, String gender) {
		
		maritalStatus = maritalStatus.trim().equals("") ? "single" : maritalStatus.trim().toLowerCase();
		gender = gender.trim().equals("") ? "male" : gender.trim().toLowerCase();
		
		String title = gender.toLowerCase().equals("male") ? "mr." : maritalStatus.equals("single") ? "ms." : "mrs.";
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstCivilTitle = jdbc
				.queryForList("SELECT code FROM opuscollege.civiltitle WHERE description = '"
						+ title + "'");
		if (lstCivilTitle.toString().equals("[]"))
			return null;
		else
			return lstCivilTitle.get(0).get("code").toString();

	}

	private int getStudyGradeTypeId(String gradeTypeCode,String studyDescription,int academicYearId,String studyTimeCode,int organizationalUnitId) {
		
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		String sql="SELECT id FROM opuscollege.studygradetype WHERE studyid = (SELECT id FROM opuscollege.study WHERE studydescription = '"
				+ studyDescription
				+ "' AND organizationalUnitId='"+organizationalUnitId+"')AND gradetypecode='"+gradeTypeCode+"' AND currentacademicyearid='"+academicYearId+"' AND studytimecode='"+studyTimeCode+"'";
		List<Map<String, Object>> idList = jdbc.queryForList(sql);
		int id=idList.toString().equals("[]") ? 0 : (Integer) idList.get(0).get("id");
		//if(id==0)System.out.println(sql);
		return id;
	}

	private StudyPlan getStudyPlan(int studentId,int studyId, String gradeTypeCode) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> idList = jdbc
				.queryForList("SELECT id FROM opuscollege.studyplan WHERE studentid='"+studentId+"' AND studyid = '"
						+ studyId + "' AND gradetypecode='" + gradeTypeCode + "'");
		
		return studentManager.findStudyPlan(idList.toString().equals("[]") ? 0 : (Integer) idList.get(0)
				.get("id"));
	}

	private int getStudyPlanDetailId(int studyPlanId, int subjectId,int studyPlanCardinalTimeUnitId) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> idList = jdbc
				.queryForList("SELECT id FROM opuscollege.studyplandetail WHERE studyplanid = '"
						+ studyPlanId + "' AND subjectid='" + subjectId + "' AND studyPlanCardinalTimeUnitId='"+studyPlanCardinalTimeUnitId+"'");
		return idList.toString().equals("[]") ? 0 : (Integer) idList.get(0)
				.get("id");
	}
	
	private int getSubjectResultId(int subjectId,int studyPlanDetailId) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> idList = jdbc
				.queryForList("SELECT id FROM opuscollege.subjectresult WHERE subjectid = '"
						+ subjectId + "' AND studyplandetailid='" + studyPlanDetailId + "'");
		return idList.toString().equals("[]") ? 0 : (Integer) idList.get(0)
				.get("id");
	}
	
	private int getSecondarySubjectId(String subjectName){
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> result = jdbc.queryForList("SELECT id FROM opuscollege.secondaryschoolsubject WHERE lower(description)='"+subjectName.toLowerCase()+"'");
		if(!result.toString().equals("[]"))
			return Integer.parseInt(result.get(0).get("id").toString());
		return 0;
	}
	
	private int getSecondarySubjectGroupId(int subjectId, int studyGradeTypeId){
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		//List<Map<String, Object>> result = jdbc.queryForList("SELECT id FROM opuscollege.groupedsecondaryschoolsubject WHERE groupedsecondaryschoolsubjectid in (select id from opuscollege.secondaryschoolsubjectgroup where studygradetypeid='"+studyGradeTypeId+"') and secondaryschoolsubjectid='"+ subjectId+"'");
		List<Map<String, Object>> result = jdbc.queryForList("SELECT id FROM opuscollege.groupedsecondaryschoolsubject WHERE secondaryschoolsubjectid='"+ subjectId+"'");
		if(!result.toString().equals("[]"))
			return Integer.parseInt(result.get(0).get("id").toString());
		return 0;
	}
	
	private void addGradedSecondarySchoolSubject(int subjectId, int studyPlanId,int studyGradeTypeId,String grade){
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		int SecondarySchoolSubjectGroupId=getSecondarySubjectGroupId(subjectId, studyGradeTypeId);
		List<Map<String, Object>> result = jdbc.queryForList("SELECT id FROM opuscollege.gradedsecondaryschoolsubject WHERE secondaryschoolsubjectid ='"+subjectId+"' and studyplanid='"+studyPlanId+"'");
		
		if(result.toString().equals("[]")){
			jdbc.execute("INSERT INTO opuscollege.gradedsecondaryschoolsubject (secondaryschoolsubjectid,studyplanid,grade,secondaryschoolsubjectgroupid,active) VALUES" +
					"('"+subjectId+"','"+studyPlanId+"','"+grade+"','"+SecondarySchoolSubjectGroupId+"','Y')");
		}
	}
	
	private String getProgressStatusCode(String comment,int studyGradeTypeId,int cardinalTimeUnitNumber) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		String progressStattus="";
		StudyGradeType studyGradeType=studyManager.findStudyGradeType(studyGradeTypeId);
				
		if (comment!=null){
			comment=comment.toLowerCase();
			if(cardinalTimeUnitNumber==studyGradeType.getMaxNumberOfCardinalTimeUnits() && (comment.equalsIgnoreCase("cp") || comment.equalsIgnoreCase("clear pass") || comment.toLowerCase().indexOf("graduate")!=-1))
				progressStattus="G";
			else if(comment.indexOf("cp")==0 || comment.indexOf("clear")==0)
				progressStattus="CP";
			else if((comment.indexOf("prc")==0 || comment.indexOf("proceed")==0) && (comment.indexOf("rpt")==-1 && comment.indexOf("repeat")==-1))
				progressStattus="P";
			else if((comment.indexOf("prc")==0 || comment.indexOf("proceed")==0) && (comment.indexOf("rpt")!=-1 || comment.indexOf("repeat")!=-1))
				progressStattus="PR";
			else if (comment.indexOf("pt")==0 || comment.indexOf("part")==0)
				progressStattus="PT";
			else if(comment.indexOf("s")==0)
				progressStattus="S";
			else if (comment.indexOf("exp")==0)
				progressStattus="E";
			else if(comment.indexOf("univer")==0)
				progressStattus="EU";
			else if (comment.indexOf("sch")==0)
				progressStattus="ES";
			else if(comment.indexOf("prog")==0)
				progressStattus="EP";
			else if (comment.indexOf("wp")==0 || comment.indexOf(" with permission")==0)
				progressStattus="WP";
		}
			/*	List<Map<String, Object>> result = jdbc
					.queryForList("SELECT code FROM opuscollege.progressstatus WHERE description LIKE '"+progressStattus+"%'");
        MockHttpServletRequest request = new MockHttpServletRequest();

        
		int i = 0;
		// set up new study plan details for each selected subject block and
		// subject
		for (int subjectId : subjectIds) {
			StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
			studyPlanDetail.setActive("Y");
			studyPlanDetail.setStudyPlanId(studyPlanId);
			studyPlanDetail.setSubjectId(subjectId);
			studyPlanDetail
					.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
			String code=progressStattus.equals("")? null : result.toString().equals("[]")?null:result.get(0).get("code").toString();
			
			if(code!=null)
				progressStattus=code;
			studyPlanDetail.setStudyGradeTypeId(studyPlanCTU
					.getStudyGradeTypeId());
			// save the study plan
            studentManager.addStudyPlanDetail(studyPlanDetail, request);
			SubjectResult subjectResult = subjectResults.get(i++);
			subjectResult.setWriteWho("opuscollege");
		
			subjectResult.setStudyPlanDetailId(getStudyPlanDetailId(
					studyPlanId, subjectId));
			subjectResult.setStaffMemberId(getStaffMemberID());
			// save the results
			System.out.println("SubjectId =>> " + subjectId);
			resultManager.addSubjectResult(subjectResult);

		}
		*/
		return progressStattus;
	}
}
