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

import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.domain.util.StudyGradeTypeUtil;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.college.web.form.TransferStudentsForm;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.AcademicYearUtil;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;
import org.uci.opus.util.lookup.LookupUtil;

@Controller
@RequestMapping(value = "/college/person/transferStudents")
@SessionAttributes(TransferStudentsController.TRANSFER_STUDENTS_FORM)
public class TransferStudentsController {

    static final String TRANSFER_STUDENTS_FORM = "transferStudentsForm";
    private static Logger log = LoggerFactory.getLogger(TransferStudentsController.class);
    private static String formView = "college/person/transferStudents";

    @Autowired
    private AcademicYearUtil academicYearUtil;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private OpusInit opusInit;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    @Autowired
    private CollegeWebExtensions collegeWebExtensions;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;

    // The newForm parameter is only useful when coming from elsewhere (e.g. the menu).
    // So after removing session form objects, we can remove the newForm parameter
    @RequestMapping(params = "newForm='true'")
    public String setupFormViaGet(HttpServletRequest request, ModelMap model) {
        log.debug("setupFormViaGet - removing form session objects");
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(TRANSFER_STUDENTS_FORM, session, model, opusMethods.isNewForm(request));
        return "redirect:/college/person/transferStudents.view"; // without newForm=true
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(TRANSFER_STUDENTS_FORM, session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "student");

        TransferStudentsForm transferStudentsForm = (TransferStudentsForm) model.get(TRANSFER_STUDENTS_FORM);
        if (transferStudentsForm == null) {
            log.debug("no attribute transferStudentsForm found, creating one");
            transferStudentsForm = new TransferStudentsForm();

            model.addAttribute(TRANSFER_STUDENTS_FORM, transferStudentsForm);
        }

        return setupForm(request, transferStudentsForm, model);
    }

    @RequestMapping(method = RequestMethod.POST)
    // orgunit and study filter selection
    public String setupForm(HttpServletRequest request, TransferStudentsForm transferStudentsForm, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        TimeTrack timer = new TimeTrack("TransferStudentsController.setupForm");

        // get lookups
        lookupCacher.getAddressLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);

        StudentFilterBuilder fb = dealWithFilters(request, transferStudentsForm);

        // TODO put these maps into the form object, NB: see allCardinalTimeUnitsMap further down
        // for easier and faster JSP rendering, make maps out of lookup lists
        LookupUtil.putCodeToDescriptionMap(request, "allGradeTypes", "allGradeTypesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyForms", "allStudyFormsMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyTimes", "allStudyTimesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allCardinalTimeUnits", "allCardinalTimeUnitsMap");
        LookupUtil.putCodeToDescriptionMap(request, "allProgressStatuses", "allProgressStatusesMap");

        StudySettings studySettings = transferStudentsForm.getStudySettings();
        int studyId = studySettings.getStudyId();
        int academicYearId = studySettings.getAcademicYearId();
        int studyGradeTypeId = studySettings.getStudyGradeTypeId();
        Integer cardinalTimeUnitNumber = studySettings.getCardinalTimeUnitNumber();
        if (log.isDebugEnabled()) {
            log.debug("setupForm: academicYearId = " + academicYearId);
        }

        // init form lists
        List<AcademicYear> allAcademicYears = fb.getAllAcademicYears();
        transferStudentsForm.setAllAcademicYears(allAcademicYears);
        transferStudentsForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        transferStudentsForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
        transferStudentsForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));
        timer.measure("lookups");
        StudyGradeType sgt = null;

        // if all mandatory filters have been chosen, get the list of students and study plans CTUs
        if (cardinalTimeUnitNumber != null && cardinalTimeUnitNumber != 0) {

            // prepare performance filter entries
            sgt = studyManager.findStudyGradeType(studyGradeTypeId);
            Map<Integer, StudentPerformanceFilter> ctuSuccessOptions = buildPerformaceFilter(sgt.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit());
            transferStudentsForm.setCtuSuccessOptions(ctuSuccessOptions);

            // filter progress statuses: don't add incrementing statuses if in last CTU of SGT
            List<Lookup7> allProgressStatuses = (List<Lookup7>) request.getAttribute("allProgressStatuses");
            if (cardinalTimeUnitNumber == sgt.getNumberOfCardinalTimeUnits()) {
                for (Iterator<Lookup7> it = allProgressStatuses.iterator(); it.hasNext();) {
                    Lookup7 progressStatus = it.next();
                    if ("Y".equalsIgnoreCase(progressStatus.getIncrement())) {
                        it.remove();
                    }
                }
            }
            transferStudentsForm.setAllProgressStatuses(allProgressStatuses);
            transferStudentsForm.setCodeToProgressStatusMap(new CodeToLookupMap(allProgressStatuses));

            // determine possible target academic years: include current year if semester / trimester based
            List<AcademicYear> allTargetAcademicYears = transferStudentsForm.getNextAcademicYears();
            CodeToLookupMap allCardinalTimeUnitsMap = new CodeToLookupMap(lookupCacher.getAllCardinalTimeUnits(preferredLanguage));
            Lookup8 cardinalTimeUnit = (Lookup8) allCardinalTimeUnitsMap.get(sgt.getCardinalTimeUnitCode());
            if (cardinalTimeUnit.getNrOfUnitsPerYear() > 1) {
                AcademicYear currentAcademicYear = AcademicYearUtil.getAcademicYearById(allAcademicYears, academicYearId);
                allTargetAcademicYears.add(0, currentAcademicYear);
            }
            transferStudentsForm.setAllTargetAcademicYears(allTargetAcademicYears);

            Map<String, TimeUnitAndAcademicYear> progressStatusToTimeUnitMap = makeProgressStatusToTimeUnitMap(transferStudentsForm.getAllProgressStatuses(),
                    allAcademicYears, cardinalTimeUnit, cardinalTimeUnitNumber, academicYearId);
            transferStudentsForm.setProgressStatusToTimeUnitMap(progressStatusToTimeUnitMap);

            List<Integer> nextAcademicYearIds = DomainUtil.getIds(transferStudentsForm.getNextAcademicYears());
            List<Student> allStudents = null;
            Map<String, Object> parameterMap = new HashMap<>();
            parameterMap.put("studyId", studyId);
            parameterMap.put("studyGradeTypeId", studyGradeTypeId);
            parameterMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
            parameterMap.put("noHigherCardinalTimeUnitNumbers", "Y");
            parameterMap.put("studyplanStatusCodes",
                    Arrays.asList(OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION, OpusConstants.STUDYPLAN_STATUS_GRADUATED));
            parameterMap.put("nonExistingAcademicYearIds", nextAcademicYearIds);
            parameterMap.put("preferredLanguage", preferredLanguage);
            parameterMap.put("preferredPersonSorting", opusInit.getPreferredPersonSorting());

            if (log.isDebugEnabled()) {
                log.debug("Transferstudents : opusInit.getPreferredPersonSorting() =" + opusInit.getPreferredPersonSorting());
            }

            // Use ResultFormatter to fill up ctuResult objects in the for loop
            // CollegeWebExtensions collegeWebExtensions = (CollegeWebExtensions) session.getAttribute("collegeWebExtensions");
            CtuResultFormatter ctuResultFormatter = collegeWebExtensions.getCtuResultFormatter();
            transferStudentsForm.setCtuResultFormatter(ctuResultFormatter);

            if (!StringUtil.isNullOrEmpty((String) request.getAttribute("preselectStatuses")) && transferStudentsForm.getAllStudents() != null
                    && transferStudentsForm.getAllStudents().size() != 0) {
                // REload students from transferStudentsForm in case of preselect
                allStudents = transferStudentsForm.getAllStudents();
                request.setAttribute("preselectStatuses", null);

            } else {
                // NEW load students including one studyPlanCTU per student according to filters
                allStudents = studentManager.findStudentsWithCTUAndSubjectResults(parameterMap);
                timer.measure("findStudentsWithCTUAndSubjectResults");
            }

            // the statistics will give us an overview of student performance
            StudyPlanCardinalTimeUnitStatisticsFactory studyPlanCTUStatisticsFactory = new StudyPlanCardinalTimeUnitStatisticsFactory(
                    OpusMethods.getPreferredLocale(request));
            model.addAttribute("studyPlanCTUStatisticsFactory", studyPlanCTUStatisticsFactory);

            // filter students according to the selected performance option
            int ctuSuccessOptionKey = transferStudentsForm.getCtuSuccessOptionKey();
            StudentPerformanceFilter studentPerformanceFilter = transferStudentsForm.getCtuSuccessOptions().get(ctuSuccessOptionKey);
            filterStudents(allStudents, studentPerformanceFilter, studyPlanCTUStatisticsFactory); // remove students who don't fit the
                                                                                                  // selected performance criteria
            transferStudentsForm.setAllStudents(allStudents);

            // for onward studies (quota allocation), fill target study grade type combo
            parameterMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, transferStudentsForm.getOrganization());
            parameterMap.put("preferredLanguage", preferredLanguage);
            parameterMap.put("institutionTypeCode", transferStudentsForm.getOrganization().getInstitutionTypeCode());
            parameterMap.put("studyId", 0);
            parameterMap.put("currentAcademicYearIds", nextAcademicYearIds);
            List<StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(parameterMap);
            transferStudentsForm.setAllStudyGradeTypes(allStudyGradeTypes);
            transferStudentsForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(allStudyGradeTypes));
            timer.measure("findStudyGradeTypes");

            List<Integer> studyIds = DomainUtil.getIntProperties(allStudyGradeTypes, "studyId");
            List<Study> allStudies = studyManager.findStudies(studyIds, preferredLanguage);
            transferStudentsForm.setIdToStudyMap(new IdToStudyMap (allStudies));
            
            List<Integer> organizationalUnitIds = DomainUtil.getIntProperties(allStudies, "organizationalUnitId");
            List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnitsByIds(organizationalUnitIds);
            transferStudentsForm.setIdToOrganizationalUnitMap(new IdToOrganizationalUnitMap(organizationalUnits));

            for (Student student : allStudents) {
                StudyPlan studyPlan = student.getStudyPlans().get(0);

                // set progressStatusCode in the form for editing
                StudyPlanCardinalTimeUnit spctu = studyPlan.getStudyPlanCardinalTimeUnits().get(0);
                transferStudentsForm.getProgressStatusCodes().put(spctu.getId(), spctu.getProgressStatusCode());
                // transferStudentsForm.getStudyPlanCardinalTimeUnits().put(spctu.getId(), spctu);

                // initialize the default target academic year for each studyplan
                TimeUnitAndAcademicYear unitAndYear = progressStatusToTimeUnitMap.get(spctu.getProgressStatusCode());
                if (unitAndYear != null) {
                    transferStudentsForm.getTargetAcademicYearIds().put(spctu.getId(), unitAndYear.getAcademicYearId());
                }

                // fetch ctuResult related data to make it available in the ctuResult objects
                String gradeTypeCode = studyPlan.getGradeTypeCode();
                CardinalTimeUnitResult cardinalTimeUnitResult = spctu.getCardinalTimeUnitResult();
                // check for cardinalTimeUnitResult.getId() != 0 because loading through the huge sql map could create an empty cardinalTimeUnitResult object
                if (cardinalTimeUnitResult != null && cardinalTimeUnitResult.getId() != 0) {
                    ctuResultFormatter.loadAdditionalInfo(cardinalTimeUnitResult, gradeTypeCode, preferredLanguage);
                }

                // for graduated students, initialize the list of studyGradeTypes, with 1./2./3. choice on top
                int firstStudyId = studyPlan.getFirstChoiceOnwardStudyId();
                String firstGradeTypeCode = studyPlan.getFirstChoiceOnwardGradeTypeCode();
                StudyGradeType firstSgt = StudyGradeTypeUtil.findStudyGradeType(allStudyGradeTypes, firstStudyId, firstGradeTypeCode);
                if (firstSgt != null) {
                    transferStudentsForm.getFirstChoiceStudyGradeTypes().put(spctu.getId(), firstSgt);
                }
            }
            timer.measure("student looping");
        }
        timer.end();

        transferStudentsForm.setStudyGradeType(sgt);

        return formView; // point to the jsp file
    }

    private void filterStudents(List<Student> allStudents, StudentPerformanceFilter studentPerformanceFilter,
            StudyPlanCardinalTimeUnitStatisticsFactory studyPlanCTUStatisticsFactory) {

        if (studentPerformanceFilter == null)
            return;

        for (Iterator<Student> it = allStudents.iterator(); it.hasNext();) {
            Student student = it.next();
            StudyPlanCardinalTimeUnit spctu = getStudyPlan(student);
            StudyPlanCardinalTimeUnitStatistics statistics = studyPlanCTUStatisticsFactory.get(spctu);
            if (!studentPerformanceFilter.include(statistics)) {
                it.remove();
            }
        }
    }

    protected StudentFilterBuilder dealWithFilters(HttpServletRequest request, TransferStudentsForm transferStudentsForm) {
        HttpSession session = request.getSession(false);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        // create filter objects and initialize with request/session values
        Organization organization = transferStudentsForm.getOrganization();
        if (organization == null) {
            organization = new Organization();
            transferStudentsForm.setOrganization(organization);
            opusMethods.fillOrganization(session, request, organization);
        }
        StudySettings studySettings = transferStudentsForm.getStudySettings();
        if (studySettings == null) {
            studySettings = new StudySettings();
            transferStudentsForm.setStudySettings(studySettings);
            opusMethods.fillStudySettings(session, request, studySettings);
        }

        // init filter builder with current filter selections
        fb.updateFilterBuilder(transferStudentsForm.getOrganization());
        fb.updateFilterBuilder(transferStudentsForm.getStudySettings());

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS for filters
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, fb.getInstitutionTypeCode(), fb.getInstitutionId(), fb.getBranchId(),
                fb.getOrganizationalUnitId());

        fb.doLookups();
        lookupCacher.getAddressLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
        fb.loadStudies();
        fb.loadAcademicYears();
        fb.loadStudyGradeTypes(true);

        // organization and studySettings values may have changed during filter builder operations
        fb.updateOrganization(organization);
        fb.updateStudySettings(studySettings);

        // remember filter selections in session
        opusMethods.rememberOrganization(session, organization);
        opusMethods.rememberStudySettings(session, studySettings);

        // endgradecomments
        if (fb.getStudyGradeTypeId() != 0) {
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(fb.getStudyGradeTypeId());
            // see if the endGrades are defined on studygradetype level
            String endGradesPerGradeType = studyManager.findEndGradeType(studyGradeType.getCurrentAcademicYearId());
            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
                endGradesPerGradeType = "N";
            } else {
                endGradesPerGradeType = "Y";
            }

            if ("Y".equals(endGradesPerGradeType)) {
                // define StudyPlanResult's endgradetype:
                Map<String, Object> studyPlanEndGradeMap = new HashMap<>();
                studyPlanEndGradeMap.put("preferredLanguage", preferredLanguage);
                studyPlanEndGradeMap.put("endGradeTypeCode", studyGradeType.getGradeTypeCode());
                studyPlanEndGradeMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());
                transferStudentsForm.setFullEndGradeCommentsForGradeType(studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap));
                if (log.isDebugEnabled()) {
                    log.debug("transferStudentsController: fullEndGradeCommentsForGradeType.size() = "
                            + transferStudentsForm.getFullEndGradeCommentsForGradeType().size());
                }
            }
        }

        return fb;
    }

    // transferStudents button clicked: let's try to move students to a new cardinal time unit
    @Transactional
    @RequestMapping(params = "transferStudents")
    public String processTransferStudentSubmit(HttpServletRequest request, SessionStatus sessionStatus,
            @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm, BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // validate if at least one student has been selected
        List<Integer> selectedStudyPlanCTUIds = transferStudentsForm.getSelectedStudyPlanCTUIds();
        if (selectedStudyPlanCTUIds == null || selectedStudyPlanCTUIds.isEmpty()) {
            result.reject("jsp.error.transferstudents.noStudentsSelected");
        } else {
            for (int studyPlanCTUId : selectedStudyPlanCTUIds) {
                String progressStatusCode = transferStudentsForm.getProgressStatusCodes().get(studyPlanCTUId);
                Lookup7 progressStatus = (Lookup7) transferStudentsForm.getCodeToProgressStatusMap().get(progressStatusCode);

                if ("Y".equalsIgnoreCase(progressStatus.getGraduating())) {

                    // validate that for graduated students an onward study grade type has been selected
                    if (transferStudentsForm.getTargetStudyGradeTypeIds().get(studyPlanCTUId) == 0) {
                        result.reject("jsp.error.transferstudents.noonwardstudygradetype");
                    }

                } else {

                    // validate that for non-graduated students an academic year has been selected
                    if (transferStudentsForm.getTargetAcademicYearIds().get(studyPlanCTUId) == 0) {
                        result.reject("jsp.error.transferstudents.noacademicyear");
                    }

                }
            }

        }

        List<Integer> selectedStudyPlanIds = studentManager.findStudyPlanIds(selectedStudyPlanCTUIds);

        if (result.hasErrors()) {
            return setupForm(request, transferStudentsForm, model); // in case of error, no redirect
        }

        // prepare for transfer
        Map<String, TimeUnitAndAcademicYear> progressStatusToTimeUnitMap = transferStudentsForm.getProgressStatusToTimeUnitMap();
        // StudyGradeType sourceSGT = studyManager.findStudyGradeType(sourceStudyGradeTypeId);
        StudyGradeType sourceSGT = transferStudentsForm.getStudyGradeType();
        Locale locale = OpusMethods.getPreferredLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // let's create studyPlans, studyPlanCTUs and studyPlanDetails
        for (Student student : transferStudentsForm.getAllStudents()) {
            StudyPlan sourceStudyPlan = student.getStudyPlans().get(0);
            StudyPlanCardinalTimeUnit sourceSpctu = sourceStudyPlan.getStudyPlanCardinalTimeUnits().get(0);
            int studyPlanCTUId = sourceSpctu.getId();

            student.setWriteWho(opusMethods.getWriteWho(request));
            student.setStudentWriteWho(opusMethods.getWriteWho(request));

            // only process selected rows
            if (!selectedStudyPlanCTUIds.contains(studyPlanCTUId))
                continue;

            String progressStatusCode = transferStudentsForm.getProgressStatusCodes().get(studyPlanCTUId);
            Lookup7 progressStatus = (Lookup7) transferStudentsForm.getCodeToProgressStatusMap().get(progressStatusCode);

            // create new study plan for transfers to other studies
            StudyPlan targetStudyPlan;
            int targetStudyGradeTypeId;
            int targetCTUnr;
            if ("Y".equalsIgnoreCase(progressStatus.getGraduating())) {
                // 1. Graduating student: needs new study plan (different study)
                targetStudyGradeTypeId = transferStudentsForm.getTargetStudyGradeTypeIds().get(studyPlanCTUId);

                StudyPlan newStudyPlan = new StudyPlan();
                int studentId = student.getStudentId();
                StudyGradeType studyGradeType = studyManager.findStudyGradeType(targetStudyGradeTypeId, preferredLanguage);
                String studyPlanDescription = studyGradeType.getStudyDescription() + " - " + studyGradeType.getGradeTypeDescription();

                newStudyPlan.setActive("Y");
                newStudyPlan.setStudentId(studentId);
                newStudyPlan.setStudyId(studyGradeType.getStudyId());
                newStudyPlan.setGradeTypeCode(studyGradeType.getGradeTypeCode());
                newStudyPlan.setStudyPlanDescription(studyPlanDescription);
                newStudyPlan.setStudyPlanStatusCode(appConfigManager.getAdmissionInitialStudyPlanStatus());
                newStudyPlan.setApplicationNumber(sourceStudyPlan.getApplicationNumber()); // we don't have a new application number
                // adding the study plan to the database will assign an id
                studentManager.addStudyPlanToStudent(newStudyPlan, opusMethods.getWriteWho(request));

                targetStudyPlan = newStudyPlan;
                targetCTUnr = 1;

                // create studyPlanCTU to the target study plan
                StudyPlanCardinalTimeUnit spctu = assignStudentToCTU(targetStudyPlan, targetStudyGradeTypeId, targetCTUnr, progressStatus, request,
                        sourceSpctu);

                // create compulsory studyPlanDetails
                // String iMajorMinor = (String) session.getAttribute("iMajorMinor");
                String iMajorMinor = opusInit.getMajorMinor();
                String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");

                studentManager.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(spctu, locale, preferredLanguage, iMajorMinor,
                        iUseOfPartTimeStudyGradeTypes);

                // finally set the primary study for the student to the new study
                student.setPrimaryStudyId(studyGradeType.getStudyId());

                studentManager.updateStudent(student, null, null, null);

            } else if ("Y".equalsIgnoreCase(progressStatus.getContinuing())) {
                // 2. normal transfer of students to a new study plan cardinal time unit
                targetStudyPlan = sourceStudyPlan;

                int targetAcademicYearId = transferStudentsForm.getTargetAcademicYearIds().get(studyPlanCTUId);
                Map<String, Object> params = new HashMap<>();
                params.put("studyId", sourceSGT.getStudyId());
                params.put("gradeTypeCode", sourceSGT.getGradeTypeCode());
                params.put("studyTimeCode", sourceSGT.getStudyTimeCode());
                params.put("studyFormCode", sourceSGT.getStudyFormCode());
                if ("Y".equals(session.getAttribute("iUseOfPartTimeStudyGradeTypes"))) {
                    // find out if a switch between parttime / fulltime must be made:
                    if ((OpusConstants.PROGRESS_STATUS_TO_PARTTIME).equals(progressStatus.getCode())) {
                        params.put("studyIntensityCode", "P");
                    } else {
                        if ((OpusConstants.PROGRESS_STATUS_TO_FULLTIME).equals(progressStatus.getCode())) {
                            params.put("studyIntensityCode", "F");
                        } else {
                            params.put("studyIntensityCode", sourceSGT.getStudyIntensityCode());
                        }
                    }
                }
                params.put("currentAcademicYearId", targetAcademicYearId);
                params.put("preferredLanguage", preferredLanguage);
                StudyGradeType studyGradeType = studyManager.findStudyGradeTypeByParams(params);
                if (studyGradeType == null) {
                    result.reject("jsp.error.transferstudents.notargetstudygradetype");
                    break;
                }

                targetStudyGradeTypeId = studyGradeType.getId();

                TimeUnitAndAcademicYear unitAndYear = progressStatusToTimeUnitMap.get(progressStatusCode);
                targetCTUnr = unitAndYear.getCardinalTimeUnitNumber();

                // create studyPlanCTU to the target study plan
                StudyPlanCardinalTimeUnit targetSpctu = assignStudentToCTU(targetStudyPlan, targetStudyGradeTypeId, targetCTUnr, progressStatus, request,
                        sourceSpctu);

                // create studyPlanDetails
                studentManager.generateDetailsForStudyPlanCardinalTimeUnit(sourceSpctu, targetSpctu, request, result);

            } else {
                log.warn("Progress status is non-continuing for studyPlanCardinalTimeUnit (id = " + sourceSpctu.getId()
                        + "). No subject subscriptions possible");
            }
        }

        String view;
        if (result.hasErrors()) {
            view = formView;
        } else {

            session.setAttribute("successfullyTransferredStudyPlanIds", makeNumberToBooleanMap(selectedStudyPlanIds));

            sessionStatus.setComplete();

            // after setting session complete no newForm necessary, because form object has been discarded
            view = "redirect:/college/person/transferStudents.view";
        }

        return view;
    }

    @RequestMapping(value = "/generateEndGrade/{index}")
    public String generateEndGrade(@PathVariable("index") int index, HttpServletRequest request, SessionStatus sessionStatus,
            @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm, BindingResult result, ModelMap model) {

        log.debug("generateEndGrade for index " + index);

        generateEndGrade(request, transferStudentsForm, result, index);

        return getViewString(request, sessionStatus, transferStudentsForm, result, model);
    }

    @RequestMapping(params = "generateEndGrades")
    public String processGenerateEndGradesSubmit(HttpServletRequest request, SessionStatus sessionStatus,
            @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm, BindingResult result, ModelMap model) {

        log.debug("generate all end grades");

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        for (Student student : transferStudentsForm.getAllStudents()) {
            int rowIndex = transferStudentsForm.getAllStudents().indexOf(student);
            generateEndGrade(request, transferStudentsForm, result, rowIndex);
        }

        return getViewString(request, sessionStatus, transferStudentsForm, result, model);
    }

    /**
     * In case of validation error return the view without redirect, otherwise return a redirect
     */
    private String getViewString(HttpServletRequest request, SessionStatus sessionStatus, TransferStudentsForm transferStudentsForm, BindingResult result,
            ModelMap model) {

        if (result.hasErrors()) {
            return setupForm(request, transferStudentsForm, model); // in case of error, no redirect
        }

        sessionStatus.setComplete();

        // after setting session complete no newForm necessary, because form object has been discarded
        return "redirect:/college/person/transferStudents.view";
    }

    private void generateEndGrade(HttpServletRequest request, TransferStudentsForm transferStudentsForm, BindingResult result, int rowIndex) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale locale = OpusMethods.getPreferredLocale(request);
        StudyGradeType studyGradeType = transferStudentsForm.getStudyGradeType();

        Student student = transferStudentsForm.getAllStudents().get(rowIndex);
        StudyPlanCardinalTimeUnit spctu = getStudyPlan(student);

        Map<String, Object> ctuMap = new HashMap<>();
        ctuMap.put("studyPlanId", spctu.getStudyPlanId());
        ctuMap.put("studyPlanCardinalTimeUnitId", spctu.getId());
        ctuMap.put("currentAcademicYearId", transferStudentsForm.getStudySettings().getAcademicYearId());
        ctuMap.put("active", "Y");
        CardinalTimeUnitResult cardinalTimeUnitResult = resultManager.findCardinalTimeUnitResultByParams(ctuMap);

        if (cardinalTimeUnitResult == null) {
            if (log.isDebugEnabled()) {
                log.debug("No cardinal time unit result available yet for " + student.getSurnameFull());
            }
            cardinalTimeUnitResult = new CardinalTimeUnitResult();
            cardinalTimeUnitResult.setStudyPlanId(spctu.getStudyPlanId());
            cardinalTimeUnitResult.setStudyPlanCardinalTimeUnitId(spctu.getId());
            cardinalTimeUnitResult.setActive("Y");
            cardinalTimeUnitResult.setPassed("N");
            cardinalTimeUnitResult.setCardinalTimeUnitResultDate(new Date());
        } else {
            if (log.isDebugEnabled()) {
                log.debug("Found CTU result for " + student.getSurnameFull());
            }
        }

        result.pushNestedPath("allStudents[" + rowIndex + "].studyPlans[0].studyPlanCardinalTimeUnits[0].cardinalTimeUnitResult");
        resultManager.generateCardinalTimeUnitMark(cardinalTimeUnitResult, preferredLanguage, locale, result);
        result.popNestedPath();

        if (log.isDebugEnabled()) {
            log.debug("generateCardinalTimeUnitEndGrade - cardinalTimeUnitResult.getMark() = " + cardinalTimeUnitResult.getMark());
        }

        if (cardinalTimeUnitResult.getMark() == null || cardinalTimeUnitResult.getMark().trim().isEmpty()) {
            cardinalTimeUnitResult.setPassed("N");
            if (log.isDebugEnabled()) {
                log.debug("onsubmit: endGrade 0.0. - txtError = " + cardinalTimeUnitResult.getCalculationMessage());
            }
        } else {
            String passed = resultManager.isPassedCardinalTimeUnitResult(spctu.getId(), cardinalTimeUnitResult, preferredLanguage,
                    studyGradeType.getGradeTypeCode());
            cardinalTimeUnitResult.setPassed(passed);
            if (cardinalTimeUnitResult.getEndGradeComment() == null || "".equals(cardinalTimeUnitResult.getEndGradeComment())) {
                EndGrade endGrade = resultManager.calculateEndGradeForMark(cardinalTimeUnitResult.getMark(), studyGradeType.getGradeTypeCode(),
                        preferredLanguage, studyGradeType.getContactId());
                if (endGrade != null) {
                    cardinalTimeUnitResult.setEndGradeComment(endGrade.getCode());
                }
            }
            if (log.isDebugEnabled()) {
                log.debug("onsubmit: endGrade NOT 0.0., passed = " + passed + ", comment = " + cardinalTimeUnitResult.getEndGradeComment());
            }
        }
        // update cardinalTimeUnitResult
        String writeWho = opusMethods.getWriteWho(request);
        if (cardinalTimeUnitResult.getId() == 0) {
            resultManager.addCardinalTimeUnitResult(cardinalTimeUnitResult, writeWho);
        } else {
            resultManager.updateCardinalTimeUnitResult(cardinalTimeUnitResult, writeWho);
        }
    }

    /**
     * Assign a student
     * 
     * @param studyPlan
     *            the study plan to which a new SPCTU shall be added
     * @param studyGradeTypeId
     * @param cardinalTimeUnitNumber
     * @param previousStudyPlanCardinalTimeUnit
     *            From which time unit the student has been transferred from
     */
    protected StudyPlanCardinalTimeUnit assignStudentToCTU(StudyPlan studyPlan, int studyGradeTypeId, int cardinalTimeUnitNumber, Lookup7 progressStatus,
            HttpServletRequest request, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit) {

        // set up studyPlanCTU
        StudyPlanCardinalTimeUnit studyPlanCTU = new StudyPlanCardinalTimeUnit();
        studyPlanCTU.setActive("Y");
        studyPlanCTU.setTuitionWaiver("N");
        studyPlanCTU.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
        studyPlanCTU.setStudyGradeTypeId(studyGradeTypeId);
        studyPlanCTU.setStudyPlanId(studyPlan.getId());
        studyPlanCTU.setCardinalTimeUnitStatusCode(appConfigManager.getCntdRegistrationInitialCardinalTimeUnitStatus());
        studyPlanCTU.setStudyIntensityCode(studentManager.getNextStudyIntensityCode(progressStatus));

        studentManager.addStudyPlanCardinalTimeUnit(studyPlanCTU, previousStudyPlanCardinalTimeUnit, request);
        studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnitByParams(studyPlanCTU.getStudyPlanId(), studyPlanCTU.getStudyGradeTypeId(),
                studyPlanCTU.getCardinalTimeUnitNumber());

        return studyPlanCTU;
    }

    private Map<Number, Boolean> makeNumberToBooleanMap(Collection<Integer> numbers) {
        Map<Number, Boolean> numberToBooleanMap = new HashMap<>();
        if (numbers != null && !numbers.isEmpty()) {
            for (Number nr : numbers) {
                numberToBooleanMap.put(nr, Boolean.TRUE);
            }
        }
        return numberToBooleanMap;
    }

    private Map<Integer, StudentPerformanceFilter> buildPerformaceFilter(int maxFailedSubjects) {
        Map<Integer, StudentPerformanceFilter> ctuSuccessOptions = new TreeMap<>();
        if (maxFailedSubjects == 0) {
            maxFailedSubjects = 2; // default value
        }

        // the key of ctuSuccessOptions is just any unique integer value other than 0
        for (int i = 0; i <= maxFailedSubjects; i++) {
            ctuSuccessOptions.put(i + 1, new NrOfFailedSubjectsFilter(i));
        }
        ctuSuccessOptions.put(maxFailedSubjects + 2, new MaxFailedSubjectsFilter(maxFailedSubjects));
        ctuSuccessOptions.put(maxFailedSubjects + 3, new MinFailedSubjectsFilter(maxFailedSubjects + 1));

        return ctuSuccessOptions;
    }

    /**
     * Refresh button clicked to preselect progress status
     */
    @RequestMapping(value = "/preselectProgressStatus/{index}")
    public String processPreselectProgressStatus(@PathVariable("index") int index, HttpServletRequest request,
            @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm, BindingResult result, ModelMap model) {

        log.debug("preselect progress statuses for index " + index);

        Student student = transferStudentsForm.getAllStudents().get(index);
        preselectProgressStatus(request, transferStudentsForm, student);

        // global flag "preselectStatuses" seems to work here
        request.setAttribute("preselectStatuses", "Y");

        return setupForm(request, transferStudentsForm, model);

    }

    /**
     * Submit button clicked to preselect the progress statuses for all students where progress status is yet empty.
     */
    @RequestMapping(params = "preSelectProgress")
    public String preselectAllEmptyProgressStatuses(HttpServletRequest request,
            @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm, BindingResult result, ModelMap model) {

        log.info("preselect all progress statuseses");

        for (Student student : transferStudentsForm.getAllStudents()) {
            StudyPlanCardinalTimeUnit spctu = getStudyPlan(student);
            String progressStatusCode = spctu.getProgressStatusCode();
            if (progressStatusCode == null || "".equals(progressStatusCode) || "0".equals(progressStatusCode)) {
                preselectProgressStatus(request, transferStudentsForm, student);
            }
        }

        request.setAttribute("preselectStatuses", "Y");
        return setupForm(request, transferStudentsForm, model);
    }

    /**
     * We have only one study plan in our data structure, therefore the study plan is always the first one in the list.
     * 
     * @param student
     * @return
     */
    private StudyPlanCardinalTimeUnit getStudyPlan(Student student) {
        return student.getStudyPlans().get(0).getStudyPlanCardinalTimeUnits().get(0);
    }

    private void preselectProgressStatus(HttpServletRequest request, TransferStudentsForm transferStudentsForm, Student student) {
        StudyPlanCardinalTimeUnit spctu = getStudyPlan(student);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale locale = OpusMethods.getPreferredLocale(request);

        // Map<String, Object> ctuMap = new HashMap<>();
        // ctuMap.put("studyPlanId", spctu.getStudyPlanId());
        // ctuMap.put("studyPlanCardinalTimeUnitId", spctu.getId());
        // ctuMap.put("currentAcademicYearId", transferStudentsForm.getStudySettings().getAcademicYearId());
        // ctuMap.put("active", "Y");
        // CardinalTimeUnitResult cardinalTimeUnitResult = resultManager.findCardinalTimeUnitResultByParams(ctuMap);
        //
        // if (cardinalTimeUnitResult != null) {

        spctu = resultManager.calculateProgressStatusForStudyPlanCardinalTimeUnit(spctu, preferredLanguage, locale);
        spctu.setProgressStatusPreselect(true);

        // }
    }

    // submit button clicked: let's try to update the progress statuses for all selected students
    @RequestMapping(params = "updateProgress")
    public String processUpdateProgressSubmit(HttpServletRequest request, @ModelAttribute(TRANSFER_STUDENTS_FORM) TransferStudentsForm transferStudentsForm,
            BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        log.info("updating progress statuses");

        studentManager.updateProgressStatuses(transferStudentsForm.getProgressStatusCodes(), OpusMethods.getPreferredLanguage(request),
                opusMethods.getWriteWho(request));

        // TODO make redirect instead of calling setupForm - this should be better in case of reloading
        return setupForm(request, transferStudentsForm, model);
    }

    private Map<String, TimeUnitAndAcademicYear> makeProgressStatusToTimeUnitMap(List<? extends Lookup7> allProgressStatuses,
            List<AcademicYear> allAcademicYears, Lookup8 cardinalTimeUnit, int cardinalTimeUnitNumber, int academicYearId) {
        Map<String, TimeUnitAndAcademicYear> map = new HashMap<>();

        if (log.isDebugEnabled() && allAcademicYears != null) {
            log.debug("TransferStudentsController.makeProgressStatusToTimeUnitMap: allAcademicYears.size = " + allAcademicYears.size());
        }
        for (Lookup7 progressStatus : allProgressStatuses) {
            TimeUnitAndAcademicYear unitAndYear = new TimeUnitAndAcademicYear();
            if ("Y".equalsIgnoreCase(progressStatus.getContinuing())) {
                map.put(progressStatus.getCode(), unitAndYear);
                int newCTUnr = cardinalTimeUnitNumber;
                int newAcademicYearId = academicYearId;
                if ("Y".equalsIgnoreCase(progressStatus.getIncrement())) {
                    newCTUnr = cardinalTimeUnitNumber + 1;
                    if (academicYearUtil.isIncrementAcademicYearAfterCTUnr(cardinalTimeUnit, cardinalTimeUnitNumber)) {
                        newAcademicYearId = AcademicYearUtil.getNextAcademicYearId(allAcademicYears, academicYearId);
                    }
                } else {
                    // in case the same CTUnr has to be done again, it can only be done in the next academic year
                    newAcademicYearId = AcademicYearUtil.getNextAcademicYearId(allAcademicYears, academicYearId);
                }
                unitAndYear.setCardinalTimeUnitCode(cardinalTimeUnit.getCode()); // for now just use the same CTU code
                unitAndYear.setCardinalTimeUnitNumber(newCTUnr);
                unitAndYear.setAcademicYearId(newAcademicYearId);
                if (log.isDebugEnabled()) {
                    log.debug("TransferStudentsController.makeProgressStatusToTimeUnitMap: newAcademicYearId = " + newAcademicYearId);
                }
            }
        }

        return map;
    }

}
