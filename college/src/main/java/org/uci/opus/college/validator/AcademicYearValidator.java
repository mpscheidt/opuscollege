package org.uci.opus.college.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.AcademicYear;

@Component
public class AcademicYearValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return AcademicYear.class.isAssignableFrom(clazz);    }

    @Override
    public void validate(Object object, Errors errors) {
        
        AcademicYear academicYear = (AcademicYear) object;

        if (academicYear.getDescription() == null || academicYear.getDescription().isEmpty()) {
            errors.rejectValue("academicYear.description", "invalid.empty.format");
        }
        

    }

}
