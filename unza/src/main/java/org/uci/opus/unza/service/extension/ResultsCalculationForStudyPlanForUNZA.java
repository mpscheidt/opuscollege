/*******************************************************************************
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
 * The Original Code is Opus-College unza module code.
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
 ******************************************************************************/
package org.uci.opus.unza.service.extension;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.ResultsCalculations;
import org.uci.opus.college.service.result.ResultUtil;
import org.uci.opus.util.StringUtil;

/*
 * Calculate the progress status for a studyplancardinaltimeunit
 * based on business rules for a university or country
 */

public class ResultsCalculationForStudyPlanForUNZA 
		implements ResultsCalculations {

    private static Logger log = Logger.getLogger(ResultsCalculationForStudyPlanForUNZA.class);
    
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private MessageSource messageSource;    
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private ResultUtil resultUtil;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;

    /**
     * @see org.uci.opus.college.service.ResultsCalculationForStudyPlan_old
     *      #calculateResultsForStudyPlan(
     *      org.uci.opus.college.domain.Study, org.uci.opus.college.domain.result.StudyPlanResult,
     *      double, java.lang.String, java.util.Locale)
     */
    @Override
    public final StudyPlanResult calculateResultsForStudyPlan(
    		final Study study, 
    		final StudyPlanResult studyPlanResult,
            final BigDecimal brsPassingSubjectDouble,
            final String preferredLanguage, 
            final Locale currentLoc,
            Errors errors) {   // TODO use errors object for validation

        Study diffStudy = null;
        StudyGradeType diffStudyGradeType = null;
        String errorMsg = "";
        boolean allSubjectsPassed = false;
        boolean subjectResultForSubjectFound = false;
        BigDecimal creditAmount = BigDecimal.ZERO;
        BigDecimal totalCreditAmount = BigDecimal.ZERO;
        String subjectResultMark = "";
        int subjectResultMarkInt = 0;
        BigDecimal subjectResultMarkDouble = BigDecimal.ZERO;
        BigDecimal maxSubjectResultMarkDouble = BigDecimal.ZERO;
        boolean markIsString = false;
        String examMark = null;
        int examMarkInt = 0;
        BigDecimal examMarkDouble = BigDecimal.ZERO;
        BigDecimal thesisCreditAmount = BigDecimal.ZERO;
        Thesis thesis = null;
        ThesisResult thesisResult = null;
        String thesisMark = "0.0";
        int thesisMarkInt = 0;
        BigDecimal thesisMarkDouble = BigDecimal.ZERO;
        List < ? extends EndGrade > allEndGrades = null;
        List < SubjectResult > subjectResultsForStudyPlan = null;
        List < Subject > allSubjectsForStudyPlan = null;
        List < StudyPlanDetail > allStudyPlanDetailsForStudyPlan = null;
        List < Subject > calculatableSubjects = null;
        StudyPlan studyPlan = null;
        
        studyPlan = studentManager.findStudyPlan(studyPlanResult.getStudyPlanId());

        Map<String, Object> acadMap = new HashMap<String, Object>();
        acadMap.put("studyPlanId", studyPlanResult.getStudyPlanId());
        AcademicYear lastAcademicYear = academicYearManager.findLastAcademicYear(acadMap);

        Map<String, Object> endGradeMap = new HashMap<String, Object>();
        endGradeMap.put("preferredLanguage", preferredLanguage);
        endGradeMap.put("endGradeTypeCode", studyPlan.getGradeTypeCode());
        endGradeMap.put("academicYearId", lastAcademicYear.getId());
        allEndGrades = studyManager.findAllEndGrades(endGradeMap);

        allSubjectsForStudyPlan = 
            studentManager.findActiveSubjectsForStudyPlan(studyPlan.getId());
        allStudyPlanDetailsForStudyPlan = 
            studentManager.findStudyPlanDetailsForStudyPlan(studyPlan.getId());
        
        if (allSubjectsForStudyPlan != null 
                && allSubjectsForStudyPlan.size() != 0 
                    && allStudyPlanDetailsForStudyPlan != null 
                        && allStudyPlanDetailsForStudyPlan.size() != 0) {
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: allSubjectsForStudyPlan.size() = " 
                        + allSubjectsForStudyPlan.size() + ", allStudyPlanDetailsForStudyPlan.size() = "
                        + allStudyPlanDetailsForStudyPlan.size());
            }
            
            subjectResultsForStudyPlan = resultManager.findCalculatableSubjectResultsForStudyPlan(
                    allStudyPlanDetailsForStudyPlan, 
                    allSubjectsForStudyPlan, studyPlan, false);
            
            if (subjectResultsForStudyPlan == null || subjectResultsForStudyPlan.size() == 0) {
                errorMsg = errorMsg + messageSource.getMessage(
                        "jsp.error.studyplancardinaltimeunitstatus.activelyregistered", null, currentLoc);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: calculatable subjectResults.size() " 
                            + subjectResultsForStudyPlan.size());
                }
            }
            calculatableSubjects = resultManager.findCalculatableSubjectsForStudyPlan(
                    preferredLanguage, studyPlan, "allYears");
            
        } else {
        	 if (log.isDebugEnabled()) {
                 log.debug("ResultsCalculations.calculateResultsForStudyPlanForUNZA: allSubjectsForStudyPlan.size() IS NULL " +
                 		"or allStudyPlanDetailsForStudyPlan.size() is NULL");
             }       	
        }
        
        if ("".equals(errorMsg) && calculatableSubjects == null) {
            errorMsg = errorMsg + messageSource.getMessage(
                    "jsp.error.studyplancardinaltimeunitstatus.activelyregistered", null, currentLoc);
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculations.calculateResultsForStudyPlanForUNZA: calculatableSubjects.size() = " +
                		calculatableSubjects.size());
            }
        }
        
        if ("".equals(errorMsg)) {
            if (calculatableSubjects.size() == 0) {
                errorMsg = errorMsg + messageSource.getMessage(
                        "jsp.error.subjects.notenough.calculation", null, currentLoc);
            } else {
                // Studyplan result calculation must take into account that subjects may be from
                // different studies or studygradetypes with their own rewarding scales 
                // (minimumMark / maximumMark scale).
                // If these differ, then no generated mark can be set -> errorMsg !
                if (subjectResultsForStudyPlan != null && subjectResultsForStudyPlan.size() != 0) {
                    
                    for (int h = 0; h < calculatableSubjects.size(); h++) {
                        diffStudy = null;
                        diffStudyGradeType = null;
                        Subject subject = null;
                        
                        // general: first check endgrades for correct comparison values (study or studygradetype)
                        if (allEndGrades == null || allEndGrades.get(0) == null
                                || "".equals(allEndGrades.get(0).getEndGradeTypeCode())) {
                            //  no studygradetype defined (mozambican situation):
                            if (calculatableSubjects.get(h).getPrimaryStudyId() != study.getId()) {
                                diffStudy = studyManager.findStudy(
                                        calculatableSubjects.get(h).getPrimaryStudyId());
                                if (!diffStudy.getMinimumMarkSubject().equals(study.getMinimumMarkSubject())) {
                                    errorMsg = messageSource.getMessage(
                                            "jsp.error.different.rewarding.scales", null, currentLoc);
                                }
                                if (!diffStudy.getMaximumMarkSubject().equals(study.getMaximumMarkSubject())) {
                                    errorMsg = messageSource.getMessage(
                                            "jsp.error.different.rewarding.scales", null, currentLoc);
                                }
                            }
                        } else {
                            //  studygradetype defined (zambian situation):
                            subject = calculatableSubjects.get(h);
                            Map<String, Object> map = new HashMap<String, Object>();
                            map.put("subjectId", subject.getId());
                            map.put("preferredLanguage", preferredLanguage);
                            List <? extends SubjectStudyGradeType> subjectStudyGradeTypes = 
                                    subjectManager.findSubjectStudyGradeTypes(map);
                            BigDecimal saveMinimumEndGradeStudyGradeType = BigDecimal.ZERO;
                            BigDecimal saveMaximumEndGradeStudyGradeType = BigDecimal.ZERO;
                            BigDecimal minimumEndGradeStudyGradeType = BigDecimal.ZERO;
                            BigDecimal maximumEndGradeStudyGradeType = BigDecimal.ZERO;
                            for (int x = 0; x < subjectStudyGradeTypes.size(); x++) {
                                SubjectStudyGradeType subjectStudyGradeType = subjectStudyGradeTypes.get(x);
                                StudyGradeType sgt = studyManager.findStudyGradeType(subjectStudyGradeType.getStudyGradeTypeId());

                                Map<String, Object> minMap = new HashMap<String, Object>();
                                minMap.put("endGradeTypeCode", subjectStudyGradeType.getGradeTypeCode());
                                minMap.put("academicYearId", sgt.getCurrentAcademicYearId());

                                minimumEndGradeStudyGradeType = studyManager.findMinimumEndGradeForGradeType(minMap);
                                maximumEndGradeStudyGradeType = studyManager.findMaximumEndGradeForGradeType(minMap);
//                                if (saveMinimumEndGradeStudyGradeType != 0.0 
//                                        && saveMinimumEndGradeStudyGradeType != minimumEndGradeStudyGradeType) {
                                if (saveMinimumEndGradeStudyGradeType.compareTo(BigDecimal.ZERO) != 0 
                                        && saveMinimumEndGradeStudyGradeType.compareTo(minimumEndGradeStudyGradeType) != 0) {
                                    errorMsg = messageSource.getMessage(
                                            "jsp.error.different.rewarding.scales", null, currentLoc);
                                    break;
                                }
//                                if (saveMaximumEndGradeStudyGradeType != 0.0 
//                                        && saveMaximumEndGradeStudyGradeType != maximumEndGradeStudyGradeType) {
                                if (saveMaximumEndGradeStudyGradeType.compareTo(BigDecimal.ZERO) != 0 
                                        && saveMaximumEndGradeStudyGradeType.compareTo(maximumEndGradeStudyGradeType) != 0) {
                                    errorMsg = messageSource.getMessage(
                                            "jsp.error.different.rewarding.scales", null, currentLoc);
                                    break;
                                }
                                
                            }
                        }
                            
                        if (!"".equals(errorMsg)) {
                            if (log.isDebugEnabled()) {
                                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                        + "error different scales: " + errorMsg);
                            }
                            // break for loop at this level:
                            break;
                        }
                    }
                } else {
                    errorMsg = errorMsg + messageSource.getMessage(
                            "jsp.error.nosubjectresults", null, currentLoc);
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                + "no subjectresults available");
                    }
                }
            }
        }
        
        if ("".equals(errorMsg)) {
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                        + "start calculation for all calculatableSubjects.size() = "
                        + calculatableSubjects.size());
            }
            for (int h = 0; h < calculatableSubjects.size(); h++) {
            	
            	// reset subject values:
                subjectResultForSubjectFound = false;
                allSubjectsPassed = false;
                // reset max value:
                maxSubjectResultMarkDouble = BigDecimal.ZERO;
                Subject subject = 
                        subjectManager.findSubject(calculatableSubjects.get(h).getId());
                if (log.isDebugEnabled()) {
                    log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                            + "start calculation for calculatableSubject " 
                            + subject.getSubjectDescription());
                }
                // 1. check if creditamount is set for the subject:
                creditAmount = subject.getCreditAmount();
//                if (creditAmount == 0) {
                if (creditAmount.compareTo(BigDecimal.ZERO) == 0) {
                    //examMark = "-";
                    examMark = "0.0";
                    errorMsg = errorMsg + messageSource.getMessage(
                            "jsp.error.subjects.creditamount.empty", null, currentLoc);
                } else {
//                    totalCreditAmount = totalCreditAmount + creditAmount;
                    totalCreditAmount = totalCreditAmount.add(creditAmount);

                    // 2. check if academicyear is set for the subject:
                    if (subject.getCurrentAcademicYearId() == 0) {
                        examMark = "0.0";
                        errorMsg = errorMsg + messageSource.getMessage(
                                "jsp.error.subjects.academicyear.empty", null, currentLoc);
                    } else {
                    	// calculate with calculatable subject values:
                        for (int i = 0; i < subjectResultsForStudyPlan.size(); i++) {
                        	if (calculatableSubjects.get(h).getId() == subjectResultsForStudyPlan.get(i).getSubjectId()) {
                                subjectResultForSubjectFound = true;
                                allSubjectsPassed = true;
                                // reset subjectResult values:
                                subjectResultMark = subjectResultsForStudyPlan.get(i).getMark();
                                subjectResultMarkInt = 0;
                
                                if (StringUtil.checkValidInt(subjectResultMark) == -1) {
                                    if (StringUtil.checkValidDouble(subjectResultMark) == -1) {
                                        // mark is string, not number:
                                        markIsString = true;
                                        for (int j = 0; j < allEndGrades.size(); j++) {
                                            if (StringUtil.lrtrim(subjectResultMark).equals(allEndGrades.get(j).getCode())) {
                                                subjectResultMarkInt = 
                                                    Integer.parseInt(allEndGrades.get(j).getDescription());
                                            }
                                        }
//                                        subjectResultMarkDouble = (double) subjectResultMarkInt;
                                        subjectResultMarkDouble = new BigDecimal(subjectResultMarkInt);
                                    } else {
//                                        subjectResultMarkDouble = Double.parseDouble(subjectResultMark);
                                        subjectResultMarkDouble = new BigDecimal(subjectResultMark);
                                    }
                                } else {
                                    subjectResultMarkInt = Integer.parseInt(subjectResultMark);
//                                    subjectResultMarkDouble = (double) subjectResultMarkInt;
                                    subjectResultMarkDouble = new BigDecimal(subjectResultMarkInt);
                                }
                                if (log.isDebugEnabled()) {
                                    log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                            + subject.getSubjectDescription() + ", subjectResultMarkDouble =  " + subjectResultMarkDouble);
                                }
                
                                // comparison necessary, only one result per examination (highest):
//                                if (subjectResultMarkDouble > maxSubjectResultMarkDouble) {
                                if (subjectResultMarkDouble.compareTo(maxSubjectResultMarkDouble) > 0) {
                                    maxSubjectResultMarkDouble = subjectResultMarkDouble;
                                }
                                // reset value:
                                subjectResultMarkDouble = BigDecimal.ZERO;
                            }
                        } // end for subjectResultsForStudyPlan
                        if (subjectResultForSubjectFound == false) {
                            errorMsg = errorMsg + messageSource.getMessage(
                                    "jsp.error.missingsubjectresults.cardinaltimeunit", null, currentLoc);
                            examMark = "0.0";
                            if (log.isDebugEnabled()) {
                                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                        + "subjectResultForSubjectFound == false");
                            }
                            break;
                        }
                    } // end if subject.getCurrentAcademicYearId() == 0 or not 
                } // end if credit amount is 0 or not

                // calculate total subject result looping
                // 2009 new: also continue when the subject is not passed or no subjectresult found:
                if ("".equals(errorMsg)) { 
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                + subject.getSubjectDescription() + " - maxSubjectResultMarkDouble:" + maxSubjectResultMarkDouble);
                    }
//                    examMarkDouble = examMarkDouble + (creditAmount * maxSubjectResultMarkDouble);
                    examMarkDouble = examMarkDouble.add(creditAmount.multiply(maxSubjectResultMarkDouble));
                } else {
                    // break the for loop:
                    break;
                }
            } // end for calculatable subjects
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: after examMark calculations: examMarkDouble = " 
                            + examMarkDouble + ", totalCreditAmount = " + totalCreditAmount);
            }
        
            /* 2. thesis (present or not) */
            if ("".equals(errorMsg)) {
                if (studyPlan.getThesis() != null && studyPlan.getThesis().getId() != 0) {
                    thesis = studentManager.findThesis(studyPlan.getThesis().getId());
                    thesisResult = resultManager.findThesisResultByThesisId(thesis.getId());
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: thesis found: " 
                                    + thesis.getThesisDescription());
                    }
                    thesisCreditAmount = new BigDecimal(thesis.getCreditAmount());
                    // retrieve actual mark for thesis
                    // fetch cardinalTimeUnitResult mark value
                    if (thesisResult != null) {
                        if (StringUtil.checkValidInt(thesisResult.getMark()) == -1) {
                            if (StringUtil.checkValidDouble(thesisResult.getMark()) == -1) {
                                // mark is string, not number:
                                markIsString = true;
                                for (int j = 0; j < allEndGrades.size(); j++) {
                                    if (StringUtil.lrtrim(thesisResult.getMark()).equals(allEndGrades.get(j).getCode())) {
                                        thesisMarkInt = 
                                            Integer.parseInt(allEndGrades.get(j).getDescription());
                                    }
                                }
//                                thesisMarkDouble = (double) thesisMarkInt;
                                thesisMarkDouble = new BigDecimal(thesisMarkInt);
                            } else {
//                                thesisMarkDouble = Double.parseDouble(thesisResult.getMark());
                                thesisMarkDouble = new BigDecimal(thesisResult.getMark());
                            }
                        } else {
                            thesisMarkInt = Integer.parseInt(thesisResult.getMark());
//                            thesisMarkDouble = (double) thesisMarkInt;
                            thesisMarkDouble = new BigDecimal(thesisMarkInt);
                        }
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: step 1 calculation thesisMarkDouble = " 
                                + thesisMarkDouble + ", thesisCreditAmount = " + thesisCreditAmount);
                    }
                    // multiply with creditamount:
//                    thesisMarkDouble = thesisMarkDouble * thesisCreditAmount;
                    thesisMarkDouble = thesisMarkDouble.multiply(thesisCreditAmount);
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: step 2 calculation thesisMarkDouble = " 
                                + thesisMarkDouble + ", thesisCreditAmount = " + thesisCreditAmount);
                    }
                }
            }

            // END CALCULATION: combine the thesisMark and examMark into one final mark:
            if ("".equals(errorMsg)) {
                // check whether there is a thesis to take into account
                if (thesis != null && thesisResult != null) {
//                    examMarkDouble = examMarkDouble + thesisMarkDouble;
//                    totalCreditAmount = totalCreditAmount + thesisCreditAmount;
                    examMarkDouble = examMarkDouble.add( thesisMarkDouble);
                    totalCreditAmount = totalCreditAmount.add(thesisCreditAmount);
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: before end-calculation thesisMark = " 
                                + thesisMarkDouble + ", totalCreditAmount = " + totalCreditAmount
                                + ", examMarkDouble = " + examMarkDouble);
                    }
                }

                if (log.isDebugEnabled()) {
                    log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: BEFORE end-calculation totalCreditAmount = " + totalCreditAmount
                            + ", examMarkDouble = " + examMarkDouble);
                }
                // calculate the average mark divided bij credit amount:
//                examMarkDouble = examMarkDouble / totalCreditAmount;
                examMarkDouble = examMarkDouble.divide( totalCreditAmount, ResultManagerInterface.MC);
                // round the end-value to 2 digits:
//                examMarkDouble = su.formatDoubleMark(examMarkDouble);
                examMarkDouble = resultUtil.formatMark(examMarkDouble);

                if (log.isDebugEnabled()) {
                    log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: AFTER end-calculation totalExamMarkDouble = " 
                            + examMarkDouble);
                }

                // decide whether to present a number or a letter:
                if (markIsString == true) {

                    // round the double -> int
//                    examMarkInt = (int) Math.round(examMarkDouble);
                    examMarkInt = examMarkDouble.intValue();

                    for (int k = 0; k < allEndGrades.size(); k++) {
                        if (examMarkInt == Integer.parseInt(allEndGrades.get(k).getDescription())) {
                            examMark = allEndGrades.get(k).getCode();
                            // break the for-loop:
                            break;
                        }
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                + "examMark is string:" + examMark);
                    }
                } else {
                    if (examMarkInt != 0) {
                        examMark = "" + examMarkInt;
                    } else {
//                        examMark = "" + su.formatDoubleMark(examMarkDouble);
                        examMark = resultUtil.formatMark(examMarkDouble).toPlainString();
                    }
                    if (log.isDebugEnabled()) {
                        log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: "
                                + "examMark is int / double:" + examMark);
                    }
                }
            }
        }
        if (!"".equals(errorMsg) ) {
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForUNZA.calculateResultsForStudyPlan: after calculation errMsg is not empty: "
                        + errorMsg);
            }
            // return errormessage:
            studyPlanResult.setMark("0.0");
//            studyPlanResult.setCalculationMessage(errorMsg);
        } else {
            studyPlanResult.setMark(examMark);
//            studyPlanResult.setCalculationMessage(null);
        }
    
        return studyPlanResult;
 
    }
}
