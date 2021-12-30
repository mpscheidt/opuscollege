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

package org.uci.opus.college.web.flow;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToExaminationMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.domain.util.IdToTestMap;
import org.uci.opus.college.persistence.StaffMemberMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.StaffMemberFormValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StaffMemberForm;
import org.uci.opus.college.web.util.PasswordChangeEvaluator;
import org.uci.opus.util.Encode;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/staffmember")
@SessionAttributes({StaffMemberEditController.STAFF_MEMBER_FORM})
public class StaffMemberEditController {

    public static final String STAFF_MEMBER_FORM = "staffMemberForm";

    private static Logger log = LoggerFactory.getLogger(StaffMemberEditController.class);
    private static final String formView = "college/person/staffmember";

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    @Autowired private OpusUserManagerInterface opusUserManager;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StaffMemberMapper staffMemberMapper;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private TestManagerInterface testManager;

    @Autowired private StaffMemberFormValidator staffMemberFormValidator;
    
    public StaffMemberEditController() {
        super();
    }

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "staff_member_ID"
     * is set, the specified staff member is read. Otherwise a new one is
     * created.
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        long start = System.currentTimeMillis();
        HttpSession session = request.getSession(false);
        
        if (log.isDebugEnabled()) {
            log.debug("StaffMemberEditController formBackingObject entered...");
        }
        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(STAFF_MEMBER_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to staffmembers */
        session.setAttribute("menuChoice", "staffmembers");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StaffMemberForm staffMemberForm = (StaffMemberForm) model.get(STAFF_MEMBER_FORM);
        if (staffMemberForm == null) {
            int institutionId = 0;
            int branchId = 0;
            int organizationalUnitId = 0;

            staffMemberForm = new StaffMemberForm();
            model.put(STAFF_MEMBER_FORM, staffMemberForm);
            
            staffMemberForm.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

            // get the StaffMemberId if it exists
            int staffMemberId = ServletUtil.getIntParam(request, "staffMemberId", 0);

            StaffMember staffMember;

            if (staffMemberId != 0) {
                // Existing staff member
                staffMember = staffMemberManager.findStaffMember(preferredLanguage, staffMemberId);

                // read orgunit/branch/inst from the staff member's primary unit of appointment
                organizationalUnitId = staffMember.getPrimaryUnitOfAppointmentId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                // still 0 is possible when no branch is chosen in the select screens:
                institutionId = institutionManager.findInstitutionOfBranch(branchId);

                // staffOpusUserRoles
                // get all non expired roles for this user
//                Map<String, Object> userRoleMap = new HashMap<String, Object>();
//                userRoleMap.put("personId", staffMember.getPersonId());
//                List<OpusUserRole> opusUserRoles = opusUserManager.findOpusUserRolesByParams(userRoleMap);
//                form.setOpusUserRoles(opusUserRoles);

                // staffOpusUser
                OpusUser staffOpusUser = opusUserManager.findOpusUserByPersonId(staffMember.getPersonId());
                staffMemberForm.setOpusUser(staffOpusUser);

                // load subjects that are taught by this staff member
                Collection<Integer> subjectIds = DomainUtil.getIntProperties(staffMember.getSubjectsTaught(), "subjectId");
//correct                List<Subject> allSubjects = subjectManager.findSubjects(subjectIds);
                List<Subject> allSubjects = new ArrayList<>();
                if (!subjectIds.isEmpty()) {
                    Map<String, Object> findSubjectsMap = new HashMap<>();
                    findSubjectsMap.put("subjectIds", subjectIds);
                    allSubjects = subjectManager.findSubjects(findSubjectsMap);
                }

                staffMemberForm.setIdToSubjectMap(new IdToSubjectMap(allSubjects));
                
                // load all examinations of this staff member
                Collection<Integer> examinationIds = DomainUtil.getIntProperties(staffMember.getExaminationsTaught(), "examinationId");
//correct                List<Examination> allExaminations = examinationManager.findExaminations(examinationIds);
                List<Examination> allExaminations = new ArrayList<>();
                if (!examinationIds.isEmpty()) {
                    HashMap<String, Object> findExaminationsMap = new HashMap<>();
                    findExaminationsMap.put("examinationIds", examinationIds);
                    allExaminations = examinationManager.findExaminations(findExaminationsMap);
                }
                staffMemberForm.setIdToExaminationMap(new IdToExaminationMap(allExaminations));

                Collection<Integer> testIds = DomainUtil.getIntProperties(staffMember.getTestsSupervised(), "testId");
//correct                List<Test> allTests = testManager.findTests(testIds);
                List<Test> allTests = new ArrayList<>();
                if (!testIds.isEmpty()) {
                    HashMap<String, Object> findTestsMap = new HashMap<>();
                    findTestsMap.put("testIds", testIds);
                    allTests = testManager.findTests(findTestsMap);
                }
                staffMemberForm.setIdToTestMap(new IdToTestMap(allTests));

                // get all non expired roles for this user
                Map<String , Object> userRolesMap = new HashMap<>();
                userRolesMap.put("personId", staffMember.getPersonId());
                userRolesMap.put("notExpired", "false");
                userRolesMap.put("notAvailable", "false");
                userRolesMap.put("preferredLanguage", preferredLanguage);
                List<Map<String,Object>> userRoles = (List <Map<String,Object>>) opusUserManager.findOpusUserRolesByParams2(userRolesMap);
                staffMemberForm.setUserRoles(userRoles);

                List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
                staffMemberForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

                //photograph properties
                Map<String , String> photographProperties = ServletUtil.getImageProperties(staffMember.getPhotograph());
                photographProperties.put("type", staffMember.getPhotographMimeType());
                staffMemberForm.setPhotographProperties(photographProperties);

            } else {
                // New staff member
                staffMember = new StaffMember();

                /* generate personCode and staffMemberCode - Generate the codes on submit when still empty */
//                String personCode = StringUtil.createUniqueCode("P", "" + organizationalUnitId);
//                staffMember.setPersonCode(personCode);
//                String staffMemberCode = StringUtil.createUniqueCode("STA", "" + organizationalUnitId);
//                staffMember.setStaffMemberCode(staffMemberCode);

                // default values:
//                staffMember.setPrimaryUnitOfAppointmentId(organizationalUnitId);
                staffMember.setActive("Y");
                staffMember.setPublicHomepage("N");
                staffMember.setRegistrationDate(new Date());
                
                /* fetch chosen institutionId and branchId for new staffmember */
                institutionId = OpusMethods.getInstitutionId(session, request);
                branchId = OpusMethods.getBranchId(session, request);
                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            }

            staffMemberForm.setStaffMember(staffMember);

            Organization organization = new Organization();
            organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
            staffMemberForm.setOrganization(organization);

            session.setAttribute("institutionId", institutionId);
            session.setAttribute("branchId", branchId);
            session.setAttribute("organizationalUnitId", organizationalUnitId);

            // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
            String educationTypeCode = OpusMethods.getInstitutionTypeCode(request);
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(staffMemberForm.getOrganization(),
                    session, request, educationTypeCode, institutionId, branchId, organizationalUnitId);

            lookupCacher.getPersonLookups(preferredLanguage, request);
            lookupCacher.getStaffMemberLookups(preferredLanguage, request);
            lookupCacher.getContractLookups(preferredLanguage, request);
            lookupCacher.getAddressLookups(preferredLanguage, request);

            staffMemberForm.setAllGenders(lookupCacher.getAllGenders(preferredLanguage));
            staffMemberForm.setAllCivilStatuses(lookupCacher.getAllCivilStatuses(preferredLanguage));
            staffMemberForm.setAllCivilTitles(lookupCacher.getAllCivilTitles(preferredLanguage));
            staffMemberForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
            staffMemberForm.setAllNationalities(lookupCacher.getAllNationalities(preferredLanguage));
            staffMemberForm.setAllCountries(lookupCacher.getAllCountries(preferredLanguage));
            staffMemberForm.setAllProvinces(lookupCacher.getAllProvinces(preferredLanguage));
            staffMemberForm.setAllDistricts(lookupCacher.getAllDistricts());
            staffMemberForm.setAllAdministrativePosts(lookupCacher.getAllAdministrativePosts());
            staffMemberForm.setAllIdentificationTypes(lookupCacher.getAllIdentificationTypes());
            staffMemberForm.setAllLanguages(lookupCacher.getAllLanguages());
            staffMemberForm.setAllMasteringLevels(lookupCacher.getAllMasteringLevels(preferredLanguage));
            staffMemberForm.setAllBloodTypes(lookupCacher.getAllBloodTypes(preferredLanguage));
            staffMemberForm.setAllAppointmentTypes(lookupCacher.getAllAppointmentTypes());
            staffMemberForm.setAllStaffTypes(lookupCacher.getAllStaffTypes());
            staffMemberForm.setAllDayParts(lookupCacher.getAllDayParts());
            staffMemberForm.setAllEducationTypes(lookupCacher.getAllEducationTypes());
            staffMemberForm.setAllFunctions(lookupCacher.getAllFunctions());
            staffMemberForm.setAllFunctionLevels(lookupCacher.getAllFunctionLevels());
            staffMemberForm.setAllContractTypes(lookupCacher.getAllContractTypes());
            staffMemberForm.setAllContractDurations(lookupCacher.getAllContractDurations());
            staffMemberForm.setAllStudyTimes(lookupCacher.getAllStudyTimes(preferredLanguage));

            // Set the lists of provinces/districts of birth/origin into the form object, depending on current values of country/province of birth/origin
            staffMemberForm.setAllProvincesOfBirth(lookupCacher.getAllProvinces(staffMember.getCountryOfBirthCode(), preferredLanguage));
            staffMemberForm.setAllDistrictsOfBirth(lookupCacher.getAllDistricts(staffMember.getProvinceOfBirthCode(), preferredLanguage));
            staffMemberForm.setAllProvincesOfOrigin(lookupCacher.getAllProvinces(staffMember.getCountryOfOriginCode(), preferredLanguage));
            staffMemberForm.setAllDistrictsOfOrigin(lookupCacher.getAllDistricts(staffMember.getProvinceOfOriginCode(), preferredLanguage));

            // TODO make a general method to retrieve certain addresstypes (e.g. "1", "6") 
            /* work around the addresstypes */
//            List < ? extends Lookup > allAddressTypes = (List < ? extends Lookup >
//                                                        ) request.getAttribute("allAddressTypes");
            List<Lookup> allAddressTypes = lookupCacher.getAllAddressTypes();
            List<Lookup> allAddressTypesActual = new ArrayList<>();
            Lookup aType = null;
            int ix = 0;
            request.setAttribute("allAddressTypes", null);
            for (int i = 0; i < allAddressTypes.size(); i++) {
                // home = code 1
                // formal communication address staffmember = code 6
                if ("1".equals(allAddressTypes.get(i).getCode())
                        || "6".equals(allAddressTypes.get(i).getCode())) {
                    aType = allAddressTypes.get(i);
                    allAddressTypesActual.add(ix,  aType);
                    ix = ix + 1;
                }
            }
            staffMemberForm.setAllAddressTypes(allAddressTypesActual);
        }

        if (log.isDebugEnabled()) {
            log.debug("time to load: " + (System.currentTimeMillis() - start));
        }
        return formView;
    }

    /**
     * Saves the new or updated staffmember.
     * @throws IOException 
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm,
            BindingResult result, ModelMap model) throws IOException
            {

        if (log.isDebugEnabled()) {
            log.debug("StaffMemberEditController processSubmit entered...");
        }

        StaffMember staffMember = staffMemberForm.getStaffMember();
        Organization organization = staffMemberForm.getOrganization();
        NavigationSettings navigationSettings = staffMemberForm.getNavigationSettings();

        int organizationalUnitId = organization.getOrganizationalUnitId();
        staffMember.setPrimaryUnitOfAppointmentId(organizationalUnitId);    // what has been chosen in the organizationlUnit combo

        // --- Validation ---

        staffMemberFormValidator.validate(staffMemberForm, result);
        HttpSession session = request.getSession(false);

        // Validate photograph
        MultipartFile photograph = staffMemberForm.getPhotograph();
        if (photograph != null && !photograph.isEmpty()) {

            // validate if previous diploma file is too big
            int maxUploadSizeImage = appConfigManager.getMaxUploadSizeImage();
            if (photograph.getSize() > maxUploadSizeImage) {
                result.rejectValue("staffMember.photograph", "invalid.uploadsize", new Object[] {maxUploadSizeImage}, null);
            }

            // validate file type
            List<String> imageMimeTypes = OpusMethods.getImageMimeTypes(session);
            List<String> docMimeTypes = OpusMethods.getDocMimeTypes(session);
            String contentType = photograph.getContentType();
            if (!imageMimeTypes.contains(contentType) && !docMimeTypes.contains(contentType)) {
                result.rejectValue("staffMember.photograph", "invalid.doctype.format");
            }
        }

        if (result.hasErrors()) {
            return formView;
        }
        

//        StaffMember changedStaffMember = null;
//        String showUserNameError = "";
//        String showPasswordError = "";
//        String showStaffMemberError = "";
//        String dbPw = "";
//        OpusUser opusUser = (OpusUser) request.getAttribute("personOpusUser");
//        int organizationalUnitId = 0;
        
        staffMember.setWriteWho(opusMethods.getWriteWho(request));
        
//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        String opusUserLanguage = (String) session.getAttribute("opusUserLanguage");
        
//        Locale currentLoc = RequestContextUtils.getLocale(request);

        /* reset institution/branch/orgunit attributes, but save organizationalUnitId first */
//        if (request.getParameter("organizationalUnitId") != null) {
//        	organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
//        }
//        request.setAttribute("institutionId", null);
//        request.setAttribute("branchId", null);
        //request.setAttribute("organizationalUnitId", null);

//        if (request.getParameter("currentPageNumber") != null) {
//            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
//        }
//        request.setAttribute("currentPageNumber", currentPageNumber);

        boolean checkPw = false;
//        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_password"))) {
        if (navigationSettings.getTab() == 1 && navigationSettings.getPanel() == 1) {
            checkPw = true;
        }
        
//        if (!StringUtil.isNullOrEmpty(request
//                .getParameter("panel_personaldata"))) {
//            panel = Integer.parseInt(request.getParameter("panel_personaldata"));
//        } else {
//            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_background"))) {
//                panel = Integer.parseInt(request.getParameter("panel_background"));
//            } else {
//                if (!StringUtil.isNullOrEmpty(request.getParameter("panel_identification"))) {
//                    panel = Integer.parseInt(request.getParameter("panel_identification"));
//                } else {
//                    if (!StringUtil.isNullOrEmpty(request.getParameter("panel_miscellaneous"))) {
//                        panel = Integer.parseInt(request.getParameter("panel_miscellaneous"));
//                    } else {
//                        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_photograph"))) {
//                            panel = Integer.parseInt(request.getParameter("panel_photograph"));
//                        } else {
//                            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_remarks"))) {
//                                panel = Integer.parseInt(request.getParameter("panel_remarks"));
//                            } else {
//                                if (!StringUtil.isNullOrEmpty(request.getParameter("panel_opususer"))) {
//                                    panel = Integer.parseInt(request.getParameter("panel_opususer"));
//                                } else {
//                                    if (!StringUtil.isNullOrEmpty(request.getParameter("panel_appointment"))) {
//                                        panel = Integer.parseInt(request.getParameter("panel_appointment"));
//                                    } else {
//                                        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_contract"))) {
//                                            panel = Integer.parseInt(request.getParameter("panel_contract"));
//                                        } else {
//                                            if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//                                                panel = Integer.parseInt(request.getParameter("panel"));
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        form.getNavigationSettings().setPanel(panel);
//        Integer panel = ServletUtil.getIntObject(request, "panel"); // e.g. when returning via the link in the navigation bar from a page like Add address: read panel and tab
//        if (panel != null) {
//            staffMemberForm.getNavigationSettings().setTab(panel);
//        }

//        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_personaldata"))) {
//            tab = Integer.parseInt(request.getParameter("tab_personaldata"));
//        } else {
//            if (!StringUtil.isNullOrEmpty(request.getParameter("tab_opususer"))) {
//                tab = Integer.parseInt(request.getParameter("tab_opususer"));
//            } else {
//                if (!StringUtil.isNullOrEmpty(request.getParameter("tab_contract"))) {
//                    tab = Integer.parseInt(request.getParameter("tab_contract"));
//                } else {
//                    if (!StringUtil
//                            .isNullOrEmpty(request.getParameter("panel"))) {
//                        tab = Integer.parseInt(request.getParameter("panel"));
//                    }
//                }
//            }
//        }
//        form.getNavigationSettings().setTab(tab);

        /* perform validation manually */
//        staffMemberValidator.validate(staffMember, result);
        if (result.hasErrors()) {
            return formView;
        }

        /* fill opusUserRole */
//        OpusUserRole staffOpusUserRole = (OpusUserRole) request.getAttribute("personOpusUserRole");
//        OpusUserRole staffOpusUserRole = form.getOpusUserRole();
        
//        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUserRole_id"))) {
//            staffOpusUserRole.setId(Integer.parseInt(request.getParameter("opusUserRole_id")));
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUserRole_username"))) {
//            staffOpusUserRole.setUserName(request.getParameter("opusUserRole_username"));
//        }
//        
//        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUserRole_role"))) {
//            staffOpusUserRole.setRole(request.getParameter("opusUserRole_role"));
//        }
 
        /* fill opusUser */
//        OpusUser staffOpusUser = (OpusUser) request.getAttribute("personOpusUser");
//        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUserRole_username"))) {
//            staffOpusUser.setUserName(request.getParameter("opusUserRole_username"));
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUser_lang"))) {
//        	staffOpusUser.setLang(request.getParameter("opusUser_lang"));
//
//        } else {
//            staffOpusUser.setLang(opusUserLanguage);
//        }

        /*
         * if a country of birth is chosen, but no province then also district
         * has to be empty
         */
        if (StringUtil.isNullOrEmpty(staffMember.getCountryOfBirthCode())) {
            staffMember.setProvinceOfBirthCode("");
        }
        if (StringUtil.isNullOrEmpty(staffMember.getProvinceOfBirthCode())) {
            staffMember.setDistrictOfBirthCode("");
        }
        /*
         * if a country of origin is chosen, but no province then also district
         * has to be empty
         */
        if (StringUtil.isNullOrEmpty(staffMember.getCountryOfOriginCode())) {
            staffMember.setProvinceOfOriginCode("");
        }
        if (StringUtil.isNullOrEmpty(staffMember.getProvinceOfOriginCode())) {
            staffMember.setDistrictOfOriginCode("");
        }

        /* if personCode or staffMemberCode are made empty, give default values */
        if (StringUtil.isNullOrEmpty(staffMember.getPersonCode())) {
            /* generate personCode and staffMemberCode */
            String personCode = StringUtil.createUniqueCode("P", "" + organizationalUnitId);
            staffMember.setPersonCode(personCode);
        }
        if (StringUtil.isNullOrEmpty(staffMember.getStaffMemberCode())) {
            String staffMemberCode = StringUtil.createUniqueCode("STA", "" + organizationalUnitId);
            staffMember.setStaffMemberCode(staffMemberCode);
        }
        
        // put the photograph into the staffMember object
        if (photograph != null && !photograph.isEmpty()) {
            staffMember.setPhotograph(photograph.getBytes());
            staffMember.setPhotographName(photograph.getOriginalFilename());
            staffMember.setPhotographMimeType(photograph.getContentType());
        }

        OpusUser staffOpusUser = null;
        String newOrChangedPasswordInClear = null;

        if (staffMember.getStaffMemberId() == 0) {
            // New staff member

            /* test if the combination already exists */
            Map<String, Object> findStaffMemberMap = new HashMap<>();
            findStaffMemberMap.put("surnameFull", staffMember.getSurnameFull());
            findStaffMemberMap.put("firstNamesFull", staffMember.getFirstnamesFull());
            findStaffMemberMap.put("birthdate", staffMember.getBirthdate());
            if (staffMemberMapper.countStaffMembers(findStaffMemberMap) != 0) {

                result.reject("jsp.error.general.alreadyexists");
            } else {
                // Give the default role to the new user
                OpusUserRole staffOpusUserRole = new OpusUserRole();
                staffOpusUserRole.setRole("guest");
                staffOpusUser = new OpusUser();
                staffOpusUser.setLang(appConfigManager.getAppLanguages().get(0));

                newOrChangedPasswordInClear = staffMember.getPersonCode();
                staffOpusUser.setPw(Encode.encodeMd5(newOrChangedPasswordInClear));
                staffMemberManager.addStaffMember(staffMember, staffOpusUserRole, staffOpusUser);
            }
        } else {
            // Update staff member

            staffOpusUser = staffMemberForm.getOpusUser();

            // Reset failed login attempts if checkbox selected
            if (staffMemberForm.isResetFailedLoginAttempts()) {
                staffOpusUser.setFailedLoginAttempts(0);
            }

            // Update organizationunitid if set in dropdown
            if (organizationalUnitId != 0) {
                staffOpusUser.setPreferredOrganizationalUnitId(organizationalUnitId);
            }

            if (opusUserManager.isUserNameAlreadyExists(staffOpusUser.getUserName(), staffOpusUser.getId())) {
                result.rejectValue("opusUser.userName", "jsp.error.username.exists", new Object[] {staffOpusUser.getUserName()}, "User already exists");
            }

            if (!result.hasErrors()) {
                String dbPw = opusUserManager.findOpusUserByPersonId(staffOpusUser.getPersonId()).getPw();
                PasswordChangeEvaluator pwEval = new PasswordChangeEvaluator(
                        request, staffOpusUser, dbPw, staffMemberForm.getCurrentPassword(), 
                        staffMemberForm.getNewPassword(), staffMemberForm.getConfirmPassword());;

                // check only when submit is done in password panel
                if (checkPw) {
                    pwEval.checkAndSetPassword(result);
                }

                if (!result.hasErrors()) {
                    // update staffmember
                    // TODO If username changes, update all roles' username
                    staffMemberManager.updateStaffMemberAndOpusUser(staffMember, staffOpusUser, dbPw);
                    if (pwEval.isPwdChanged()) {
                        newOrChangedPasswordInClear = staffMemberForm.getNewPassword();
                    }
                }
            }
        }

        if (result.hasErrors()) {
            return formView;
        }

        if (newOrChangedPasswordInClear != null) {
            // if the user is new or the password has changed show new opusUser password in new screen
            request.setAttribute("tab", navigationSettings.getTab());
            request.setAttribute("panel", navigationSettings.getPanel());
            request.setAttribute("username", staffOpusUser.getUsername());
            request.setAttribute("password", newOrChangedPasswordInClear);
            request.setAttribute("staffMemberId", staffMember.getStaffMemberId());
            request.setAttribute("from", "staffmember");
            request.setAttribute("currentPageNumber", navigationSettings.getCurrentPageNumber());
            return "college/person/pw";
        } else {
            return "redirect:/college/staffmember.view?newForm=true&tab=" + navigationSettings.getTab()
                    + "&panel=" + navigationSettings.getPanel()
                    + "&staffMemberId=" + staffMember.getStaffMemberId()
                    + "&from=staffmember"
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        }

    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.institutionId")
    public String institutionChanged(@ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        opusMethods.loadBranches(staffMemberForm.getOrganization());
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.branchId")
    public String branchChanged(@ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        opusMethods.loadOrganizationalUnits(staffMemberForm.getOrganization());
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=staffMember.countryOfBirthCode")
    public String countryOfBirthChanged(HttpServletRequest request, @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        String countryCode = staffMemberForm.getStaffMember().getCountryOfBirthCode();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        staffMemberForm.setAllProvincesOfBirth(lookupCacher.getAllProvinces(countryCode, preferredLanguage));
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=staffMember.provinceOfBirthCode")
    public String provinceOfBirthChanged(HttpServletRequest request, @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        String provinceCode = staffMemberForm.getStaffMember().getProvinceOfBirthCode();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        staffMemberForm.setAllDistrictsOfBirth(lookupCacher.getAllDistricts(provinceCode, preferredLanguage));
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=staffMember.countryOfOriginCode")
    public String countryOfOriginChanged(HttpServletRequest request, @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        String countryCode = staffMemberForm.getStaffMember().getCountryOfOriginCode();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        staffMemberForm.setAllProvincesOfOrigin(lookupCacher.getAllProvinces(countryCode, preferredLanguage));
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=staffMember.provinceOfOriginCode")
    public String provinceOfOriginChanged(HttpServletRequest request, @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {

        String provinceCode = staffMemberForm.getStaffMember().getProvinceOfOriginCode();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        staffMemberForm.setAllDistrictsOfOrigin(lookupCacher.getAllDistricts(provinceCode, preferredLanguage));
        return formView;
    }

    @RequestMapping(params="deletePhotograph=true")
    public String deletePhotograph(
            HttpServletRequest request,
            @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm) {
        
        StaffMember staffMember = (StaffMember) staffMemberForm.getStaffMember();
        NavigationSettings navigationSettings = staffMemberForm.getNavigationSettings();

        staffMember.setPhotograph(null);
        staffMember.setPhotographName(null);
        staffMember.setPhotographMimeType(null);
        personManager.updatePersonPhotograph(staffMember);
        
        return "redirect:/college/staffmember.view?newForm=true&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel()
                + "&staffMemberId=" + staffMember.getStaffMemberId()
                + "&from=staffmember"
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    @RequestMapping(value="/deletefunction/{functionCode}", method = RequestMethod.GET)
    public String deleteFunction(HttpServletRequest request, @ModelAttribute(STAFF_MEMBER_FORM) StaffMemberForm staffMemberForm, @PathVariable("functionCode") String functionCode) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        int staffMemberId = staffMemberForm.getStaffMember().getStaffMemberId();
        staffMemberManager.deleteLookupFromStaffMember(staffMemberId, functionCode, "function");

        NavigationSettings nav = staffMemberForm.getNavigationSettings();
        return "redirect:/college/staffmember.view?newForm=true&tab=2&panel=0"
                + "&staffMemberId=" + staffMemberId
                + "&currentPageNumber=" + nav.getCurrentPageNumber();

    }

}
