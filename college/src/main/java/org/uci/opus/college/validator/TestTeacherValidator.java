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

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;


/**
 * Validator for {@link TestTeacher}.
 * 
 * @author MoVe
 */
@Component
public class TestTeacherValidator implements Validator {

	@Autowired private TestManagerInterface testManager;
	@Autowired private StudyManagerInterface studyManager;

    /** 
     * {@inheritDoc}.
     * @see org.springframework.validation.Validator#supports(java.lang.Class)
     */
    public boolean supports(final Class<?> clazz) {
    	return TestTeacher.class.isAssignableFrom(clazz);
    }

    /**
     *  {@inheritDoc}.
     * @see org.springframework.validation.Validator#validate(
     * 			java.lang.Object, org.springframework.validation.Errors)
     */
    public void validate(final Object obj, final Errors errors) {
    	TestTeacher testTeacher = (TestTeacher) obj;
    	
        if (testTeacher.getStaffMemberId() == 0) {
            errors.rejectValue("staffMemberId", "invalid.empty.format");
        }
        if (testTeacher.getTestId() == 0) {
            errors.rejectValue("testId", "invalid.empty.format");
        }
        
        // check, if this test / classgroup is already assigned to the teacher
        if (!errors.hasErrors()) {
        	List<TestTeacher> testTeachers = testManager.findTeachersForTest(testTeacher.getTestId());
        	for (TestTeacher existingTestTeacher : testTeachers) {
        		if (existingTestTeacher.getStaffMemberId() == testTeacher.getStaffMemberId()) {
        			int classgroupId = testTeacher.getClassgroupId() != null ? testTeacher.getClassgroupId() : 0;
        			int existingClassgroupId = existingTestTeacher.getClassgroupId() != null ? existingTestTeacher.getClassgroupId() : 0;
        			if ((classgroupId == 0 && existingClassgroupId != 0) || (classgroupId != 0 && existingClassgroupId == 0)) {
        				Test test = testManager.findTest(testTeacher.getTestId());
        				errors.rejectValue(null, "jsp.error.testteacher.alreadyexists", new Object[] { test.getTestCode() }, null);
        			} else if (classgroupId == existingClassgroupId) {
        				Test test = testManager.findTest(testTeacher.getTestId());
        				if (classgroupId == 0) {
        					errors.rejectValue(null, "jsp.error.testteacher.alreadyexists", new Object[] { test.getTestCode() }, null);
        				} else {
        					Classgroup classgroup = studyManager.findClassgroupById(classgroupId);
        					errors.rejectValue(null, "jsp.error.testteacher.alreadyexistswithclass", new Object[] { test.getTestCode(), classgroup.getDescription() }, null);
        				}
    				}
        		}
        	}
        }
    }

}
