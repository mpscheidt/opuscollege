package org.uci.opus.accommodation.validator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.accommodation.domain.StudentAccommodation;

@Component
public class RoomAllocationValidator implements Validator {

	Logger log = LoggerFactory.getLogger(RoomAllocationValidator.class);

    @Override
    public boolean supports(Class<?> clazz) {
        return RoomAllocationValidator.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object obj, Errors errors) {

    	StudentAccommodation studentAccommodation = (StudentAccommodation)obj;
    	
    	if (0 == (Integer) errors.getFieldValue("academicYear.id")) {
        	errors.rejectValue("academicYear.id", "invalid.empty.format");
    	}
    	
        if (!"Y".equalsIgnoreCase(studentAccommodation.getApproved())) {
            errors.rejectValue("approved", "jsp.accommodation.error.notApproved");
        }
        
        if (0 == (Integer) errors.getFieldValue("roomId")) {
            errors.rejectValue("roomId", "invalid.empty.format");
        }

    }

}
