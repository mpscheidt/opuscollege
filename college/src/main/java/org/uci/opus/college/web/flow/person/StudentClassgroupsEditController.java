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

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentClassgroupsForm;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@SessionAttributes({ StudentClassgroupsEditController.FORM_NAME, AbstractStudentEditController.FORM_NAME_SHARED })
public class StudentClassgroupsEditController extends AbstractStudentEditController<StudentClassgroupsForm> {

	public static final String FORM_NAME = "studentClassgroupsForm";

	private static Logger log = LoggerFactory.getLogger(StudentClassgroupsEditController.class);

	@Autowired private SecurityChecker securityChecker;
	// @Autowired private CollegeServiceExtensions collegeServiceExtensions;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private LookupCacher lookupCacher;
	@Autowired private AcademicYearManagerInterface academicYearManager;

	public StudentClassgroupsEditController() {
	    super();
    }

    @Override
    protected StudentClassgroupsForm newFormInstance() {
        return new StudentClassgroupsForm();
    }

	/**
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/college/student-classgroups.view", method = RequestMethod.GET)
	public String setUpForm(ModelMap model, HttpServletRequest request) {

		if (log.isDebugEnabled()) {
			log.debug("setUpForm entered...");
		}

		HttpSession session = request.getSession(false);

		/*
		 * perform session-check. If wrong, this throws an Exception towards
		 * ErrorController
		 */
		securityChecker.checkSessionValid(session);

        StudentClassgroupsForm studentForm = super.setupFormShared(FORM_NAME, model, request);
        StudentFormShared shared = studentForm.getStudentFormShared();

        Student student = shared.getStudent();
        if (student == null) {
            throw new RuntimeException("No student given. Note: This screen is not applicable for the creation of new students.");
        }

		/* set menu to students */
		session.setAttribute("menuChoice", "students");

		/* with each call the preferred language may be changed */
		String preferredLanguage = OpusMethods.getPreferredLanguage(request);

		if (super.isNewForm()) {
		    
		    List<Integer> studyGradeTypeIds = DomainUtil.getIntProperties(student.getClassgroups(), "studyGradeTypeId");
		    studentForm.setStudyGradeTypes(studyManager.findStudyGradeTypes(studyGradeTypeIds, preferredLanguage));
		    
		    studentForm.setIdToAcademicYearMap(new IdToAcademicYearMap(academicYearManager.findAllAcademicYears()));
		    
		    studentForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
		}

		return FORM_VIEW;
	}

	@RequestMapping(value="/college/person/studentclassgroup_delete.view", method = RequestMethod.GET)
	public String processDelete(
			@ModelAttribute(FORM_NAME) StudentClassgroupsForm form,
			BindingResult result,
			SessionStatus status,
			HttpServletRequest request,
			ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        NavigationSettings navigationSettings = form.getStudentFormShared().getNavigationSettings();
        
        int classgroupId = Integer.parseInt(request.getParameter("classgroupId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));

        if (classgroupId != 0 && studentId != 0) {
        	// TODO: clarify if there are any conditions which prevent the deletion of a studentclassgroup.

        	String showError = "";
        	//showError = "test";
        	
            if (!"".equals(showError)) {
                return "redirect:/college/student-classgroups.view?newForm=true"
                		+ "&studentId=" + studentId
            			+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            			+ "&tab=" + navigationSettings.getTab() 
            			+ "&panel=" + navigationSettings.getPanel()    
            			+ "&showError=" + showError;
            } 
            
            studyManager.deleteStudentClassgroup(studentId, classgroupId);
            
            status.setComplete();
        }

        return "redirect:/college/student-classgroups.view?newForm=true"
        		+ "&studentId=" + studentId
    			+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
    			+ "&tab=" + navigationSettings.getTab() 
    			+ "&panel=" + navigationSettings.getPanel();    
    }
}
