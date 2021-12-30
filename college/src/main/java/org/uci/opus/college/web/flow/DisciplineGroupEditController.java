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

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.persistence.DisciplineGroupMapper;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.DisciplineGroupValidator;
import org.uci.opus.college.web.form.DisciplineGroupForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: SecondarySchoolEditController.
 */

@Controller
@RequestMapping("/college/disciplinegroup.view")
@SessionAttributes({"disciplineGroupForm"})
public class DisciplineGroupEditController {
    
    private static Logger log = LoggerFactory.getLogger(DisciplineGroupEditController.class);
    private String formView;
    @Autowired private DisciplineGroupMapper disciplineGroupMapper;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupManagerInterface lookupManager;

    public DisciplineGroupEditController() {
        super();
		this.formView = "admin/disciplineGroup";
    }

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException 
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {
        
        // declare variables
        DisciplineGroupForm disciplineGroupForm = null;
        DisciplineGroup disciplineGroup = null;
        
        NavigationSettings navigationSettings = null;
        
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new disciplineGroup, destroy any existing one on the session
        opusMethods.removeSessionFormObject("disciplineGroupForm", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        int groupId = ServletUtil.getIntParam(request, "groupId", 0);

        /* disciplineGroupFORM - fetch or create the form object and fill it with disciplineGroup */
        if ((DisciplineGroupForm) session.getAttribute("disciplineGroupForm") != null) {
            
        	disciplineGroupForm = (DisciplineGroupForm) session.getAttribute("disciplineGroupForm");
        
        } else {
        
        	disciplineGroupForm = new DisciplineGroupForm();
        }

        if(groupId == 0) {
        
        	disciplineGroup = disciplineGroupForm.createNewDisciplineGroup(); 

        } else { 
        	
        	disciplineGroup = disciplineGroupMapper.findById(groupId);
        	
        	Map<String ,Object> findDisciplinesMap = new HashMap<>();
            
        	findDisciplinesMap.put("lang", preferredLanguage);
        	findDisciplinesMap.put("disciplineGroupId", disciplineGroup.getId());
        	
            disciplineGroup.setDisciplines(studyManager.findDisciplinesForGroup(findDisciplinesMap));
         }

        disciplineGroupForm.setDisciplineGroup(disciplineGroup);
        
        /* DisciplineGroupFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (disciplineGroupForm.getNavigationSettings() != null) {
        	navigationSettings = disciplineGroupForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        disciplineGroupForm.setNavigationSettings(navigationSettings);

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtErr"))) {
        	disciplineGroupForm.setTxtErr(disciplineGroupForm.getTxtErr() + 
        			ServletRequestUtils.getStringParameter(
                            request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtMsg"))) {
        	disciplineGroupForm.setTxtMsg(disciplineGroupForm.getTxtErr() + 
        			ServletRequestUtils.getStringParameter(
                            request, "txtMsg"));
        }


        model.addAttribute("disciplineGroupForm", disciplineGroupForm);        
        
        return formView;
    }

    /**
     * @param disciplineGroupForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("disciplineGroupForm") DisciplineGroupForm disciplineGroupForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

    	NavigationSettings navigationSettings = disciplineGroupForm.getNavigationSettings();

        DisciplineGroup disciplineGroup = disciplineGroupForm.getDisciplineGroup();
        
        int id = disciplineGroup.getId();
            
       new DisciplineGroupValidator(disciplineGroupMapper).validate(disciplineGroupForm, result);            
            
            if (result.hasErrors()) {

            	return formView;
            	
            } else {

            	if(id == 0){
            		id = disciplineGroupMapper.add(disciplineGroup);
            	} else {
            	    disciplineGroupMapper.update(disciplineGroup);
            	}
            	
                status.setComplete();
            }
                	
            return "redirect:/college/disciplinegroup.view?newForm=true&groupId=" + id
            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            ;
        }
    
    @RequestMapping(method = RequestMethod.GET, params = "task=deleteDiscipline")
	public String deleteDiscipline(
			@RequestParam("disciplineCode") String disciplineCode
			, @RequestParam("disciplineGroupId") int disciplineGroupId
			, ModelMap model,
			HttpServletRequest request) {

		HttpSession session = request.getSession(false);

		/*
		 * perform session-check. If wrong, this throws an Exception towards
		 * ErrorController
		 */
		securityChecker.checkSessionValid(session);

		DisciplineGroupForm disciplineGroupForm = (DisciplineGroupForm) session
				.getAttribute("disciplineGroupForm");

		NavigationSettings navigationSettings = disciplineGroupForm.getNavigationSettings();

		studyManager.deleteGroupedDiscipline(disciplineGroupId, disciplineCode);

        return "redirect:/college/disciplinegroup.view?newForm=true&groupId=" + disciplineGroupId
        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
        + "&tab=1"
        ;

	}


    }

