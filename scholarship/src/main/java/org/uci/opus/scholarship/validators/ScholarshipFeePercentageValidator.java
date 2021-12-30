package org.uci.opus.scholarship.validators;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.scholarship.domain.ScholarshipFeePercentage;
import org.uci.opus.scholarship.web.form.ScholarshipFeePercentageForm;
import org.uci.opus.util.StringUtil;

public class ScholarshipFeePercentageValidator implements Validator {

    public boolean supports(final Class<?> clazz) {
        return ScholarshipFeePercentage.class.isAssignableFrom(clazz);
    }

    public void validate(final Object obj, final Errors errors) {
    	
    	ScholarshipFeePercentage feePercentage = ((ScholarshipFeePercentageForm)obj).getScholarshipFeePercentage();
    	String percentageStr = feePercentage.getPercentage() + "";
    	double percentage = 0 ;
    	
    	ValidationUtils.rejectIfEmpty(errors, "scholarshipFeePercentage.feeCategoryCode", "invalid.empty.format");
    	
    	if(StringUtil.checkValidDouble(percentageStr) != 1)
    		percentage = 0;
    	else
    		percentage = Double.parseDouble(percentageStr);
    	
    	if((percentage < 1) || (percentage > 100))
    		errors.rejectValue("scholarshipFeePercentage.percentage"
    							, "invalid.number.mustbebetween.args"
    							, new String[]{"1", "100"}
    							, "invalid.number.mustbebetween.args");
    }

}
