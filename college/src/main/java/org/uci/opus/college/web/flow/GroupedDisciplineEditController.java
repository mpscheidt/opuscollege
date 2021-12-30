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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.domain.GroupedDiscipline;
import org.uci.opus.college.persistence.DisciplineGroupMapper;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.GroupedDisciplineForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;


@Controller
@RequestMapping("/college/groupedDiscipline.view")
@SessionAttributes({"groupedDisciplineForm"})
public class GroupedDisciplineEditController {
    
    private static Logger log = LoggerFactory.getLogger(GroupedDisciplineEditController.class);
    private String formView;
    @Autowired private DisciplineGroupMapper disciplineGroupMapper;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;

    public GroupedDisciplineEditController() {
        super();
		this.formView = "admin/groupedDiscipline";
    }

    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, @RequestParam("groupId") int groupId) {
        
        // declare variables
        GroupedDisciplineForm groupedDisciplineForm = null;
        DisciplineGroup disciplineGroup = null;
        
        NavigationSettings navigationSettings = null;
        
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        opusMethods.removeSessionFormObject("groupedDisciplineForm", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if ((GroupedDisciplineForm) session.getAttribute("groupedDisciplineForm") != null) {
            
        	groupedDisciplineForm = (GroupedDisciplineForm) session.getAttribute("groupedDisciplineForm");
        
        } else {
        
        	groupedDisciplineForm = new GroupedDisciplineForm();
        }

       	disciplineGroup = disciplineGroupMapper.findById(groupId);

       	Map<String, Object> findDisciplinesMap = new HashMap<>();
            
       	findDisciplinesMap.put("lang", preferredLanguage);
      	findDisciplinesMap.put("disciplineGroupId", disciplineGroup.getId());
      	
        groupedDisciplineForm.setDisciplinesNotInGroup(studyManager.findDisciplinesNotInGroup(disciplineGroup.getId(), preferredLanguage));
            
        groupedDisciplineForm.setDisciplineGroup(disciplineGroup);
        
        if (groupedDisciplineForm.getNavigationSettings() != null) {
        	navigationSettings = groupedDisciplineForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        
        groupedDisciplineForm.setNavigationSettings(navigationSettings);

        model.addAttribute("groupedDisciplineForm", groupedDisciplineForm);        
        
        return formView;
    }

    /**
     * @param groupedDisciplineForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("groupedDisciplineForm") GroupedDisciplineForm groupedDisciplineForm
    		, @RequestParam("disciplinesCodes") String[] disciplinesCodes
            , SessionStatus status, HttpServletRequest request) { 

    	HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

    	NavigationSettings navigationSettings = groupedDisciplineForm.getNavigationSettings();

        DisciplineGroup disciplineGroup = groupedDisciplineForm.getDisciplineGroup();
        
        List<GroupedDiscipline> groupedDisciplines = new ArrayList<>();
        
        int groupId = disciplineGroup.getId();
            
        for(String disciplineCode: disciplinesCodes){
        	
        	GroupedDiscipline gd = new GroupedDiscipline();
        	
        	gd.setActive("Y");
        	gd.setDisciplineGroupId(groupId);
        	gd.setDisciplineCode(disciplineCode);
        	gd.setWriteWho(opusMethods.getWriteWho(request));
        	
        	groupedDisciplines.add(gd);
        
        }

        if(!groupedDisciplines.isEmpty())
        	studyManager.addGroupedDisciplines(groupedDisciplines);
            
            	
             status.setComplete();
                	
            return "redirect:/college/disciplinegroup.view?newForm=true&groupId=" + groupId
            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            + "&tab=1"
            ;
        }

    }

