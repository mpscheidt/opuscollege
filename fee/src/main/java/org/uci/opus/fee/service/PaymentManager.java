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
 * The Original Code is Opus-College fee module code.
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
package org.uci.opus.fee.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.persistence.PaymentMapper;

/**
 * @author move
 *
 */
public class PaymentManager implements PaymentManagerInterface {

    private static Logger log = LoggerFactory.getLogger(PaymentManager.class);

    @Autowired private PaymentMapper paymentMapper;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudentBalanceEvaluation studentBalanceEvaluation;

    @Override
    public List<Payment> findPaymentsForStudent(final int studentId) {
        return paymentMapper.findPaymentsForStudent(studentId);
    }

    @Override
    public Payment findPayment(final int paymentId) {
        return paymentMapper.findPayment(paymentId);
    }

    @Override
    public Payment findPaymentByParams(final Map<String, Object> map) {
        return paymentMapper.findPaymentByParams(map);
    }

    @Override
    public List<Payment> findPaymentsByParams(Map<String, Object> map) {
        return paymentMapper.findPaymentsByParams(map);
    }

    @Override
    @Transactional
    public void addPayment(final Payment payment, String writeWho) {
        payment.setWriteWho(writeWho);
    	paymentMapper.addPayment(payment);
        paymentMapper.addPaymentHistory(payment);
    	updateStudyPlanCtuStatus(payment, writeWho);
    }

    @Override
    @Transactional
    public void updatePayment(final Payment payment, String writeWho) {
        payment.setWriteWho(writeWho);
        paymentMapper.updatePayment(payment);
        paymentMapper.updatePaymentHistory(payment);
        updateStudyPlanCtuStatus(payment, writeWho);
    }
    
    @Override
    @Transactional
    public void deletePayment(final int paymentId, String writeWho) {
        
    	Payment payment = findPayment(paymentId);
    	payment.setWriteWho(writeWho);

    	paymentMapper.deletePayment(paymentId);
        paymentMapper.deletePaymentHistory(payment);
        
        updateStudyPlanCtuStatus(payment, writeWho);
    }
    
    @Override
    @Transactional
    public void deletePaymentsForStudentBalance(int studentBalanceId, String writeWho) {
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("studentBalanceId", studentBalanceId);
        for (Payment payment : paymentMapper.findPaymentsByParams(map)) {
            deletePayment(payment.getId(), writeWho);
        }

    }

    /**
     * Update studyplancardinaltimeunit status according to the fees paid
     * @param payment
     * @param writeWho
     */
    private void updateStudyPlanCtuStatus(Payment payment, String writeWho){

    	/*
    	int studyGradeTypeId = 0;
    	int subjectBlockStudyGradeTypeId = 0; 
  	  	int subjectStudyGradeTypeId = 0;
  	  	int academicYearId = 0;
  	  	int studyPlanId = 0;
        */

//    	Fee fee = feeDao.findFee(payment.getFeeId());
//        Student student = studentDao.findStudentById(studentId);
        
        StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(payment.getStudyPlanDetailId());
        int studyPlanId = studyPlanDetail.getStudyPlanId();

        if (studentBalanceEvaluation.hasMadeSufficientPaymentsForAdmission(studyPlanId)) {
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);

            studyPlan.setStudyPlanStatusCode(OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION);
            studyPlan.setWriteWho(writeWho);

            studentManager.updateStudyPlan(studyPlan, writeWho);
        }

        int studentId = payment.getStudentId();
        
        StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluation.getStudentBalanceInformation(studentId);
        if(studentBalanceEvaluation.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation))
        {

    		//update status of cardinal time units for this study plan
    		Map<String, Object> findTimeUnitsMap = new HashMap<String, Object>();
            
            findTimeUnitsMap.put("studyPlanId", studyPlanId);
        	findTimeUnitsMap.put("cardinalTimeUnitStatusCode", OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT);
    		
    		List<? extends StudyPlanCardinalTimeUnit> timeUnits = studentManager.findStudyPlanCardinalTimeUnitsByParams(findTimeUnitsMap);
    		
    		for(StudyPlanCardinalTimeUnit timeUnit: timeUnits) {
    			timeUnit.setCardinalTimeUnitStatusCode(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME);
    			timeUnit.setWriteWho(payment.getWriteWho());
    			
    			studentManager.updateStudyPlanCardinalTimeUnit(timeUnit);
    		}
        		
        } 

    	
    }

	public StudentBalanceEvaluation getStudentBalanceEvaluation() {
		return studentBalanceEvaluation;
	}

	public void setStudentBalanceEvaluation(
			StudentBalanceEvaluation studentBalanceEvaluation) {
		this.studentBalanceEvaluation = studentBalanceEvaluation;
	}

}
