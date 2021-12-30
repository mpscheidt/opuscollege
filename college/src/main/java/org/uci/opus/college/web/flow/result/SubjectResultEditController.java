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

import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
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
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.SubjectResultPrivilegeFlags;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.AcademicYearMapper;
import org.uci.opus.college.persistence.SubjectResultCommentMapper;
import org.uci.opus.college.persistence.SubjectResultMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.result.ResultPrivilegeFlagsFactory;
import org.uci.opus.college.service.result.SubjectResultGenerator;
import org.uci.opus.college.validator.SubjectResultValidator;
import org.uci.opus.college.validator.result.ExaminationResultDeleteValidator;
import org.uci.opus.college.validator.result.SubjectResultDeleteValidator;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.SubjectResultForm;
import org.uci.opus.college.web.user.OpusSecurityException;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.TimeTrack;

// TODO even without passing a subjectresultId, it should be sufficient to pass subjectId
//      and to find out an existing subject result
//      This is important because when entering an examination result in the "sub-screen"
//      and returning to this screen, then the generated subject result is not shown 
//      and one could enter a new subject result

@Controller
@RequestMapping(value="/college/subjectresult")
@SessionAttributes({ SubjectResultEditController.FORM_NAME })
public class SubjectResultEditController {

    private final String viewName = "college/exam/subjectResult";

    public static final String FORM_NAME = "subjectResultForm";

    private static Logger log = LoggerFactory.getLogger(SubjectResultEditController.class);

    @Autowired private AcademicYearMapper academicYearMapper;
    @Autowired private CollegeWebExtensions collegeWebExtensions;
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private ResultPrivilegeFlagsFactory resultPrivilegeFlagsFactory;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private SubjectResultCommentMapper subjectResultCommentMapper;
    @Autowired private ExaminationResultDeleteValidator examinationResultDeleteValidator;
    @Autowired private SubjectResultMapper subjectResultMapper; 

    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) throws IllegalAccessException, InstantiationException, InvocationTargetException, NoSuchMethodException {
    	TimeTrack timer = new TimeTrack("SubjectResultEditController.setupForm");

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        SubjectResultForm subjectResultForm = (SubjectResultForm) model.get(FORM_NAME);
        if (subjectResultForm == null) {
            subjectResultForm = new SubjectResultForm();
            model.put(FORM_NAME, subjectResultForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            subjectResultForm.setNavigationSettings(navigationSettings);
            
            subjectResultForm.setIdToSubjectResultCommentMap(new IdToObjectMap<>(subjectResultCommentMapper.findSubjectResultComments(new HashMap<>())));

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            int subjectResultId = ServletUtil.getIntParam(request, "subjectResultId", 0);

            int subjectId;
            int studyPlanDetailId;
            SubjectResult subjectResult;
            if (subjectResultId != 0) {
                subjectResult = resultManager.findSubjectResult(subjectResultId);
                subjectId = subjectResult.getSubjectId();
                studyPlanDetailId = subjectResult.getStudyPlanDetailId();
            } else {
                subjectId = ServletUtil.getIntParam(request, "subjectId", 0);
                studyPlanDetailId = ServletUtil.getIntParam(request, "studyPlanDetailId", 0);
                
                if (subjectId == 0) {
                    throw new RuntimeException("Neither subjectResultId nor subjectId given");
                }

                subjectResult = new SubjectResult();
                subjectResult.setStudyPlanDetailId(studyPlanDetailId);
                subjectResult.setActive("Y");
                subjectResult.setSubjectId(subjectId);
                subjectResult.setSubjectResultDate(new Date());
//                subjectResult.setPassed("N");
            }
            subjectResultForm.setSubjectResult(subjectResult);
            
            StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
            studentManager.setResultsPublished(studyPlanCardinalTimeUnit);
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
            Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());

            subjectResultForm.setStudyPlanDetail(studyPlanDetail);
            subjectResultForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            subjectResultForm.setStudyPlan(studyPlan);
            subjectResultForm.setStudyGradeType(studyGradeType);
            subjectResultForm.setStudent(student);

            Subject subject = subjectManager.findSubject(subjectId);
            Study study = studyManager.findStudy(subject.getPrimaryStudyId());
            AcademicYear academicYear = academicYearMapper.findAcademicYear(subject.getCurrentAcademicYearId());
            subjectResultForm.setAcademicYear(academicYear);
            timer.measure("data");

            // BRs PASSING:
            String brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
            subjectResultForm.setSubject(subject);
            subjectResultForm.setStudy(study);
            subjectResultForm.setBrsPassing(brsPassing);
            
            // authorization for subjectResult
            SubjectResultPrivilegeFlags resultPrivilegeFlags = resultPrivilegeFlagsFactory.forSubjects(request);
            AuthorizationSubExTest subjectResultAuthorization = resultManager.determineAuthorizationForSubExTestResult(studyPlanDetail, studyPlanCardinalTimeUnit, subjectResult, subject, resultPrivilegeFlags);
            subjectResultForm.setSubjectResultAuthorization(subjectResultAuthorization);
            timer.measure("subjectResultAuthorization");

            // calculate total percentage of examinations underneath subject:
            int percentageTotal = examinationManager.findTotalWeighingFactor(subjectId);
            subjectResultForm.setPercentageTotal(percentageTotal);

            // get possible examinationResults that are already there
            Map<String, Object> findExaminationResultsMap = new HashMap<>();
            findExaminationResultsMap.put("studyPlanDetailId", studyPlanDetailId);
            findExaminationResultsMap.put("subjectId", subjectId);
            List<ExaminationResult> existingExaminationResults = resultManager.findExaminationResultsByParams(findExaminationResultsMap);
            subjectResult.setExaminationResults(existingExaminationResults);
            timer.measure("existingExaminationResults");

            // remember current (DB) values during editing
            SubjectResult subjectResultInDb = (SubjectResult) BeanUtils.cloneBean(subjectResult);
            subjectResultForm.setSubjectResultInDb(subjectResultInDb);

            // privileges for examinations
            List<StudyPlanDetail> studyPlanDetails = new ArrayList<>(1);
            studyPlanDetails.add(studyPlanDetail);  // all examinationResults belong to the same studyPlanDetail
            List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = new ArrayList<>(1);
            studyPlanCardinalTimeUnits.add(studyPlanCardinalTimeUnit);
            Map<String, AuthorizationSubExTest> authorizationMap = resultManager.determineAuthorizationForExaminationResults(studyPlanDetails, studyPlanCardinalTimeUnits, existingExaminationResults, request);
            subjectResultForm.setExaminationResultAuthorizationMap(authorizationMap);
            timer.measure("examinationResultAuthorization");

            List<Integer> staffMemberIds = DomainUtil.getIntProperties(subject.getSubjectTeachers(), "staffMemberId");
            if (!staffMemberIds.isEmpty()) {
                Map<String, Object> staffMemberMap = new HashMap<>();
                staffMemberMap.put("staffMemberIds", staffMemberIds);
                List<StaffMember> allStaffMembers = staffMemberManager.findStaffMembers(staffMemberMap);
                subjectResultForm.setIdToSubjectTeacherMap(new IdToStaffMemberMap(allStaffMembers));
            }

            // load logged in staff member
            OpusUser opusUser = opusMethods.getOpusUser();
            if (personManager.isStaffMember(opusUser.getPersonId())) {
                StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
                subjectResultForm.setLoggedInStaffMember(staffMember);
            }

            // Use ResultFormatter to fill up subjectResult object
            SubjectResultFormatter subjectResultFormatter = collegeWebExtensions.getSubjectResultFormatter();
            // fetch additional subjectResult related data to make it available in the subjectResult objects
            subjectResultFormatter.loadAdditionalInfo(subjectResultInDb, studyPlan.getGradeTypeCode(), preferredLanguage);
            subjectResultForm.setSubjectResultFormatter(subjectResultFormatter);

            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level
            boolean endGradesPerGradeType = studyManager.useEndGrades(subject.getCurrentAcademicYearId());
            subjectResultForm.setEndGradesPerGradeType(endGradesPerGradeType);

            if (!endGradesPerGradeType) {
                // No end grades (Mozambican situation)
                subjectResultForm.setMinimumMarkValue(study.getMinimumMarkSubject());
                subjectResultForm.setMaximumMarkValue(study.getMaximumMarkSubject());
            } else {
                // Using end grades /Zambian situation)
                subjectResultForm.setMinimumMarkValue("0");
                subjectResultForm.setMaximumMarkValue("100");

                // find comments for SubjectResult's endgradetype:
                Map<String, Object> studyPlanEndGradeMap = new HashMap<>();
                studyPlanEndGradeMap.put("preferredLanguage", preferredLanguage);
                studyPlanEndGradeMap.put("academicYearId", subject.getCurrentAcademicYearId());

                studyPlanEndGradeMap.put("endGradeTypeCode", studyPlan.getGradeTypeCode());
                List<EndGrade> fullEndGradeCommentsForGradeType = studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap);
                List<EndGrade> fullFailGradeCommentsForGradeType = studyManager.findFullFailGradeCommentsForGradeType(studyPlanEndGradeMap);

//                request.setAttribute("fullEndGradeCommentsForGradeType", fullEndGradeCommentsForGradeType);
//                request.setAttribute("fullFailGradeCommentsForGradeType", fullFailGradeCommentsForGradeType);
                subjectResultForm.setFullEndGradeCommentsForGradeType(fullEndGradeCommentsForGradeType);
                subjectResultForm.setFullFailGradeCommentsForGradeType(fullFailGradeCommentsForGradeType);

//                String subjectGradeTypeCode;
//                if (OpusConstants.ATTACHMENT_RESULT.equals(subject.getResultType())) {
//                    subjectGradeTypeCode = OpusConstants.ATTACHMENT_RESULT;
//                } else {
//                    subjectGradeTypeCode = studyPlan.getGradeTypeCode();
//                }
                // extra AR grades:
//                studyPlanEndGradeMap.put("endGradeTypeCode", subjectGradeTypeCode);
//                List<EndGrade> fullAREndGradeCommentsForGradeType = studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap);
//                List<EndGrade> fullARFailGradeCommentsForGradeType = studyManager.findFullFailGradeCommentsForGradeType(studyPlanEndGradeMap);
//
//                subjectResultForm.setFullAREndGradeCommentsForGradeType(fullAREndGradeCommentsForGradeType);
//                subjectResultForm.setFullARFailGradeCommentsForGradeType(fullARFailGradeCommentsForGradeType);

                
            }

            timer.measure("before history");
            subjectResultForm.setSubjectResultHistories(subjectResultMapper.findSubjectResultHistory(subjectId, studyPlanDetailId));
        }

        timer.end();
        return viewName;
    }

    /**
     * Saves the new or updated subjectResult.
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) SubjectResultForm subjectResultForm,
            BindingResult result, ModelMap model) {

        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.processSubmit started...");
        }
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        SubjectResult subjectResult = subjectResultForm.getSubjectResult();

        result.pushNestedPath("subjectResult");
        SubjectResultValidator subjectResultValidator = new SubjectResultValidator(subjectResultForm.getMinimumMarkValue(), subjectResultForm.getMaximumMarkValue());
        subjectResultValidator.validate(subjectResult, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

        resultManager.saveSubjectResultIfModified(request, subjectResult, subjectResultForm.getSubjectResultInDb(), subjectResultForm.getSubject().getCurrentAcademicYearId(), subjectResultForm.getResultGenerator());

        sessionStatus.setComplete();

        NavigationSettings navigationSettings = subjectResultForm.getNavigationSettings();
        return "redirect:/college/subjectresult.view?newForm=true"
                + "&subjectResultId=" + subjectResult.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();
    }

    @RequestMapping(method=RequestMethod.POST, params = "generate")
    public String generateSubjectResult(
            SubjectResultForm subjectResultForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        SubjectResult subjectResult = subjectResultForm.getSubjectResult();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // only set mark into form object, don't store, because maybe no teacher chosen yet
        result.pushNestedPath("subjectResult");
        SubjectResultGenerator resultGenerator = resultManager.generateSubjectResultMark(subjectResult, preferredLanguage, result);
        subjectResultForm.setResultGenerator(resultGenerator);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

		// since in some cases a negative result without mark but with comment
		// is created, display these two pieces of information to the user
        if (resultGenerator.isGeneratedPassed() != null) {
        	subjectResult.setPassed(resultGenerator.isGeneratedPassed() ? "Y" : "N");
        }
        
        Integer subjectResultCommentId = resultGenerator.getAssessmentResultCommentId();
        subjectResult.setSubjectResultCommentId(subjectResultCommentId);
        
        return viewName;
    }

    @Transactional
    @RequestMapping(value="/deleteSubjectResult", method = RequestMethod.GET)
    public String deleteSubjectResult(SubjectResultForm form, BindingResult result, HttpServletRequest request) {

        SubjectResult subjectResult = form.getSubjectResult();

        // Assert authorization
        AuthorizationSubExTest subjectResultAuthorization = form.getSubjectResultAuthorization();
        String writeWho = opusMethods.getWriteWho(request);
        if (!subjectResultAuthorization.getDelete()) {
        	throw new OpusSecurityException("No authorization to delete result");
        }
        
        SubjectResultDeleteValidator subjectResultDeleteValidator = new SubjectResultDeleteValidator(studentManager, resultManager);
        subjectResultDeleteValidator.validate(subjectResult, result);
        if (result.hasErrors()) {
            return viewName;
        }

        resultManager.deleteSubjectResult(subjectResult.getId(), writeWho);

        NavigationSettings navigationSettings = form.getNavigationSettings();

        return "redirect:/college/subjectresult.view?newForm=true"
        + "&subjectId=" + subjectResult.getSubjectId()
        + "&studyPlanDetailId=" + subjectResult.getStudyPlanDetailId()
        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
        + "&tab=" + navigationSettings.getTab() 
        + "&panel=" + navigationSettings.getPanel();
    }
    
    @Transactional
    @RequestMapping(value="/delete", method=RequestMethod.GET)
    public String deleteExaminationResult(@RequestParam("examinationResultId") int examinationResultId,
            SubjectResultForm subjectResultForm, BindingResult result, HttpServletRequest request, SessionStatus sessionStatus, ModelMap model) {

        ExaminationResult examinationResult = resultManager.findExaminationResult(examinationResultId);

        // Assert authorization
        Map<String, AuthorizationSubExTest> authorizationMap = subjectResultForm.getExaminationResultAuthorizationMap();
        examinationResultDeleteValidator.validate(examinationResult, result, authorizationMap);
        if (result.hasErrors()) {
            return viewName;
        }

        String writeWho = opusMethods.getWriteWho(request);
        resultManager.deleteExaminationResult(examinationResultId, writeWho);
        
        sessionStatus.setComplete();

        NavigationSettings navigationSettings = subjectResultForm.getNavigationSettings();
        SubjectResult subjectResult = subjectResultForm.getSubjectResult();
        Subject subject = subjectResultForm.getSubject();
        StudyPlanDetail studyPlanDetail = subjectResultForm.getStudyPlanDetail();

        return "redirect:/college/subjectresult.view?newForm=true"
                + "&subjectResultId=" + (subjectResult == null ? "0" : subjectResult.getId())   // in theory not needed because no change allowed when subjectResult exists
                + "&subjectId=" + subject.getId()
                + "&studyPlanDetailId=" + studyPlanDetail.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();
    }

}
