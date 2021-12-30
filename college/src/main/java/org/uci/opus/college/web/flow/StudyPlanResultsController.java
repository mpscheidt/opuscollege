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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.StudyPlanResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyPlanResultsForm;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

/**
 * Servlet implementation class for Servlet: StudyPlanResultsController.
 * 
 */
@Controller
@RequestMapping("/college/studyplanresults.view")
@SessionAttributes({ "studyPlanResultsForm" })
public class StudyPlanResultsController {

    private static Logger log = LoggerFactory.getLogger(StudyPlanResultsController.class);
    private String formView;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    
    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private CollegeWebExtensions collegeWebExtensions;

    @Autowired
    private OpusInit opusInit;

    @Autowired
    private ResultManagerInterface resultManager;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public StudyPlanResultsController() {
        super();
        this.formView = "college/exam/studyPlanResults";
    }

    /**
     * @param model
     * @param request
     * @return formview
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

    	TimeTrack timer = new TimeTrack("StudyPlanResultsController.setUpForm");
        StudyPlanResultsForm studyPlanResultsForm = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;
        StudySettings studySettings = null;

        HttpSession session = request.getSession(false);

        int primaryStudyId = 0;
        // String searchValue = "";

        /*
         * perform session-check. If wrong, this throws an Exception towards ErrorController
         */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject("studyPlanResultsForm", session, opusMethods.isNewForm(request));

        /* set menu to exams */
        session.setAttribute("menuChoice", "exams");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);

        fb.initChosenValues();
        fb.doLookups();
        fb.loadStudies();
        fb.loadStudyGradeTypes();
        fb.loadMaxCardinalTimeUnitNumber();
        timer.measure("filter builder");

        /*
         * studentsForm - fetch or create the form object and fill it with organization and navigationSettings
         */
        if ((StudyPlanResultsForm) session.getAttribute("studyPlanResultsForm") != null) {
            studyPlanResultsForm = (StudyPlanResultsForm) session.getAttribute("studyPlanResultsForm");
        } else {
            studyPlanResultsForm = new StudyPlanResultsForm();
        }

        /* ORGANIZATION - fetch or create the object */
        if (studyPlanResultsForm.getOrganization() != null) {
            organization = studyPlanResultsForm.getOrganization();
        } else {
            organization = new Organization();

            int organizationalUnitId = (Integer) session.getAttribute("organizationalUnitId");
            int branchId = (Integer) session.getAttribute("branchId");
            int institutionId = (Integer) session.getAttribute("institutionId");
            organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
        }
        studyPlanResultsForm.setOrganization(organization);

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (studyPlanResultsForm.getNavigationSettings() != null) {
            navigationSettings = studyPlanResultsForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "studyplanresults.view");
        }
        studyPlanResultsForm.setNavigationSettings(navigationSettings);

        /* STUDY SETTINGS - fetch or create the object */
        if (studyPlanResultsForm.getStudySettings() != null) {
            studySettings = studyPlanResultsForm.getStudySettings();
        } else {
            studySettings = new StudySettings();
            studySettings = opusMethods.fillStudySettings(request, studySettings);
        }
        studyPlanResultsForm.setStudySettings(studySettings);

        /* STUDENT STATUS */
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentStatusCode"))) {
            studyPlanResultsForm.setStudentStatusCode(request.getParameter("studentStatusCode"));
        }

        /* Catch errormessages */
        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
            studyPlanResultsForm.setTxtErr(request.getParameter("showStudentError"));
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to
        // fill pulldowns
        int organizationalUnitId = organization.getOrganizationalUnitId();
		opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), organizationalUnitId);

        boolean isUserAStudent = request.isUserInRole("student");

        // Use ResultFormatters to fill up ctuResult and subjectResult objects
        // in the for loop
        // Use ResultFormatter to fill up studyPlanResult object
        StudyPlanResultFormatter studyPlanResultFormatter = collegeWebExtensions.getStudyPlanResultFormatter();
        studyPlanResultsForm.setStudyPlanResultFormatter(studyPlanResultFormatter);

        boolean limitToSameStudyGradeType = request.isUserInRole("READ_STUDENTS_SAME_STUDYGRADETYPE")
                && !request.isUserInRole("READ_STUDENTS");

        // performance: pre-fetch tree of organizationalUnitIds to avoid crawl-tree "thousands of times", ie. once per student
        List<Integer> organizationalUnitIds = null;
        if (organizationalUnitId != 0) {
            organizationalUnitIds = organizationalUnitManager.findTreeOfOrganizationalUnitIds(organizationalUnitId);
        }
        timer.measure("various preps");
        
        // LIST OF STUDIES
        // used to show the name of the primary study of each subject in the
        // overview
        Map<String, Object> findMap = new HashMap<>();

        findMap.put("institutionId", organization.getInstitutionId());
        findMap.put("branchId", organization.getBranchId());
        findMap.put("organizationalUnitIds", organizationalUnitIds);
        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        if (limitToSameStudyGradeType) {
            // OpusUser opusUser = (OpusUser) session.getAttribute("opusUser");
            OpusUser opusUser = opusMethods.getOpusUser();
            findMap.put("personId", opusUser.getPersonId());
        }

        studyPlanResultsForm.setAllStudies(studyManager.findStudies(findMap));
        studyPlanResultsForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
        timer.measure("findStudies");
        
        findMap.put("studyId", studySettings.getStudyId());
        findMap.put("preferredLanguage", preferredLanguage);

        studyPlanResultsForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findMap));

        timer.measure("findStudyGradeTypes");
        
        // determine studyGradeType according to studySettings.studyGradeTypeId
        int studyGradeTypeId = studyPlanResultsForm.getStudySettings().getStudyGradeTypeId();
        StudyGradeType studyGradeType = studyGradeTypeId == 0 ? null : studyManager.findStudyGradeType(studyGradeTypeId);

        // set studygradetype into studySettings for convenience
        studySettings.setStudyGradeType(studyGradeType);

        // LIST OF STUDIES TO SHOW IN DROP DOWN LIST
        // this cannot be the same list as allStudies, because this list needs
        // to be empty
        // if the organizational unit is not chosen
        if (organizationalUnitId != 0) {
            studyPlanResultsForm.setDropDownListStudies(studyPlanResultsForm.getAllStudies());
        } else {
            studyPlanResultsForm.setDropDownListStudies(null);
        }

        // LIST OF STUDENTS DEPENDING ON CHOSEN VALUES
        Map<String, Object> findStudentsMap = new HashMap<>();
        findStudentsMap.put("institutionId", organization.getInstitutionId());
        findStudentsMap.put("branchId", organization.getBranchId());
        findStudentsMap.put("organizationalUnitIds", organizationalUnitIds);
        findStudentsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findStudentsMap.put("studyId", studySettings.getStudyId());
        findStudentsMap.put("studyGradeTypeId", studySettings.getStudyGradeTypeId());
        findStudentsMap.put("cardinalTimeUnitNumber", studySettings.getCardinalTimeUnitNumber());
        if (studySettings.getClassgroupId() != 0) {
            findStudentsMap.put("classgroupId", studySettings.getClassgroupId());
        }
        findStudentsMap.put("studentStatusCode", studyPlanResultsForm.getStudentStatusCode());
        findStudentsMap.put("studyPlanStatusCode", studySettings.getStudyPlanStatus().getCode());
        findStudentsMap.put("searchValue", navigationSettings.getSearchValue());

        int lowestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsLowestGrade();
        int highestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsHighestGrade();

        findStudentsMap.put("defaultMaximumGradePoint", highestGradeOfSecondarySchoolSubjects);
        findStudentsMap.put("defaultMinimumGradePoint", lowestGradeOfSecondarySchoolSubjects);

        if (limitToSameStudyGradeType) {
            List<? extends StudyGradeType> allStudyGradeTypes = studyPlanResultsForm.getAllStudyGradeTypes();
            if (allStudyGradeTypes != null && !allStudyGradeTypes.isEmpty()) {
                findStudentsMap.put("studyGradeTypeIds", DomainUtil.getIds(allStudyGradeTypes));
            }
        }

        // get the total count of students that apply to the filter criteria
        int studentCount = studentManager.findStudentCount(findStudentsMap);
        studyPlanResultsForm.setStudentCount(studentCount);

        timer.measure("students count");
        
        // get the students themselves
        // int iPaging = opusMethods.getIPaging(session);
        int iPaging = opusInit.getPaging();
        findStudentsMap.put("offset", (navigationSettings.getCurrentPageNumber() - 1) * iPaging);
        findStudentsMap.put("limit", iPaging);
        List<? extends Student> allStudents = studentManager.findStudents(findStudentsMap);
        timer.measure("students");
        
        // fetch additional studyplan related data to make it available in the
        // studyplan objects
        if (allStudents != null && allStudents.size() != 0) {
            for (Student student : allStudents) {
                if (student.getStudyPlans() != null && student.getStudyPlans().size() != 0) {
                    for (int i = 0; i < student.getStudyPlans().size(); i++) {
                        StudyPlan studyPlan = student.getStudyPlans().get(i);
                        if (studyPlan.getStudyPlanResult() != null) {

                            studyPlanResultFormatter.loadAdditionalInfo(studyPlan.getStudyPlanResult(), studyPlan.getGradeTypeCode(),
                                    preferredLanguage);

                        }
                    }
                }
            }
        }
        timer.measure("students additional info");

        // set all students (enriched) in studyplanresultform:
        studyPlanResultsForm.setAllStudents(allStudents);

        /* fill lookup-tables with right values */
        lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);

        // remember if study is chosen
        if (request.getParameter("primaryStudyId") != null) {
            primaryStudyId = Integer.parseInt(request.getParameter("primaryStudyId"));
            session.setAttribute("primaryStudyId", primaryStudyId);
        } else if (session.getAttribute("primaryStudyId") != null) {
            primaryStudyId = (Integer) session.getAttribute("primaryStudyId");
        }

        model.addAttribute("isUserAStudent", isUserAStudent);
        model.addAttribute("studyPlanResultsForm", studyPlanResultsForm);

        timer.end("lookups");
        
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("studyPlanResultsForm") StudyPlanResultsForm studyPlanResultsForm, BindingResult result,
            SessionStatus status, HttpServletRequest request) {

        Organization organization = studyPlanResultsForm.getOrganization();
        HttpSession session = request.getSession(false);

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("institutionId", organization.getInstitutionId());

        return "redirect:studyplanresults.view";
    }

    @PreAuthorize("hasRole('DELETE_STUDYPLAN_RESULTS')")
    @RequestMapping(method = RequestMethod.GET, params = "delete=true")
    public String deleteStudyPlanResult(@RequestParam("studyPlanResultId") int studyPlanResultId,
            @ModelAttribute("studyPlanResultsForm") StudyPlanResultsForm studyPlanResultsForm, BindingResult result,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        resultManager.deleteStudyPlanResult(studyPlanResultId, opusMethods.getWriteWho(request));

        NavigationSettings navigationSettings = studyPlanResultsForm.getNavigationSettings();
        return "redirect:/college/studyplanresults.view?newForm=true&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

}
