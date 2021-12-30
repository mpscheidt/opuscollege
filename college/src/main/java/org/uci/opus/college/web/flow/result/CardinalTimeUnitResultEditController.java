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

import java.util.ArrayList;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Authorization;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.CardinalTimeUnitResultValidator;
import org.uci.opus.college.validator.result.SubjectResultDeleteValidator;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.CardinalTimeUnitResultForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.college.web.util.exam.ResultsReportBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.LookupCacherKey;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/cardinaltimeunitresult")
@SessionAttributes({CardinalTimeUnitResultEditController.FORM_NAME})
public class CardinalTimeUnitResultEditController {

    public static final String FORM_NAME = "cardinalTimeUnitResultForm";
    private static Logger log = LoggerFactory.getLogger(CardinalTimeUnitResultEditController.class);
    private final String formView = "college/exam/cardinalTimeUnitResult";
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private CollegeWebExtensions collegeWebExtensions;
    @Autowired private ReportController reportController;       


    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

    	CardinalTimeUnitResultForm cardinalTimeUnitResultForm = (CardinalTimeUnitResultForm) model.get(FORM_NAME);
        if (cardinalTimeUnitResultForm == null) {
            cardinalTimeUnitResultForm = new CardinalTimeUnitResultForm();
            model.addAttribute(FORM_NAME, cardinalTimeUnitResultForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            cardinalTimeUnitResultForm.setNavigationSettings(navigationSettings);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            int studyPlanCardinalTimeUnitId = ServletUtil.getIntParam(request, "studyPlanCardinalTimeUnitId", 0);
            if (studyPlanCardinalTimeUnitId == 0) {
                throw new RuntimeException("studyPlanCardinalTimeUnitId not given");
            }

            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
            Study study = studyManager.findStudy(studyGradeType.getStudyId());

            // BRs PASSING:
            cardinalTimeUnitResultForm.setBrsPassing(opusMethods.getBrsPassingSubject(null, study, currentLoc));

            CardinalTimeUnitResult cardinalTimeUnitResult = studyPlanCardinalTimeUnit.getCardinalTimeUnitResult();
            if (cardinalTimeUnitResult == null) {
                cardinalTimeUnitResult = new CardinalTimeUnitResult();
                cardinalTimeUnitResult.setStudyPlanId(studyPlan.getId());
                cardinalTimeUnitResult.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
                cardinalTimeUnitResult.setActive("Y");
                cardinalTimeUnitResult.setPassed("N");
                cardinalTimeUnitResult.setCardinalTimeUnitResultDate(new Date());
                studyPlanCardinalTimeUnit.setCardinalTimeUnitResult(cardinalTimeUnitResult);
            }

            cardinalTimeUnitResultForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            cardinalTimeUnitResultForm.setStudyPlan(studyPlan);
            cardinalTimeUnitResultForm.setStudyGradeType(studyGradeType);
            cardinalTimeUnitResultForm.setStudy(study);

            List<StudyPlanDetail> allStudyPlanDetails = (List<StudyPlanDetail>) studyPlanCardinalTimeUnit.getStudyPlanDetails();
            cardinalTimeUnitResultForm.setAllStudyPlanDetails(allStudyPlanDetails);    // TODO unnecessary
            
            Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());
            cardinalTimeUnitResultForm.setStudent(student);

            // ACADEMIC YEARS
            cardinalTimeUnitResultForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());

            // results visible to students in the studyPlanCardinalTimeUnit?
            studentManager.setResultsPublished(studyPlanCardinalTimeUnit);

            cardinalTimeUnitResultForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
            cardinalTimeUnitResultForm.setAllCardinalTimeUnits(lookupCacher.getAllCardinalTimeUnits(new LookupCacherKey(preferredLanguage, LookupCacherKey.CAPITALIZE)));
            cardinalTimeUnitResultForm.setAllCardinalTimeUnitStatuses(lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage));
            cardinalTimeUnitResultForm.setAllProgressStatuses(lookupCacher.getAllProgressStatuses(preferredLanguage));

            // Use ResultFormatters to fill up ctuResult object and subjectResult objects in the for loop
            // Use ResultFormatter to fill up ctuResult object
            CtuResultFormatter ctuResultFormatter = collegeWebExtensions.getCtuResultFormatter();
            cardinalTimeUnitResultForm.setCtuResultFormatter(ctuResultFormatter);
            // Use ResultFormatter to fill up subjectResult objects in the for loop
            SubjectResultFormatter subjectResultFormatter = collegeWebExtensions.getSubjectResultFormatter();
            cardinalTimeUnitResultForm.setSubjectResultFormatter(subjectResultFormatter);

            
            // see if the endGrades are defined on studygradetype level
            String endGradesPerGradeType = studyManager.findEndGradeType(studyGradeType.getCurrentAcademicYearId());
            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
                endGradesPerGradeType = "N";    // TODO use boolean
            } else {
                endGradesPerGradeType = "Y";
            }
            //request.setAttribute("endGradesPerGradeType", endGradesPerGradeType);
            cardinalTimeUnitResultForm.setEndGradesPerGradeType(endGradesPerGradeType);
            
            // define StudyPlanResult's endgradetype:
            Map<String, Object> studyPlanEndGradeMap = new HashMap<>();
            studyPlanEndGradeMap.put("preferredLanguage", preferredLanguage);
            if ("Y".equals(endGradesPerGradeType)) {
                studyPlanEndGradeMap.put("endGradeTypeCode", studyPlan.getGradeTypeCode());
            }
            studyPlanEndGradeMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());
            cardinalTimeUnitResultForm.setAllEndGradesStudyPlan(studyManager.findAllEndGrades(studyPlanEndGradeMap));

            // endgradecomments
            if ("Y".equals(endGradesPerGradeType)) {
                cardinalTimeUnitResultForm.setFullEndGradeCommentsForGradeType(studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap));
                cardinalTimeUnitResultForm.setFullFailGradeCommentsForGradeType(studyManager.findFullFailGradeCommentsForGradeType(studyPlanEndGradeMap));

                // extra AR grades:
                studyPlanEndGradeMap.put("endGradeTypeCode", OpusConstants.ATTACHMENT_RESULT);
                cardinalTimeUnitResultForm.setAllAREndGradesStudyPlan(studyManager.findAllEndGrades(studyPlanEndGradeMap));
                cardinalTimeUnitResultForm.setFullAREndGradeCommentsForGradeType(studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap));
                //cardinalTimeUnitResultForm.setFullARFailGradeCommentsForGradeType(studyManager.findFullFailGradeCommentsForGradeType(studyPlanEndGradeMap));

                if (log.isDebugEnabled()) {
                    log.debug("StudyPlanCTUResultsEditController: fullEndGradeCommentsForGradeType.size() = " 
                            + cardinalTimeUnitResultForm.getFullEndGradeCommentsForGradeType().size()
                            + ", fullFailGradeCommentsForGradeType.size() = " 
                            + cardinalTimeUnitResultForm.getFullFailGradeCommentsForGradeType().size()
                            + ", fullAREndGradeCommentsForGradeType.size() = " 
                            + cardinalTimeUnitResultForm.getFullAREndGradeCommentsForGradeType().size()
                    );
                }
            }
            
            // TODO check for cardinalTimeUnitResult.getMark().isEmpty() ??
            if (cardinalTimeUnitResult != null && cardinalTimeUnitResult.getMark() != null) {
                
                cardinalTimeUnitResult.setEndGradeTypeCode(studyPlan.getGradeTypeCode());

//                if (cardinalTimeUnitResultForm.getAllEndGradesStudyPlan() == null 
//                        || cardinalTimeUnitResultForm.getAllEndGradesStudyPlan().isEmpty()
//                            || "".equals(cardinalTimeUnitResultForm.getAllEndGradesStudyPlan().get(0).getEndGradeTypeCode())) {
//                    // CONTINUE : Mozambican situation
//                } else {
//                    // gradepoint is loaded in formatter.loadAdditionalInfo()
////                    BigDecimal gradePoint = resultManager.calculateGradePointForMark(
////                            cardinalTimeUnitResult.getMark(), cardinalTimeUnitResult.getEndGradeTypeCode(), preferredLanguage,
////                            studyGradeType.getCurrentAcademicYearId());
////                    cardinalTimeUnitResult.setGradePoint(gradePoint);
//                    // the following should not be necessary, since it's in the database
////                    if (cardinalTimeUnitResult.getEndGradeComment() == null || "".equals(cardinalTimeUnitResult.getEndGradeComment())) {
////                        String endGradeComment = resultManager.calculateEndGradeForMark(
////                            cardinalTimeUnitResult.getMark(), cardinalTimeUnitResult.getEndGradeTypeCode(), preferredLanguage,
////                            studyGradeType.getCurrentAcademicYearId());
////                        cardinalTimeUnitResult.setEndGradeComment(endGradeComment);
////                    }   
//                }
            }

            CardinalTimeUnitResult cardinalTimeUnitResultInDb = new CardinalTimeUnitResult(cardinalTimeUnitResult);
            cardinalTimeUnitResultForm.setCardinalTimeUnitResultInDb(cardinalTimeUnitResultInDb);

            Authorization cardinalTimeUnitResultAuthorization = resultManager.determineAuthorizationForCardinalTimeUnitResult(studyPlanCardinalTimeUnit, request);
            cardinalTimeUnitResultForm.setCardinalTimeUnitResultAuthorization(cardinalTimeUnitResultAuthorization);

            // fetch additional ctuResult related data to make it available in the ctuResult object
            ctuResultFormatter.loadAdditionalInfo(cardinalTimeUnitResultInDb, studyPlan.getGradeTypeCode(), preferredLanguage);

            // MINIMUM and MAXIMUM GRADE:
            // see if the endGrades are defined on studygradetype level:
            if ("N".equals(endGradesPerGradeType)) {
                // (mozambican situation):
                // find the minimum and maximum mark on the level of the study:
                cardinalTimeUnitResultForm.setMinimumGrade(study.getMinimumMarkSubject());
                cardinalTimeUnitResultForm.setMaximumGrade(study.getMaximumMarkSubject());
                cardinalTimeUnitResultForm.setMinimumMarkValue(study.getMinimumMarkSubject());
                cardinalTimeUnitResultForm.setMaximumMarkValue(study.getMaximumMarkSubject());

            } else {
                // (zambian situation):
                // 1. find the minimum and maximum mark on the level of the studyplan
                Map<String, Object> minMap = new HashMap<>();
                minMap.put("endGradeTypeCode", studyPlan.getGradeTypeCode());
                minMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());

                cardinalTimeUnitResultForm.setMinimumGrade(String.valueOf(studyManager.findMinimumEndGradeForGradeType(minMap)));
                cardinalTimeUnitResultForm.setMaximumGrade(String.valueOf(studyManager.findMaximumEndGradeForGradeType(minMap)));
                cardinalTimeUnitResultForm.setMinimumMarkValue("0");
                cardinalTimeUnitResultForm.setMaximumMarkValue("100");
               
            }


            // SUBJECTBLOCKS & SUBJECTS
            // List < SubjectBlock > allSubjectBlocks =
            // subjectManager.findSubjectBlocks(findMap);
            List<SubjectBlock> allSubjectBlocks = studentManager.findSubjectBlocksForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
            cardinalTimeUnitResultForm.setAllSubjectBlocks(allSubjectBlocks);

            List<Integer> subjectIdsForStudyPlanCTU = studentManager.findSubjectIdsForStudyPlanCardinalTimeUnitAndInBlocks(studyPlanCardinalTimeUnitId);
            Map<String, Object> findSubjectMap = new HashMap<>();
            findSubjectMap.put("subjectIds", subjectIdsForStudyPlanCTU);
            List<Subject> allSubjects = subjectManager.findSubjects(findSubjectMap);
            cardinalTimeUnitResultForm.setAllSubjects(allSubjects);

            // SUBJECTSUBJECTBLOCKS
            List<Integer> allSubjectBlockIds = DomainUtil.getIds(allSubjectBlocks);
            if (!allSubjectBlockIds.isEmpty()) {
                Map<String, Object> findSSBMap = new HashMap<>();
                findSSBMap.put("subjectBlockIds", allSubjectBlockIds);
                cardinalTimeUnitResultForm.setAllSubjectSubjectBlocks(subjectManager.findSubjectSubjectBlocks(findSSBMap));
            }


            // -- subject results
            Map<String, Object> resultsMap = new HashMap<>();
            resultsMap.put("studyPlanCardinalTimeUnitId", cardinalTimeUnitResultForm.getStudyPlanCardinalTimeUnit().getId());
            List < SubjectResult> subjectResults = resultManager.findActiveSubjectResultsForCardinalTimeUnit(resultsMap);  // TODO make this a property of the result map
             // fetch additional subjectResult related data to make it available in the subjectResult objects
            if (subjectResults != null && subjectResults.size() != 0) {
                for (SubjectResult subjectResult : subjectResults) {
                    Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());
                    String subjectGradeTypeCode;
                    if (OpusConstants.ATTACHMENT_RESULT.equals(subject.getResultType())) {
                        subjectGradeTypeCode = OpusConstants.ATTACHMENT_RESULT;
                    } else {
                        subjectGradeTypeCode = studyPlan.getGradeTypeCode();
                    }
                    subjectResultFormatter.loadAdditionalInfo(subjectResult, subjectGradeTypeCode, preferredLanguage);
                }
            }

            // set the privileges for the subject results
            if (allStudyPlanDetails != null && allStudyPlanDetails.size() != 0) {

                List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = new ArrayList<>();
                allStudyPlanCardinalTimeUnits.add(studyPlanCardinalTimeUnit);

                Map<String, AuthorizationSubExTest> authorizationMap = resultManager.determineAuthorizationForSubjectResults(allStudyPlanDetails, allStudyPlanCardinalTimeUnits, subjectResults, request);
                cardinalTimeUnitResultForm.setAuthorizationMap(authorizationMap);
            }

            cardinalTimeUnitResultForm.setAllSubjectResultsForStudyPlanCardinalTimeUnit(subjectResults);            

            // STUDIES
            Map<String, Object> findMap = new HashMap<>();
            List<Integer> primaryStudyIds = DomainUtil.getIntProperties(allSubjects, "primaryStudyId");
            findMap.put("studyIds", primaryStudyIds);
            cardinalTimeUnitResultForm.setAllStudies(studyManager.findStudies(findMap));   // TODO rename allStudies to primaryStudies
        }

        return formView;
    }

    /**
     * @param studyPlanResultForm
     * @param result
     * @param sessionStatus
     * @param request
     * @return
     */
//    @Transactional
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute(FORM_NAME) CardinalTimeUnitResultForm cardinalTimeUnitResultForm,
            BindingResult result, SessionStatus sessionStatus, HttpServletRequest request) { 

    	NavigationSettings navigationSettings = cardinalTimeUnitResultForm.getNavigationSettings();

        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = cardinalTimeUnitResultForm.getStudyPlanCardinalTimeUnit();
        CardinalTimeUnitResult cardinalTimeUnitResult = studyPlanCardinalTimeUnit.getCardinalTimeUnitResult();
        StudyGradeType studyGradeType = cardinalTimeUnitResultForm.getStudyGradeType();

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        result.pushNestedPath("studyPlanCardinalTimeUnit.cardinalTimeUnitResult");
        new CardinalTimeUnitResultValidator(cardinalTimeUnitResultForm.getMinimumMarkValue(), cardinalTimeUnitResultForm.getMaximumMarkValue()).validate(
                cardinalTimeUnitResult, result);
        result.popNestedPath();

        if (!OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED.equals(studyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())) {
            result.reject("jsp.error.studyplancardinaltimeunitstatus.activelyregistered");
        }

        if (result.hasErrors()) {
        	return formView;
        }

    	if (log.isDebugEnabled()) {
    		log.debug("CardinalTimeUnitResultEditController.onsubmit: studyplanctu actively registered");
    	}

        String mark = cardinalTimeUnitResult.getMark();
        String endGradeComment = cardinalTimeUnitResult.getEndGradeComment();
        if (( // !"Y".equals(generateCardinalTimeUnitResultEndGrade) &&
        		(mark == null || "0".equals(mark) || "0.0".equals(mark)
        		)) &&
    		    endGradeComment != null && !"".equals(endGradeComment)
        	) {
            	// do no calculation, only set endgradecomment with zero-mark
        	cardinalTimeUnitResult.setPassed("N");
        	if (log.isDebugEnabled()) {
        		log.debug("StudyPlanCTUResultsEditController: only set endgradecomment");
        	}
        } else {
            String passed = resultManager.isPassedCardinalTimeUnitResult(
                    cardinalTimeUnitResult.getStudyPlanCardinalTimeUnitId() //studyPlanCardinalTimeUnit.getId()
                    , cardinalTimeUnitResult, 
                        preferredLanguage, studyGradeType.getGradeTypeCode());
            cardinalTimeUnitResult.setPassed(passed);

            EndGrade endGrade = resultManager.calculateEndGradeForMark(cardinalTimeUnitResult.getMark(), studyGradeType.getGradeTypeCode(), preferredLanguage,
                    studyGradeType.getCurrentAcademicYearId());
            if (endGrade != null) {
                cardinalTimeUnitResult.setEndGradeComment(endGrade.getCode());
            }

            if (log.isDebugEnabled()) {
                log.debug("CardinalTimeUnitResultEditController.onsubmit: endGrade NOT 0.0., but : " + cardinalTimeUnitResult.getMark()
                        + " - passed = " + passed + ", comment = " + cardinalTimeUnitResult.getEndGradeComment());
            }
        }
    	if (log.isDebugEnabled()) {
    		log.debug("CardinalTimeUnitResultEditController.onsubmit: endgrade =" + mark
    			+ ", comment=" + endGradeComment);
    	}

    	// -- write to DB --
        String writeWho = opusMethods.getWriteWho(request);
        if (cardinalTimeUnitResult.getId() == 0) {
            resultManager.addCardinalTimeUnitResult(cardinalTimeUnitResult, writeWho);
        } else {
            resultManager.updateCardinalTimeUnitResult(cardinalTimeUnitResult, writeWho);
        }
        sessionStatus.setComplete();

        return "redirect:/college/cardinaltimeunitresult.view?newForm=true&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel()  
                + "&studyPlanCardinalTimeUnitId=" + studyPlanCardinalTimeUnit.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

//    @Transactional
    @RequestMapping(method=RequestMethod.POST, params="generateResultButton")
    public String generateResult(@ModelAttribute(FORM_NAME) CardinalTimeUnitResultForm cardinalTimeUnitResultForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = cardinalTimeUnitResultForm.getStudyPlanCardinalTimeUnit();
        CardinalTimeUnitResult cardinalTimeUnitResult = studyPlanCardinalTimeUnit.getCardinalTimeUnitResult();

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale currentLoc = RequestContextUtils.getLocale(request);

        // do calculation
        result.pushNestedPath("studyPlanCardinalTimeUnit.cardinalTimeUnitResult");
        resultManager.generateCardinalTimeUnitMark(cardinalTimeUnitResult, preferredLanguage, currentLoc, result);
        result.popNestedPath();

        if (log.isDebugEnabled()) {
            log.debug("StudyPlanCTUResultsEditController: generateCardinalTimeUnitEndGrade - cardinalTimeUnitResult.getMark() = " 
                    + cardinalTimeUnitResult.getMark() + ", comment = " + cardinalTimeUnitResult.getEndGradeComment());
        }

        return formView;
    }

   
//    @Transactional
    @RequestMapping(value="/delete", method=RequestMethod.GET)
    public String deleteSubjectResult(@RequestParam("subjectResultId") int subjectResultId,
            @ModelAttribute(FORM_NAME) CardinalTimeUnitResultForm cardinalTimeUnitResultForm,
            BindingResult result, SessionStatus sessionStatus, HttpServletRequest request) { 

        SubjectResult subjectResult = resultManager.findSubjectResult(subjectResultId);

        // Assert authorization
        Map<String, AuthorizationSubExTest> authorizationMap = cardinalTimeUnitResultForm.getSubjectResultAuthorizationMap();
        String writeWho = opusMethods.getWriteWho(request);
        resultManager.assertDeleteAuthorization(subjectResult, authorizationMap, writeWho);
        
        SubjectResultDeleteValidator subjectResultDeleteValidator = new SubjectResultDeleteValidator(studentManager, resultManager);
        subjectResultDeleteValidator.validate(subjectResult, result);
        if (result.hasErrors()) {
            return formView;
        }

        resultManager.deleteSubjectResult(subjectResultId, writeWho);
        sessionStatus.setComplete();

        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = cardinalTimeUnitResultForm.getStudyPlanCardinalTimeUnit();
        NavigationSettings navigationSettings = cardinalTimeUnitResultForm.getNavigationSettings();

        return "redirect:/college/cardinaltimeunitresult.view?newForm=true&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel()
                + "&studyPlanCardinalTimeUnitId=" + studyPlanCardinalTimeUnit.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }
    
    @RequestMapping(value = "/subjectHistory/{subjectId}/{studyPlanDetailId}")
    public ModelAndView subjectHistory(HttpServletRequest request, @PathVariable("subjectId") int subjectId, @PathVariable("studyPlanDetailId") int studyPlanDetailId, @ModelAttribute(FORM_NAME) CardinalTimeUnitResultForm form) {
        
        return reportController.createReport(request.getSession(false), "result/SubjectHistory",
                " AND subject.id = " + subjectId + " AND studyPlanDetailId = " + studyPlanDetailId, 
                "SubjectResults_" + subjectId, "pdf", OpusMethods.getPreferredLocale(request));
//        return resultsReportBuilder.subjectHistory(request, form.getAssessmentStructurePrivilege(), subjectId, form.getStudyPlan().getId(), format);
    }

}
