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
import java.sql.Time;
import java.util.*;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.service.StaffMemberManager;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.util.StaffMemberUtil;

import java.util.List;

public class UnzaStaffMigrator {
	private DataSource srsDataSource;
	private DataSource opusDataSource;
	@Autowired
	StaffMemberManagerInterface staffMemberManager;
	private static Logger log = Logger.getLogger(UnzaStaffMigrator.class);

	public DataSource getSrsDataSource() {
		return srsDataSource;
	}

	public void setSrsDataSource(DataSource srsDataSource) {
		this.srsDataSource = srsDataSource;
	}

	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

	@SuppressWarnings("deprecation")
	public void convertStaff() throws SQLException {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.person " +
				"where personcode in (select employee_number " +
				"from srsdatastage.staff)";
		opusJdbcTemplate.execute(query);
		JdbcTemplate jdbcTemplate = new JdbcTemplate(srsDataSource);

		List<Map<String, Object>> staffMemberList = jdbcTemplate
				.queryForList("select * from srsdatastage.staff");
		for (Map<String, Object> sm : staffMemberList) {
			log.info(sm);

			// Get the informix data from the Map object
			String employeenumber = (String) sm.get("employee_number");
			String sur_name = (String) sm.get("sur_name");
			String first_name = (String) sm.get("first_name");
			String second_name = (String) sm.get("second_name");
			String initials = (String) sm.get("initials");
			String title = (String) sm.get("title");
			String cost_centre_id = (String) sm.get("cost_centre_id");
			// String sDob =(String)sm.get("dob");
			// String sDriginale_doe=(String)sm.get("originale_doe");
			// String sMost_recent_doe=(String)sm.get("most_recent_doe");
			// Date dob =new Date(sDob.replace("/", "-"));
			// Date original_doe=new Date(sDriginale_doe.replace("/", "-"));
			// Date most_recent_doe=new Date(sMost_recent_doe.replace("/",
			// "-"));
			// ******************************************************************************
			String newDob;
			newDob = ((String) sm.get("dob"));
			newDob.replace("/", "-");
			Date dob = new Date((String) newDob);
			// ---------------------------------------------------------------------------------
			String newOriginal_doe;
			newOriginal_doe = ((String) sm.get("original_doe"));
			newOriginal_doe.replace("/", "-");
			Date original_doe = new Date((String) newOriginal_doe);
			// ---------------------------------------------------------------------------------
			// Date original_doe=new Date((String)sm.get("originale_doe"));
			// Date original_doe=new Date((String)sm.get("originale_doe"));
			String newMost_recent_doe;
			newMost_recent_doe = ((String) sm.get("most_recent_doe"));
			newMost_recent_doe.replace("/", "-");
			Date most_recent_doe = new Date((String) newMost_recent_doe);

			// ********************************************************************************

			String gender = (String) sm.get("gender");
			String id_number = (String) sm.get("id_number");
			String occupation = (String) sm.get("occupation");
			Date last_doe = (Date) sm.get("last_doe");
			String nationality = (String) sm.get("nationality");
			String job_grade = (String) sm.get("job_grade");
			String employee_status = (String) sm.get("employee_status");
			String newFirstnamesAlias = (String) sm.get("first_name");
			String newFirstnamesFull = (String) sm.get("first_name");
			String newIdentificationNumber = (String) sm.get("id_number");
			String newSurnameAlias = (String) sm.get("sur_name");
			String newSurnameFull = (String) sm.get("sur_name");
			// int newPrimaryUnitOfAppointmentId =(int)sm.get(costcentre);
			// Set up the transfer object

			StaffMember staffMember = new StaffMember();
			staffMember.setStaffMemberCode(employeenumber);
			staffMember.setFirstnamesFull(first_name);
			staffMember.setSurnameFull(sur_name);
			staffMember.setBirthdate(dob);
			staffMember.setActive("Y");
			// staffMember.setAddresses(newAddresses);
			staffMember.setAdministrativePostOfOriginCode(cost_centre_id);
			staffMember.setAppointmentTypeCode("default");
			staffMember.setBloodTypeCode("default");
			staffMember.setCityOfOrigin("default");
			staffMember.setCivilStatusCode("default");
			staffMember.setCivilTitleCode(title);
			staffMember.setContactPersonEmergenciesName("default");
			// staffMember.setContracts("");
			staffMember.setContactPersonEmergenciesTelephoneNumber("default");
			staffMember.setCountryOfBirthCode("");
			staffMember.setCountryOfOriginCode("");
			staffMember.setDateOfAppointment(original_doe);
			staffMember.setDistrictOfBirthCode("");
			staffMember.setDistrictOfOriginCode("");
			staffMember.setEducationTypeCode("");
			// staffMember.setEndWorkDay(new Time(12, 00, 00));
			staffMember.setExaminationsTaught(null);
			staffMember.setFirstnamesAlias(newFirstnamesAlias);
			staffMember.setFirstnamesFull(newFirstnamesFull);
			// staffMember.set
			// staffMember.setFunctions(newFunctions);
			staffMember.setGenderCode(gender);
			staffMember.setGradeTypeCode("");
			staffMember.setHealthIssues("");
			staffMember.setHobbies("");
			staffMember.setHousingOnCampus("");
			// staffMember.setId(newId);
			staffMember.setIdentificationDateOfExpiration(new Date());
			staffMember.setIdentificationDateOfIssue(new Date());
			staffMember.setIdentificationNumber(newIdentificationNumber);
			staffMember.setIdentificationPlaceOfIssue("");
			staffMember.setIdentificationTypeCode("L");
			staffMember.setLanguageFirstCode("en_ZM");
			staffMember.setLanguageFirstMasteringLevelCode("0");
			staffMember.setLanguageSecondCode("0");
			staffMember.setLanguageSecondMasteringLevelCode("0");
			staffMember.setLanguageThirdCode("0");
			// staffMember.setNationalityCingfordode(null);
			staffMember.setNationalRegistrationNumber(id_number);
			staffMember.setPersonCode(employeenumber);
			// staffMember.setPersonId(newPersonId);
			staffMember.setPhotograph(null);
			staffMember.setPhotographMimeType("0");
			staffMember.setPhotographName("0");
			staffMember.setPlaceOfBirth("0");
			//TODO:code to lookup the Id for an Organization Unit given the Org Unit Code
			staffMember.setPrimaryUnitOfAppointmentId(1);//Very important as it ties to a temp org
			staffMember.setProfessionCode("");
			staffMember.setProfessionDescription("");
			staffMember.setProvinceOfBirthCode("");
			staffMember.setProvinceOfOriginCode("");
			staffMember.setPublicHomepage("");
			staffMember.setRegistrationDate(new Date());
			staffMember.setRemarks("");
			staffMember.setSocialNetworks("");
			staffMember.setStaffMemberCode(employeenumber);
			// staffMember.setStaffMemberId(employeenumber);
			// staffMember.setStaffTypeCode(newStaffTypeCode);
			// staffMember.setStartWorkDay(new Time());
			// staffMember.setSubjectsTaught(null);
			staffMember.setSupervisingDayPartCode("");
			staffMember.setSurnameAlias(sur_name);
			staffMember.setSurnameFull(sur_name);
			staffMember.setTeachingDayPartCode("");
			staffMember.setTeachingDayPartCode("");
			// staffMember.setTestsSupervised(null);

			// staffMember.setTestsSupervised(null);

			// Remember that you first need to create a new opus user record.
			// this is very important.
			// for the new user.
			String preferredLanguage = "en_ZM";
			OpusUserRole opusUserRole = new OpusUserRole();

			OpusUser opusUser = new OpusUser();

			opusUserRole.setRole("Admin");
			opusUserRole.setInstitutionId(1);
			opusUserRole.setBranchId(1);
			opusUserRole.setOrganizationalUnitId(1);
			opusUserRole.setUserName(employeenumber);// sur_name +
														// first_name.substring(0,
														// 1));//this is just to
														// give a default
														// username which can be
														// modified later
			opusUser.setLang(preferredLanguage);

			// Then create the StaffMember
			staffMemberManager.addStaffMember(staffMember, opusUserRole,
					opusUser);
			// staffMemberManager.addStaffMember(preferredLanguage, staffMember,
			// staffOpusUserRole, staffOpusUser, currentLoc, request)
			// staffMemberManager.addFunctionToStaffMember(staffMemberId,
			// functionCode, functionLevelCode);

			// other details required by staff member

		}

	}
	public void moveStaff(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(srsDataSource);
        JdbcTemplate jdbcTemplateDataStage = new JdbcTemplate(opusDataSource);
        
        /*Load all nationality*/
        List<Map<String, Object>> stafflist = jdbcTemplate
                .queryForList("select * from srsystem.staff");
        
        for (Map<String, Object> staff : stafflist) {
            log.info(staff);
            
            String employee_number="0";
            if(staff.get("employee_number") != null || staff.get("employee_number") !="")
            	employee_number = (String)staff.get("employee_number");
            
            String sur_name="0";
            if(staff.get("sur_name") != null || staff.get("sur_name") !="")
            	sur_name = (String)staff.get("sur_name");
            
            String first_name="0";
            if(staff.get("first_name") != null || !staff.get("first_name").equals(null))
            	first_name= (String)staff.get("first_name");
            
            String second_name="0";
            if(staff.get("second_name") != null || staff.get("second_name") !="")
            	second_name = (String)staff.get("second_name");
            
            String initials="0";
            if(staff.get("initials") != null || staff.get("initials") !="")
            	initials = (String)staff.get("initials");
            
            String dob="0";
            if(staff.get("dob") != null || staff.get("dob") !="")
            	dob = (String)staff.get("dob");
            
            String original_doe="0";
            if(staff.get("original_doe") != null || staff.get("original_doe") !="")
            	original_doe = (String)staff.get("original_doe");
            
            String most_recent_doe="0";
            if(staff.get("most_recent_doe") != null || staff.get("most_recent_doe") !="")
            	most_recent_doe= (String)staff.get("most_recent_doe");
            
            String gender="0";
            if(staff.get("gender") != null || staff.get("gender") !="")
            	gender = (String)staff.get("gender");
            
            String id_number="0";
            if(staff.get("id_number") != null || staff.get("id_number") !="")
            	id_number = (String)staff.get("id_number");
            
            String occupation="0";
            if(staff.get("occupation") != null || staff.get("occupation") !="")
            	occupation= (String)staff.get("occupation");
           
            String nationality="0";
            if(staff.get("nationality") != null || staff.get("nationality") !="")
            	nationality= (String)staff.get("nationality");
            
            String passport_number="0";
            if(staff.get("passport_number") != null || staff.get("passport_number") !="")
            	passport_number= (String)staff.get("passport_number");
            
            String title="0";
            if(staff.get("title") != null || staff.get("title") !="")
            	title= (String)staff.get("title");
            
            String cost_centre_id="0";
            if(staff.get("cost_centre_id") != null || staff.get("cost_centre_id") !="")
            	cost_centre_id= (String)staff.get("cost_centre_id");
            
            String cost_centre="0";
            if(staff.get("cost_centre") != null || staff.get("cost_centre") !="")
            	cost_centre= (String)staff.get("cost_centre");
            
            String costcentre_new="0";
            if(staff.get("costcentre_new") != null || staff.get("costcentre_new") !="")
            	costcentre_new= (String)staff.get("costcentre_new");
            
            String srs_schcode ="0";
            if(staff.get("srs_schcode") != null || staff.get("srs_schcode") !="")
            	srs_schcode= (String)staff.get("srs_schcode");
            
            String sql = "INSERT INTO srsdatastage.staff"+
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            /* Write the record to the staging database */
            jdbcTemplateDataStage.update(sql, new Object[] { employee_number,sur_name,first_name,second_name,
            		initials,dob,original_doe,most_recent_doe,gender,id_number,occupation,nationality,
            		passport_number,title,cost_centre_id,cost_centre,costcentre_new,srs_schcode});
        }
	}
}
