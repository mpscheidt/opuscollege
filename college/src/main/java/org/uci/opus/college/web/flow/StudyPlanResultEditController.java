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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
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
import org.uci.opus.college.domain.AcademicYear;
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
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.college.validator.StudyPlanResultValidator;
import org.uci.opus.college.validator.result.SubjectResultDeleteValidator;
import org.uci.opus.college.web.extpoint.CollegeWebExtensions;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.extpoint.StudyPlanResultFormatter;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.extpoint.ThesisResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.StudyPlanResultForm;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.LookupCacherKey;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/studyplanresult")
@SessionAttributes({ StudyPlanResultEditController.FORM_NAME })
public class StudyPlanResultEditController {

    public static final String FORM_NAME = "studyPlanResultForm";
    private static Logger log = LoggerFactory.getLogger(StudyPlanResultEditController.class);
    private final String formView = "college/exam/studyPlanResult";

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private CollegeWebExtensions collegeWebExtensions;
    @Autowired private ReportController reportController;

    @PreAuthorize("hasRole('READ_STUDYPLAN_RESULTS') or principal.personId == @studentManager.findPersonId(#request.getParameter('studentId'))")
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws IllegalAccessException, InstantiationException, InvocationTargetException, NoSuchMethodException {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        /* STUDYPLANRESULTFORM - fetch or create the form object and fill it */
        StudyPlanResultForm studyPlanResultForm = (StudyPlanResultForm) model.get(FORM_NAME);
        if (studyPlanResultForm == null) {
            studyPlanResultForm = new StudyPlanResultForm();
            model.put(FORM_NAME, studyPlanResultForm);
            
            /* STUDYPLANRESULTFORM.NAVIGATIONSETTINGS - fetch or create the object */
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            studyPlanResultForm.setNavigationSettings(navigationSettings);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            Locale currentLoc = RequestContextUtils.getLocale(request);

            // ACADEMIC YEARS
            studyPlanResultForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());

            studyPlanResultForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
            studyPlanResultForm.setAllStudyPlanStatuses(lookupCacher.getAllStudyPlanStatuses(preferredLanguage));
            studyPlanResultForm.setAllStudyPlanStatuses(lookupCacher.getAllStudyPlanStatuses(preferredLanguage));
            studyPlanResultForm.setAllCardinalTimeUnitStatuses(lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage));
            studyPlanResultForm.setAllProgressStatuses(lookupCacher.getAllProgressStatuses(preferredLanguage));
            studyPlanResultForm.setAllCardinalTimeUnits(lookupCacher.getAllCardinalTimeUnits(new LookupCacherKey(preferredLanguage, LookupCacherKey.CAPITALIZE)));
            studyPlanResultForm.setAllImportanceTypes(lookupCacher.getAllImportanceTypes(preferredLanguage));
            studyPlanResultForm.setAllRigidityTypes(lookupCacher.getAllRigidityTypes(preferredLanguage));

            boolean isUserAStudent = request.isUserInRole("student");
            studyPlanResultForm.setUserIsStudent(isUserAStudent);

            // -- Result formatters --
            // Use ResultFormatters to fill up ctuResult and subjectResult objects in the for loop
            StudyPlanResultFormatter studyPlanResultFormatter = collegeWebExtensions.getStudyPlanResultFormatter();
            studyPlanResultForm.setStudyPlanResultFormatter(studyPlanResultFormatter);
            
            ThesisResultFormatter thesisResultFormatter = collegeWebExtensions.getThesisResultFormatter();
            studyPlanResultForm.setThesisResultFormatter(thesisResultFormatter);

            CtuResultFormatter ctuResultFormatter = collegeWebExtensions.getCtuResultFormatter();
            studyPlanResultForm.setCtuResultFormatter(ctuResultFormatter);

            SubjectResultFormatter subjectResultFormatter = collegeWebExtensions.getSubjectResultFormatter();
            studyPlanResultForm.setSubjectResultFormatter(subjectResultFormatter);


            // -- If studyplanId given, use that, otherwise load all studyPlans for student and take first one --
            StudyPlan studyPlan = null;
            int studentId;
            int studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
            if (studyPlanId == 0) {
                studentId = ServletUtil.getIntParam(request, "studentId", 0);
                if (studentId == 0) {
                    throw new RuntimeException("Neither studyPlanId nor studentId given");
                }
            } else {
                studyPlan = studentManager.findStudyPlan(studyPlanId);
                studentId = studyPlan.getStudentId();
            }

            Student student = studentManager.findStudent(preferredLanguage, studentId);
            studyPlanResultForm.setStudent(student);

            // all study plans of the student are available by clicking on the different panels
            Map<String, Object> activeStudyPlansMap = new HashMap<>();
            activeStudyPlansMap.put("studentId", studentId);
            activeStudyPlansMap.put("active", "Y");
            List<StudyPlan> allStudyPlans = studentManager.findStudyPlansForStudentByParams(activeStudyPlansMap);
            studyPlanResultForm.setAllStudyPlansForStudent(allStudyPlans);
            
            if (!allStudyPlans.isEmpty()) {

                if (studyPlanId == 0) {
                    studyPlan = allStudyPlans.get(0);
                    studyPlanId = studyPlan.getId();
                }
                studyPlanResultForm.setStudyPlan(studyPlan);
                
                // evaluate student's payments
                StudentBalanceEvaluation studentBalanceEvaluation = collegeServiceExtensions.getStudentBalanceEvaluation();
                StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluation.getStudentBalanceInformation(studentId);
                student.setHasMadeSufficientPayments(studentBalanceEvaluation.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation));
    
                // studyplandetails for chosen studyplan
                Map<String, Object> activeStudyPlanDetailsMap = new HashMap<>();
                activeStudyPlanDetailsMap.put("studentId", studentId);
                activeStudyPlanDetailsMap.put("active", "Y");
                activeStudyPlanDetailsMap.put("studyPlanId", studyPlanId);
                List<StudyPlanDetail> allStudyPlanDetails = studentManager.findStudyPlanDetailsForStudent(activeStudyPlanDetailsMap);
                studyPlanResultForm.setAllStudyPlanDetails(allStudyPlanDetails);
    
                // thesis for chosen studyplan
                Map<String, Object> findCTUMap = new HashMap<>();
                findCTUMap.put("studyPlanId", studyPlanId);
                List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(findCTUMap);
                studentManager.setResultsPublished(allStudyPlanCardinalTimeUnits);
                studyPlanResultForm.setAllStudyPlanCardinalTimeUnits(allStudyPlanCardinalTimeUnits);
    
                Map<Integer, Authorization> cardinalTimeUnitResultAuthorizationMap = resultManager.determineAuthorizationForCardinalTimeUnitResults(allStudyPlanCardinalTimeUnits, request);
                studyPlanResultForm.setCardinalTimeUnitResultAuthorizationMap(cardinalTimeUnitResultAuthorizationMap);
    
                // find organization id's matching with the study
                Study study = studyManager.findStudy(studyPlan.getStudyId());
                studyPlanResultForm.setStudy(study);
                studyPlanResultForm.setBrsPassing(opusMethods.getBrsPassingSubject(null, study, currentLoc));
    
                // -- Find or create studyPlanResult --
                StudyPlanResult studyPlanResult = studyPlan.getStudyPlanResult(); //resultManager.findStudyPlanResultByStudyPlanId(studyPlanId);
                String studyPlanGradeTypeCode = studyPlan.getGradeTypeCode();
                if (studyPlanResult == null) {
                    studyPlanResult = new StudyPlanResult();
                    studyPlanResult.setStudyPlanId(studyPlanId);
                    studyPlanResult.setActive("Y");
                    studyPlanResult.setPassed("N");
                    studyPlanResult.setExamDate(new Date());
                    studyPlanResult.setEndGradeTypeCode(studyPlanGradeTypeCode);
                    studyPlanResult.setSubjectResults(resultManager.findSubjectResultsForStudyPlan(studyPlan.getId()));
                    studyPlan.setStudyPlanResult(studyPlanResult);
                } else {
                    studyPlanResult.setEndGradeTypeCode(studyPlanGradeTypeCode);

                    // additional studyPlanResult info has to be loaded before cloning (see next step)
                    studyPlanResultFormatter.loadAdditionalInfo(studyPlanResult, studyPlanGradeTypeCode, preferredLanguage);

                    // Make a copy of the studyPlanResult that will represent the persistent status even after user changes the value
                    StudyPlanResult studyPlanResultInDb = (StudyPlanResult) BeanUtils.cloneBean(studyPlanResult);
                    studyPlanResultForm.setStudyPlanResultInDb(studyPlanResultInDb);
                }
    
                // Use endGrades?
                Map<String, Object> map = new HashMap<>();
                map.put("studyPlanId", studyPlan.getId());
                AcademicYear lastAcademicYear = academicYearManager.findLastAcademicYear(map);
    
                // If study plan has no time units yet, we have no academic year (and also no results at all)
                if (lastAcademicYear != null) {
                    studyPlanResultForm.setAcadmicYearIdOfLastCTU(lastAcademicYear.getId());
                }
    
                // see if the endGrades are defined on studygradetype level
                String endGradesPerGradeType = null;
                if (lastAcademicYear != null) {
                    // The following returns null if no end grades defined
                    endGradesPerGradeType = studyManager.findEndGradeType(lastAcademicYear.getId());
                }
                if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
                    endGradesPerGradeType = "N";
                } else {
                    endGradesPerGradeType = "Y";
                }
                studyPlanResultForm.setEndGradesPerGradeType(endGradesPerGradeType);
    
                // define StudyPlanResult's endgradetype:
                if (lastAcademicYear != null) {
                    Map<String, Object> studyPlanEndGradeMap = new HashMap<>();
                    studyPlanEndGradeMap.put("preferredLanguage", preferredLanguage);
                    if ("Y".equals(endGradesPerGradeType)) {
                        studyPlanEndGradeMap.put("endGradeTypeCode", studyPlanGradeTypeCode);
                    }
                    studyPlanEndGradeMap.put("academicYearId", lastAcademicYear.getId());
                    studyPlanResultForm.setAllEndGradesStudyPlan(studyManager.findAllEndGrades(studyPlanEndGradeMap));
    
                    // end grade comments
                    if ("Y".equals(endGradesPerGradeType)) {
                        studyPlanResultForm.setFullEndGradeCommentsForGradeType(
                            studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap));
                        studyPlanResultForm.setFullFailGradeCommentsForGradeType(
                                studyManager.findFullFailGradeCommentsForGradeType(studyPlanEndGradeMap));
                        // extra AR grades:
                        studyPlanEndGradeMap.put("endGradeTypeCode", OpusConstants.ATTACHMENT_RESULT);
                        studyPlanResultForm.setFullAREndGradeCommentsForGradeType(
                                studyManager.findFullEndGradeCommentsForGradeType(studyPlanEndGradeMap));
        
                        if (log.isDebugEnabled()) {
                            log.debug("StudyPlanResultEditController: fullEndGradeCommentsForGradeType.size() = " 
                                    + studyPlanResultForm.getFullEndGradeCommentsForGradeType().size()
                                    + ", fullFailGradeCommentsForGradeType.size() = " 
                                    + studyPlanResultForm.getFullFailGradeCommentsForGradeType().size()
                                    + ", fullAREndGradeCommentsForGradeType.size() = " 
                                    + studyPlanResultForm.getFullAREndGradeCommentsForGradeType().size()
                            );
                        }
                    }
        
                    // check endgrades for calculation values
                    if (studyPlanResultForm.getAllEndGradesStudyPlan() == null 
                        || studyPlanResultForm.getAllEndGradesStudyPlan().isEmpty()
                        || studyPlanResultForm.getAllEndGradesStudyPlan().get(0) == null
                            || "".equals(studyPlanResultForm.getAllEndGradesStudyPlan().get(0).getEndGradeTypeCode())) {
                        // no studygradetype defined (mozambican situation):
                        // find the minimum and maximum mark on the level of the study:
                        studyPlanResultForm.setMinimumGradeStudyPlan(study.getMinimumMarkSubject());
                        studyPlanResultForm.setMaximumGradeStudyPlan(study.getMaximumMarkSubject());
                        studyPlanResultForm.setMinimumGradeThesis(study.getMinimumMarkSubject());
                        studyPlanResultForm.setMaximumGradeThesis(study.getMaximumMarkSubject());
                        // values for grades:
                        studyPlanResultForm.setMinimumMarkValueStudyPlan(study.getMinimumMarkSubject());
                        studyPlanResultForm.setMaximumMarkValueStudyPlan(study.getMaximumMarkSubject());
                        studyPlanResultForm.setMinimumMarkValueThesis(study.getMinimumMarkSubject());
                        studyPlanResultForm.setMaximumMarkValueThesis(study.getMaximumMarkSubject());
        
                    } else {
                        // studygradetype defined (zambian situation):
                        // find the minimum and maximum mark on the level of the studyplan
                        Map<String, Object> minMap = new HashMap<>();
                        minMap.put("endGradeTypeCode", studyPlanGradeTypeCode);
                        minMap.put("academicYearId", lastAcademicYear.getId());
        
                        studyPlanResultForm.setMinimumGradeStudyPlan(String.valueOf(
                                studyManager.findMinimumEndGradeForGradeType(minMap)));
                        studyPlanResultForm.setMaximumGradeStudyPlan(String.valueOf(
                                studyManager.findMaximumEndGradeForGradeType(minMap)));
        
                        // find the minimum and maximum mark on the level of the thesis
                        studyPlanResultForm.setMinimumGradeThesis(String.valueOf(
                                studyManager.findMinimumEndGradeForGradeType(minMap)));
                        studyPlanResultForm.setMaximumGradeThesis(String.valueOf(
                                studyManager.findMaximumEndGradeForGradeType(minMap)));
                        // values for grades:
                        studyPlanResultForm.setMinimumMarkValueStudyPlan("0");
                        studyPlanResultForm.setMaximumMarkValueStudyPlan("100");
                        studyPlanResultForm.setMinimumMarkValueThesis("0");
                        studyPlanResultForm.setMaximumMarkValueThesis("100");
                    }
        
                    // cardinal time units for chosen studyplan
                    Map<String, Object> activeCardinalTimeUnitsMap = new HashMap<>();
                    activeCardinalTimeUnitsMap.put("studentId", student.getStudentId());
                    activeCardinalTimeUnitsMap.put("active", "Y");
                    activeCardinalTimeUnitsMap.put("studyPlanId", studyPlan.getId());
                    List<CardinalTimeUnitResult> allBareCardinalTimeUnitResults = resultManager.findCardinalTimeUnitResultsForStudent(activeCardinalTimeUnitsMap);
        
                    List<CardinalTimeUnitResult> allCardinalTimeUnitResults = new ArrayList<>();
                    if (allBareCardinalTimeUnitResults != null && !allBareCardinalTimeUnitResults.isEmpty()) {
        
                        // see if the endGrades are defined on studygradetype level
                        if ("N".equals(endGradesPerGradeType)) {
                            // mozambican situation
                            allCardinalTimeUnitResults = allBareCardinalTimeUnitResults;
        
                        } else {
                            // zambian situation
                            CardinalTimeUnitResult ctuResult = new CardinalTimeUnitResult();
                            
                            allCardinalTimeUnitResults = new ArrayList<>();
                            for (int i = 0; i < allBareCardinalTimeUnitResults.size(); i++) {
                                ctuResult = allBareCardinalTimeUnitResults.get(i);
                                
                                if (ctuResult != null && ctuResult.getMark() != null && !ctuResult.getMark().isEmpty()) {
                                    ctuResult.setEndGradeTypeCode(studyPlanGradeTypeCode);
                                    // set ctuResult in new arraylist:
                                    allCardinalTimeUnitResults.add(ctuResult);
                                }
                            }
                        }
                    }
                    studyPlanResultForm.setAllCardinalTimeUnitResults(allCardinalTimeUnitResults);
        
                    // Thesis result
                    ThesisResult thesisResult = studyPlanResult.getThesisResult();
                    // define thesisResult's endgradetype:
                    if (thesisResult != null) {
                        thesisResult.setEndGradeTypeCode(studyPlanGradeTypeCode);
                        studyPlanResult.setThesisResult(thesisResult);
        
                        Map<String, Object> thesisEndGradeMap = new HashMap<>();
                        thesisEndGradeMap.put("preferredLanguage", preferredLanguage);
                        if ("Y".equals(endGradesPerGradeType)) {
                            thesisEndGradeMap.put("endGradeTypeCode", thesisResult.getEndGradeTypeCode());
                        }
                        thesisEndGradeMap.put("academicYearId", lastAcademicYear.getId());
                        studyPlanResultForm.setAllEndGradesThesis(studyManager.findAllEndGrades(thesisEndGradeMap));
                    } else {
                        studyPlanResultForm.setAllEndGradesThesis(new ArrayList<EndGrade>());
                    }
        

                    // load additional info for the other types of result (additional info for studyPlanTesult already loaded before cloning it)

                    // fetch additional ctuResult related data to make it available in the ctuResult objects
                    if (allCardinalTimeUnitResults != null && allCardinalTimeUnitResults.size() != 0) {
                        for (CardinalTimeUnitResult ctuResult : allCardinalTimeUnitResults) {
                            ctuResultFormatter.loadAdditionalInfo(ctuResult, studyPlanGradeTypeCode, preferredLanguage);
                        }
                    }

                    // Load subjectResults: don't use lazy load of studyPlanResult, which may be new and then won't load automatically
                    List<SubjectResult> allSubjectResults = studyPlanResult.getSubjectResults();

                    // fetch additional subjectResult related data to make it available in the subjectResult objects
                    if (allSubjectResults != null && allSubjectResults.size() != 0) {
                        for (SubjectResult subjectResult : allSubjectResults) {
                            Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());
                            String subjectGradeTypeCode;
                            if (OpusConstants.ATTACHMENT_RESULT.equals(subject.getResultType())) {
                                subjectGradeTypeCode = OpusConstants.ATTACHMENT_RESULT;
                            } else {
                                subjectGradeTypeCode = studyPlanGradeTypeCode;
                            }
                            subjectResultFormatter.loadAdditionalInfo(subjectResult, subjectGradeTypeCode, preferredLanguage);
                        }
                    }

                    if (thesisResult != null) {
                        // fetch additional thesisResult related data to make it available in the thesisResult object
                        thesisResultFormatter.loadAdditionalInfo(thesisResult, studyPlanGradeTypeCode, preferredLanguage);
                    }

                    
                    // for result of the overall studyplan consider latest time unit
                    if (studyPlanResult != null) {
                        StudyPlanCardinalTimeUnit latestSpctu = allStudyPlanCardinalTimeUnits.get(allStudyPlanCardinalTimeUnits.size()-1);
                        studyPlanResultForm.setResultsVisibleToStudentsForStudyPlan(latestSpctu.isResultsPublished());
                    }
        
        
                    // -- Subjects and subject blocks --
                    List<SubjectBlock> allSubjectBlocks = studentManager.findSubjectBlocksForStudyPlan(studyPlanId);
                    studyPlanResultForm.setAllSubjectBlocks(allSubjectBlocks);
        
                    List<Subject> subjectsForStudyPlan = subjectManager.findSubjectsForStudyPlan(studyPlanId);
                    List<Subject> allSubjects = subjectsForStudyPlan;
                    studyPlanResultForm.setAllSubjects(allSubjects);
        

                    //  SUBJECTSUBJECTBLOCKS
                    if (allSubjectBlocks != null && !allSubjectBlocks.isEmpty()) {
                        List<Integer> subjectBlockIds = DomainUtil.getIds(allSubjectBlocks);

                        Map<String, Object> findSSBMap = new HashMap<>();
                        findSSBMap.put("subjectBlockIds", subjectBlockIds);
                        studyPlanResultForm.setAllSubjectSubjectBlocks(subjectManager.findSubjectSubjectBlocks(findSSBMap));
                    }

                    // TODO there is already "allStudyPlanDetails" fetched from database - either replace the above with this one or the other way around
//                    List<Integer> studyGradeTypeIds = DomainUtil.getIntProperties(allStudyPlanCardinalTimeUnits, "studyGradeTypeId");
                    List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = studyPlan.getStudyPlanCardinalTimeUnits();
                    List<StudyPlanDetail> studyPlanDetails = DomainUtil.getMergedCollectionProperties(studyPlanCardinalTimeUnits, "studyPlanDetails");
                    List<Integer> studyPlanDetailIds = DomainUtil.getIds(studyPlanDetails);
                    List<Integer> studyGradeTypeIds = DomainUtil.getProperties(studyPlanCardinalTimeUnits, "studyGradeTypeId");
        
                    List<StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(studyGradeTypeIds, preferredLanguage);
                    studyPlanResultForm.setAllStudyGradeTypes(allStudyGradeTypes);
        
                    // allStudies: for allStudygradetypes, allSubjectBlocks and allSubjects
                    List<Integer> studyIds = DomainUtil.getIntProperties(allStudyGradeTypes, "studyId");
                    studyIds.addAll(DomainUtil.getIntProperties(allSubjects, "primaryStudyId"));
                    studyIds.addAll(DomainUtil.getIntProperties(allSubjectBlocks, "primaryStudyId"));
                    List<Study> allStudies = studyManager.findStudies(studyIds, preferredLanguage);
                    studyPlanResultForm.setAllStudies(allStudies);


                    //  SUBJECTBLOCKSTUDYGRADETYPES & SUBJECTSTUDYGRADETYPES
                    List<SubjectBlockStudyGradeType> subjectBlockStudyGradeTypes = subjectManager.findSubjectBlockStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
                    studyPlanResultForm.setAllSubjectBlockStudyGradeTypes(subjectBlockStudyGradeTypes);

                    List<Integer> subjectBlockStudyGradeTypeIds = DomainUtil.getIds(subjectBlockStudyGradeTypes);
// TODO findSubjectStudyGradeTypes returns > 1700 SubjectStudyGradeTypes for spdId = 113560
                    List<SubjectStudyGradeType> allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
                    // add the (virtual) blocked subjectstudygradetypes from the previous studyplancardinaltimeunit too, in case one or more have to be repeated:
                    List<SubjectStudyGradeType> blockedSubjectStudyGradeTypes = subjectManager.findBlockedSubjectStudyGradeTypeByParams(subjectBlockStudyGradeTypeIds);
                    allSubjectStudyGradeTypes.addAll(blockedSubjectStudyGradeTypes);
                    studyPlanResultForm.setAllSubjectStudyGradeTypes(allSubjectStudyGradeTypes);


                    if (allStudyPlanDetails != null && allStudyPlanDetails.size() != 0) {
                        Map<String, AuthorizationSubExTest> authorizationMap = resultManager.determineAuthorizationForSubjectResults(allStudyPlanDetails, allStudyPlanCardinalTimeUnits, allSubjectResults, request);
                        studyPlanResultForm.setSubjectResultAuthorizationMap(authorizationMap);
                    }
                    
                    studyPlanResult.setSubjectResults(allSubjectResults);
                }
            }

        }

        return formView;
    }

    /**
     * @param studyPlanResultForm
     * @param bindingResult
     * @param status
     * @param request
     * @return
     */
//    @Transactional
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute(FORM_NAME) StudyPlanResultForm studyPlanResultForm,
            BindingResult bindingResult, SessionStatus status, HttpServletRequest request) { 
        
    	NavigationSettings navigationSettings = studyPlanResultForm.getNavigationSettings();

        Student student = studyPlanResultForm.getStudent();
        StudyPlan studyPlan = studyPlanResultForm.getStudyPlan();

        StudyPlanResult studyPlanResult = studyPlan.getStudyPlanResult();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
    	
        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        String minimumMarkValueStudyPlan = studyPlanResultForm.getMinimumMarkValueStudyPlan();
        String maximumMarkValueStudyPlan = studyPlanResultForm.getMaximumMarkValueStudyPlan();
        if (!StringUtils.hasText(minimumMarkValueStudyPlan)) {
            bindingResult.reject("invalid.studyplan.empty");
            return formView;
        }

        bindingResult.pushNestedPath("studyPlan.studyPlanResult");
        StudyPlanResultValidator studyPlanResultValidator = new StudyPlanResultValidator(minimumMarkValueStudyPlan, maximumMarkValueStudyPlan);
        studyPlanResultValidator.validate(studyPlanResult, bindingResult);
        bindingResult.popNestedPath();
        if (bindingResult.hasErrors()) {
        	return formView;
        }
    
    
    	if (log.isDebugEnabled()) {
    		log.debug("StudyPlanResultEditController.processSubmit");
    	}

        // find endGradeType:
    	String endGradeTypeCode = studyPlan.getGradeTypeCode();

    	// TODO test if it works for new studyPlanResult! (was only executed for update result)
        String passed = resultManager.isPassedStudyPlanResult(
                studyPlanResult, preferredLanguage, endGradeTypeCode,
                studyPlanResultForm.getAcadmicYearIdOfLastCTU());
        studyPlanResult.setPassed(passed);

        if (studyPlanResult.getId() == 0) {
            resultManager.addStudyPlanResult(studyPlanResult, opusMethods.getWriteWho(request));
        } else {
            resultManager.updateStudyPlanResult(studyPlanResult, opusMethods.getWriteWho(request));
        }

        status.setComplete();

    	return "redirect:/college/studyplanresult.view?newForm=true"
                + "&studentId=" + student.getStudentId() 
                + "&studyPlanId=" + studyPlan.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();

    }

//    @Transactional
    @RequestMapping(method = RequestMethod.POST, params = "setThesisMark")
    public String setThesisMark(@ModelAttribute(FORM_NAME) StudyPlanResultForm studyPlanResultForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

        StudyPlan studyPlan = studyPlanResultForm.getStudyPlan();
        StudyPlanResult studyPlanResult = studyPlan.getStudyPlanResult();
        ThesisResult thesisResult = studyPlanResult.getThesisResult();

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        Locale currentLoc = RequestContextUtils.getLocale(request);

        if (thesisResult != null) {
            if (log.isDebugEnabled()) {
                log.debug("StudyPlanResultEditController: thesisResult.getMark() = " 
                        + thesisResult.getMark());
            }

            String passed = resultManager.isPassedThesisResult(
                    studyPlanResult.getStudyPlanId(),
                    thesisResult, preferredLanguage, studyPlan.getGradeTypeCode(), studyPlanResultForm.getAcadmicYearIdOfLastCTU());
            thesisResult.setPassed(passed);
            thesisResult.setWriteWho(opusMethods.getWriteWho(request));

            if (thesisResult.getId() == 0) {        // TODO only set into thesisResult - save in processSubmit
                resultManager.addThesisResult(thesisResult);
            } else {
                resultManager.updateThesisResult(thesisResult);
            }
        }

        return formView;
    }

//    @Transactional
    @RequestMapping(method=RequestMethod.POST, params="generateResultButton")
    public String generateResult(@ModelAttribute(FORM_NAME) StudyPlanResultForm studyPlanResultForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

        StudyPlan studyPlan = studyPlanResultForm.getStudyPlan();
        StudyPlanResult studyPlanResult = studyPlan.getStudyPlanResult();

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale currentLoc = RequestContextUtils.getLocale(request);

//        if ("Y".equals(generateStudyPlanMark)) {
            if (log.isDebugEnabled()) {
                log.debug("StudyPlanResultEditController: generateStudyPlanMark=true");
            }
            studyPlanResult.setMark(null);
            studyPlanResult.setPassed("N");
//        }

            studyPlanResult = resultManager.generateStudyPlanMark(studyPlanResult, 
                    preferredLanguage, currentLoc, studyPlan.getGradeTypeCode(), studyPlanResultForm.getAcadmicYearIdOfLastCTU(),
                    result);

        return formView;
    }

    @PreAuthorize("hasRole('DELETE_CARDINALTIMEUNIT_RESULTS')")
    @RequestMapping(method=RequestMethod.GET, params="deleteCardinalTimeUnit=true")
    public String deleteCardinalTimeUnitResult(@RequestParam("cardinalTimeUnitResultId") int cardinalTimeUnitResultId,
            @ModelAttribute(FORM_NAME) StudyPlanResultForm studyPlanResultForm,
            BindingResult result, SessionStatus status,HttpServletRequest request) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        StudyPlan studyPlan = studyPlanResultForm.getStudyPlan();

        // assert the delete privilege
        CardinalTimeUnitResult cardinalTimeUnitResult = resultManager.findCardinalTimeUnitResult(cardinalTimeUnitResultId);
        resultManager.assertDeleteAuthorization(cardinalTimeUnitResult, request);

        // TODO verify if no studyPlanResult exists

        resultManager.deleteCardinalTimeUnitResult(cardinalTimeUnitResultId, opusMethods.getWriteWho(request));
        status.setComplete();

        NavigationSettings navigationSettings = studyPlanResultForm.getNavigationSettings();
        return "redirect:/college/studyplanresult.view?newForm=true&studyPlanId=" + studyPlan.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();
    }

//    @Transactional
    @RequestMapping(value="/deletesubjectresult", method=RequestMethod.GET)
    public String deleteSubjectResult(@RequestParam("subjectResultId") int subjectResultId,
            @ModelAttribute(FORM_NAME) StudyPlanResultForm studyPlanResultForm,
            BindingResult result, SessionStatus sessionStatus, HttpServletRequest request) { 

        SubjectResult subjectResult = resultManager.findSubjectResult(subjectResultId);

        // Assert authorization
        Map<String, AuthorizationSubExTest> authorizationMap = studyPlanResultForm.getSubjectResultAuthorizationMap();
        String writeWho = opusMethods.getWriteWho(request);
        resultManager.assertDeleteAuthorization(subjectResult, authorizationMap, writeWho);
        
        SubjectResultDeleteValidator subjectResultDeleteValidator = new SubjectResultDeleteValidator(studentManager, resultManager);
        subjectResultDeleteValidator.validate(subjectResult, result);
        if (result.hasErrors()) {
            return formView;
        }

        resultManager.deleteSubjectResult(subjectResultId, writeWho);
        sessionStatus.setComplete();

        StudyPlan studyPlan = studyPlanResultForm.getStudyPlan();
        NavigationSettings navigationSettings = studyPlanResultForm.getNavigationSettings();
        return "redirect:/college/studyplanresult.view?newForm=true"
                + "&studentId=" + studyPlan.getStudentId() 
                + "&studyPlanId=" + studyPlan.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel();
    }
    
    @RequestMapping(value = "/subjectHistory/{subjectId}/{studyPlanDetailId}")
    public ModelAndView subjectHistory(HttpServletRequest request, @PathVariable("subjectId") int subjectId, @PathVariable("studyPlanDetailId") int studyPlanDetailId, @ModelAttribute(FORM_NAME) StudyPlanResultForm form) {
        
        return reportController.createReport(request.getSession(false), "result/SubjectHistory",
                " AND subject.id = " + subjectId + " AND studyPlanDetailId = " + studyPlanDetailId, 
                "SubjectResults_" + subjectId, "pdf", OpusMethods.getPreferredLocale(request));
    }


}
