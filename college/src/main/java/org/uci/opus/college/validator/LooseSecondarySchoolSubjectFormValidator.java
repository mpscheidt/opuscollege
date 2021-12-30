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


import java.util.HashMap;
import java.util.Map;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.LooseSecondarySchoolSubject;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.SecondarySchoolSubjectForm;
import org.uci.opus.util.StringUtil;


public class LooseSecondarySchoolSubjectFormValidator implements Validator {

	private StudyManagerInterface studyManager;
	
	public LooseSecondarySchoolSubjectFormValidator(StudyManagerInterface studyManager){
		this.studyManager = studyManager;
	}
	
	@Override
    public boolean supports(final Class<?> clazz) {
        return SecondarySchoolSubjectForm.class.isAssignableFrom(clazz);
    }

	@Override
    public void validate(final Object obj, final Errors errors) {
    	
    	SecondarySchoolSubjectForm form = (SecondarySchoolSubjectForm)obj;
    	LooseSecondarySchoolSubject subject = form.getLooseSecondarySchoolSubject();
    	
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "looseSecondarySchoolSubject.code", "invalid.empty.format");
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "looseSecondarySchoolSubject.description", "invalid.empty.format");
    	ValidationUtils.rejectIfEmptyOrWhitespace(errors, "looseSecondarySchoolSubject.active", "invalid.empty.format");
    	
		if (!StringUtil.isNullOrEmpty(subject.getCode(), true)) {

			// check if there is a subject with code
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("code", subject.getCode());

			LooseSecondarySchoolSubject repeatedSubject = studyManager.findLooseSecondarySchoolSubject(map);

			if ((repeatedSubject != null)
					&& (repeatedSubject.getId() != subject.getId())) {
				errors.rejectValue("looseSecondarySchoolSubject.code",
						"jsp.error.general.alreadyexists");
			}
		}
    }

}
