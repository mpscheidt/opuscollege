package org.uci.opus.college.web.form;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup1;
import org.uci.opus.college.domain.Lookup2;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup4;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToExaminationMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.domain.util.IdToTestMap;
import org.uci.opus.util.CodeToLookupMap;

public class StaffMemberForm {

    private StaffMember staffMember;
    private MultipartFile photograph;
    private Organization organization;
    private NavigationSettings navigationSettings;
    private String submitter;

    private IdToSubjectMap idToSubjectMap;
    private IdToAcademicYearMap idToAcademicYearMap;
    private IdToExaminationMap idToExaminationMap;
    private IdToTestMap idToTestMap;
    private List<Map<String,Object>> userRoles;
    private OpusUser opusUser;
    private Map<String , String> photographProperties;
    private boolean resetFailedLoginAttempts;
    
    private String currentPassword;
    private String newPassword;
    private String confirmPassword;

    private List<Lookup> allAddressTypes;
    private List<Lookup> allGenders;
    private List<Lookup> allCivilStatuses;
    private List<Lookup> allCivilTitles;
    private List<Lookup9> allGradeTypes;
    private List<Lookup1> allNationalities;
    private List<Lookup3> allCountries;
    private List<Lookup5> allProvinces;
    private List<Lookup> allDistricts;
    private List<Lookup4> allAdministrativePosts;
    private List<Lookup5> allProvincesOfBirth;
    private List<Lookup2> allDistrictsOfBirth;
    private List<Lookup5> allProvincesOfOrigin;
    private List<Lookup2> allDistrictsOfOrigin;
    private List<Lookup> allIdentificationTypes;
    private List<Lookup1> allLanguages;
    private List<Lookup> allMasteringLevels;
    private List<Lookup> allBloodTypes;
    private List<Lookup> allAppointmentTypes;
    private List<Lookup> allStaffTypes;
    private List<Lookup> allDayParts;
    private List<Lookup> allEducationTypes;
    private List<Lookup> allFunctions;
    private List<Lookup> allFunctionLevels;
    private List<Lookup> allContractTypes;
    private List<Lookup> allContractDurations;
    private List<Lookup> allStudyTimes;

    private CodeToLookupMap codeToGenderMap;
    private CodeToLookupMap codeToCivilStatusMap;
    private CodeToLookupMap codeToCivilTitleMap;
    private CodeToLookupMap codeToIdentificationTypeMap;
    private CodeToLookupMap codeToMasteringLevelMap;
    private CodeToLookupMap codeToBloodTypeMap;
    private CodeToLookupMap codeToStudyTimeMap;

    public StaffMember getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(StaffMember staffMember) {
        this.staffMember = staffMember;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public IdToSubjectMap getIdToSubjectMap() {
        return idToSubjectMap;
    }

    public void setIdToSubjectMap(IdToSubjectMap idToSubjectMap) {
        this.idToSubjectMap = idToSubjectMap;
    }

    public List<Map<String,Object>> getUserRoles() {
        return userRoles;
    }

    public void setUserRoles(List<Map<String,Object>> userRoles) {
        this.userRoles = userRoles;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public OpusUser getOpusUser() {
        return opusUser;
    }

    public void setOpusUser(OpusUser opusUser) {
        this.opusUser = opusUser;
    }

    public boolean isResetFailedLoginAttempts() {
        return resetFailedLoginAttempts;
    }

    public void setResetFailedLoginAttempts(boolean resetFailedLoginAttempts) {
        this.resetFailedLoginAttempts = resetFailedLoginAttempts;
    }

    public List<Lookup> getAllAddressTypes() {
        return allAddressTypes;
    }

    public void setAllAddressTypes(List<Lookup> allAddressTypes) {
        this.allAddressTypes = allAddressTypes;
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

    public void setCodeToGenderMap(CodeToLookupMap codeToGenderMap) {
        this.codeToGenderMap = codeToGenderMap;
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

    public void setCodeToCivilStatusMap(CodeToLookupMap codeToCivilStatusMap) {
        this.codeToCivilStatusMap = codeToCivilStatusMap;
    }

    public List<Lookup> getAllCivilTitles() {
        return allCivilTitles;
    }

    public void setAllCivilTitles(List<Lookup> allCivilTitles) {
        this.allCivilTitles = allCivilTitles;
    }

    public CodeToLookupMap getCodeToCivilTitleMap() {
        if (codeToCivilTitleMap == null) {
            codeToCivilTitleMap = new CodeToLookupMap(allCivilTitles);
        }
        return codeToCivilTitleMap;
    }

    public void setCodeToCivilTitleMap(CodeToLookupMap codeToCivilTitleMap) {
        this.codeToCivilTitleMap = codeToCivilTitleMap;
    }

    public List<Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    public void setAllGradeTypes(List<Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public List<Lookup1> getAllNationalities() {
        return allNationalities;
    }

    public void setAllNationalities(List<Lookup1> allNationalities) {
        this.allNationalities = allNationalities;
    }

    public List<Lookup3> getAllCountries() {
        return allCountries;
    }

    public void setAllCountries(List<Lookup3> allCountries) {
        this.allCountries = allCountries;
    }

    public List<Lookup5> getAllProvincesOfBirth() {
        return allProvincesOfBirth;
    }

    public void setAllProvincesOfBirth(List<Lookup5> allProvincesOfBirth) {
        this.allProvincesOfBirth = allProvincesOfBirth;
    }

    public List<Lookup2> getAllDistrictsOfBirth() {
        return allDistrictsOfBirth;
    }

    public void setAllDistrictsOfBirth(List<Lookup2> allDistrictsOfBirth) {
        this.allDistrictsOfBirth = allDistrictsOfBirth;
    }

    public List<Lookup5> getAllProvincesOfOrigin() {
        return allProvincesOfOrigin;
    }

    public void setAllProvincesOfOrigin(List<Lookup5> allProvincesOfOrigin) {
        this.allProvincesOfOrigin = allProvincesOfOrigin;
    }

    public List<Lookup2> getAllDistrictsOfOrigin() {
        return allDistrictsOfOrigin;
    }

    public void setAllDistrictsOfOrigin(List<Lookup2> allDistrictsOfOrigin) {
        this.allDistrictsOfOrigin = allDistrictsOfOrigin;
    }

    public List<Lookup> getAllIdentificationTypes() {
        return allIdentificationTypes;
    }

    public void setAllIdentificationTypes(List<Lookup> allIdentificationTypes) {
        this.allIdentificationTypes = allIdentificationTypes;
    }

    public CodeToLookupMap getCodeToIdentificationTypeMap() {
        if (codeToIdentificationTypeMap == null) {
            codeToIdentificationTypeMap = new CodeToLookupMap(allIdentificationTypes);
        }
        return codeToIdentificationTypeMap;
    }

    public void setCodeToIdentificationTypeMap(CodeToLookupMap codeToIdentificationTypeMap) {
        this.codeToIdentificationTypeMap = codeToIdentificationTypeMap;
    }

    public List<Lookup1> getAllLanguages() {
        return allLanguages;
    }

    public void setAllLanguages(List<Lookup1> allLanguages) {
        this.allLanguages = allLanguages;
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

    public void setCodeToMasteringLevelMap(CodeToLookupMap codeToMasteringLevelMap) {
        this.codeToMasteringLevelMap = codeToMasteringLevelMap;
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

    public void setCodeToBloodTypeMap(CodeToLookupMap codeToBloodTypeMap) {
        this.codeToBloodTypeMap = codeToBloodTypeMap;
    }

    public String getSubmitter() {
        return submitter;
    }

    public void setSubmitter(String submitter) {
        this.submitter = submitter;
    }

    public List<Lookup> getAllAppointmentTypes() {
        return allAppointmentTypes;
    }

    public void setAllAppointmentTypes(List<Lookup> allAppointmentTypes) {
        this.allAppointmentTypes = allAppointmentTypes;
    }

    public List<Lookup> getAllStaffTypes() {
        return allStaffTypes;
    }

    public void setAllStaffTypes(List<Lookup> allStaffTypes) {
        this.allStaffTypes = allStaffTypes;
    }

    public List<Lookup> getAllDayParts() {
        return allDayParts;
    }

    public void setAllDayParts(List<Lookup> allDayParts) {
        this.allDayParts = allDayParts;
    }

    public List<Lookup> getAllEducationTypes() {
        return allEducationTypes;
    }

    public void setAllEducationTypes(List<Lookup> allEducationTypes) {
        this.allEducationTypes = allEducationTypes;
    }

    public List<Lookup> getAllFunctions() {
        return allFunctions;
    }

    public void setAllFunctions(List<Lookup> allFunctions) {
        this.allFunctions = allFunctions;
    }

    public List<Lookup> getAllFunctionLevels() {
        return allFunctionLevels;
    }

    public void setAllFunctionLevels(List<Lookup> allFunctionLevels) {
        this.allFunctionLevels = allFunctionLevels;
    }

    public List<Lookup> getAllContractTypes() {
        return allContractTypes;
    }

    public void setAllContractTypes(List<Lookup> allContractTypes) {
        this.allContractTypes = allContractTypes;
    }

    public List<Lookup> getAllContractDurations() {
        return allContractDurations;
    }

    public void setAllContractDurations(List<Lookup> allContractDurations) {
        this.allContractDurations = allContractDurations;
    }

    public List<Lookup5> getAllProvinces() {
        return allProvinces;
    }

    public void setAllProvinces(List<Lookup5> allProvinces) {
        this.allProvinces = allProvinces;
    }

    public List<Lookup> getAllDistricts() {
        return allDistricts;
    }

    public void setAllDistricts(List<Lookup> allDistricts) {
        this.allDistricts = allDistricts;
    }

    public List<Lookup4> getAllAdministrativePosts() {
        return allAdministrativePosts;
    }

    public void setAllAdministrativePosts(List<Lookup4> allAdministrativePosts) {
        this.allAdministrativePosts = allAdministrativePosts;
    }

    public Map<String , String> getPhotographProperties() {
        return photographProperties;
    }

    public void setPhotographProperties(Map<String , String> photographProperties) {
        this.photographProperties = photographProperties;
    }

    public MultipartFile getPhotograph() {
        return photograph;
    }

    public void setPhotograph(MultipartFile photograph) {
        this.photograph = photograph;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        if (codeToStudyTimeMap == null) {
            codeToStudyTimeMap = new CodeToLookupMap(allStudyTimes);
        }
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public List<Lookup> getAllStudyTimes() {
        return allStudyTimes;
    }

    public void setAllStudyTimes(List<Lookup> allStudyTimes) {
        this.allStudyTimes = allStudyTimes;
    }

    public IdToExaminationMap getIdToExaminationMap() {
        return idToExaminationMap;
    }

    public void setIdToExaminationMap(IdToExaminationMap idToExaminationMap) {
        this.idToExaminationMap = idToExaminationMap;
    }

    public IdToTestMap getIdToTestMap() {
        return idToTestMap;
    }

    public void setIdToTestMap(IdToTestMap idToTestMap) {
        this.idToTestMap = idToTestMap;
    }

    public String getCurrentPassword() {
        return currentPassword;
    }

    public void setCurrentPassword(String currentPassword) {
        this.currentPassword = currentPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

}
