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
 * The Original Code is Opus-College scholarship module code.
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
package org.uci.opus.scholarship.validators;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;

/**
 * Validator for {@link SponsorPayment}.
 * 
 * @author MoVe
 * @author markus
 */
@Service
public class SponsorPaymentValidator implements Validator {

    @Autowired private ScholarshipManagerInterface scholarshipManager;

    /**
     * {@inheritDoc}.
     * 
     * @see org.springframework.validation.Validator#supports(java.lang.Class)
     */
    public boolean supports(final Class<?> clazz) {
        return SponsorPayment.class.isAssignableFrom(clazz);
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.springframework.validation.Validator#validate(java.lang.Object,
     *      org.springframework.validation.Errors)
     */
    public void validate(final Object obj, final Errors errors) {

        SponsorPayment sponsorPayment = (SponsorPayment) obj;

        int sponsorInvoiceId = sponsorPayment.getSponsorInvoiceId();
        if (sponsorInvoiceId == 0) {
            errors.rejectValue("sponsorInvoiceId", "invalid.empty.format");
        }

        ValidationUtils.rejectIfEmpty(errors, "paymentReceivedDate", "invalid.empty.format");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "receiptNumber", "invalid.empty.format");

        BigDecimal amount = sponsorPayment.getAmount();
        if (amount == null || amount.equals(BigDecimal.ZERO)) {
            errors.rejectValue("amount", "invalid.empty.format");
        } else if (sponsorInvoiceId != 0) {
            // Need to load sponsorInvoice by hand, because getter doesn't work if this is a new sponsorPayment
            SponsorInvoice sponsorInvoice = scholarshipManager.findSponsorInvoiceById(sponsorInvoiceId);
            BigDecimal maxAmountToBePaid = sponsorInvoice.getOutstandingAmount();
            // in case of updating an existing payment: maxAmountToBePaid += amountInDb,
            // otherwise updating would not be possible anymore if e.g. all has been paid (maxAmountToBePaid would be 0)
            if (sponsorPayment.getId() != 0) {
                BigDecimal amountInDb = scholarshipManager.findSponsorPaymentById(sponsorPayment.getId()).getAmount();
                maxAmountToBePaid = maxAmountToBePaid.add(amountInDb);
            }
            if (amount.compareTo(maxAmountToBePaid) > 0) {
                errors.rejectValue("amount", "invalid.sponsorpayment.cannot.be.greater.than.outstanding.amount");
            }
        }

        //check if there is a sponsorInvoice with this invoice number (invoice number is unique)
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("id", sponsorPayment.getId());
        params.put("receiptNumber", sponsorPayment.getReceiptNumber());

        if(scholarshipManager.doesSponsorPaymentExist(params)) {
            errors.rejectValue("receiptNumber", "jsp.error.general.alreadyexists");        
        }
    }

}
