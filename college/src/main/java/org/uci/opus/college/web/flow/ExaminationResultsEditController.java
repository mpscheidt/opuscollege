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
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AuthorizationMap;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.StudyplanDetailMapper;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.result.ResultUtil;
import org.uci.opus.college.validator.result.ExaminationResultDeleteValidator;
import org.uci.opus.college.validator.result.ExaminationResultValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.result.ExaminationResultsForm;
import org.uci.opus.college.web.util.exam.ExaminationResultLine;
import org.uci.opus.college.web.util.exam.ExaminationResultLines;
import org.uci.opus.college.web.util.exam.ExaminationResultsBuilder;
import org.uci.opus.college.web.util.exam.ResultsReportBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/examinationresults")
@SessionAttributes({ExaminationResultsEditController.FORM_NAME})
public class ExaminationResultsEditController {

    private final String viewName = "college/exam/examinationResults";
    public static final String FORM_NAME = "examinationResultsForm";
    private static Logger log = LoggerFactory.getLogger(ExaminationResultsEditController.class);

    @Autowired private ApplicationContext context;    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private ResultUtil resultUtil;
    @Autowired private ResultsReportBuilder resultsReportBuilder;
    @Autowired private ExaminationResultDeleteValidator examinationResultDeleteValidator;
    @Autowired private StudyplanDetailMapper studyplanDetailMapper;

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setupForm(ModelMap model, HttpServletRequest request) {
		TimeTrack timer = new TimeTrack("ExaminationResultsEditController.setupForm");

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        ExaminationResultsForm form = (ExaminationResultsForm) model.get(FORM_NAME);
        if (form == null) {
            form = new ExaminationResultsForm();
            model.put(FORM_NAME, form);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            form.setNavigationSettings(navigationSettings);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            form.setCodeToStudyPlanStatusMap(new CodeToLookupMap(lookupCacher.getAllStudyPlanStatuses(preferredLanguage)));

            List<ExaminationResultComment> comments = resultManager.findExaminationResultComments(new HashMap<String, Object>());
            form.setExaminationResultComments(comments);

            int examinationId = ServletUtil.getIntParam(request, "examinationId", 0);
            if (examinationId == 0) {
                throw new RuntimeException("examinationId not given");
            }

           
            int studyGradeTypeId = ServletUtil.getIntParam(request, "studyGradeTypeId", 0);
            request.setAttribute("studyGradeTypeId", studyGradeTypeId); // TODO is this needed? also check in subjectResults

            
            Examination examination = examinationManager.findExamination(examinationId);
            form.setExamination(examination);

            int subjectId = examination.getSubjectId();
            Subject subject = subjectManager.findSubject(subjectId);
            form.setSubject(subject);

            // load logged in staff member
            OpusUser opusUser = opusMethods.getOpusUser();
            int staffMemberIdLoggedIn = 0;
            if (personManager.isStaffMember(opusUser.getPersonId())) {
            	StaffMember staffMemberLoggedIn = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
				form.setStaffMember(staffMemberLoggedIn);
				staffMemberIdLoggedIn = staffMemberLoggedIn.getStaffMemberId();
            }

            List<StaffMember> teachers = null;
            List<Integer> staffMemberIds = DomainUtil.getIntProperties(examination.getTeachersForExamination(), "staffMemberId");
            if (!staffMemberIds.isEmpty()) {
                Map<String, Object> staffMemberMap = new HashMap<>();
                staffMemberMap.put("staffMemberIds", staffMemberIds);
                teachers = staffMemberManager.findStaffMembers(staffMemberMap);
                timer.measure("staff members");
            }
            form.setTeachers(teachers);
            form.setIdToExaminationTeacherMap(new IdToStaffMemberMap(teachers));

            Map<String, Object> findClassgroupsMap = new HashMap<>();
			findClassgroupsMap.put("subjectId", subjectId);
			List<Classgroup> classgroups = studyManager.findClassgroups(findClassgroupsMap);
			form.setAllClassgroups(classgroups);

			Integer classgroupId = ServletUtil.getIntObject(request, "classgroupId");

			if (classgroupId == null && !classgroups.isEmpty()) {
				findClassgroupsMap.put("staffMemberId", staffMemberIdLoggedIn);
				List<Classgroup> classGroupsforStaffMember = studyManager.findClassgroups(findClassgroupsMap);

				if (!classGroupsforStaffMember.isEmpty()) {
					Classgroup cg = classGroupsforStaffMember.get(0);
					classgroupId = cg.getId();
				} else {
					classgroupId = classgroups.get(0).getId();
				}

			}

			if (classgroupId != null) {
				form.setClassgroupId(classgroupId);

			}
			timer.measure("classgroups");

            // BRs PASSING:
            Study study = studyManager.findStudy(subject.getPrimaryStudyId());

            String brsPassing;
            if (!StringUtils.isBlank(examination.getBRsPassingExamination())) {
                brsPassing = examination.getBRsPassingExamination();
            } else {
                brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
            }
            form.setBrsPassing(brsPassing);


            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level:
            String endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
                // mozambican situation
                form.setMinimumMarkValue(study.getMinimumMarkSubject());
                form.setMaximumMarkValue(study.getMaximumMarkSubject());
            } else {
                // zambian situation
                form.setMinimumMarkValue("0");
                form.setMaximumMarkValue("100");
            }


            // TESTS

            // STUDY PLAN DETAILS:
            Map<String, Object> findStudyPlanDetails = new HashMap<>();
            findStudyPlanDetails.put("subjectId", subjectId);
            findStudyPlanDetails.put("classgroupId", classgroupId);
            findStudyPlanDetails.put("cardinalTimeUnitStatusCode", OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
//            List<StudyPlanDetail> allStudyPlanDetails = studentManager.findStudyPlanDetailsByParams(findStudyPlanDetails);
            List<StudyPlanDetail> allStudyPlanDetails = studyplanDetailMapper.findStudyPlanDetailsWithEagerSubjects(findStudyPlanDetails);
            timer.measure("studyplandetails");

            // EXAMINATION RESULTS:
            List<ExaminationResult> allExaminationResults = resultManager.findExaminationResults(examinationId);
            timer.measure("examination results");

//            ExaminationResultsBuilder rb = new ExaminationResultsBuilder(opusInit.getPreferredPersonSorting());
            ExaminationResultsBuilder rb = context.getBean(ExaminationResultsBuilder.class);
            rb.setExamination(examination);
            rb.setAllStudyPlanDetails(allStudyPlanDetails);
            rb.setAllExaminationResults(allExaminationResults);
            rb.build();
            ExaminationResultLines resultLines = rb.getResultLines();
            form.setAllLines(resultLines);
            timer.measure("results builder");

            if (!allStudyPlanDetails.isEmpty()) {
                List<Integer> studyPlanCardinalTimeUnitIds = DomainUtil.getIntProperties(allStudyPlanDetails, "studyPlanCardinalTimeUnitId");
                List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnits(studyPlanCardinalTimeUnitIds);
                studentManager.setResultsPublished(allStudyPlanCardinalTimeUnits);

                AuthorizationMap<AuthorizationSubExTest> examinationResultAuthorizationMap = resultManager.determineAuthorizationForExaminationResults(examination, allStudyPlanDetails,
                        allStudyPlanCardinalTimeUnits, (List<ExaminationResult>) rb.getAllResultsOfLines(), request);
                form.setExaminationResultAuthorizationMap(examinationResultAuthorizationMap);

                // Note: in the end the form might not need the resultAuthorizationMap anymore, resultLines could be sufficient if all authorization logic inside
                // and JSPs call resultLines to get authorization info instead of constructing complicated authorizationKey within JSP
                resultLines.setResultAuthorizationMap(examinationResultAuthorizationMap);
                
                // determine rights to read - and hence create report for - every part of the assessment structure
                form.setAssessmentStructurePrivilege(resultManager.determineReadPrivilegesForAssessmentStructure(request, subject));
                
                timer.measure("authorizations");
            }

            // Lookups
            List<Lookup10> allExaminationTypes = lookupCacher.getAllExaminationTypes(preferredLanguage);
            form.setAllExaminationTypes(allExaminationTypes);

            timer.end();
        }

        return viewName;
    }

    @RequestMapping("/classgroup")
    public String classgroupChanged(@ModelAttribute(FORM_NAME) ExaminationResultsForm form) {
        return getRedirectUrl(form);
    }

    @Transactional
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) ExaminationResultsForm examinationResultsForm,
            BindingResult bindingResult)
            {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

//        if (examinationResultsForm.getAllLines() == null) {
//            return viewName;
//        }

//        Map<String, AuthorizationSubExTest> authorizationMap = examinationResultsForm.getExaminationResultAuthorizationMap();

        ExaminationResultValidator resultValidator = new ExaminationResultValidator(examinationResultsForm.getMinimumMarkValue(),
                examinationResultsForm.getMaximumMarkValue(), opusMethods.getOpusUser());

        ExaminationResultLines lines = examinationResultsForm.getAllLines();
        lines.saveAllResults(resultValidator, bindingResult, resultManager, request);

//        List<ExaminationResult> examinationResults = new ArrayList<>();
//        List<ExaminationResult> examinationResultsInDB = new ArrayList<>();
//
//        for (int i = 0; i < examinationResultsForm.getAllLines().size(); i++) {
//            ExaminationResultLine examinationResultLine = (ExaminationResultLine) examinationResultsForm.getAllLines().get(i);
//            for (int j = 0; j < examinationResultLine.getResults().size(); j++) {
//                ExaminationResult examinationResult = (ExaminationResult) examinationResultLine.getResults().get(j);
//                int examinationResultId = examinationResult.getId();
//
//                ExaminationResult examinationResultInDB = examinationResultLine.getResultsInDB().size() > j ? (ExaminationResult) examinationResultLine.getResultsInDB().get(j) : null;
//
//                AuthorizationSubExTest authorization = (AuthorizationSubExTest) resultUtil.getAuthorization(examinationResult, authorizationMap);
//                examinationResultValidator.setAuthorization(authorization);
//
//                String mark = examinationResult.getMark();
//
//                // This line can be ignored if no data was entered: ie. new result && no mark entered
//                // - ignore teacher because when only one teacher then always automatically selected
//                boolean ignore = (examinationResultId == 0 && StringUtil.isNullOrEmpty(mark, true)) || examinationResult.equals(examinationResultInDB);
//                if (ignore) {
//                    continue;       // ignore this result and go to next one
//                }
//                
//                // -- Validation --
//
//                result.pushNestedPath("allLines[" + i + "].results[" + j + "]");
//                examinationResultValidator.validate(examinationResult, result);
//                result.popNestedPath(); // end of validation of this line
//
//                // Store all rows without errors: prevent possible data loss, which could occur if only storing in case no row having any errors
//                examinationResults.add(examinationResult);
//                examinationResultsInDB.add(examinationResultInDB);
//            }
//        }

        if (bindingResult.hasErrors()) {
            return viewName;
        }

//        for (int i = 0; i < examinationResults.size(); i++) {
//            ExaminationResult examinationResult = examinationResults.get(i);
//            ExaminationResult examinationResultInDB = examinationResultsInDB.get(i);
//            resultManager.saveResultIfModified(request, examinationResult, examinationResultInDB);
//        }
        
        sessionStatus.setComplete();

        return getRedirectUrl(examinationResultsForm);

    }

    private String getRedirectUrl(ExaminationResultsForm form) {
        Examination examination = form.getExamination();
        NavigationSettings navigationSettings = form.getNavigationSettings();
        return "redirect:/college/examinationresults.view?newForm=true" 
                + (form.getClassgroupId() == null ? "" : "&classgroupId=" + form.getClassgroupId())
                + "&examinationId=" + examination.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel();
    }


    @RequestMapping(method=RequestMethod.GET, params = "generate")
    public String generateExaminationResult(@RequestParam("generate") int i,
            ExaminationResultsForm examinationResultsForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        if (log.isDebugEnabled()) {
            log.debug("generate examination result for line " + i);
        }
        
        Examination examination = examinationResultsForm.getExamination();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // Find the respective ExaminationResult to set the mark
//        ResultLine<ExaminationResult> line = examinationResultsForm.getAllLines().get(i);
//        List<? extends IResult> results = line.getResults();
//        int lastAttemptIndex = results.size() - 1;
//        ExaminationResult examinationResult = (ExaminationResult) results.get(lastAttemptIndex);
        ExaminationResultLines allLines = examinationResultsForm.getAllLines();
        int lastAttemptIndex = allLines.getLastAttemptIndex(i);
        ExaminationResult examinationResult = allLines.getResult(i, lastAttemptIndex);
        int studyPlanDetailId = examinationResult.getStudyPlanDetailId();

        result.pushNestedPath("allLines[" + i + "].results[" + lastAttemptIndex + "]");
        String mark = resultManager.generateExaminationResultMark(studyPlanDetailId, examination.getId(), preferredLanguage, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return viewName;
        }

        // only set mark into form object, don't store, because maybe no teacher chosen yet
        examinationResult.setMark(mark);

        return viewName;
    }

    /**
     * Try to generate a result for all lines that have no result yet and where lower level results exist.
     * @param examinationResultsForm
     * @param result
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(method=RequestMethod.POST, params = "generateAll")
    public String generateAllSubjectResults(ExaminationResultsForm examinationResultsForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        if (log.isDebugEnabled()) {
            log.debug("generate all examination results");
        }
        
        Examination examination = examinationResultsForm.getExamination();
        Map<String, AuthorizationSubExTest> authorizationMap = examinationResultsForm.getExaminationResultAuthorizationMap();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        for (int i = 0; i < examinationResultsForm.getAllLines().size() ; i++) {
            ExaminationResultLine examinationResultLine = (ExaminationResultLine) examinationResultsForm.getAllLines().get(i);
            List<ExaminationResult> results = (List<ExaminationResult>) examinationResultLine.getResults();
            int lastAttemptIndex = results.size() - 1;
            ExaminationResult examinationResult = results.get(lastAttemptIndex);

            // Only generate if has create privilege (same condition as in jsp)
            AuthorizationSubExTest authorization = (AuthorizationSubExTest) resultUtil.getAuthorization(examinationResult, authorizationMap);
            if (!authorization.getCreate()) {
                continue;
            }

            int studyPlanDetailId = examinationResult.getStudyPlanDetailId();
            if (examinationResult.getId() == 0 && examinationResultLine.getTestResultsFound()) {
                result.pushNestedPath("allLines[" + i + "].results[" + lastAttemptIndex + "]");
                String mark = resultManager.generateExaminationResultMark(studyPlanDetailId, examination.getId(), preferredLanguage, result);
                result.popNestedPath();

                if (!result.hasFieldErrors("allLines[" + i + "].results[" + lastAttemptIndex + "].mark")) {
                    // only set a new result if the newly generated mark is different from the latest mark
                    if (lastAttemptIndex == 0 || !results.get(lastAttemptIndex-1).getMark().equals(mark)) { // note: mark may be null
                        examinationResult.setMark(mark);
                    }
                }
            }
        }

        return viewName;
    }


    @Transactional
    @RequestMapping(value = "/delete/{lineIdx}/{attemptIdx}")
    public String deleteExaminationResult(
            @PathVariable("lineIdx") int lineIdx, @PathVariable("attemptIdx") int attemptIdx,
            ExaminationResultsForm examinationResultsForm, BindingResult bindingResult, HttpServletRequest request, SessionStatus sessionStatus, ModelMap model) {

        ExaminationResultLines allLines = examinationResultsForm.getAllLines();
        ExaminationResult examinationResult = allLines.getResult(lineIdx, attemptIdx);

        Map<String, AuthorizationSubExTest> authorizationMap = examinationResultsForm.getExaminationResultAuthorizationMap();

        bindingResult.pushNestedPath("allLines[" + lineIdx + "].results[" + attemptIdx + "]");
        examinationResultDeleteValidator.validate(examinationResult, bindingResult, authorizationMap);
        bindingResult.popNestedPath();

        if (bindingResult.hasErrors()) {
            return viewName;
        }

        String writeWho = opusMethods.getWriteWho(request);
        resultManager.deleteExaminationResult(examinationResult.getId(), writeWho);

        sessionStatus.setComplete();

        return getRedirectUrl(examinationResultsForm);
    }

    @RequestMapping(value = "/subjectResults/{format}")
    public ModelAndView pdfSubjectResults(HttpServletRequest request, @PathVariable("format") String format, @ModelAttribute(FORM_NAME) ExaminationResultsForm form) {

        return resultsReportBuilder.subjectResults(request, form.getAssessmentStructurePrivilege(), form.getSubject().getId(), form.getClassgroupId(), format);
    }

    @RequestMapping(value = "/examinationResults/{examinationId}/{format}")
    public ModelAndView examinationResults(HttpServletRequest request, @PathVariable("examinationId") int examinationId, @PathVariable("format") String format, @ModelAttribute(FORM_NAME) ExaminationResultsForm form) {
        
        return resultsReportBuilder.examinationResults(request, form.getAssessmentStructurePrivilege(), examinationId, form.getClassgroupId(), format);
    }
    
    @RequestMapping(value = "/testResults/{testId}/{format}")
    public ModelAndView testResults(HttpServletRequest request, @PathVariable("testId") int testId, @PathVariable("format") String format, @ModelAttribute(FORM_NAME) ExaminationResultsForm form) {

        return resultsReportBuilder.testResults(request, form.getAssessmentStructurePrivilege(), testId, form.getClassgroupId(), format);
    }

    @Transactional
    @RequestMapping(method = RequestMethod.POST, params = "deleteAll")
    public String deleteAll(HttpServletRequest request, SessionStatus sessionStatus, @ModelAttribute(FORM_NAME) ExaminationResultsForm form,
            BindingResult bindingResult) {

        log.info("attempting to delete all examination results");

        // looping all lines
        for (ExaminationResultLine line : form.getAllLines()) {
            
            // looping the attempts
            for (int i = 0; i < line.getResults().size(); i++) {
                ExaminationResult exResult = line.getResults().get(i);
                AuthorizationSubExTest authorization = (AuthorizationSubExTest) resultUtil.getAuthorization(exResult, form.getExaminationResultAuthorizationMap());
                if (authorization.getDelete()) {
                    resultManager.deleteExaminationResult(exResult.getId(), opusMethods.getWriteWho(request));
                }
            }
        }

        return getRedirectUrl(form);
    }

}
