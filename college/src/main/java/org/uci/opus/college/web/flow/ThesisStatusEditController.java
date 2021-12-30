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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisStatus;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.validator.ThesisStatusValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.ThesisStatusForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/thesisstatus.view")
@SessionAttributes({"thesisStatusForm"})
public class ThesisStatusEditController {
    
    private static Logger log = LoggerFactory.getLogger(ThesisStatusEditController.class);
    private String formView;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private ThesisStatusValidator thesisStatusValidator;

    public ThesisStatusEditController() {
        super();
        this.formView = "college/person/thesisstatus";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("ThesisStatusEditController.setUpForm entered...");  
        }
        
        int thesisId = 0;
        Thesis thesis = null;
        int thesisStatusId = 0;
        int studyPlanId = 0;
        int studentId = 0;
        StudyPlan studyPlan = null;
        Student student = null;
        ThesisStatus thesisStatus;
        NavigationSettings navigationSettings = null;
        List < ? extends Lookup > allThesisStatuses = null;
                    
        HttpSession session = request.getSession(false);
        
        // if adding a new thesis supervisor, destroy any existing one on the session
        opusMethods.removeSessionFormObject("thesisStatusForm", session
                                                    , opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        ThesisStatusForm thesisStatusForm = new ThesisStatusForm();
        
        allThesisStatuses = (List < ? extends Lookup >) lookupManager.findAllRows(
                                                        preferredLanguage, "thesisStatus");
        thesisStatusForm.setAllThesisStatuses(allThesisStatuses);

        if (!StringUtil.isNullOrEmpty(request.getParameter("thesisStatusId"))) {
            thesisStatusId = Integer.parseInt(request.getParameter("thesisStatusId"));
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
            student = studentManager.findStudent(preferredLanguage, studentId);
            thesisStatusForm.setStudent(student);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyPlanId"))) {
            studyPlanId = Integer.parseInt(request.getParameter("studyPlanId"));
            studyPlan = studentManager.findStudyPlan(studyPlanId);
            thesisStatusForm.setStudyPlan(studyPlan);
        }
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("thesisId"))) {
            thesisId = Integer.parseInt(request.getParameter("thesisId"));
            thesis = studentManager.findThesis(thesisId);
            thesisStatusForm.setThesis(thesis);
        }

        navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, null);
        thesisStatusForm.setNavigationSettings(navigationSettings);

        if (thesisStatusId != 0) {
            thesisStatus = studentManager.findThesisStatus(thesisStatusId);
            thesisStatusForm.setThesisStatus(thesisStatus);
        }

        model.addAttribute("thesisStatusForm", thesisStatusForm);
   
        return formView;
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("thesisStatusForm") ThesisStatusForm thesisStatusForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) 
            {
  
        if (log.isDebugEnabled()) {
            log.debug("ThesisStatusEditController.processSubmit entered...");  
        }

        thesisStatusValidator.onBindAndValidate(request, thesisStatusForm, result);
        if (result.hasErrors()) {
           
            return formView;
        } else {
            NavigationSettings navigationSettings = thesisStatusForm.getNavigationSettings();
            ThesisStatus thesisStatus = thesisStatusForm.getThesisStatus();
            
            int thesisId = thesisStatusForm.getThesis().getId();
            thesisStatus.setThesisId(thesisId);
            
    
            if (thesisStatus.getId() == 0) {
                studentManager.addThesisStatus(thesisStatus);
            } else {
                studentManager.updateThesisStatus(thesisStatus);
            }
            
            return "redirect:/college/thesis.view?newForm=true&thesisId=" + thesisId
                + "&studyPlanId=" + thesisStatusForm.getStudyPlan().getId()
                + "&studentId=" + thesisStatusForm.getStudent().getStudentId()
                + "&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel() + "&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
        }
    }
}

