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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.Address;
import org.uci.opus.config.CountryProperties;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.StringUtil;


/**
 * Validator for {@link Address}.
 * 
 * @author M. in het Veld
 */
@Component
public class AddressValidator implements Validator {

    public static final String EMAIL_REGEX = OpusConstants.EMAIL_REGEX;
    
    @Autowired private CountryProperties countryProperties;
    @Autowired private OpusInit opusInit;
    
//    public static final String PHONE_REGEX = OpusConstants.PHONE_REGEX;
    
//    public static final String MOBILE_PHONE_REGEX = OpusConstants.MOBILE_PHONE_REGEX;

//    public static final String ZIP_CODE_REGEX = OpusConstants.ZIP_CODE_REGEX;

    @Override
    public boolean supports(final Class<?> clazz) {
        return Address.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
    	
    	this.onBindAndValidate(null, obj, errors);
    }

    /**
     *  {@inheritDoc}.
     * @see org.springframework.validation.Validator#onBindAndValidate(
     * 		java.lang.Object, 
     * 				org.springframework.validation.Errors)
     */
    public void onBindAndValidate(HttpServletRequest request, 
    		final Object obj, final Errors errors) { 
    	
        HttpSession session = request.getSession(false);

         /* addressTypeId - required field */
        if ("".equals(errors.getFieldValue("address.addressTypeCode").toString())
                || "0".equals(errors.getFieldValue("address.addressTypeCode").toString())
                ) {
            errors.rejectValue("address.addressTypeCode", "invalid.addresstype.format");
        }

        /* countryCode - required field */
        if (errors.getFieldValue("address.countryCode") == null
        		|| "".equals(errors.getFieldValue("address.countryCode").toString())) {
            errors.rejectValue("address.countryCode", "invalid.country.format");
        }
        /* provinceCode - required field */
        if (StringUtil.isNullOrEmpty((String)errors.getFieldValue("address.provinceCode"), true)
                || "0".equals(errors.getFieldValue("address.provinceCode").toString())) {
            errors.rejectValue("address.provinceCode", "invalid.province.format");
        }
        /* districtCode - required field */
//        if ("".equals(errors.getFieldValue("address.districtCode").toString())) {
//            errors.rejectValue("address.districtCode", "invalid.district.format");
//        }
        /* administrativePostCode - required field */
//        if ("".equals(errors.getFieldValue("address.administrativePostCode").toString())) {
//            errors.rejectValue("address.administrativePostCode", "invalid.administrativepost.format");
//        }
        /* city - required field */
        if (errors.getFieldValue("address.city") == null
        		|| "".equals(errors.getFieldValue("address.city").toString())) {
            errors.rejectValue("address.city", "invalid.city.format");
        }

        /* street - required field */
//      if (errors.getFieldValue("address.street") == null
//        		|| "".equals(errors.getFieldValue("address.street").toString())) {
//          errors.rejectValue("address.street", "invalid.street.format");
//      }

      /* number format validation*/
      if (!"".equals(errors.getFieldValue("address.number")) 
      		&& !"0".equals(errors.getFieldValue("address.number"))) {
      	 String addressNumber = String.valueOf(errors.getFieldValue("address.number"));
      	if (StringUtil.checkValidInt(addressNumber) == -1) {
	            errors.rejectValue("address.number", "invalid.housenumber.format");
      	}
      }

        /* zipCode format validation */
        String zipCodeRegex = countryProperties.getZipCodeRegex();
        if (errors.getFieldValue("address.zipCode") != null 
        		&&  !"".equals(errors.getFieldValue("address.zipCode"))) {
            if (!((String) errors.getFieldValue("address.zipCode")).matches(zipCodeRegex)) {
                errors.rejectValue("address.zipCode", "invalid.zipcode.format");
            }
        }
        
        /* phone and fax format validation */
//        String phoneRegex = countryProperties.getPhoneRegex();
//        if (errors.getFieldValue("address.telephone") != null
//        		&& !"".equals(errors.getFieldValue("address.telephone"))) {
//            if (!((String) errors.getFieldValue("address.telephone")).matches(phoneRegex)) {
//                errors.rejectValue("address.telephone", "invalid.telephone.format");
//            }
//        }
//        if (errors.getFieldValue("address.faxNumber") != null
//        		&& !"".equals(errors.getFieldValue("address.faxNumber"))) {
//            if (!((String) errors.getFieldValue("address.faxNumber")).matches(phoneRegex)) {
//                errors.rejectValue("address.faxNumber", "invalid.faxnumber.format");
//            }
//        }
        
        /* mobile phone - required field for ?? (if not organization) + format validation */
//        String mobilePhoneRegex = countryProperties.getMobilePhoneRegex();
//        if ("Y".equals((String)session.getAttribute("iMobilePhoneRequired"))
//        		&& errors.getFieldValue("address.addressTypeCode") != "4"
//        			&& errors.getFieldValue("address.addressTypeCode") != "5") {
//	        if (errors.getFieldValue("address.mobilePhone") == null 
//	        		|| "".equals(errors.getFieldValue("address.mobilePhone"))) {
//	            errors.rejectValue("address.mobilePhone", "invalid.mobilephone.format");
//	        }
//        } 
//        if (errors.getFieldValue("address.mobilePhone") != null
//        		&& !"".equals(errors.getFieldValue("address.mobilePhone"))) {
//            if (!((String) errors.getFieldValue("address.mobilePhone")).matches(mobilePhoneRegex)) {
//                errors.rejectValue("address.mobilePhone", "invalid.mobilephone.format");
//            }
//        }

	    /* emailAddress - required field for ?? (if not organization) + format validation */
//        if ("Y".equals((String)session.getAttribute("iEmailAddressRequired"))
        if (opusInit.getEmailAddressRequired()
        		&& errors.getFieldValue("address.addressTypeCode") != "4"
        			&& errors.getFieldValue("address.addressTypeCode") != "5") {
		    if (errors.getFieldValue("address.emailAddress") == null
		    		|| "".equals(errors.getFieldValue("address.emailAddress"))) {
	            errors.rejectValue("address.emailAddress", "invalid.email.format");
		    }
        }
        if (errors.getFieldValue("address.emailAddress") != null
        		&& !"".equals(errors.getFieldValue("address.emailAddress"))) {
	        if (!((String) errors.getFieldValue("address.emailAddress")).matches(EMAIL_REGEX)) {
	            errors.rejectValue("address.emailAddress", "invalid.email.format");
	        }
	    }
 
    }

}
