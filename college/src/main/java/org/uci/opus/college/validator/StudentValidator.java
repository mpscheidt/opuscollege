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
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.persistence.StudentMapper;
import org.uci.opus.config.CountryProperties;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.StringUtil;

/**
 * Validator for {@link Student}.
 * 
 * @author MoVe
 */
@Component
public class StudentValidator implements Validator {

	@Autowired
	private CountryProperties countryProperties;

	@Autowired
	private StudentMapper studentMapper;

	@SuppressWarnings("unused")
	private static Logger log = LoggerFactory.getLogger(StudentValidator.class);

	@Override
	public boolean supports(final Class<?> clazz) {
		return Student.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(final Object obj, final Errors errors) {
		
		Student student = (Student) obj;

		DateUtil du = new DateUtil();

		/* surnameFull - required field */
		if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("surnameFull"))) {
			errors.rejectValue("surnameFull", "invalid.surnamefull.format");
		}
		/* firstnamesFull - required field */
		if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("firstnamesFull"))) {
			errors.rejectValue("firstnamesFull", "invalid.firstnames.format");
		}
		/* gender - required field & validity check */
		Object genderCode = errors.getFieldValue("genderCode");
		if (genderCode == null || "".equals(genderCode.toString()) || "0".equals(genderCode.toString())) {
			errors.rejectValue("genderCode", "invalid.empty.format");
		} else {
			if (!"1".equals(genderCode.toString()) && !"2".equals(genderCode.toString())) {
				errors.rejectValue("genderCode", "invalid.gender.format");
			}
		}

		/* primaryStudyId - required field */
		if ("".equals(errors.getFieldValue("primaryStudyId").toString())
				|| "0".equals(errors.getFieldValue("primaryStudyId").toString())) {
			errors.rejectValue("primaryStudyId", "invalid.primarystudy.format");
		}

		/* identificationTypeCode - required field */
		// when adding a student, this field is not known yet
		if (errors.getFieldValue("identificationTypeCode") != null) {
			if (!"".equals(errors.getFieldValue("identificationTypeCode").toString())) {
				if ("0".equals(errors.getFieldValue("identificationTypeCode").toString())) {
					errors.rejectValue("identificationTypeCode", "invalid.identificationtype.format");
				}
				/* identificationNumber - required field */
				if ("".equals(errors.getFieldValue("identificationNumber").toString())) {
					errors.rejectValue("identificationNumber", "invalid.identificationnumber.format");
				}
			}
		}

		/* identificationDateOfIssue - validity check only if not empty */
		if (!StringUtil.isNullOrEmpty((String) errors.getFieldValue("identificationDateOfIssue"))) {
			/*
			 * if (!(du.isValidDateString((String)errors.getFieldValue(
			 * "identificationDateOfIssue")))) {
			 * errors.rejectValue("identificationDateOfIssue",
			 * "invalid.date.format"); }
			 */
			if (!(du.isPastDateString((String) errors.getFieldValue("identificationDateOfIssue")))) {
				errors.rejectValue("identificationDateOfIssue", "invalid.date.past");
			}
		}
		/* identificationDateOfExpiration - validity check only if not empty */
		if (!StringUtil.isNullOrEmpty((String) errors.getFieldValue("identificationDateOfExpiration"))) {
			/*
			 * if (!(du.isValidDateString((String)errors.getFieldValue(
			 * "identificationDateOfExpiration")))) {
			 * errors.rejectValue("identificationDateOfExpiration",
			 * "invalid.date.format"); }
			 */
			if (!(du.isFutureDateString((String) errors.getFieldValue("identificationDateOfExpiration")))) {
				errors.rejectValue("identificationDateOfExpiration", "invalid.date.future");
			}
		}

		// prevent duplicate studentCode
		if (studentMapper.alreadyExistsStudentCode(student.getStudentCode(), student.getStudentId())) {
			errors.rejectValue("studentCode", "jsp.error.studentcode.alreadyexists");
		}
	}

}
