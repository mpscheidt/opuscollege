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

package org.uci.opus.college.web.flow.subject;

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
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectClassgroupFormValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.subject.SubjectClassgroupForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@SessionAttributes({ SubjectClassgroupEditController.FORM_NAME })
@RequestMapping("/college/subject/subjectclassgroup.view")
public class SubjectClassgroupEditController {

	private final String viewName = "college/subject/subjectclassgroup";

	public static final String FORM_NAME = "subjectClassgroupForm";

	private static Logger log = LoggerFactory.getLogger(SubjectClassgroupEditController.class);

	@Autowired private OpusMethods opusMethods;
	@Autowired private MessageSource messageSource;
	@Autowired private SecurityChecker securityChecker;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private SubjectManagerInterface subjectManager;
	@Autowired private SubjectClassgroupFormValidator subjectClassgroupFormValidator;
	
	@RequestMapping(method = RequestMethod.GET)
	protected final String setUpForm(HttpServletRequest request, ModelMap model) {

		HttpSession session = request.getSession(false);
		securityChecker.checkSessionValid(session);
		opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

		/* set menu to subjectclassgroup */
		session.setAttribute("menuChoice", "subject");

		String preferredLanguage = OpusMethods.getPreferredLanguage(request);
		NavigationSettings navigationSettings = null;
		Subject subject = null;
		StudyGradeType studyGradeType = null;

		/* fetch or create the form object */
		SubjectClassgroupForm subjectClassgroupForm = (SubjectClassgroupForm) model.get(FORM_NAME);
		if (subjectClassgroupForm == null) {
			subjectClassgroupForm = new SubjectClassgroupForm();
			int subjectId = ServletUtil.getIntParam(request, "subjectId", 0);
			int studyGradeTypeId = ServletUtil.getIntParam(request, "studyGradeTypeId", 0);
			int subjectStudyGradeTypeId = ServletUtil.getIntParam(request, "subjectStudyGradeTypeId", 0);
			
			if (subjectId != 0) {
				subject = subjectManager.findSubject(subjectId);
				subjectClassgroupForm.setSubject(subject);
			}
			if (studyGradeTypeId != 0) {
				studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
				subjectClassgroupForm.setStudyGradeType(studyGradeType);
			}
			subjectClassgroupForm.setSubjectStudyGradeTypeId(subjectStudyGradeTypeId);
			model.put(FORM_NAME, subjectClassgroupForm);
		} else {
			subject = subjectClassgroupForm.getSubject();
			studyGradeType = subjectClassgroupForm.getStudyGradeType();
		}

		/* NAVIGATION SETTINGS - fetch or create the object */
		if (subjectClassgroupForm.getNavigationSettings() != null) {
			navigationSettings = subjectClassgroupForm.getNavigationSettings();
		} else {
			navigationSettings = new NavigationSettings();
			opusMethods.fillNavigationSettings(request, navigationSettings, null);
		}
		subjectClassgroupForm.setNavigationSettings(navigationSettings);

		// List of Classgroups
		List<Classgroup> allClassgroups = null;		
		if (studyGradeType != null) {
			Map<String, Object> findClassgroupsMap = new HashMap<String, Object>();
			findClassgroupsMap.put("studyGradeTypeId", studyGradeType.getId());
			allClassgroups = studyManager.findClassgroups(findClassgroupsMap);

			// remove already assigned classgroups
			findClassgroupsMap.put("subjectId", subject.getId());
			List<Classgroup> assignedClassgroups = studyManager.findClassgroups(findClassgroupsMap);
			for (Classgroup classgroup : allClassgroups.toArray(new Classgroup[allClassgroups.size()])) {
				for (Classgroup classgroupAssigned : assignedClassgroups) {
					if (classgroupAssigned.getId() == classgroup.getId()) {
						allClassgroups.remove(classgroup);
					}
				}
			}
		}

		subjectClassgroupForm.setAllClassgroups(allClassgroups);

		return viewName;
	}
	
	@RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) SubjectClassgroupForm subjectClassgroupForm,
            BindingResult result, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
    	NavigationSettings navigationSettings = subjectClassgroupForm.getNavigationSettings();
        
        String submitFormObject = request.getParameter("submitFormObject");
        submitFormObject = submitFormObject == null ? "" : submitFormObject;

        if ("true".equals(submitFormObject)) {
        	Subject subject = subjectClassgroupForm.getSubject();
            int classgroupId = subjectClassgroupForm.getClassgroupId();
            int subjectId = subject != null ? subject.getId() : 0;

            // This should be moved to the validator. But how? 
            // The validator has not access to the request.
            if (subjectId == 0) {
            	Locale currentLoc = RequestContextUtils.getLocale(request);
            	String subjectTxt = messageSource.getMessage("jsp.general.subject", new Object[] {}, currentLoc);
            	result.reject("jsp.lookup.alert.cannotbeempty.arg", new Object[] { subjectTxt }, null);
            }

            subjectClassgroupFormValidator.validate(subjectClassgroupForm, result);

            if (result.hasErrors()) {
                return viewName;
            }
            
            String writeWho = opusMethods.getWriteWho(request);
            studyManager.addSubjectClassgroup(subjectId, classgroupId, writeWho);
            
            sessionStatus.setComplete();

            return "redirect:/college/subjectstudygradetype.view"
                    + "?subjectStudyGradeTypeId=" + subjectClassgroupForm.getSubjectStudyGradeTypeId()
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                    + "&tab=" + navigationSettings.getTab() 
                    + "&panel=" + navigationSettings.getPanel();
        }
        
        return "redirect:/college/subject/subjectclassgroup.view";
    }
}