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
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.result.SubjectResult;


/**
 * Validator for {@link SubjectResult}.
 * 
 * @author MoVe
 */
public class SubjectResultValidator implements Validator {

    private MarkValidator markValidator;

    public SubjectResultValidator(BigDecimal minimumMarkValue, BigDecimal maximumMarkValue) {
        markValidator = new MarkValidator(minimumMarkValue, maximumMarkValue);
    }

    public SubjectResultValidator(String minimumMarkValue, String maximumMarkValue) {
        markValidator = new MarkValidator(minimumMarkValue, maximumMarkValue);
    }

    @Override
    public boolean supports(final Class<?> clazz) {
        return SubjectResult.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
    	
    	SubjectResult subjectResult = (SubjectResult) obj;

        /* required fields */
        if ("".equals(errors.getFieldValue("subjectId").toString()) 
                || "0".equals(errors.getFieldValue("subjectId").toString())) {
            errors.rejectValue("subjectId", "invalid.empty.format");
        }
        if ("".equals(errors.getFieldValue("staffMemberId").toString()) 
                || "0".equals(errors.getFieldValue("staffMemberId").toString())) {
            errors.rejectValue("staffMemberId", "invalid.empty.format");
        }

        // mark only needs to be validated if not a (negative) result has been generated with an intentionally empty mark
        if (subjectResult.getPassed() == null) {
        	markValidator.validate(errors.getFieldValue("mark"), errors);
        }
        
        /* subjectResultDate - required field & validity check */
        if ("".equals(errors.getFieldValue("subjectResultDate").toString())) {
            //if (!( StringUtil.isValidDate((Date)errors.getFieldValue("subjectResultDate")))) {
                errors.rejectValue("subjectResultDate", "invalid.date.format");
            //}
        }
        
    }

}
