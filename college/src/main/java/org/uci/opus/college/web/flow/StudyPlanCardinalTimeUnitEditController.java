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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.domain.util.IdToSubjectBlockMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.StudyPlanCardinalTimeUnitValidator;
import org.uci.opus.college.validator.StudyPlanDetailDeleteValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyPlanCardinalTimeUnitForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: StudyPlanCardinalTimeUnitEditController.
 */

@Controller
@RequestMapping("/college/studyplancardinaltimeunit.view")
@SessionAttributes({ StudyPlanCardinalTimeUnitEditController.FORM })
public class StudyPlanCardinalTimeUnitEditController {

    public static final String FORM = "studyPlanCardinalTimeUnitForm";

    private static Logger log = LoggerFactory.getLogger(StudyPlanCardinalTimeUnitEditController.class);
    private String formView;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private OpusInit opusInit;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudyPlanDetailDeleteValidator studyPlanDetailDeleteValidator;
    @Autowired private SubjectManagerInterface subjectManager;

    @Autowired private List <Module> modules;


    public StudyPlanCardinalTimeUnitEditController() {
        super();

        this.formView = "college/person/studyPlanCardinalTimeUnit";
    }

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        // declare variables
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        StudyPlan studyPlan = null;
        Student student = null;
        StudyGradeType studyGradeType = null;
        Study study = null;
        StudyGradeType minorStudyGradeType = null;

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int maxNumberOfCardinalTimeUnits = 0;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));

        Locale currentLoc = RequestContextUtils.getLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        int studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
//        int cardinalTimeUnitNumber = ServletUtil.getIntParam(request, "cardinalTimeUnitNumber", 0);

        // either studyPlanCardinalTimeUnitId or studyPlanId/cardinalTimeUnitNumber have to be present
        int studyPlanCardinalTimeUnitId = ServletUtil.getIntParam(request, "studyPlanCardinalTimeUnitId", 0);
        int studyPlanId;
        
        StudyPlanCardinalTimeUnitForm studyPlanCardinalTimeUnitForm = (StudyPlanCardinalTimeUnitForm) model.get(FORM);
        if (studyPlanCardinalTimeUnitForm == null || studyPlanCardinalTimeUnitId != studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit().getId()) {
            studyPlanCardinalTimeUnitForm = new StudyPlanCardinalTimeUnitForm();
            model.addAttribute(FORM, studyPlanCardinalTimeUnitForm);

            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
            
            if (studyPlanCardinalTimeUnitId != 0) {
                // EXISTING STUDYPLANCARDINALTIMEUNIT
                studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
                studyPlanId = studyPlanCardinalTimeUnit.getStudyPlanId();

                //               MP: todo
                //               List <Rfc> rfcs = rfcManager.findRfcs(OpusConstants.RFC_ENTITY_TYPE_STUDYPLANCARDINALTIMEUNIT,
                //                       studyPlanCardinalTimeUnitId);
                //               studyPlanCardinalTimeUnit.setRfcs(rfcs);

            } else {

                // NEW STUDYPLANCARDINALTIMEUNIT
                studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
                int cardinalTimeUnitNumber = ServletUtil.getIntParam(request, "cardinalTimeUnitNumber", 0);

                studyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
                studyPlanCardinalTimeUnit.setStudyPlanId(studyPlanId);
                studyPlanCardinalTimeUnit.setActive("Y");
                studyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
                studyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode(appConfigManager.getCntdRegistrationInitialCardinalTimeUnitStatus());
                studyPlanCardinalTimeUnit.setTuitionWaiver("N");
                studyPlanCardinalTimeUnit.setStudyIntensityCode(OpusConstants.STUDY_INTENSITY_FULLTIME);

            }

            studyPlan = studentManager.findStudyPlan(studyPlanId);
            student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());
            study = studyManager.findStudy(studyPlan.getStudyId());

            studyPlanCardinalTimeUnitForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            studyPlanCardinalTimeUnitForm.setStudyPlan(studyPlan);
            studyPlanCardinalTimeUnitForm.setStudent(student);

            
            
            // find organization id's matching with the study
            organizationalUnitId = study.getOrganizationalUnitId();
            branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            institutionId = institutionManager.findInstitutionOfBranch(branchId);

            if (studyPlanCardinalTimeUnit.getStudyGradeTypeId() != 0) {
                studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
            } else {
                // no studyplanctu's defined yet:
                AcademicYear academicYear = academicYearManager.getCurrentAcademicYear();

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("preferredLanguage", preferredLanguage);
                map.put("studyId", studyPlan.getStudyId());
                map.put("gradeTypeCode", studyPlan.getGradeTypeCode());
                map.put("currentAcademicYearId", academicYear.getId());
                map.put("studyTimeCode", OpusConstants.STUDY_TIME_DAYTIME);
                map.put("studyFormCode", OpusConstants.STUDY_FORM_REGULAR);
                if ("Y".equals(session.getAttribute("iUseOfPartTimeStudyGradeTypes"))) {
                    map.put("studyIntensityCode", OpusConstants.STUDY_INTENSITY_FULLTIME);
                }
                studyGradeType = studyManager.findStudyGradeTypeByParams(map);
                
                // Set the default study grade type according to the study plan, because this is what we usually want
                if (studyGradeType != null) {
                    studyPlanCardinalTimeUnit.setStudyGradeTypeId(studyGradeType.getId());
                }
            }
            studyPlanCardinalTimeUnitForm.setStudyGradeType(studyGradeType);

            loadStudyGradeTypeRelatedData(studyPlanCardinalTimeUnitForm);


            // get the organization values from study:
            organization = new Organization();
            organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
            studyPlanCardinalTimeUnitForm.setOrganization(organization);

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            studyPlanCardinalTimeUnitForm.setNavigationSettings(navigationSettings);

            
            // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                    session, request, organization.getInstitutionTypeCode(),
                    organization.getInstitutionId(), organization.getBranchId(), 
                    organization.getOrganizationalUnitId());

            /* put lookup-tables on the request */
            lookupCacher.getPersonLookups(preferredLanguage, request);
            lookupCacher.getStudentLookups(preferredLanguage, request);
            lookupCacher.getStudyLookups(preferredLanguage, request);
            lookupCacher.getStudyPlanLookups(preferredLanguage, request);
            lookupCacher.getSubjectLookups(preferredLanguage, request);

            studyPlanCardinalTimeUnitForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
            studyPlanCardinalTimeUnitForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
            studyPlanCardinalTimeUnitForm.setCodeToImportanceTypeMap(new CodeToLookupMap(lookupCacher.getAllImportanceTypes(preferredLanguage)));
            studyPlanCardinalTimeUnitForm.setCodeToRigidityTypeMap(new CodeToLookupMap(lookupCacher.getAllRigidityTypes(preferredLanguage)));
            studyPlanCardinalTimeUnitForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));
            List<Lookup> allStudyIntensities = lookupCacher.getAllStudyIntensities(preferredLanguage);
            studyPlanCardinalTimeUnitForm.setAllStudyIntensities(allStudyIntensities);
            studyPlanCardinalTimeUnitForm.setCodeToStudyIntensityMap(new CodeToLookupMap(allStudyIntensities));
            List<Lookup7> allProgressStatuses = lookupCacher.getAllProgressStatuses(preferredLanguage);
            studyPlanCardinalTimeUnitForm.setAllProgressStatuses(allProgressStatuses);
            studyPlanCardinalTimeUnitForm.setCodeToProgressStatusMap(new CodeToLookupMap(allProgressStatuses));

            List<Lookup> allCardinalTimeUnitStatuses = lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage);
            studyPlanCardinalTimeUnitForm.setCodeToCardinalTimeUnitStatusMap(new CodeToLookupMap(allCardinalTimeUnitStatuses));
            
            // filter cardinaltimeunitstatuses for part time students:
            if (studyGradeType != null) {
                if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyGradeType.getStudyIntensityCode())) {
                    
                    int positionOfCustomizeProgramme = 0;
//                    allCardinalTimeUnitStatuses = (List < ? extends Lookup >) request.getAttribute("allCardinalTimeUnitStatuses");
                    // remove 'customize programme:
                    for (int i = 0; i < allCardinalTimeUnitStatuses.size();i++) {
                        if (OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME.equals(allCardinalTimeUnitStatuses.get(i).getCode())) {
                            positionOfCustomizeProgramme = i;
                            break;
                        }
                    }
                    allCardinalTimeUnitStatuses.remove(positionOfCustomizeProgramme);
                }
            }
            studyPlanCardinalTimeUnitForm.setAllCardinalTimeUnitStatuses(allCardinalTimeUnitStatuses);

            /* study domain attributes */
            studyPlanCardinalTimeUnitForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
            studyPlanCardinalTimeUnitForm.setIdToAcademicYearMap(new IdToAcademicYearMap(studyPlanCardinalTimeUnitForm.getAllAcademicYears()));

            
            
            // calculate total number of subjects in this cardinaltimeunit (for maximum values):
            List<StudyPlanDetail> studyPlanDetails = studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit().getStudyPlanDetails();
            List<StudyPlanDetail> nonExemptStudyPlanDetails = studentManager.extractNonExempted(studyPlanDetails);
            int totalNumberOfSubjects = studyManager.countSubjectsInStudyPlanDetails(nonExemptStudyPlanDetails);
            studyPlanCardinalTimeUnitForm.setTotalNumberOfSubjects(totalNumberOfSubjects);

            if (studyPlanDetails != null && studyPlanDetails.size() != 0) {
                for (StudyPlanDetail sdp : studyPlanDetails) {
                    StudyGradeType studyPlanDetailsStudyGradetype = studyManager.findStudyGradeType(sdp.getStudyGradeTypeId());
                    if (studyPlanCardinalTimeUnitForm.getStudyGradeType().getCurrentAcademicYearId() != studyPlanDetailsStudyGradetype.getCurrentAcademicYearId()) {
                        log.warn("non matching academic years of studyPlanCardinalTimeUnit.studygradetype (id = " + studyPlanCardinalTimeUnitForm.getStudyGradeType().getId()
                                + ") and of studyplandetail (id = " + studyPlanDetailsStudyGradetype.getId() + ")");
                        // non matching studygradetype / studyplandetails:
                        studyPlanCardinalTimeUnitForm.setTxtMsg(studyPlanCardinalTimeUnitForm.getTxtMsg()
                                + messageSource.getMessage("jsp.msg.studygradetype.studyplandetails.nonmatching", null, currentLoc));
                        break;
                    }
                }
            }

            List<SubjectBlock> allSubjectBlocks = null;
            List<Subject> allSubjects = null;
            
            if (studyPlanCardinalTimeUnitId != 0) {

//                List<Integer> studyGradeTypeIds = DomainUtil.getProperties(studyPlanDetails, "studyGradeTypeId");
//                List<StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(studyGradeTypeIds, preferredLanguage);
//                studyPlanCardinalTimeUnitForm.setAllStudyGradeTypes(allStudyGradeTypes);
//                studyPlanCardinalTimeUnitForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(allStudyGradeTypes));
                
                allSubjectBlocks = studentManager.findSubjectBlocksForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
                studyPlanCardinalTimeUnitForm.setIdToSubjectBlockMap(new IdToSubjectBlockMap(allSubjectBlocks));
        //        studyPlanForm.setAllSubjectBlocks(subjectManager.findSubjectBlocks(findMap));
        //        List < Subject > allSubjects = subjectManager.findSubjects(findMap);
                
                allSubjects = subjectManager.findSubjectsForStudyPlan(studyPlanId);
                //List < Subject > allBlockedSubjects = subjectManager.findBlockedSubjects(findMap); 
                //allSubjects.addAll(allBlockedSubjects);
        //        studyPlanForm.setAllSubjects(allSubjects);
                studyPlanCardinalTimeUnitForm.setIdToSubjectMap(new IdToSubjectMap(allSubjects));

                //  SUBJECTBLOCKSTUDYGRADETYPES & SUBJECTSTUDYGRADETYPES
            
                List<Integer> studyPlanDetailIds = DomainUtil.getIds(studyPlanDetails);

                List<SubjectBlockStudyGradeType> subjectBlockStudyGradeTypes = subjectManager.findSubjectBlockStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
                studyPlanCardinalTimeUnitForm.setAllSubjectBlockStudyGradeTypes(subjectBlockStudyGradeTypes);

                List<SubjectStudyGradeType> allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
                // add the (virtual) blocked subjectstudygradetypes from the previous studyplancardinaltimeunit too, in case one or more have to be repeated:
                List<Integer> subjectBlockStudyGradeTypeIds = DomainUtil.getIds(subjectBlockStudyGradeTypes);
                List<SubjectStudyGradeType> blockedSubjectStudyGradeTypes = subjectManager.findBlockedSubjectStudyGradeTypeByParams(subjectBlockStudyGradeTypeIds);
                allSubjectStudyGradeTypes.addAll(blockedSubjectStudyGradeTypes);
                studyPlanCardinalTimeUnitForm.setAllSubjectStudyGradeTypes(allSubjectStudyGradeTypes);
            }

            // allStudyGradeTypes needed for combo - both if new or existing studyPlanCardinalTimeUnit
            Map<String, Object> findMap = new HashMap<>();
            findMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, organization);
            findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            findMap.put("preferredLanguage", preferredLanguage);
            findMap.put("studyId", 0);
            findMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
            List<StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(findMap);
            studyPlanCardinalTimeUnitForm.setAllStudyGradeTypes(allStudyGradeTypes);
            studyPlanCardinalTimeUnitForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(allStudyGradeTypes));

            // allStudies: for allStudygradetypes, allSubjectBlocks and allSubjects
            List<Integer> studyIds = DomainUtil.getIntProperties(allStudyGradeTypes, "studyId");
            studyIds.addAll(DomainUtil.getIntProperties(allSubjects, "primaryStudyId"));
            studyIds.addAll(DomainUtil.getIntProperties(allSubjectBlocks, "primaryStudyId"));
            List<Study> allStudies = studyManager.findStudies(studyIds, preferredLanguage);
            studyPlanCardinalTimeUnitForm.setIdToStudyMap(new IdToStudyMap(allStudies));

            // Org. units
            List<Integer> organizationalUnitIds = DomainUtil.getIntProperties(allStudies, "organizationalUnitId");
            List<OrganizationalUnit> allOrgUnits = organizationalUnitManager.findOrganizationalUnitsByIds(organizationalUnitIds);
            studyPlanCardinalTimeUnitForm.setIdToOrganizationalUnitMap(new IdToOrganizationalUnitMap(allOrgUnits));


        }



        // MESSAGES
        studyPlanCardinalTimeUnitForm.setTxtMsg(request.getParameter("txtMsg"));

        return formView;
    }

    private void loadStudyGradeTypeRelatedData(StudyPlanCardinalTimeUnitForm studyPlanCardinalTimeUnitForm) {

        int maxNumberOfCardinalTimeUnits;
        CardinalTimeUnitStudyGradeType cardinalTimeUnitStudyGradeType = null;
        int maxNumberOfSubjects = 0;

        StudyGradeType studyGradeType = studyPlanCardinalTimeUnitForm.getStudyGradeType();
        if (studyGradeType != null) {

            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit();

            // CardinalTimeUnitStudyGradeType holds data on number of elective subjects and blocks
            Map<String, Object> findMap = new HashMap<String, Object>();
            findMap.put("studyGradeTypeId", studyGradeType.getId());
            findMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
            cardinalTimeUnitStudyGradeType = studyManager.findCardinalTimeUnitStudyGradeTypeByParams(findMap);

            maxNumberOfSubjects = studyGradeType.getMaxNumberOfSubjectsPerCardinalTimeUnit();

            maxNumberOfCardinalTimeUnits = studyManager.findMaxCardinalTimeUnitNumberForStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        } else {
            maxNumberOfCardinalTimeUnits = opusInit.getMaxCardinalTimeUnits();
        }

        studyPlanCardinalTimeUnitForm.setCardinalTimeUnitStudyGradeType(cardinalTimeUnitStudyGradeType);
        studyPlanCardinalTimeUnitForm.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);

        // if unspecified (= 0), then take application init parameter
        if (maxNumberOfSubjects == 0) {
            maxNumberOfSubjects = opusInit.getMaxSubjectsPerCardinalTimeUnit();
        }
        studyPlanCardinalTimeUnitForm.setMaxNumberOfSubjectsPerCardinalTimeUnit(maxNumberOfSubjects);
    }

    // studyGradeTypeId changed; we fetch it by: "params = .."
    @RequestMapping(method=RequestMethod.POST, params="submitFormObject=studyGradeTypeIdSelect")
    public String processStudyGradeTypeCombo(
            @ModelAttribute(FORM) StudyPlanCardinalTimeUnitForm studyPlanCardinalTimeUnitForm, BindingResult result,
            SessionStatus status, HttpServletRequest request) {

        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit();
        
        int studyGradeTypeId = studyPlanCardinalTimeUnit.getStudyGradeTypeId();
        StudyGradeType studyGradeType = studyGradeTypeId == 0 ? null : studyManager.findStudyGradeType(studyGradeTypeId);
        studyPlanCardinalTimeUnitForm.setStudyGradeType(studyGradeType);
        
        loadStudyGradeTypeRelatedData(studyPlanCardinalTimeUnitForm);
        
        return formView;
    }


    /**
     * @param studyForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute(FORM) 
            StudyPlanCardinalTimeUnitForm studyPlanCardinalTimeUnitForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

        NavigationSettings navigationSettings = studyPlanCardinalTimeUnitForm.getNavigationSettings();
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit();

        String submitFormObject = "";
        HttpSession session = request.getSession(false);

        Locale currentLoc = RequestContextUtils.getLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Student student = studyPlanCardinalTimeUnitForm.getStudent();
        StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit = null;
        int academicYearId = 0;

        if (studyPlanCardinalTimeUnitForm.getStudyGradeType() == null || 
                studyPlanCardinalTimeUnit.getStudyGradeTypeId() != studyPlanCardinalTimeUnitForm.getStudyGradeType().getId()) {
            studyPlanCardinalTimeUnitForm.setStudyGradeType(
                    studyManager.findStudyGradeType(studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit().getStudyGradeTypeId()));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {

            new StudyPlanCardinalTimeUnitValidator().validate(
                    studyPlanCardinalTimeUnitForm, result);
            if (result.hasErrors()) {

                /* re-fill lookup-tables with right values */
                lookupCacher.getPersonLookups(preferredLanguage, request);
                lookupCacher.getStudentLookups(preferredLanguage, request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                lookupCacher.getStudyPlanLookups(preferredLanguage, request);
                lookupCacher.getSubjectLookups(preferredLanguage, request);

                return formView;
            }

            Map<String, Object> map = new HashMap<String, Object>();
            map.put("studyPlanId", studyPlanCardinalTimeUnit.getStudyPlanId());
            map.put("studyGradeTypeId", studyPlanCardinalTimeUnit.getStudyGradeTypeId());
            map.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
            map.put("progressStatusCode", studyPlanCardinalTimeUnit.getProgressStatusCode());

            if (studyPlanCardinalTimeUnit.getId() == 0) {
                /* add new studyPlanCardinalTimeUnit - test if the combination already exists */
                if (studentManager.findStudyPlanCardinalTimeUnitByParams(map) != null) {

                    result.reject("jsp.error.studyplancardinaltimeunit.edit");
                    result.reject("jsp.error.general.alreadyexists");

                    return formView;

                } else {
                    studentManager.addStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, null, request);
                    // we need the newly assigned id, so let's load the new record
                    studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(
                            studyPlanCardinalTimeUnit.getStudyPlanId(),
                            studyPlanCardinalTimeUnit.getStudyGradeTypeId(),
                            studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());

                }
            } else {
                // deal with possible change in progress status that involves the graduating flag
                StudyPlanCardinalTimeUnit oldStudyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit.getId());
                studentManager.updateStudyPlanStatus(studyPlanCardinalTimeUnit.getStudyPlanId(), 
                        oldStudyPlanCardinalTimeUnit.getProgressStatusCode(), studyPlanCardinalTimeUnit.getProgressStatusCode(), 
                        preferredLanguage, opusMethods.getWriteWho(request));

                // update
                studentManager.updateStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            }

            status.setComplete();

            return "redirect:/college/studyplan.view?newForm=true&tab=1"   // want to go to spctu tab, not main tab
                    + "&panel=" + navigationSettings.getPanel()
                    + "&studentId=" + studyPlanCardinalTimeUnitForm.getStudent().getStudentId()
                    + "&studyPlanId=" + studyPlanCardinalTimeUnitForm.getStudyPlan().getId()
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        } else {
            // submit but no save: after combo box selection
            return formView;
        }

    }

    @RequestMapping(params="deleteStudyPlanDetail=true")
    public String deleteStudyPlanDetail(HttpServletRequest request, @ModelAttribute(FORM) StudyPlanCardinalTimeUnitForm studyPlanCardinalTimeUnitForm, BindingResult errors, 
            @RequestParam("studyPlanDetailId") int studyPlanDetailId) {
        
        StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
        studyPlanDetailDeleteValidator.validate(studyPlanDetail, errors);
        
        if (errors.hasErrors()) {
            return formView;
        }

        studentManager.deleteStudyPlanDetail(studyPlanDetailId, request);

        NavigationSettings navigationSettings = studyPlanCardinalTimeUnitForm.getNavigationSettings();
        return "redirect:/college/studyplancardinaltimeunit.view?newForm=true&tab=0" 
                + "&panel=0"
                + "&studyPlanCardinalTimeUnitId=" + studyPlanCardinalTimeUnitForm.getStudyPlanCardinalTimeUnit().getId()
                + "&studyPlanId=" + studyPlanCardinalTimeUnitForm.getStudyPlan().getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }
    

}
