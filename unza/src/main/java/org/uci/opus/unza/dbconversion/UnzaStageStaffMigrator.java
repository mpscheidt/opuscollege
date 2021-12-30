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
/**
 * 
 * @author Kingford M Haakalaki
 *
 */

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
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManager;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.util.StaffMemberUtil;
import java.util.List;

public class UnzaStageStaffMigrator {
	private DataSource stageDataSource;
	private DataSource opusDataSource;
	@Autowired
	StaffMemberManagerInterface staffMemberManager;
	@Autowired
	 private InstitutionManagerInterface iManager;
	@Autowired OrganizationalUnitManagerInterface organizationalUnitManager;
	@Autowired OrganizationalUnitManagerInterface orgUnitManager;
	private static Logger log = Logger.getLogger(UnzaStaffMigrator.class);

	/*public DataSource getStageSrsDataSource() {
		return stageDataSource;
	}

	public void setStageDataSource(DataSource stageDataSource) {
		this.stageDataSource = stageDataSource;
	}*/

	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

	@SuppressWarnings("deprecation")
	public void convertStaff() throws SQLException {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.person " +
		"where personcode in (select employee_number " +
		"from srsdatastage.staff)";
		opusJdbcTemplate.execute(query);
		opusJdbcTemplate.execute(query);

		List<Map<String, Object>> staffMemberList = jdbcTemplate
				.queryForList("select * from srsdatastage.staff");
		for (Map<String, Object> sm : staffMemberList) {
			log.info(sm);

			// Get the informix data from the Map object
			String employee_number = (String) sm.get("employee_number");
			String sur_name = (String) sm.get("sur_name");
			String first_name = (String) sm.get("first_name");
			String second_name = (String) sm.get("second_name");
			String initials = (String) sm.get("initials");
			String title = (String) sm.get("title");
			String cost_centre_id = (String) sm.get("cost_centre_id");
			Date dob =new Date(Date.parse((String)sm.get("dob")));//= (Date)sm.get("dob");			
			Date original_doe=new Date(Date.parse((String)sm.get("original_doe")));// = (Date)sm.get("original_doe");
			Date most_recent_doe = new Date (Date.parse((String)sm.get("most_recent_doe")));//= (Date)sm.get("most_recent_doe");
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
			String cname = (String)sm.get("name");
			String costCenterCode =(String)sm.get("cost_centre_id");
			// int newPrimaryUnitOfAppointmentId =(int)sm.get(costcentre);
			// Set up the transfer object

			//load organizationalunit using code and description
			/*//Integer orgUnit=null;*/
			Map<String,Object> orgUnitParams = new HashMap<String,Object>();
			String centerDesc =cost_centre_id.substring(4);
			String centerCode = cost_centre_id.substring(0,3);
			orgUnitParams.put("organizationalUnitDescription",centerDesc.trim());
			orgUnitParams.put("organizationalUnitCode",centerCode.trim());
			OrganizationalUnit orgUnit = null;
			log.info("==================Org unit parameters============");
			log.info(cname);
			log.info(costCenterCode);
			
			//HashMap<String,String> orgUnitParams = new HashMap<String,String>();
			//orgUnitParams.put("organizationalUnitDescription", cname.trim());
			//orgUnitParams.put("organizationalUnitCode", costCenterCode.trim());
			//OrganizationalUnit orgUnit = new OrganizationalUnit();
			
			//orgUnitParams.put("organizationalUnitDescription", "NS Georaphy");
			//orgUnitParams.put("organizationalUnitCode", "063");
			log.info("XXXXXXXXXXXXXX");
			log.info(cost_centre_id.substring(4));
			log.info(cost_centre_id);
			log.info(cost_centre_id.substring(0,3));
			log.info(orgUnitParams);
			
			int institutionId =0;
						
			orgUnit=organizationalUnitManager.findOrganizationalUnitByNameAndCode(orgUnitParams);
			log.info("The Organizational Unit: "+orgUnit);
			log.info("##################OrganizationalUnit from DB#####################");
			if(!(orgUnit==null)){
				log.info("The Org unit description:"+orgUnit.getOrganizationalUnitDescription());
				
				//load branch to which unit belongs
				//Branch branch = branchManager.findBranchOfOrganizationalUnit(orgUnit.getId());
				
				//load institution to which unit belongs
				
				institutionId = iManager.findInstitutionOfBranch(orgUnit.getBranchId());
				
			}
			
			StaffMember staffMember = new StaffMember();
			staffMember.setStaffMemberCode(employee_number);
			staffMember.setFirstnamesFull(first_name);
			staffMember.setSurnameFull(sur_name);
			staffMember.setBirthdate(dob);
			staffMember.setActive("Y");
			// staffMember.setAddresses(newAddresses);
			staffMember.setAdministrativePostOfOriginCode(cost_centre_id);
			staffMember.setAppointmentTypeCode("0");
			staffMember.setBloodTypeCode("0");
			staffMember.setCityOfOrigin("0");
			staffMember.setCivilStatusCode("0");
			staffMember.setCivilTitleCode(title);
			staffMember.setContactPersonEmergenciesName("0");
			// staffMember.setContracts("");
			staffMember.setContactPersonEmergenciesTelephoneNumber("0");
			staffMember.setCountryOfBirthCode("0");
			staffMember.setCountryOfOriginCode("0");
			staffMember.setDateOfAppointment(original_doe);
			staffMember.setDistrictOfBirthCode("0");
			staffMember.setDistrictOfOriginCode("0");
			staffMember.setEducationTypeCode("0");
			// staffMember.setEndWorkDay(new Time(12, 00, 00));
			staffMember.setExaminationsTaught(null);
			staffMember.setFirstnamesAlias(newFirstnamesAlias);
			staffMember.setFirstnamesFull(newFirstnamesFull);
			// staffMember.set
			// staffMember.setFunctions(newFunctions);
			staffMember.setGenderCode(gender);
			staffMember.setGradeTypeCode("0");
			staffMember.setHealthIssues("0");
			staffMember.setHobbies("0");
			staffMember.setHousingOnCampus("0");
			// staffMember.setId(newId);
			staffMember.setIdentificationDateOfExpiration(new Date());
			staffMember.setIdentificationDateOfIssue(new Date());
			staffMember.setIdentificationNumber(newIdentificationNumber);
			staffMember.setIdentificationPlaceOfIssue("0");
			staffMember.setIdentificationTypeCode("L");
			staffMember.setLanguageFirstCode("en_ZM");
			staffMember.setLanguageFirstMasteringLevelCode("0");
			staffMember.setLanguageSecondCode("0");
			staffMember.setLanguageSecondMasteringLevelCode("0");
			staffMember.setLanguageThirdCode("Fr");
			// staffMember.setNationalityCingfordode(null);
			staffMember.setNationalRegistrationNumber(id_number);
			staffMember.setPersonCode(employee_number);
			// staffMember.setPersonId(newPersonId);
			staffMember.setPhotograph(null);
			staffMember.setPhotographMimeType("0");
			staffMember.setPhotographName("0");
			staffMember.setPlaceOfBirth("0");
			
			//staffMember.setPrimaryUnitOfAppointmentId(213);//This is very important
			//Load the UNKNOWN orgUnit for staff members that dont have a unit
			HashMap<String, Object> orgUnitMap = new HashMap<String, Object>();
			orgUnitMap.put("organizationalUnitDescription", "UNKNOWN");
			orgUnitMap.put("organizationalUnitCode", "43");
			
			OrganizationalUnit UNKNOWN = orgUnitManager.findOrganizationalUnitByNameAndCode(orgUnitMap);
			//This is very important
			if(!(orgUnit==null)){
				staffMember.setPrimaryUnitOfAppointmentId(orgUnit.getId());
				
				log.info("*************Staff memmber Org ID*****************");
				log.info("The Org Unit ID:"+orgUnit.getId());
			}else{
				staffMember.setPrimaryUnitOfAppointmentId(UNKNOWN.getId());//This is very important must be an existing unit NS
			}
			staffMember.setProfessionCode("0");
			staffMember.setProfessionDescription("0");
			staffMember.setProvinceOfBirthCode("0");
			staffMember.setProvinceOfOriginCode("0");
			staffMember.setPublicHomepage("0");
			staffMember.setRegistrationDate(new Date());
			staffMember.setRemarks("0");
			staffMember.setSocialNetworks("0");
			staffMember.setStaffMemberCode(employee_number);
			// staffMember.setStaffMemberId(employeenumber);
			// staffMember.setStaffTypeCode(newStaffTypeCode);
			// staffMember.setStartWorkDay(new Time());
			// staffMember.setSubjectsTaught(null);
			staffMember.setSupervisingDayPartCode("");
			staffMember.setSurnameAlias(sur_name);
			staffMember.setSurnameFull(sur_name);
			staffMember.setTeachingDayPartCode("0");
			staffMember.setTeachingDayPartCode("0");
			// staffMember.setTestsSupervised(null);

			// staffMember.setTestsSupervised(null);

			// Remember that you first need to create a new opus user record.
			// this is very important.
			// for the new user.
			String preferredLanguage = "en_ZM";
			OpusUserRole opusUserRole = new OpusUserRole();

			OpusUser opusUser = new OpusUser();
            
			opusUserRole.setRole("guest");
        	opusUserRole.setInstitutionId(institutionId);
			
			
			if(!(orgUnit==null)){
				opusUserRole.setOrganizationalUnitId(orgUnit.getId());
				opusUserRole.setBranchId(orgUnit.getBranchId());
			}else{
				opusUserRole.setOrganizationalUnitId(148);//defaultunit
				opusUserRole.setBranchId(2);
			}
			
			opusUserRole.setUserName(employee_number);// sur_name +
														// first_name.substring(0,
														// 1));//this is just to
														// give a default
														// username which can be
														// modified later
			opusUser.setLang(preferredLanguage);

			// Then create the StaffMember
			try {
				staffMemberManager.addStaffMember(staffMember, opusUserRole,
						opusUser);
				
			}catch(Exception e){
				log.debug(e.getMessage());
				
			}
			
			

			// other details required by staff member

		}

	}
}
