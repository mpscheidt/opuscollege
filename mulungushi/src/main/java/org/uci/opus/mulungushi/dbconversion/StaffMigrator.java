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

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.Encode;

public class StaffMigrator {

    private static final String CODE_548 = "548";

	private static final String CODE_4 = "4";

	private static final String CODE_3 = "3";

	private static final String CODE_2 = "2";

	private static final String CODE_1 = "1";

	private static Logger log = LoggerFactory.getLogger(StaffMigrator.class);

    @Autowired private DataSource dataSource;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired DBUtil dbUtil;
    @Autowired SchoolMigrator schoolMigrator;
    @Autowired private OpusUserManagerInterface opusUserManager;

    private Map<Integer, StaffMember> departmentIdToStaffMemberMap = new HashMap<>();
    
    static private SimpleDateFormat df = (SimpleDateFormat) DateFormat.getDateInstance();

    static {
        df.applyPattern("yyyy-MM-dd");
    }

    public void convertStaff() throws SQLException {

        log.info("Starting conversion of Staff Members");

    	int registrarsOfficeId = schoolMigrator.getRegistrarsOffice().getId();

    	for (StaffMember staffMember : staffMemberManager.findAllStaffMembers("en_ZM")) {
    		if ("Registrar".equalsIgnoreCase(staffMember.getSurnameFull()) || "Admin".equalsIgnoreCase(staffMember.getSurnameFull())) {
    			// set primaryUnitOfAppointmentId so that admin and registry users are visible in the staff members overview
				staffMember.setPrimaryUnitOfAppointmentId(registrarsOfficeId);

    	        OpusUser staffOpusUser = opusUserManager.findOpusUserByPersonId(staffMember.getPersonId());
    	        staffOpusUser.setPreferredOrganizationalUnitId(registrarsOfficeId);

    	        staffMemberManager.updateStaffMemberAndOpusUser(staffMember, staffOpusUser, null);

    			// opusUserRole need to have a correct organizationalUnitId set to be able to login
    	    	OpusUserRole userRole = opusUserManager.findOpusUserRolesByUserName(staffOpusUser.getUsername()).get(0);
    	    	userRole.setOrganizationalUnitId(registrarsOfficeId);
    	    	opusUserManager.updateOpusUserRole(userRole);

    		} else {
    			staffMemberManager.deleteStaffMember("en", staffMember.getStaffMemberId(), "datamigration");
    		}
    	}

		insertStaff(CODE_1, "Fanuel", "Sumaili", CODE_1, schoolMigrator.getTeachingDepartments().get(0)); 	// Business
		insertStaff(CODE_2, "Rodson", "Mukwena", CODE_1, schoolMigrator.getTeachingDepartments().get(1));	// Social Science
		insertStaff(CODE_548, "Douglas", "Kunda", CODE_1, schoolMigrator.getTeachingDepartments().get(2));
		insertStaff(CODE_3, "Olusegun", "Yerokun", CODE_1, schoolMigrator.getTeachingDepartments().get(3));	// Agriculture
		insertStaff(CODE_4, "Annie", "Sikwibele", CODE_2, schoolMigrator.getTeachingDepartments().get(4));	// Distance Education
    }
    
	private StaffMember insertStaff(String code, String firstnames, String surname, String genderCode, OrganizationalUnit unit) {
    	StaffMember dean = new StaffMember();
    	
    	dean.setPrimaryUnitOfAppointmentId(unit.getId());
    	dean.setActive("Y");
    	dean.setStaffMemberCode(code);
    	dean.setFirstnamesFull(firstnames);
    	dean.setSurnameFull(surname);

    	try {
			dean.setBirthdate(df.parse("1970-01-01"));
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	
    	dean.setAppointmentTypeCode("0");
    	dean.setStaffTypeCode(CODE_1);		// 1 = Academic
    	
    	dean.setPersonCode(code);
    	dean.setWriteWho("migration");
    	dean.setCivilTitleCode("0");
    	dean.setGradeTypeCode("0");
    	dean.setGenderCode(genderCode);
    	dean.setNationalityCode("0");
    	dean.setPlaceOfBirth("");
    	dean.setCountryOfBirthCode("0");
    	dean.setProvinceOfBirthCode("0");
    	dean.setDistrictOfBirthCode("0");
    	dean.setCountryOfOriginCode("0");
    	dean.setProvinceOfOriginCode("0");
    	dean.setDistrictOfOriginCode("0");
    	dean.setCityOfOrigin("");
    	dean.setCivilStatusCode("0");
    	dean.setHousingOnCampus("N");
    	dean.setPublicHomepage("N");

    	String userName = (dean.getFirstnamesFull().substring(0, 1) + dean.getSurnameFull()).toLowerCase();
    	// user account for staff member
        OpusUserRole staffOpusUserRole = new OpusUserRole();
        staffOpusUserRole.setRole("admin-B");
        staffOpusUserRole.setUserName(userName);

        OpusUser staffOpusUser = new OpusUser();
        staffOpusUser.setLang("en_ZM");
        staffOpusUser.setUserName(userName);
        staffOpusUser.setPw(Encode.encodeMd5(dean.getSurnameFull() + "2014"));
        staffOpusUser.setPreferredOrganizationalUnitId(unit.getId());

    	staffMemberManager.addStaffMember(dean, staffOpusUserRole, staffOpusUser);

    	// remember
//    	departmentIdToStaffMemberMap.put(unit.getId(), dean);
    	
    	return dean;
    }

	public Map<Integer, StaffMember> getDepartmentIdToStaffMemberMap() {
		if (departmentIdToStaffMemberMap.isEmpty()) {
			putIUnitIdToStaffmemberMap(staffMemberManager.findStaffMemberByCode("en_ZM", CODE_1));
			putIUnitIdToStaffmemberMap(staffMemberManager.findStaffMemberByCode("en_ZM", CODE_2));
			putIUnitIdToStaffmemberMap(staffMemberManager.findStaffMemberByCode("en_ZM", CODE_548));
			putIUnitIdToStaffmemberMap(staffMemberManager.findStaffMemberByCode("en_ZM", CODE_3));
			putIUnitIdToStaffmemberMap(staffMemberManager.findStaffMemberByCode("en_ZM", CODE_4));
		}
		
		return departmentIdToStaffMemberMap;
	}

	private void putIUnitIdToStaffmemberMap(StaffMember dean) {
		departmentIdToStaffMemberMap.put(dean.getPrimaryUnitOfAppointmentId(), dean);
	}

 }
