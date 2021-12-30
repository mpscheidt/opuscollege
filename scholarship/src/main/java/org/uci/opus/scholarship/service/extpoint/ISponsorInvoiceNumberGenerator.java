package org.uci.opus.scholarship.service.extpoint;

import org.uci.opus.scholarship.domain.SponsorInvoice;

public interface ISponsorInvoiceNumberGenerator {

    /**
     * Generate a sponsor invoice number for the given sponsorInvoice.
     * The generated number will be set in sponsorInvoice.invoiceNumber.
     * This method is called when a new sponsorInvoice is stored to the DB.
     * @param sponsorInvoice
     * @param academicYearId
     */
    void generateSponsorInvoiceNumber(SponsorInvoice sponsorInvoice, int academicYearId);

}
