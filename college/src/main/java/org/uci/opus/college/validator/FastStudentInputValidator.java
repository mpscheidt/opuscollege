/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.college.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.web.form.FastStudentInputForm;
import org.uci.opus.config.CountryProperties;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusInit;

/**
 * Validates student and its Address properties
 * @author stelio
 * @author mp
 */
@Component
public class FastStudentInputValidator implements Validator {

//	private AddressValidator addressValidator;
    @Autowired private StudentValidator studentValidator;
    @Autowired private CountryProperties countryProperties;
    @Autowired private OpusInit opusInit;
//	private @Value("${mobilephone.regex}") String mobilePhoneRegex;

    public static final String EMAIL_REGEX = OpusConstants.EMAIL_REGEX;

	public boolean supports(Class<?> clazz) {
		return FastStudentInputForm.class.isAssignableFrom(clazz);
	}

    public void validate(final Object obj, final Errors errors) {
    	
    	FastStudentInputForm fastStudentInputForm = (FastStudentInputForm) obj;

		errors.pushNestedPath("student");  // the following are all properties of the student object
		studentValidator.validate(fastStudentInputForm.getStudent(), errors);

	    /* emailAddress - required field for Zambia (if not organization) + format validation */
//        if ("Y".equals((String)session.getAttribute("iEmailAddressRequired"))) {
		if (opusInit.getEmailAddressRequired()) {
		    if (errors.getFieldValue("addresses[0].emailAddress") == null
		    		|| "".equals(errors.getFieldValue("addresses[0].emailAddress"))) {
		        if (!((String) errors.getFieldValue("addresses[0].emailAddress")).matches(EMAIL_REGEX)) {
		            errors.rejectValue("addresses[0].emailAddress", "invalid.email.format");
		        }
		    }
        }
        if (errors.getFieldValue("addresses[0].emailAddress") != null
        		&& !"".equals(errors.getFieldValue("addresses[0].emailAddress"))) {
	        if (!((String) errors.getFieldValue("addresses[0].emailAddress")).matches(EMAIL_REGEX)) {
	            errors.rejectValue("addresses[0].emailAddress", "invalid.email.format");
	        }
	    }

        errors.pushNestedPath("addresses[0]");

        if (opusInit.getMobilePhoneRequired()) {
            if (errors.getFieldValue("mobilePhone") == null || "".equals(errors.getFieldValue("mobilePhone"))) {
                errors.rejectValue("mobilePhone", "invalid.mobilephone.format");
            }
        }

        if (errors.getFieldValue("mobilePhone") != null && !"".equals(errors.getFieldValue("mobilePhone"))) {
            String mobilePhoneRegex = countryProperties.getMobilePhoneRegex();
            if (!((String) errors.getFieldValue("mobilePhone")).matches(mobilePhoneRegex)) {
                errors.rejectValue("mobilePhone", "invalid.telephone.format");
            }
        }
		
        errors.popNestedPath();     // pop addresses
        
        errors.popNestedPath();     // pop student
		
//		List<? extends Address> addresses = ((Student)obj).getAddresses();
//        try {
//		   	//there is only address when adding a student via fastinput
//	          errors.pushNestedPath("addresses[0]");
//	          ValidationUtils.invokeValidator(this.addressValidator,addresses.get(0) , errors);
//	      } finally {
//	          errors.popNestedPath();
//	      }
	}
}
