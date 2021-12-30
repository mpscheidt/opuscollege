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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Lookup1;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.factory.AddressFactory;
import org.uci.opus.mulungushi.data.MuStudentDao;
import org.uci.opus.mulungushi.domain.MuStudent;
import org.uci.opus.util.Encode;

public class StudentMigrator {

	private static Logger log = LoggerFactory.getLogger(StudentMigrator.class);
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private ResultManagerInterface resultManager;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private DataSource dataSource;
	@Autowired private DBUtil dbUtil;
	@Autowired private CourseMigrator courseMigrator;
	@Autowired private ProgrammeMigrator programmeMigrator;
	@Autowired private MuStudentDao muStudentDao;
	@Autowired private LookupManagerInterface lookupManager;
	@Autowired private AddressFactory addressFactory;
	@Autowired private AddressManagerInterface addressManager;
	@Autowired private StudyPlanMigrator studyPlanMigrator;
	
	private List<Lookup1> allNationalities = new ArrayList<>();
	private Map<String, Student> studentNoToStudentMap = new HashMap<>();

    static private SimpleDateFormat df = (SimpleDateFormat) DateFormat.getDateInstance();

    static {
        df.applyPattern("yyyy-MM-dd");
    }

	public void convertStudents() throws Exception {
    	log.info("Starting conversion of Students");
		
		initAllNationalities();

    	log.info("Going to delete student related data in DB");
    	studyPlanMigrator.deleteStudyPlanData();	

		// delete all currently exisitng students including related tables (person, opususer, opususerrole)
		List<Student> allStudents = studentManager.findAllStudents("en_ZM");
		for (Student student : allStudents) {
			studentManager.deleteStudent("en_ZM", student.getStudentId(), "migration");
		}

		for (MuStudent muStudent : muStudentDao.getStudents()) {
			
			String programNo = muStudent.getProgramNo();
			if (programNo == null) {
			    log.warn("Will not migrate student since no program number set in grades table for student " + muStudent);
			} else {
                Study study = programmeMigrator.getStudy(programNo);
    			if (study == null) {
    				log.warn("Will not migrate student since no study for programNo = " + programNo + " (" + muStudent + ")");
    			} else {
    
    				Student student = new Student();
    				student.setActive("Y");
    				student.setStudentCode(Integer.toString(muStudent.getStudentNo()));
    				student.setFirstnamesFull(muStudent.getFirstnames());
    				student.setSurnameFull(muStudent.getSurname());
    				student.setBirthdate(muStudent.getDateOfBirth());
    				student.setPrimaryStudyId(study.getId());
    				student.setScholarship("N");
    				student.setSubscriptionRequirementsFulfilled("Y");
    				student.setSecondaryStudyId(0);
    				student.setRelativeOfStaffMember("N");
    				student.setRuralAreaOrigin("N");
    
    				student.setPersonCode(student.getStudentCode());
    				student.setWriteWho("migration");
    				student.setCivilTitleCode("0");
    		    	student.setGradeTypeCode("0");
    		    	student.setGenderCode(getGenderCode(muStudent));
    		    	Lookup1 nationality = findNationality(muStudent);
    				student.setNationalityCode(nationality == null ? null : nationality.getCode());
    				student.setForeignStudent(nationality == null || "Zambian".equalsIgnoreCase(nationality.getDescription()) ? "N" : "Y");
    		    	student.setPlaceOfBirth(muStudent.getPlaceOfBirth());
    		    	student.setCountryOfBirthCode("0");
    		    	student.setProvinceOfBirthCode("0");
    		    	student.setDistrictOfBirthCode("0");
    		    	student.setCountryOfOriginCode("0");
    		    	student.setProvinceOfOriginCode("0");
    		    	student.setDistrictOfOriginCode("0");
    		    	student.setCityOfOrigin("");
    		    	student.setCivilStatusCode(getCivilStatusCode(muStudent));
    		    	student.setHousingOnCampus("N");
    		    	student.setIdentificationTypeCode(getIdentificationTypeCode(muStudent));
    		    	student.setIdentificationNumber(muStudent.getNrcOrPassport());
    		    	student.setPublicHomepage("N");
    		    	student.setFinancialGuardianFullName(muStudent.getNameOfNextOfKin());
    		    	student.setFinancialGuardianRelation(muStudent.getRelationToNextOfKin());
    
    		    	// user and password
    		    	String userName = Integer.toString(muStudent.getStudentNo());
    		        OpusUserRole opusUserRole = new OpusUserRole();
    		        opusUserRole.setRole("student");
    		        opusUserRole.setUserName(userName);
    
    		        OpusUser opusUser = new OpusUser();
    		        opusUser.setLang("en_ZM");
    		        opusUser.setUserName(userName);
    		        opusUser.setPw(Encode.encodeMd5("studpass123"));
    		        opusUser.setPreferredOrganizationalUnitId(study.getOrganizationalUnitId());
    
    		        // store the new student
    		        studentManager.addStudent(student, opusUserRole, opusUser);
    		        
    		        // residential (home) address: type "1"
    		        int personId = student.getPersonId();
    				Address homeAddress = addressFactory.newHomeAddress(personId);
    		        homeAddress.setCity(muStudent.getResidentialAddress());
    		        
    		        // formal communication address: type "2"
    		        Address formalCommunicationAddress = addressFactory.newFormalCommuncationAddressStudent(personId);
    		        formalCommunicationAddress.setCity(muStudent.getPostalAddress() == null ? null : muStudent.getPostalAddress().trim());
    		        formalCommunicationAddress.setTelephone(muStudent.getBusinessPhone() == null ? null : muStudent.getBusinessPhone().trim());
    		        formalCommunicationAddress.setMobilePhone(DbConvUtil.replaceUnicode0(muStudent.getMobileNo()));
    		        formalCommunicationAddress.setEmailAddress(muStudent.getEmail() == null ? null : muStudent.getEmail().trim());
    
    		        // next of kin / financial guardian: type "3"
    		        Address financialGuardianAddress = addressFactory.newFinancialGuardianAddress(personId);
    		        financialGuardianAddress.setCity(muStudent.getNextOfKinResAddress());
    		        financialGuardianAddress.setStreet(muStudent.getNextOfKinPostalAddress());
    		        financialGuardianAddress.setMobilePhone(muStudent.getNextOfKinMobileNo());
    		        financialGuardianAddress.setTelephone(muStudent.getNextOfKinPhoneNo());
    
    		        List<Address> addresses = new ArrayList<>();
    		        addresses.add(homeAddress);
    		        addresses.add(formalCommunicationAddress);
    		        addresses.add(financialGuardianAddress);
    		        student.setAddresses(addresses);
    		        
    		        // store addresses
    	            addressManager.addAddresses(addresses);
    			}
			}
		}

	}

	private String getGenderCode(MuStudent muStudent) {
		String code = null;
		
		String sex = muStudent.getSex();
		if (StringUtils.isNotBlank(sex)) {
			String letter = sex.trim().substring(0, 1);
			if ("F".equalsIgnoreCase(letter)) {
				// 2 = female
				code = "2";
			} else if ("M".equalsIgnoreCase(letter)) {
				// 1 = male
				code = "1";
			}
		}
		
		return code;
		
	}

	@SuppressWarnings("unchecked")
	private void initAllNationalities() {
		allNationalities = lookupManager.findAllRows("en", "nationality");
	}

	private Lookup1 findNationality(MuStudent muStudent) {

		if (!StringUtils.isNotBlank(muStudent.getNationality())) {
			log.warn("Nationality is not set for student " + muStudent);
			return null;
		}

		// take care of a few typical typos
		String muNationality = muStudent.getNationality().trim();
		if ("Zabian".equalsIgnoreCase(muNationality)
				|| "Zaambian".equalsIgnoreCase(muNationality)
				|| "Zanbian".equalsIgnoreCase(muNationality)) {
			muNationality = "Zambian";
		}

		// at least the first 3 characters need to match, otherwise no nationality found
		for (int idx = muNationality.length(); idx >= 3; idx--) {
			for (Lookup1 lookup : allNationalities) {
				String lookupDescription = lookup.getDescription().trim();
				
				if (lookupDescription.length() >= idx
						&& lookupDescription.substring(0, idx).equalsIgnoreCase(muNationality.substring(0, idx))) {
					return lookup;
				}
					
			}
		}
		
		log.warn("Nationality " + muNationality + " of student " + muStudent  + " cannot be mapped to a nationality in Opus");
		
		return null;
	}

	private String getCivilStatusCode(MuStudent muStudent) {
		// default: "2" = "single"
		String civilStatusCode = "2";
		
		String muMaritalStatus = muStudent.getMaritalStatus();
		if (StringUtils.isNotBlank(muMaritalStatus) && muMaritalStatus.length() >= 4) {
			String martial4 = muMaritalStatus.substring(0, 4).toLowerCase();
			if (martial4.startsWith("marr")) {
				// 1 = married
				civilStatusCode = "1";
			} else if (martial4.startsWith("wido")) {
				// 3 = widow
				civilStatusCode = "3";
			} else if (martial4.startsWith("divo") || martial4.startsWith("sepa")) {
				// 4 = divorced
				civilStatusCode = "4";
			}
		}
		
		return civilStatusCode;
	}
	
	private String getIdentificationTypeCode(MuStudent muStudent) {
		String code = null;
		
		String nrcOrPassport = muStudent.getNrcOrPassport();
		if (StringUtils.isNotBlank(nrcOrPassport)) {
			if (StringUtils.isNumeric(nrcOrPassport.substring(0, 1))) {
				// 1 = NRC (starts with number)
				code = "1";
			} else {
				// 3 = Passport (starts with letter)
				code = "3";
			}
		}
		
		return code;
	}

	public Student getStudent(String studentNo) {
		return getStudentNoToStudentMap().get(studentNo);
	}

	private Map<String, Student> getStudentNoToStudentMap() {
		if (studentNoToStudentMap.isEmpty()) {
			for (Student s : studentManager.findAllStudents("en")) {
				studentNoToStudentMap.put(s.getStudentCode(), s);
			}
		}
		return studentNoToStudentMap;
	}

}
