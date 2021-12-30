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

package org.uci.opus.college.validator.result;

import org.springframework.validation.Errors;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.result.ExaminationResult;

/**
 * Validator for {@link ExaminationResult}.
 * Before calling {@link #validate(Object, Errors)}, be sure to set the authorization object
 * that corresponds to the examinationResult-to-be-validated.
 * 
 * @author MoVe
 * @author markus
 */
public class ExaminationResultValidator extends AbstractResultValidator<ExaminationResult> {

    public ExaminationResultValidator(String minimumMarkValue, String maximumMarkValue, OpusUser opusUser) {
        super(minimumMarkValue, maximumMarkValue, opusUser);
    }

    @Override
    public boolean supports(final Class<?> clazz) {
        return ExaminationResult.class.isAssignableFrom(clazz);
    }

    @Override
    protected void validateResult(final ExaminationResult examinationResult, final Errors errors) {
        
//        ExaminationResult examinationResult = (ExaminationResult) obj;
//
//        int id = examinationResult.getId();
//        if (id == 0) {
//            if (getAuthorization() == null || !getAuthorization().getCreate()) {
//                errors.reject("jsp.error.noauthorization.createresult");
//            }
//        } else {
//            if (getAuthorization() == null || !getAuthorization().getUpdate()) {
//                errors.reject("jsp.error.noauthorization.updateresult");
//            }
//        }
        
//        if (errors.hasErrors()) {
//            return;
//        }

        /* required fields */
        if (examinationResult.getExaminationId() == 0) {
            errors.rejectValue("examinationId", "invalid.empty.format");
        }
        if (examinationResult.getSubjectId() == 0) {
            errors.rejectValue("subjectId", "invalid.empty.format");
        }
//        int staffMemberId = examinationResult.getStaffMemberId();
//        if (staffMemberId == 0) {
//            errors.rejectValue("staffMemberId", "invalid.empty.format");
//        } else {
//            // check if selected staff member is authorized
//            StaffMember opusUserStaffMember = opusUser.getStaffMember();
//            int opusUserStaffMemberId = opusUserStaffMember != null ? opusUserStaffMember.getStaffMemberId() : 0;
//            if (getAuthorization().isStaffMemberLimitedToSelf() && staffMemberId != opusUserStaffMemberId) {
//                errors.rejectValue("staffMemberId", "jsp.error.noauthorization.selectedstaffmember");
//            }
//        }
//
//        markValidator.validate(errors.getFieldValue("mark"), errors);

        /* examinationResultDate - required field & validity check */
        if (examinationResult.getExaminationResultDate() == null) {
    		errors.rejectValue("examinationResultDate", "invalid.date.format");
    	}
        
    }

}
