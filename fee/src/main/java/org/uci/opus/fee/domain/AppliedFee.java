package org.uci.opus.fee.domain;

import java.math.BigDecimal;

import org.uci.opus.college.domain.AcademicYear;


public class AppliedFee {

//	private int id; 
//	private String writeWho;
    private int studentId;
    private int studentBalanceId;
    private String exemption;
    private Fee fee;
    
    private BigDecimal discountedFeeDue;
    // special amount to be paid; e.g. used for the balanceBroughtForward
    private BigDecimal amount;
    private BigDecimal amountPaid;
    // fees on area of education
    private AcademicYear academicYear;
 // fees on studyGradeType
    private int studyPlanCardinalTimeUnitId;
 // fees on subject(Blocks)
    private int studyPlanDetailId;
    private int ctuNumber;
    
    public AppliedFee() {
    	discountedFeeDue = new BigDecimal(0.00);
    	amount = new BigDecimal(0.00);
        amountPaid = new BigDecimal(0.00);
        exemption = "N";
    }
    
    public AppliedFee(Fee fee) {
    	setFee(fee);
    	discountedFeeDue = fee.getFeeDue();
    	amount = new BigDecimal(0.00);
        amountPaid = new BigDecimal(0.00);
        exemption = "N";
    }
    
    public AppliedFee(Fee fee, BigDecimal discountPercentage) {
    	discountedFeeDue = new BigDecimal(0.00);
    	amount = new BigDecimal(0.00);
        amountPaid = new BigDecimal(0.00);
        exemption = "N";
        
        setFee(fee);
        BigDecimal hundred = new BigDecimal(100);
        BigDecimal zero = new BigDecimal(0);
        BigDecimal discountRatio = new BigDecimal(0.00);
        if (discountPercentage.compareTo(hundred) > 0) {
        	discountPercentage = hundred;
        }
        if (discountPercentage.compareTo(zero) != 0) {
        	discountRatio = (hundred.subtract(discountPercentage)).divide(hundred);
            setDiscountedFeeDue(fee.getFeeDue().multiply(discountRatio));
        }
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(final int studentId) {
        this.studentId = studentId;
    }

    public int getStudentBalanceId() {
        return studentBalanceId;
    }

    public void setStudentBalanceId(final int studentBalanceId) {
        this.studentBalanceId = studentBalanceId;
    }

    public String getExemption() {
        return exemption;
    }

    public void setExemption(final String exemption) {
        this.exemption = exemption;
    }

    public Fee getFee() {
        return fee;
    }

    public void setFee(final Fee fee) {
        this.fee = fee;
    }

    public BigDecimal getDiscountedFeeDue() {
        return discountedFeeDue;
    }

    public void setDiscountedFeeDue(final BigDecimal discountedFeeDue) {
        this.discountedFeeDue = discountedFeeDue;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(final BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(final BigDecimal amountPaid) {
        this.amountPaid = amountPaid;
    }

    public AcademicYear getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(final AcademicYear academicYear) {
        this.academicYear = academicYear;
    }

    public int getStudyPlanCardinalTimeUnitId() {
        return studyPlanCardinalTimeUnitId;
    }

    public void setStudyPlanCardinalTimeUnitId(final int studyPlanCardinalTimeUnitId) {
        this.studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnitId;
    }

    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }

    public void setStudyPlanDetailId(final int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
    }

    public int getCtuNumber() {
        return ctuNumber;
    }

    public void setCtuNumber(final int ctuNumber) {
        this.ctuNumber = ctuNumber;
    }
    
    public BigDecimal calculateDiscountedFee(BigDecimal discountPercentage) {
    	BigDecimal hundred = new BigDecimal(100);
        BigDecimal zero = new BigDecimal(0);
        BigDecimal discountRatio = new BigDecimal(0.00);
        BigDecimal discountedFeeDue = new BigDecimal(0.00);
        if (discountPercentage.compareTo(hundred) > 0) {
        	discountPercentage = hundred;
        }
        if (discountPercentage.compareTo(zero) != 0) {
        	discountRatio = (hundred.subtract(discountPercentage)).divide(hundred);
        	discountedFeeDue = fee.getFeeDue().multiply(discountRatio);
        }
        
        return discountedFeeDue;
    }
    
    public String toString() {
        	
    	String returnString = "AppliedFee is: \n"
    			+ "\n studentId = " + this.getStudentId()
    			+ "\n studentBalanceId = " + this.getStudentBalanceId()
    			+ "\n exemption = " + this.getExemption();
    			if (this.getFee() != null) {
    				returnString += "\n fee = " + this.getFee().toString();
    			}
   			returnString += "\n discountedFeeDue = " + this.getDiscountedFeeDue()
    			+ "\n amount = " + this.getAmount()
    			+ "\n amountPaid = " + this.getAmountPaid();
    			if (this.getAcademicYear() != null) {
    				returnString += "\n academicYear = " + this.getAcademicYear().toString();
    			}
    			returnString += "\n studyPlanCardinalTimeUnitId = " + this.getStudyPlanCardinalTimeUnitId()
    			+ "\n studyPlanDetailId = " + this.getStudyPlanDetailId()
    			+ "\n ctuNumber = " + this.getCtuNumber();
    			
    			return returnString;
    }

}
