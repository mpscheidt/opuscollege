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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultPrivilegeFlags;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.ExaminationResultCommentMapper;
import org.uci.opus.college.persistence.ExaminationResultMapper;
import org.uci.opus.college.persistence.SubjectResultMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.service.result.ResultPrivilegeFlagsFactory;
import org.uci.opus.college.validator.result.ExaminationResultValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.ExaminationResultForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@SessionAttributes({ ExaminationResultEditController.FORM_NAME })
public class ExaminationResultEditController {

    private final String viewName = "college/exam/examinationResult";

    public static final String FORM_NAME = "examinationResultForm";

    private static Logger log = LoggerFactory.getLogger(ExaminationResultEditController.class);

    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private ResultPrivilegeFlagsFactory resultPrivilegeFlagsFactory;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private MessageSource messageSource;
    @Autowired private TestManagerInterface testManager;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private ExaminationResultMapper examinationResultMapper;
    @Autowired private ExaminationResultCommentMapper examinationResultCommentMapper;
    
    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) {

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(value="/college/examinationresult.view", method=RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {
    	TimeTrack timer = new TimeTrack("ExaminationResultEditController.setupForm");

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        ExaminationResultForm examinationResultForm = (ExaminationResultForm) model.get(FORM_NAME);
        if (examinationResultForm == null) {
            examinationResultForm = new ExaminationResultForm();
            model.put(FORM_NAME, examinationResultForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            examinationResultForm.setNavigationSettings(navigationSettings);
            
            examinationResultForm.setIdToExaminationResultCommentMap(new IdToObjectMap<>(examinationResultCommentMapper.findExaminationResultComments(new HashMap<>())));

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            int examinationResultId = ServletUtil.getIntParam(request, "examinationResultId", 0);

            int examinationId;
            int studyPlanDetailId;
            ExaminationResult examinationResult;
            if (examinationResultId != 0) {
                examinationResult = resultManager.findExaminationResult(examinationResultId);
                examinationId = examinationResult.getExaminationId();
                studyPlanDetailId = examinationResult.getStudyPlanDetailId();
            } else {
                examinationResult = new ExaminationResult();
                examinationId = ServletUtil.getIntParam(request, "examinationId", 0);
                studyPlanDetailId = ServletUtil.getIntParam(request, "studyPlanDetailId", 0);
            }
            examinationResultForm.setExaminationResult(examinationResult);

            // For filling the new examinationResult, the subjectId is needed
            Examination examination = examinationManager.findExamination(examinationId);
            int subjectId = examination.getSubjectId();
            Subject subject = subjectManager.findSubject(subjectId);
            Study study = studyManager.findStudy(subject.getPrimaryStudyId());

            examinationResultForm.setExamination(examination);
            examinationResultForm.setSubject(subject);
            examinationResultForm.setStudy(study);

            Map<String, Object> findExaminationResultsMap = new HashMap<>();
            findExaminationResultsMap.put("examinationId", examinationId);
            findExaminationResultsMap.put("studyPlanDetailId", studyPlanDetailId);
            List<ExaminationResult> examinationResults = resultManager.findExaminationResultsByParams(findExaminationResultsMap);

            if (examinationResultId == 0) {
                examinationResult.setStudyPlanDetailId(studyPlanDetailId);
                examinationResult.setActive("Y");
                examinationResult.setExaminationId(examinationId);
                examinationResult.setSubjectId(subjectId);
//                examinationResult.setSubjectResultId(subjectResultId);
                examinationResult.setExaminationResultDate(new Date());
                examinationResult.setPassed("N");

                // find out if this the first attempt, or higher
                int maxNumberOfAttempts = examination.getNumberOfAttempts();
                if (examinationResults != null && examinationResults.size() != 0) {
                    int newAttemptNr = examinationResults.get(examinationResults.size()-1).getAttemptNr() + 1;
                    if (newAttemptNr > maxNumberOfAttempts) {
                        throw new RuntimeException(messageSource.getMessage("maxnumber.attempts.reached", null, currentLoc));
                    } else {
                        examinationResult.setAttemptNr(newAttemptNr);
                    }
                } else {
                    examinationResult.setAttemptNr(1);
                }
            }

            StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
            studentManager.setResultsPublished(studyPlanCardinalTimeUnit);
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
            Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());

            examinationResultForm.setStudyPlanDetail(studyPlanDetail);
            examinationResultForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            examinationResultForm.setStudyPlan(studyPlan);
            examinationResultForm.setStudyGradeType(studyGradeType);
            examinationResultForm.setStudent(student);


            // get possible testResults that are already there:
            Map<String, Object> findTestResultsMap = new HashMap<>();
            findTestResultsMap.put("examinationId", examinationId);
            findTestResultsMap.put("studyPlanDetailId", studyPlanDetailId);
            List<TestResult> existingTestResults = resultManager.findTestResultsByParams(findTestResultsMap);
            examinationResult.setTestResults(existingTestResults);

            List<Integer> staffMemberIds = DomainUtil.getIntProperties(examination.getTeachersForExamination(), "staffMemberId");
            if (!staffMemberIds.isEmpty()) {
                Map<String, Object> staffMemberMap = new HashMap<>();
                staffMemberMap.put("staffMemberIds", staffMemberIds);
                List<StaffMember> allStaffMembers = staffMemberManager.findStaffMembers(staffMemberMap);
                examinationResultForm.setIdToExaminationTeacherMap(new IdToStaffMemberMap(allStaffMembers));
            }

            // load logged in staff member
            OpusUser opusUser = opusMethods.getOpusUser();
            if (personManager.isStaffMember(opusUser.getPersonId())) {
                StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
                examinationResultForm.setLoggedInStaffMember(staffMember);
//                examinationResult.setStaffMemberId(staffMember.getStaffMemberId());
            }

            int subjectResultId = ServletUtil.getIntParam(request, "subjectResultId", 0);
            examinationResultForm.setSubjectResultId(subjectResultId);

//            List < StudyPlan > allStudyPlans = null;
//            allStudyPlans = (ArrayList<StudyPlan>) studentManager.findStudyPlansForStudent(studentId);
//            request.setAttribute("allStudyPlans", allStudyPlans);
    
//            Organization organization = new Organization();
//            organization.setInstitutionId(institutionId);
//            organization.setBranchId(branchId);
//            organization.setOrganizationalUnitId(organizationalUnitId);
//            organization.setEducationTypeCode(educationTypeCode);

            // ACADEMIC YEARS
//    		Map<String, Object> academicYearMap = new HashMap<String, Object>();
//    		request.setAttribute("allAcademicYears", studyManager.findAllAcademicYears(academicYearMap));

//            Map<String, Object> findMap = new HashMap<String, Object>();
//            findMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, organization);

            // SUBJECTBLOCKS & SUBJECTS
//            List < SubjectBlock > allSubjectBlocks = null;
//            List < Subject > allSubjects = null;
//            findMap.put("active", "");
//            findMap.put("rigidityTypeCode", null);
//            allSubjectBlocks = (ArrayList < SubjectBlock >) 
//    				subjectManager.findSubjectBlocks(findMap); 
//            request.setAttribute("allSubjectBlocks", allSubjectBlocks);
//            allSubjects = (ArrayList < Subject >) 
//    				subjectManager.findSubjects(findMap);
//            request.setAttribute("allSubjects", allSubjects);

//            List < StaffMember > allStaffMembers = null;
//            allStaffMembers = staffMemberManager.findStaffMembers(findMap);
//            request.setAttribute("allStaffMembers", allStaffMembers);

//            List < ExaminationTeacher > allExaminationTeachers = null;
//            allExaminationTeachers = examinationManager.findTeachersForExamination(examinationId);
//            request.setAttribute("allExaminationTeachers", allExaminationTeachers);

            // BRs PASSING:
            String brsPassing;
            if (examination.getBRsPassingExamination() != null && !"".equals(examination.getBRsPassingExamination())) {
                brsPassing = examination.getBRsPassingExamination();
            } else {
                brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
            }
            examinationResultForm.setBrsPassing(brsPassing);

            // authorization
            ExaminationResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forExaminations(request);
            AuthorizationSubExTest examinationResultAuthorization = resultManager.determineAuthorizationForMultipleAttemptResult(studyPlanDetail, studyPlanCardinalTimeUnit, examinationResults, examinationResult, examination, resultPrivilegeFlags);
            examinationResultForm.setExaminationResultAuthorization(examinationResultAuthorization);

            int percentageTotal = testManager.findTotalWeighingFactor(examinationId);
            examinationResultForm.setPercentageTotal(percentageTotal);

            // ALL ACTIVE TESTS FOR EXAMINATION:
//            List < Test > allActiveTestsForExamination = null;
//            allActiveTestsForExamination = testManager.findActiveTestsForExamination(examinationId);
//            request.setAttribute("allActiveTestsForExamination",allActiveTestsForExamination);

            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level
            String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
       	    	// mozambican situation
//            	request.setAttribute("minimumGrade",study.getMinimumMarkSubject());
//            	request.setAttribute("maximumGrade",study.getMaximumMarkSubject());
            	examinationResultForm.setMinimumMarkValue(study.getMinimumMarkSubject());
            	examinationResultForm.setMaximumMarkValue(study.getMaximumMarkSubject());
            } else {
       	        // zambian situation
//                Map<String, Object> minMap = new HashMap<String, Object>();
//                minMap.put("endGradeTypeCode", studyGradeType.getGradeTypeCode());
//                minMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());

//                double minimumEndGradeForGradeType = studyManager.findMinimumEndGradeForGradeType(minMap);
//                double maximumEndGradeForGradeType = studyManager.findMaximumEndGradeForGradeType(minMap);
//            	request.setAttribute("minimumGrade",String.valueOf(minimumEndGradeForGradeType));
//            	request.setAttribute("maximumGrade",String.valueOf(maximumEndGradeForGradeType));
                examinationResultForm.setMinimumMarkValue("0");
                examinationResultForm.setMaximumMarkValue("100");
            }
            
        	if (examinationResult != null && examinationResult.getMark() != null && !examinationResult.getMark().trim().isEmpty()) {
        		examinationResult.setEndGradeTypeCode(studyGradeType.getGradeTypeCode());
                // zambian situation:
        		if (endGradesPerGradeType != null || !"".equals(endGradesPerGradeType)) {
            	
        		    EndGrade endGrade = resultManager.calculateEndGradeForMark(
    	       	    		examinationResult.getMark(), examinationResult.getEndGradeTypeCode(), preferredLanguage,
    	       	    		subject.getCurrentAcademicYearId());
        		    if (endGrade != null) {
//        		        examinationResult.setGradePoint(endGrade.getGradePoint());
                        examinationResult.setEndGrade(endGrade.getCode());
        		    }
    	        	//endGradeComment = resultManager.calculateEndGradeCommentForMark(
    	        	//		examinationResult.getMark(), examinationResult.getEndGradeTypeCode(), preferredLanguage);
    	        	//examinationResult.setEndGradeComment(endGradeComment);
        		}
            }
        	
        	timer.measure("before histories");
        	examinationResultForm.setExaminationResultHistories(examinationResultMapper.findExaminationResultHistory(examinationId, studyPlanDetailId));
        }

        timer.end();
        return viewName;
    }

    /**
     * Saves the new or updated examinationResult.
     */
    @RequestMapping(value="/college/examinationresult.view", method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) ExaminationResultForm examinationResultForm,
            BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        ExaminationResult examinationResult = examinationResultForm.getExaminationResult();
        ExaminationResultValidator examinationResultValidator = new ExaminationResultValidator(examinationResultForm.getMinimumMarkValue(),
                examinationResultForm.getMaximumMarkValue(), opusMethods.getOpusUser());

        AuthorizationSubExTest authorization = examinationResultForm.getExaminationResultAuthorization();
        examinationResultValidator.setAuthorization(authorization);

        result.pushNestedPath("examinationResult");
        examinationResultValidator.validate(examinationResult, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        String passed = resultManager.isPassedExaminationResult(examinationResult, examinationResult.getMark(), preferredLanguage);
        examinationResult.setPassed(passed);

        if (examinationResult.getId() == 0) {
            resultManager.addExaminationResult(examinationResult, request);
        } else {
            resultManager.updateExaminationResult(examinationResult, request);
        }

        sessionStatus.setComplete();

        NavigationSettings navigationSettings = examinationResultForm.getNavigationSettings();
        return "redirect:/college/examinationresult.view?newForm=true&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() 
                + "&studentId=" + examinationResultForm.getStudent().getStudentId()
                + "&examinationResultId=" + examinationResult.getId()
                + "&studyPlanDetailId=" + examinationResult.getStudyPlanDetailId()
                + "&examinationId=" + examinationResult.getExaminationId()
                + "&subjectId="+ examinationResult.getSubjectId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

//    @Transactional
    @RequestMapping(value="/college/examinationresult.view", method=RequestMethod.POST, params = "generateExaminationResult")
    public String generateExaminationResult(ExaminationResultForm examinationResultForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        ExaminationResult examinationResult = examinationResultForm.getExaminationResult();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        result.pushNestedPath("examinationResult");
        String mark = resultManager.generateExaminationResultMark(examinationResult.getStudyPlanDetailId(), examinationResult.getExaminationId(), preferredLanguage, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

        // only set mark into form object, don't store, because maybe no teacher chosen yet
        examinationResult.setMark(mark);
        log.info("Generation of examination result for examination id = " + examinationResult.getExaminationId());

        return viewName;
    }

    @RequestMapping(value="/college/examinationresult/deletetestresult.view", method=RequestMethod.GET)
    public String deleteExaminationResult(@RequestParam("testResultId") int testResultId,
            ExaminationResultForm examinationResultForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        NavigationSettings navigationSettings = examinationResultForm.getNavigationSettings();
        Examination examination = examinationResultForm.getExamination();
        ExaminationResult examinationResult = examinationResultForm.getExaminationResult();
        int studyPlanDetailId = examinationResult.getStudyPlanDetailId();

        // test result cannot be deleted if dependent examination result is present
        Map<String, Object> map = new HashMap<>();
        map.put("examinationId", examination.getId());
        map.put("studyPlanDetailId", studyPlanDetailId);
        List<ExaminationResult> examinationResults = resultManager.findExaminationResultsByParams(map);
        if (examinationResults != null && !examinationResults.isEmpty()) {
            result.reject("jsp.error.testresult.delete");
            result.reject("general.exists.examinationresult");
        }
        if (result.hasErrors()) {
            return viewName;
        }

        resultManager.deleteTestResult(testResultId, opusMethods.getWriteWho(request));

        return "redirect:/college/examinationresult.view?newForm=true"
                + "&examinationResultId=" + examinationResultForm.getExaminationResult().getId()
                + "&studyPlanDetailId=" + studyPlanDetailId
                + "&examinationId=" + examination.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();
    }

}
