package org.uci.opus.college.validator;

import java.math.BigDecimal;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.util.StringUtil;

public class MarkValidator implements Validator {
    
    private BigDecimal minimumMarkValue;
    private BigDecimal maximumMarkValue;

    public MarkValidator(BigDecimal minimumMarkValue, BigDecimal maximumMarkValue) {
        this.minimumMarkValue = minimumMarkValue;
        this.maximumMarkValue = maximumMarkValue;
    }

    /**
     * String values will be converted to BigDecimal.
     * @param minimumMarkValue
     * @param maximumMarkValue
     */
    public MarkValidator(String minimumMarkValue, String maximumMarkValue) {
        this.minimumMarkValue = new BigDecimal(minimumMarkValue);
        this.maximumMarkValue = new BigDecimal(maximumMarkValue);
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return String.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object object, Errors errors) {

        String mark = (String) object; 

        switch (StringUtil.checkValidDouble(mark)) {
        case -1:
            errors.rejectValue("mark", "invalid.invalid");
            break;
        case 0:
            errors.rejectValue("mark", "invalid.empty.format");
            break;
        }
        
        if (errors.hasErrors()) {
            return;
        }

        // At this point a number is expected that can be converted to a BigDecimal
        BigDecimal markDecimal = new BigDecimal(mark);
        if (markDecimal.compareTo(minimumMarkValue) < 0 || markDecimal.compareTo(maximumMarkValue) > 0) {
            errors.rejectValue("mark", "invalid.invalid");
        }
    }

}
