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
package org.uci.opus.unza.service.extension;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManager;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.finance.util.BankInterfaceUtils;

/* Evaluation of studentbalance per student for UNZA:
 * If a student has a negative or zero balance, the boolean is set to true
 * If a student has a positive balance, the business rules will be applied:
 * Business rules balance for progression:
 * - if a student is on 100 % GRZ sponsorship, their balance must be zero
 * - if a student is on 75 %, 50 % or 25 % sponsorship, they should have paid at least 75 % of their fees. Any carried forward balance above this threshold will result in not being cleared to register; the system will automatically bar them
 * - if a student is on self or private sponsorship, they should have paid 50 % of the current invoices. Any carried forward balance above this threshold will result in not being cleared to register; the system will automatically bar them. 
 */

public class StudentBalanceEvaluationForUNZA implements StudentBalanceEvaluation {

    @Autowired private StudentManagerInterface studentManager;
    @Autowired private BankInterfaceUtils bankInterfaceUtils;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private FeeManagerInterface feeManager;

    private static Logger log = Logger.getLogger(StudentBalanceEvaluationForUNZA.class);

    @Override
    public StudentBalanceInformation getStudentBalanceInformation(int studentId) {
        return null;
    }

    @Override
    public boolean hasMadeSufficientPaymentsForRegistration(StudentBalanceInformation studentBalanceInformation) {
        return false;
    }

    @Override
    public boolean hasMadeSufficientPaymentsForAdmission(int studyPlanId) {
        return false;
    }

    
/*    @Override
    public BigDecimal getCurrentStudentBalance(int studentId) {
//        List<Map<String,Object>> result = null;
        BigDecimal totalFeesAmount = BigDecimal.ZERO;
        BigDecimal totalPaid = BigDecimal.ZERO;
 
        List <DiscountedFee> allDiscountedFees = new ArrayList<DiscountedFee>();
//        Student student = studentManager.findStudentByCode(studentCode);
        List <Payment> paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);
        List <DiscountedFee> feesForSubjectStudyGradeTypes=bankInterfaceUtils.getStudentFeesForSubjectStudyGradeTypesWithDiscounts(studentId);
        List <DiscountedFee> feesForSubjectBlockStudyGradeTypes=bankInterfaceUtils.getStudentFeesForSubjectBlockStudyGradeTypesWithDiscounts(studentId);
        List <DiscountedFee> feesForStudyGradeTypes=bankInterfaceUtils.getStudentFeesForStudyGradeTypesWithDiscounts(studentId);
        List <DiscountedFee> feesForAcademicYear = bankInterfaceUtils.getStudentFeesForAcademicYearsWithDiscounts(studentId);       
        List <? extends StudentBalance> studentBalances = feeManager.findStudentBalances(studentId);
        for(DiscountedFee fee: feesForSubjectStudyGradeTypes){
        	allDiscountedFees.add(fee);
            totalFeesAmount = totalFeesAmount.add(BigDecimal.valueOf(fee.getDiscountedFeeDue()));
        }
        for(DiscountedFee fee: feesForSubjectBlockStudyGradeTypes){
        	allDiscountedFees.add(fee);
            totalFeesAmount = totalFeesAmount.add(BigDecimal.valueOf(fee.getDiscountedFeeDue()));
        }
        for(DiscountedFee fee: feesForStudyGradeTypes){
        	allDiscountedFees.add(fee);
            totalFeesAmount = totalFeesAmount.add(BigDecimal.valueOf(fee.getDiscountedFeeDue()));
        }
        for(DiscountedFee fee: feesForAcademicYear){
        	allDiscountedFees.add(fee);
            totalFeesAmount = totalFeesAmount.add(BigDecimal.valueOf(fee.getDiscountedFeeDue()));
        }

//        for (int i = 0; i < result.size(); i++) {
//            balance = Double.parseDouble((String) result.get(i).get("Expr1"));
//            if (log.isDebugEnabled()) {
//                log.debug("StudentBalanceEvaluationForCBU: balance = " + balance);
//            }
//        }
        for(Payment payment: paymentsForStudent){
        	for(StudentBalance studentBalance : studentBalances ){
        		if(payment.getStudentBalanceId()==studentBalance.getId()){
        			totalPaid = totalPaid.add(payment.getSumPaid());
        		}
        	}
        }
        BigDecimal balance = totalFeesAmount.subtract(totalPaid);
        return balance;
    }*/

/*    public boolean hasMadeSufficientPayments(int studentId) {
        if (log.isDebugEnabled()) {
            log.debug("StudentBalanceEvaluationForUNZA.studentBalanceMeetsScholarshipRules entered");
        }
        
        boolean studentBalanceMeetsScholarshipRules = true;
        String scholarshipInfo = null;
//        String sponsorName = null;
        String sponsorshipPercentage = null;
        double amount = 0.0;

        // do the evaluation:

        // TODO - 1. evaluate sponsor info
        // sponsorName + sponsorshipPercentage
       
        if (log.isDebugEnabled()) {
            log.debug("StudentBalanceEvaluationForUNZA: scholarshipInfo = " + scholarshipInfo);
        }


        // BRs:
        // 100 %: balance must be zero or negative
        // If this method will be used, must request parameter be passed to isStudentBalanceNegative
        if ("100".equals(sponsorshipPercentage)) {
            if (this.hasPaidAllFees(studentId)) {
                studentBalanceMeetsScholarshipRules = true;
            } else {
                studentBalanceMeetsScholarshipRules = false;
            }
            return studentBalanceMeetsScholarshipRules;
        }
        
        // TODO - 2. retrieve fees imposed from studentBalance

        BigDecimal balance = getCurrentStudentBalance(studentId);

//        Student student = null;
        //student = studentManager.findStudentByCode(studentCode);
//        List <StudentBalance> studentBalances = student.getStudentBalances();

        // TODO: count up all studentbalancerecords for the current academic year:
        // academicyearfees, studyplancardinaltimeunitfees, subject(block)fees
        
        // Evaluate with the found information:
        
        // 75 %, 50 %, 25 5 : 75 % must be paid
        if ("75".equals(sponsorshipPercentage) 
            || "50".equals(sponsorshipPercentage) 
                || "25".equals(sponsorshipPercentage)) {
            if (balance.doubleValue() <= (amount * 0.75)) {
                studentBalanceMeetsScholarshipRules = true;
            } else {
                studentBalanceMeetsScholarshipRules = false;
            }
            return studentBalanceMeetsScholarshipRules;
        }
        
        // PRIVATE SPONSORSHIP: 50 % must be paid
        if (sponsorshipPercentage == null) {
            if (balance.doubleValue() <= (amount * 0.50)) {
                studentBalanceMeetsScholarshipRules = true;
            } else {
                studentBalanceMeetsScholarshipRules = false;
            }
            return studentBalanceMeetsScholarshipRules;
            
        }
        return studentBalanceMeetsScholarshipRules;
    }*/


    
}
