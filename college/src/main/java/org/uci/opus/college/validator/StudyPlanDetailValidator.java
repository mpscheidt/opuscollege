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
import org.uci.opus.college.domain.StudyPlanDetail;



/**
 * Validator for {@link StudyPlanDetail}.
 * 
 * @author MoVe
 */
public class StudyPlanDetailValidator implements Validator {

    @Override
    public boolean supports(final Class<?> clazz) {
        return StudyPlanDetail.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {

        
        /* studyPlanId - required field */
        if ("".equals(errors.getFieldValue("studyPlanDetail.studyPlanId").toString())
                || "0".equals(errors.getFieldValue("studyPlanDetail.studyPlanId").toString())) {
            errors.rejectValue("studyPlanDetail.studyPlanId", "invalid.studyplan.format");
        }
        
        /* studyPlanCardinalTimeUnitId - required field */
        if ("".equals(errors.getFieldValue("studyPlanDetail.studyPlanCardinalTimeUnitId").toString())
                || "0".equals(errors.getFieldValue("studyPlanDetail.studyPlanCardinalTimeUnitId").toString())) {
            errors.rejectValue("studyPlanDetail.studyPlanCardinalTimeUnitId", "invalid.empty.format");
        }

        /* academicYearId - required field */
//        if ("".equals(errors.getFieldValue("academicYearId").toString())
//        		|| "-".equals(errors.getFieldValue("academicYearId").toString())) {
//            errors.rejectValue("academicYearId", "invalid.empty.format");
//        }

        /* either subjectId or subjectBlockId is required */
//        if (
//        		(
//        		"".equals(errors.getFieldValue("subjectId").toString())
//                || "0".equals(errors.getFieldValue("subjectId").toString())
//        		)
//            && 
//        		(
//            	"".equals(errors.getFieldValue("subjectBlockId").toString())
//            	|| "0".equals(errors.getFieldValue("subjectBlockId").toString())
//        		)
//        	) {
//            errors.rejectValue("subjectId", "invalid.studyplan.format");
//            errors.rejectValue("subjectBlockId", "invalid.studyplan.format");
//        }
//        if (
//        	(!"0".equals(errors.getFieldValue("subjectId").toString()))  
//        		&& (!"0".equals(errors.getFieldValue("subjectBlockId").toString()))
//        	)
//        		{
//            errors.rejectValue("subjectId", "invalid.studyplan.subject.subjectblock.format");
//        }

    }

}
