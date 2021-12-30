/*******************************************************************************
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
 * The Original Code is Opus-College fee module code.
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
 ******************************************************************************/
package org.uci.opus.fee.validators;


import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.fee.domain.Fee;


/**
 * Validator for {@link Fee}.
 * 
 * @author MoVe
 */
@Component
public class FeeStudyGradeTypeValidator implements Validator {

    private static Logger log = LoggerFactory.getLogger(FeeStudyGradeTypeValidator.class);

    public boolean supports(Class<?> clazz) {
        return Fee.class.isAssignableFrom(clazz);
    }

    public void validate(Object obj, Errors errors) {

        Fee fee = (Fee) obj;

        String categoryCode = fee.getCategoryCode();
        if ("".equals(categoryCode) || "0".equals(categoryCode)) {
        	errors.rejectValue("categoryCode", "invalid.id.format");
        }

        int studyGradeTypeId = fee.getStudyGradeTypeId();
        if (studyGradeTypeId == 0) {
            errors.rejectValue("studyGradeTypeId", "invalid.id.format");
        }

        BigDecimal feeDue = fee.getFeeDue();
        if (feeDue == null || "".equals(feeDue)
                || feeDue.doubleValue() == 0) {
            errors.rejectValue("feeDue", "invalid.number.format");
        }

        //ValidationUtils.rejectIfEmpty(errors, "deadline", "invalid.empty.format");

//        int numberOfInstallments = fee.getNumberOfInstallments();
//        if (numberOfInstallments == 0) {
//            errors.rejectValue("numberOfInstallments", "invalid.number.format");
//        } 

        ValidationUtils.rejectIfEmpty(errors, "feeUnitCode", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "nationalityGroupCode", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "tuitionWaiverDiscountPercentage", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "fulltimeStudentDiscountPercentage", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "localStudentDiscountPercentage", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "continuedRegistrationDiscountPercentage", "invalid.empty.format");
//        ValidationUtils.rejectIfEmpty(errors, "postgraduateDiscountPercentage", "invalid.empty.format");

    }

}
