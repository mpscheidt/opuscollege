/*
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
 * The Original Code is Opus-College college module code.
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
*/

package org.uci.opus.college.web.form.person;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup1;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.web.form.AddressLookup;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.CodeToLookupMap;

public class StudentForm implements IStudentForm {

    private StudentFormShared studentFormShared;

	private Organization organization;

	private AddressLookup previousInstitutionAddressLookup;

	private String txtMsg;

	private List < Study > allStudies;
	private List < Study > allSecondaryStudies;
    private List < Study > studyPlanStudies;
	private List < StaffMember> allStaffMembers;
	private Map<String , String> photographProperties;
	private IdToOrganizationalUnitMap idToOrganizationalUnitMap;
	private OpusUser opusUser;
	private OpusUserRole personOpusUserRole;
	private List < Institution > allPreviousInstitutions;
	
	private boolean studentCodeWillBeGenerated;
	
    private List<Lookup> allBloodTypes;
    private List<Lookup> allCivilStatuses;
	private List<Lookup> allCivilTitles;
	private List<Lookup3> allCountries;
    private List<Lookup> allGenders;
    private List<Lookup9> allGradeTypes;
    private List<Lookup> allMasteringLevels;
    private List<Lookup1> allNationalities;
    private List<Lookup5> allProvinces;
    private List<Lookup> allDistricts;

    private CodeToLookupMap codeToBloodTypeMap;
    private CodeToLookupMap codeToCivilStatusMap;
    private CodeToLookupMap codeToCivilTitleMap;
    private CodeToLookupMap codeToCountryMap;
    private CodeToLookupMap codeToGenderMap;
    private CodeToLookupMap codeToGradeTypeMap;
    private CodeToLookupMap codeToMasteringLevelMap;
    private CodeToLookupMap codeToNationalityMap;

	public StudentForm() {
		txtMsg = "";
	}

	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}

	/**
	 * @param organization the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}

	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}

	public List < Study > getAllStudies() {
        return allStudies;
    }

    public void setAllStudies(final List < Study > allStudies) {
        this.allStudies = allStudies;
    }

    /**
	 * @return the allSecondaryStudies
	 */
	public List<Study> getAllSecondaryStudies() {
		return allSecondaryStudies;
	}

	/**
	 * @param allSecondaryStudies the allSecondaryStudies to set
	 */
	public void setAllSecondaryStudies(final List<Study> allSecondaryStudies) {
		this.allSecondaryStudies = allSecondaryStudies;
	}

	/**
	 * @return the allStaffMembers
	 */
	public List<StaffMember> getAllStaffMembers() {
		return allStaffMembers;
	}

	/**
	 * @param allStaffMembers the allStaffMembers to set
	 */
	public void setAllStaffMembers(final List<StaffMember> allStaffMembers) {
		this.allStaffMembers = allStaffMembers;
	}

	/**
	 * @return the photographProperties
	 */
	public Map<String, String> getPhotographProperties() {
		return photographProperties;
	}

	/**
	 * @param photographProperties the photographProperties to set
	 */
	public void setPhotographProperties(final Map<String, String> photographProperties) {
		this.photographProperties = photographProperties;
	}

	/**
	 * @return the idToOrganizationalUnitMap
	 */
	public IdToOrganizationalUnitMap getIdToOrganizationalUnitMap() {
		return idToOrganizationalUnitMap;
	}

	/**
	 * @param idToOrganizationalUnitMap the idToOrganizationalUnitMap to set
	 */
	public void setIdToOrganizationalUnitMap(
			final IdToOrganizationalUnitMap idToOrganizationalUnitMap) {
		this.idToOrganizationalUnitMap = idToOrganizationalUnitMap;
	}

	/**
	 * @return the personOpusUser
	 */
	public OpusUser getOpusUser() {
		return opusUser;
	}

	/**
	 * @param personOpusUser the personOpusUser to set
	 */
	public void setOpusUser(final OpusUser opusUser) {
		this.opusUser = opusUser;
	}

	/**
	 * @return the personOpusUserRole
	 */
	public OpusUserRole getPersonOpusUserRole() {
		return personOpusUserRole;
	}

	/**
	 * @param personOpusUserRole the personOpusUserRole to set
	 */
	public void setPersonOpusUserRole(final OpusUserRole personOpusUserRole) {
		this.personOpusUserRole = personOpusUserRole;
	}

	/**
	 * @return the allPreviousInstitutions
	 */
	public List<Institution> getAllPreviousInstitutions() {
		return allPreviousInstitutions;
	}

	/**
	 * @param allPreviousInstitutions the allPreviousInstitutions to set
	 */
	public void setAllPreviousInstitutions(final List<Institution> allPreviousInstitutions) {
		this.allPreviousInstitutions = allPreviousInstitutions;
	}

    public boolean isStudentCodeWillBeGenerated() {
        return studentCodeWillBeGenerated;
    }

    public void setStudentCodeWillBeGenerated(boolean studentCodeWillBeGenerated) {
        this.studentCodeWillBeGenerated = studentCodeWillBeGenerated;
    }

    public List < Study > getStudyPlanStudies() {
        return studyPlanStudies;
    }

    public void setStudyPlanStudies(List < Study > studyPlanStudies) {
        this.studyPlanStudies = studyPlanStudies;
    }

    public AddressLookup getPreviousInstitutionAddressLookup() {
        return previousInstitutionAddressLookup;
    }

    public void setPreviousInstitutionAddressLookup(AddressLookup previousInstitutionAddressLookup) {
        this.previousInstitutionAddressLookup = previousInstitutionAddressLookup;
    }

    public StudentFormShared getStudentFormShared() {
        return studentFormShared;
    }

    public void setStudentFormShared(StudentFormShared studentFormShared) {
        this.studentFormShared = studentFormShared;
    }

    public CodeToLookupMap getCodeToCivilTitleMap() {
        if (codeToCivilTitleMap == null) {
            codeToCivilTitleMap = new CodeToLookupMap(allCivilTitles);
        }
        return codeToCivilTitleMap;
    }

    public List<Lookup> getAllCivilTitles() {
        return allCivilTitles;
    }

    public void setAllCivilTitles(List<Lookup> allCivilTitles) {
        this.allCivilTitles = allCivilTitles;
    }

    public List<Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    public void setAllGradeTypes(List<Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        if (codeToGradeTypeMap == null) {
            codeToGradeTypeMap = new CodeToLookupMap(allGradeTypes);
        }
        return codeToGradeTypeMap;
    }

    public List<Lookup> getAllGenders() {
        return allGenders;
    }

    public void setAllGenders(List<Lookup> allGenders) {
        this.allGenders = allGenders;
    }

    public CodeToLookupMap getCodeToGenderMap() {
        if (codeToGenderMap == null) {
            codeToGenderMap = new CodeToLookupMap(allGenders);
        }
        return codeToGenderMap;
    }

    public List<Lookup> getAllCivilStatuses() {
        return allCivilStatuses;
    }

    public void setAllCivilStatuses(List<Lookup> allCivilStatuses) {
        this.allCivilStatuses = allCivilStatuses;
    }

    public CodeToLookupMap getCodeToCivilStatusMap() {
        if (codeToCivilStatusMap == null) {
            codeToCivilStatusMap = new CodeToLookupMap(allCivilStatuses);
        }
        return codeToCivilStatusMap;
    }

    public List<Lookup> getAllMasteringLevels() {
        return allMasteringLevels;
    }

    public void setAllMasteringLevels(List<Lookup> allMasteringLevels) {
        this.allMasteringLevels = allMasteringLevels;
    }

    public CodeToLookupMap getCodeToMasteringLevelMap() {
        if (codeToMasteringLevelMap == null) {
            codeToMasteringLevelMap = new CodeToLookupMap(allMasteringLevels);
        }
        return codeToMasteringLevelMap;
    }

    public List<Lookup> getAllBloodTypes() {
        return allBloodTypes;
    }

    public void setAllBloodTypes(List<Lookup> allBloodTypes) {
        this.allBloodTypes = allBloodTypes;
    }

    public CodeToLookupMap getCodeToBloodTypeMap() {
        if (codeToBloodTypeMap == null) {
            codeToBloodTypeMap = new CodeToLookupMap(allBloodTypes);
        }
        return codeToBloodTypeMap;
    }

    public List<Lookup1> getAllNationalities() {
        return allNationalities;
    }

    public void setAllNationalities(List<Lookup1> allNationalities) {
        this.allNationalities = allNationalities;
    }

    public CodeToLookupMap getCodeToNationalityMap() {
        if (codeToNationalityMap == null) {
            codeToNationalityMap = new CodeToLookupMap(allNationalities);
        }
        return codeToNationalityMap;
    }

    public List<Lookup3> getAllCountries() {
        return allCountries;
    }

    public void setAllCountries(List<Lookup3> allCountries) {
        this.allCountries = allCountries;
    }

    public CodeToLookupMap getCodeToCountryMap() {
        if (codeToCountryMap == null) {
            codeToCountryMap = new CodeToLookupMap(allCountries);
        }
        return codeToCountryMap;
    }

}
