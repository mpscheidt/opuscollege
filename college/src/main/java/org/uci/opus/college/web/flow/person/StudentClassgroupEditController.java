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

package org.uci.opus.college.web.flow.person;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.StudentClassgroupFormValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentClassgroupForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@SessionAttributes({ StudentClassgroupEditController.FORM_NAME })
@RequestMapping("/college/person/studentclassgroup.view")
public class StudentClassgroupEditController {

	private final String viewName = "college/person/studentclassgroup";

	public static final String FORM_NAME = "studentClassgroupForm";

	private static Logger log = LoggerFactory.getLogger(StudentClassgroupEditController.class);

	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private LookupCacher lookupCacher;
	@Autowired private OpusInit opusInit;
	@Autowired private OpusMethods opusMethods;
	@Autowired private MessageSource messageSource;
	@Autowired private SecurityChecker securityChecker;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private StudentClassgroupFormValidator studentClassgroupFormValidator;
	
	@RequestMapping(method = RequestMethod.GET)
	protected final String setUpForm(HttpServletRequest request, ModelMap model) {

		HttpSession session = request.getSession(false);
		securityChecker.checkSessionValid(session);

        // TODO throw away form if studentId different, see StudentAddressesEditController
		opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

		/* set menu to studentclassgroup */
		session.setAttribute("menuChoice", "student");

		String preferredLanguage = OpusMethods.getPreferredLanguage(request);
		NavigationSettings navigationSettings = null;
		int studentId = 0; 
		int personId = 0;

		/* fetch or create the form object */
		StudentClassgroupForm studentClassgroupForm = (StudentClassgroupForm) model.get(FORM_NAME);
		if (studentClassgroupForm == null) {
			studentClassgroupForm = new StudentClassgroupForm();
			studentId = ServletUtil.getIntParam(request, "studentId", 0);
			studentClassgroupForm.setStudentId(studentId);
			if (studentId != 0) {
				Student student = studentManager.findStudent(preferredLanguage, studentId);
				if (student != null) {
					personId = student.getPersonId();
					studentClassgroupForm.setPersonId(personId);
					studentClassgroupForm.setStudent(student);
				}
			}

			model.put(FORM_NAME, studentClassgroupForm);
		} else {
			studentId = studentClassgroupForm.getStudentId();
			personId = studentClassgroupForm.getPersonId();
		}

		/* NAVIGATION SETTINGS - fetch or create the object */
		if (studentClassgroupForm.getNavigationSettings() != null) {
			navigationSettings = studentClassgroupForm.getNavigationSettings();
		} else {
			navigationSettings = new NavigationSettings();
			opusMethods.fillNavigationSettings(request, navigationSettings, null);
		}
		studentClassgroupForm.setNavigationSettings(navigationSettings);

		Map<String, Object> findStudiesMap = new HashMap<String, Object>();

		findStudiesMap.put("preferredLanguage", preferredLanguage);
		findStudiesMap.put("personId", personId);
		studentClassgroupForm.setAllStudies(studyManager.findStudies(findStudiesMap));

		findStudiesMap.put("studyId", studentClassgroupForm.getStudyId());
		findStudiesMap.put("currentAcademicYearId", studentClassgroupForm.getAcademicYearId());		
		studentClassgroupForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findStudiesMap));
		
		studentClassgroupForm.setIdToAcademicYearMap(new IdToAcademicYearMap(academicYearManager.findAllAcademicYears()));
		studentClassgroupForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));

		// academic years combo
		List<AcademicYear> allAcademicYears = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("studyId", studentClassgroupForm.getStudyId());
		allAcademicYears = studyManager.findAllAcademicYears(map);
		studentClassgroupForm.setAllAcademicYears(allAcademicYears);

		// reset academicYearId if not in list of available academic years (e.g.
		// after changing study filter selection)
		List<Integer> allAcademicYearIds = DomainUtil.getIds(allAcademicYears);
		if (!allAcademicYearIds.contains(studentClassgroupForm.getAcademicYearId())) {
			// set default academicyear to current year to filter large amounts
			// of subjects:
			AcademicYear currentAcademicYear = academicYearManager.getCurrentAcademicYear();
			if (allAcademicYearIds.contains(currentAcademicYear.getId())) {
				studentClassgroupForm.setAcademicYearId(currentAcademicYear.getId());
			}
		}

		// List of Classgroups
		List<Classgroup> allClassgroups = null;		
		int studyGradeTypeId = studentClassgroupForm.getStudyGradeTypeId();
		if (studyGradeTypeId != 0) {
			Map<String, Object> findClassgroupsMap = new HashMap<String, Object>();
			findClassgroupsMap.put("studyGradeTypeId", studentClassgroupForm.getStudyGradeTypeId());
			allClassgroups = studyManager.findClassgroups(findClassgroupsMap);
		}		

		studentClassgroupForm.setAllClassgroups(allClassgroups);

		return viewName;
	}
	
	@RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) StudentClassgroupForm studentClassgroupForm,
            BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
    	NavigationSettings navigationSettings = studentClassgroupForm.getNavigationSettings();
        
        String submitFormObject = request.getParameter("submitFormObject");
        submitFormObject = submitFormObject == null ? "" : submitFormObject;

        if ("true".equals(submitFormObject)) {
            int classgroupId = studentClassgroupForm.getClassgroupId();
            int studentId = studentClassgroupForm.getStudentId();

            // This should be moved to the validator. But how? 
            // The validator has not access to the request.
            if (studentId == 0) {
            	Locale currentLoc = RequestContextUtils.getLocale(request);
            	String studentTxt = messageSource.getMessage("general.student", new Object[] {}, currentLoc);
            	result.reject("jsp.lookup.alert.cannotbeempty.arg", new Object[] { studentTxt }, null);
            }

            studentClassgroupFormValidator.validate(studentClassgroupForm, result);

            if (result.hasErrors()) {
                return viewName;
            }
            
            String writeWho = opusMethods.getWriteWho(request);
            studyManager.addStudentClassgroup(studentId, classgroupId, writeWho);
            
            sessionStatus.setComplete();

            return "redirect:/college/student-classgroups.view?newForm=true"
                    + "&studentId=" + studentId
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                    + "&tab=" + navigationSettings.getTab() 
                    + "&panel=" + navigationSettings.getPanel();
        }
        
        return "redirect:/college/person/studentclassgroup.view";
    }
}