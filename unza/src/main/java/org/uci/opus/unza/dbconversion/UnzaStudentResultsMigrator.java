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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unza.dbconversion;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.uci.opus.college.data.SubjectDaoInterface;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.unza.util.UnzaUtils;
import org.uci.opus.util.OpusMethods;


/**
* @author Katuta G.C. Kaunda
* 
*/
public class UnzaStudentResultsMigrator {
	private static Logger log = Logger.getLogger(UnzaStudentResultsMigrator.class);
	private DataSource opusDataSource;
	@Autowired
	private StudentManagerInterface studentManager;
	@Autowired
	private AddressManagerInterface studentAddressManager;
	@Autowired
	private StudyManagerInterface studyManager;
	@Autowired
	private SubjectManagerInterface subjectManager;
	@Autowired 
	private OrganizationalUnitManagerInterface unitManager;
	@Autowired
	private ResultManagerInterface resultManager;
	@Autowired 
	private UnzaUtils unzaUtils;
	@Autowired 
	private SubjectDaoInterface subjectDao;
	@Autowired private OpusMethods opusMethods;
	
	private Address objAddr1;

    private MockHttpServletRequest request = new MockHttpServletRequest();
	//@Autowired 
	//private MockHttpServletRequest request;
	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}
	
	private List<Map<String, Object>> obtainStudentAcadRecord(String studentId) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsystem.acadyr where studid='"
				+ studentId.toString() + "' AND cmtcode = code order by studid";
		List<Map<String, Object>> academicHistoryList = jdbcTemplate
				.queryForList(query);
		for (Map<String, Object> srsStudentAcadyr : academicHistoryList) {
			log.info(srsStudentAcadyr);
			// String qtaCode=(String)srsStudentAcadyr.get("");
			// convertStudentCourse(srsStudentAcadyr.);
		}
		return academicHistoryList;
	}

	/*
	 * Return quota information for the supplied quotacode and schcode obtained
	 * possibly from acadyrfor an individual student
	 * 
	 * @param str
	 * 
	 * @param str
	 * 
	 * @return List<Map<String,Object>>
	 */
	private Map<String, Object> obtainQuotaInfo(String qtaCode) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsystem.quota where code=" + qtaCode;// +"AND schcode="+schcode;
		List<Map<String, Object>> studentQuotaList = jdbcTemplate
				.queryForList(query);
		Map<String, Object> quota=null;
		for (Map<String, Object> srsStudentQuota : studentQuotaList) {
			log.info(srsStudentQuota);
			quota = srsStudentQuota;
		}
		return quota;
	}

	/*
	 * Return student course information for a student for an academic year
	 * 
	 * @param str
	 * 
	 * @param str
	 * 
	 * @return List<Map<String,Object>>
	 */

	private List<Map<String, Object>> obtainStudentCourseInfo(String studentId,
			String ayear) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsystem.credit where studid="
				+ studentId + "AND ayear=" + ayear;
		List<Map<String, Object>> courseList = jdbcTemplate.queryForList(query);
		for (Map<String, Object> course : courseList) {
			log.info(course);
		}
		return courseList;
	}

	/*
	 * Return student Major information for a student
	 * 
	 * @param str
	 * 
	 * @return List<Map<String,Object>>
	 */

	private List<Map<String, Object>> obtainMajorInfo(String mjr) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsystem.major where code=" + mjr;
		List<Map<String, Object>> majorList = jdbcTemplate.queryForList(query);
		for (Map<String, Object> major : majorList) {
			log.info(major);
		}
		return majorList;
	}
	
	private List<Map<String, Object>> obtainStudentCredit(String studentId,
			String ayear) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsystem.credit,srsystem.course where studid="
				+ studentId + "AND ayear=" + ayear +"AND course=code";
		List<Map<String, Object>> courseList = jdbcTemplate.queryForList(query);
		//Map<String, Object> crse = null;
		for (Map<String, Object> course : courseList) {
			log.info(course);
			//crse = course;
		}
		return courseList;
	}
	public void convertStudentResults() throws SQLException {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		
		//load the student from opus
		//obtain academic record from SRS
		//Create StudyPlan
		//addStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit)
		//Create StudyPlanDetail
		
		/*This is assumed to be the students Major*/
		int newPrimaryStudyId=0;
		/*This will be obtained from quota description*/
		String studyPlanDescription;
		
		/*Load all the students*/
		List< ? extends Student> unzaStudentLst = studentManager.findAllStudents("en_ZM");
		
		/*For each student create StudyPlan/StudyPlans*/
		for (Student opusStudent : unzaStudentLst) {
			log.info(opusStudent);
			/*Stores the current study*/
			String currentStudy="-9900";
			/*Load current students academic records*/
			List<Map<String, Object>> acadyr = obtainStudentAcadRecord(opusStudent.getStudentCode());
			StudyPlan opusStudentStudyPlan= null;
			/* Create a StudyPlan Object for each Study or GradeType the student takes */
			for (Map<String,Object> srsAcadRecord : acadyr){
				int studyPlanId=0;
				int studyPlanCardinalTimeUnitId=0;
				/*Load the Study*/
				//Study oStudy = studyManager.findStudyByCode(srsAcadRecord.get("mjrcode"));
				
				/*TODO:If current major != srsmjr then create a new StudyPlan
				 * otherwise that info is already captured in the StudyPlanCardinalTimeUnit. This Caters
				 * for those students starting as NQ. A studyPlan is created for 1st Year and another for
				 * the major they choose later.*/
				
				String srsmjr = (String)srsAcadRecord.get("mjrcode");
				if( srsmjr != currentStudy){
					opusStudentStudyPlan = new StudyPlan();
					Study opusStudy = new Study();
					
					/*Each StudyPlan captures the academic details of a Student*/
					opusStudentStudyPlan.setStudentId(opusStudent.getStudentId());
					opusStudentStudyPlan.setActive("Y");
					//opusStudentStudyPlan.setStudyPlanDescription("");
					opusStudentStudyPlan.setStudyPlanStatusCode("3");//Approved initial admission
					/*use the mjrcode to set the studyId*/
					opusStudentStudyPlan.setStudyId((Integer) srsAcadRecord.get("mjrcode"));
					opusStudentStudyPlan.setGradeTypeCode((String)srsAcadRecord.get("qtacode"));
					opusStudentStudyPlan.setMinor1Id(0);// This info is currently not captured in srs. a default of 44 is used
						
					
					/*Set the current Study to the iteration majorcode*/
					currentStudy = srsmjr;
					/*Persist the StudyPlan*/
					studentManager.addStudyPlanToStudent(opusStudentStudyPlan, opusMethods.getWriteWho(request));
					
				}
				
				/*Load the just created StudyPlan*/
				StudyPlan unzaStudyPlan;
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("studentId",opusStudent.getStudentId());
				map.put("studyId",(Integer) srsAcadRecord.get("mjrcode"));
				map.put("gradeTypeCode",(String)srsAcadRecord.get("qtacode"));
				map.put("studyPlanDescription",(String)obtainQuotaInfo((String)srsAcadRecord.get("qtacode")).get("title"));
				//unzaStudyPlan = studentManager.findStudyPlanByParams(map);
				
				unzaStudyPlan = studentManager.findStudyPlan(studyPlanId);
				
				/*TODO:Create the StudyPlanCardinalTimeUnits for each record in acadyr 
				 * for now all students are assumed to be semesterized. Change this later
				 * for school of medicine
				 * */
				StudyPlanCardinalTimeUnit opusStudyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
				opusStudyPlanCardinalTimeUnit.setStudyPlanId(unzaStudyPlan.getId());
				opusStudyPlanCardinalTimeUnit.setStudyGradeTypeId(0);//TODO:use lookup to determine studygradetypeId
				opusStudyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(0);//TODO:use the ayear to compute the cardinal time unit #.create utility to do this
				opusStudyPlanCardinalTimeUnit.setProgressStatusCode("Actively Registered");//TODO:use the semester comment to determine whether the semester was completed successfully
				
				/*Persist the StudyPlanCardinalTimeUnit*/
				studyPlanCardinalTimeUnitId = studentManager.addStudyPlanCardinalTimeUnit(opusStudyPlanCardinalTimeUnit, null, request);
				
				/*Create a StudyPlanDetail for this current opusStudyPlanCardinalTimeUnit.If its repeated the list will
				 * contain more objects
				 * TODO:For now an assumption has been made that the student has passed 
				 * without repetition. Determine how to capture which CTUs have been repeated 
				 * from SRS*/
				StudyPlanDetail opusStudyPlanCardinalTimeUnitStudyPlanDetail = new StudyPlanDetail();
				opusStudyPlanCardinalTimeUnitStudyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
				
				/*For the current semester (CTU) get the corresponding records of courses 
				 * from the credit table and populate the subjects list. Each record represents a course*/
				List<Map<String,Object>> sbjlst;
				List<Subject> subjects = new ArrayList<Subject>() ;
				List<SubjectResult> subjectResults= new ArrayList<SubjectResult>(); 
				/*Obtain a students credit for the current academic year/semester (CTU).
				 * Ideally this should return a single record*/
				sbjlst = obtainStudentCredit(opusStudent.getStudentCode(),(String)srsAcadRecord.get("mjrcode"));
				Subject subject;
				/*Loop through the subjects for the student*/
				for(Map<String,Object> creditList :sbjlst){
					/*TODO:use the studyManager to Load the subject based on an id or some other parameters*/
					Map<String,Object> subjectMap = new HashMap<String,Object>();
					subjectMap.put("subjectDescription", (String)creditList.get("description"));
					subjectMap.put("primaryStudyId", 0);
					subjectMap.put("subjectCode", (String)creditList.get("code"));
					/*TODO:Create a utility to compute the academicId from the ayear*/
					subjectMap.put("academicYearId", (String)creditList.get("ayear"));				
					subject = subjectManager.findSubjectByDescriptionStudyCode(subjectMap);
					 ///= new Subject();	
					/*Set the StudyPrimaryId its set to 0 by default*/
					//subject.setPrimaryStudyId(opusStudent.getPrimaryStudyId());	
					/*Add subjects to the list*/
					subjects.add(subject);
					
					/*For each grade for the subject create a SubjectResult*/
					SubjectResult subjectResult = new SubjectResult();
					subjectResult.setActive("Y");
					subjectResult.setSubjectId(subject.getId());
					subjectResult.setEndGrade((String)creditList.get("finalgrade"));//TODO:final grade. confirm
					subjectResult.setMark((String)creditList.get("examgrade"));
					subjectResult.setEndGradeTypeCode((String)creditList.get("defsupp"));//TODO:def/supp.confirm
					//subjectResult.setPassed("");
					
					subjectResults.add(subjectResult);
				}//end of for loop for subject list
				opusStudyPlanCardinalTimeUnitStudyPlanDetail.setSubjects(subjects);
				opusStudyPlanCardinalTimeUnitStudyPlanDetail.setSubjectResults(subjectResults);
				//opusStudyPlanCardinalTimeUnitStudyPlanDetail.setExaminationResults(examinationResults);
				
				/*The CardinalTimeUnitResults is similar to the end of semester comment
				 * There is a list to capture the CardinalTimeUnit result in cases where the CTU
				 * Was failed and has to be repeated. This is the result for the whole semester.*/
				CardinalTimeUnitResult cardinalTimeUnitResult = new CardinalTimeUnitResult();
//				List<CardinalTimeUnitResult> cardinalTimeUnitResults = new ArrayList<CardinalTimeUnitResult>();
				cardinalTimeUnitResult.setCalculationMessage("calculationMessage");//TODO:what is this for
				cardinalTimeUnitResult.setPassed((String)srsAcadRecord.get("text"));//end of semester comment
				cardinalTimeUnitResult.setMark((String)srsAcadRecord.get("text"));//TODO:confirm this
				cardinalTimeUnitResult.setEndGradeComment((String)srsAcadRecord.get("text"));//TODO:confirm this
				cardinalTimeUnitResult.setEndGrade((String)srsAcadRecord.get("text"));//TODO:confirm this
				//cardinalTimeUnitResult.set
				
//				opusStudyPlanCardinalTimeUnit.setCardinalTimeUnitResults(cardinalTimeUnitResults);
				opusStudyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode((String)srsAcadRecord.get("text"));
				
			
			} //end of for loop for student Acadyr record
			
		} //end of for loop for unzaStudentList
		
	} //end of method converStudentResults
	
	/**
	 * Creates a subject study grade type using the credit table from SRS
	 */
	public void createSubjectStudyGradeTypes(){
		
		String studentQuery = "select studentid from srsdatastage.student";
		String studentAcadyr = "select a.studentid, s.uname as uname, s.code as schoolcode,m.title as major_title, c.course as course,";
		       studentAcadyr+= " cs.coursedescription as coursedescription,a.quotacode as quotacode,a.ayear as ayear ";
			   studentAcadyr+= " from srsdatastage.acadyr a,srsdatastage.credit c,srsdatastage.school s, srsdatastage.major m,srsdatastage.course cs";
			   studentAcadyr+= " where a.studentid = c.studentid AND s.code = a.schoolcode AND a.ayear = c.ayear AND cs.coursecode = c.course";
			   studentAcadyr+=" AND a.majorcode = m.majorcode AND a.studentid = ? ";
			   studentAcadyr+=" AND  m.quotacode = a.quotacode AND cs.schoolcode = a.schoolcode ";
		//String stdntAcadyr = "select * from srsdatastage.acadyr c where c.studentid ='99543303'";
		JdbcTemplate students = new JdbcTemplate(opusDataSource);
		JdbcTemplate acadyr = new JdbcTemplate(opusDataSource);
		
		List<Map<String,Object>> studentLst = students.queryForList(studentQuery);
		int totalStudents = studentLst.size();
		int studentRecordNumber =0;
		for(Map<String,Object> student : studentLst){
			log.info("StudentId#:"+student);
			log.info("Outer loop executing");
			//load a student's entire acadyr record
			List<Map<String,Object>> acadrecord = acadyr.queryForList(studentAcadyr,student.get("studentid"));
			//List<Map<String,Object>> acadrecord = students.queryForList("select * from srsdatastage.course");
			
			//loop through the entire academic Reacord for this student creating subjectstudyGradeTypes for each course
			academicrecord:
			for(Map<String,Object> arec :acadrecord  ){
				log.info("This Student Record#:"+studentRecordNumber +" of "+totalStudents);
				log.info("		inner loop executing");
				log.info("StudentId#:"+student);
			 	log.info("arec: "+arec);
			 	
			 	String descr = (String)arec.get("uname");
			 	String schCode =(String)arec.get("schoolcode");
			 	String studyDescr = (String)arec.get("major_title");
			 	String subjectCode = (String)arec.get("course");
			 	String subjectDescription = (String)arec.get("coursedescription");
			 	String gradeTypeCode = (String)arec.get("quotacode");
			 	String ayear = (String)arec.get("ayear");
			 	
			 	//load the organization unit
			 	OrganizationalUnit unit;
			 	HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("organizationalUnitDescription", descr.trim());
				map.put("organizationalUnitCode", schCode);
				unit = unitManager.findOrganizationalUnitByNameAndCode(map);
				
				//load the study
				if(unit != null){
					Study study1;
					HashMap<String, Object> map2 = new HashMap<String, Object>();
					map2.put("studyDescription", studyDescr.trim());
					map2.put("organizationalUnitId", unit.getId());
					map2.put("academicFieldCode", "0");
					
					log.info("^^^^^^^Study Parameters^^^^^^^^");
					log.info("Map2:"+map2);
					
					
					study1=studyManager.findStudyByNameUnit(map2);	
					log.info("^^^^^^^Study Description^^^^^^^^");
					log.info(study1.getId()+" - "+study1.getStudyDescription());
					
					//try{
						//load the study Grade Type
						//if(study1 != null){
							StudyGradeType sgt;
							HashMap<String, Object> map5 = new HashMap<String, Object>();
							map5.put("studyId",study1.getId());
							map5.put("gradeTypeCode",gradeTypeCode);//use quota code		
							map5.put("currentAcademicYearId",getCurrentAcademicYearId(ayear));//TODO:private method that accepts ayear and returns currentAcademicYearId
							map5.put("studyFormCode","0");
							map5.put("studyTimeCode","0");
							map5.put("studyIntensityCode","0");
							
							log.info("^^^^^^^StudyGradeType Parameters^^^^^^^^");
							log.info("Map5:"+map5);
							log.info("Academic Year"+ ayear);
							sgt = studyManager.findStudyGradeTypeByStudyAndGradeType(map5);
							
							log.info("^^^^^^^StudyGradeType Description^^^^^^^^");
							log.info(sgt.getId()+"-"+sgt.getGradeTypeDescription());
							//load the subject
							//if(sgt != null){
								Subject subj;
								HashMap<String, Object> map3 = new HashMap<String, Object>();							
								map3.put("subjectDescription",subjectDescription.trim());
								map3.put("primaryStudyId",study1.getId());
								map3.put("subjectCode",subjectCode.trim());
								map3.put("academicYearId",getCurrentAcademicYearId(ayear));
								
								log.info("^^^^^^^Subject Parameters^^^^^^^^");
								log.info("Map3:"+map3);
								subj = subjectManager.findSubjectByDescriptionStudyCode(map3);
								//subj = subjectManager.findSubjectByDescriptionStudyCode(map3);
								
								if(subj == null){
									//if the subj is null this implies the primaryStudyId is different so just use the code
									HashMap<String, Object> map3_1 = new HashMap<String, Object>();							
									map3_1.put("subjectCode",subjectCode.trim());
									map3_1.put("subjectDescription",subjectDescription.trim());
									map3_1.put("academicYearId",getCurrentAcademicYearId(ayear));
									
								    //subj = subjectManager.findSubjectByCode(map3_1);
									subj = subjectManager.findSubjectByDescriptionStudyCode2(map3_1);
									
									//If subj is null at this point it means the subject was discontinued or doesnt exist anymore
									if(subj == null){
										continue academicrecord;
									}
									log.info("^^^^^^^Subject Parameters^^^^^^^^");
									log.info("Map3_1:"+map3_1);
									log.info("PrimaryStudyId: "+subj.getPrimaryStudyId());
								}
								
								log.info("^^^^^^^Subject Description^^^^^^^^");
								log.info(subj.getId()+"-"+subj.getSubjectDescription());
							 	
							 	//create a subject study grade type
							 	SubjectStudyGradeType subjectStudyGradeType = new SubjectStudyGradeType();
							 	subjectStudyGradeType.setSubjectId(subj.getId());
							 	subjectStudyGradeType.setActive("Y");
							 	subjectStudyGradeType.setCardinalTimeUnitNumber(0);//in which year is course offered?
							 	subjectStudyGradeType.setStudyDescription(study1.getStudyDescription());//use the mjrcode
							 	subjectStudyGradeType.setStudyGradeTypeId(sgt.getId());
							 	
							 	//check if subjectStudyGradeType exists
							 	HashMap<String, Object> map6 = new HashMap<String, Object>();							
								map6.put("subjectId",subj.getId());
								map6.put("studyGradeTypeId",sgt.getId());	
								
								log.info("^^^^^^^StudyGradeType--Exists Parameters^^^^^^^^");
								log.info("Map6:"+map6);
								
								int count=subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map6);
								//int count2=subjectManager
								
								log.info("###################### count[If 0 Subject doesnt Exist]: " + count + " ###############");
								
								if(count==0){	
									
									subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
									log.info("###################### Added Subject Study Grade Type ###############");
								}
								
							//}//subject if block
						//}//study if block
						
					//}catch(Exception e){
					//	log.error(e.getMessage());
					//}
					
				}//end of if statement checking that the current major from students acad exists in opus

			 	
			}//end of Student's academic record for loop
			studentRecordNumber++; //increment the student sentinel
			
		}//end of Student for loop
		
		
	}// end of method createSubjectStudyGradeTypes
	public void createSsgt(){
		/*String ssgtQuery ="select distinct a.quotacode as quota_code,a.majorcode as major_code ,a.schoolcode as school_code," +
				"c.course as course_code,cr.coursedescription as course_descr,m.title as m_title,q.title as q_title,a.quotacode as quota_code,s.uname "+
				" from srsdatastage.acadyr  a "+
				"inner join srsdatastage.credit c on a.ayear =c.ayear  and a.studentid = c.studentid and a.ayear=? "+ 
				"inner join srsdatastage.course cr on c.course = cr.coursecode "+
				"inner join srsdatastage.major m on a.majorcode = m.majorcode " +
				"inner join srsdatastage.quota q on m.quotacode = q.quotacode " +
				"inner join srsdatastage.school s on s.code = q.schoolcode"; 
		*/
		//String ssgtQuery="select uname,major_code,school_code,m_title,course_code,course_descr,quota_code from srsdatastage.ayr_cr_cs_q_m_20101";
		String ssgtQuery="select uname,major_code,school_code,m_title,course_code,course_descr,quota_code,semester,yearofprogram from srsdatastage.ssgt_20041_20102";
		String years = "select distinct ayear from srsdatastage.acadyr order by ayear desc";
		
		JdbcTemplate ssgtTemp = new JdbcTemplate(opusDataSource);
		List<Map<String,Object>> ayears = ssgtTemp.queryForList(years);
		String param="20102";
		log.info("Processing ssgt .....");
		for(Map<String,Object> year: ayears){
			log.info("Current Year:|"+year.get("ayear")+"|");
			param=year.get("ayear").toString().trim();
			List<Map<String,Object>> ssgtLst = ssgtTemp.queryForList(ssgtQuery);
			
			for(Map<String,Object> ssgtMap: ssgtLst){
				//log.info(ssgtMap);
				
				String descr = (String)ssgtMap.get("uname");
			 	String schCode =(String)ssgtMap.get("school_code");
			 	String studyDescr = (String)ssgtMap.get("m_title");
			 	String subjectCode = (String)ssgtMap.get("course_code");
			 	String subjectDescription = (String)ssgtMap.get("course_descr");
			 	String gradeTypeCode = (String)ssgtMap.get("quota_code");
			 	String semester=null;
			 	String yearofprogram=null;
			 	StringBuffer semesterfromcode=new StringBuffer(subjectCode.trim());
			 	
			 	Integer ctu,yop,offset;
			 	ctu=0;
			 	yop=0;
			 	offset=0;
			 	
			 	if(ssgtMap.get("semester") != null && ssgtMap.get("yearofprogram") != null){
			 		
			 		semester =(String)ssgtMap.get("semester");
			 		yearofprogram=(String)ssgtMap.get("yearofprogram");
//			 		try{
			 			offset = Integer.parseInt(semesterfromcode.substring(semesterfromcode.length()-1));
			 			
			 			ctu = Integer.parseInt(semester);
			 			yop = Integer.parseInt(yearofprogram);
			 			// log.info("semester #:"+ctu);
			 			//log.info("Cardinal unit: "+yearofprogram);
			 			//log.info("Semester from code"+offset);
			 			if (offset == 2) {
			 				//semester 2 course
			 				ctu = yop*2+1;
			 				//log.info("semester #2:"+ctu);
			 			}else {
			 				//semester 1 course
			 				ctu = yop*2;
			 				//log.info("semester #1:"+ctu);
			 			}
//			 		}catch(ParseException pe){
			 			//log.warn(pe.getMessage());
//			 		}
			 	}
			 	//String ayear = (String)ssgtMap.get("ayear");
			 	
			 	//load the organization unit
				OrganizationalUnit unit;
			 	HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("organizationalUnitDescription", descr.trim());
				map.put("organizationalUnitCode", schCode);
				
				unit = unitManager.findOrganizationalUnitByNameAndCode(map);
				//load the study
				if(unit != null){
					Study study1;
					HashMap<String, Object> map2 = new HashMap<String, Object>();
					map2.put("studyDescription", studyDescr.trim());
					map2.put("organizationalUnitId", unit.getId());
					map2.put("academicFieldCode", "0");
					
					//log.info("^^^^^^^Study Parameters^^^^^^^^");
					//log.info("Map2:"+map2);
					
					
					study1=studyManager.findStudyByNameUnit(map2);	
					
					if(study1 != null){
						//log.info("^^^^^^^Study Description^^^^^^^^");
						//log.info(study1.getId()+" - "+study1.getStudyDescription());
						
						StudyGradeType sgt;
						HashMap<String, Object> map5 = new HashMap<String, Object>();
						map5.put("studyId",study1.getId());
						map5.put("gradeTypeCode",gradeTypeCode);//use quota code		
						map5.put("currentAcademicYearId",getCurrentAcademicYearId(param));
						map5.put("studyFormCode","1");
						map5.put("studyTimeCode","1");
						map5.put("studyIntensityCode","F");
						
						//log.info("^^^^^^^StudyGradeType Parameters^^^^^^^^");
						//log.info("Map5:"+map5);
						//log.info("Academic Year"+ param);
						sgt = studyManager.findStudyGradeTypeByStudyAndGradeType(map5);
						
						if(sgt != null){
							//log.info("^^^^^^^StudyGradeType Description^^^^^^^^");
							//log.info(sgt.getId()+"-"+sgt.getGradeTypeDescription());
							Subject subj,subj2;
							HashMap<String, Object> map3 = new HashMap<String, Object>();							
							map3.put("subjectDescription",subjectDescription.trim());
							map3.put("primaryStudyId",study1.getId());
							map3.put("subjectCode",subjectCode.trim());
							map3.put("academicYearId",getCurrentAcademicYearId(param));
							
							//log.info("^^^^^^^Subject Parameters^^^^^^^^");
							//log.info("Map3:"+map3);
							subj = subjectManager.findSubjectByDescriptionStudyCode(map3);
							SubjectStudyGradeType subjectStudyGradeType = new SubjectStudyGradeType();
							if(subj == null){
								
								HashMap<String, Object> map3_1 = new HashMap<String, Object>();							
								map3_1.put("subjectCode",subjectCode.trim());
								
								map3_1.put("primaryStudyId",getPrimaryStudy("Dps-"+unit.getOrganizationalUnitDescription().trim()));
								map3_1.put("subjectDescription",subjectDescription.trim());
								map3_1.put("academicYearId",getCurrentAcademicYearId(param));
								//log.info("map3_1"+map3_1);
							    //subj = subjectManager.findSubjectByCode(map3_1);
								subj2 = subjectManager.findSubjectByDescriptionStudyCode(map3_1);
								if(subj2 != null){
									subjectStudyGradeType.setSubjectId(subj2.getId());
									subjectStudyGradeType.setActive("Y");
								 	//subjectStudyGradeType.setCardinalTimeUnitNumber(ctu);//in which year is course offered?
									subjectStudyGradeType.setCardinalTimeUnitNumber(0);//Any
								 	subjectStudyGradeType.setStudyDescription(study1.getStudyDescription());//use the mjrcode
								 	subjectStudyGradeType.setStudyGradeTypeId(sgt.getId());
								 	subjectStudyGradeType.setRigidityTypeCode("3");
								 	subjectStudyGradeType.setImportanceTypeCode("1");
								 	
								 	HashMap hMap = new HashMap();
								 	hMap.put("subjectId", subj2.getId());
								 	hMap.put("studyGradeTypeId", sgt.getId());
								 	
								 	
								 	int existsSsgt = 0;
								 	existsSsgt= subjectDao.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(hMap);
								 	
								 	if (existsSsgt == 0){
								 		subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
										//log.info("###################### Added Subject Study Grade Type  k###############");
								 	}
								}
								
							}else{
								subjectStudyGradeType.setSubjectId(subj.getId());
								subjectStudyGradeType.setActive("Y");
							 	subjectStudyGradeType.setCardinalTimeUnitNumber(ctu);//in which year is course offered?
							 	subjectStudyGradeType.setStudyDescription(study1.getStudyDescription());//use the mjrcode
							 	subjectStudyGradeType.setStudyGradeTypeId(sgt.getId());
							 	subjectStudyGradeType.setRigidityTypeCode("3");
							 	subjectStudyGradeType.setImportanceTypeCode("1");
							 	
							 	HashMap hMap2 = new HashMap();
							 	hMap2.put("subjectId", subj.getId());
							 	hMap2.put("studyGradeTypeId", sgt.getId());
							 	
							 	int existsSsgt = 0;
							 	existsSsgt= subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(hMap2);
							 	
							 	
							 	if (existsSsgt == 0){
							 		subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
									//log.info("###################### Added Subject Study Grade Type  n###############");
							 	}
							}
							
							//create a subject study grade type
						 	//SubjectStudyGradeType subjectStudyGradeType = new SubjectStudyGradeType();
						 	//subjectStudyGradeType.setSubjectId(subj.getId());
						 	
						}
					}
				}
				
				
			}

		}
		log.info("finished Processing ssgt .....");
		
	}
	private Integer getPrimaryStudy(String descr) {
		String query="select id from opuscollege.study where studyDescription =?";
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		return new Integer(jdbcTemplate.queryForInt(query,descr));
	}

	public Integer getCurrentAcademicYearId(String ayear){
		Integer academicYear = new Integer(ayear);
		Integer param = academicYear/10;
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select id from opuscollege.academicyear where description = ?";
		List<Map<String, Object>> academicYearList = jdbcTemplate.queryForList(query,param.toString());
		
		for (Map<String,Object> a:academicYearList ){
			//log.info("The AcademicYearId:"+a);
			return (Integer)a.get("id");
		}
		//log.info(null);
		return null;
	}
	
	/**Create Student Study Plans*/
	public void createStudentStudyPlan(){
        
        
        

        String studentIdSql = "SELECT studentid FROM srsdatastage.student where studentid like '2%'";
		/*String studentSubjects = "select acadyr.*,credit.*,course.coursedescription from srsdatastage.acadyr "
		                             +"inner join srsdatastage.credit on credit.studentid = acadyr.studentid "
		                             +"inner join srsdatastage.course on credit.course = course.coursecode"
		                             +" AND credit.ayear = acadyr.ayear "
		                             +" AND acadyr.studentid =? "
		                             +" AND credit.ayear = ? AND acadyr.ayear > '20032'";*/
        String studentSubjects = "select distinct acadyr.*,credit.*,course.coursedescription from srsdatastage.acadyr "
                +"inner join srsdatastage.credit on credit.studentid = acadyr.studentid "
                +"inner join srsdatastage.course on credit.course = course.coursecode"
                +" AND credit.ayear = acadyr.ayear "
                +" AND acadyr.studentid =20000049 "
                +" AND credit.ayear = ? AND acadyr.ayear > '20032'";
		String studentEntireAcadRec ="select * from srsdatastage.acadyr where studentid = ? AND acadyr.ayear > '20032'";
		
		JdbcTemplate students = new JdbcTemplate(opusDataSource);
		JdbcTemplate entireAcadyrec = new JdbcTemplate(opusDataSource);
		JdbcTemplate entireSubjects = new JdbcTemplate(opusDataSource);
		
		/**Obtain a list of students Creating a StudyPlan for each of them*/
		List<Map<String,Object>> studentIds = students.queryForList(studentIdSql);
		
		for(Map<String,Object> stdId : studentIds){
			
			//Track the current major code. If It changes create a new StudyPlan
			String startingMajor = "0";
			
			
			
			List<Map<String,Object>> academicRecord = entireAcadyrec.queryForList(studentEntireAcadRec,stdId.get("studentid"));
			int studyPlanCardinalTimeUnitId=0;
			int ayear = 0;
			int yrofpgm =0;
			int studyPlanId =0;
			String studyId ="0";
			String gradeTypeCode = "0";
			Integer stdid=null;
			stdid=unzaUtils.getStudentId(stdId.get("studentid").toString());
			for(Map<String,Object> rec:academicRecord ){
				
				/** Create a StudyPlan Object. if the startingMajor is different from the currentMajor create a new Plan else plan already created*/
				String currentMajor = (String)rec.get("majorcode");
				
				gradeTypeCode =unzaUtils.getGradeTypeCode(rec.get("studentid").toString(),rec.get("ayear").toString());
				studyId =unzaUtils.getStudyId(rec.get("studentid").toString(),rec.get("ayear").toString()).toString();
				if(!startingMajor.equals(currentMajor) && studyId != null){
					
					
					if(stdid != null){
						StudyPlan studentStudyPlan = new StudyPlan();
						studentStudyPlan.setActive("Y");
						//studentStudyPlan.setStudentId(Integer.parseInt(stdId.get("studentid").toString()));//use function to return studentid based on code
						studentStudyPlan.setStudentId(stdid);
						studentStudyPlan.setStudyPlanDescription(unzaUtils.getStudyPlanDescription(rec.get("studentid").toString(),rec.get("ayear").toString()));//quota the student is studying
						studentStudyPlan.setStudyId(Integer.parseInt(studyId));//use the utility function
						studentStudyPlan.setGradeTypeCode(gradeTypeCode);//quota code use the utility function
						studentStudyPlan.setMinor1Id(0);
						studentStudyPlan.setApplicationNumber(0);
						log.info("Study Plan Description: "+unzaUtils.getStudyPlanDescription(rec.get("studentid").toString(),rec.get("ayear").toString()));
						log.info("Study ID: "+unzaUtils.getStudyId(rec.get("studentid").toString(),rec.get("ayear").toString()));
						log.info("Grade Type Code: "+unzaUtils.getGradeTypeCode(rec.get("studentid").toString(),rec.get("ayear").toString()));
						log.info("The StudyGradeType is: "+unzaUtils.getStudyGradeTypeId(studyId, gradeTypeCode, rec.get("ayear").toString(), "F"));
						
						studyPlanId = studentManager.addStudyPlanToStudent(studentStudyPlan, opusMethods.getWriteWho(request));
						startingMajor = currentMajor;
					}
					
				}
				
				
				
				if(stdid != null){
					log.info("StudyPlan Id:"+studyPlanId );
					
					log.info("The Academic Record:"+ rec);
					/** CardinalTime Unit*/
					StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
					studyPlanCardinalTimeUnit.setActive("Y");
					ayear = Integer.parseInt(rec.get("ayear").toString());
					yrofpgm = Integer.parseInt(rec.get("yearofprogram").toString());
					//studyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(CTUComputer.computeCTU2(yrofpgm, ayear));//obtain this from ayear
					studyPlanCardinalTimeUnit.setStudyPlanId(studyPlanId);
					studyPlanCardinalTimeUnit.setTuitionWaiver("0");
					studyPlanCardinalTimeUnit.setStudyGradeTypeId(unzaUtils.getStudyGradeTypeId(studyId, gradeTypeCode, rec.get("ayear").toString(), "F"));//load this
					//request.setAttribute("writeWho", "Data Migrator");
					MockHttpSession session = new MockHttpSession();
					request.setSession(session);
					RequestAttributes attrs = RequestContextHolder.getRequestAttributes();
			    	if (attrs == null)
			    	{
			    	    log.info("Creating new ServletRequestAttributes");
			    	    attrs = new ServletRequestAttributes(request);
			    	    
			    	    attrs.setAttribute("writeWho", "Data Migration", RequestAttributes.SCOPE_REQUEST);

			    	    RequestContextHolder.setRequestAttributes(attrs);
			    	}
			    	log.info(attrs);
			        
					studyPlanCardinalTimeUnitId = studentManager.addStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, null, request);
					
					//query all subjects for this academic year
					List <Map<String,Object>> subjectList = entireSubjects.queryForList(studentSubjects,stdId.get("studentid"),rec.get("ayear"));
					List<Subject> subjects = new ArrayList<Subject>();
					List<SubjectResult> subjectResults = new ArrayList<SubjectResult>();
					StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
					int studyPlanDetailId =0;
					int subjectId =0;
					int studyGradeTypeId =0;
					/**Create a studyplandetail for each subject*/
					for(Map<String,Object> subj: subjectList){
						
						studyPlanDetail.setActive("Y");
						studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
						studyPlanDetail.setStudyPlanId(studyPlanId);
						subjectId = unzaUtils.getSubjectId(subj.get("course").toString(), rec.get("ayear").toString(),subj.get("coursedescription").toString());
						studyGradeTypeId=unzaUtils.getStudyGradeTypeId(studyId, gradeTypeCode, rec.get("ayear").toString(), "F");
						studyPlanDetail.setSubjectId(subjectId);//find subjId using code and ayear
						studyPlanDetail.setStudyGradeTypeId(studyGradeTypeId);
						log.info("!!!!OPus studyGradeTypeId:"+studyGradeTypeId+"DB SubjectID: "+subjectId +"!!!Description: "+subj.get("coursedescription"));
						log.info("subject:"+subj);
						
						studyPlanDetailId = studentManager.addStudyPlanDetail(studyPlanDetail, request);
						
						/**Subjects in the Cardinal Time Unit*/
						
						SubjectResult subjectResult = new SubjectResult();
				        subjectResult.setSubjectId(subjectId);
				        subjectResult.setStudyPlanDetailId(studyPlanDetailId);
				       // subjectResult.setSubjectResultDate(DateUtil.parseIsoDate("2010-05-24"));
				        subjectResult.setStaffMemberId(157);//create and use a default staff member
				        subjectResult.setActive("Y");
				        subjectResult.setPassed("Y");
				        //subjectResult.setEndGradeComment("passed");
				        subjectResult.setEndGradeComment((String)subj.get("finalgrade"));//create map to determine endgrade comment
				        //subjectResult.setMark("12.99");
				        subjectResult.setMark((String)subj.get("finalgrade"));//use map to determine actual mark by mapping to the grade given
				        subjectResult.setWriteWho("opuscollege");
				        int subjectResultId =0;
				        if (subjectId !=0)
				        	subjectResultId = resultManager.addSubjectResult(subjectResult, request);
				        
				        log.info("The subject result ID is:"+subjectResultId);
				        
				        //resultDao.addSubjectResult(subjectResult);
						//subject.setSubjectCode((String)subj.get("course"));
						//subjects.add(subject);
						
						
						
						
						
						
						
						
						
					}
					
					//studyPlanCardinalTimeUnit.setStudyPlanDetails(null);
					//studyPlanCardinalTimeUnit.setSubjects(subjects);
					//studyPlanCardinalTimeUnit.setSubjectResults(subjectResults);
					//studyPlanCardinalTimeUnit.setCardinalTimeUnitResults(cardinalTimeUnitResults);
					
					
					log.info("CardinalTimeUnitId: "+studyPlanCardinalTimeUnitId);
				}
				
			}//for over students acadyear record
			
			
			
		}//for loop over student list
		
		
		
		
		
		
		
		
		//load the study using the majr code
		//load the studyGradeType using the quotacode
	}//end of method create student study plan
	
	public void createEndgrades(){
		//load the codes of grade types without an end grade
		String gradetypesWithoutEndgrades ="select code from opuscollege.gradetype where code not in (select endgradetypecode from opuscollege.endgrade)";
		
	}
	public void createStudyPlanVersion2(){
		String studentIdSql = "SELECT distinct studentid FROM srsdatastage.student where studentid like '2%'";
		String studentSubjects = "select distinct acadyr.*,credit.*,course.coursedescription from srsdatastage.acadyr "
	                +"inner join srsdatastage.credit on credit.studentid = acadyr.studentid "
	                +"inner join srsdatastage.course on credit.course = course.coursecode"
	                +" AND credit.ayear = acadyr.ayear "
	                +" AND acadyr.studentid =20000049 "
	               // +" AND credit.ayear = ? " 
	                +"AND acadyr.ayear > '20032'";
		String studentEntireAcadRec ="select distinct * from srsdatastage.acadyr where studentid = ? AND acadyr.ayear > '20032' order by acadyr.ayear";
		
		JdbcTemplate students = new JdbcTemplate(opusDataSource);
		JdbcTemplate entireAcadyrec = new JdbcTemplate(opusDataSource);
		JdbcTemplate entireSubjects = new JdbcTemplate(opusDataSource);
		
		/**Obtain a list of students Creating a StudyPlan for each of them*/
		List<Map<String,Object>> studentIds = students.queryForList(studentIdSql);
		
		for(Map<String,Object> stdId : studentIds){
			//use a Map to track the individual Majors
			HashMap<String,String> processedMajorMap = new  HashMap<String,String>();
			HashMap<String,String> processedQuotaMap = new  HashMap<String,String>();
			List<Map<String,Object>> academicRecord 
			= entireAcadyrec.queryForList(studentEntireAcadRec,stdId.get("studentid"));
			
			for(Map<String,Object> rec:academicRecord ){
				//create a new studyplan if the initial major changes
				if (processedMajorMap.containsKey((String)rec.get("majorcode"))){
					//create studyplancardinaltime unit entry
				}else{
					//create a new studyplan
					processedMajorMap.put((String)rec.get("majorcode"),(String)rec.get("studentid"));
					
					//get all quota associated with student
					List<Map<String,Object> > gt =unzaUtils.getGradeTypeCode2(rec.get("studentid").toString(),rec.get("ayear").toString());
					for(Map<String,Object> g:gt){
						
						//check whether quota has been processed for this student 
						if(processedQuotaMap.containsKey((String)g.get("quotacode"))){
							//do nothing
						}else{
							//create a new studyplan
							processedQuotaMap.put((String)g.get("quotacode"),(String) rec.get("studentid"));
						}
						
					}
					//studyId =unzaUtils.getStudyId(rec.get("studentid").toString(),rec.get("ayear").toString()).toString();
					processedMajorMap.put((String)rec.get("majorcode"), (String)stdId.get("studentid"));
				}
				
				
				//create a new studyplan if the initial quota changes
			}
			
		}// end of student loop
	}//end of create studyplan version2
	public void createStudyplanForStudent(){
		//TODO: Step 1 - Load Student one Student's Details From SRS
		//TODO: Step 2 - Create a Student - Use FastInputStudentController as guide
		//TODO: Step 3 - Create a Studyplan
	}

} //end of UnzaStudentResultsMigrator
