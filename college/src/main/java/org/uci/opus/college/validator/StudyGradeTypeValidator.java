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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;


/**
 * Validator for {@link StudyGradeType}.
 * 
 * @author MoVe
 */
@Component
public class StudyGradeTypeValidator implements Validator {
	
	@Autowired
	private StudyManagerInterface studyManager;

    @Override
    public boolean supports(final Class<?> clazz) {
        return StudyGradeType.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(final Object obj, final Errors errors) {
    	
    	this.onBindAndValidate(null, obj, errors);
    }

    public void onBindAndValidate(HttpServletRequest request, 
    		final Object obj, final Errors errors) {
    	
        HttpSession session = request.getSession(false);

        /* studyId - required field */
        if ("".equals(errors.getFieldValue("studyId").toString())) {
            errors.rejectValue("studyId", "invalid.study.format");
        }
        
        /* gradeTypeCode - required field */
        if ("".equals(errors.getFieldValue("gradeTypeCode").toString())
        		|| "0".equals(errors.getFieldValue("gradeTypeCode").toString())) {
            errors.rejectValue("gradeTypeCode", "invalid.gradetype.format");
        }
        
        /* currentAcademicYearId - required field */
        if ("".equals(errors.getFieldValue("currentAcademicYearId").toString())
        		|| "0".equals(errors.getFieldValue("currentAcademicYearId").toString())) {
            errors.rejectValue("currentAcademicYearId", "invalid.empty.format");
        }

        /* studyTimeCode - required field */
        if ("".equals(errors.getFieldValue("studyTimeCode").toString())
        		|| "0".equals(errors.getFieldValue("studyTimeCode").toString())) {
            errors.rejectValue("studyTimeCode", "invalid.empty.format");
        }
        
        /* studyFormCode - required field */
        if ("".equals(errors.getFieldValue("studyFormCode").toString())
                || "0".equals(errors.getFieldValue("studyFormCode").toString())) {
            errors.rejectValue("studyFormCode", "invalid.empty.format");
        }

        /* studyIntensityCode - required field if use of fulltime / parttime */
        if ("Y".equals((String)session.getAttribute("iUseOfPartTimeStudyGradeTypes"))) {
	        if ("".equals(errors.getFieldValue("studyIntensityCode").toString())
	        		|| "0".equals(errors.getFieldValue("studyIntensityCode").toString())) {
	            errors.rejectValue("studyIntensityCode", "invalid.empty.format");
	        }
        }

        /* cardinalTimeUnitCode - required field */
        if ("".equals(errors.getFieldValue("cardinalTimeUnitCode").toString())
        		|| "0".equals(errors.getFieldValue("cardinalTimeUnitCode").toString())) {
            errors.rejectValue("cardinalTimeUnitCode", "invalid.cardinaltimeunit.format");
        }

        /* numberOfCardinalTimeUnits - required field */
        if ("".equals(errors.getFieldValue("numberOfCardinalTimeUnits").toString())
                || "0".equals(errors.getFieldValue("numberOfCardinalTimeUnits").toString())) {
            errors.rejectValue("numberOfCardinalTimeUnits", "invalid.empty.format");
        }

        // Always allow resetting the studyGradeTypeCode (to null).
        // If non-empty studyGradeTypeCode is given, it shall be unique within the same academic year
        StudyGradeType studyGradeType = (StudyGradeType) obj;
        if (StringUtils.isBlank(studyGradeType.getStudyGradeTypeCode())) {
            studyGradeType.setStudyGradeTypeCode(null);
        } else if (studyManager.alreadyExistsStudyGradeTypeCode(studyGradeType)) {
        	errors.rejectValue("studyGradeTypeCode", "jsp.error.studygradetypecode.exists");
        }

    }

}
