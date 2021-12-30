package org.uci.opus.college.validator.result;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.validator.MarkValidator;

/**
 * Reusable validation logic for results.
 * 
 * @author Markus Pscheidt
 *
 * @param <T>
 */
public abstract class AbstractResultValidator<T extends IResult> implements Validator {

    protected MarkValidator markValidator;
    private AuthorizationSubExTest authorization;
    protected OpusUser opusUser;
    
    public AbstractResultValidator(String minimumMarkValue, String maximumMarkValue, OpusUser opusUser) {
        markValidator = new MarkValidator(minimumMarkValue, maximumMarkValue);
        this.opusUser = opusUser;
    }


    @Override
    public void validate(Object target, Errors errors) {
        
        @SuppressWarnings("unchecked")
        T result = (T) target;

        int id = result.getId();
        if (id == 0) {
            if (getAuthorization() == null || !getAuthorization().getCreate()) {
                errors.reject("jsp.error.noauthorization.createresult");
            }
        } else {
            if (getAuthorization() == null || !getAuthorization().getUpdate()) {
                errors.reject("jsp.error.noauthorization.updateresult");
            }
        }

        if (errors.hasErrors()) {
            return;
        }

        int staffMemberId = result.getStaffMemberId();
        if (staffMemberId == 0) {
            errors.rejectValue("staffMemberId", "invalid.empty.format");
        } else {
            // check if selected staff member is authorized
            StaffMember opusUserStaffMember = opusUser.getStaffMember();
            int opusUserStaffMemberId = opusUserStaffMember != null ? opusUserStaffMember.getStaffMemberId() : 0;
            if (getAuthorization().isStaffMemberLimitedToSelf() && staffMemberId != opusUserStaffMemberId) {
                errors.rejectValue("staffMemberId", "jsp.error.noauthorization.selectedstaffmember");
            }
        }

        markValidator.validate(errors.getFieldValue("mark"), errors);

        // do additional result specific validation
        validateResult(result, errors);
    }

    protected abstract void validateResult(T result, Errors errors);
    
    public AuthorizationSubExTest getAuthorization() {
        return authorization;
    }

    public void setAuthorization(AuthorizationSubExTest authorization) {
        this.authorization = authorization;
    }

}
