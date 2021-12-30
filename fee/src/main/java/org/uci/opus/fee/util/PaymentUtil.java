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

package org.uci.opus.fee.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.finance.util.BankInterfaceUtils;

public class PaymentUtil {

    @Autowired private StudentManagerInterface studentManager; 
    @Autowired private SubjectManagerInterface subjectManager;  

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

	public static HashMap<String,List<Payment>> createPaymentsToPayAllForStudyGradeType(List < ? extends Fee >allStudentFeesForStudyGradeTypes,List < ? extends Payment >allPaymentsForStudent,List < ? extends StudentBalance >allStudentBalances,int studyGradeTypeId){
		
		List < Payment > paymentsToPayAllForStudyGradeType = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsToPayAllForStudyGradeType = new ArrayList<Payment >();
		HashMap<String,List<Payment>> allPaymentsToPayForStudyGradeType = new HashMap<String,List<Payment>>();
		Payment newPayment = null;
		double newPaymentForFee = 0.0;
		for(Fee fee: allStudentFeesForStudyGradeTypes){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsToPayAllForStudyGradeType.add(newPayment);
//							}
//							else{
								paymentsToPayAllForStudyGradeType.add(newPayment);
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForStudyGradeType.put("approevedPayments", paymentsToPayAllForStudyGradeType);
		allPaymentsToPayForStudyGradeType.put("rejectedPayments", rejectedPaymentsToPayAllForStudyGradeType);
		return allPaymentsToPayForStudyGradeType;
	}
	public static HashMap<String,List<Payment>> createPaymentsToPayAllForAcademicYear(List < ? extends Fee >allStudentFeesForStudyGradeTypes,List < ? extends Payment >allPaymentsForStudent,List < ? extends StudentBalance >allStudentBalances,int academicYearId){
		
		List < Payment > paymentsToPayAllForStudyGradeType = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsToPayAllForStudyGradeType = new ArrayList<Payment >();
		HashMap<String,List<Payment>> allPaymentsToPayForStudyGradeType = new HashMap<String,List<Payment>>();
		Payment newPayment = null;
		double newPaymentForFee = 0.0;
		for(Fee fee: allStudentFeesForStudyGradeTypes){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getAcademicYearId()==academicYearId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsToPayAllForStudyGradeType.add(newPayment);
//							}
//							else{
								paymentsToPayAllForStudyGradeType.add(newPayment);
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForStudyGradeType.put("approevedPayments", paymentsToPayAllForStudyGradeType);
		allPaymentsToPayForStudyGradeType.put("rejectedPayments", rejectedPaymentsToPayAllForStudyGradeType);
		return allPaymentsToPayForStudyGradeType;
	}	
	public static HashMap<String,List<Payment>> createAcademicYearSurplusPaymentsForNextCardinalUnit(List < ? extends Fee >studentFeesToLoad,List < ? extends Payment >allPaymentsForStudent,List < ? extends StudentBalance >allStudentBalances,List <AcademicYear>allAcademicYears,int academicYearId){
		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
	//	List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		double newPaymentForFee = 0.0;
        int nextAcademicYearId = 0;
        String categoryCode = null;
        boolean nextYearFeeFound = false;
        for(AcademicYear year:allAcademicYears){
        	if(year.getId()==academicYearId){
        		nextAcademicYearId = year.getNextAcademicYearId();
        	}
        }
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			categoryCode = fee.getCategoryCode();
			if(fee.getAcademicYearId()==academicYearId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee<0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextYearFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
								for(Fee fee2: studentFeesToLoad){
									if(categoryCode.equals(fee2.getCategoryCode()) && fee2.getAcademicYearId()==nextAcademicYearId){
										for(StudentBalance studentBalance2: allStudentBalances){
											if(studentBalance2.getFeeId()==fee2.getId()){
												nextYearFeeFound = true;
												newPayment2 = new Payment();
												newPayment2.setFeeId(fee2.getId());
												newPayment2.setStudentBalanceId(studentBalance2.getId());
												newPayment2.setPayDate(new Date());
												newPayment2.setStudentId(studentBalance2.getStudentId());
												newPayment2.setActive("Y");
												newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
												newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//												if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//													rejectedPaymentsByInstallmentNumber.add(newPayment2);
//												}
//												else{
													paymentsToPayForNextCardinalUnit.add(newPayment2);
													paymentsToPayForNextCardinalUnit.add(newPayment);
//												}											
											}
										}	
									}
								}
								if(!nextYearFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
							//}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public HashMap<String,List<Payment>> createSubjectStudyGradeTypesSurplusPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad,List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		StudyPlanDetail studyPlanDetail = null;
		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int subjectStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;
        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee<0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
							    studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
									map = new HashMap();
							      	map.put("studyGradeTypeId", nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId());
							      	map.put("subjectId", studyPlanDetail.getSubjectId());
							      	subjectStudyGradeTypeId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getSubjectStudyGradeTypeId()==subjectStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public HashMap<String,List<Payment>> createSubjectBlockStudyGradeTypesSurplusPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad, List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		StudyPlanDetail studyPlanDetail = null;
		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int subjectBlockStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;

        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee<0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
							    studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
							      	subjectBlockStudyGradeTypeId = subjectBlockMapper.findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(studyPlanDetail.getSubjectBlockId(), nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId());
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getSubjectBlockStudyGradeTypeId()==subjectBlockStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}

	
//	public void transferSurplus(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, HttpServletRequest request) {
//	    
//	    // Check if there is a previous studyPlanCardinalTimeUnit
//	    StudyPlanCardinalTimeUnit previousSpctu = studentManager.findPreviousStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
//	    if (previousSpctu == null) {
//	        return;
//	    }
//	    
//        String writeWho = opusMethods.getWriteWho(request);
//
//        int studentId = studentManager.findStudentIdForStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());
//        Student student = studentManager.findPlainStudent(studentId);
//
//        //        List<Fee> studentFeesToLoad = feeManager.findStudentFeesForSubjectBlockStudyGradeTypes(studentId);
////	    studentFeesToLoad.addAll(feeManager.findStudentFeesForSubjectStudyGradeTypes(studentId));
////	    studentFeesToLoad.addAll(feeManager.findStudentFeesForStudyGradeTypes(studentId));
////	    studentFeesToLoad.addAll(feeManager.findStudentFeesForAcademicYears(studentId));
//
//	    double totalSurplus = 0.0;
////	    List<Payment> allPaymentsForTransfer = new ArrayList<Payment>();
//	    
//	    // Find surpluses from previous studyPlanCardinalTimeUnit
//	    List<StudentBalance> studentBalances = feeDao.findStudentBalancesByStudyPlanCardinalTimeUnitId(previousSpctu.getId());
//	    for (StudentBalance studentBalance : studentBalances) {
//	        Fee fee = feeDao.findFee(studentBalance.getFeeId());   // make a findFeeDue() method to avoid loading the entire Fee object
//	        Map<String, Object> map = new HashMap<String, Object>();
//	        map.put("studentBalanceId", studentBalance.getId());
//	        List<Payment> payments = paymentDao.findPaymentsByParams(map);
//	        double alreadyPaid = 0.0;
//	        for (Payment payment : payments) {
//	            alreadyPaid += payment.getSumPaid().doubleValue();
//	        }
//
//	        DiscountedFee discountedFee = bankInterfaceUtils.getDiscountedFee(fee, student);
//            double surplus = alreadyPaid;
//            if (discountedFee != null) {
//                surplus -= discountedFee.getDiscountedFeeDue();
//            }
//	        if (surplus > 0) {
//	            totalSurplus += surplus;
//	            // move surplus to next CTU
//	            Payment make0Payment = new Payment();
//                make0Payment.setFeeId(fee.getId());
//                make0Payment.setStudentBalanceId(studentBalance.getId());
//                make0Payment.setPayDate(new Date());
//                make0Payment.setStudentId(studentBalance.getStudentId());
//                make0Payment.setActive("Y");
//                make0Payment.setSumPaid(BigDecimal.valueOf(-surplus));
//                make0Payment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(payments,studentBalances,fee.getId()));
//                make0Payment.setWriteWho(writeWho);
////                allPaymentsForTransfer.add(make0Payment);
//                paymentManager.addPayment(make0Payment);
//	        }
//	    }
//	    
//	    // get all fees in the new time unit 
//	    if (totalSurplus > 0) {
//	        
//            List<Payment> paymentsForStudent = paymentManager.findPaymentsForStudent(studentId);
//
//            // get the fees in the new studyplanCTU
//            List<Fee> allFeesOfSPCTU = new ArrayList<Fee>();
//            List<StudentBalance> studentBalancesNew = feeDao.findStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());
//            for (StudentBalance studentBalance : studentBalancesNew) {
//                allFeesOfSPCTU.add(feeDao.findFee(studentBalance.getFeeId()));
//            }
//            List<DiscountedFee> discountedFees = bankInterfaceUtils.getDiscountedFees(allFeesOfSPCTU, student);
//            bankInterfaceUtils.makePayments(totalSurplus, paymentsForStudent, discountedFees, studentBalancesNew);
//	    }
//	    
//	}
	
	public HashMap<String,List<Payment>> createStudyGradeTypesSurplusPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad, List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;

		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int newStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;

        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee<0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studentBalance.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
									newStudyGradeTypeId = nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId();
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getStudyGradeTypeId()==newStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public static HashMap<String,List<Payment>> createAcademicYearOutstandingPaymentsForNextCardinalUnit(List < ? extends Fee >studentFeesToLoad,List < ? extends Payment >allPaymentsForStudent,List < ? extends StudentBalance >allStudentBalances,List <AcademicYear>allAcademicYears,int academicYearId){
		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		double newPaymentForFee = 0.0;
        int nextAcademicYearId = 0;
        String categoryCode = null;
        boolean nextYearFeeFound = false;
        for(AcademicYear year:allAcademicYears){
        	if(year.getId()==academicYearId){
        		nextAcademicYearId = year.getNextAcademicYearId();
        	}
        }
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			categoryCode = fee.getCategoryCode();
			if(fee.getAcademicYearId()==academicYearId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextYearFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
								for(Fee fee2: studentFeesToLoad){
									if(categoryCode.equals(fee2.getCategoryCode()) && fee2.getAcademicYearId()==nextAcademicYearId){
										for(StudentBalance studentBalance2: allStudentBalances){
											if(studentBalance2.getFeeId()==fee2.getId()){
												nextYearFeeFound = true;
												newPayment2 = new Payment();
												newPayment2.setFeeId(fee2.getId());
												newPayment2.setStudentBalanceId(studentBalance2.getId());
												newPayment2.setPayDate(new Date());
												newPayment2.setStudentId(studentBalance2.getStudentId());
												newPayment2.setActive("Y");
												newPayment2.setSumPaid(BigDecimal.valueOf((0.0-newPaymentForFee)));
												newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//												if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//													rejectedPaymentsByInstallmentNumber.add(newPayment2);
//												}
//												else{
													paymentsToPayForNextCardinalUnit.add(newPayment2);
													paymentsToPayForNextCardinalUnit.add(newPayment);
//												}											
											}
										}	
									}
								}
								if(!nextYearFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public HashMap<String,List<Payment>> createSubjectStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad,List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		StudyPlanDetail studyPlanDetail = null;
		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int subjectStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;
        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
							    studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
									map = new HashMap();
							      	map.put("studyGradeTypeId", nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId());
							      	map.put("subjectId", studyPlanDetail.getSubjectId());
							      	subjectStudyGradeTypeId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getSubjectStudyGradeTypeId()==subjectStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf((0.0-newPaymentForFee)));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public HashMap<String,List<Payment>> createSubjectBlockStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad,List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;
		StudyPlanDetail studyPlanDetail = null;
		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int subjectBlockStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;

        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
							    studyPlanDetail = studentManager.findStudyPlanDetail(studentBalance.getStudyPlanDetailId());
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanDetail.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
							      	subjectBlockStudyGradeTypeId = subjectBlockMapper.findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(studyPlanDetail.getSubjectBlockId(), nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId());
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getSubjectBlockStudyGradeTypeId()==subjectBlockStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}
	public HashMap<String,List<Payment>> createStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(
			List < ? extends Fee > studentFeesToLoad,List < ? extends Payment > allPaymentsForStudent,
			List < ? extends StudentBalance > allStudentBalances,
			int studyGradeTypeId, String iUseOfPartTimeStudyGradeTypes){

		List < Payment > paymentsToPayForNextCardinalUnit = new ArrayList<Payment >();
		List < Payment > rejectedPaymentsByFeeNotFound = new ArrayList<Payment >();
//		List < Payment > rejectedPaymentsByInstallmentNumber = new ArrayList<Payment >();	
		HashMap<String,List<Payment>> allPaymentsToPayForNexCardinalUnit = new HashMap<String,List<Payment>>();
		Payment newPayment,newPayment2 = null;

		StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
		StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;	
		HashMap map = null;
		int newStudyGradeTypeId = 0;
		double newPaymentForFee = 0.0;

        boolean nextCardinalUnitFeeFound = false;
  
		for(Fee fee: studentFeesToLoad){
			newPaymentForFee = fee.getFeeDue().doubleValue();
			if(fee.getStudyGradeTypeId()==studyGradeTypeId){
				for(StudentBalance studentBalance: allStudentBalances){
					if(studentBalance.getFeeId()==fee.getId()){
						for(Payment payment: allPaymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								newPaymentForFee = newPaymentForFee - payment.getSumPaid().doubleValue();
							}
						}
						if(newPaymentForFee>0){
							newPayment = new Payment();
							newPayment.setFeeId(fee.getId());
							newPayment.setStudentBalanceId(studentBalance.getId());
							newPayment.setPayDate(new Date());
							newPayment.setStudentId(studentBalance.getStudentId());
							newPayment.setActive("Y");
							newPayment.setSumPaid(BigDecimal.valueOf(newPaymentForFee));
							newPayment.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee.getId()));
							nextCardinalUnitFeeFound = false;
//							if(newPayment.getInstallmentNumber()>fee.getNumberOfInstallments()){
//								rejectedPaymentsByInstallmentNumber.add(newPayment);
//							}
//							else{
								studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studentBalance.getStudyPlanCardinalTimeUnitId());
								nextStudyPlanCardinalTimeUnit = studentManager.findNextStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, iUseOfPartTimeStudyGradeTypes);
						      	if(nextStudyPlanCardinalTimeUnit != null){
									newStudyGradeTypeId = nextStudyPlanCardinalTimeUnit.getStudyGradeTypeId();
									for(Fee fee2: studentFeesToLoad){
										if(fee2.getStudyGradeTypeId()==newStudyGradeTypeId){
											for(StudentBalance studentBalance2: allStudentBalances){
												if(studentBalance2.getFeeId()==fee2.getId()){
													nextCardinalUnitFeeFound = true;
													newPayment2 = new Payment();
													newPayment2.setFeeId(fee2.getId());
													newPayment2.setStudentBalanceId(studentBalance2.getId());
													newPayment2.setPayDate(new Date());
													newPayment2.setStudentId(studentBalance2.getStudentId());
													newPayment2.setActive("Y");
													newPayment2.setSumPaid(BigDecimal.valueOf(0.0-newPaymentForFee));
													newPayment2.setInstallmentNumber(BankInterfaceUtils.getNextPaymentInstallmentNumber(allPaymentsForStudent,allStudentBalances,fee2.getId()));
//													if(newPayment2.getInstallmentNumber()>fee2.getNumberOfInstallments()){
//														rejectedPaymentsByInstallmentNumber.add(newPayment2);
//													}
//													else{
														paymentsToPayForNextCardinalUnit.add(newPayment2);
														paymentsToPayForNextCardinalUnit.add(newPayment);
//													}											
												}
											}	
										}
									}
						      	}
								if(!nextCardinalUnitFeeFound){
									rejectedPaymentsByFeeNotFound.add(newPayment);
								}
//							}
						}
					}
				}
			}	
		}
		allPaymentsToPayForNexCardinalUnit.put("approevedPayments", paymentsToPayForNextCardinalUnit);
//		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByInstallmentNumber", rejectedPaymentsByInstallmentNumber);
		allPaymentsToPayForNexCardinalUnit.put("rejectedPaymentsByFeeNotFound", rejectedPaymentsByFeeNotFound);		
		return allPaymentsToPayForNexCardinalUnit;	
	}			
}
