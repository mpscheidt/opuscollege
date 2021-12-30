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
 * The Original Code is Opus-College cbu module code.
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

package org.uci.opus.cbu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.config.OpusConstants;

@Service
public class CbuStudentPaymentChecker {

    private static Logger log = LoggerFactory.getLogger(CbuStudentPaymentChecker.class);

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private StudentManagerInterface studentManager;


    @Scheduled(fixedDelay=300000)     // fixedDelay in ms: e.g. 5000 = 5 seconds, 300000 = 5 minutes
    public void runStudentPaymentCheck() {
//        log.info("Starting periodic student payment check");
        
        StudentBalanceEvaluation studentBalanceEvaluation = collegeServiceExtensions.getStudentBalanceEvaluation();
        int currentAcademicYearId = academicYearManager.getCurrentAcademicYear().getId();
        
        // Check admission payments
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentAcademicYearId", currentAcademicYearId);    // limit to those study plans that have a time unit in the current year
        map.put("studyPlanStatusCode", OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_PAYMENT);
        List<Integer> studyPlanIds = studentManager.findStudyPlanIds(map);
        log.info(studyPlanIds.size() + " studyPlans in current academic year (id = " + currentAcademicYearId + ") with status 'waiting for payment' - studyPlan-IDs: " + studyPlanIds);
        
        // check for each studyPlan if sufficient payments made for admission
        for (int studyPlanId : studyPlanIds) {
            if (studentBalanceEvaluation.hasMadeSufficientPaymentsForAdmission(studyPlanId)) {
                log.info("Student with studyPlan (id =" + studyPlanId + ") has paid sufficiently for the admission, setting admission status to 'waiting for selection'");

                StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);
                studyPlan.setStudyPlanStatusCode(OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION);
                studentManager.updateStudyPlan(studyPlan, CbuStudentPaymentChecker.class.getSimpleName());
            }
        }
        
        // get a list of studyPlanCTUs with status "waiting for payment"
        map.clear();
        map.put("currentAcademicYearId", currentAcademicYearId);
        map.put("cardinalTimeUnitStatusCode", OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT);
        List<Integer> spctuIds = studentManager.findStudyPlanCardinalTimeUnitIds(map);
        
        log.info(spctuIds.size() + " studyPlanCardinalTimeUnits in current academic year (id = " + currentAcademicYearId + ") with status 'waiting for payment' - studyPlanCardinalTimeUnit-IDs: " + spctuIds);
        
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
