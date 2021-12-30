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


import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.Study;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.StringUtil;


/**
 * Validator for {@link Study}.
 * 
 * @author MoVe
 */
public class StudyValidator implements Validator {

    @Override
    public boolean supports(final Class<?> clazz) {
        return Study.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {

        DateUtil du = new DateUtil();
        
        /* organizationalUnitId - required field */
        if ("".equals(errors.getFieldValue("study.organizationalUnitId").toString()) 
                || "0".equals(errors.getFieldValue("study.organizationalUnitId").toString())) {
            errors.rejectValue("study.organizationalUnitId",
            		"invalid.organizationalUnitId.format");
        }
        
        /* studyDescription - required field */
        if (StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.studyDescription"), true)) {
            errors.rejectValue("study.studyDescription", "invalid.studyDescription.format");
        }
        
        /* dateOfEstablishment - validity check only if not empty */
        if (!StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.dateOfEstablishment"))) {
            if (!(du.isValidDateString((String) errors.getFieldValue("study.dateOfEstablishment")))) {
                errors.rejectValue("study.dateOfEstablishment", "invalid.date.format");
            }
        }
        
        /* startDate - validity check only if not empty */
        if (!StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.startDate"))) {
            if (!(du.isValidDateString((String) errors.getFieldValue("study.startDate")))) {
                errors.rejectValue("study.startDate", "invalid.date.format");
            }
        }

//        if (StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.minimumMarkSubject"), true)) {
//            errors.rejectValue("study.minimumMarkSubject", "invalid.empty.format");
//        } else {
//            if (su.checkValidInt(errors.getFieldValue("study.minimumMarkSubject").toString()) == -1) {
//                if (su.checkValidDouble(errors.getFieldValue("study.minimumMarkSubject").toString()) == -1) {
//                    if (su.lrtrim(errors.getFieldValue("study.minimumMarkSubject").toString()).length() != 1) {
//                        errors.rejectValue("study.minimumMarkSubject", "invalid.mark.format");
//                    }
//                }
//            }
//        }

//        if (StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.maximumMarkSubject"), true)) {
//            errors.rejectValue("study.maximumMarkSubject", "invalid.empty.format");
//        } else {
//            if (su.checkValidInt(errors.getFieldValue("study.maximumMarkSubject").toString()) == -1) {
//                if (su.checkValidDouble(errors.getFieldValue("study.maximumMarkSubject").toString()) == -1) {
//                    if (su.lrtrim(errors.getFieldValue("study.maximumMarkSubject").toString()).length() != 1) {
//                        errors.rejectValue("study.maximumMarkSubject", "invalid.mark.format");
//                    }
//                }
//            }
//        }

//        if (StringUtil.isNullOrEmpty((String)errors.getFieldValue("study.BRsPassingSubject"), true)) {
//            errors.rejectValue("study.BRsPassingSubject", "invalid.empty.format");
//        } else {
//            if (su.checkValidInt(errors.getFieldValue("study.BRsPassingSubject").toString()) == -1) {
//                if (su.checkValidInt(errors.getFieldValue("study.BRsPassingSubject").toString()) == -1) {
//                    if (su.lrtrim(errors.getFieldValue("study.BRsPassingSubject").toString()).length() != 1) {
//                        errors.rejectValue("study.BRsPassingSubject", "invalid.mark.format");
//                    }
//                }
//            }
//        }

        du = null;
        
    }

}
