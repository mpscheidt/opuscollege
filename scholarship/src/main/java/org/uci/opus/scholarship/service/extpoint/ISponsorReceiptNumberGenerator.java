package org.uci.opus.scholarship.service.extpoint;

import org.uci.opus.scholarship.domain.SponsorPayment;

public interface ISponsorReceiptNumberGenerator {

    /**
     * Generate a sponsor receipt number for the given sponsorInvoice.
     * The generated number will be set in sponsorPayment.receiptNumber.
     * This method is called when a new sponsorPayment is inserted into the DB.
     * @param sponsorPayment
     */
    void generateSponsorReceiptNumber(SponsorPayment sponsorPayment);

}
