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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.persistence.StaffMemberMapper;
import org.uci.opus.util.DateUtil;


/**
 * Validator for {@link StaffMember}.
 * 
 * @author MoVe
 */
@Component
public class StaffMemberValidator implements Validator {

    private Logger log = LoggerFactory.getLogger(StaffMemberValidator.class);
    
    @Autowired private StaffMemberMapper staffMemberMapper;

    @Override
    public boolean supports(final Class<?> clazz) {
        return StaffMember.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
    	
    	StaffMember staffMember = (StaffMember) obj;

        DateUtil du = new DateUtil();

        /* primaryUnitOfAppointmentId - required field */
        if ("0".equals(errors.getFieldValue("primaryUnitOfAppointmentId").toString())) {
            errors.rejectValue("primaryUnitOfAppointmentId",
            			"invalid.organizationalUnitId.format");
        }
        /* surnameFull - required field */
        if ("".equals(errors.getFieldValue("surnameFull").toString())) {
            errors.rejectValue("surnameFull", "invalid.surnamefull.format");
        }
        /* firstnamesFull - required field */
        if ("".equals(errors.getFieldValue("firstnamesFull").toString())) {
            errors.rejectValue("firstnamesFull", "invalid.firstnames.format");
        }
        /* gender - required field & validity check */
        if ("".equals(errors.getFieldValue("genderCode").toString())
                || "0".equals(errors.getFieldValue("genderCode").toString())) {
            errors.rejectValue("genderCode", "invalid.empty.format");
        } else {
            if (!"1".equals(errors.getFieldValue("genderCode").toString())
                    && !"2".equals(errors.getFieldValue("genderCode").toString())) {
                 errors.rejectValue("genderCode", "invalid.gender.format");
            }
        }
        /* birthdate - required field & validity check */
        //if (!"".equals(errors.getFieldValue("birthdate"))) {
            /*if (!(su.isValidDate((Date) errors.getFieldValue("birthdate")))) {
                errors.rejectValue("birthdate", "invalid.date.format");
            }*/
        	if (!(du.isPastDateString((String) errors.getFieldValue("birthdate")))) {
        		errors.rejectValue("birthdate", "invalid.date.past");
        	}
        //}
        
        /* identificationDateOfIssue - validity check only if not empty */
        if (!"".equals(errors.getFieldValue("identificationDateOfIssue"))) {
            /*if (!(su.isValidDate((Date) errors.getFieldValue("identificationDateOfIssue")))) {
                errors.rejectValue("identificationDateOfIssue", "invalid.date.format");
            }*/
        	if (!(du.isPastDateString((String) errors.getFieldValue("identificationDateOfIssue")))) {
        		errors.rejectValue("identificationDateOfIssue", "invalid.date.past");
        	}
        }
        
        /* startWorkDay - validity check only if not empty */
        if (errors.getFieldValue("startWorkDay") != null &&
                !"".equals(errors.getFieldValue("startWorkDay").toString())) {
           String strTime = errors.getFieldValue("startWorkDay").toString();
           int hours = Integer.parseInt(strTime.substring(0, 2));
           int minutes = Integer.parseInt(strTime.substring(3,5));
           if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
               errors.rejectValue("startWorkDay", "invalid.time.format");
           }
        }
        
        /* endWorkDay - validity check only if not empty */
        if (errors.getFieldValue("startWorkDay") != null &&
                !"".equals(errors.getFieldValue("endWorkDay").toString())) {
           String strTime = errors.getFieldValue("endWorkDay").toString();
           int hours = Integer.parseInt(strTime.substring(0, 2));
           int minutes = Integer.parseInt(strTime.substring(3,5));
           if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
               errors.rejectValue("endWorkDay", "invalid.time.format");
           }
        }
        
        /* identificationDateOfExpiration - validity check only if not empty */
        if (!"".equals(errors.getFieldValue("identificationDateOfExpiration"))) {
            /*if (!(su.isValidDate((Date) errors.getFieldValue(
            			"identificationDateOfExpiration")))) {
                errors.rejectValue("identificationDateOfExpiration", "invalid.date.format");
            }*/
        	if (!(du.isFutureDateString((String) errors.getFieldValue(
        					"identificationDateOfExpiration")))) {
        		errors.rejectValue("identificationDateOfExpiration", "invalid.date.future");
        	}
        }

        // prevent duplicate staffMemberCode
        if (staffMemberMapper.alreadyExistsStaffMemberCode(staffMember.getStaffMemberCode(), staffMember.getStaffMemberId())) {
        	errors.rejectValue("staffMemberCode", "jsp.error.general.alreadyexists");
        }
        
    }

}
