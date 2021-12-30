package org.uci.opus.scholarship.domain;

import java.math.BigDecimal;
import java.util.Date;

public class SponsorPayment {
    private int id;
    private int sponsorInvoiceId;
    private Date paymentReceivedDate;
    private BigDecimal amount;
    private String receiptNumber;
    private String writeWho;
    
    private SponsorInvoice sponsorInvoice;
    
    public SponsorPayment() {
    }

    public int getId() {
        return id;
    }

    public void setId(final int id) {
        this.id = id;
    }

    public Date getPaymentReceivedDate() {
        return paymentReceivedDate;
    }

    public void setPaymentReceivedDate(final Date paymentReceivedDate) {
        this.paymentReceivedDate = paymentReceivedDate;
    }

    public int getSponsorInvoiceId() {
        return sponsorInvoiceId;
    }

    public void setSponsorInvoiceId(int sponsorInvoiceId) {
        this.sponsorInvoiceId = sponsorInvoiceId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getReceiptNumber() {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public SponsorInvoice getSponsorInvoice() {
        return sponsorInvoice;
    }

    public void setSponsorInvoice(SponsorInvoice sponsorInvoice) {
        this.sponsorInvoice = sponsorInvoice;
    }

}
