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
import org.uci.opus.college.domain.Penalty;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.validator.PenaltyValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.PenaltyForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;


@Controller
@RequestMapping("/college/penalty.view")
@SessionAttributes("penaltyForm")
 public class PenaltyEditController {
    
     private static Logger log = LoggerFactory.getLogger(PenaltyEditController.class);
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private StudentManagerInterface studentManager;
     @Autowired private LookupManagerInterface lookupManager;
     @Autowired private OpusMethods opusMethods;
     private String formView;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public PenaltyEditController() {
        super();
        this.formView = "college/person/penalty";
    }


    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("PenaltyEditController.setUpForm entered...");
        }
        // declare variables
        PenaltyForm penaltyForm = null;
        Student student = null;
        NavigationSettings navSettings = null;
        
        HttpSession session = request.getSession(false);   
        Penalty penalty = null;
        int penaltyId = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // when entering a new form, destroy any existing objectForms on the session
        opusMethods.removeSessionFormObject("penaltyForm", session, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        /* fetch or create the form object */
        penaltyForm = new PenaltyForm();
        // entering the form: the PenaltyForm.penalty does not exist yet
        // get the penaltyId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("penaltyId"))) {
            penaltyId = Integer.parseInt(request.getParameter("penaltyId"));
        }
        // EXISTING Penalty
        if (penaltyId != 0) {
            penalty = studentManager.findPenalty(penaltyId, preferredLanguage);
        } else {
            penalty = new Penalty();
            penalty.setStudentId(Integer.parseInt(request.getParameter("studentId")));
        }
        penaltyForm.setPenalty(penalty);
        
        if (penalty.getStudentId() != 0) {
            student = studentManager.findStudent(preferredLanguage
                                                , penalty.getStudentId());
            penaltyForm.setStudent(student);
        }

        /* NAVIGATIONSETTINGS - create the object */
        navSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navSettings, null);
        penaltyForm.setNavigationSettings(navSettings);

        List < ? extends Lookup > allPenaltyTypes = 
        (List < ? extends Lookup >) lookupManager.findAllRows(preferredLanguage, "penaltyType");
        penaltyForm.setAllPenaltyTypes(allPenaltyTypes);
            
        model.addAttribute("penaltyForm", penaltyForm);        
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("penaltyForm") PenaltyForm penaltyForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

        Penalty penalty = penaltyForm.getPenalty();
        NavigationSettings navSettings = penaltyForm.getNavigationSettings();
        int tab= navSettings.getTab();
        int panel = navSettings.getPanel();
        int currentPageNumber = navSettings.getCurrentPageNumber();

        new PenaltyValidator().validate(penaltyForm, result);
        if (result.hasErrors()) {
            return formView;
        }
        
        if (penalty.getId() == 0) {
            studentManager.addPenalty(penalty);
        } else {
            studentManager.updatePenalty(penalty);
        }

        status.setComplete();
        return "redirect:/college/student-absences.view?newForm=true&tab=" + tab + "&panel=" + panel 
                                                + "&studentId=" + penalty.getStudentId()
                                                + "&currentPageNumber=" + currentPageNumber;
    }

}
