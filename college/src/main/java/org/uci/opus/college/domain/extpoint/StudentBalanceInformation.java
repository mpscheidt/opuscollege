package org.uci.opus.college.domain.extpoint;

import java.math.BigDecimal;

import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;

/**
 * 
 * Information about the student balance.
 * This information is typically given by an external system, e.g. Dimensions or Accpac.
 * Not all external systems provide the same balance information,
 * e.g. one system may provide the paid percentage, whereas another immediately provides a sufficientRegistrationPayment flag.
 * 
 * The {@link StudentBalanceEvaluation} uses the student balance information to determine
 * information understandable by Opus.
 * 
 * @author markus
 * @see StudentBalanceEvaluation
 */
public class StudentBalanceInformation {

    private int studentId;
    private String studentCode;
    private BigDecimal balance;
    private BigDecimal invoiced;
    private BigDecimal paidPercentage;
    private Boolean sufficientPaymentsForRegistration;

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public BigDecimal getInvoiced() {
        return invoiced;
    }

    public void setInvoiced(BigDecimal invoiced) {
        this.invoiced = invoiced;
    }

    public BigDecimal getPaidPercentage() {
        return paidPercentage;
    }

    public void setPaidPercentage(BigDecimal paidPercentage) {
        this.paidPercentage = paidPercentage;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Boolean getSufficientPaymentsForRegistration() {
        return sufficientPaymentsForRegistration;
    }

    public void setSufficientPaymentsForRegistration(Boolean sufficientPaymentsForRegistration) {
        this.sufficientPaymentsForRegistration = sufficientPaymentsForRegistration;
    }

}
