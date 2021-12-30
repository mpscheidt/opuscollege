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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyType;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectStudyTypeValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.SubjectStudyTypeForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectstudytype.view")
@SessionAttributes("subjectStudyTypeForm")
public class SubjectStudyTypeEditController {
    
    private static Logger log = LoggerFactory.getLogger(SubjectStudyTypeEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    
    private String formView;

    public SubjectStudyTypeEditController() {
        super();
        this.formView = "college/subject/subjectStudyType";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            {
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectStudyTypeEditController.setUpForm entered...");
        }

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // define variables
        SubjectStudyTypeForm subjectStudyTypeForm = null;
        NavigationSettings navigationSettings = null;
        
        Subject subject = null;
        int subjectId = 0;

        SubjectStudyType subjectStudyType = null;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        // always new SubjectStudyTypeForm
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));
        
        /* no editing nor other submit than "add" so always a new object */
        subjectStudyTypeForm = new SubjectStudyTypeForm();
        
        navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, "subjectstudytype.view");
        subjectStudyTypeForm.setNavigationSettings(navigationSettings);

        // get the subject's name to show in the header (bread crumbs path)
        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
            subjectId = Integer.parseInt(request.getParameter("subjectId"));
        }
        // subjectId should always be filled
        if (subjectId != 0) {
            // needed to show the subject's name in the header (bread crumbs path)
            subject = subjectManager.findSubject(subjectId);
            subjectStudyTypeForm.setSubject(subject);
        }

        // get the list of SubjectStudyTypes
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("subjectId", subjectId);
        map.put("preferredLanguage", preferredLanguage);

        subjectStudyTypeForm.setAllSubjectStudyTypes(subjectManager.findSubjectStudyTypes(map));

        // get lookups for subject
        lookupCacher.getSubjectLookups(preferredLanguage, request);

        // subjectStudyType always inserted, never updated
        subjectStudyType = new SubjectStudyType();
        subjectStudyType.setSubjectId(subjectId);
        subjectStudyType.setActive("Y");
        subjectStudyTypeForm.setSubjectStudyType(subjectStudyType);
            
        model.addAttribute("subjectStudyTypeForm", subjectStudyTypeForm);        
        return formView;
    }

    /**
     * Saves the link between a studyType and a subject.
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute(
                                "subjectStudyTypeForm") SubjectStudyTypeForm subjectStudyTypeForm
                                , BindingResult result, HttpServletRequest request
                                , SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectStudyTypeEditController.processSubmit entered...");
        }
        
        SubjectStudyType subjectStudyType = subjectStudyTypeForm.getSubjectStudyType();

        NavigationSettings navigationSettings = subjectStudyTypeForm.getNavigationSettings();
        
        new SubjectStudyTypeValidator().validate(subjectStudyType, result);
        if (result.hasErrors()) {
            /* if an error is detected by the validator, then the setUpForm is not called. Therefore
             * the lookup tables need to be filled in this method as well
             */
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            /* put lookup-tables on the request */
            lookupCacher.getSubjectLookups(preferredLanguage, request);
            
            return formView;
        }

        subjectManager.addSubjectStudyType(subjectStudyType);

         // should work but doesn't do anything in this case, not needed
        // status.setComplete();

        return "redirect:/college/subject.view?newForm=true"
                                            + "&tab=" + navigationSettings.getTab()
                                            + "&panel=" + navigationSettings.getPanel()
                                            + "&subjectId=" + subjectStudyType.getSubjectId()
                                            + "&currentPageNumber=" 
                                            + navigationSettings.getCurrentPageNumber();

    }

}
