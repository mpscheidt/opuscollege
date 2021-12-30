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
package org.uci.opus.finance.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.DiscountedFee;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.service.FinancialTransactionManagerInterface;
import org.uci.opus.finance.service.extpoint.FinanceServiceExtensions;

/**
 * @author R.Rusinkiewicz
 *
 */
public class BankInterfaceUtils {

    private static Logger log = LoggerFactory.getLogger(BankInterfaceUtils.class);

    @Autowired private FinanceServiceExtensions financeServiceExtensions;
    @Autowired private FinancialTransactionManagerInterface financialTransactionManager;  
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyMapper studyDao; 

    int currentAcademicYearId = 0;
    /* Type request */
    public static final int POST_TRANSACTION_TYPE_REQUEST = 1;
    public static final int QUERY_STATUS_TYPE_REQUEST = 2;
    public static final int REVERSE_TRANSACTION_TYPE_REQUEST = 3;

    public static final String POST_TRANSACTION_TYPE_REQUEST_MESSAGE = "POST"; 
    public static final String QUERY_STATUS_TYPE_REQUEST_MESSAGE = "QUERY";
    public static final String REVERSE_TRANSACTION_TYPE_REQUEST_MESSAGE = "REVERSE";

    /* Status */
    public static final int STATUS_OK = 0;
    public static final int STATUS_ERROR_INTERFACE = 1;
    public static final int STATUS_ERROR_OPUS = 2;
    public static final int STATUS_ERROR_IGNORED = 4;

    public static final String STATUS_OK_MESSAGE="SUCCESS";
    public static final String STATUS_ERROR_INTERFACE_MESSAGE="INTERFACE ERROR";
    public static final String STATUS_ERROR_OPUS_MESSAGE="OPUS ERROR";
    public static final String STATUS_ERROR_IGNORED_MESSAGE="IGNORED";

    /* Both FinancialRequest and FinancialTransaction error codes and messages*/
    public static final int NO_ERR = 0;
    public static final String NO_ERR_MESSAGE = "";
    public static final int ERR_GENERAL_FAILURE = 1;
    public static final String ERR_GENERAL_FAILURE_MESSAGE = "GENERAL FAILURE";

    /* FinancialRequest error codes and messages*/
    public static final int ERR_STUDENTID_INVALID = 2;
    public static final int ERR_TRANS_NOT_FOUND = 3;
    public static final int ERR_AMOUNT_INVALID = 5;
    public static final int ERR_UNPAREABLE_CSV_DATA = 7;
    public static final int ERR_MISSING_FIELDS = 8;
    public static final int ERR_DUPLICATE_REQUEST_ID = 9;
    public static final int ERR_MISSING_TRANID = 10;
    public static final int ERR_MISSING_REQUESTID = 11;
    public static final int ERR_INVALID_KEY = 12;


    public static final String ERR_STUDENTID_INVALID_MESSAGE = "INVALID STUDENTID";
    public static final String ERR_TRANS_NOT_FOUND_MESSAGE = "TRANSACTION NOT FOUND";
    public static final String ERR_AMOUNT_INVALID_MESSAGE = "INVALID AMOUNT";
    public static final String ERR_UNPAREABLE_CSV_DATA_MESSAGE = "UNPAREABLE CSV DATA";
    public static final String ERR_MISSING_FIELDS_MESSAGE = "MISSING FIELDS";
    public static final String ERR_DUPLICATE_REQUEST_ID_MESSAGE = "DUPLICATE REQUEST ID";
    public static final String ERR_MISSING_TRANID_MESSAGE = "TRANACTION ID MISSING";
    public static final String ERR_MISSING_REQUESTID_MESSAGE = "REQUEST ID MISSING";
    public static final String ERR_INVALID_KEY_MESSAGE = "INVALID KEY";

    /* FinancialTransaction error codes and messages*/
    public static final int ERR_STUDENT_NOT_EXIST = 4;
    public static final int ERR_STUDENT_NOT_REGISTERED = 6;
    public static final int ERR_MISSING_SFEES = 13;

    public static final String ERR_STUDENT_NOT_EXIST_MESSAGE = "STUDENT DOES NOT EXIST";
    public static final String ERR_STUDENT_NOT_REGISTERED_MESSAGE = "STUDENT NOT REGISTERED";
    public static final String ERR_MISSING_SFEES_MESSAGE = "MISSING STUDENT FEES";

    /* Xml response templates */
    public static final String POST_TRANSACTION_RESPONSE_XML_TEMPLATE = "<xml version = \"1.0\"?>"+
            "<PostTranResponse status=\"\" errorMessage=\"\">"+
            "<Transaction id=\"\" status=\"\""+
            " errorMessage=\"\"></Transaction>"+
            "</PostTranResponse>";
    public static final String QUERY_STATUS_RESPONSE_XML_TEMPLATE = "<xml version = \"1.0\"?>"+
            "<QueryStatusResponse status=\"\">"+
            "<Transaction id=\"\" status=\"\">"+
            " errorMessage=\"\"></Transaction>"+
            "</QueryStatusResponse>";
    public static final String REVERSE_TRANSACTION_RESPONSE_XML_TEMPLATE = "<xml version = \"1.0\"?>"+
            "<ReverseTransactionResponse status=\"\">"+
            "<Transaction id=\"\" status=\"\""+
            " errorMessage=\"\"></Transaction>"+
            " </ReverseTransactionResponse>";
    public BankInterfaceUtils(){

    }
    public BankInterfaceUtils(int currentAcademicYearId){
        this.currentAcademicYearId=currentAcademicYearId;
    }
    /**
     * Translates incoming errorCode into corresponding errorMessage
     * @param errorCode
     * @return errorMessage
     */
    public static String getErrorMessage(int errorCode){
        switch(errorCode) {
        case(NO_ERR): return NO_ERR_MESSAGE;
        case(ERR_GENERAL_FAILURE): return ERR_GENERAL_FAILURE_MESSAGE;
        case(ERR_STUDENTID_INVALID): return ERR_STUDENTID_INVALID_MESSAGE;
        case(ERR_TRANS_NOT_FOUND): return ERR_TRANS_NOT_FOUND_MESSAGE;
        case(ERR_AMOUNT_INVALID): return ERR_AMOUNT_INVALID_MESSAGE;
        case(ERR_UNPAREABLE_CSV_DATA): return ERR_UNPAREABLE_CSV_DATA_MESSAGE;
        case(ERR_MISSING_FIELDS): return ERR_MISSING_FIELDS_MESSAGE;
        case(ERR_DUPLICATE_REQUEST_ID): return ERR_DUPLICATE_REQUEST_ID_MESSAGE;
        case(ERR_MISSING_TRANID): return ERR_MISSING_TRANID_MESSAGE;
        case(ERR_MISSING_REQUESTID): return ERR_MISSING_REQUESTID_MESSAGE;
        case(ERR_INVALID_KEY): return ERR_INVALID_KEY_MESSAGE;
        case(ERR_STUDENT_NOT_EXIST): return ERR_STUDENT_NOT_EXIST_MESSAGE;
        case(ERR_STUDENT_NOT_REGISTERED): return ERR_STUDENT_NOT_REGISTERED_MESSAGE;
        case(ERR_MISSING_SFEES): return ERR_MISSING_SFEES_MESSAGE;          
        default: return NO_ERR_MESSAGE;
        }
    }
    /**
     * Translates incoming statusCode into corresponding statusMessage
     * @param statusCode
     * @return statusMessage
     */
    public static String getStatusMessage(int statusCode){
        switch(statusCode) {
        case(STATUS_OK): return STATUS_OK_MESSAGE;          
        case(STATUS_ERROR_INTERFACE): return STATUS_ERROR_INTERFACE_MESSAGE;
        case(STATUS_ERROR_OPUS): return STATUS_ERROR_OPUS_MESSAGE;
        case(STATUS_ERROR_IGNORED): return STATUS_ERROR_IGNORED_MESSAGE;
        default: return STATUS_OK_MESSAGE;
        }
    }
    /**
     * Translates incoming transactionTypId into coresponding typeMessage
     * @param transactionTypeId
     * @return typeMessage
     */
    public static String getTypeMessage(int transactionTypeId){
        switch(transactionTypeId) {
        case(POST_TRANSACTION_TYPE_REQUEST): return POST_TRANSACTION_TYPE_REQUEST_MESSAGE;          
        case(QUERY_STATUS_TYPE_REQUEST): return QUERY_STATUS_TYPE_REQUEST_MESSAGE;
        case(REVERSE_TRANSACTION_TYPE_REQUEST): return REVERSE_TRANSACTION_TYPE_REQUEST_MESSAGE;
        default: return "";
        }
    }
    /**
     * Finds nextInstallmentNumber for new Payment for corresponding Fee
     * @param studentPayments
     * @param studentBalances
     * @param feeId
     * @return nextInstallmentNumber 
     */
    public static int getNextPaymentInstallmentNumber(List<? extends Payment> studentPayments, List<? extends StudentBalance> studentBalances,int feeId){
        int nextPaymentInstallmentNumber = 0;
        for(StudentBalance studentBalance:studentBalances){
            if(studentBalance.getFeeId()==feeId){
                for(Payment payment:studentPayments){
                    if(payment.getFeeId()==feeId && payment.getStudentBalanceId()==studentBalance.getId()){
                        if(payment.getInstallmentNumber()>nextPaymentInstallmentNumber){
                            nextPaymentInstallmentNumber = payment.getInstallmentNumber();
                        }
                    }

                }
            }
        }
        return nextPaymentInstallmentNumber+1;
    }
    
    /**
     * This method process selected financialTransactions into the student Payments for the 
     * outstanding fees. The payments are sorted on their academicYearId so first the payments
     * for older outstanding fees are generated. The last payment (rest Payment) is being created
     * for the tuition fee for the academic year of the incoming transaction.
     * @param requestIds
     * @param writeWho
     */
    public void processToStudentBalance(String[] requestIds, String writeWho){

        FinancialTransaction financialTransaction = null;
        List<DiscountedFee> feesForSubjectStudyGradeTypes = null;
        List<DiscountedFee> feesForSubjectBlockStudyGradeTypes = null;
        List<DiscountedFee> feesForStudyGradeTypes = null;
        List<DiscountedFee> feesForAcademicYear = null;
        List<? extends Payment> paymentsForStudent = null;

        List<DiscountedFee> allStudentFeesNotYetPaidFully;// = new ArrayList<DiscountedFee>();
        List <StudentBalance> allStudentBalances;
        double alreadyPaid = 0.0; 
        double restPayment = 0.0;
        //        double previousRestPayment = 0.0;
        //        double newPaymentForFee = 0.0;
        //        Payment newPayment = null;
        String studentCode = null;
        Student student = null;
        for(String financialTransactionId: requestIds){
            //            feeNumber = 0;
            allStudentFeesNotYetPaidFully = new ArrayList<DiscountedFee>();
            financialTransaction = financialTransactionManager.findFinancialTransaction(financialTransactionId);
            restPayment = financialTransaction.getAmount().doubleValue();
            studentCode = financialTransaction.getStudentCode();
            student = studentManager.findStudentByCode(studentCode);
            // TODO: find the studyPlanCTuId of this student and get only the studentBalances belonging to that
            // see appliedFees
            // no order by in the query
            allStudentBalances = feeManager.findStudentBalances(student.getStudentId());
            // ordered by feeId, fee_payment.payDate, fee_payment.installmentNumber
            paymentsForStudent=paymentManager.findPaymentsForStudent(student.getStudentId());
            if(financialTransaction != null){
                currentAcademicYearId = financialTransaction.getAcademicYearId();
                feesForSubjectStudyGradeTypes=this.getStudentFeesForSubjectStudyGradeTypesWithDiscounts(student.getStudentId());
                feesForSubjectBlockStudyGradeTypes=this.getStudentFeesForSubjectBlockStudyGradeTypesWithDiscounts(student.getStudentId());
                feesForStudyGradeTypes=this.getStudentFeesForStudyGradeTypesWithDiscounts(student.getStudentId());
                feesForAcademicYear = this.getStudentFeesForAcademicYearsWithDiscounts(student.getStudentId());
                for(DiscountedFee discountedFee: feesForAcademicYear){
                    Fee fee = discountedFee.getFee();
                    for(StudentBalance studentBalance: allStudentBalances){
                        if(fee.getId()== studentBalance.getFeeId()){
                            for(Payment payment: paymentsForStudent){
                                if(payment.getStudentBalanceId()==studentBalance.getId()){
                                    alreadyPaid += payment.getSumPaid().doubleValue();
                                }
                            }
                            if(alreadyPaid < discountedFee.getDiscountedFeeDue() || (fee.getAcademicYearId() == currentAcademicYearId) && fee.getCategoryCode().equals("1") && fee.getStudyGradeTypeId()==0 && fee.getSubjectBlockStudyGradeTypeId()==0 && fee.getSubjectStudyGradeTypeId()==0){
                                allStudentFeesNotYetPaidFully.add(discountedFee);
                            }
                            alreadyPaid = 0.0;  
                        }
                    }
                }
                for(DiscountedFee discountedFee: feesForStudyGradeTypes){
                    for(StudentBalance studentBalance: allStudentBalances){
                        if(discountedFee.getFee().getId()== studentBalance.getFeeId()){
                            for(Payment payment: paymentsForStudent){
                                if(payment.getStudentBalanceId()==studentBalance.getId()){
                                    alreadyPaid += payment.getSumPaid().doubleValue();
                                }
                            }
                            if(alreadyPaid < discountedFee.getDiscountedFeeDue()){
                                //                                studyGradeType = studyManager.findStudyGradeType(studentFee.getStudyGradeTypeId());
                                //                                if(studyGradeType != null){
                                //                                    studentFee.setAcademicYearId(studyGradeType.getCurrentAcademicYearId());
                                //                                }
                                allStudentFeesNotYetPaidFully.add(discountedFee);
                            }
                            alreadyPaid = 0.0;  
                        }
                    }
                }       
                for(DiscountedFee discountedFee: feesForSubjectStudyGradeTypes){
                    for(StudentBalance studentBalance: allStudentBalances){
                        if(discountedFee.getFee().getId()== studentBalance.getFeeId()){
                            for(Payment payment: paymentsForStudent){
                                if(payment.getStudentBalanceId()==studentBalance.getId()){
                                    alreadyPaid += payment.getSumPaid().doubleValue();
                                }
                            }
                            if(alreadyPaid < discountedFee.getDiscountedFeeDue()){
                                //                                subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(preferredLanguage, studentFee.getSubjectStudyGradeTypeId());
                                //                                if(subjectStudyGradeType != null){
                                //                                    studyGradeType = studyManager.findStudyGradeType(subjectStudyGradeType.getStudyGradeTypeId());
                                //                                }
                                //                                if(studyGradeType != null){
                                //                                    studentFee.setAcademicYearId(studyGradeType.getCurrentAcademicYearId());
                                //                                }
                                allStudentFeesNotYetPaidFully.add(discountedFee);
                            }
                            alreadyPaid = 0.0;  
                        }
                    }
                }                       
                for(DiscountedFee discountedFee: feesForSubjectBlockStudyGradeTypes){
                    for(StudentBalance studentBalance: allStudentBalances){
                        if(discountedFee.getFee().getId()== studentBalance.getFeeId()){
                            for(Payment payment: paymentsForStudent){
                                if(payment.getStudentBalanceId()==studentBalance.getId()){
                                    alreadyPaid += payment.getSumPaid().doubleValue();
                                }
                            }
                            if(alreadyPaid < discountedFee.getDiscountedFeeDue()){
                                //                                subjectBlockStudyGradeType = subjectManager.findSubjectBlockStudyGradeType(preferredLanguage, discountedFee.getSubjectStudyGradeTypeId());
                                //                                if(subjectBlockStudyGradeType != null){
                                //                                    studyGradeType = subjectBlockStudyGradeType.getStudyGradeType();
                                //                                }
                                //                                if(studyGradeType != null){
                                //                                    discountedFee.setAcademicYearId(studyGradeType.getCurrentAcademicYearId());
                                //                                }
                                allStudentFeesNotYetPaidFully.add(discountedFee);
                            }
                            alreadyPaid = 0.0;  
                        }
                    }
                }

                makePayments(restPayment, paymentsForStudent, allStudentFeesNotYetPaidFully, allStudentBalances, writeWho);
                financialTransaction.setProcessedToStudentbalance("Y");
                financialTransactionManager.updateFinancialTransaction(financialTransaction);
            }
        }
    }

    /**
     * The discounts and scholarships will be deducted from the given fees (allStudentFeesNotYetPaidFully).
     * @param paymentAmount
     * @param paymentsForStudent
     * @param allStudentFeesNotYetPaidFully
     * @param allStudentBalances
     * @param writeWho
     */
    public void makePayments(double paymentAmount, List<? extends Payment> paymentsForStudent, List<DiscountedFee> allStudentFeesNotYetPaidFully,
            List<StudentBalance> allStudentBalances, String writeWho) {

        double previousRestPayment;
        double newPaymentForFee;
        Payment newPayment;
        int feeNumber = 0;
        IdToAcademicYearMap idToAcademicYearMap = new IdToAcademicYearMap(academicYearManager.findAllAcademicYears());
        if (log.isDebugEnabled()) {
	        for (DiscountedFee discFee : allStudentFeesNotYetPaidFully) {
	        	if (discFee.getFee() != null) {
	        		log.debug("fee in discounted Fee = " + discFee.getFee().getId());
	        	} else {
	        		log.debug("fee in discounted Fee = null");
	        	}
	        	if (discFee.getDiscountedFeeDue() != 0) {
	        		log.debug("DiscountedFeeDue in discounted Fee = " + discFee.getDiscountedFeeDue());
	        	} else {
	        		log.debug("DiscountedFeeDue in discounted Fee = 0");
	        	}
	        }
        }
        Collections.sort(allStudentFeesNotYetPaidFully,new FeesComparatorAscending(idToAcademicYearMap));
        outer:           for(DiscountedFee discountedFee: allStudentFeesNotYetPaidFully){
            feeNumber++;
            double alreadyPaid = 0.0;
            Fee fee = discountedFee.getFee();
            for(StudentBalance studentBalance: allStudentBalances){
                if(fee.getId()== studentBalance.getFeeId()){
                    for(Payment payment: paymentsForStudent){
                        if(payment.getStudentBalanceId()==studentBalance.getId() && payment.getFeeId() == fee.getId()){
                            alreadyPaid += payment.getSumPaid().doubleValue();
                        }
                    }
                    if(alreadyPaid < discountedFee.getDiscountedFeeDue() || feeNumber == allStudentFeesNotYetPaidFully.size()){
                        if(feeNumber == allStudentFeesNotYetPaidFully.size()){
                            newPaymentForFee = paymentAmount;
                            previousRestPayment = paymentAmount;
                            paymentAmount = 0.0;
                        }else{
                            if(paymentAmount > (discountedFee.getDiscountedFeeDue()-alreadyPaid)){
                                newPaymentForFee = discountedFee.getDiscountedFeeDue()-alreadyPaid;
                                previousRestPayment = paymentAmount;      
                                paymentAmount = paymentAmount - (discountedFee.getDiscountedFeeDue()-alreadyPaid);
                            }
                            else{
                                newPaymentForFee = paymentAmount;
                                previousRestPayment = paymentAmount;
                                paymentAmount = 0.0;
                            }
                        }
                        newPayment = new Payment();
                        newPayment.setFeeId(fee.getId());
                        newPayment.setStudentBalanceId(studentBalance.getId());
                        newPayment.setPayDate(new Date());
                        newPayment.setStudentId(studentBalance.getStudentId());
                        newPayment.setActive("Y");
                        newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
                        newPayment.setInstallmentNumber(getNextPaymentInstallmentNumber(paymentsForStudent,allStudentBalances,fee.getId()));
                        if(newPayment.getInstallmentNumber() > fee.getNumberOfInstallments()){
                            log.warn("BankInterfaceUtils.processToStudentBalance new payment intallment number bigger than fee installment number "+newPayment.getInstallmentNumber()+","+fee.getNumberOfInstallments());
                          //  paymentAmount = previousRestPayment;
                        }
                       // else{
                            newPayment.setWriteWho("unza");
                            paymentManager.addPayment(newPayment, writeWho);
                      //  }
                        if(paymentAmount == 0.0)
                            break outer;                                
                    }
                }
            }    
        }
    }

    /**
     * Calculates the new amount for study grade type fees based on the fees amount and entered corresponding discounts for these fees
     * @param studentId
     * @param preferredLanguage
     * @param request
     * @return studentFeesForStudyGradeTypes
     */
    public List<DiscountedFee> getStudentFeesForStudyGradeTypesWithDiscounts(int studentId) {

        List < ? extends Fee > allStudentFeesForStudyGradeTypes = feeManager.findStudentFeesForStudyGradeTypes(studentId);
        List<DiscountedFee> discountedFees = new ArrayList<DiscountedFee>();

        if (studentId != 0) {
            Student student = studentManager.findPlainStudent(studentId);
            for (Fee fee : allStudentFeesForStudyGradeTypes) {
                DiscountedFee discountedFee = getStudentFeeForStudyGradeTypesWithDiscounts(fee, student);
                discountedFees.add(discountedFee);
            }
        }
        return discountedFees;
    }

    /**
     * Apply the discounts and scholarships to the given fees for the given student.
     * @param fees
     * @param student
     * @return
     */
//    public List<AppliedFee> getDiscountedFees(List<AppliedFee> fees, Student student) {
//
//        List<AppliedFee> discountedFees = new ArrayList<AppliedFee>();
//
//        for (AppliedFee fee : fees) {
//        	AppliedFee discountedFee = getDiscountedFee(fee, student);
//            discountedFees.add(discountedFee);
//        }
//        return discountedFees;
//    }

//    public AppliedFee getDiscountedFee(AppliedFee fee, Student student) {
//    	AppliedFee discountedFee = null;
//        int discountPercentage = 0;
//        if (fee.getFee().getStudyGradeTypeId() != 0) {
//        	 discountPercentage += financeServiceExtensions.getDiscountPercentage(student, fee.getFee());
//        	 discountedFee = new AppliedFee(fee.getFee(), new BigDecimal(discountPercentage));
////            discountedFee = getStudentFeeForStudyGradeTypesWithDiscounts(fee, student);
//        } else if (fee.getFee().getAcademicYearId() != 0
//        		|| fee.getFee().getSubjectBlockId() != 0
//        		|| fee.getFee().getSubjectBlockStudyGradeTypeId() != 0) {
////            discountedFee = getStudentFeeForAcademicYearsWithDiscounts(fee, student);
//        	discountedFee = new AppliedFee(fee.getFee(), new BigDecimal(0));
////        } else if (fee.getFee().getSubjectBlockId() != 0) {
////            discountedFee = getStudentFeeForSubjectStudyGradeTypesDiscounts(fee, student);
////        } else if (fee.getFee().getSubjectBlockStudyGradeTypeId() != 0) {
////            discountedFee = getStudentFeeForSubjectBlockStudyGradeTypesDiscounts(fee, student);
//        } else {
//            log.warn("Data inconsistency: Fee with id " + fee.getFee().getId() + " is none of the possible types. Fee is ignored");
//        }
//        return discountedFee;
//    }

    public DiscountedFee getStudentFeeForStudyGradeTypesWithDiscounts(final Fee fee, final Student student) {

        int discountPercentage = 0;
//        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
//        StudyGradeType studyGradeType = null;
//        boolean foundLocalStudentDiscount = false;

        /* tuitionWaiverDiscountPercentage */    
//        for (StudentBalance studentBalance : feeManager.findStudentBalancesByFeeId(fee.getId())) {
//            if (studentBalance.getStudyPlanCardinalTimeUnitId() != 0) {
//                studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studentBalance.getStudyPlanCardinalTimeUnitId());
//                if(studyPlanCardinalTimeUnit != null && "Y".equals(studyPlanCardinalTimeUnit.getTuitionWaiver())){
//                    discountPercentage += fee.getTuitionWaiverDiscountPercentage();
//                }
//            }
//        }

        /*fulltimeStudentDiscountPercentage */
        //      for(int i=0; i <allStudentFeesForStudyGradeTypes.size();i++){
    //    studyGradeType = studyManager.findStudyGradeType(fee.getStudyGradeTypeId());
//        if("F".equals(studyGradeType.getStudyIntensityCode())){
//            discountPercentage += fee.getFulltimeStudentDiscountPercentage();
//        }
//
//        /*localStudentDiscountPercentage */
//        if("SATC".equals(student.getNationalityGroupCode())){
//            foundLocalStudentDiscount = true;
//        }
//
//        if("N".equals(student.getForeignStudent())){
//            foundLocalStudentDiscount = true;
//        }
//        if(foundLocalStudentDiscount) {
//            discountPercentage += fee.getLocalStudentDiscountPercentage();
//        }

        /* continuedRegistrationDiscountPercentage */
//        for (StudentBalance studentBalance : feeManager.findStudentBalancesByFeeId(fee.getId())) {
//            if (studentBalance.getStudyPlanCardinalTimeUnitId() != 0) {
//                studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studentBalance.getStudyPlanCardinalTimeUnitId());
//                if(studyPlanCardinalTimeUnit != null && studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber()>1){
//                    discountPercentage += fee.getContinuedRegistrationDiscountPercentage();
//                }
//            }
//        }

        /* postgraduateDiscountPercentage */
    //    Lookup gradeType = studyManager.findGradeTypeByStudyGradeTypeId(fee.getStudyGradeTypeId(), "en");
        // TODO there should be a better way to decide if this is a master
//        if(gradeType != null){
//            if(gradeType.getDescription().startsWith("Master")){
//                discountPercentage += fee.getPostgraduateDiscountPercentage();
//            }
//        }

        discountPercentage += financeServiceExtensions.getDiscountPercentage(student, fee);
        DiscountedFee discountedFee = new DiscountedFee(fee, discountPercentage);
        return discountedFee;
    }

//    public DiscountedFee getStudentFeeForAcademicYearsWithDiscounts(final Fee fee, final Student student) {
//
//        int discountPercentage = 0;
//   //     boolean foundLocalStudentDiscount = false;
//
//        /* tuitionWaiverDiscountPercentage */    
//        /*fulltimeStudentDiscountPercentage */
//        /*localStudentDiscountPercentage */
////        if("SATC".equals(student.getNationalityGroupCode())){
////            foundLocalStudentDiscount = true;
////        }
////        if("N".equals(student.getForeignStudent())){
////            foundLocalStudentDiscount = true;
////        }
////        if(foundLocalStudentDiscount){
////            discountPercentage += fee.getLocalStudentDiscountPercentage();
////        }
//        /* continuedRegistrationDiscountPercentage */
//
//        /* postgraduateDiscountPercentage */
//
//        DiscountedFee discountedFee = new DiscountedFee(fee, discountPercentage);
//        return discountedFee;
//    }

    /**
     * Get all academic years fees. For all fee values the applicable discounts are subtracted.
     * @param studentId
     * @param preferredLanguage
     * @param request
     * @return studentFeesForAcademicYears
     */
    public List<DiscountedFee> getStudentFeesForAcademicYearsWithDiscounts(int studentId){

        List<DiscountedFee> discountedFees = new ArrayList<DiscountedFee>();
        List < ? extends Fee > allStudentFeesForAcademicYears = feeManager.findStudentFeesForAcademicYears(studentId);

        if (studentId != 0) {
//            Student student = studentManager.findPlainStudent(studentId);

            for (Fee fee : allStudentFeesForAcademicYears) {
//                DiscountedFee discountedFee = getStudentFeeForAcademicYearsWithDiscounts(fee, student);
            	DiscountedFee discountedFee = new DiscountedFee(fee, 0);
                discountedFees.add(discountedFee);
            }
        }    
        return discountedFees;
    }

//    public DiscountedFee getStudentFeeForSubjectStudyGradeTypesDiscounts(final Fee fee, final Student student) {
//        int discountPercentage = 0;
//
////        StudyGradeType studyGradeType = null;
////        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
////        StudyPlanDetail studyPlanDetail = null;
////        Lookup gradeType = null;
////        boolean foundLocalStudentDiscount = false;
////
////        /* tuitionWaiverDiscountPercentage */
////        SubjectStudyGradeType subjectStudyGradeType = subjectDao.findPlainSubjectStudyGradeType(fee.getSubjectStudyGradeTypeId());
////        List<StudentBalance> studentBalances = feeManager.findStudentBalancesByFeeId(fee.getId());
////        for (StudentBalance studentBalance : studentBalances) {
////            studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
////            if (studyPlanDetail != null) {
////                studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(studyPlanDetail.getStudyPlanId(), fee.getStudyGradeTypeId(),
////                        subjectStudyGradeType.getCardinalTimeUnitNumber());
////                if ("Y".equals(studyPlanCardinalTimeUnit.getTuitionWaiver())) {
////                    discountPercentage += fee.getTuitionWaiverDiscountPercentage();
////                }
////            }
////        }
//
//        /* fulltimeStudentDiscountPercentage */
////        studyGradeType = studyManager.findStudyGradeType(fee.getStudyGradeTypeId());
////        if ("F".equals(studyGradeType.getStudyIntensityCode())) {
////            discountPercentage += fee.getFulltimeStudentDiscountPercentage();
////        }
////
////        /* localStudentDiscountPercentage */
////        if ("SATC".equals(student.getNationalityGroupCode())) {
////            foundLocalStudentDiscount = true;
////        }
////        if ("N".equals(student.getForeignStudent())) {
////            foundLocalStudentDiscount = true;
////        }
////        if (foundLocalStudentDiscount) {
////            discountPercentage += fee.getLocalStudentDiscountPercentage();
////        }
////        /* continuedRegistrationDiscountPercentage */
////        if (subjectStudyGradeType.getCardinalTimeUnitNumber() > 1) {
////            discountPercentage += fee.getContinuedRegistrationDiscountPercentage();
////        }
////
////        /* postgraduateDiscountPercentage */
////        gradeType = studyManager.findGradeTypeByStudyGradeTypeId(fee.getStudyGradeTypeId(), "en");
////        // TODO there should be a better way to decide if this is a master
////        if (gradeType != null) {
////            if (gradeType.getDescription().startsWith("Master")) {
////                discountPercentage += fee.getPostgraduateDiscountPercentage();
////            }
////        }
//
//        // calculate the discounted feeDue
//        DiscountedFee discountedFee = new DiscountedFee(fee, discountPercentage);
//        return discountedFee;
//    }

    /**
     * Calculates the new amount for subject study grade type fees based on the fees amount and entered corresponding discounts for these fees
     * @param studentId
     * @return studentFeesForSubjectStudyGradeTypes
     */
    public List<DiscountedFee> getStudentFeesForSubjectStudyGradeTypesWithDiscounts(int studentId){

        List<DiscountedFee> discountedFees = new ArrayList<DiscountedFee>();
        List < ? extends Fee > allStudentFeesForSubjectStudyGradeTypes = feeManager.findStudentFeesForSubjectStudyGradeTypes(studentId);

        if (studentId != 0) {
//            Student student = studentManager.findPlainStudent(studentId);

            for (Fee fee : allStudentFeesForSubjectStudyGradeTypes) {
//                DiscountedFee discountedFee = getStudentFeeForAcademicYearsWithDiscounts(fee, student);
            	DiscountedFee discountedFee = new DiscountedFee(fee, 0);
                discountedFees.add(discountedFee);
            }

        }    
        return discountedFees;
    }

//    public DiscountedFee getStudentFeeForSubjectBlockStudyGradeTypesDiscounts(final Fee fee, final Student student) {
//
////        StudyGradeType studyGradeType = null;
////        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
////        StudyPlanDetail studyPlanDetail = null;
////        Lookup gradeType = null;
//
//        int discountPercentage = 0;
////        boolean foundLocalStudentDiscount = false;
//
//        /* tuitionWaiverDiscountPercentage */
////        SubjectBlockStudyGradeType subjectBlockStudyGradeType = subjectDao.findPlainSubjectBlockStudyGradeType(fee.getSubjectBlockStudyGradeTypeId());
////        for (StudentBalance studentBalance : feeManager.findStudentBalancesByFeeId(fee.getId())) {
////            studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
////            if (studyPlanDetail != null) {
////                studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnitByParams(studyPlanDetail.getStudyPlanId(), fee.getStudyGradeTypeId(),
////                        subjectBlockStudyGradeType.getCardinalTimeUnitNumber());
////                if ("Y".equals(studyPlanCardinalTimeUnit.getTuitionWaiver())) {
////                    discountPercentage += fee.getTuitionWaiverDiscountPercentage();
////                }
////            }
////        }
////
////        /* fulltimeStudentDiscountPercentage */
////        studyGradeType = studyManager.findStudyGradeType(fee.getStudyGradeTypeId());
////        if ("F".equals(studyGradeType.getStudyIntensityCode())) {
////            discountPercentage += fee.getFulltimeStudentDiscountPercentage();
////        }
////
////        /* localStudentDiscountPercentage */
////        if ("SATC".equals(student.getNationalityGroupCode())) {
////            foundLocalStudentDiscount = true;
////        }
////        if ("N".equals(student.getForeignStudent())) {
////            foundLocalStudentDiscount = true;
////        }
////        if (foundLocalStudentDiscount) {
////            discountPercentage += fee.getLocalStudentDiscountPercentage();
////        }
////
////        // continuedRegistrationDiscountPercentage
////        discountPercentage += fee.getContinuedRegistrationDiscountPercentage();
////
////        // postgraduateDiscountPercentage
////        gradeType = studyManager.findGradeTypeByStudyGradeTypeId(fee.getStudyGradeTypeId(), "en");
////
////        // TODO there should be a better way to decide if this is a master
////        if (gradeType != null) {
////            if (gradeType.getDescription().startsWith("Master")) {
////                discountPercentage += fee.getPostgraduateDiscountPercentage();
////            }
////        }
//
//        DiscountedFee discountedFee = new DiscountedFee(fee, discountPercentage);
//        return discountedFee;
//    }

    /**
     * Calculates the new amount for subject block study grade type fees based on the fees amount and entered corresponding discounts for these fees
     * @param studentId
     * @param preferredLanguage
     * @return studentFeesForSubjectBlockStudyGradeTypes
     */
    public List<DiscountedFee> getStudentFeesForSubjectBlockStudyGradeTypesWithDiscounts(int studentId){

        List<DiscountedFee> discountedFees = new ArrayList<DiscountedFee>();
        List < ? extends Fee > allStudentFeesForSubjectBlockStudyGradeTypes = feeManager.findStudentFeesForSubjectBlockStudyGradeTypes(studentId);

        if (studentId != 0) {
            Student student = studentManager.findPlainStudent(studentId);

            for (Fee fee : allStudentFeesForSubjectBlockStudyGradeTypes) {
//                DiscountedFee discountedFee = getStudentFeeForSubjectBlockStudyGradeTypesDiscounts(fee, student);
            	DiscountedFee discountedFee = new DiscountedFee(fee, 0);
                discountedFees.add(discountedFee);
            }

        }    
        return discountedFees;
    }
    /**
     * Retrieves the list of financialTransaction which are associated to the tuition fee, and in case it is paid less than 75 procent
     * @param financialTransactions
     * @param request
     * @return the list of financialTransaction that meet criteria
     */
    public List<FinancialTransaction> getTuitionFee75PercentPaid(List<FinancialTransaction> financialTransactions,HttpServletRequest request){
        int studentId = 0;
        String studentCode = null;
        Student student = null;
        List<StudentBalance>allStudentBalances = null;
        List<Payment> paymentsForStudent = null;
        List<DiscountedFee> allStudentFeesToPay = new ArrayList<DiscountedFee>();
        List<FinancialTransaction> resultFinancialTransactions = new ArrayList<FinancialTransaction>();
        List<DiscountedFee> feesForSubjectStudyGradeTypes = null;
        List<DiscountedFee> feesForSubjectBlockStudyGradeTypes = null;
        List<DiscountedFee> feesForStudyGradeTypes = null;
        List<DiscountedFee> feesForAcademicYear = null;
        DiscountedFee tuitionFee = null;// = new Fee();
        double alreadyPaid = 0.0;
        double tuitionFeeValue = 0.0;
        IdToAcademicYearMap idToAcademicYearMap = new IdToAcademicYearMap(academicYearManager.findAllAcademicYears());
        FeesComparatorAscending comparator = new FeesComparatorAscending(idToAcademicYearMap);
        for(FinancialTransaction financialTransaction:financialTransactions){
            alreadyPaid = 0.0;
            allStudentFeesToPay = new ArrayList<DiscountedFee>();
            if(financialTransaction.getStatusCode()==BankInterfaceUtils.STATUS_ERROR_IGNORED){
                continue;
            }
            studentCode = financialTransaction.getStudentCode();
            if(studentCode != null){
                student = studentManager.findStudentByCode(studentCode);
            }
            if(student != null){
                studentId = student.getStudentId();
            }
            feesForSubjectStudyGradeTypes=getStudentFeesForSubjectStudyGradeTypesWithDiscounts(studentId);
            feesForSubjectBlockStudyGradeTypes=getStudentFeesForSubjectBlockStudyGradeTypesWithDiscounts(studentId);
            feesForStudyGradeTypes=getStudentFeesForStudyGradeTypesWithDiscounts(studentId);
            feesForAcademicYear = getStudentFeesForAcademicYearsWithDiscounts(studentId);
            for(DiscountedFee fee:feesForSubjectStudyGradeTypes){
                allStudentFeesToPay.add(fee);
            }
            for(DiscountedFee fee:feesForSubjectBlockStudyGradeTypes){
                allStudentFeesToPay.add(fee);
            }
            for(DiscountedFee fee:feesForStudyGradeTypes){
                allStudentFeesToPay.add(fee);
            }
            for(DiscountedFee fee:feesForAcademicYear){
                allStudentFeesToPay.add(fee);
            }
            financialTransaction = financialTransactionManager.findFinancialTransaction(financialTransaction.getFinancialRequestId());

            allStudentBalances = feeManager.findStudentBalances(studentId);
            paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);

            Collections.sort(allStudentFeesToPay,comparator);
            for(DiscountedFee fee:allStudentFeesToPay){
                if (fee.getFee().getCategoryCode().equals("1")) {
                    tuitionFee = fee;
                }
            }
            for(StudentBalance studentBalance: allStudentBalances){
                if(tuitionFee != null && tuitionFee.getFee().getId()== studentBalance.getFeeId()){
                    for(Payment payment: paymentsForStudent){
                        if(payment.getStudentBalanceId()==studentBalance.getId()){
                            alreadyPaid += payment.getSumPaid().doubleValue();
                        }
                    }
                }
            }
            tuitionFeeValue=(tuitionFee.getDiscountedFeeDue());
            if(alreadyPaid < 0.75 * tuitionFeeValue) {
                resultFinancialTransactions.add(financialTransaction);
            }
        }
        return resultFinancialTransactions;
    }

    /**
     * Sort Payments based on academicYear. There are two exceptiona: the balanceBroughtForward
     * must be at the top of the list and the Tuition Fee for the incoming
     * academic Year must be at the bottom of the list. 
     */
    public class FeesComparatorAscending implements Comparator<DiscountedFee> {

        private IdToAcademicYearMap idToAcademicYearMap;

        public FeesComparatorAscending(IdToAcademicYearMap idToAcademicYearMap) {
            this.idToAcademicYearMap = idToAcademicYearMap;
        }

        public int compare(DiscountedFee discountedFee1, DiscountedFee discountedFee2) {

            // find the academic year of the fee
            Fee fee1 = discountedFee1.getFee();
            if (log.isDebugEnabled()) {
	            if (discountedFee2 != null) {
	                log.debug("discountedFee2 is not null");
	                if (discountedFee2.getFee() != null ) {
	                    log.debug("discountedFee2 .getFee() is not null");
	                } else {
	                    log.debug("discountedFee2.getFee() is NULL");
	                }
	            } else {
	                log.debug("discountedFee2 is NULL");
	            }
            }
            Fee fee2 = discountedFee2.getFee();
            int academicYearId1 = determineAcadmicYearId(fee1);
            int academicYearId2 = determineAcadmicYearId(fee2);
            AcademicYear academicYear1 = idToAcademicYearMap.get(academicYearId1);
            AcademicYear academicYear2 = idToAcademicYearMap.get(academicYearId2);

            int result = academicYear1.getDescription().compareTo(academicYear2.getDescription());

            if (result == 0) {
                // the two academic years are equal -> at the put tuition fee (category 1) to the bottom of the list
                result = fee1.getCategoryCode().compareTo(fee2.getCategoryCode());
                if (result != 0) {
                    /* the balancBroughtFwd fee must be paid first so must be brought to the top
                     of the list. So, regardless of the actual value of the feeId, it is considered 
                     to be smaller than the other feeId */
                    if ((FeeConstants.BALANCE_BROUGHT_FORWARD_CAT).equals(fee1.getCategoryCode())) {
                        result = -1;
                    } else if ((FeeConstants.BALANCE_BROUGHT_FORWARD_CAT).equals(fee2.getCategoryCode())) {
                        result = 1;
                    }
                    /* the tuition fee must be paid last so must be brought to the bottom
                    of the list. So, regardless of the actual value of the feeId, it is considered 
                    to be bigger than the other feeId */
                    if ("1".equals(fee1.getCategoryCode())) {
                        result = 1;
                    } else if ("1".equals(fee2.getCategoryCode())) {
                        result = -1;
                    }
                }
            }

            return result;
        }
    }
    
    public int determineAcadmicYearId(Fee fee) {
        int academicYearId;

        if (fee.getAcademicYearId() != 0) {
            academicYearId = fee.getAcademicYearId();
        } else if (fee.getStudyGradeTypeId() != 0) {
            academicYearId = studyDao.findAcademicYearIdForStudyGradeTypeId(fee.getStudyGradeTypeId());
        } else if (fee.getSubjectStudyGradeTypeId() != 0) {
            academicYearId = studyDao.findAcademicYearIdForSubjectStudyGradeTypeId(fee.getSubjectStudyGradeTypeId());
        } else if (fee.getSubjectBlockStudyGradeTypeId() != 0) {
            academicYearId = studyDao.findAcademicYearIdForSubjectBlockStudyGradeTypeId(fee.getSubjectBlockStudyGradeTypeId());
        } else {
            throw new RuntimeException("Fee is inconsistent - This should never happen");
        }

        return academicYearId;
    }

}
