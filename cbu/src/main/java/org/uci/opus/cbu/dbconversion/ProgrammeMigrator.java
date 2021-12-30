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

import java.sql.Date;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.data.ProgrammeDao;
import org.uci.opus.cbu.domain.Programme;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;

public class ProgrammeMigrator {

	private static Logger log = LoggerFactory.getLogger(ProgrammeMigrator.class);
	@Autowired private DataSource dataSource;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private ProgrammeDao programmeDao;
	
	/**
	 * This method is used to convert Programmmes data from STURECO Database to OpusCollege Database
	 * @throws SQLException
	 */
	public void convertProgrammes() throws SQLException {
		
		dbUtil.truncateTable("study");
		dbUtil.truncateTable("studygradetype");
		dbUtil.truncateTable("cardinaltimeunitstudygradetype");
		
		//add academic years
		populateAcademicYears();
		List<Programme> programmes=programmeDao.getProgrammes();
		// iterate through a collection of a List object
		for (Programme programme : programmes) {
			
			String cardinalTimeUnit = getCardinalTimeUnit(programme.getCode());
			String studyDescription=programmeDao.getStudyDescription(programme.getName());
			String studyTimeDescription=programmeDao.getStudyTimeDescription(programme.getName());
			String studyFormDescription=programmeDao.getStudyFormDescription(programme.getName());
			String gradeTypeCode=programmeDao.getGradeTypeCode(programme.getName());
			String gradeTypeDescription=programmeDao.getGradeTypeDescription(programme.getName());
			String studyTimeCode=getStudyTimeCode(studyTimeDescription);
			String studyFormCode=getStudyFormCode(studyFormDescription);
			String gradeTypeTitle=programmeDao.getGradeTypeTitle(gradeTypeDescription);
			
			Study study = new Study();
			study.setActive("Y");
			study.setStudyDescription(programmeDao.getStudyDescription(programme.getName()));
			//set default value for academicfield equal to 0
			study.setAcademicFieldCode("0");
			study.setOrganizationalUnitId(getOrganizationalUnitId(programme.getDepartment().getCode()));
			
			if (!checkIfStudyExist(study.getStudyDescription(),study.getOrganizationalUnitId())){
				studyManager.addStudy(study);
			}else{
				study.setId(getStudyID(study.getStudyDescription(),study.getOrganizationalUnitId()));
				studyManager.updateStudy(study);
			}
			
			if (programmeDao.getGradeTypeDescription(programme.getName()) != "") {
				addGradeType(gradeTypeCode, gradeTypeDescription,gradeTypeTitle);
				addStudyTime(studyTimeCode, studyTimeDescription);
				addStudyGradeTypes(programme.getCode(),studyDescription,gradeTypeCode, programme.getProgrammeDuration(), studyTimeCode,studyFormCode,cardinalTimeUnit,study.getOrganizationalUnitId(),programme.getYearStopped());
			}
		}
		
	}
	
	/**
	 * This method is used to add a single studygradetype.
	 * 
	 * @param programmeCode
	 * @param studyDescription
	 * @param gradeTypeCode
	 * @param studyDuration
	 * @param studyTime
	 * @param studyFormCode
	 * @param cardinalTimeUnit
	 * @param organizationalUnitId
	 * @param academicYearId
	 */
	public void addStudyGradeType(String programmeCode,String studyDescription,String gradeTypeCode, int studyDuration, String studyTime,String studyFormCode,String cardinalTimeUnit,int organizationalUnitId,int academicYearId) {
		JdbcTemplate opusTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyMap = opusTemplate.queryForList("SELECT * FROM opuscollege.study WHERE studydescription='"+ studyDescription + "' AND organizationalunitid='"+organizationalUnitId+"'");
		List<Map<String, Object>> cardinalTimeUnitList = opusTemplate.queryForList("SELECT * FROM opuscollege.cardinaltimeunit WHERE description='"	+ cardinalTimeUnit.toLowerCase() + "' AND lang='en'");
			
		if (!studyMap.toString().equals("[]")) {
			//Create a new studyGradeType object
			StudyGradeType studyGradeType = new StudyGradeType();
			//Set the values to the studyGradeType object
			studyGradeType.setStudyId(Integer.parseInt(studyMap.get(0).get("id").toString()));
			studyGradeType.setGradeTypeCode(gradeTypeCode);
			studyGradeType.setStudyTimeCode(studyTime);
			studyGradeType.setNumberOfCardinalTimeUnits(studyDuration);
			studyGradeType.setMaxNumberOfCardinalTimeUnits(studyDuration);
			studyGradeType.setCardinalTimeUnitCode(cardinalTimeUnitList.get(0).get("code").toString());
			studyGradeType.setActive("Y");
			studyGradeType.setStudyFormCode(studyFormCode);
			studyGradeType.setStudyIntensityCode("F");
	
			//create studyGradeTypes for all academicYears
			Calendar calendar=Calendar.getInstance();
			calendar.setTime(programmeDao.getProgrammeStartDate(programmeCode,studyDescription));
			
			studyGradeType.setCurrentAcademicYearId(academicYearId);
		
			int studyGradeTypeId=0;
			//add a studygradetype if only it does not exist otherwise just do the update
			if(!studyGradeTypeExist(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode())){
				//addStudyGradeType(studyGradeType);
				studyManager.addStudyGradeType(studyGradeType);
				studyGradeTypeId=getStudyGradeTypeId(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode());
				addCardinalTimeUnitsForStudyGradeType(studyGradeTypeId, studyGradeType.getMaxNumberOfCardinalTimeUnits());
			}else{
				studyGradeTypeId=getStudyGradeTypeId(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode());
				studyGradeType.setId(studyGradeTypeId);
				studyManager.updateStudyGradeType(studyGradeType);
				addCardinalTimeUnitsForStudyGradeType(studyGradeTypeId, studyGradeType.getMaxNumberOfCardinalTimeUnits());
			}
		}
	}
	/**
	 * This method is used to add a studyGradeTypes to opuscollege database
	 * 
	 * @param studyDescription
	 * @param gradeTypeDescription
	 * @param studyDuration
	 * @param studyTime
	 * @param studyFormCode
	 * @param cardinalTimeUnit
	 */
	private void addStudyGradeTypes(String programmeCode,String studyDescription,String gradeTypeCode, int studyDuration, String studyTime,String studyFormCode,String cardinalTimeUnit,int organizationalUnitId,int stopYear) {
		JdbcTemplate opusTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyMap = opusTemplate.queryForList("SELECT * FROM opuscollege.study WHERE studydescription='"+ studyDescription + "' AND organizationalunitid='"+organizationalUnitId+"'");
		List<Map<String, Object>> cardinalTimeUnitList = opusTemplate.queryForList("SELECT * FROM opuscollege.cardinaltimeunit WHERE description='"	+ cardinalTimeUnit.toLowerCase() + "' AND lang='en'");
			
		if (!studyMap.toString().equals("[]")) {
			//Create a new studyGradeType object
			StudyGradeType studyGradeType = new StudyGradeType();
			//Set the values to the studyGradeType object
			studyGradeType.setStudyId(Integer.parseInt(studyMap.get(0).get("id").toString()));
			studyGradeType.setGradeTypeCode(gradeTypeCode);
			studyGradeType.setStudyTimeCode(studyTime);
			studyGradeType.setNumberOfCardinalTimeUnits(studyDuration);
			studyGradeType.setMaxNumberOfCardinalTimeUnits(studyDuration);
			studyGradeType.setCardinalTimeUnitCode(cardinalTimeUnitList.get(0).get("code").toString());
			studyGradeType.setActive("Y");
			studyGradeType.setStudyFormCode(studyFormCode);
			studyGradeType.setStudyIntensityCode("F");
	
			//create studyGradeTypes for all academicYears
			Calendar calendar=Calendar.getInstance();
			calendar.setTime(programmeDao.getProgrammeStartDate(programmeCode,studyDescription));
			int startYear=calendar.get(Calendar.YEAR);
			stopYear=stopYear==0?Calendar.getInstance().get(Calendar.YEAR):stopYear;
			
			for (;startYear<=stopYear;startYear++) {
				int academicYearId=getAcademicYearId(String.valueOf(startYear));
				studyGradeType.setCurrentAcademicYearId(academicYearId);
		
				int studyGradeTypeId=0;
				//add a studygradetype if only it does not exist otherwise just do the update
				if(!studyGradeTypeExist(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode())){
					//addStudyGradeType(studyGradeType);
					studyManager.addStudyGradeType(studyGradeType);
					studyGradeTypeId=getStudyGradeTypeId(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode());
					addCardinalTimeUnitsForStudyGradeType(studyGradeTypeId, studyGradeType.getMaxNumberOfCardinalTimeUnits());
				}else{
					studyGradeTypeId=getStudyGradeTypeId(studyGradeType.getStudyId(), studyGradeType.getGradeTypeCode(), studyGradeType.getCurrentAcademicYearId(),studyGradeType.getStudyFormCode(),studyGradeType.getStudyTimeCode());
					studyGradeType.setId(studyGradeTypeId);
					studyManager.updateStudyGradeType(studyGradeType);
					addCardinalTimeUnitsForStudyGradeType(studyGradeTypeId, studyGradeType.getMaxNumberOfCardinalTimeUnits());
				}
			}
			
			if(log.isInfoEnabled())
				log.info(studyGradeType.toString());
		}
	}

	/**
	 * This method is used to retrieve an organizationalUnitId using a departmentCode
	 * @param departmentCode
	 * @return returns 0 if not found
	 */
	public int getOrganizationalUnitId(String departmentCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstDepartment = opusTemplate
				.queryForList("SELECT * FROM opuscollege.organizationalunit where organizationalunitcode='"+ departmentCode+"'");
		if(lstDepartment.size() > 0){
			return Integer.parseInt(lstDepartment.get(0).get("id").toString());
		}
		return 0;
	}
	
	/**
	 * This method is used to create the academicYears
	 */
	private void populateAcademicYears() {
		int currentYear=Calendar.getInstance().get(Calendar.YEAR);
		int nextAcademicYearId = 0;

		//dbUtil.truncateTable("academicyear");
		//delete academicyears above 2012
		//deleteAcademicYears();
		
		for (int year = currentYear; year >= 1987; year--) {
			if(!checkIfAcademicYearExist(String.valueOf(year))){
				AcademicYear ay = new AcademicYear();
				ay.setDescription(String.valueOf(year));
				ay.setEndDate(Date.valueOf(year + "-12-31"));
				ay.setStartDate(Date.valueOf(year + "-01-01"));
			
				ay.setNextAcademicYearId(nextAcademicYearId);
			
				academicYearManager.addAcademicYear(ay);

				nextAcademicYearId = ay.getId();
			}
		}
	}
	
	/**
	 * This method is used to get the CardinalTimeUnit for a given programme
	 * @param programmeCode
	 * @return
	 */
	public String getCardinalTimeUnit(String programmeCode) {
		String cardinalTimeUnit = "Year";
		if (programmeCode.equals("17") || programmeCode.equals("18")
				|| programmeCode.equals("19") || programmeCode.equals("79")
				|| programmeCode.equals("68"))
			cardinalTimeUnit = "Semester";
		return cardinalTimeUnit;
	}

	/**
	 * This method is used to check if the study exist
	 * @param studyName
	 * @param organizationalUnitId
	 * @return
	 */
	private boolean checkIfStudyExist(String studyName,int organizationalUnitId) {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyObject = temp
				.queryForList("SELECT * FROM opuscollege.study WHERE studydescription='"
						+ studyName + "' AND organizationalunitid='"+organizationalUnitId+"'");

		if (studyObject.toString().equals("[]"))
			return false;
		else
			return true;
	}
	
	private boolean checkIfAcademicYearExist(String academicYearDescription) {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyObject = temp.queryForList("SELECT * FROM opuscollege.academicyear WHERE description='"+academicYearDescription+"'");

		if (studyObject.toString().equals("[]"))
			return false;
		else
			return true;
	}

	//private void deleteAcademicYears() {
	//	JdbcTemplate temp = new JdbcTemplate(dataSource);
	//	temp.execute("DELETE FROM opuscollege.academicyear WHERE description>'2012'");
	//}

	/**
	 * This method is retrieve the id of a Study
	 * @param studyName
	 * @return
	 */
	private int getStudyID(String studyName,int organizationalUnitId) {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyObject = temp
				.queryForList("SELECT id FROM opuscollege.study WHERE studydescription='"
						+ studyName + "' and organizationalunitid='"+organizationalUnitId+"'");
		return studyObject.toString().equals("[]")?0:Integer.valueOf(studyObject.get(0).get("id").toString());
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
	public String getStudyFormCode(String studyFormDescription) {
		JdbcTemplate opus = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyFormObject = opus.queryForList("SELECT code FROM opuscollege.studyform WHERE description='" + studyFormDescription + "'");
		return studyFormObject.toString().equals("[]")?"D":studyFormObject.get(0).get("code").toString();
	}
	
	
	/**
	 * This method is used to add a gradeType to opusCollege database
	 * @param code
	 * @param gradeType
	 * @param title
	 */
	private void addGradeType(String code, String gradeType,String title) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> gradeTypes = jdbcTemplate.queryForList("SELECT * FROM opuscollege.gradetype WHERE code='"+ code + "'");
		if (gradeTypes.toString().equals("[]")) {
			jdbcTemplate.execute("INSERT INTO opuscollege.gradetype (code,lang,description,title,active) VALUES ('"
							+ code + "','en','"	+ gradeType	+ "','"	+ title	+ "','Y')");
		}
	}

	/**
	 * This method is used to add a studyTime to opusCollege database
	 * @param code
	 * @param description
	 */
	private void addStudyTime(String code, String description) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> studyTime = jdbcTemplate.queryForList("SELECT * FROM opuscollege.studytime WHERE description='"+ description + "'");

		if (studyTime.toString().equals("[]")) {
			jdbcTemplate.execute("INSERT INTO opuscollege.studytime (code,lang,description,active) VALUES ('" + code + "','en','" + description + "','Y')");
		}
	}
	/**
	 * This method is used to add cardinalTimeUnitStudyGradeType to opusCollege database
	 * @param studyGradeTypeId
	 * @param studyDuration
	 */
	private void addCardinalTimeUnitsForStudyGradeType(int studyGradeTypeId, int studyDuration){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		
		for(int i=1; i<=studyDuration;i++){
			List<Map<String, Object>> result = jdbcTemplate.queryForList("SELECT * FROM opuscollege.cardinaltimeunitstudygradetype WHERE studygradetypeid='"+ studyGradeTypeId + "' AND cardinaltimeunitnumber='"+i+"'");
	
			if (result.toString().equals("[]")) {
				jdbcTemplate.execute("INSERT INTO opuscollege.cardinaltimeunitstudygradetype (studygradetypeid, cardinaltimeunitnumber, numberofelectivesubjectblocks,numberofelectivesubjects,active) VALUES ('" + studyGradeTypeId + "','"+i+"','0','0','Y')");
			}
		}
	}
	
	/**
	 * This method is used to check if the studyGradeTypeExist in opusCollege database
	 * @param studyId
	 * @param gradeTypeCode
	 * @param currentAcademicYearId
	 * @param studyFormCode
	 * @param studyTimeCode
	 * @return
	 */
	private boolean studyGradeTypeExist(int studyId,String gradeTypeCode,int currentAcademicYearId,String studyFormCode,String studyTimeCode) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		List<Map<String, Object>> result = jdbcTemplate.queryForList("SELECT * FROM opuscollege.studygradetype WHERE studyid='"+ studyId + "' AND gradetypecode='"+gradeTypeCode+"' AND currentacademicyearid='"+currentAcademicYearId+"' AND studyformcode='"+studyFormCode+"' AND studytimecode='"+studyTimeCode+"'");

		if (result.toString().equals("[]")) {
			return false;
		}
		return true;
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
