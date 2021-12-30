package org.uci.opus.fee.service.extension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.IStudyPlanCardinalTimeUnitListener;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.persistence.PaymentMapper;
import org.uci.opus.fee.persistence.StudentBalanceMapper;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.fee.util.AppliedFeesInCtuComparator;
import org.uci.opus.finance.service.extpoint.FinanceServiceExtensions;
import org.uci.opus.util.OpusMethods;

@Service
public class FeeStudyPlanCardinalTimeUnitListener implements
        IStudyPlanCardinalTimeUnitListener {

    @Autowired private FeeManagerInterface feeManager;
    @Autowired private StudentBalanceMapper studentBalanceMapper;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PaymentMapper paymentDao;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private FinanceServiceExtensions financeServiceExtensions;

    
    private static Logger log = LoggerFactory.getLogger(FeeStudyPlanCardinalTimeUnitListener.class);

    @Override
    public void studyPlanCardinalTimeUnitAdded(
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,
            StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit,
            HttpServletRequest request) {
        
        //HttpSession session = request.getSession(false);        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String writeWho = opusMethods.getWriteWho(request);
        BigDecimal balanceBFwd = new BigDecimal(0.00);
        List < StudentBalance> studentBalances;

        // CTU fees (semester/trimester/year/...)
        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
        Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());
        // create studentBalances/appliedFees for fees on study and educationArea
        studentBalances = feeManager.createStudentBalances(studyPlanCardinalTimeUnit,
                studyPlan.getStudentId(),
                preferredLanguage, writeWho);

        if (previousStudyPlanCardinalTimeUnit != null) {
	        // add Balance Brought Forward which is a special form of studentBalance
	        balanceBFwd = feeManager.calculateBalanceBroughtForward(studyPlanCardinalTimeUnit
	                                    , previousStudyPlanCardinalTimeUnit, preferredLanguage);

	        // TODO: MOVE TO OTHER CLASS?
	        // if the balanceBFwd is a surplus, distribute it over the fees
	        if (balanceBFwd.signum() == -1) {
	        	
	        	// create a list of appliedFees
	        	List <AppliedFee> appliedFees = new ArrayList<AppliedFee>();
	        	for (StudentBalance studentBalance : studentBalances) {
	        		AppliedFee appliedFee = feeManager.findAppliedFeeForStudentBalance(studentBalance.getId());
	        		Fee fee = appliedFee.getFee();
	        		// do not add the balanceBroughtFwd, since this in this case it does not need to be paid but
	        		// is used to pay the other fees
	        		if (!appliedFee.getFee().getCategoryCode().equals(FeeConstants.BALANCE_BROUGHT_FORWARD_CAT)) {
	        			// take into account any discounts because of a scholarship
	        			if (fee.getStudyGradeTypeId() != 0) {
	        	        	 int discountPercentage = financeServiceExtensions.getDiscountPercentage(student, fee);
	        	        	 appliedFee.setDiscountedFeeDue(appliedFee.calculateDiscountedFee(new BigDecimal(discountPercentage)));
	        			} else {
	        				appliedFee.setDiscountedFeeDue(appliedFee.getFee().getFeeDue());
	        			}
	        			//appliedFee = bankInterfaceUtils.getDiscountedFee(appliedFee, student);
	        			appliedFees.add(appliedFee);
	        		}
	        	}
	        	// put the tuition fee on the bottom of the list, so it will be paid last
	        	Collections.sort(appliedFees, new AppliedFeesInCtuComparator());
	        	// pay the fees as far as possible with the surplus of the balanceBroughtFwd
	        	
//	        	paymentUtil.transferSurplus(studyPlanCardinalTimeUnit, balanceBFwd, studentBalances, request);
	        	BigDecimal remainingSurplus = balanceBFwd;
	        	if (log.isDebugEnabled()) {
	        		log.debug("remainingSurplus.signum() before negate = " + remainingSurplus.signum());
	        		log.debug("remainingSurplus before negate = " + remainingSurplus);
	        	}
	        	// easier to calculate with positive number
	        	remainingSurplus = remainingSurplus.negate();
	        	if (log.isDebugEnabled()) {
		        	log.debug("remainingSurplus.signum() after = " + remainingSurplus.signum());
		        	log.debug("remainingSurplus after = " + remainingSurplus);
	        	}
	        	
	        	BigDecimal amountToPay = new BigDecimal(0.00);
	        	for (AppliedFee appliedFee : appliedFees) {
	        		// there is still a surplus to divide
	        		if (remainingSurplus.signum() == 1) {
	        			// see which part of this fee can be paid off
//		        		BigDecimal feeDue = appliedFee.getFee().getFeeDue();
	        			BigDecimal feeDue = appliedFee.getDiscountedFeeDue();
		        		// remainingSurplus equal to or more than feeDue
		        		if (remainingSurplus.compareTo(feeDue) >= 0 ) {
		        			amountToPay = feeDue;
		        		// remainingSurplus is less than feeDue
		        		} else {
		        			amountToPay = remainingSurplus;
		        			
		        		}
		        		
		        		remainingSurplus = remainingSurplus.subtract(amountToPay);
		        		if (log.isDebugEnabled()) {
			        		log.debug("appliedFee studentBalanceId + feeDue + paid = " 
			        					+ appliedFee.getStudentBalanceId() + " - " 
			        					+ appliedFee.getDiscountedFeeDue() + " - " 
			        					+ appliedFee.getAmountPaid());
			        		log.debug("amountToPay = " + amountToPay);
			        		log.debug("remainingSurplus = " + remainingSurplus);
		        		}
		        		
		        		Payment newPayment;
		        		newPayment = new Payment();
		                newPayment.setFeeId(appliedFee.getFee().getId());
		                newPayment.setStudentBalanceId(appliedFee.getStudentBalanceId());
		                newPayment.setPayDate(new Date());
		                newPayment.setStudentId(appliedFee.getStudentId());
		                newPayment.setActive("Y");
		                newPayment.setSumPaid(amountToPay);
						// this is always the first installment for this fee
						newPayment.setInstallmentNumber(1);
//						newPayment.setWriteWho("opuscollege-fees");
						paymentManager.addPayment(newPayment, writeWho);
	        		}
	        	}
	        }
	    }
    }

    @Override
    public void isDeleteAllowed(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, BindingResult result) {
        // Check if a payment has been made already for the given studyPlanCardinalTimeUnit
        boolean paymentExists = false;
        List<StudentBalance> studentBalancesNew = studentBalanceMapper.findStudentBalancesByStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());
        for (StudentBalance studentBalance : studentBalancesNew) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("studentBalanceId", studentBalance.getId());
            List<Payment> payments = paymentDao.findPaymentsByParams(map);
            if (payments != null && !payments.isEmpty()) {
                paymentExists = true;
                break;
            }
        }
        if (paymentExists) {
            result.reject("jsp.error.studyplancardinaltimeunit.delete");
            result.reject("jsp.error.payments.exist");
        }
    }

    @Override
    public void beforeStudyPlanCardinalTimeUnitDelete(int studyPlanCardinalTimeUnitId, String writeWho) {

        feeManager.deleteStudentBalancesByStudyPlanCardinalTimeUnitId(
                studyPlanCardinalTimeUnitId, writeWho);

    }

}
