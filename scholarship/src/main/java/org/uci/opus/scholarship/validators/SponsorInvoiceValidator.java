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
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;

/**
 * Validator for {@link SponsorInvoice}.
 * 
 * @author markus
 */
@Service
public class SponsorInvoiceValidator implements Validator{

	@Autowired private ScholarshipManagerInterface scholarshipManager;
	
    public SponsorInvoiceValidator() {
		super();
	}

	public boolean supports(final Class<?> clazz) {
        return SponsorInvoice.class.isAssignableFrom(clazz);
    }

    public void validate(final Object obj, final Errors errors) {

    	SponsorInvoice sponsorInvoice = (SponsorInvoice) obj; 

        if (sponsorInvoice.getScholarshipId() == 0) {
            errors.rejectValue("scholarshipId", "invalid.empty.format");
        }

    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "invoiceNumber", "invalid.empty.format");

        if (sponsorInvoice.getInvoiceDate() == null) {
            errors.rejectValue("invoiceDate", "invalid.empty.format");
        }

        BigDecimal amount = sponsorInvoice.getAmount();
        if (amount == null || amount.equals(BigDecimal.ZERO)) {
            errors.rejectValue("amount", "invalid.empty.format");
        }

    	//check if there is a sponsorInvoice with this invoice number (invoice number is unique)
    	Map<String, Object> params = new HashMap<String, Object>();
    	params.put("id", sponsorInvoice.getId());
    	params.put("invoiceNumber", sponsorInvoice.getInvoiceNumber());

    	if(scholarshipManager.doesSponsorInvoiceExist(params))
    		errors.rejectValue("invoiceNumber","jsp.error.general.alreadyexists");
    	
    }

}
