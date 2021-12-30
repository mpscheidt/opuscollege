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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.ObtainedQualificationValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.StudyPlanForm;
import org.uci.opus.util.OpusMethods;

@Controller
@RequestMapping("/obtained_qualification.view")
@SessionAttributes({"studyPlanForm"})
public class ObtainedQualificationEditController {
    
    private static Logger log = LoggerFactory.getLogger(ObtainedQualificationEditController.class);
    private String formView;
    @Autowired private ObtainedQualificationValidator obtainedQualificationValidator;
    @Autowired private MessageSource messageSource;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupManagerInterface lookupManager;

    public ObtainedQualificationEditController() {
        super();
        this.formView = "college/person/obtainedqualification";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("ObtainedQualificationEditController.setUpForm entered...");  
        }
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        HttpSession session = request.getSession(false);
        
        StudyPlanForm studyPlanForm = ((StudyPlanForm) 
                                                    session.getAttribute("studyPlanForm"));

        List < ? extends Lookup9 > allGradeTypes = lookupManager.findAllRows(preferredLanguage,"gradeType");

        request.setAttribute("allGradeTypes",allGradeTypes);
        
        model.addAttribute("studyPlanForm", studyPlanForm);
   
        return formView;
        
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("studyPlanForm") StudyPlanForm studyPlanForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) 
            {
  
        if (log.isDebugEnabled()) {
            log.debug("ObtainedQualificationEditController.processSubmit entered...");  
        }
        Student student = studyPlanForm.getStudent();
        StudyPlan studyPlan = studyPlanForm.getStudyPlan();
        NavigationSettings navigationSettings = studyPlanForm.getNavigationSettings();

        obtainedQualificationValidator.onBindAndValidate(request, studyPlanForm, result);
        if (result.hasErrors()) {
            Locale currentLoc = RequestContextUtils.getLocale(request);
            studyPlanForm.setTxtErr(
                    messageSource.getMessage("jsp.error.requestadmission", null, currentLoc)
            );
            
            return formView;
        } else {
            List < ObtainedQualification > allObtainedQualifications = studyPlanForm
                                                                .getAllObtainedQualifications();
            ObtainedQualification newObtainedQualification = 
                                                studyPlanForm.getNewObtainedQualification();
            if (allObtainedQualifications == null) {
                allObtainedQualifications = new ArrayList<ObtainedQualification>();
            }
            newObtainedQualification.setStudyPlanId(studyPlanForm.getStudyPlan().getId());
            allObtainedQualifications.add(newObtainedQualification);
            
            
            studyManager.addObtainedQualification(newObtainedQualification);
            studyPlanForm.setAllObtainedQualifications(allObtainedQualifications);
            studyPlanForm.setNewObtainedQualification(null);
        }

        return "redirect:/college/studyplan.view?newForm=true&studyPlanId=" + studyPlan.getId() 
                + "&studentId=" + student.getStudentId() + "&tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel() + "&currentPageNumber=" 
                + navigationSettings.getCurrentPageNumber();
    }
}
