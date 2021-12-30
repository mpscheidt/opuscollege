package org.uci.opus.college.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.web.form.StaffMemberForm;

@Component
public class StaffMemberFormValidator implements Validator {

	@Autowired
	private StaffMemberValidator staffMemberValidator;

	@Override
	public boolean supports(Class<?> clazz) {
		return StaffMemberForm.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object staffMemberForm, Errors errors) {
		errors.pushNestedPath("staffMember");
		staffMemberValidator.validate(((StaffMemberForm) staffMemberForm).getStaffMember(), errors);
		errors.popNestedPath();
	}

}
