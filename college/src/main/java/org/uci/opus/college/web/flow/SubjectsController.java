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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.persistence.SubjectResultMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectsForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/subjects")
@SessionAttributes({ SubjectsController.SUBJECTS_FORM })
public class SubjectsController extends OverviewController<Subject, SubjectsForm> {

    public static final String SUBJECTS_FORM = "subjectsForm";
    private String formView;

    @Autowired
    private ExaminationManagerInterface examinationManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private OpusInit opusInit;

    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private SubjectResultMapper subjectResultMapper;

    @Autowired
    private TestManagerInterface testManager;

    public SubjectsController() {
        super(SUBJECTS_FORM, "studies");
        this.formView = "college/subject/subjects";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String showSubjects(ModelMap model, HttpServletRequest request) {
		TimeTrack timer = new TimeTrack("SubjectsController");

        // HttpSession session = request.getSession(false);
        // /*
        // * perform session-check. If wrong, this throws an Exception towards
        // * ErrorController
        // */
        // securityChecker.checkSessionValid(session);
        //
        // // when entering a new form, destroy any existing objectForms on the session
        // opusMethods.removeSessionFormObject(SUBJECTS_FORM, session, model, opusMethods.isNewForm(request));
        //
        // /* set menu to subjects */
        // session.setAttribute("menuChoice", "studies");

        /* fetch or create the form object */
        // SubjectsForm subjectsForm = (SubjectsForm) model.get(SUBJECTS_FORM);
        super.initSetupForm(model, request);

        // if (subjectsForm == null) {
        // subjectsForm = new SubjectsForm();
        //
        // if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
        // int studyId = Integer.parseInt(request.getParameter("studyId"));
        // subjectsForm.setStudyId(studyId);
        // }
        //
        // subjectsForm.setOrderBy("lower(subjectDescription)");
        //
        // List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        // subjectsForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        // setCurrentAcademicYear(subjectsForm, allAcademicYears);
        //
        // NavigationSettings navigationSettings = new NavigationSettings();
        // opusMethods.fillNavigationSettings(request, navigationSettings);
        // subjectsForm.setNavigationSettings(navigationSettings);
        //
        //// model.addAttribute(SUBJECTS_FORM, subjectsForm);
        // }

        // loadEverythingThatCouldChange(request, session, subjectsForm);

        timer.end();
        return formView;
    }

    @Override
    protected SubjectsForm createForm(ModelMap model, HttpServletRequest request) {

        return new SubjectsForm();
    }
    
    @Override
    protected void initForm(SubjectsForm form, HttpServletRequest request) {

        // init navigation settings
        super.initForm(form, request);

        Organization organization = opusMethods.createAndFillOrganization(request);
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
        form.setOrganization(organization);
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            int studyId = Integer.parseInt(request.getParameter("studyId"));
            form.setStudyId(studyId);
        }

        form.setOrderBy("lower(subjectDescription)");

        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        form.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        setCurrentAcademicYear(form, allAcademicYears);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        form.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
    }

//    @Override
//    protected void loadDynamicLookupTableData(HttpServletRequest request, SubjectsForm form) {

        // ----------------------
        // load lookup table data
        // ----------------------

//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//
//        // allStudyTimes
//        lookupCacher.getSubjectLookups(preferredLanguage, request);

//    }

    @Override
    protected void loadFilterContents(HttpServletRequest request, SubjectsForm subjectsForm) {

        // ----------------------
        // load filter contents
        // ----------------------

        Organization organization = subjectsForm.getOrganization();
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
        
        // LIST OF STUDIES
        // used to show the name of the primary study of each subject in the overview
        Map<String, Object> findStudiesMap = new HashMap<>();

        findStudiesMap.put("institutionId", organization.getInstitutionId());
        findStudiesMap.put("branchId", organization.getBranchId());
        findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        List<Study> allStudies = studyManager.findStudies(findStudiesMap);
        subjectsForm.setIdToStudyMap(new IdToStudyMap(allStudies));

        // LIST OF STUDIES TO SHOW IN DROP DOWN LIST
        // this cannot be the same list as allStudies, because this list needs to be empty
        // if the organizational unit is not chosen
        if (organization.getOrganizationalUnitId() != 0) {
            subjectsForm.setDropDownListStudies(allStudies);
        } else {
            subjectsForm.setDropDownListStudies(null);
        }

        // academic years combo
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        map.put("studyId", subjectsForm.getStudyId());
        List<AcademicYear> allAcademicYears = studyManager.findAllAcademicYears(map);
        subjectsForm.setAllAcademicYears(allAcademicYears);

        // reset academicYearId if not in list of available academic years (e.g. after changing study filter selection)
        List<Integer> allAcademicYearIds = DomainUtil.getIds(allAcademicYears);
        if (!allAcademicYearIds.contains(subjectsForm.getAcademicYearId())) {
            setCurrentAcademicYearIfUnset(subjectsForm, allAcademicYears);
        }

    }

    @Override
    protected void loadOverviewList(HttpServletRequest request, SubjectsForm subjectsForm) {
		TimeTrack timer = new TimeTrack("SubjectsController.loadOverviewList");

        // HttpSession session = request.getSession(false);

        // int organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
        // int branchId = ((Integer) session.getAttribute("branchId"));
        // int institutionId = ((Integer) session.getAttribute("institutionId"));
        // Organization organization = opusMethods.fillOrganization(session, request, new Organization(), organizationalUnitId, branchId,
        // institutionId);
        // subjectsForm.setOrganization(organization);
        //
        // /* retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS
        // *
        // * the institutionTypeCode is used for studies, and therefore subjects,
        // * Studies are only registered for universities; if in
        // * the future this should change, it will be easier to alter the code
        // */
        // opusMethods.getInstitutionBranchOrganizationalUnitSelect(session,
        // request, organization.getInstitutionTypeCode(),
        // organization.getInstitutionId(), organization.getBranchId(),
        // organization.getOrganizationalUnitId());

        // ----------------------
        // load list items
        // ----------------------

        Organization organization = subjectsForm.getOrganization();

        // LIST OF SUBJECTS
        Map<String, Object> findSubjectsMap = new HashMap<>();
        findSubjectsMap.put("institutionId", organization.getInstitutionId());
        findSubjectsMap.put("branchId", organization.getBranchId());
        findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findSubjectsMap.put("studyId", subjectsForm.getStudyId());
        findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findSubjectsMap.put("searchValue", subjectsForm.getNavigationSettings().getSearchValue());
        findSubjectsMap.put("active", "");
        findSubjectsMap.put("currentAcademicYearId", subjectsForm.getAcademicYearId());
        findSubjectsMap.put("orderBy", subjectsForm.getOrderBy());

        // get the total count that apply to the filter criteria
        int subjectCount = subjectManager.findSubjectCount(findSubjectsMap);
        subjectsForm.setSubjectCount(subjectCount);

        // int iPaging = opusMethods.getIPaging(session);
        int iPaging = opusInit.getPaging();
        findSubjectsMap.put("offset", (subjectsForm.getNavigationSettings().getCurrentPageNumber() - 1) * iPaging);
        findSubjectsMap.put("limit", iPaging);

        List<Subject> allSubjects = subjectManager.findSubjects(findSubjectsMap);
        subjectsForm.setAllSubjects(allSubjects);
        timer.end();
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(SUBJECTS_FORM) SubjectsForm subjectsForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        String orderBy = ServletUtil.getStringValue(session, request, "orderBy", "lower(subjectDescription)");
        subjectsForm.setOrderBy(orderBy);

        processSubmitGeneric(subjectsForm, request);

        /* fill lookup-tables with right values */
        return formView;
    }

    @RequestMapping(method = RequestMethod.GET, params = "delete")
    @PreAuthorize("hasRole('DELETE_SUBJECTS')")
    @Transactional
    public String processDelete(@RequestParam("delete") int subjectId, @ModelAttribute(SUBJECTS_FORM) SubjectsForm form, BindingResult bindingResult,
            HttpServletRequest request, ModelMap model) {

        // int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        log.info("attempting to delete subject with id " + subjectId);

        // subject cannot be deleted if results are present
        if (subjectResultMapper.existSubjectResultsForSubject(subjectId)) {
            // show error for linked results
            bindingResult.reject("jsp.error.subject.delete");
            bindingResult.reject("jsp.error.general.delete.linked.result");
            return formView;
        }

        // subject cannot be deleted if it belongs to a studyplan
        if (subjectManager.existSubjectStudyPlanDetails(subjectId)) {

            // show error for linked results
            bindingResult.reject("jsp.error.subject.delete");
            bindingResult.reject("jsp.error.general.delete.linked.studyplandetail");
            return formView;
        }

        // subject cannot be deleted if underlying examination results are present
        List<Examination> examinationList = examinationManager.findExaminationsForSubject(subjectId);

        for (int i = 0; i < examinationList.size(); i++) {
            List<ExaminationResult> examinationResultList = null;
            examinationResultList = (ArrayList<ExaminationResult>) resultManager.findExaminationResults(examinationList.get(i).getId());
            if (examinationResultList.size() != 0) {
                // show error for linked examination results
                bindingResult.reject("jsp.error.examination.delete");
                bindingResult.reject("jsp.error.general.delete.linked.examinationresult");
                return formView;
            }

            // examination cannot be deleted if underlying test results are present
            List<Test> testList = testManager.findTestsForExamination(examinationList.get(i).getId());

            for (int j = 0; j < testList.size(); j++) {
                List<TestResult> testResultList = null;
                testResultList = (ArrayList<TestResult>) resultManager.findTestResults(testList.get(j).getId());
                if (testResultList.size() != 0) {
                    // show error for linked test results
                    bindingResult.reject("jsp.error.test.delete");
                    bindingResult.reject("jsp.error.general.delete.linked.testresult");
                    return formView;
                }
            }
        }

        // delete all underlying examinations and tests
        for (Examination examination : examinationList) {

            for (Test test : examination.getTests()) {
                log.info("deleting test " + test);
                testManager.deleteTest(test.getId());
            }

            log.info("deleting examination " + examination);
            examinationManager.deleteExamination(examination.getId());
        }

        log.info("deleting subject " + subjectId);
        subjectManager.deleteSubject(subjectId, request);

        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/subjects.view?newForm=true&currentPageNumber=" + nav.getCurrentPageNumber();
    }

}
