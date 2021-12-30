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

package org.uci.opus.college.web.flow.result;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.TestResultMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.result.TestResultValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.TestResultForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@SessionAttributes({ TestResultEditController.FORM_NAME })
public class TestResultEditController {

    private final String viewName = "college/exam/testResult";

    public static final String FORM_NAME = "testResultForm";
    private static Logger log = LoggerFactory.getLogger(TestResultEditController.class);

    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private TestManagerInterface testManager;
    @Autowired private TestResultMapper testResultMapper;

    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(value="/college/testresult.view", method=RequestMethod.GET)
    public String setupForm(ModelMap model, HttpServletRequest request) {
    	TimeTrack timer = new TimeTrack("TestResultEditController.setupForm");

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        
        TestResultForm testResultForm = (TestResultForm) model.get(FORM_NAME);
        if (testResultForm == null) {
            testResultForm = new TestResultForm();
            model.put(FORM_NAME, testResultForm);
            
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            testResultForm.setNavigationSettings(navigationSettings);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            int studyPlanDetailId = ServletUtil.getIntParam(request, "studyPlanDetailId", 0);
            testResultForm.setStudyPlanDetailId(studyPlanDetailId);
            
            StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
            Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());
            testResultForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            testResultForm.setStudyPlan(studyPlan);
            testResultForm.setStudent(student);

            int testId = ServletUtil.getIntParam(request, "testId", 0);

            Test test = testManager.findTest(testId);
            Examination examination = examinationManager.findExamination(test.getExaminationId());
            Subject subject = subjectManager.findSubject(examination.getSubjectId());
            Study study = studyManager.findStudy(subject.getPrimaryStudyId());

//            int examinationId = ServletUtil.getIntParam(request, "examinationId", 0);
            testResultForm.setTest(test);
            testResultForm.setExamination(examination);
            testResultForm.setSubject(subject);
            
            List<Integer> staffMemberIds = DomainUtil.getIntProperties(test.getTeachersForTest(), "staffMemberId");
            if (!staffMemberIds.isEmpty()) {
                Map<String, Object> staffMemberMap = new HashMap<>();
                staffMemberMap.put("staffMemberIds", staffMemberIds);
                List<StaffMember> allStaffMembers = staffMemberManager.findStaffMembers(staffMemberMap);
                testResultForm.setIdToTestTeacherMap(new IdToStaffMemberMap(allStaffMembers));
            }

            String brsPassing = testManager.getBRsPassingTest(test);
            // BRs PASSING:
//            if (test.getBRsPassingTest() != null && !"".equals(test.getBRsPassingTest())) {
//                brsPassing = test.getBRsPassingTest();
//            } else {
            if (StringUtils.isBlank(brsPassing)) {
//                if (examination.getBRsPassingExamination() != null && !"".equals(examination.getBRsPassingExamination())) {
                    brsPassing = examination.getBRsPassingExamination();
//                } else {
            }
            if (StringUtils.isBlank(brsPassing)) {
                brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
            }
            testResultForm.setBrsPassing(brsPassing);

            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level
            String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
            boolean endGradesPerGradeTypeFlag = !StringUtil.isEmpty(endGradesPerGradeType);
            testResultForm.setMinimumMarkValue(resultManager.getMinimumMarkValue(endGradesPerGradeTypeFlag, study));
            testResultForm.setMaximumMarkValue(resultManager.getMaximumMarkValue(endGradesPerGradeTypeFlag, study));
//            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
//                // mozambican situation
////                request.setAttribute("minimumGrade", study.getMinimumMarkSubject());
////                request.setAttribute("maximumGrade", study.getMaximumMarkSubject());
//                testResultForm.setMinimumMarkValue(study.getMinimumMarkSubject());
//                testResultForm.setMaximumMarkValue(study.getMaximumMarkSubject());
//            } else {
//                // zambian situation
//                Map<String, Object> minMap = new HashMap<String, Object>();
//                minMap.put("endGradeTypeCode", studyGradeType.getGradeTypeCode());
//                minMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());
//
////                double minimumEndGradeForGradeType = studyManager.findMinimumEndGradeForGradeType(minMap);
////                double maximumEndGradeForGradeType = studyManager.findMaximumEndGradeForGradeType(minMap);
////                request.setAttribute("minimumGrade",String.valueOf(minimumEndGradeForGradeType));
////                request.setAttribute("maximumGrade",String.valueOf(maximumEndGradeForGradeType));
//                testResultForm.setMinimumMarkValue("0");
//                testResultForm.setMaximumMarkValue("100");
//            }

            int testResultId = ServletUtil.getIntParam(request, "testResultId", 0);

            TestResult testResult;
            if (testResultId != 0) {
                testResult = resultManager.findTestResult(testResultId);

                if (testResult != null && testResult.getMark() != null && !testResult.getMark().trim().isEmpty()) {
                    testResult.setEndGradeTypeCode(studyGradeType.getGradeTypeCode());

                    // zambian situation:
                    if (endGradesPerGradeTypeFlag) {

//                        BigDecimal gradePoint = resultManager.calculateGradePointForMark(
//                                testResult.getMark(), testResult.getEndGradeTypeCode(), preferredLanguage,
//                                subject.getCurrentAcademicYearId());
//                        testResult.setGradePoint(gradePoint);
                        EndGrade endGrade = resultManager.calculateEndGradeForMark(
                                testResult.getMark(), testResult.getEndGradeTypeCode(), preferredLanguage,
                                subject.getCurrentAcademicYearId());
                        if (endGrade != null) {
                            testResult.setEndGrade(endGrade.getCode());
                        }
                        //endGradeComment = resultManager.calculateEndGradeCommentForMark(
                        //      testResult.getMark(), testResult.getEndGradeTypeCode(), preferredLanguage);
                        //testResult.setEndGradeComment(endGradeComment);
                    }
                }

            } else {
                testResult = new TestResult();
                testResult.setStudyPlanDetailId(studyPlanDetailId);
                testResult.setActive("Y");
                testResult.setTestId(testId);
                testResult.setExaminationId(examination.getId());
                testResult.setTestResultDate(new Date());
                testResult.setPassed("N");
// TODO check for possibleTeacher like in examinationResult and subjectResult views
//                OpusUser opusUser = opusMethods.getOpusUser();
//                if (personManager.isStaffMember(preferredLanguage, opusUser.getPersonId())) {
//                    StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
////                    testResult.setStaffMemberId(staffMember.getStaffMemberId());
//                }
//                testResult.setWriteWho(opusMethods.getWriteWho(request));

                // find out if this the first attempt, or higher
                Map<String, Object> findTestResultsMap = new HashMap<>();
                findTestResultsMap.put("testId", testId);
                findTestResultsMap.put("examinationId", examination.getId()); // ?? does it make a difference ??
                findTestResultsMap.put("studyPlanDetailId", studyPlanDetailId);
                List<TestResult> testResults = resultManager.findTestResultsByParams(findTestResultsMap);
                int maxNumberOfAttempts = test.getNumberOfAttempts();
                if (testResults != null && !testResults.isEmpty()) {
                    int newAttemptNr = testResults.get(testResults.size()-1).getAttemptNr() + 1;
                    if (newAttemptNr > maxNumberOfAttempts) {
                        throw new RuntimeException(messageSource.getMessage("maxnumber.attempts.reached", null, currentLoc));
                    } else {
                        testResult.setAttemptNr(newAttemptNr);
                    }
                } else {
                    testResult.setAttemptNr(1);
                }
            }
            testResultForm.setTestResult(testResult);
            
            int examinationResultId = ServletUtil.getIntParam(request, "examinationResultId", 0);
            testResultForm.setExaminationResultId(examinationResultId);
            
//            request.setAttribute("showTestResultError",showTestResultError);

//            List<StudyPlan> allStudyPlans = null;
//            allStudyPlans = (ArrayList<StudyPlan>) studentManager.findStudyPlansForStudent(studentId);
//            request.setAttribute("allStudyPlans", allStudyPlans);

//            Organization organization = new Organization();
//            organization.setInstitutionId(institutionId);
//            organization.setBranchId(branchId);
//            organization.setOrganizationalUnitId(organizationalUnitId);
//            organization.setEducationTypeCode(educationTypeCode);

            // ACADEMIC YEARS
//            Map<String, Object> academicYearMap = new HashMap<String, Object>();
//            request.setAttribute("allAcademicYears", studyManager.findAllAcademicYears(academicYearMap));

//            Map<String, Object> findMap = new HashMap<String, Object>();
//            findMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, organization);

            // SUBJECTBLOCKS & SUBJECTS
//            List < SubjectBlock > allSubjectBlocks = null;
//            List < Subject > allSubjects = null;
//            findMap.put("active", "");
//            findMap.put("rigidityTypeCode", null);
//            allSubjectBlocks = (ArrayList < SubjectBlock >) 
//                    subjectManager.findSubjectBlocks(findMap); 
//            request.setAttribute("allSubjectBlocks", allSubjectBlocks);
//            allSubjects = (ArrayList < Subject >) 
//                    subjectManager.findSubjects(findMap);
//            request.setAttribute("allSubjects", allSubjects);

//            List < Examination > allExaminations = null;
//            allExaminations = (ArrayList < Examination >) 
//                    examinationManager.findExaminations(findMap);
//            request.setAttribute("allExaminations", allExaminations);

            timer.measure("before histories");
            testResultForm.setTestResultHistories(testResultMapper.findTestResultHistory(testId, studyPlanDetailId));
        }

        timer.end();
        return viewName;
    }
    
//    @Transactional
    @RequestMapping(value="/college/testresult.view", method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) TestResultForm testResultForm,
            BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        TestResult testResult = testResultForm.getTestResult();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        TestResultValidator validator = new TestResultValidator(testResultForm.getMinimumMarkValue(), testResultForm.getMaximumMarkValue(), opusMethods.getOpusUser());
        result.pushNestedPath("testResult");
        validator.validate(testResult, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

        // set passed:
        if (!testResult.getMark().isEmpty()) {
            String passed = resultManager.isPassedTestResult(testResult, testResult.getMark(), preferredLanguage);
            testResult.setPassed(passed);
        } else {
            testResult.setPassed("N");
        }

        // add testResult
        if (testResult.getId() == 0) {

/* MP: no creation of empty examination results and test results anymore
 *     TODO instead: Automatic calculation of real examination result if all test results are there
            if (testResult.getExaminationResultId() == 0) {
                int newAttemptNr = 0;
                Examination examination = null;
                int maxNumberOfAttempts = 0;
                if (examinationId != 0) {
                    examination = examinationManager.findExamination(examinationId);
                    maxNumberOfAttempts = examination.getNumberOfAttempts();
                }
                List < ExaminationResult> examinationResults = null;
                
                // find out if this the first examinationresult for this subjectresult, or higher
                HashMap findExaminationResultsMap = new HashMap();
                findExaminationResultsMap.put("subjectId", subjectId);
                //findExaminationResultsMap.put("subjectResultId", subjectResultId);
                findExaminationResultsMap.put("examinationId", examinationId);
                findExaminationResultsMap.put("studyPlanDetailId", studyPlanDetailId);
                examinationResults = resultManager.findExaminationResultsByParams(findExaminationResultsMap);
                if (examinationResults != null && examinationResults.size() != 0) {
                    for (int i = 0; i < examinationResults.size(); i++) {
                        newAttemptNr = examinationResults.get(i).getAttemptNr() + 1;
                        if (newAttemptNr > maxNumberOfAttempts) {
                            showExaminationResultError = showExaminationResultError + 
                            messageSource.getMessage("maxnumber.attempts.reached", null, currentLoc);
                        } else {
                            examinationResultAttemptNr = newAttemptNr;
                        }
                    }
                } else {
                    examinationResultAttemptNr = 1;
                }
            } else {
                examinationResultAttemptNr = 1;
            }
*/
            resultManager.addTestResult(testResult, request);
        } else {
            // update testResult
            resultManager.updateTestResult(testResult, request);
        }

        NavigationSettings navigationSettings = testResultForm.getNavigationSettings();
        return "redirect:/college/examinationresult.view?newForm=true&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel() 
                + "&studentId=" + testResultForm.getStudent().getStudentId()
                + "&testResultId=" + testResult.getId()
                + "&studyPlanDetailId=" + testResult.getStudyPlanDetailId()
                + "&examinationId="+ testResult.getExaminationId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

}
