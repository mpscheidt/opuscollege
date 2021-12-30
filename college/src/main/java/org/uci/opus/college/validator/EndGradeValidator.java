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


import java.math.BigDecimal;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.EndGrade;


public class EndGradeValidator implements Validator {

    @Override
    public boolean supports(final Class<?> clazz) {
        return EndGrade.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
    	
    	EndGrade endGrade = (EndGrade)obj;

    	BigDecimal percentageMin = endGrade.getPercentageMin();
    	BigDecimal percentageMax = endGrade.getPercentageMax();
    	BigDecimal gradePoint = endGrade.getGradePoint();
    	
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "code", "invalid.empty.format"); 
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "endGradeTypeCode", "invalid.empty.format");
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "academicYearId", "invalid.empty.format");
    	
    	if(endGrade.getAcademicYearId() == 0)
    		errors.rejectValue("academicYearId", "invalid.empty.format");
    	
        if(percentageMin != null && percentageMin.compareTo(BigDecimal.ZERO) < 0) {
    		errors.rejectValue("percentageMin", "invalid.invalid");
        }
    	
        if(percentageMax != null && percentageMax.compareTo(BigDecimal.ZERO) < 0) {
    		errors.rejectValue("percentageMax", "invalid.invalid");
        }

        if(percentageMin != null && percentageMax != null && percentageMin.compareTo(percentageMax) > 0) {
    		errors.rejectValue("percentageMin", "invalid.cantbegreaterthanmaxpercentage");
        }

        if(gradePoint != null && gradePoint.compareTo(BigDecimal.ZERO) < 0) {
            errors.rejectValue("gradePoint", "invalid.invalid");
        }
        
    }

}
