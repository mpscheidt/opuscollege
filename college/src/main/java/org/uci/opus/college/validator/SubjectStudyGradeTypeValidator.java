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
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.util.StringUtil;

/**
 * Validator for {@link SubjectStudyGradeType}.
 *
 * @author J. Nooitgedagt
 */
public class SubjectStudyGradeTypeValidator implements Validator {

    @SuppressWarnings("unused")
    private static Logger log = LoggerFactory.getLogger(SubjectStudyGradeTypeValidator.class);

    @Override
    public boolean supports(final Class<?> clazz) {
        return SubjectStudyGradeType.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
        
        /* studyId - required field */
        if ("".equals(errors.getFieldValue("subjectStudyGradeType.studyId").toString())
                || "0".equals(errors.getFieldValue("subjectStudyGradeType.studyId").toString())) {
            errors.rejectValue("subjectStudyGradeType.studyId", "invalid.study.format");
        }
        
        /* subjectId - required field */
        if ("".equals(errors.getFieldValue("subjectStudyGradeType.subjectId").toString())
                || "0".equals(errors.getFieldValue("subjectStudyGradeType.subjectId").toString())) {
            errors.rejectValue("subjectStudyGradeType.subjectId", "invalid.subject.format");
        }
        
        /* gradeTypeCode - required field */
        if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("subjectStudyGradeType.gradeTypeCode").toString())
                || "0".equals(errors.getFieldValue("subjectStudyGradeType.gradeTypeCode").toString())) {
            errors.rejectValue("subjectStudyGradeType.gradeTypeCode", "invalid.empty.format");
        }
        
        /* studyGradeTypeId - required field */
        if ("".equals(errors.getFieldValue("subjectStudyGradeType.studyGradeTypeId").toString())
                || "0".equals(errors.getFieldValue("subjectStudyGradeType.studyGradeTypeId").toString())) {
            errors.rejectValue("subjectStudyGradeType.studyGradeTypeId", "invalid.empty.format");
        }

        /* rigidityTypeCode - required field - check after study and gradeType are filled */
        if (!"0".equals(errors.getFieldValue("subjectStudyGradeType.studyId").toString())
        	&& !"".equals(errors.getFieldValue("subjectStudyGradeType.gradeTypeCode").toString())) {
		        if ("".equals(errors.getFieldValue("subjectStudyGradeType.rigidityTypeCode").toString())
		                || "0".equals(errors.getFieldValue("subjectStudyGradeType.rigidityTypeCode").toString())) {
		            errors.rejectValue("subjectStudyGradeType.rigidityTypeCode", "invalid.empty.format");
		        }
        }

        ValidationUtils.rejectIfEmpty(errors, "subjectStudyGradeType.cardinalTimeUnitNumber", "invalid.empty.format");

    }

}
