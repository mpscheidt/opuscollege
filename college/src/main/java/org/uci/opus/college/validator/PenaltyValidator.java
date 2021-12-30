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

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.Penalty;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.StringUtil;

public class PenaltyValidator {

    Logger log = LoggerFactory.getLogger(PenaltyValidator.class);

    public boolean supports(final Class<?> clazz) {
        return Penalty.class.isAssignableFrom(clazz);
    }

    public void validate(final Object obj, final Errors errors) {
    
        DateUtil du = new DateUtil();
        
        if ("".equals(errors.getFieldValue("penalty.startDate"))) {
            errors.rejectValue("penalty.startDate", "invalid.empty.format");
        } else {
            if (!(du.isValidDateString((String) errors.getFieldValue("penalty.startDate")))) {
                errors.rejectValue("penalty.startDate", "invalid.date.format");
            }
        }
        
        if (!"".equals(errors.getFieldValue("penalty.endDate"))) {
            if (!(du.isValidDateString((String) errors.getFieldValue("penalty.endDate")))) {
                errors.rejectValue("penalty.endDate", "invalid.date.format");
            }
        }
        
        // startDate must come before endDate 
        if (!"".equals(errors.getFieldValue("penalty.startDate"))
                && du.isValidDateString((String) errors.getFieldValue("penalty.startDate"))
                && !"".equals(errors.getFieldValue("penalty.endDate"))
                && du.isValidDateString((String) errors.getFieldValue("penalty.endDate"))
                ) {
            Date startDate = du.parseSimpleDate((String) errors.getFieldValue("penalty.startDate"), "yyyy-MM-dd");
            Date endDate = du.parseSimpleDate((String) errors.getFieldValue("penalty.endDate"), "yyyy-MM-dd");
                
            if (startDate.compareTo(endDate) > 0) {
                errors.rejectValue("penalty.endDate", "jsp.error.enddatebefore");
            }
        }
        
        /* penaltyType.code - required field */
        if ("".equals(errors.getFieldValue("penalty.penaltyType.code").toString())
                || "0".equals(errors.getFieldValue("penalty.penaltyType.code").toString())) {
            errors.rejectValue("penalty.penaltyType.code", "invalid.empty.format");
        }
        
        if (errors.getFieldValue("penalty.amount") != null
                && 
                ("".equals(errors.getFieldValue("penalty.amount").toString()) 
                || "0".equals(errors.getFieldValue("penalty.amount").toString())
                )) {
            errors.rejectValue("penalty.amount", "invalid.zero.format");
        } else {
            String amountString = String.valueOf(errors.getFieldValue("penalty.amount"));
            if (StringUtil.checkValidDouble(amountString) == -1) {
                errors.rejectValue("penalty.amount", "invalid.amount.format"); 
            } else {
                Double amountDouble = Double.valueOf(amountString);
                if (amountDouble == 0.0) {
                    errors.rejectValue("penalty.amount", "invalid.zero.format");
//                } else {
//                    // used to check maximum value allowed
//                    BigDecimal amount = BigDecimal.valueOf(amountDouble);
//                    // used to check the maximum number of decimal places 
//                    BigDecimal movepoint = amount.movePointRight(OpusConstants.CREDIT_AMOUNT_DECIMAL_PLACES);
//                    
//                    if (amountDouble > OpusConstants.CREDIT_AMOUNT_MAX
//                            || movepoint.scale() != 0) {
//                        errors.rejectValue("penalty.amount", "invalid.amount.format");
//                    }
                }
            }
        }
        
//        su = null;
    }

}
