package org.uci.opus.moz.service.extension;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.extpoint.ProgressCalculation;
import org.uci.opus.config.OpusConstants;

/*
 * Calculate the progress status for a studyplancardinaltimeunit
 * based on the Mozambican business rules
 */
public class ProgressCalculationForMozambique implements ProgressCalculation {

    private static Logger log = LoggerFactory.getLogger(ProgressCalculationForMozambique.class);

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private ResultManagerInterface resultManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Override
    public void calculateProgressStatusForStudyPlanCardinalTimeUnit(final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,
            final String preferredLanguage, final Locale currentLoc) {

        if (log.isDebugEnabled()) {
            log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit entered");
        }

        if (studyPlanCardinalTimeUnit == null || studyPlanCardinalTimeUnit.getId() == 0) {
            return;
        }

        // 1. check if this studyplancardinaltimeunit has a ctu-result:
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        int maxNumberOfSubjects = studyGradeType.getMaxNumberOfSubjectsPerCardinalTimeUnit();
        int maxNumberOfFailedSubjects = studyGradeType.getMaxNumberOfFailedSubjectsPerCardinalTimeUnit();
        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());

        Map<String, Object> ctuMap = new HashMap<>();
        // ctuMap.put("studyPlanId", studyPlan.getId());
        ctuMap.put("studyPlanCardinalTimeUnitId", studyPlanCardinalTimeUnit.getId());
        // ctuMap.put("currentAcademicYearId", studyGradeType.getCurrentAcademicYearId());
        ctuMap.put("active", "Y");

        CardinalTimeUnitResult cardinalTimeUnitResult = resultManager.findCardinalTimeUnitResultByParams(ctuMap);
        if (cardinalTimeUnitResult == null) {
            if (log.isDebugEnabled()) {
                log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: cardinalTimeUnitResult is NULL, therefore progress calculation not possible");
            }
            // jump out of this method without action:
            return;
        }

        // 2. check if this studyplancardinaltimeunit has calculatable subjectresults:
//        ctuMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
//        ctuMap.put("studyGradeTypeId", studyPlanCardinalTimeUnit.getStudyGradeTypeId());
//        ctuMap.put("active", "Y");
//        List<StudyPlanDetail> studyPlanDetailsForStudyPlanCardinalTimeUnit = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(ctuMap);

        List<Subject> subjects = studyPlanCardinalTimeUnit.getSubjects();
        int numberOfAssignedSubjects = subjects.size();

//        if (studyPlanDetailsForStudyPlanCardinalTimeUnit != null && studyPlanDetailsForStudyPlanCardinalTimeUnit.size() != 0) {
        if (numberOfAssignedSubjects != 0) {
            if (log.isDebugEnabled()) {
                log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanDetailsForStudyPlanCardinalTimeUnit found, size = "
                        + numberOfAssignedSubjects);
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: NO studyPlanDetailsForStudyPlanCardinalTimeUnit found");
            }
            // jump out of this method without action:
            return;
        }

        ctuMap.put("studyId", studyPlan.getStudyId());
        ctuMap.put("gradeTypeCode", studyPlan.getGradeTypeCode());
        ctuMap.put("cardinalTimeUnitNumber", studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());

        List<SubjectResult> subjectResultsForCTU = resultManager.findCalculatableSubjectResultsForCardinalTimeUnit(
                studyPlanCardinalTimeUnit.getStudyPlanDetails(), ctuMap);
        if (subjectResultsForCTU != null && subjectResultsForCTU.size() != 0) {

            if (log.isDebugEnabled()) {
                log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: subjectResultsForCTU found, size = "
                        + subjectResultsForCTU.size());
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: NO subjectResultsForCTU found");
            }
            // jump out of this method without action:
            return;
        }

        // 3. business rules checks:
        List<SubjectResult> failedSubjectResults = new ArrayList<>();
        List<SubjectResult> passedSubjectResults = new ArrayList<>();
        for (SubjectResult sr : subjectResultsForCTU) {
            if ("N".equals(resultManager.isPassedSubjectResult(sr, sr.getMark(), preferredLanguage, studyGradeType.getGradeTypeCode(), null))) {
                failedSubjectResults.add(sr);
            } else {
                passedSubjectResults.add(sr);
            }
        }
        
        int numberOfMissingResults = numberOfAssignedSubjects - subjectResultsForCTU.size();
        int numberOfFailedOrMissingResults = failedSubjectResults.size() + numberOfMissingResults;
        
        String progressStatusCode;
        if (numberOfFailedOrMissingResults == 0) {

            // No failed or missing subjects: Either "graduate" or "clear pass"

            if (studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() == studyGradeType.getNumberOfCardinalTimeUnits()) {
                // Graduate:
                // If all subjects from the final cardinal time-unit are succeeded.
                // No forwarding to the next cardinal time-unit.
//                studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_GRADUATE);
                progressStatusCode = OpusConstants.PROGRESS_STATUS_GRADUATE;
//                return;

            } else {
//                studyPlanCardinalTimeUnit.setProgressStatusCode(OpusConstants.PROGRESS_STATUS_CLEAR_PASS);
                progressStatusCode = OpusConstants.PROGRESS_STATUS_CLEAR_PASS;

            }
        } else if (numberOfFailedOrMissingResults <= maxNumberOfFailedSubjects) {
            progressStatusCode = OpusConstants.PROGRESS_STATUS_PROCEED_AND_REPEAT;
        } else {
            progressStatusCode = OpusConstants.PROGRESS_STATUS_REPEAT;
        }
        if (log.isDebugEnabled()) {
            log.debug("ProgressCalculationForMozambique.calculateProgressStatusForStudyPlanCardinalTimeUnit: studyPlanCardinalTimeUnitId = "
                    + studyPlanCardinalTimeUnit.getId() + " set to " + progressStatusCode);
        }
        studyPlanCardinalTimeUnit.setProgressStatusCode(progressStatusCode);
        
    }

    @Override
    public boolean proceedCheck(Lookup7 oldProgressStatus, List<SubjectResult> allUnPassedSubjectResults, int subjectId, boolean subjectRepeated) {

        // empty method.

        return subjectRepeated;
    }

}
