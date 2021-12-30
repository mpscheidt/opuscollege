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
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisSupervisor;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.ThesisSupervisorForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/thesissupervisor.view")
@SessionAttributes({"thesisSupervisorForm"})
public class ThesisSupervisorEditController {
    
    private static Logger log = LoggerFactory.getLogger(ThesisSupervisorEditController.class);
    private String formView;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private OpusMethods opusMethods;

    public ThesisSupervisorEditController() {
        super();
        this.formView = "college/person/thesissupervisor";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
        
        if (log.isDebugEnabled()) {
            log.debug("ThesisSupervisorEditController.setUpForm entered...");  
        }
        
        int thesisId = 0;
        Thesis thesis = null;
        int thesisSupervisorId = 0;
        int studyPlanId = 0;
        int studentId = 0;
        StudyPlan studyPlan = null;
        Student student = null;
        ThesisSupervisor thesisSupervisor;
        NavigationSettings navigationSettings = null;
        
        HttpSession session = request.getSession(false);
        
        // if adding a new thesis supervisor, destroy any existing one on the session
        opusMethods.removeSessionFormObject("thesisSupervisorForm", session
                                                    , opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        ThesisSupervisorForm thesisSupervisorForm = new ThesisSupervisorForm();
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("thesisSupervisorId"))) {
            thesisSupervisorId = Integer.parseInt(request.getParameter("thesisSupervisorId"));
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
            student = studentManager.findStudent(preferredLanguage, studentId);
            thesisSupervisorForm.setStudent(student);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyPlanId"))) {
            studyPlanId = Integer.parseInt(request.getParameter("studyPlanId"));
            studyPlan = studentManager.findStudyPlan(studyPlanId);
            thesisSupervisorForm.setStudyPlan(studyPlan);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("thesisId"))) {
            thesisId = Integer.parseInt(request.getParameter("thesisId"));
            thesis = studentManager.findThesis(thesisId);
            thesisSupervisorForm.setThesis(thesis);
        }

        navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, null);
        thesisSupervisorForm.setNavigationSettings(navigationSettings);

        if (thesisSupervisorId != 0) {
            thesisSupervisor = studentManager.findThesisSupervisor(thesisSupervisorId);
            thesisSupervisorForm.setThesisSupervisor(thesisSupervisor);
        }

        model.addAttribute("thesisSupervisorForm", thesisSupervisorForm);
   
        return formView;
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("thesisSupervisorForm") ThesisSupervisorForm thesisSupervisorForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {
  
        if (log.isDebugEnabled()) {
            log.debug("ThesisSupervisorEditController.processSubmit entered...");  
        }

        NavigationSettings navigationSettings = thesisSupervisorForm.getNavigationSettings();
        ThesisSupervisor thesisSupervisor = thesisSupervisorForm.getThesisSupervisor();
        
        int thesisId = thesisSupervisorForm.getThesis().getId();
        thesisSupervisor.setThesisId(thesisId);

            if (thesisSupervisor.getPrincipal().equals(OpusConstants.GENERAL_YES)) {
                // update other thesisSupervisors to "N"
                studentManager.updateThesisSupervisorsPrincipal(thesisSupervisor.getThesisId()
                        , OpusConstants.GENERAL_NO);
            }
            if (thesisSupervisor.getId() == 0) {
                studentManager.addThesisSupervisor(thesisSupervisor);
            } else {
                studentManager.updateThesisSupervisor(thesisSupervisor);
            }

            return "redirect:/college/thesis.view?newForm=true&thesisId=" + thesisId 
                + "&studyPlanId=" + thesisSupervisorForm.getStudyPlan().getId()
                + "&studentId=" + thesisSupervisorForm.getStudent().getStudentId()
                + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel() + "&currentPageNumber=" 
                + navigationSettings.getCurrentPageNumber();
    }
}
