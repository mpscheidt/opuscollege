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


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.ListUtil;


/**
 * Validator for {@link Fee}.
 * 
 * @author MoVe
 * @author Markus
 */
@Component
public class FeeAcademicYearValidator implements Validator {

    private static Logger log = LoggerFactory.getLogger(FeeAcademicYearValidator.class);

    @Autowired private FeeManagerInterface feeManager;

//    public FeeAcademicYearValidator(FeeManagerInterface feeManager){
//    	this.feeManager = feeManager;
//    }
//
    public boolean supports(Class<?> clazz) {
        return Fee.class.isAssignableFrom(clazz);
    }

    public void validate(Object obj, Errors errors) {

        Fee fee = (Fee) obj;
        Map<String, Object> findFeeMap = new HashMap<String, Object>();
        findFeeMap.put("id", fee.getId());
   //     findFeeMap.put("branchId", fee.getBranchId());
        findFeeMap.put("academicYearId", fee.getAcademicYearId());
        findFeeMap.put("categoryCode", fee.getCategoryCode());

        /* required fields */
        if ("".equals(errors.getFieldValue("categoryCode").toString()) 
                || "0".equals(errors.getFieldValue("categoryCode").toString())
        ) {
        	errors.rejectValue("categoryCode", "invalid.empty.format");
        }
        if ("".equals(errors.getFieldValue("feeDue").toString()) 
                || "0.0".equals(errors.getFieldValue("feeDue").toString())) {
            errors.rejectValue("feeDue", "invalid.number.format");
        }
//        if ("".equals(errors.getFieldValue("numberOfInstallments").toString())
//            	|| "0".equals(errors.getFieldValue("numberOfInstallments").toString())) {
//            errors.rejectValue("numberOfInstallments", "invalid.number.format");
//        } 
//        if ("".equals(errors.getFieldValue("localStudentDiscountPercentage").toString()))
//			{            errors.rejectValue("localStudentDiscountPercentage", "invalid.empty.format");
//		}
        if ("".equals(errors.getFieldValue("academicYearId").toString()) 
                        || "0".equals(errors.getFieldValue("academicYearId").toString())
         ) {
            errors.rejectValue("academicYearId", "invalid.id.format");
         }

        // TODO: a fee of a specific category can only occur once per academic year/study intensity 
        // /study time / study form nationality group / ctu (if not "Any")
        if(fee.getAcademicYearId() !=0 && !fee.getCategoryCode().equals("0")) {
	        List < Fee > feeList = feeManager.findFeeByAcademicYearAndCategoryCode(findFeeMap);
	        // this fee is already excluded in query, so if the list is not empty, the error occurs
	        if (!ListUtil.isNullOrEmpty(feeList)) {
	            errors.rejectValue("academicYearId", "jsp.error.fee.academicyearcategorycode.exist");
	        	errors.rejectValue("categoryCode", "jsp.error.fee.academicyearcategorycode.exist");
	        }
        }

        ValidationUtils.rejectIfEmpty(errors, "feeUnitCode", "invalid.empty.format");

    }

}
