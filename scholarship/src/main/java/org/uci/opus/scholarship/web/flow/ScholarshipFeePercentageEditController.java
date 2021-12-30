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

package org.uci.opus.scholarship.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.ScholarshipFeePercentage;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.validators.ScholarshipFeePercentageValidator;
import org.uci.opus.scholarship.web.form.ScholarshipFeePercentageForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping(value="/scholarship/scholarshipFeePercentage.view")
@SessionAttributes({"scholarshipFeePercentageForm"})
public class ScholarshipFeePercentageEditController {
    
     private static Logger log = LoggerFactory.getLogger(ScholarshipFeePercentageEditController.class);
     
     private String formView;
     
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private OpusMethods opusMethods;
     @Autowired private ScholarshipManagerInterface scholarshipManager;
     @Autowired private LookupManagerInterface lookupManager;
     
     public ScholarshipFeePercentageEditController() {
		super();
		
		this.formView = "scholarship/scholarship/scholarshipfeepercentage";
	}
     
     @RequestMapping(method=RequestMethod.GET)
     public String setUpForm(ModelMap model, HttpServletRequest request, @RequestParam("scholarshipId") int scholarshipId) 
             throws Exception {
         
         ScholarshipFeePercentageForm scholarshipFeePercentageForm = null;
         
         NavigationSettings navigationSettings = null;
         
         HttpSession session = request.getSession(false);
         
         /* perform session-check. If wrong, this throws an Exception towards ErrorController */
         securityChecker.checkSessionValid(session);
         
         // if adding a new scholarshipFeePercentage, destroy any existing one on the session
         opusMethods.removeSessionFormObject("scholarshipFeePercentageForm", session, opusMethods.isNewForm(request));

         /* set menu to admin */
         session.setAttribute("menuChoice", "scholarship");
         
         int feePercentageId = ServletRequestUtils.getIntParameter(request, "feePercentageId", 0); 
         
         String preferredLanguage = OpusMethods.getPreferredLanguage(request);

         /* ScholarshipFeePercentageForm - fetch or create the form object and fill it with secondarySchool */
         if ((ScholarshipFeePercentageForm) session.getAttribute("scholarshipFeePercentageForm") != null) {
             scholarshipFeePercentageForm = (ScholarshipFeePercentageForm) session.getAttribute("scholarshipFeePercentageForm");
         } else {
             scholarshipFeePercentageForm = new ScholarshipFeePercentageForm();
         }

         if(feePercentageId != 0)
        	 scholarshipFeePercentageForm.setScholarshipFeePercentage(scholarshipManager.findOne(feePercentageId));
         else
        	 scholarshipFeePercentageForm.setScholarshipFeePercentage(scholarshipFeePercentageForm.createNewScholarshipFeePercentage(scholarshipId, opusMethods.getWriteWho(request)));
         
         scholarshipFeePercentageForm.setFeeCategories(lookupManager.findAllRows(preferredLanguage, "fee_feecategory"));
         scholarshipFeePercentageForm.setScholarshipFeeCategories(scholarshipManager.findFeeCategoriesForScholarship(scholarshipId));
         
         /* ScholarshipFeePercentageForm.NAVIGATIONSETTINGS - fetch or create the object */
         if (scholarshipFeePercentageForm.getNavigationSettings() != null) {
        	 
         	navigationSettings = scholarshipFeePercentageForm.getNavigationSettings();
         	
         } else {
        	 
         	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
         }
         
         scholarshipFeePercentageForm.setNavigationSettings(navigationSettings);

         if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                 request, "txtErr"))) {
         	scholarshipFeePercentageForm.setTxtErr(scholarshipFeePercentageForm.getTxtErr() + 
         			ServletRequestUtils.getStringParameter(
                             request, "txtErr"));
         }

         if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                 request, "txtMsg"))) {
         	scholarshipFeePercentageForm.setTxtMsg(scholarshipFeePercentageForm.getTxtErr() + 
         			ServletRequestUtils.getStringParameter(
                             request, "txtMsg"));
         }

         model.addAttribute("scholarshipFeePercentageForm", scholarshipFeePercentageForm);        
         
         return formView;
     }
        
     @RequestMapping(method=RequestMethod.POST)
     public String processSubmit(
     		@ModelAttribute("scholarshipFeePercentageForm") ScholarshipFeePercentageForm scholarshipFeePercentageForm,
             BindingResult result, SessionStatus status, HttpServletRequest request) { 

     	NavigationSettings navigationSettings = scholarshipFeePercentageForm.getNavigationSettings();

        ScholarshipFeePercentage scholarshipFeePercentage = scholarshipFeePercentageForm.getScholarshipFeePercentage();
             
        new ScholarshipFeePercentageValidator().validate(scholarshipFeePercentageForm, result);            
             
             if (result.hasErrors()) {

             	return formView;
             	
             } else {

            	 if(scholarshipFeePercentage.getId() == 0) {
             		scholarshipManager.addScholarshipFeePercentage(scholarshipFeePercentage);
             	} else {             	
                 scholarshipManager.updateScholarshipFeePercentage(scholarshipFeePercentage);
             	}
             	
                 status.setComplete();
             }

             return "redirect:/scholarship/scholarship.view?newForm=true"
             + "&scholarshipId=" + scholarshipFeePercentage.getScholarshipId()
             + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
             + "&tab=" + navigationSettings.getTab()
             + "&panel=" + navigationSettings.getPanel()
             ;
         }
    	 
    
}
