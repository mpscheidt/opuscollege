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
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.util.DateUtil;

public class StudentExpulsionValidator {
    
    Logger log = LoggerFactory.getLogger(StaffMemberValidator.class);

    /** 
     * {@inheritDoc}.
     * @see org.springframework.validation.Validator#supports(java.lang.Class)
     */
    public boolean supports(final Class<?> clazz) {
        return StaffMember.class.isAssignableFrom(clazz);
    }

    /**
     *  {@inheritDoc}.
     * @see org.springframework.validation.Validator#validate(
     *          java.lang.Object, org.springframework.validation.Errors)
     */
    public void validate(final Object obj, final Errors errors) {
    
        DateUtil du = new DateUtil();
        
        if ("".equals(errors.getFieldValue("studentExpulsion.startDate"))) {
            errors.rejectValue("studentExpulsion.startDate", "invalid.empty.format");
        } else {
            if (!(du.isValidDateString((String) errors.getFieldValue("studentExpulsion.startDate")))) {
                errors.rejectValue("studentExpulsion.startDate", "invalid.date.format");
            }
        }
        
        if (!"".equals(errors.getFieldValue("studentExpulsion.endDate"))) {
            if (!(du.isValidDateString((String) errors.getFieldValue("studentExpulsion.endDate")))) {
                errors.rejectValue("studentExpulsion.endDate", "invalid.date.format");
            }
        }
        
        // startDate must come before endDate 
        if (!"".equals(errors.getFieldValue("studentExpulsion.startDate"))
                && du.isValidDateString((String) errors.getFieldValue("studentExpulsion.startDate"))
                && !"".equals(errors.getFieldValue("studentExpulsion.endDate"))
                && du.isValidDateString((String) errors.getFieldValue("studentExpulsion.endDate"))
                ) {
            Date startDate = du.parseSimpleDate((String) errors.getFieldValue("studentExpulsion.startDate"), "yyyy-MM-dd");
            Date endDate = du.parseSimpleDate((String) errors.getFieldValue("studentExpulsion.endDate"), "yyyy-MM-dd");
                
            if (startDate.compareTo(endDate) > 0) {
                errors.rejectValue("studentExpulsion.endDate", "jsp.error.enddatebefore");
            }
        }
        
        /* expulsionType.code - required field */
        if ("".equals(errors.getFieldValue("studentExpulsion.expulsionType.code").toString())
                || "0".equals(errors.getFieldValue("studentExpulsion.expulsionType.code").toString())) {
            errors.rejectValue("studentExpulsion.expulsionType.code", "invalid.empty.format");
        }
    }

}
