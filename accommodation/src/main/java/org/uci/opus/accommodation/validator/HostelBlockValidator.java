package org.uci.opus.accommodation.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.accommodation.domain.HostelBlock;

@Component
public class HostelBlockValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return HostelBlock.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object obj, Errors errors) {

        ValidationUtils.rejectIfEmpty(errors, "code", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "hostel.id", "invalid.empty.format");
        
        if (0 == (Integer) errors.getFieldValue("hostel.id")) {
            errors.rejectValue("hostel.id", "invalid.empty.format");
        }

        if (0 == (Integer) errors.getFieldValue("numberOfFloors")) {
            errors.rejectValue("numberOfFloors", "invalid.empty.format");
        }
    }

}
