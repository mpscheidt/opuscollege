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
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.persistence.DisciplineGroupMapper;
import org.uci.opus.college.web.form.DisciplineGroupsForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@SessionAttributes({"disciplineGroupsForm"})
public class DisciplineGroupsController {
    
     private static Logger log = LoggerFactory.getLogger(DisciplineGroupsController.class);
    
     private String formView;
     
     @Autowired private DisciplineGroupMapper disciplineGroupMapper;
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private OpusMethods opusMethods;

     public DisciplineGroupsController() {
		super();
		this.formView = "admin/disciplineGroups";
	}

	@RequestMapping(value="/college/disciplinegroups.view", method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	
    	DisciplineGroupsForm disciplineGroupsForm = null;
    	Organization organization = null;
        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        opusMethods.removeSessionFormObject("disciplineGroupsForm", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        /* disciplineGroupsForm - fetch or create the form object and fill it 
         *     with organization and navigationSettings */
        if ((DisciplineGroupsForm) session.getAttribute("disciplineGroupsForm") != null) {
        	disciplineGroupsForm = (DisciplineGroupsForm) session.getAttribute("disciplineGroupsForm");
        } else {
        	disciplineGroupsForm = new DisciplineGroupsForm();
        }

        /* ORGANIZATION - fetch or create the object */
        if (disciplineGroupsForm.getOrganization() != null) {
        	organization = disciplineGroupsForm.getOrganization();
        } else {
        	organization = new Organization();
            
        	int organizationalUnitId = (Integer) session.getAttribute("organizationalUnitId");
            int branchId = (Integer) session.getAttribute("branchId");
            int institutionId = (Integer) session.getAttribute("institutionId");
            organization = opusMethods.fillOrganization(session, request, organization, 
            		organizationalUnitId, branchId, institutionId);
        }
        disciplineGroupsForm.setOrganization(organization);

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (disciplineGroupsForm.getNavigationSettings() != null) {
        	navigationSettings = disciplineGroupsForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "disciplinegroups.view");
        	
        }
        disciplineGroupsForm.setNavigationSettings(navigationSettings);

        /* Catch errormessages */
        if (!StringUtil.isNullOrEmpty(request.getParameter("txtErr"))) {
        	disciplineGroupsForm.setTxtErr(request.getParameter("txtErr"));
        }

       
        Map<String, Object> findSubjectsMap = new HashMap<>();

        findSubjectsMap.put("searchValue", navigationSettings.getSearchValue());        

        disciplineGroupsForm.setDisciplineGroups(disciplineGroupMapper.findDisciplineGroups(findSubjectsMap));
        		

        model.addAttribute("disciplineGroupsForm", disciplineGroupsForm);
        
        return formView; 
    }
 
	@RequestMapping(value="/college/disciplinegroups.view", method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("disciplineGroupsForm") DisciplineGroupsForm disciplineGroupsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

    	NavigationSettings navigationSettings = disciplineGroupsForm.getNavigationSettings();

        Organization organization = disciplineGroupsForm.getOrganization();
        HttpSession session = request.getSession(false);        

        disciplineGroupsForm.clearErrorMessages();

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId",organization.getOrganizationalUnitId());
        session.setAttribute("branchId",organization.getBranchId());
        session.setAttribute("institutionId",organization.getInstitutionId());

        
   	 	return "redirect:/college/disciplinegroups.view?" 
   	 			+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    
	@RequestMapping(value="/college/disciplinegroup_delete.view", method=RequestMethod.GET)
    public String deleteSubject(@RequestParam("groupId") int groupId, ModelMap model, HttpServletRequest request){
   	 
    	HttpSession session = request.getSession(false);        
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController   */
        securityChecker.checkSessionValid(session);
        
        DisciplineGroupsForm disciplineGroupsForm = (DisciplineGroupsForm) session.getAttribute("disciplineGroupsForm");

        List<String> errorMessages = new ArrayList<>();
        
     
     if(errorMessages.size() > 0) {	
     	disciplineGroupsForm.setErrorMessages(errorMessages);
     } else {

    	disciplineGroupMapper.deleteById(groupId);
     }
     
     model.addAttribute("disciplineGroupsForm", disciplineGroupsForm);
 			
     return "redirect:/college/disciplinegroups.view?" 
			+ "&currentPageNumber=" + disciplineGroupsForm.getNavigationSettings().getCurrentPageNumber();
 }


}
