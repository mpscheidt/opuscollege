package org.uci.opus.college.validator;

import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.web.flow.study.CurriculumTransitionData;

@Service
public class CurriculumTransitionValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return CurriculumTransitionData.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object obj, Errors errors) {

        CurriculumTransitionData data = (CurriculumTransitionData) obj;
        
        if (data.getFromAcademicYearId() == 0) {
            errors.rejectValue("fromAcademicYearId", "invalid.empty.format");
        }

        if (data.getToAcademicYearId() == 0) {
            errors.rejectValue("toAcademicYearId", "invalid.empty.format");
        }
    }

    
}
