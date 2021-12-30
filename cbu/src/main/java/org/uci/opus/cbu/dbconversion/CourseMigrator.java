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
package org.uci.opus.cbu.dbconversion;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.data.CourseDao;
import org.uci.opus.cbu.data.ProgrammeDao;
import org.uci.opus.cbu.domain.Course;
import org.uci.opus.cbu.domain.Programme;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;

public class CourseMigrator {

	private static Logger log = LoggerFactory.getLogger(CourseMigrator.class);
	
	@Autowired private DataSource dataSource;
	@Autowired private SubjectManagerInterface subjectManager;
	@Autowired StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private ProgrammeDao programmeDao;
	@Autowired private CourseDao courseDao;
	
	public void convertCourses() throws SQLException {
		dbUtil.truncateTable("subject");
		dbUtil.truncateTable("subjectstudygradetype");
		
		// Retrieve Programmes from CBUSchoolProgrammes Tables
		List<Course> courses=null;
		List<Programme> programmes=programmeDao.getProgrammes();
		
		// iterate through a collection of a List object
		for(Programme programme:programmes){
			courses=courseDao.getCourses(programme.getCode());
			if(courses!=null){
				for (Course course : courses) {
					if(log.isInfoEnabled())
						log.info(course.toString());
					
					Calendar calendar=Calendar.getInstance();
					calendar.setTime(programmeDao.getProgrammeStartDate(programme.getCode(),programmeDao.getStudyDescription(programme.getName())));
					int startYear=calendar.get(Calendar.YEAR);
					
					for (;startYear<=2012;startYear++) {
						int year=startYear;
						//only add the courses to the programmes which are currently being offered.
						//other courses will be added when adding the results for the students
						if(programmeDao.getProgramme(course.getProgramme().getCode(),year).getYearStopped()==0)
							addSubject(course.getProgramme().getCode(), course.getCode(), course.getName(),course.getYearOfStudy(), year, course.isActive()?"Y":"N");
					}
				}
			}
		}
	}

	public Subject getSubject(String code, String description,	int academicYearId) {
		Subject subject = null;
		JdbcTemplate opusTemplate = new JdbcTemplate(dataSource);
		String sql="SELECT id FROM opuscollege.subject WHERE subjectcode='"
				+ code.trim() + "' AND subjectdescription='"
				+ description.trim() + "' AND currentacademicyearid='"+ academicYearId + "'";
		List<Map<String, Object>> lstSubject = opusTemplate.queryForList(sql);
		if (!lstSubject.toString().equals("[]")) {
			subject = subjectManager.findSubject(Integer.parseInt(lstSubject
					.get(0).get("id").toString()));
		}
		
		return subject;
	}

	
	public int getStudyId(String studyDescription,int organizationalUnitId) {
		JdbcTemplate opusJdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> idList = opusJdbc
				.queryForList("SELECT id FROM opuscollege.study WHERE studydescription = '"
						+ studyDescription + "' AND organizationalunitid='"+organizationalUnitId+"'");
		int studyId = 0;
		if (!idList.toString().equals("[]"))
			studyId = Integer.valueOf(idList.get(0).get("id").toString());
		return studyId;
	}
	
	public void addSubject(String programmeCode,String courseCode,String courseName,int cardinalTimeUnitNumber,int year,String active){
		int academicYearId=getAcademicYearId(String.valueOf(year));
		Programme programme=programmeDao.getProgramme(programmeCode,year);
		int organizationalUnitId=getOrganizationalUnitId(programme.getDepartment().getCode());
		
		String studyDescription=programmeDao.getStudyDescription(programme.getName());
		String studyTimeCode=getStudyTimeCode(programmeDao.getStudyTimeDescription(programme.getName()));
		String studyFormCode=getStudyFormCode(programmeDao.getStudyFormDescription(programme.getName()));
		String gradeTypeCode=programmeDao.getGradeTypeCode(programme.getName());
		int studyId=getStudyId(studyDescription, organizationalUnitId);
	
		int studyGradeTypeId=getStudyGradeTypeId(studyId, gradeTypeCode, academicYearId, studyFormCode, studyTimeCode);
		
		Subject subject = getSubject(courseCode, courseName, academicYearId);
		if (subject == null)
			subject = new Subject();
		
		subject.setCurrentAcademicYearId(academicYearId);
		subject.setSubjectCode(courseCode);
		subject.setSubjectDescription(courseName);
		subject.setPrimaryStudyId(getStudyId(studyDescription,organizationalUnitId));
		subject.setStudyTimeCode(studyTimeCode);
		subject.setActive(active);
		subject.setExamTypeCode("2"); //2 for multiple event
//		subject.setCreditAmount(1.0);
        subject.setCreditAmount(BigDecimal.ONE);
		
		if(subject.getId()==0){
			subjectManager.addSubject(subject);
			subject = getSubject(courseCode, courseName, academicYearId);
		}else{
			subjectManager.updateSubject(subject);
		}
		
		
		if(studyGradeTypeId!=0)
			assignCoursetoProgram(studyGradeTypeId, subject, studyTimeCode, cardinalTimeUnitNumber, active);
	}
	
	/**
	 * This method is used to retrieve an organizationalUnitId using a departmentCode
	 * @param departmentCode
	 * @return returns 0 if not found
	 */
	private int getOrganizationalUnitId(String departmentCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstDepartment = opusTemplate
				.queryForList("SELECT * FROM opuscollege.organizationalunit where organizationalunitcode='"+ departmentCode+"'");
		if(lstDepartment.size() > 0){
			return Integer.parseInt(lstDepartment.get(0).get("id").toString());
		}
		return 0;
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
	/**
	 * This method is used to retrieve the studyFormCode using the studyDescription. StudyFormCode are in the form of D for Day, E for Evening, etc
	 * @param studyFormDescription
	 * @return
	 */
	private String getStudyFormCode(String studyFormDescription) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyFormObject = opus.queryForList("SELECT code FROM opuscollege.studyform WHERE description='" + studyFormDescription + "'");
		return studyFormObject.toString().equals("[]")?"D":studyFormObject.get(0).get("code").toString();
	}
	
	private void assignCoursetoProgram(int studyGradeTypeId, Subject subject,String studyTimeCode,
			int yearOfStudy, String active) {
		JdbcTemplate opusJdbc = new JdbcTemplate(dataSource);
		
		StudyGradeType studyGradeType=studyManager.findStudyGradeType(studyGradeTypeId);
		List<Map<String, Object>> subjectStudyTypeList = opusJdbc
				.queryForList("SELECT id FROM opuscollege.subjectstudygradetype WHERE studygradetypeid ='"
						+ studyGradeTypeId
						+ "' AND subjectid='"
						+ subject.getId() + "'");
	
		if (subjectStudyTypeList.toString().equals("[]")) {
			SubjectStudyGradeType subjectStudyGradeType = new SubjectStudyGradeType();
			//subjectStudyGradeType.setStudyGradeType(studyGradeType);
			subjectStudyGradeType.setSubjectId(subject.getId());
			subjectStudyGradeType.setStudyGradeTypeId(studyGradeTypeId);
			subjectStudyGradeType.setActive(active);
			subjectStudyGradeType.setCardinalTimeUnitNumber(yearOfStudy);
			// Set to compulsory as the default value
			subjectStudyGradeType.setRigidityTypeCode("1");
			
			if(log.isInfoEnabled())
				log.info(subjectStudyGradeType.toString());
			subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
				
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("studyGradeTypeId", studyGradeTypeId);
			map.put("subjectId", subject.getId());
			map.put("preferredLanguage", "en");
			
			@SuppressWarnings("unchecked")
			List<SubjectStudyGradeType> subjectStudyGradeTypeList = (List<SubjectStudyGradeType>) subjectManager.findSubjectStudyGradeTypes(map);
						
			SubjectStudyGradeType subjectStudyGradeType = subjectStudyGradeTypeList.get(0);
			
			subjectStudyGradeType.setStudyGradeType(studyGradeType);
			subjectStudyGradeType.setActive(active);
			subjectManager.updateSubjectStudyGradeType(subjectStudyGradeType);
			if(log.isInfoEnabled())
				log.info("update " + subjectStudyGradeType);
			
		}
	}
	
	/**
	 * This method is used to retrieve a studyGradeTypeId from opusCollege database
	 * @param studyId
	 * @param gradeTypeCode
	 * @param currentAcademicYearId
	 * @param studyFormCode
	 * @param studyTimeCode
	 * @return
	 */
	private int getStudyGradeTypeId(int studyId,String gradeTypeCode,int currentAcademicYearId,String studyFormCode,String studyTimeCode) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> result = jdbcTemplate.queryForList("SELECT * FROM opuscollege.studygradetype WHERE studyid='"+ studyId + "' AND gradetypecode='"+gradeTypeCode+"' AND currentacademicyearid='"+currentAcademicYearId+"' AND studyformcode='"+studyFormCode+"' AND studytimecode='"+studyTimeCode+"'");

		if (result.toString().equals("[]")) {
			return 0;
		}
		return Integer.valueOf(result.get(0).get("id").toString());
	}
	
	private int getAcademicYearId(String academicYearDescription) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstAcademicYear = jdbc
				.queryForList("SELECT id FROM opuscollege.academicyear WHERE description='"
						+ academicYearDescription + "'");
		return lstAcademicYear.toString().equals("[]") ? 0 : Integer
				.valueOf(lstAcademicYear.get(0).get("id").toString());
	}
}
