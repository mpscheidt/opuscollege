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

package org.uci.opus.college.web.flow.person;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.validator.StudentValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.person.IStudentForm;
import org.uci.opus.college.web.form.person.StudentForm;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.college.web.user.OpusSecurityException;
import org.uci.opus.college.web.util.AddressLookupBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.Encode;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

/**
 * Controller for personal data view and subscription view.
 *
 */
@Controller
@RequestMapping(value = "/college/student")
@SessionAttributes({ StudentPersonalEditController.FORM_NAME, AbstractStudentEditController.FORM_NAME_SHARED })
public class StudentPersonalEditController extends AbstractStudentEditController<StudentForm> {

    private static final String REDIRECT_SUBSCRIPTION_VIEW = "redirect:/college/student/subscription.view";
    private static final String REDIRECT_PERSONAL_VIEW = "redirect:/college/student/personal.view";

    public static final String FORM_NAME = "studentForm";

    private Logger log = LoggerFactory.getLogger(StudentPersonalEditController.class);

    @Autowired
    private AddressLookupBuilder addressLookupBuilder;
    
    @Autowired
    private AppConfigManagerInterface appConfigManager;
    
    @Autowired
    private BranchManagerInterface branchManager;
    
    @Autowired
    private CollegeServiceExtensions collegeServiceExtensions;
    
    @Autowired
    private ExaminationManagerInterface examinationManager;
    
    @Autowired
    private InstitutionManagerInterface institutionManager;
    
    @Autowired
    private LookupCacher lookupCacher;
    
    @Autowired
    private OpusInit opusInit;
    
    @Autowired
    private OpusMethods opusMethods;
    
    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    
    @Autowired
    private MessageSource messageSource;
    
    @Autowired
    private ResultManagerInterface resultManager;
    
    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private StudyManagerInterface studyManager;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    
    @Autowired
    private SubjectManagerInterface subjectManager;

    // studentnumbergenerator must be autowired because of primary flag:
    @Autowired
    private StudentNumberGeneratorInterface studentNumberGenerator;

    @Autowired
    private StudentValidator studentValidator;

    public StudentPersonalEditController() {
        super();
    }

    /**
     * Load student data and return the personal data view.
     * 
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/personal", method = RequestMethod.GET)
    public String setUpFormPersonal(ModelMap model, HttpServletRequest request) {
        return setupForm(model, request);
    }

    /**
     * Load student data and return the subscription data view.
     * 
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/subscription", method = RequestMethod.GET)
    public String setUpFormSubscription(ModelMap model, HttpServletRequest request) {
        return setupForm(model, request);
    }

    @Override
    protected StudentForm newFormInstance() {
        return new StudentForm();
    }

    private String setupForm(ModelMap model, HttpServletRequest request) {
        if (log.isDebugEnabled()) {
            log.debug("StudentPersonalEditController.setUpForm entered...");
        }

        TimeTrack timer = new TimeTrack("StudentPersonalEditController.setupForm");
        
        // declare variables
        Organization organization;

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        StudentForm studentForm = super.setupFormShared(FORM_NAME, model, request);
        StudentFormShared shared = studentForm.getStudentFormShared();
        timer.measure("super.setupFormShared");

        /* set menu to students */
        session.setAttribute("menuChoice", "students");

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (super.isNewForm()) {

            int institutionId = 0;
            int branchId = 0;
            int organizationalUnitId = 0;

            studentForm.setStudentCodeWillBeGenerated(studentNumberGenerator.applies(StudentNumberGeneratorInterface.KEY_SUBMIT));

            Student student = shared.getStudent();
            if (student != null) {

                int studyId = student.getPrimaryStudyId();
                if (studyId != 0) {
                    // unitStudy = (OrganizationalUnit) organizationalUnitManager.findOrganizationalUnitOfStudy(studyId);
                    Study study = studyManager.findStudy(studyId);

                    // find organization id's matching with the study
                    organizationalUnitId = study.getOrganizationalUnitId();
                    branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                    institutionId = institutionManager.findInstitutionOfBranch(branchId);
                }

                // Studies for study plan studies
                List<Integer> studyIds = DomainUtil.getIntProperties(student.getStudyPlans(), "studyId");
                List<Study> studyPlanStudies = studyManager.findStudies(studyIds, preferredLanguage);
                studentForm.setStudyPlanStudies(studyPlanStudies);

            } else {
                // NEW STUDENT -- only applies to personal student view
                student = new Student();
                shared.setStudent(student);

                // fetch organization from session
                institutionId = OpusMethods.getInstitutionId(session, request);
                branchId = OpusMethods.getBranchId(session, request);
                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);

                /* generate personCode and studentCode */
                String personCode = StringUtil.createUniqueCode("P", "" + organizationalUnitId);
                student.setPersonCode(personCode);

                String studentCode = createUniqueStudentNumberOnScreen(organizationalUnitId, student);
                student.setStudentCode(studentCode);

                // default values:
                student.setPrimaryStudyId(0);
                student.setSecondaryStudyId(0);
                student.setActive("Y");
                student.setScholarship("N");
                student.addStudentStudentStatus(new Date(), OpusConstants.STUDENTSTATUS_ACTIVE);
                student.setPublicHomepage("N");
                student.setForeignStudent("N");
                student.setRelativeOfStaffMember("N");
                student.setRuralAreaOrigin("N");
                student.setRegistrationDate(new Date());
                student.setDateOfEnrolment(new Date());
                student.setSubscriptionRequirementsFulfilled("Y");
                OpusUserRole studentOpusUserRole = new OpusUserRole();
                studentOpusUserRole.setRole("student");
                studentForm.setPersonOpusUserRole(studentOpusUserRole);
                OpusUser studentOpusUser = new OpusUser();
                studentOpusUser.setLang(appConfigManager.getAppLanguages().get(0));
                studentForm.setOpusUser(studentOpusUser);
            }

            String writeWho = opusMethods.getWriteWho(request);
            student.setWriteWho(writeWho);
            student.setStudentWriteWho(writeWho);

            // get the organization values from study:
            organization = new Organization();
            organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
            studentForm.setOrganization(organization);

            // primary study: select only studies from current organizationalUnitId
            loadAllStudies(studentForm);

            // secondary study: select all studies from current institution for selection
            if (opusInit.isSecondStudy()) {
                Map<String, Object> findSecondaryStudiesMap = new HashMap<>();
                findSecondaryStudiesMap.put("institutionId", organization.getInstitutionId());
                findSecondaryStudiesMap.put("branchId", 0);
                findSecondaryStudiesMap.put("organizationalUnitId", 0);
                findSecondaryStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
                studentForm.setAllSecondaryStudies(studyManager.findStudies(findSecondaryStudiesMap));
            }

            // photograph properties
            Map<String, String> photographProperties = ServletUtil.getImageProperties(student.getPhotograph());
            photographProperties.put("type", student.getPhotographMimeType());
            studentForm.setPhotographProperties(photographProperties);

            Map<String, Object> findMap = new HashMap<>();
            findMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, organization);
            findMap.put("preferredLanguage", preferredLanguage);
            findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            List<OrganizationalUnit> allOrgUnits = organizationalUnitManager.findOrganizationalUnits(findMap);
            IdToOrganizationalUnitMap idToOrganizationalUnitMap = new IdToOrganizationalUnitMap(allOrgUnits);
            studentForm.setIdToOrganizationalUnitMap(idToOrganizationalUnitMap);

            // previous institution
            studentForm.setAllPreviousInstitutions(institutionManager.findInstitutions(new HashMap<String, Object>()));

            studentForm.setPreviousInstitutionAddressLookup(addressLookupBuilder.newAddressLookup(preferredLanguage,
                    student.getPreviousInstitutionCountryCode(), student.getPreviousInstitutionProvinceCode(), student.getPreviousInstitutionDistrictCode()));
            
            studentForm.setAllBloodTypes(lookupCacher.getAllBloodTypes(preferredLanguage));
            studentForm.setAllCivilStatuses(lookupCacher.getAllCivilStatuses(preferredLanguage));
            studentForm.setAllCivilTitles(lookupCacher.getAllCivilTitles(preferredLanguage));
            studentForm.setAllCountries(lookupCacher.getAllCountries(preferredLanguage));
            studentForm.setAllGenders(lookupCacher.getAllGenders(preferredLanguage));
            studentForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
            studentForm.setAllMasteringLevels(lookupCacher.getAllMasteringLevels(preferredLanguage));
            studentForm.setAllNationalities(lookupCacher.getAllNationalities(preferredLanguage));

            timer.measure("new form");
        } else {
            organization = studentForm.getOrganization();
        }

        // data stored in the request needs to be loaded at every GET, independent of newForm true or false

        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), organization.getOrganizationalUnitId());

        referenceData(request, shared.getStudent());
        timer.end("reference data");

        String showDocTypeError = "";
        String showPhotoTypeError = "";
        String showStudentError = "";

        /* catch possible other errors */
        if (!StringUtil.isNullOrEmpty(request.getParameter("showDocTypeError"))) {
            showDocTypeError = request.getParameter("showDocTypeError");
        }
        request.setAttribute("showDocTypeError", showDocTypeError);

        if (!StringUtil.isNullOrEmpty(request.getParameter("showPhotoTypeError"))) {
            showPhotoTypeError = request.getParameter("showPhotoTypeError");
        }
        request.setAttribute("showPhotoTypeError", showPhotoTypeError);

        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
            showStudentError = request.getParameter("showStudentError");
        }
        request.setAttribute("showStudentError", showStudentError);

        return FORM_VIEW;
    }

    /**
     * If organizationalUnitId is selected (!= 0), then load allStudies, otherwise set to null.
     * 
     * @param studentForm
     */
    private void loadAllStudies(StudentForm studentForm) {

        Organization organization = studentForm.getOrganization();

        List<Study> allStudies = null;
        if (organization.getOrganizationalUnitId() != 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("institutionId", organization.getInstitutionId());
            map.put("branchId", organization.getBranchId());
            map.put("organizationalUnitId", organization.getOrganizationalUnitId());
            map.put("institutionTypeCode", organization.getInstitutionTypeCode());
            allStudies = studyManager.findStudies(map);
        }
        studentForm.setAllStudies(allStudies);
    }

    /**
     * Request attributes need to loaded at *every* request.
     * 
     * @param request
     * @param student
     */
    private void referenceData(HttpServletRequest request, Student student) {
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // put lookup-tables on the request: getPersonLookups uses request attributes countryOfBirthCode, provinceOfBirthCode etc.
        if (request.getParameter("countryOfBirthCode") == null) {
            request.setAttribute("countryOfBirthCode", student.getCountryOfBirthCode());
        }
        if (request.getParameter("provinceOfBirthCode") == null) {
            request.setAttribute("provinceOfBirthCode", student.getProvinceOfBirthCode());
        }
        if (request.getParameter("countryOfOriginCode") == null) {
            request.setAttribute("countryOfOriginCode", student.getCountryOfOriginCode());
        }
        if (request.getParameter("provinceOfOriginCode") == null) {
            request.setAttribute("provinceOfOriginCode", student.getProvinceOfOriginCode());
        }
        lookupCacher.getPersonLookups(preferredLanguage, request);
//        lookupCacher.getAddressLookups(preferredLanguage, request);
//        lookupCacher.getStudentLookups(preferredLanguage, request);
//        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
    }

    /**
     * @param organizationalUnitId
     */
    protected String createUniqueStudentNumberOnScreen(int organizationalUnitId, Student student) {
        String studentCode;
        studentCode = collegeServiceExtensions.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SCREEN, organizationalUnitId, student);
        return studentCode;
    }

    /**
     * @param organizationalUnitId
     */
    protected String createUniqueStudentNumberOnSubmit(int organizationalUnitId, Student student) {
        String studentCode;
        studentCode = collegeServiceExtensions.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SUBMIT, organizationalUnitId, student);
        return studentCode;
    }

    @PreAuthorize("hasRole('student')")
    @RequestMapping(value = "/personal/mydetails", method = RequestMethod.GET)
    public String setupFormPersonalForLoggedInStudent(ModelMap model, HttpServletRequest request) {

        Student student = verifyStudent();

        boolean newForm = opusMethods.isNewForm(request);
        return REDIRECT_PERSONAL_VIEW + "?newForm=" + newForm + "&studentId=" + student.getStudentId();
    }

    @PreAuthorize("hasRole('student')")
    @RequestMapping(value = "/subscription/mydetails", method = RequestMethod.GET)
    public String setupFormSubscriptionForLoggedInStudent(ModelMap model, HttpServletRequest request) {

        Student student = verifyStudent();

        boolean newForm = opusMethods.isNewForm(request);
        int tab = ServletUtil.getIntParam(request, "tab", 2);
        return REDIRECT_SUBSCRIPTION_VIEW + "?newForm=" + newForm + "&studentId=" + student.getStudentId() + "&tab=" + tab;
    }

    private Student verifyStudent() {
        OpusUser opusUser = opusMethods.getOpusUser();
        Student student = opusUser.getStudent();
        if (student == null) {
            throw new RuntimeException("Logged-in user is not a student");
        }
        return student;
    }

    /**
     * Store data and show personal data view.
     * 
     * @param studentForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(value = "/personal", method = RequestMethod.POST)
    public String processSubmitPersonal(@ModelAttribute(FORM_NAME) StudentForm studentForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {
        return processSubmit(REDIRECT_PERSONAL_VIEW, studentForm, result, status, request);
    }

    /**
     * Store data and show subscription data view.
     * 
     * @param studentForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(value = "/subscription", method = RequestMethod.POST)
    public String processSubmitSubscription(@ModelAttribute(FORM_NAME) StudentForm studentForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {
        return processSubmit(REDIRECT_SUBSCRIPTION_VIEW, studentForm, result, status, request);
    }

    private String processSubmit(String redirectView, StudentForm studentForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        StudentFormShared shared = studentForm.getStudentFormShared();
        NavigationSettings navigationSettings = shared.getNavigationSettings();

        HttpSession session = request.getSession(false);
        Student student = shared.getStudent();
        String dbPw = "";

        if (log.isDebugEnabled()) {
            log.debug("StudentPersonalEditController.processSubmit entered...");
        }

        /*
         * used to create personCode and studentCode if necessary. DO NOT use the name "organizationalUnitId" in this instance: it will
         * create errors in the application.
         */
        int tmpOrganizationalUnitId = 0;
        String showStudentError = "";

        // String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Locale currentLoc = RequestContextUtils.getLocale(request);

        OpusUserRole studentOpusUserRole = studentForm.getPersonOpusUserRole();
        OpusUser studentOpusUser = studentForm.getOpusUser();

        /* if a country of birth is chosen, but no province then also district has to be empty */
        if ("".equals(student.getCountryOfBirthCode()) || "0".equals(student.getCountryOfBirthCode())) {
            student.setProvinceOfBirthCode("");
            student.setDistrictOfBirthCode("");
        } else {
            if ("".equals(student.getProvinceOfBirthCode()) || "0".equals(student.getProvinceOfBirthCode())) {
                student.setDistrictOfBirthCode("");
            }
        }
        /* if a country of origin is chosen, but no province then also district has to be empty */
        if ("".equals(student.getCountryOfOriginCode()) || "0".equals(student.getCountryOfOriginCode())) {
            student.setProvinceOfOriginCode("");
            student.setDistrictOfOriginCode("");
        } else {
            if ("".equals(student.getProvinceOfOriginCode()) || "0".equals(student.getProvinceOfOriginCode())) {
                student.setDistrictOfOriginCode("");
            }
        }

        /* if personCode or studentCode are made empty, give default values */
        tmpOrganizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        if (StringUtil.isNullOrEmpty(student.getPersonCode())) {
            /* generate personCode */
            String personCode = StringUtil.createUniqueCode("P", "" + tmpOrganizationalUnitId);
            student.setPersonCode(personCode);

        }

        // -- validation --
        result.pushNestedPath("studentFormShared.student");
        studentValidator.validate(student, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            // put lookups on the request again TODO put on form instead of using request
            // lookupCacher.getPersonLookups(preferredLanguage, request);
            // lookupCacher.getAddressLookups(preferredLanguage, request);
            // lookupCacher.getStudentLookups(preferredLanguage, request);
            //
            // request.setAttribute("from", "student");
            // request.setAttribute("command", student);
            referenceData(request, shared.getStudent());

            return FORM_VIEW;
        }

        if (StringUtil.isNullOrEmpty(student.getStudentCode())) {
            String studentCode = createUniqueStudentNumberOnSubmit(tmpOrganizationalUnitId, student);
            student.setStudentCode(studentCode);
        }

        boolean pwdChanged = false;
        String newPasswordInClear = null;

        // add student
        if (student.getStudentId() == 0) {

            String showStudentErrorCode = studentManager.validateNewStudent(student, currentLoc);
            if (!StringUtil.isNullOrEmpty(showStudentErrorCode)) {
                showStudentError = messageSource.getMessage(showStudentErrorCode, null, currentLoc);
            }
            if (StringUtil.isNullOrEmpty(showStudentError)) {

                newPasswordInClear = student.getPersonCode();
                studentOpusUser.setPw(Encode.encodeMd5(newPasswordInClear));
                studentManager.addStudent(student, studentOpusUserRole, studentOpusUser);
                pwdChanged = true;
            }
            // update student
        } else {
            // don't change the opusUserRole
            studentOpusUserRole = null;
            studentOpusUser = null;

            studentManager.updateStudent(student, studentOpusUserRole, studentOpusUser, dbPw);
        }

        if (pwdChanged) {
            // if the user is new or the password has changed, show new password on new screen
            request.setAttribute("tab", navigationSettings.getTab());
            request.setAttribute("panel", navigationSettings.getPanel());
            request.setAttribute("username", studentOpusUser.getUsername());
            request.setAttribute("password", newPasswordInClear);
            request.setAttribute("studentId", student.getStudentId());
            request.setAttribute("from", "student");
            request.setAttribute("currentPageNumber", navigationSettings.getCurrentPageNumber());

            return "college/person/pw";

        } else {

            // status.setComplete();

            return redirectView + "?tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() + "&studentId=" + student.getStudentId()
                    + "&from=student" + "&showStudentError=" + showStudentError + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        }
    }

    @RequestMapping(value = "/deleteStudyplan")
    public String deleteStudyPlan(@ModelAttribute(FORM_NAME) IStudentForm studentForm, BindingResult result, HttpServletRequest request) {

        /* perform privilege check. If wrong, this throws an Exception towards ErrorController */
        if (!request.isUserInRole("DELETE_STUDY_PLANS")) {
            String err = "opusUserRole does not have the correct privilege to perform this action";
            log.warn(err);
            throw new OpusSecurityException(err);
        }

        int studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
        int studentId = ServletUtil.getIntParam(request, "studentId", 0);

        NavigationSettings navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings);

        if (studyPlanId != 0 && studentId != 0) {

            // Study plan cannot be deleted if subject results or examination results are present
            // either within a subject block subject or within a loose subject
            List<StudyPlanDetail> studyPlanDetails = studentManager.findStudyPlanDetailsForStudyPlan(studyPlanId);

            for (int i = 0; i < studyPlanDetails.size(); i++) {
                int subjectId = studyPlanDetails.get(i).getSubjectId();
                int studyPlanDetailId = studyPlanDetails.get(i).getId();
                if (subjectId != 0) {
                    // LOOSE SUBJECT
                    checkSubjectOrExaminationResults(result, subjectId, studyPlanDetailId);
                } else {
                    if (studyPlanDetails.get(i).getSubjectBlockId() != 0) {
                        // SUBJECT - SUBJECTBLOCK
                        List<Subject> subjects = subjectBlockMapper.findSubjectsForSubjectBlockInStudyPlainDetail(studyPlanDetails.get(i).getSubjectBlockId());
                        for (Subject subject : subjects) {
                            checkSubjectOrExaminationResults(result, subject.getId(), studyPlanDetailId);

                        }
                    }
                }
            }

            if (result.hasErrors()) {
                return FORM_VIEW;
            }

            // delete obtained qualifications
            studyManager.deleteObtainedQualificationsByStudyPlanId(studyPlanId);
            // delete careerPositions
            studyManager.deleteCareerPositionsByStudyPlanId(studyPlanId);
            // delete referees
            studyManager.deleteRefereesByStudyPlanId(studyPlanId);

            studentManager.deleteStudyPlan(studyPlanId, opusMethods.getWriteWho(request));
        }

        return "redirect:/college/student/subscription.view?newForm=true&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel()
                + "&studentId=" + studentId + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    private void checkSubjectOrExaminationResults(BindingResult result, int subjectId, int studyPlanDetailId) {

        Map<String, Object> resultListMap = new HashMap<>();
        resultListMap.put("studyPlanDetailId", studyPlanDetailId);
        resultListMap.put("subjectId", subjectId);
        List<SubjectResult> subjectResultsForStudyPlanDetail = resultManager.findSubjectResultsByParams(resultListMap);

        if (subjectResultsForStudyPlanDetail != null && subjectResultsForStudyPlanDetail.size() != 0) {
            // show error for linked results
            Subject subject = subjectManager.findSubject(subjectId);
            result.reject("jsp.error.general.delete.linked.subjectresult", new Object[] { subject.getSubjectDescription() }, "subject result exists");
        } else {
            // examination cannot be deleted if examination results are present
            List<ExaminationResult> examinationResultListForStudyPlanDetail = resultManager.findExaminationResultsForStudyPlanDetail(resultListMap);
            if (examinationResultListForStudyPlanDetail.size() != 0) {
                // show error for linked results
                Subject s = subjectManager.findSubject(subjectId);
                Examination e = examinationManager.findExamination(examinationResultListForStudyPlanDetail.get(0).getExaminationId());
                result.reject("jsp.error.general.delete.linked.examinationresult",
                        new Object[] { s.getSubjectDescription() + " / " + e.getExaminationDescription() }, "examination result exists");
                result.reject("jsp.error.general.delete.linked.examinationresult");
            }
        }
    }

    @RequestMapping(value = "/personal", method = RequestMethod.POST, params = "submitter=organization.institutionId")
    public String institutionChanged(HttpServletRequest request, @ModelAttribute(FORM_NAME) StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        opusMethods.loadBranches(studentForm.getOrganization());
        setPrimaryStudyAndAllStudies(studentForm);
        referenceData(request, shared.getStudent());
        return FORM_VIEW;
    }

    @RequestMapping(value = "/personal", method = RequestMethod.POST, params = "submitter=organization.branchId")
    public String branchChanged(HttpServletRequest request, @ModelAttribute(FORM_NAME) StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        opusMethods.loadOrganizationalUnits(studentForm.getOrganization());
        setPrimaryStudyAndAllStudies(studentForm);
        referenceData(request, shared.getStudent());
        return FORM_VIEW;
    }

    @RequestMapping(value = "/personal", method = RequestMethod.POST, params = "submitter=organization.organizationalUnitId")
    public String organizationalUnitChanged(HttpServletRequest request, @ModelAttribute(FORM_NAME) StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        setPrimaryStudyAndAllStudies(studentForm);
        referenceData(request, shared.getStudent());
        return FORM_VIEW;
    }

    private void setPrimaryStudyAndAllStudies(StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        shared.getStudent().setPrimaryStudyId(0);
        loadAllStudies(studentForm);
    }

    @RequestMapping(value = "/subscription", method = RequestMethod.POST, params = "submitter=previousInstitutionCountryCode")
    public String previousInstitutionCountryCodeChanged(HttpServletRequest request, @ModelAttribute(FORM_NAME) StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        addressLookupBuilder.loadProvinces(studentForm.getPreviousInstitutionAddressLookup(), shared.getStudent().getPreviousInstitutionCountryCode());
        studentForm.getPreviousInstitutionAddressLookup().setAllDistricts(null);
        shared.getStudent().setPreviousInstitutionProvinceCode(null);
        shared.getStudent().setPreviousInstitutionDistrictCode(null);
        referenceData(request, shared.getStudent());
        return FORM_VIEW;
    }

    @RequestMapping(value = "/subscription", method = RequestMethod.POST, params = "submitter=previousInstitutionProvinceCode")
    public String previousInstitutionProvinceCodeChanged(HttpServletRequest request, @ModelAttribute(FORM_NAME) StudentForm studentForm) {

        StudentFormShared shared = studentForm.getStudentFormShared();

        addressLookupBuilder.loadDistricts(studentForm.getPreviousInstitutionAddressLookup(), shared.getStudent().getPreviousInstitutionProvinceCode());
        shared.getStudent().setPreviousInstitutionDistrictCode(null);
        referenceData(request, shared.getStudent());
        return FORM_VIEW;
    }

}
