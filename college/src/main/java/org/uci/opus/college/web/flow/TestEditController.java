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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.TestValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.subject.TestForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/test")
@SessionAttributes({ TestEditController.FORM_OBJECT })
public class TestEditController {

    public static final String FORM_OBJECT = "testForm";
    private static final String FORM_VIEW = "college/subject/test";

    private static Logger log = LoggerFactory.getLogger(TestEditController.class);

    private TestValidator validator = new TestValidator();

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private ExaminationManagerInterface examinationManager;

    @Autowired
    private TestManagerInterface testManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StudyManagerInterface studyManager;

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "staff_member_ID" is set, the
     * specified staff member is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        TestForm form = new TestForm();
        model.put(FORM_OBJECT, form);
        
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        int testId = ServletUtil.getIntParam(request, "testId", 0);
        // if (!StringUtil.isNullOrEmpty(request.getParameter("testId"))) {
        // testId = Integer.parseInt(request.getParameter("testId"));
        // }

        int examinationId = ServletUtil.getIntParam(request, "examinationId", 0);
//        if (!StringUtil.isNullOrEmpty(request.getParameter("examinationId"))) {
//            examinationId = Integer.parseInt(request.getParameter("examinationId"));
//        }

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
//        institutionId = OpusMethods.getInstitutionId(session, request);
//        session.setAttribute("institutionId", institutionId);
//
//        branchId = OpusMethods.getBranchId(session, request);
//        session.setAttribute("branchId", branchId);
//
//        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
//        session.setAttribute("organizationalUnitId", organizationalUnitId);

//        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
//        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
//        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId, organizationalUnitId);

        /* study domain attributes */
//        lookupCacher.getExaminationLookups(preferredLanguage, request);

        List<Lookup10> allExaminationTypes = lookupCacher.getAllExaminationTypes(preferredLanguage);
        form.setAllExaminationTypes(allExaminationTypes);

        // for easier and faster JSP rendering, make maps out of lookup lists
        form.setAllExaminationTypesMap(new CodeToLookupMap(allExaminationTypes));
//        LookupUtil.putCodeToDescriptionMap(request, "allExaminationTypes", "allExaminationTypesMap");

        // needed to show the names in the header (bread crumbs path)
        Examination examination = null;
        Subject subject = null;
        Study study = null;
        if (examinationId != 0) {
            examination = examinationManager.findExamination(examinationId);
            subject = subjectManager.findSubject(examination.getSubjectId());
            study = studyManager.findStudy(subject.getPrimaryStudyId());
        }
        form.setExamination(examination);
        form.setSubject(subject);
        form.setStudy(study);

        // see if the endGrades are defined on studygradetype level (zambian situation):
        String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
        if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
            endGradesPerGradeType = "N";
        } else {
            endGradesPerGradeType = "Y";
        }
        request.setAttribute("endGradesPerGradeType", endGradesPerGradeType);

        Test test;
        if (testId != 0) {
            test = testManager.findTest(testId);
        } else {
            test = new Test();
            test.setExaminationId(examinationId);
            test.setActive("Y");

            /* generate testCode */
            createAndSetTestCode(test);
        }
        form.setTest(test);

        // get testTeachers
        Collection<Integer> staffMemberIds = DomainUtil.getIntProperties(test.getTeachersForTest(), "staffMemberId");
        HashMap<String, Object> findStaffMemberMap = new HashMap<>();
        findStaffMemberMap.put("staffMemberIds", staffMemberIds);
        List<StaffMember> allTeachers = staffMemberManager.findStaffMembers(findStaffMemberMap);
        form.setAllTeachers(allTeachers);

        form.setAllClassgroups(studyManager.findClassgroupsBySubjectId(subject.getId()));

        return FORM_VIEW;
    }

    private void createAndSetTestCode(Test test) {
        String testCode = StringUtil.createUniqueCode("T", "" + test.getExaminationId());
        test.setTestCode(testCode);
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) TestForm form, BindingResult result) {

        Test test = form.getTest();

        result.pushNestedPath("test");
        validator.validate(test, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int examinationId = test.getExaminationId();

        /* if examinationCode is made empty, give default value */
        if (StringUtil.isNullOrEmpty(test.getTestCode())) {
            createAndSetTestCode(test);
        }

        /*
         * the total percentage of all underlying tests of this examination must be 0 or 100 So
         * adding or updating the test cannot succeed if it makes the total exceed the 100%
         */
        int totalPercentage = testManager.findTotalWeighingFactor(examinationId, test.getId());
        totalPercentage += test.getWeighingFactor();

        /* test if the combination already exists */
        Map<String, Object> findTestMap = new HashMap<>();
        findTestMap.put("testCode", test.getTestCode());
        findTestMap.put("testDescription", test.getTestDescription());
        findTestMap.put("examinationId", test.getExaminationId());
        findTestMap.put("examinationTypeCode", test.getExaminationTypeCode());
        if (test.getId() != 0) {
            findTestMap.put("id", test.getId());
        }
        if (testManager.findTestByParams(findTestMap) != null) {
            result.reject("jsp.error.general.alreadyexists");
            return FORM_VIEW;
//            if (test.getId() != 0) {
//                showTestError = test.getTestCode() + ". " + messageSource.getMessage("jsp.error.test.edit", null, currentLoc);
//            } else {
//                showTestError = test.getTestCode() + ". " + messageSource.getMessage("jsp.error.test.add", null, currentLoc);
//            }
//
//            showTestError += messageSource.getMessage("jsp.error.general.alreadyexists", null, currentLoc);
        }

        // test if the total percentage of tests of the examination does not exceed 100
        if (totalPercentage > 100) {
            result.reject("jsp.error.percentagetotal.exceeds.hundred");
            return FORM_VIEW;
//            if (!"".equals(showTestError)) {
//                showTestError += "<br/><br/>";
//            }
//            showTestError += messageSource.getMessage("jsp.error.percentagetotal.exceeds.hundred", null, currentLoc);
        }

        boolean newTest = true;
        if (test.getId() == 0) {
            log.info("adding " + test);
            testManager.addTest(test);
        } else {
            log.info("updating " + test);
            testManager.updateTest(test);
            newTest = false;
        }

        NavigationSettings nav = form.getNavigationSettings();
        
        String view;
        if (newTest) {
            view = "redirect:/college/test.view?tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&examinationId=" + examinationId + "&testId=" + test.getId() + "&currentPageNumber="
                    + nav.getCurrentPageNumber();
        } else {
            view = "redirect:/college/examination.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&examinationId=" + examinationId + "&from=test" + "&currentPageNumber="
                    + nav.getCurrentPageNumber();
        }
        return view;
    }

}
