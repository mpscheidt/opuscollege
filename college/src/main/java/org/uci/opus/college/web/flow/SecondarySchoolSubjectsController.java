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

package org.uci.opus.college.web.flow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.service.QueryUtilitiesManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SecondarySchoolSubjectsForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@SessionAttributes({"secondarySchoolSubjectsForm"})
public class SecondarySchoolSubjectsController {
    
     private static Logger log = LoggerFactory.getLogger(SecondarySchoolSubjectsController.class);
    
     private String formView;
     
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private OpusMethods opusMethods;
     @Autowired private StudyManagerInterface studyManager;
     @Autowired private StudyMapper studyMapper;
     @Autowired private QueryUtilitiesManagerInterface queryManager;
     @Autowired private MessageSource messageSource;
    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public SecondarySchoolSubjectsController() {
		super();
		this.formView = "college/subject/secondarySchoolSubjects";
	}

	@RequestMapping(value="/college/secondaryschoolsubjects.view", method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            {
    	
    	SecondarySchoolSubjectsForm secondarySchoolSubjectsForm = null;
    	Organization organization = null;
        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        opusMethods.removeSessionFormObject("secondarySchoolSubjectsForm", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        /* secondarySchoolSubjectsForm - fetch or create the form object and fill it 
         *     with organization and navigationSettings */
        if ((SecondarySchoolSubjectsForm) session.getAttribute("secondarySchoolSubjectsForm") != null) {
        	secondarySchoolSubjectsForm = (SecondarySchoolSubjectsForm) session.getAttribute("secondarySchoolSubjectsForm");
        } else {
        	secondarySchoolSubjectsForm = new SecondarySchoolSubjectsForm();
        }

        /* ORGANIZATION - fetch or create the object */
        if (secondarySchoolSubjectsForm.getOrganization() != null) {
        	organization = secondarySchoolSubjectsForm.getOrganization();
        } else {
        	organization = new Organization();
            
        	int organizationalUnitId = (Integer) session.getAttribute("organizationalUnitId");
            int branchId = (Integer) session.getAttribute("branchId");
            int institutionId = (Integer) session.getAttribute("institutionId");
            organization = opusMethods.fillOrganization(session, request, organization, 
            		organizationalUnitId, branchId, institutionId);
        }
        secondarySchoolSubjectsForm.setOrganization(organization);

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (secondarySchoolSubjectsForm.getNavigationSettings() != null) {
        	navigationSettings = secondarySchoolSubjectsForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "secondaryschoolsubjects.view");
        	
        }
        secondarySchoolSubjectsForm.setNavigationSettings(navigationSettings);

        /* Catch errormessages */
        if (!StringUtil.isNullOrEmpty(request.getParameter("txtErr"))) {
        	secondarySchoolSubjectsForm.setTxtErr(request.getParameter("txtErr"));
        }

       
        HashMap<String, Object> findSubjectsMap = new HashMap<>();
        
        findSubjectsMap.put("searchValue", navigationSettings.getSearchValue());        
        
        secondarySchoolSubjectsForm.setSecondarySchoolSubjects(studyMapper.findSecondarySchoolSubjectsAsMaps(findSubjectsMap));
        		

        model.addAttribute("secondarySchoolSubjectsForm", secondarySchoolSubjectsForm);
        
        return formView; 
    }
 
	@RequestMapping(value="/college/secondaryschoolsubjects.view", method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("secondarySchoolSubjectsForm") SecondarySchoolSubjectsForm secondarySchoolSubjectsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

    	NavigationSettings navigationSettings = secondarySchoolSubjectsForm.getNavigationSettings();

        Organization organization = secondarySchoolSubjectsForm.getOrganization();
        HttpSession session = request.getSession(false);        

        secondarySchoolSubjectsForm.clearErrorMessages();

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId",organization.getOrganizationalUnitId());
        session.setAttribute("branchId",organization.getBranchId());
        session.setAttribute("institutionId",organization.getInstitutionId());

        
   	 	return "redirect:/college/secondaryschoolsubjects.view?" 
   	 			+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    
	@RequestMapping(value="/college/secondaryschoolsubject_delete.view", method=RequestMethod.GET)
    public String deleteSubject(@RequestParam("subjectId") int subjectId, ModelMap model, HttpServletRequest request){
   	 
    	HttpSession session = request.getSession(false);        
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController   */
        securityChecker.checkSessionValid(session);
        
        SecondarySchoolSubjectsForm secondarySchoolSubjectsForm = (SecondarySchoolSubjectsForm) session.getAttribute("secondarySchoolSubjectsForm");

        Locale currentLoc = RequestContextUtils.getLocale(request);

        List<String> errorMessages = new ArrayList<>();
        
     //count gradedSecondaryschoolSubject which depend on this secondary school subject
     int gradedSecondarySchoolSubjects = queryManager.countValue("gradedsecondaryschoolsubject", "secondaryschoolsubjectid", subjectId);
     //count gropuedSecondaryschoolSubject which depend on this secondary school subject
     int groupedSecondarySchoolSubjects =  queryManager.countValue("groupedSecondarySchoolSubject", "secondaryschoolsubjectid", subjectId);
	 
     if(gradedSecondarySchoolSubjects > 0) {
 		String tableName = messageSource.getMessage("jsp.general.secondaryschoolsubjects.grades" ,null, currentLoc);
    
		String errorMessage = messageSource.getMessage("jsp.error.secondaryschoolsubject.delete.args",
    			new Object[]{"", gradedSecondarySchoolSubjects, tableName},
    			currentLoc
    			);
		
		errorMessages.add(errorMessage);
		
     } 
     
     if(groupedSecondarySchoolSubjects > 0) {
 		String tableName = messageSource.getMessage("jsp.general.secondaryschoolsubjects.groups" ,null, currentLoc);
    
		String errorMessage = messageSource.getMessage("jsp.error.secondaryschoolsubject.delete.args",
    			new Object[]{"", groupedSecondarySchoolSubjects, tableName},
    			currentLoc
    			);
		
		errorMessages.add(errorMessage);
     }
     
     if(errorMessages.size() > 0) {	
     	secondarySchoolSubjectsForm.setErrorMessages(errorMessages);
     } else {
     	log.info("Deleting record with id " + subjectId);
    	studyManager.deleteLooseSecondarySchoolSubjectById(subjectId);
     }
     
     model.addAttribute("secondarySchoolSubjectsForm", secondarySchoolSubjectsForm);
 			
     return "redirect:/college/secondaryschoolsubjects.view?" 
			+ "&currentPageNumber=" + secondarySchoolSubjectsForm.getNavigationSettings().getCurrentPageNumber();
 }


}
