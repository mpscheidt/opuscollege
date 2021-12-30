package org.uci.opus.moz.service.extension;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.ResultsCalculations;

public class ResultsCalculationsForMozambique implements ResultsCalculations {

    private static Logger log = LoggerFactory.getLogger(ResultsCalculationsForMozambique.class);

    @Autowired private ResultManagerInterface resultManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private SubjectManagerInterface subjectManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    @Override
    public StudyPlanResult calculateResultsForStudyPlan(Study study,
            StudyPlanResult studyPlanResult, BigDecimal brsPassingSubjectDouble,
            String preferredLanguage, Locale currentLoc,
            Errors errors) {

        int studyPlanId = studyPlanResult.getStudyPlanId();

        // ----- SUBJECT RESULTS -----
        
        // determine all subjects within this study plan
        Set<String> allSubjectCodesForStudyPlan = new HashSet<>(); // subjectCodes instead of Subjects to ensure uniqueness

        Map<String, Object> studyPlanDetailMap = new HashMap<>();
        studyPlanDetailMap.put("studyPlanId", studyPlanId);
        studyPlanDetailMap.put("progressStatusCodeNotCarryingAll", "Y");   // ignore CTUs that had to be repeated entirely
        studyPlanDetailMap.put("preferredLanguage", preferredLanguage);
        studyPlanDetailMap.put("active", "Y");
        List<StudyPlanDetail> studyPlanDetails = studentManager.findStudyPlanDetailsByParams(studyPlanDetailMap);
        for (StudyPlanDetail studyPlanDetail : studyPlanDetails) {
            if (studyPlanDetail.getSubjectId() != 0) {
                Subject subject = subjectManager.findSubject(studyPlanDetail.getSubjectId());
                allSubjectCodesForStudyPlan.add(subject.getSubjectCode());
            }
            if (studyPlanDetail.getSubjectBlockId() != 0) {
                List<Subject> subjects = subjectBlockMapper.findSubjectsForSubjectBlock(studyPlanDetail.getSubjectBlockId());
                allSubjectCodesForStudyPlan.addAll(DomainUtil.getStringProperties(subjects, "subjectCode"));
            }
        }

        if (allSubjectCodesForStudyPlan == null || allSubjectCodesForStudyPlan.isEmpty()) {
//            errorMsg = messageSource.getMessage("jsp.error.studyplanhasnosubjects", null, currentLoc);
            errors.reject("jsp.error.studyplanhasnosubjects");
        }

        // go through all subjects to determine sum of marks and sum of credits
        BigDecimal sumMarkTimesCredit = BigDecimal.ZERO;
        BigDecimal sumCredit = BigDecimal.ZERO;

        if (!errors.hasErrors()) {

            Map<String, Object> subjectResultMap = new HashMap<>();
            subjectResultMap.put("studyPlanId", studyPlanId);
            subjectResultMap.put("passed", "Y");
            subjectResultMap.put("active", "Y");
            subjectResultMap.put("orderBy", "subjectResult.mark DESC");
            subjectResultMap.put("limit", 1);
            
            for (String subjectCode : allSubjectCodesForStudyPlan) {

                // determine the "best" result, i.e. highest mark
                subjectResultMap.put("subjectCode", subjectCode);
                
                List<SubjectResult> subjectResults = resultManager.findSubjectResultsByParams(subjectResultMap);
                if (subjectResults == null || subjectResults.isEmpty()) {
//                    errorMsg = messageSource.getMessage("jsp.error.missingsubjectresults", null, currentLoc);
                    errors.reject("jsp.error.missingsubjectresults");
                    break;
                } else {
                    SubjectResult subjectResult = subjectResults.get(0);    // the highest mark the student got on this subject
                    Subject subject = subjectManager.findSubject(subjectResult.getSubjectId());

                    BigDecimal subjectResultMark = new BigDecimal(subjectResult.getMark());
                    // Use the rounded subject result: 10 (instead of 9.5), 11 (instead of 11.49)
                    // setScale() with 0 fractional digits rounds and is easier than the BigDecimal.round() mode
                    //   see: http://stackoverflow.com/a/4134135/606662 about BigInteger.setScale()
                    BigDecimal roundedSubjectResultMark = subjectResultMark.setScale(0, RoundingMode.HALF_UP);
                    BigDecimal subjectCredit = subject.getCreditAmount();
                    sumMarkTimesCredit = sumMarkTimesCredit.add(roundedSubjectResultMark.multiply(subjectCredit));
                    sumCredit = sumCredit.add(subjectCredit);

                    if (log.isDebugEnabled()) {
                        log.debug(subject + ": " + sumMarkTimesCredit + "(after adding " + roundedSubjectResultMark + " * " + subjectCredit + "); total credits: " + sumCredit);
                    }
                }
            }
        }

        // ----- THESIS RESULT -----
        if (!errors.hasErrors()) {
            Thesis thesis = studentManager.findThesisForStudyPlan(studyPlanId);
            if (thesis != null) {
                if (log.isDebugEnabled()) {
                    log.debug("ResultsCalculationsForMozambique.calculateResultsForStudyPlan: thesis found: " 
                                + thesis.getThesisDescription());
                }
    
                ThesisResult thesisResult = resultManager.findThesisResultByThesisId(thesis.getId());
                if (thesisResult == null) {
//                    errorMsg = messageSource.getMessage("jsp.error.missingthesisresult", null, currentLoc);
                    errors.reject("jsp.error.missingthesisresult");
                } else if (!"Y".equalsIgnoreCase(thesisResult.getPassed())) {
//                    errorMsg = messageSource.getMessage("jsp.error.thesisnotpassed", null, currentLoc);
                    errors.reject("jsp.error.thesisnotpassed");
                } else {
                    // everything's ok -> let's include the thesis result just like any other result to the calculation
                    BigDecimal thesisCredit = new BigDecimal(thesis.getCreditAmount());
                    BigDecimal thesisMark = new BigDecimal(thesisResult.getMark());
                    BigDecimal roundedThesisMark = thesisMark.setScale(0, RoundingMode.HALF_UP);
                    sumMarkTimesCredit = sumMarkTimesCredit.add(roundedThesisMark.multiply(thesisCredit));
                    sumCredit = sumCredit.add(thesisCredit);

                    if (log.isDebugEnabled()) {
                        log.debug(thesis + ": " + sumMarkTimesCredit + "(after adding " + roundedThesisMark + " * " + thesisCredit + "); total credits: " + sumCredit);
                    }
                }
            }
        }

        if (errors.hasErrors()) {
            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForMozambique.calculateResultsForStudyPlan: after calculation errMsg is not empty: " + errors);
            }
            studyPlanResult.setMark("0.0");
        } else {
            // divide sum-of-subject-marks by sum-of-subject-credits
            BigDecimal studyPlanMarkDec = sumMarkTimesCredit.divide(sumCredit, 2, RoundingMode.HALF_UP);

            if (log.isDebugEnabled()) {
                log.debug("ResultsCalculationsForMozambique.calculateResultsForStudyPlan: AFTER end-calculation studyPlanMark = " 
                        + studyPlanMarkDec.toPlainString());
            }

            // round the decimal
            BigDecimal roundedStudyPlanMark = studyPlanMarkDec.setScale(0, RoundingMode.HALF_UP);

            studyPlanResult.setMark(roundedStudyPlanMark.toString());
            studyPlanResult.setMarkDecimal(studyPlanMarkDec);
        }

        return studyPlanResult;
    }

}