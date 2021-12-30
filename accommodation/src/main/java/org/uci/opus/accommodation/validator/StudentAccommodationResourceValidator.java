package org.uci.opus.accommodation.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.accommodation.web.form.StudentAccommodationResourceForm;

public class StudentAccommodationResourceValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return clazz.isAssignableFrom(StudentAccommodationResourceForm.class);
	}

	@Override
	public void validate(Object form, Errors errors) {
		StudentAccommodationResourceForm studentAccommodationResourceForm=(StudentAccommodationResourceForm)form;
		if(studentAccommodationResourceForm.getAccommodationResourceId()==0){
			errors.rejectValue("accommodationResourceId", "jsp.accommodation.error.chooseAccommodationResource");
		}		
	}

}
