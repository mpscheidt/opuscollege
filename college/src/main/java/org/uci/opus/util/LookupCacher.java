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

package org.uci.opus.util;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup1;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.Lookup2;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup4;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.extpoint.DBUpgradeListener;
import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;
import org.uci.opus.util.lookup.LookupUtil;

// Note MP 2012-12-18: This cache does not work.
// The values are always newly read from the DB.
// The problem is that preferredLanguage and the items' lang field never match:
// one is of String length 2, the other 6.
// Spring offers cache integration with e.g. EHCache which allows eviction of stale data
// Eviction should happen e.g. when data is changed via the lookup edit screens.

public class LookupCacher implements DBUpgradeListener {

    private static Logger log = LoggerFactory.getLogger(LookupCacher.class);

    private LookupManagerInterface lookupManager;
    
    @Autowired
    private ApplicationContext context;

    /* person */
    private List < Lookup > allCivilTitles;
    private List <Lookup9> allGradeTypes;
    private List < Lookup > allGenders;
    private List < Lookup1 > allNationalities;
    private List < Lookup > allNationalityGroups;
    private List < Lookup > allDistrictsOfBirth;
    private List < Lookup5 > allProvincesOfBirth;
    private List < Lookup > allDistrictsOfOrigin;
    private List < Lookup5 > allProvincesOfOrigin;
    private List < Lookup > allCivilStatuses;
    private List < Lookup > allIdentificationTypes;
    private List <Lookup > allProfessions;
    private List < Lookup1 > allLanguages;
    private List < Lookup > allMasteringLevels;
    private List < Lookup > allBloodTypes;
    private List<Lookup> allEducationTypes;
    /* staffmember */
    private List<Lookup> allAppointmentTypes;
    private List<Lookup> allStaffTypes;
    private List<Lookup> allFunctions;
    private List<Lookup> allFunctionLevels;
    private List<Lookup> allDayParts;
    /* contract */
    private List<Lookup> allContractTypes;
    private List<Lookup> allContractDurations;
    /* address */
    private List < Lookup > allAddressTypes;
    private List<Lookup4> allAdministrativePosts;
    private List<Lookup> allDistricts;
    private List<Lookup5> allProvinces;
    private List < Lookup3 > allCountries;
    private List <  Lookup5 > allProvincesForAddress;
    private List <  Lookup > allDistrictsForAddress;
    private List <  Lookup4 > allAdministrativePostsForAddress;
    /* organizationalunit */
    private List <  Lookup > allAcademicFields;
    private List <  Lookup > allUnitAreas;
    private List <  Lookup > allUnitTypes;
    /* study */
    private List<Lookup> allStudyForms;
    private List<Lookup> allStudyTimes;
    private List<Lookup> allStudyIntensities;
    private List <  Lookup > allTargetGroups;
    private List<Lookup8> allCardinalTimeUnits;
    private List <  Lookup > allBlockTypes;
    /* previousInstitution */
    private List <  Lookup3 > allCountriesForPreviousInstitution;
    private List <  Lookup5 > allProvincesForPreviousInstitution;
    private List <  Lookup >  allDistrictsForPreviousInstitution;
    
    /* student */
    private List <  Lookup > allStudentStatuses;
    // allThesisStatuses is part of the student lookups but also of the thesis lookups
//    List <  Lookup > allThesisStatuses;
    private List <  Lookup > allPreviousInstitutionDistricts;
    private List <  Lookup5 > allPreviousInstitutionProvinces;
    private List <  Lookup > allRelationTypes;
    private List <  Lookup > allLevelsOfEducation;
    private List <  Lookup > allExpellationTypes;
    private List <  Lookup > allPenaltyTypes;
    
    private List <  Lookup > allThesisStatuses;

    /* subject */
    private List<Lookup> allRigidityTypes;
    private List<Lookup> allImportanceTypes;
    private List <  Lookup > allFrequencies;
    private List <  Lookup > allExamTypes;
    private List <  Lookup > allStudyTypes;
    
    /* examination */
    private List <  Lookup > allExaminationTypes;

    /* rfcstatuses */
    private List <  Lookup > allRfcStatuses;
    
    /* studyPlan */
    private List<Lookup> allStudyPlanStatuses;
    private List<Lookup> allCardinalTimeUnitStatuses;
    private List < Lookup7 > allProgressStatuses;
    private List<Lookup> allApplicantCategories;


    // language -> List<Lookup>
    private Map<String, List<Lookup>> allAcademicFieldsMap = new HashMap<>();
    private Map<String, List<Lookup>> allAddressTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allBloodTypesMap = new HashMap<>();
    private Map<LookupCacherKey, List<Lookup8>> allCardinalTimeUnitsMap = new HashMap<>();
    private Map<String, List<Lookup>> allCardinalTimeUnitStatusesMap = new HashMap<>();
    private Map<String, List<Lookup>> allCivilStatusMap = new HashMap<>();
    private Map<String, List<Lookup>> allCivilTitlesMap = new HashMap<>();
    private Map<String, List<Lookup3>> allCountriesMap = new HashMap<>();
    private Map<String, List<Lookup>> allEducationAreasMap = new HashMap<>();
    private Map<String, List<Lookup>> allEducationLevelsMap = new HashMap<>();
    private Map<String, List<Lookup10>> allExaminationTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allGendersMap = new HashMap<>();
    private Map<String, List<Lookup9>> allGradeTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allImportanceTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allInstitutionTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allLevelsOfEducationMap = new HashMap<>();
    private Map<String, List<Lookup>> allMasteringLevelsMap = new HashMap<>();
    private Map<String, List<Lookup1>> allNationalitiesMap = new HashMap<>();
    private Map<String, List<Lookup>> allNationalityGroupsMap = new HashMap<>();
    private Map<String, List<Lookup7>> allProgressStatusesMap = new HashMap<>();
    private Map<String, List<Lookup5>> allProvincesMap = new HashMap<>();
    private Map<String, List<Lookup>> allRigidityTypesMap = new HashMap<>();
    private Map<String, List<Lookup>> allStudyFormsMap = new HashMap<>();
    private Map<String, List<Lookup>> allStudentStatusesMap = new HashMap<>();
    private Map<String, List<Lookup>> allStudyIntensitiesMap = new HashMap<>();
    private Map<String, List<Lookup>> allStudyPlanStatusesMap = new HashMap<>();
    private Map<String, List<Lookup>> allStudyTimesMap = new HashMap<>();
    private Map<String, List<Lookup>> allUnitAreasMap = new HashMap<>();
    private Map<String, List<Lookup>> allUnitTypesMap = new HashMap<>();

    
    // 3rd iteration: meta level: use lookup table names as keys and store all in one data structure to procude lookup lists and codeToLokupMaps.

    private Map<String, LookupLists> lookupListsPerLang = new HashMap<>();
    private Map<String, LookupMaps> lookupMapsPerLang = new HashMap<>();

    public LookupLists  getLookupLists(String lang) {
        LookupLists lists = lookupListsPerLang.get(lang);
        if (lists == null) {
            lists = context.getBean(LookupLists.class, lang);
            lookupListsPerLang.put(lang, lists);
        }
        return lists;
    }

    public LookupMaps  getLookupMaps(String lang) {
        LookupMaps maps = lookupMapsPerLang.get(lang);
        if (maps == null) {
            maps = context.getBean(LookupMaps.class, getLookupLists(lang));
            lookupMapsPerLang.put(lang, maps);
        }
        return maps;
    }


//    public void refreshLookups(String preferredLanguage, HttpServletRequest request) {
//
//        /* first empty all values */
//        /* person */
//        allCivilTitles = null;
//        allGradeTypes = null;
//        allGenders = null;
//        allNationalities = null;
//        allDistrictsOfBirth = null;
//        allProvincesOfBirth = null;
//        allDistrictsOfOrigin = null;
//        allProvincesOfOrigin = null;
//        allCivilStatuses = null;
//        allIdentificationTypes = null;
//        allProfessions = null;
//        allLanguages = null;
//        allMasteringLevels = null;
//        allBloodTypes = null;
//        allEducationTypes = null;
//        /* staffmember */
//        allAppointmentTypes = null;
//        allStaffTypes = null;
//        allFunctions = null;
//        allFunctionLevels = null;
//        /* contract */
//        allContractTypes = null;
//        allContractDurations = null;
//        /* address */
//        allAddressTypes = null;
//        allAdministrativePosts = null;
//        allDistricts = null;
//        allProvinces = null;
//        allCountries = null;
//        allProvincesForAddress = null;
//        allDistrictsForAddress = null;
//        allAdministrativePostsForAddress = null;
//        /* previousInstitution */
//        setAllCountriesForPreviousInstitution(null);
//        allProvincesForPreviousInstitution = null;
//        allDistrictsForPreviousInstitution = null;
//        /* organizationalunit */
//        allAcademicFields = null;
//        allUnitAreas = null;
//        allUnitTypes = null;
//        /* study */
//        allStudyForms = null;
//        allStudyTimes = null;
//        allStudyIntensities = null;
//        allTargetGroups = null;
//        allCardinalTimeUnits = null;
//        /* student */
//        allStudentStatuses = null;
//        allPreviousInstitutionDistricts = null;
//        allPreviousInstitutionProvinces = null;
//        allRelationTypes = null;
//        allLevelsOfEducation = null;
//        allExpellationTypes = null;
//        allPenaltyTypes = null;
//        //allAcademicYears= null;
//        allThesisStatuses = null;
//        /* subject */
//        allRigidityTypes = null;
//        allImportanceTypes = null;
//        allFrequencies = null;
//        allExamTypes = null;
//        allStudyTypes = null;
//        /* examination */
//        allExaminationTypes = null;
//        /* exam */
//        //allMarkEvaluations= null;
//        /* rfc statuses */
//        allRfcStatuses = null;
//        /* studyPlan */
//        allStudyPlanStatuses = null;
//        allProgressStatuses = null;
//        allApplicantCategories = null;
//        
//        getPersonLookups(preferredLanguage, request);
//        getStaffMemberLookups(preferredLanguage, request);
//        getContractLookups(preferredLanguage, request);
//        getAddressLookups(preferredLanguage, request);
//        getOrganizationalUnitLookups(preferredLanguage, request);
//        getInstitutionLookups(preferredLanguage, request);
//        getStudyLookups(preferredLanguage, request);
//        getStudentLookups(preferredLanguage, request);
//        getSubjectLookups(preferredLanguage, request);
//        getExaminationLookups(preferredLanguage, request);
//        getAllRfcStatuses(preferredLanguage, request);
//        getStudyPlanLookups(preferredLanguage, request);
//        
//    }

    public void getPersonLookups(String preferredLanguage, HttpServletRequest request) {
        if (allCivilTitles == null) {
            allCivilTitles = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "civilTitle");
        } else {
            if (allCivilTitles.size() == 0 || (allCivilTitles.size() != 0 && !preferredLanguage.equals(allCivilTitles.get(0).getLang()))) {
                allCivilTitles = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "civilTitle");
            }
        }
        request.setAttribute("allCivilTitles", allCivilTitles);
        if (allGradeTypes == null) {
            allGradeTypes = lookupManager.findAllRows(preferredLanguage, "gradeType");
        } else {
            if (allGradeTypes.size() == 0 || (allGradeTypes.size() != 0 && !preferredLanguage.equals(allGradeTypes.get(0).getLang()))) {
                allGradeTypes = lookupManager.findAllRows(preferredLanguage, "gradeType");
            }
        }
        request.setAttribute("allGradeTypes", allGradeTypes);
        if (allGenders == null) {
            allGenders = (List <Lookup>) lookupManager.findAllRows(preferredLanguage, "gender");
        } else {
            if (allGenders.size() == 0 || (allGenders.size() != 0 && !preferredLanguage.equals(allGenders.get(0).getLang()))) {
                allGenders = (List <Lookup>) lookupManager.findAllRows(preferredLanguage, "gender");
            }
        }
        request.setAttribute("allGenders", allGenders);
        if (allNationalities == null) {
            allNationalities = lookupManager.findAllRows(preferredLanguage, "nationality");
        } else {
            if (allNationalities.size() == 0 || (allNationalities.size() != 0 && !preferredLanguage.equals(allNationalities.get(0).getLang()))) {
                allNationalities = lookupManager.findAllRows(preferredLanguage, "nationality");
            }
        }
        request.setAttribute("allNationalities", allNationalities);
        
        if (allNationalityGroups == null) {
            allNationalityGroups = lookupManager.findAllRows(preferredLanguage, "nationalitygroup");
        } else {
            if (allNationalityGroups.size() == 0 || (allNationalityGroups.size() != 0 && !preferredLanguage.equals(allNationalityGroups.get(0).getLang()))) {
                allNationalityGroups = lookupManager.findAllRows(preferredLanguage, "nationalitygroup");
            }
        }
        request.setAttribute("allNationalityGroups", allNationalityGroups);

        String countryOfBirthCode = "";
        if (request.getParameter("countryOfBirthCode") != null) {
            countryOfBirthCode = request.getParameter("countryOfBirthCode");
        } else {
            if (request.getAttribute("countryOfBirthCode") != null) {
                countryOfBirthCode = (String) request.getAttribute("countryOfBirthCode");
            }
        }
        if (!"".equals(countryOfBirthCode) && !"0".equals(countryOfBirthCode)) {
            allProvincesOfBirth = lookupManager.findAllRowsForCode(
                    preferredLanguage, "province", "countryCode", countryOfBirthCode);
        } else {
           if (allProvincesOfBirth == null) {
               allProvincesOfBirth = lookupManager.findAllRows(preferredLanguage, "province");
           } else {
               if (allProvincesOfBirth.size() == 0 || (allProvincesOfBirth.size() != 0 && !preferredLanguage.equals(allProvincesOfBirth.get(0).getLang()))) {
                   allProvincesOfBirth = lookupManager.findAllRows(preferredLanguage, "province");
               }
           }
        }
        request.setAttribute("allProvincesOfBirth", allProvincesOfBirth);
        
        String provinceOfBirthCode = "";
        if (request.getParameter("provinceOfBirthCode") != null) {
            for (int i = 0; i < allProvincesOfBirth.size(); i++) {
                if (allProvincesOfBirth.get(i).getCode().equals(request.getParameter("provinceOfBirthCode"))) {
                    provinceOfBirthCode = request.getParameter("provinceOfBirthCode");
                }
            }
        } else {
            if (request.getAttribute("provinceOfBirthCode") != null) {
                for (int i = 0; i < allProvincesOfBirth.size(); i++) {
                    if (allProvincesOfBirth.get(i).getCode().equals((String) request.getAttribute("provinceOfBirthCode"))) {
                        provinceOfBirthCode = (String) request.getAttribute("provinceOfBirthCode");
                    }
                }
            }
        }
        if (!"".equals(provinceOfBirthCode) && !"0".equals(provinceOfBirthCode)) {
            allDistrictsOfBirth = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceOfBirthCode);
        } else {
              allDistrictsOfBirth = null;
        }
        request.setAttribute("allDistrictsOfBirth", allDistrictsOfBirth);

        String countryOfOriginCode = "";
        if (request.getParameter("countryOfOriginCode") != null) {
            countryOfOriginCode = request.getParameter("countryOfOriginCode");
        } else {
            if (request.getAttribute("countryOfOriginCode") != null) {
                countryOfOriginCode = (String) request.getAttribute("countryOfOriginCode");
            }
        }
        if (!"".equals(countryOfOriginCode) && !"0".equals(countryOfOriginCode)) {
            allProvincesOfOrigin = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryOfOriginCode);
        } else {
            if (allProvincesOfOrigin == null) {
                allProvincesOfOrigin = lookupManager.findAllRows(preferredLanguage, "province");
            } else {
                if (allProvincesOfOrigin.size() == 0 || (allProvincesOfOrigin.size() != 0 && !preferredLanguage.equals(allProvincesOfOrigin.get(0).getLang()))) {
                    allProvincesOfOrigin = lookupManager.findAllRows(preferredLanguage, "province");
                }
            }
        }
        request.setAttribute("allProvincesOfOrigin", allProvincesOfOrigin);
        String provinceOfOriginCode = "";
        if (request.getParameter("provinceOfOriginCode") != null) {
            for (int i = 0; i < allProvincesOfOrigin.size(); i++) {
                if (allProvincesOfOrigin.get(i).getCode().equals(request.getParameter("provinceOfOriginCode"))) {
                    provinceOfOriginCode = request.getParameter("provinceOfOriginCode");
                }
            }
        } else {
            if (request.getAttribute("provinceOfOriginCode") != null) {
                for (int i = 0; i < allProvincesOfOrigin.size(); i++) {
                    if (allProvincesOfOrigin.get(i).getCode().equals( (String) request.getAttribute("provinceOfOriginCode"))) {
                        provinceOfOriginCode = (String) request.getAttribute("provinceOfOriginCode");
                    }
                }
            }
        }
        if (!"".equals(provinceOfOriginCode) && !"0".equals(provinceOfOriginCode)) {
            allDistrictsOfOrigin = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceOfOriginCode);
        } else {
              allDistrictsOfOrigin = null;
        }
        request.setAttribute("allDistrictsOfOrigin", allDistrictsOfOrigin);
        
        if (allCivilStatuses == null) {
            allCivilStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "civilStatus");
        } else {
            if (allCivilStatuses.size() == 0 || (allCivilStatuses.size() != 0 && !preferredLanguage.equals(allCivilStatuses.get(0).getLang()))) {
                allCivilStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "civilStatus");
            }
        }
        request.setAttribute("allCivilStatuses", allCivilStatuses);
        if (allIdentificationTypes == null) {
            allIdentificationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "identificationType");
        } else {
            if (allIdentificationTypes.size() == 0 || (allIdentificationTypes.size() != 0 && !preferredLanguage.equals(allIdentificationTypes.get(0).getLang()))) {
                allIdentificationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "identificationType");
            }
        }
        request.setAttribute("allIdentificationTypes", allIdentificationTypes);
        if (allProfessions == null) {
            allProfessions = lookupManager.findAllRows(preferredLanguage, "profession");
        } else {
            if (allProfessions.size() == 0 || (allProfessions.size() != 0 && !preferredLanguage.equals(allProfessions.get(0).getLang()))) {
                allProfessions = lookupManager.findAllRows(preferredLanguage, "profession");
            }
        }
        request.setAttribute("allProfessions", allProfessions);
        if (allLanguages == null) {
            allLanguages = lookupManager.findAllRows(preferredLanguage, "language");
        } else {
            if (allLanguages.size() == 0 || (allLanguages.size() != 0 && !preferredLanguage.equals(allLanguages.get(0).getLang()))) {
                allLanguages = lookupManager.findAllRows(preferredLanguage, "language");
            }
        }
        request.setAttribute("allLanguages", allLanguages);
        if (allMasteringLevels == null) {
            allMasteringLevels = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "masteringLevel");
        } else {
            if (allMasteringLevels.size() == 0 || (allMasteringLevels.size() != 0 && !preferredLanguage.equals(allMasteringLevels.get(0).getLang()))) {
                allMasteringLevels = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "masteringLevel");
            }
        }
        request.setAttribute("allMasteringLevels", allMasteringLevels);
        if (allBloodTypes == null) {
            allBloodTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "bloodType");
        } else {
            if (allBloodTypes.size() == 0 || (allBloodTypes.size() != 0 && !preferredLanguage.equals(allBloodTypes.get(0).getLang()))) {
                allBloodTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "bloodType");
            }
        }
        request.setAttribute("allBloodTypes", allBloodTypes);

        if (allEducationTypes == null) {
            allEducationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "educationType");
        } else {
            if (allEducationTypes.size() == 0 || (allEducationTypes.size() != 0 && !preferredLanguage.equals(allEducationTypes.get(0).getLang()))) {
                allEducationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "educationType");
            }
        }
        request.setAttribute("allEducationTypes", allEducationTypes);
    }

    public void getStaffMemberLookups(String preferredLanguage, HttpServletRequest request) {
        if (allAppointmentTypes == null) {
            allAppointmentTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "appointmentType");
        } else {
            if (allAppointmentTypes.size() == 0 || (allAppointmentTypes.size() != 0 && !preferredLanguage.equals(allAppointmentTypes.get(0).getLang()))) {
                allAppointmentTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "appointmentType");
            }
        }
        request.setAttribute("allAppointmentTypes", allAppointmentTypes);
        if (allStaffTypes == null) {
            allStaffTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "staffType");
        } else {
            if (allStaffTypes.size() == 0 || (allStaffTypes.size() != 0 && !preferredLanguage.equals(allStaffTypes.get(0).getLang()))) {
                allStaffTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "staffType");
            }
        }
        request.setAttribute("allStaffTypes", allStaffTypes);
        if (allFunctions == null) {
            allFunctions = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "function");
        } else {
            if (allFunctions.size() == 0 || (allFunctions.size() != 0 && !preferredLanguage.equals(allFunctions.get(0).getLang()))) {
                allFunctions = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "function");
            }
        }
        request.setAttribute("allFunctions", allFunctions);
        if (allFunctionLevels == null) {
            allFunctionLevels = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "functionLevel");
        } else {
            if (allFunctionLevels.size() == 0 || (allFunctionLevels.size() != 0 && !preferredLanguage.equals(allFunctionLevels.get(0).getLang()))) {
                allFunctionLevels = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "functionLevel");
            }
        }
        request.setAttribute("allFunctionLevels", allFunctionLevels);
        if (allDayParts == null) {
            allDayParts = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "dayPart");
        } else {
            if (allDayParts.size() == 0 || (allDayParts.size() != 0 && !preferredLanguage.equals(allDayParts.get(0).getLang()))) {
                allDayParts = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "dayPart");
            }
        }
        request.setAttribute("allDayParts", allDayParts);
    }

    public void getContractLookups(String preferredLanguage, HttpServletRequest request) {
        if (allContractTypes == null) {
            allContractTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "contractType");
        } else {
            if (allContractTypes.size() == 0 || (allContractTypes.size() != 0 && !preferredLanguage.equals(allContractTypes.get(0).getLang()))) {
                allContractTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "contractType");
            }
        }
        request.setAttribute("allContractTypes", allContractTypes);
        if (allContractDurations == null) {
            allContractDurations = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "contractDuration");
        } else {
            if (allContractDurations.size() == 0 || (allContractDurations.size() != 0 && !preferredLanguage.equals(allContractDurations.get(0).getLang()))) {
                allContractDurations = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "contractDuration");
            }
        }
        request.setAttribute("allContractDurations", allContractDurations);
    }

    public void getAddressLookups(String preferredLanguage, HttpServletRequest request) {

        if (allCountries == null) {
            allCountries =  lookupManager.findAllRows(preferredLanguage, "country");
        } else {
            if (allCountries.size() == 0 || (allCountries.size() != 0 && !preferredLanguage.equals(allCountries.get(0).getLang()))) {
                allCountries = lookupManager.findAllRows(preferredLanguage, "country");
            }
        }
        request.setAttribute("allCountries", allCountries);

        String countryCode = "";
        if (request.getParameter("countryCode") != null) {
            countryCode = request.getParameter("countryCode");
        } else {
            if (request.getAttribute("countryCode") != null) {
                countryCode = (String) request.getAttribute("countryCode");
            }
        }

        if (!StringUtil.isNullOrEmpty(countryCode) && !"0".equals(countryCode)) {
            allProvinces = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryCode);
        } else {
            if (allProvinces == null) {
                allProvinces = lookupManager.findAllRows(preferredLanguage, "province");
            } else {
                if (allProvinces.size() == 0 || (allProvinces.size() != 0 && !preferredLanguage.equals(allProvinces.get(0).getLang()))) {
                    allProvinces = lookupManager.findAllRows(preferredLanguage, "province");
                }
            }
        }
        request.setAttribute("allProvinces", allProvinces);

        String provinceCode = "";
        if (request.getAttribute("provinceCode") != null) {
            provinceCode = (String) request.getAttribute("provinceCode");
        }
        if (!StringUtil.isNullOrEmpty(provinceCode) && !"0".equals(provinceCode)) {
            allDistricts = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceCode);
        } else {
            if (request.getAttribute("allDistricts") == null || allDistricts == null) {
                allDistricts = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "district");
            } else {
                if (allDistricts.size() == 0 || (allDistricts.size() != 0 && !preferredLanguage.equals(allDistricts.get(0).getLang()))) {
                    allDistricts = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "district");
                }
            }
        }
        request.setAttribute("allDistricts", allDistricts);

        String districtCode = "";
        if (request.getAttribute("districtCode") != null) {
            districtCode = (String) request.getAttribute("districtCode");
        }

        if (!StringUtil.isNullOrEmpty(districtCode) && !"0".equals(districtCode)) {
            allAdministrativePosts = lookupManager.findAllRowsForCode(preferredLanguage, "administrativePost", "districtCode", districtCode);
        } else {
            if (request.getAttribute("allAdministrativePosts") == null || allAdministrativePosts == null) {
                allAdministrativePosts = lookupManager.findAllRows(preferredLanguage, "administrativePost");
            } else {
                if (allAdministrativePosts.size() == 0 || (allAdministrativePosts.size() != 0 && !preferredLanguage.equals(allAdministrativePosts.get(0).getLang()))) {
                    allAdministrativePosts = lookupManager.findAllRows(preferredLanguage, "administrativePost");
                }
            }
        }
        request.setAttribute("allAdministrativePosts", allAdministrativePosts);

        if (allAddressTypes == null) {
            allAddressTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "addressType");
        } else {
            if (allAddressTypes.size() == 0 || (allAddressTypes.size() != 0 && !preferredLanguage.equals(allAddressTypes.get(0).getLang()))) {
                allAddressTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "addressType");
            }
        }
        request.setAttribute("allAddressTypes", allAddressTypes);
    }

    public void getOrganizationalUnitLookups(String preferredLanguage, HttpServletRequest request) {
        if (allAcademicFields == null) {
            allAcademicFields = lookupManager.findAllRows(preferredLanguage, "academicField");
        } else {
            if (allAcademicFields.size() == 0 || (allAcademicFields.size() != 0 && !preferredLanguage.equals(allAcademicFields.get(0).getLang()))) {
                allAcademicFields = lookupManager.findAllRows(preferredLanguage, "academicField");
            }
        }
        request.setAttribute("allAcademicFields", allAcademicFields);
        if (allUnitAreas == null) {
            allUnitAreas = lookupManager.findAllRows(preferredLanguage, "unitArea");
        } else {
            if (allUnitAreas.size() == 0 || (allUnitAreas.size() != 0 && !preferredLanguage.equals(allUnitAreas.get(0).getLang()))) {
                allUnitAreas = lookupManager.findAllRows(preferredLanguage, "unitArea");
            }
        }
        request.setAttribute("allUnitAreas", allUnitAreas);
        if (allUnitTypes == null) {
            allUnitTypes = lookupManager.findAllRows(preferredLanguage, "unitType");
        } else {
            if (allUnitTypes.size() == 0 || (allUnitTypes.size() != 0 && !preferredLanguage.equals(allUnitTypes.get(0).getLang()))) {
                allUnitTypes = lookupManager.findAllRows(preferredLanguage, "unitType");
            }
        }
        request.setAttribute("allUnitTypes", allUnitTypes);
    }

    public void getInstitutionLookups(String preferredLanguage, HttpServletRequest request) {
//        if (allEducationTypes == null) {
//            allEducationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "educationType");
//        } else {
//            if (allEducationTypes.size() == 0 || (allEducationTypes.size() != 0 && !preferredLanguage.equals(allEducationTypes.get(0).getLang()))) {
//                allEducationTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "educationType");
//            }
//        }
//        request.setAttribute("allEducationTypes", allEducationTypes);

        if (allProvinces == null) {
            allProvinces = lookupManager.findAllRows(preferredLanguage, "province");
        } else {
            if (allProvinces.size() == 0 || (allProvinces.size() != 0 && !preferredLanguage.equals(allProvinces.get(0).getLang()))) {
                allProvinces = lookupManager.findAllRows(preferredLanguage, "province");
            }
        }
        request.setAttribute("allProvinces", allProvinces);
    }

    public void getStudyLookups(String preferredLanguage, HttpServletRequest request) {

        if (allAcademicFields == null) {
            allAcademicFields = lookupManager.findAllRows(preferredLanguage, "academicField");
        } else {
            if (allAcademicFields.size() == 0 || (allAcademicFields.size() != 0 && !preferredLanguage.equals(allAcademicFields.get(0).getLang()))) {
                allAcademicFields = lookupManager.findAllRows(preferredLanguage, "academicField");
            }
        }
        request.setAttribute("allAcademicFields", allAcademicFields);

        if (allStudyForms == null) {
            allStudyForms = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyForm");
        } else {
            if (allStudyForms.size() == 0 || (allStudyForms.size() != 0 && !preferredLanguage.equals(allStudyForms.get(0).getLang()))) {
                allStudyForms = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyForm");
            }
        }
        request.setAttribute("allStudyForms", allStudyForms);

        if (allStudyTimes == null) {
            allStudyTimes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyTime");
        } else {
            if (allStudyTimes.size() == 0 || (allStudyTimes.size() != 0 && !preferredLanguage.equals(allStudyTimes.get(0).getLang()))) {
                allStudyTimes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyTime");
            }
        }
        request.setAttribute("allStudyTimes", allStudyTimes);

        if (allStudyIntensities == null) {
            allStudyIntensities = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyIntensity");
        } else {
            if (allStudyIntensities.size() == 0 || (allStudyIntensities.size() != 0 && !preferredLanguage.equals(allStudyIntensities.get(0).getLang()))) {
                allStudyIntensities = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyIntensity");
            }
        }
        request.setAttribute("allStudyIntensities", allStudyIntensities);

        if (allTargetGroups == null) {
            allTargetGroups = lookupManager.findAllRows(preferredLanguage, "targetGroup");
        } else {
            if (allTargetGroups.size() == 0 || (allTargetGroups.size() != 0 && !preferredLanguage.equals(allTargetGroups.get(0).getLang()))) {
                allTargetGroups = lookupManager.findAllRows(preferredLanguage, "targetGroup");
            }
        }
        request.setAttribute("allTargetGroups", allTargetGroups);

        if (allCardinalTimeUnits == null) {
            allCardinalTimeUnits = lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnit");
        } else {
            if (allCardinalTimeUnits.size() == 0 || (allCardinalTimeUnits.size() != 0 && !preferredLanguage.equals(allCardinalTimeUnits.get(0).getLang()))) {
                allCardinalTimeUnits = lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnit");
            }
        }
        request.setAttribute("allCardinalTimeUnits", allCardinalTimeUnits);

        if (allBlockTypes == null) {
            allBlockTypes = lookupManager.findAllRows(preferredLanguage, "blockType");
        } else {
            if (allBlockTypes.size() == 0 || (allBlockTypes.size() != 0 && !preferredLanguage.equals(allBlockTypes.get(0).getLang()))) {
                allBlockTypes = lookupManager.findAllRows(preferredLanguage, "blockType");
            }
        }
        request.setAttribute("allBlockTypes", allBlockTypes);

    }

    public void getStudentLookups(String preferredLanguage, HttpServletRequest request) {
        if (allStudentStatuses == null) {
            allStudentStatuses = lookupManager.findAllRows(preferredLanguage, "studentStatus");
        } else {
            if (allStudentStatuses.size() == 0 || (allStudentStatuses.size() != 0 && !preferredLanguage.equals(allStudentStatuses.get(0).getLang()))) {
                allStudentStatuses = lookupManager.findAllRows(preferredLanguage, "studentStatus");
            }
        }
        request.setAttribute("allStudentStatuses", allStudentStatuses);

        if (allThesisStatuses == null) {
            allThesisStatuses = lookupManager.findAllRows(preferredLanguage, "thesisStatus");
        } else {
            if (allThesisStatuses.size() == 0 || (allThesisStatuses.size() != 0 && !preferredLanguage.equals(allThesisStatuses.get(0).getLang()))) {
                allThesisStatuses = lookupManager.findAllRows(preferredLanguage, "thesisStatus");
            }
        }
        request.setAttribute("allThesisStatuses", allThesisStatuses);

        String previousInstitutionCountryCode = "";
        if (request.getParameter("previousInstitutionCountryCode") != null) {
            previousInstitutionCountryCode = request.getParameter("previousInstitutionCountryCode");
        } else {
            if (request.getAttribute("previousInstitutionCountryCode") != null) {
                previousInstitutionCountryCode = (String) request.getAttribute("previousInstitutionCountryCode");
            }
        }
        if (!"".equals(previousInstitutionCountryCode) && !"0".equals(previousInstitutionCountryCode)) {
            allPreviousInstitutionProvinces = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode",
                    previousInstitutionCountryCode);
        } else {
            if (allPreviousInstitutionProvinces == null) {
                allPreviousInstitutionProvinces = lookupManager.findAllRows(preferredLanguage, "province");
            } else {
                if (allPreviousInstitutionProvinces.size() == 0
                        || (allPreviousInstitutionProvinces.size() != 0 && !preferredLanguage.equals(allPreviousInstitutionProvinces.get(0).getLang()))) {
                    allPreviousInstitutionProvinces = lookupManager.findAllRows(preferredLanguage, "province");
                }
            }
        }
        request.setAttribute("allPreviousInstitutionProvinces", allPreviousInstitutionProvinces);
        String previousInstitutionProvinceCode = "";
        if (request.getParameter("previousInstitutionProvinceCode") != null) {
            for (int i = 0; i < allPreviousInstitutionProvinces.size(); i++) {
                if (allPreviousInstitutionProvinces.get(i).getCode().equals(request.getParameter("previousInstitutionProvinceCode"))) {
                    previousInstitutionProvinceCode = request.getParameter("previousInstitutionProvinceCode");
                }
            }
        } else {
            if (request.getAttribute("previousInstitutionProvinceCode") != null) {
                for (int i = 0; i < allPreviousInstitutionProvinces.size(); i++) {
                    if (allPreviousInstitutionProvinces.get(i).getCode().equals((String) request.getAttribute("previousInstitutionProvinceCode"))) {
                        previousInstitutionProvinceCode = (String) request.getAttribute("previousInstitutionProvinceCode");
                    }
                }
            }
        }
        if (!"".equals(previousInstitutionProvinceCode) && !"0".equals(previousInstitutionProvinceCode)) {
            allPreviousInstitutionDistricts = lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode",
                    previousInstitutionProvinceCode);
        } else {
            allPreviousInstitutionDistricts = null;
        }
        request.setAttribute("allPreviousInstitutionDistricts", allPreviousInstitutionDistricts);

        if (allRelationTypes == null) {
            allRelationTypes = lookupManager.findAllRows(preferredLanguage, "relationType");
        } else {
            if (allRelationTypes.size() == 0 || (allRelationTypes.size() != 0 && !preferredLanguage.equals(allRelationTypes.get(0).getLang()))) {
                allRelationTypes = lookupManager.findAllRows(preferredLanguage, "relationType");
            }
        }
        request.setAttribute("allRelationTypes", allRelationTypes);

        if (allLevelsOfEducation == null) {
            allLevelsOfEducation = lookupManager.findAllRows(preferredLanguage, "levelOfEducation");
        } else {
            if (allLevelsOfEducation.size() == 0 || (allLevelsOfEducation.size() != 0 && !preferredLanguage.equals(allLevelsOfEducation.get(0).getLang()))) {
                allLevelsOfEducation = lookupManager.findAllRows(preferredLanguage, "levelOfEducation");
            }
        }
        request.setAttribute("allLevelsOfEducation", allLevelsOfEducation);

        if (allExpellationTypes == null) {
            allExpellationTypes = lookupManager.findAllRows(preferredLanguage, "expellationType");
        } else {
            if (allExpellationTypes.size() == 0 || (allExpellationTypes.size() != 0 && !preferredLanguage.equals(allExpellationTypes.get(0).getLang()))) {
                allExpellationTypes = lookupManager.findAllRows(preferredLanguage, "expellationType");
            }
        }
        request.setAttribute("allExpellationTypes", allExpellationTypes);

        if (allPenaltyTypes == null) {
            allPenaltyTypes = lookupManager.findAllRows(preferredLanguage, "penaltyType");
        } else {
            if (allPenaltyTypes.size() == 0 || (allPenaltyTypes.size() != 0 && !preferredLanguage.equals(allPenaltyTypes.get(0).getLang()))) {
                allPenaltyTypes = lookupManager.findAllRows(preferredLanguage, "penaltyType");
            }
        }
        request.setAttribute("allPenaltyTypes", allPenaltyTypes);
    }

    public void getSubjectLookups(String preferredLanguage, HttpServletRequest request) {

        // TARGETGROUPS
        if (allTargetGroups == null || allTargetGroups.size() == 0 || !preferredLanguage.equals(allTargetGroups.get(0).getLang())) {
            allTargetGroups = lookupManager.findAllRows(preferredLanguage, "targetGroup");
        }
        request.setAttribute("allTargetGroups", allTargetGroups);

        // CARDINAL TIME UNITS
        if (allCardinalTimeUnits == null) {
            allCardinalTimeUnits = lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnit");
        } else {
            if (allCardinalTimeUnits.size() == 0 || (allCardinalTimeUnits.size() != 0 && !preferredLanguage.equals(allCardinalTimeUnits.get(0).getLang()))) {
                allCardinalTimeUnits = lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnit");
            }
        }
        request.setAttribute("allCardinalTimeUnits", allCardinalTimeUnits);

        // RIGIDITYTYPES
        if (allRigidityTypes == null || allRigidityTypes.size() == 0 || !preferredLanguage.equals(allRigidityTypes.get(0).getLang())) {
            allRigidityTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "rigidityType");
        }
        request.setAttribute("allRigidityTypes", allRigidityTypes);

        // IMPORTANCETYPES
        if (allImportanceTypes == null || allImportanceTypes.size() == 0 || !preferredLanguage.equals(allImportanceTypes.get(0).getLang())) {
            allImportanceTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "importanceType");
        }
        request.setAttribute("allImportanceTypes", allImportanceTypes);

        // FREQUENCIES
        if (allFrequencies == null || allFrequencies.size() == 0 || !preferredLanguage.equals(allFrequencies.get(0).getLang())) {
            allFrequencies = lookupManager.findAllRows(preferredLanguage, "frequency");
        }
        request.setAttribute("allFrequencies", allFrequencies);

        // EXAMTYPES
        if (allExamTypes == null || allExamTypes.size() == 0 || !preferredLanguage.equals(allExamTypes.get(0).getLang())) {
            allExamTypes = lookupManager.findAllRows(preferredLanguage, "examType");
        }
        request.setAttribute("allExamTypes", allExamTypes);

        // STUDYFORMS
        if (allStudyForms == null || allStudyForms.size() == 0 || !preferredLanguage.equals(allStudyForms.get(0).getLang())) {
            allStudyForms = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyForm");
        }
        request.setAttribute("allStudyForms", allStudyForms);

        // STUDYTIMES
        if (allStudyTimes == null || allStudyTimes.size() == 0 || !preferredLanguage.equals(allStudyTimes.get(0).getLang())) {
            allStudyTimes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyTime");
        }
        request.setAttribute("allStudyTimes", allStudyTimes);

        // STUDYFORMS
        if (allStudyIntensities == null || allStudyIntensities.size() == 0 || !preferredLanguage.equals(allStudyIntensities.get(0).getLang())) {
            allStudyIntensities = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyIntensity");
        }
        request.setAttribute("allStudyIntensities", allStudyIntensities);

        // STUDYTYPES
        if (allStudyTypes == null || allStudyTypes.size() == 0 || !preferredLanguage.equals(allStudyTypes.get(0).getLang())) {
            allStudyTypes = lookupManager.findAllRows(preferredLanguage, "studyType");
        }
        request.setAttribute("allStudyTypes", allStudyTypes);
    }

    public void getExaminationLookups(String preferredLanguage, HttpServletRequest request) {

        // EXAMINATION TYPES
        if (allExaminationTypes == null || allExaminationTypes.size() == 0 || !preferredLanguage.equals(allExaminationTypes.get(0).getLang())) {
            allExaminationTypes = lookupManager.findAllRows(preferredLanguage, "examinationType");
        }
        request.setAttribute("allExaminationTypes", allExaminationTypes);
    }

    public void getAllRfcStatuses(String preferredLanguage, HttpServletRequest request) {

        if (allRfcStatuses == null) {
            allRfcStatuses = lookupManager.findAllRows(preferredLanguage, "rfcStatus");
        } else {
            if (allRfcStatuses.size() == 0 || (allRfcStatuses.size() != 0 && !preferredLanguage.equals(allRfcStatuses.get(0).getLang()))) {
                allRfcStatuses = lookupManager.findAllRows(preferredLanguage, "rfcStatus");
            }
        }
        request.setAttribute("allRfcStatuses", allRfcStatuses);
    }

    public void getStudyPlanLookups(String preferredLanguage, HttpServletRequest request) {

        if (allStudyPlanStatuses == null) {
            allStudyPlanStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyPlanStatus");
        } else {
            if (allStudyPlanStatuses.size() == 0 || (allStudyPlanStatuses.size() != 0 && !preferredLanguage.equals(allStudyPlanStatuses.get(0).getLang()))) {
                allStudyPlanStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "studyPlanStatus");
            }
        }
        request.setAttribute("allStudyPlanStatuses", allStudyPlanStatuses);

        if (allCardinalTimeUnitStatuses == null) {
            allCardinalTimeUnitStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnitStatus");
        } else {
            if (allCardinalTimeUnitStatuses.size() == 0 || (allCardinalTimeUnitStatuses.size() != 0 && !preferredLanguage.equals(allCardinalTimeUnitStatuses.get(0).getLang()))) {
                allCardinalTimeUnitStatuses = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "cardinalTimeUnitStatus", "code");
            }
        }
        request.setAttribute("allCardinalTimeUnitStatuses", allCardinalTimeUnitStatuses);

        if (allProgressStatuses == null) {
            allProgressStatuses = lookupManager.findAllRows(preferredLanguage, "progressStatus");
        } else {
            if (allProgressStatuses.size() == 0 || (allProgressStatuses.size() != 0 && !preferredLanguage.equals(allProgressStatuses.get(0).getLang()))) {
                allProgressStatuses = lookupManager.findAllRows(preferredLanguage, "progressStatus");
            }
        }
        request.setAttribute("allProgressStatuses", allProgressStatuses);

        if (allApplicantCategories == null) {
            allApplicantCategories = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "applicantCategory");
        } else {
            if (ListUtil.isNullOrEmpty(allApplicantCategories) || (allApplicantCategories.size() != 0 && !preferredLanguage.equals(allApplicantCategories.get(0).getLang()))) {
                allApplicantCategories = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "applicantCategory");
            }
        }
        request.setAttribute("allApplicantCategories", allApplicantCategories);
    }

    public void getRequestAdmissionLookups(String preferredLanguage, HttpServletRequest request) {

        // also in getAddressLookups, but different checks
        if (ListUtil.isNullOrEmpty(allCountries) || (allCountries.size() != 0 && !preferredLanguage.equals(allCountries.get(0).getLang()))) {
            allCountries = lookupManager.findAllRows(preferredLanguage, "country");
        }
        request.setAttribute("allCountries", allCountries);

        String countryCode = "";
        if (request.getAttribute("countryCode") != null) {
            countryCode = (String) request.getAttribute("countryCode");
        }

        if (!StringUtil.isNullOrEmpty(countryCode) && !"0".equals(countryCode)) {
            allProvinces = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryCode);
        } else {
            allProvinces = null;
        }
        request.setAttribute("allProvinces", allProvinces);

        String provinceCode = "";
        if (request.getAttribute("provinceCode") != null) {
            provinceCode = (String) request.getAttribute("provinceCode");
        }
        if (!StringUtil.isNullOrEmpty(provinceCode) && !"0".equals(provinceCode)) {
            allDistricts = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceCode);
        } else {
            allDistricts = null;
        }
        request.setAttribute("allDistricts", allDistricts);

        String districtCode = "";
        if (request.getAttribute("districtCode") != null) {
            districtCode = (String) request.getAttribute("districtCode");
        }

        if (!StringUtil.isNullOrEmpty(districtCode) && !"0".equals(districtCode)) {
            allAdministrativePosts = lookupManager.findAllRowsForCode(preferredLanguage, "administrativePost", "districtCode", districtCode);
        } else {
            allAdministrativePosts = null;
        }
        request.setAttribute("allAdministrativePosts", allAdministrativePosts);

        // also in getPersonLookups, but different checks
        String countryOfBirthCode = "";
        if (request.getAttribute("countryOfBirthCode") != null) {
            countryOfBirthCode = (String) request.getAttribute("countryOfBirthCode");
        }

        if (!StringUtil.isNullOrEmpty(countryOfBirthCode) && !"0".equals(countryOfBirthCode)) {
            allProvincesOfBirth = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryOfBirthCode);
        } else {
            allProvincesOfBirth = null;
        }
        request.setAttribute("allProvincesOfBirth", allProvincesOfBirth);

        String provinceOfBirthCode = "";
        if (request.getAttribute("provinceOfBirthCode") != null) {
            provinceOfBirthCode = (String) request.getAttribute("provinceOfBirthCode");
        }
        if (!StringUtil.isNullOrEmpty(provinceOfBirthCode) && !"0".equals(provinceOfBirthCode)) {
            allDistrictsOfBirth = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceOfBirthCode);
        } else {
            allDistrictsOfBirth = null;
        }
        request.setAttribute("allDistrictsOfBirth", allDistrictsOfBirth);

        String countryOfOriginCode = "";
        if (request.getAttribute("countryOfOriginCode") != null) {
            countryOfOriginCode = (String) request.getAttribute("countryOfOriginCode");
        }

        if (!StringUtil.isNullOrEmpty(countryOfOriginCode) && !"0".equals(countryOfOriginCode)) {
            allProvincesOfOrigin = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryOfOriginCode);
        } else {
            allProvincesOfOrigin = null;
        }
        request.setAttribute("allProvincesOfOrigin", allProvincesOfOrigin);

        String provinceOfOriginCode = "";
        if (request.getAttribute("provinceOfOriginCode") != null) {
            provinceOfOriginCode = (String) request.getAttribute("provinceOfOriginCode");
        }
        if (!StringUtil.isNullOrEmpty(provinceOfOriginCode) && !"0".equals(provinceOfOriginCode)) {
            allDistrictsOfOrigin = (List<Lookup>) lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceOfOriginCode);
        } else {
            allDistrictsOfOrigin = null;
        }
        request.setAttribute("allDistrictsOfOrigin", allDistrictsOfOrigin);

        // also in getStudyPlanLookups, but different checks
        if (allApplicantCategories == null) {
            allApplicantCategories = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "applicantCategory");
        } else {
            if (ListUtil.isNullOrEmpty(allApplicantCategories) || (allApplicantCategories.size() != 0 && !preferredLanguage.equals(allApplicantCategories.get(0).getLang()))) {
                allApplicantCategories = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "applicantCategory");
            }
        }
        request.setAttribute("allApplicantCategories", allApplicantCategories);

        // NOT found in other getLookups methods
        request.setAttribute("allCountriesForPreviousInstitution", allCountries);
        request.setAttribute("allCountriesOfBirth", allCountries);
        request.setAttribute("allCountriesOfOrigin", allCountries);

        String previousInstitutionCountryCode = "";
        if (request.getAttribute("previousInstitutionCountryCode") != null) {
            previousInstitutionCountryCode = (String) request.getAttribute("previousInstitutionCountryCode");
        }

        if (!StringUtil.isNullOrEmpty(previousInstitutionCountryCode) && !"0".equals(previousInstitutionCountryCode)) {
            allProvincesForPreviousInstitution = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode",
                    previousInstitutionCountryCode);
        } else {
            allProvincesForPreviousInstitution = null;
        }
        request.setAttribute("allProvincesForPreviousInstitution", allProvincesForPreviousInstitution);

        String previousInstitutionProvinceCode = "";
        if (request.getAttribute("previousInstitutionProvinceCode") != null) {
            previousInstitutionProvinceCode = (String) request.getAttribute("previousInstitutionProvinceCode");
        }
        if (!StringUtil.isNullOrEmpty(previousInstitutionProvinceCode) && !"0".equals(previousInstitutionProvinceCode)) {
            allDistrictsForPreviousInstitution = lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode",
                    previousInstitutionProvinceCode);
        } else {
            allDistrictsForPreviousInstitution = null;
        }
        request.setAttribute("allDistrictsForPreviousInstitution", allDistrictsForPreviousInstitution);
    }

    /**
     * @param newLookupManager
     */
    public void setLookupManager(LookupManagerInterface newLookupManager) {
        lookupManager = newLookupManager;
    }

    @Deprecated
    public List<Lookup> getAllCivilTitles() {
        return allCivilTitles;
    }

    @Deprecated
    public void setAllCivilTitles(List<Lookup> allCivilTitles) {
        this.allCivilTitles = allCivilTitles;
    }

    public List<Lookup> getAllCivilTitles(String language) {
        return getAll("civilTitle", allCivilTitlesMap, language);
    }

    @Deprecated
    public List<Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    @Deprecated
    public void setAllGradeTypes(List<Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public List<Lookup9> getAllGradeTypes(String language) {
//        List<Lookup9> allGradeTypes = allGradeTypesMap.get(language);
//        if (allGradeTypes == null) {
//            allGradeTypes = (List<Lookup9>) lookupManager.findAllRows(language, "gradeType");
//            allGradeTypes = Collections.unmodifiableList(allGradeTypes);
//            allGradeTypesMap.put(language, allGradeTypes);
//        }
//        return allGradeTypes;
        return getAll("gradeType", allGradeTypesMap, language);
    }
    
    @Deprecated
    public List<Lookup> getAllGenders() {
        return allGenders;
    }

    @Deprecated
    public void setAllGenders(List<Lookup> allGenders) {
        this.allGenders = allGenders;
    }

    public List<Lookup> getAllGenders(String language) {
        return getAll("gender", allGendersMap, language);
    }

    @Deprecated
    public List<Lookup1> getAllNationalities() {
        return allNationalities;
    }

    @Deprecated
    public void setAllNationalities(List<Lookup1> allNationalities) {
        this.allNationalities = allNationalities;
    }

    public List<Lookup1> getAllNationalities(String language) {
        return getAll("nationality", allNationalitiesMap, language);
    }

    public List<Lookup> getAllDistrictsOfBirth() {
        return allDistrictsOfBirth;
    }

    public void setAllDistrictsOfBirth(List<Lookup> allDistrictsOfBirth) {
        this.allDistrictsOfBirth = allDistrictsOfBirth;
    }

    public List<Lookup5> getAllProvincesOfBirth() {
        return allProvincesOfBirth;
    }

    public void setAllProvincesOfBirth(List<Lookup5> allProvincesOfBirth) {
        this.allProvincesOfBirth = allProvincesOfBirth;
    }

    public List<Lookup> getAllDistrictsOfOrigin() {
        return allDistrictsOfOrigin;
    }

    public void setAllDistrictsOfOrigin(List<Lookup> allDistrictsOfOrigin) {
        this.allDistrictsOfOrigin = allDistrictsOfOrigin;
    }

    public List<Lookup5> getAllProvincesOfOrigin() {
        return allProvincesOfOrigin;
    }

    public void setAllProvincesOfOrigin(List<Lookup5> allProvincesOfOrigin) {
        this.allProvincesOfOrigin = allProvincesOfOrigin;
    }

    @Deprecated
    public List<Lookup> getAllCivilStatuses() {
        return allCivilStatuses;
    }

    @Deprecated
    public void setAllCivilStatuses(List<Lookup> allCivilStatuses) {
        this.allCivilStatuses = allCivilStatuses;
    }

    public List<Lookup> getAllCivilStatuses(String language) {
        return getAll("civilStatus", allCivilStatusMap, language);
    }

    public List<Lookup> getAllIdentificationTypes() {
        return allIdentificationTypes;
    }

    public void setAllIdentificationTypes(
            List<Lookup> allIdentificationTypes) {
        this.allIdentificationTypes = allIdentificationTypes;
    }

    public List< Lookup> getAllProfessions() {
        return allProfessions;
    }

    public void setAllProfessions(List< Lookup> allProfessions) {
        this.allProfessions = allProfessions;
    }

    public List<Lookup1> getAllLanguages() {
        return allLanguages;
    }

    public void setAllLanguages(List<Lookup1> allLanguages) {
        this.allLanguages = allLanguages;
    }

    @Deprecated
    public List<Lookup> getAllMasteringLevels() {
        return allMasteringLevels;
    }

    @Deprecated
    public void setAllMasteringLevels(List<Lookup> allMasteringLevels) {
        this.allMasteringLevels = allMasteringLevels;
    }

    public List<Lookup> getAllMasteringLevels(String language) {
        return getAll("masteringLevel", allMasteringLevelsMap, language);
    }

    @Deprecated
    public List<Lookup> getAllBloodTypes() {
        return allBloodTypes;
    }

    @Deprecated
    public void setAllBloodTypes(List<Lookup> allBloodTypes) {
        this.allBloodTypes = allBloodTypes;
    }

    public List<Lookup> getAllBloodTypes(String language) {
        return getAll("bloodType", allBloodTypesMap, language);
    }

    public List<Lookup> getAllEducationTypes() {
        return allEducationTypes;
    }

    public void setAllEducationTypes(List<Lookup> allEducationTypes) {
        this.allEducationTypes = allEducationTypes;
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

    public List<Lookup> getAllDayParts() {
        return allDayParts;
    }

    public void setAllDayParts(List<Lookup> allDayParts) {
        this.allDayParts = allDayParts;
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

    public List<Lookup> getAllAddressTypes() {
        return allAddressTypes;
    }

    public void setAllAddressTypes(List<Lookup> allAddressTypes) {
        this.allAddressTypes = allAddressTypes;
    }

    public List<Lookup4> getAllAdministrativePosts() {
        return allAdministrativePosts;
    }

    public void setAllAdministrativePosts(List<Lookup4> allAdministrativePosts) {
        this.allAdministrativePosts = allAdministrativePosts;
    }

    public List<Lookup> getAllDistricts() {
        return allDistricts;
    }

    public void setAllDistricts(List<Lookup> allDistricts) {
        this.allDistricts = allDistricts;
    }

    @Deprecated
    public List<Lookup5> getAllProvinces() {
        return allProvinces;
    }

    public List<Lookup5> getAllProvinces(String language) {
        return getAll("province", allProvincesMap, language);
    }

    @Deprecated
    public void setAllProvinces(List<Lookup5> allProvinces) {
        this.allProvinces = allProvinces;
    }

    @Deprecated
    public List<Lookup3> getAllCountries() {
        return allCountries;
    }

    public List<Lookup3> getAllCountries(String language) {
        return getAll("country", allCountriesMap, language);
    }

    @Deprecated
    public void setAllCountries(List<Lookup3> allCountries) {
        this.allCountries = allCountries;
    }

    public List< Lookup5> getAllProvincesForAddress() {
        return allProvincesForAddress;
    }

    public void setAllProvincesForAddress(
            List< Lookup5> allProvincesForAddress) {
        this.allProvincesForAddress = allProvincesForAddress;
    }

    public List< Lookup> getAllDistrictsForAddress() {
        return allDistrictsForAddress;
    }

    public void setAllDistrictsForAddress(
            List< Lookup> allDistrictsForAddress) {
        this.allDistrictsForAddress = allDistrictsForAddress;
    }

    public List< Lookup4> getAllAdministrativePostsForAddress() {
        return allAdministrativePostsForAddress;
    }

    public void setAllAdministrativePostsForAddress(
            List< Lookup4> allAdministrativePostsForAddress) {
        this.allAdministrativePostsForAddress = allAdministrativePostsForAddress;
    }

    @Deprecated
    public List< Lookup> getAllAcademicFields() {
        return allAcademicFields;
    }
    
    public List<Lookup> getAllAcademicFields(String language) {
        return getAll("academicField", allAcademicFieldsMap, language);
    }

    public void setAllAcademicFields(List< Lookup> allAcademicFields) {
        this.allAcademicFields = allAcademicFields;
    }

    @Deprecated
    public List< Lookup> getAllUnitAreas() {
        return allUnitAreas;
    }

    public List<Lookup> getAllUnitAreas(String language) {
        return getAll("unitArea", allUnitAreasMap, language);
    }

    public void setAllUnitAreas(List< Lookup> allUnitAreas) {
        this.allUnitAreas = allUnitAreas;
    }

    public List< Lookup> getAllUnitTypes() {
        return allUnitTypes;
    }

    public List<Lookup> getAllUnitTypes(String language) {
        return getAll("unitType", allUnitTypesMap, language);
    }

    public void setAllUnitTypes(List< Lookup> allUnitTypes) {
        this.allUnitTypes = allUnitTypes;
    }

    @Deprecated
    public List<Lookup> getAllStudyForms() {
        return allStudyForms;
    }
    
    public List<Lookup> getAllStudyForms(String language) {
//        List<Lookup> allStudyForms = allStudyFormsMap.get(language);
//        if (allStudyForms == null) {
//        	allStudyForms = (List<Lookup>) lookupManager.findAllRows(language, "studyForm");
//        	allStudyForms = Collections.unmodifiableList(allStudyForms);
//        	allStudyFormsMap.put(language, allStudyForms);
//        }
//        return allStudyForms;
        return getAll("studyForm", allStudyFormsMap, language);
    }

    public void setAllStudyForms(List<Lookup> allStudyForms) {
        this.allStudyForms = allStudyForms;
    }

    @Deprecated
    public List<Lookup> getAllStudyTimes() {
        return allStudyTimes;
    }
    
    public List<Lookup> getAllStudyTimes(String language) {
        return getAll("studyTime", allStudyTimesMap, language);
    }

    public void setAllStudyTimes(List<Lookup> allStudyTimes) {
        this.allStudyTimes = allStudyTimes;
    }

    @Deprecated
    public List<Lookup> getAllStudyIntensities() {
        return allStudyIntensities;
    }

    @Deprecated
    public void setAllStudyIntensities(List<Lookup> allStudyIntensities) {
        this.allStudyIntensities = allStudyIntensities;
    }

    public List<Lookup> getAllStudyIntensities(String language) {
//        List<Lookup> allStudyIntensities = allStudyIntensitiesMap.get(language);
//        if (allStudyIntensities == null) {
//            allStudyIntensities = (List<Lookup>) lookupManager.findAllRows(language, "studyIntensity");
//            allStudyIntensities = Collections.unmodifiableList(allStudyIntensities);
//            allStudyIntensitiesMap.put(language, allStudyIntensities);
//        }
//        return allStudyIntensities;
        return getAll("studyIntensity", allStudyIntensitiesMap, language);
    }
    
    public List<Lookup> getAllNationalityGroups(String language) {
        return getAll("nationalityGroup", allNationalityGroupsMap, language);
    }
    
    public List<Lookup> getAllEducationLevels(String language) {
        return getAll("educationLevel", allEducationLevelsMap, language);
    }
    
    public List<Lookup> getAllEducationAreas(String language) {
        return getAll("educationArea", allEducationAreasMap, language);
    }


    public List< Lookup> getAllTargetGroups() {
        return allTargetGroups;
    }

    public void setAllTargetGroups(List< Lookup> allTargetGroups) {
        this.allTargetGroups = allTargetGroups;
    }

    @Deprecated
    public List<Lookup8> getAllCardinalTimeUnits() {
        return allCardinalTimeUnits;
    }

    public List<Lookup8> getAllCardinalTimeUnits(String language) {
        return getAll("cardinalTimeUnit", allCardinalTimeUnitsMap, new LookupCacherKey(language));
    }

    public List<Lookup8> getAllCardinalTimeUnits(LookupCacherKey key) {
        return getAll("cardinalTimeUnit", allCardinalTimeUnitsMap, key);
    }

    public List< Lookup> getAllBlockTypes() {
        return allBlockTypes;
    }

    public void setAllBlockTypes(List< Lookup> allBlockTypes) {
        this.allBlockTypes = allBlockTypes;
    }

    @Deprecated
    public List< Lookup> getAllStudentStatuses() {
        return allStudentStatuses;
    }

    @Deprecated
    public void setAllStudentStatuses(List< Lookup> allStudentStatuses) {
        this.allStudentStatuses = allStudentStatuses;
    }

    public List<Lookup> getAllStudentStatuses(String language) {
        return getAll("studentStatus", allStudentStatusesMap, language);
    }

    public List< Lookup> getAllPreviousInstitutionDistricts() {
        return allPreviousInstitutionDistricts;
    }

    public void setAllPreviousInstitutionDistricts(
            List< Lookup> allPreviousInstitutionDistricts) {
        this.allPreviousInstitutionDistricts = allPreviousInstitutionDistricts;
    }

    public List< Lookup5> getAllPreviousInstitutionProvinces() {
        return allPreviousInstitutionProvinces;
    }

    public void setAllPreviousInstitutionProvinces(
            List< Lookup5> allPreviousInstitutionProvinces) {
        this.allPreviousInstitutionProvinces = allPreviousInstitutionProvinces;
    }

    public List< Lookup> getAllRelationTypes() {
        return allRelationTypes;
    }

    public void setAllRelationTypes(List< Lookup> allRelationTypes) {
        this.allRelationTypes = allRelationTypes;
    }

    @Deprecated
    public List< Lookup> getAllLevelsOfEducation() {
        return allLevelsOfEducation;
    }

    @Deprecated
    public void setAllLevelsOfEducation(List< Lookup> allLevelsOfEducation) {
        this.allLevelsOfEducation = allLevelsOfEducation;
    }

    public List<Lookup> getAllLevelsOfEducation(String language) {
        return getAll("levelOfEducation", allLevelsOfEducationMap, language);
    }

    public List< Lookup> getAllExpellationTypes() {
        return allExpellationTypes;
    }

    public void setAllExpellationTypes(List< Lookup> allExpellationTypes) {
        this.allExpellationTypes = allExpellationTypes;
    }

    @Deprecated
    public List<Lookup> getAllRigidityTypes() {
        return allRigidityTypes;
    }

    @Deprecated
    public void setAllRigidityTypes(List<Lookup> allRigidityTypes) {
        this.allRigidityTypes = allRigidityTypes;
    }
    
    public List<Lookup> getAllRigidityTypes(String language) {
//        List<Lookup> allRigidityTypes = allRigidityTypesMap.get(language);
//        if (allRigidityTypes == null) {
//            allRigidityTypes = (List<Lookup>) lookupManager.findAllRows(language, "rigidityType");
//            allRigidityTypes = Collections.unmodifiableList(allRigidityTypes);
//            allRigidityTypesMap.put(language, allRigidityTypes);
//        }
//        return allRigidityTypes;
        return getAll("rigidityType", allRigidityTypesMap, language);
    }

    public List<Lookup> getAllInstitutionTypes(String language) {
        return getAll("institutionType", allInstitutionTypesMap, language);
    }

    private <T extends Lookup> List<T> getAll(String tablename, Map<String, List<T>> map, String language) {
        List<T> all = map.get(language);
        if (all == null) {
            log.info("Fetching lookups from database: " + tablename);
            all = lookupManager.findAllRows(language, tablename);
            all = Collections.unmodifiableList(all);
            map.put(language, all);
        }
        return all;
    }

    private <T extends Lookup> List<T> getAll(String tablename, Map<LookupCacherKey, List<T>> map, LookupCacherKey key) {
        List<T> all = map.get(key);
        if (all == null) {
            all = lookupManager.findAllRows(key.getLang(), tablename);
            applyCapitalization(all, key.getCapitalization());
            all = Collections.unmodifiableList(all);
            map.put(key, all);
        }
        return all;
    }

    /**
     * Carry out (un)capitalization on the description of each lookup in the list.
     * @param lookups the descriptions will be changed in the given objects.
     * @param capitalization
     */
    private <T extends Lookup> void applyCapitalization(List<T> lookups, String capitalization) {
        if (LookupCacherKey.CAPITALIZE.equals(capitalization)) {
            LookupUtil.capitalize(lookups);
        } else if (LookupCacherKey.UNCAPITALIZE.equals(capitalization)) {
            // TODO create the method in LookupUtil
        }
    }

    @Deprecated
    public List<Lookup> getAllImportanceTypes() {
        return allImportanceTypes;
    }

    @Deprecated
    public void setAllImportanceTypes(
            List<Lookup> allImportanceTypes) {
        this.allImportanceTypes = allImportanceTypes;
    }

    public List<Lookup> getAllImportanceTypes(String language) {
        return getAll("importanceType", allImportanceTypesMap, language);
    }

    public List< Lookup> getAllFrequencies() {
        return allFrequencies;
    }

    public void setAllFrequencies(List< Lookup> allFrequencies) {
        this.allFrequencies = allFrequencies;
    }

    public List< Lookup> getAllExamTypes() {
        return allExamTypes;
    }

    public void setAllExamTypes(List< Lookup> allExamTypes) {
        this.allExamTypes = allExamTypes;
    }

    public List< Lookup> getAllStudyTypes() {
        return allStudyTypes;
    }

    public void setAllStudyTypes(List< Lookup> allStudyTypes) {
        this.allStudyTypes = allStudyTypes;
    }

    @Deprecated
    public List< Lookup> getAllExaminationTypes() {
        return allExaminationTypes;
    }

    @Deprecated
    public void setAllExaminationTypes(List< Lookup> allExaminationTypes) {
        this.allExaminationTypes = allExaminationTypes;
    }

    public List<Lookup10> getAllExaminationTypes(String language) {
        return getAll("examinationType", allExaminationTypesMap, language);
    }

    public List< Lookup> getAllThesisStatuses() {
        return allThesisStatuses;
    }

    public void setAllThesisStatuses(List< Lookup> allThesisStatuses) {
        this.allThesisStatuses = allThesisStatuses;
    }

    public List< Lookup> getAllRfcStatuses() {
        return allRfcStatuses;
    }

    public void setAllRfcStatuses(List< Lookup> allRfcStatuses) {
        this.allRfcStatuses = allRfcStatuses;
    }

    @Deprecated
    public List<Lookup> getAllStudyPlanStatuses() {
        return allStudyPlanStatuses;
    }

    @Deprecated
    public void setAllStudyPlanStatuses(List<Lookup> allStudyPlanStatuses) {
        this.allStudyPlanStatuses = allStudyPlanStatuses;
    }

    public List<Lookup> getAllStudyPlanStatuses(String language) {
//        List<Lookup> allStudyPlanStatuses = allStudyPlanStatusesMap.get(language);
//        if (allStudyPlanStatuses == null) {
//            allStudyPlanStatuses = (List<Lookup>) lookupManager.findAllRows(language, "studyPlanStatus");
//            allStudyPlanStatuses = Collections.unmodifiableList(allStudyPlanStatuses);
//            allStudyPlanStatusesMap.put(language, allStudyPlanStatuses);
//        }
//        return allStudyPlanStatuses;
        return getAll("studyPlanStatus", allStudyPlanStatusesMap, language);
    }

    @Deprecated
    public List<Lookup> getAllCardinalTimeUnitStatuses() {
        return allCardinalTimeUnitStatuses;
    }

    public List<Lookup> getAllAddressTypes(String language) {
        return getAll("addressType", allAddressTypesMap, language);
    }
    
    public List<Lookup> getAllCardinalTimeUnitStatuses(String language) {
        return getAll("cardinalTimeUnitStatus", allCardinalTimeUnitStatusesMap, language);
    }

    @Deprecated
    public List<Lookup7> getAllProgressStatuses() {
        return allProgressStatuses;
    }

    @Deprecated
    public Lookup7 getProgressStatusByCode(String code) {
        Lookup7 progressStatus = (Lookup7) LookupUtil.getLookupByCode(getAllProgressStatuses(), code);
        return progressStatus;
    }

    public List<Lookup7> getAllProgressStatuses(String language) {
        return getAll("progressStatus", allProgressStatusesMap, language);
    }

    public void setAllCountriesForPreviousInstitution(
            List <  Lookup3 > allCountriesForPreviousInstitution) {
        this.allCountriesForPreviousInstitution = allCountriesForPreviousInstitution;
    }

    public List <  Lookup3 > getAllCountriesForPreviousInstitution() {
        return allCountriesForPreviousInstitution;
    }

    @Override
    public void dbUpgradesExecuted(List<DbUpgradeCommandInterface> upgrades) {
        
        resetLookups();
    }
    
    public void resetLookups() {

        lookupListsPerLang.clear();
        lookupMapsPerLang.clear();
        
        allAcademicFieldsMap.clear();
        allAddressTypesMap.clear();
        allBloodTypesMap.clear();
        allCardinalTimeUnitsMap.clear();
        allCardinalTimeUnitStatusesMap.clear();
        allCivilStatusMap.clear();
        allCivilTitlesMap.clear();
        allCountriesMap.clear();
        allEducationAreasMap.clear();
        allEducationLevelsMap.clear();
        allExaminationTypesMap.clear();
        allGendersMap.clear();
        allGradeTypesMap.clear();
        allImportanceTypesMap.clear();
        allInstitutionTypesMap.clear();
        allLevelsOfEducationMap.clear();
        allMasteringLevelsMap.clear();
        allNationalitiesMap.clear();
        allNationalityGroupsMap.clear();
        allProgressStatusesMap.clear();
        allProvincesMap.clear();
        allRigidityTypesMap.clear();
        allStudentStatusesMap.clear();
        allStudyFormsMap.clear();
        allStudyIntensitiesMap.clear();
        allStudyPlanStatusesMap.clear();
        allStudyTimesMap.clear();
        allUnitAreasMap.clear();
        allUnitTypesMap.clear();
    }

    /**
     * Load all provinces for the given country
     */
    public List<Lookup5> getAllProvinces(String countryCode, String preferredLanguage) {
        List<Lookup5> allProvinces = null;
        if (countryCode != null) {
            allProvinces = lookupManager.findAllRowsForCode(preferredLanguage, "province", "countryCode", countryCode);
        }
        return allProvinces;
    }

    /**
     * Load all districts for the given province
     */
    public List<Lookup2> getAllDistricts(String provinceCode, String preferredLanguage) {
        List<Lookup2> allDistricts = null;
        if (provinceCode != null) {
            allDistricts = lookupManager.findAllRowsForCode(preferredLanguage, "district", "provinceCode", provinceCode);
        }
        return allDistricts;
    }

    /**
     * Load all posts for the given district
     */
    public List<Lookup4> getAllAdministrativePosts(String districtCode, String preferredLanguage) {
        List<Lookup4> allPosts = null;
        if (districtCode != null) {
            allPosts = lookupManager.findAllRowsForCode(preferredLanguage, "administrativepost", "districtCode", districtCode);
        }
        return allPosts;
    }

    public List<Lookup> getAllApplicantCategories() {
        return allApplicantCategories;
    }

    public void setAllApplicantCategories(List<Lookup> allApplicantCategories) {
        this.allApplicantCategories = allApplicantCategories;
    }
}
