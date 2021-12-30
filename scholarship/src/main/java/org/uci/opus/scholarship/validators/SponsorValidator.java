package org.uci.opus.scholarship.validators;

import java.util.HashMap;
import java.util.Map;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;

public class SponsorValidator implements Validator{

	private ScholarshipManagerInterface scholarshipManager;
	
    public SponsorValidator(ScholarshipManagerInterface scholarshipManager) {
		super();
		this.scholarshipManager = scholarshipManager;
	}

	public boolean supports(final Class<?> clazz) {
        return Sponsor.class.isAssignableFrom(clazz);
    }

    public void validate(final Object obj, final Errors errors) {
    	
    	Sponsor sponsor = (Sponsor) obj; 

        if (0 == (Integer) errors.getFieldValue("academicYearId")) {
            errors.rejectValue("academicYearId", "invalid.empty.format");
        }

    	ValidationUtils.rejectIfEmpty(errors, "name", "invalid.empty.format");
    	ValidationUtils.rejectIfEmpty(errors, "code", "invalid.empty.format");
        
    	//check if there is a sponsor with this code
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("code", sponsor.getCode());
    	params.put("academicYearId", sponsor.getAcademicYearId());

    	if(scholarshipManager.doesSponsorExist(sponsor.getId(), params))
    		errors.rejectValue("code","jsp.error.general.alreadyexists");
    	
    }

}
