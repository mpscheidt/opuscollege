package org.uci.opus.unza.validators;
import org.apache.log4j.Logger;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

public class FinancialRequestsValidator implements Validator{
    private static Logger log = Logger.getLogger(FinancialRequestsValidator.class);
	/**
	 * SecurityContextHolderAwareRequestWrapper is used because formBackingObject method of
	 * FinancialRequestContrioller returns HttpServletRequest class
	 */
    public boolean supports(Class<?> clazz) {
        return clazz.equals(SecurityContextHolderAwareRequestWrapper.class);
    }
    /**
     * Validates the form
     */
	public void validate(Object obj, Errors errors) {
		 log.debug("Validating");  
	}
}
