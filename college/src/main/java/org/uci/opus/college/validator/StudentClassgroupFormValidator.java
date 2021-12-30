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

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.person.StudentClassgroupForm;

@Component
public class StudentClassgroupFormValidator implements Validator {

	@Autowired private StudyManagerInterface studyManager;
	
	@Override
    public boolean supports(final Class<?> clazz) {
        return StudentClassgroupForm.class.isAssignableFrom(clazz);
    }

	@Override
    public void validate(final Object obj, final Errors errors) {
    	
    	StudentClassgroupForm form = (StudentClassgroupForm)obj;

    	int classgroupId = form.getClassgroupId();
    	int studentId = form.getStudentId();
    	
        if (classgroupId == 0) {
            errors.rejectValue("classgroupId", "invalid.empty.format");
        }
        
		Map<String, Object> findMap = new HashMap<>();
		findMap.put("classgroupIds", Arrays.asList(classgroupId));
		List<Classgroup> classgroups = studyManager.findClassgroups(findMap);
		if (classgroups != null && !classgroups.isEmpty()) {
			int studyGradeTypeId = classgroups.get(0).getStudyGradeTypeId();
			
			findMap.clear();
			findMap.put("studentId", studentId);		
			findMap.put("studyGradeTypeId", studyGradeTypeId);		
			classgroups = studyManager.findClassgroups(findMap);
			
			if (classgroups != null) {
				for (Classgroup otherClassgroup : classgroups) {
					if (otherClassgroup.getId() == classgroupId) {
						// Student is already in this classgroup
						errors.rejectValue("classgroupId", "jsp.error.studentclassgroup.isalreadyinclassgroup");
					} else {
						// Student is in another classgroup of the same year
						errors.rejectValue("classgroupId", "jsp.error.studentclassgroup.isinanotherclassgroup", new Object[] { otherClassgroup.getDescription() }, null);
					}
				}
			}
		}
    }
}
