package org.uci.opus.college.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.config.OpusConstants;

/**
 * 
 * Logic to update student payment statuses based on {@link StudentBalanceEvaluation}.
 * 
 * @author markus
 *
 */
@Service
public class StudentPaymentChecker {
    
    private static Logger log = LoggerFactory.getLogger(StudentPaymentChecker.class);
    
    @Autowired
    private CollegeServiceExtensions collegeServiceExtensions;

    @Autowired
    private StudentManagerInterface studentManager;

    /**
     * Check for status of registration payments and eventually update
     * studyPlanCardinalTimeUnit status.
     * @param academicYearId
     */
    public void checkSufficientPaymentsForRegistration(int academicYearId) {

        StudentBalanceEvaluation studentBalanceEvaluation = collegeServiceExtensions.getStudentBalanceEvaluation();

        // get a list of studyPlanCTUs with status "waiting for payment"
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentAcademicYearId", academicYearId);
        map.put("cardinalTimeUnitStatusCode", OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT);
        List<Integer> spctuIds = studentManager.findStudyPlanCardinalTimeUnitIds(map);
        
        log.info(spctuIds.size() + " studyPlanCardinalTimeUnits in current academic year (id = " + academicYearId + ") with status 'waiting for payment' - studyPlanCardinalTimeUnit-IDs: " + spctuIds);

        // check for each student if sufficient payment has been made and set status accordingly
        for (int spctuId : spctuIds) {
            int studentId = studentManager.findStudentIdForStudyPlanCardinalTimeUnitId(spctuId);
            StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluation.getStudentBalanceInformation(studentId);
            if (studentBalanceEvaluation.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation)) {
                log.info("studyPlanCardinalTimeUnit (id = " + spctuId + ", studentId = " + studentId + ") has paid sufficiently for the registration, setting registration status to 'customize program'");

                // only now load the SPCTU in order to update the status
                StudyPlanCardinalTimeUnit spctu = studentManager.findStudyPlanCardinalTimeUnit(spctuId);
                spctu.setCardinalTimeUnitStatusCode(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME);
                studentManager.updateCardinalTimeUnitStatusCode(spctu);
            }
        }

    }
}
