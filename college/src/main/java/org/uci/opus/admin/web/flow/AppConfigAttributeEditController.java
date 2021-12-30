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
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.admin.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.validator.AppConfigAttributeValidator;
import org.uci.opus.college.web.form.AppConfigAttributeForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: AppConfigAttributeController.
 */

@Controller
@RequestMapping("/college/appconfigattribute.view")
@SessionAttributes({"appConfigAttributeForm"})
public class AppConfigAttributeEditController {

    private String formView;

    @Autowired private SecurityChecker securityChecker;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private OpusMethods opusMethods;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public AppConfigAttributeEditController() {
        super();
        this.formView = "admin/appConfigAttribute";
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
    	AppConfigAttributeForm appConfigAttributeForm = null;
        AppConfigAttribute appConfigAttribute = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        int appConfigAttributeId = 0;
        
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new endGrade, destroy any existing one on the session
        opusMethods.removeSessionFormObject("appConfigAttributeForm", session, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // get the EndGradeId if it exists (requestMethos = GET)
        if (!StringUtil.isNullOrEmpty(request.getParameter("appConfigAttributeId"))) {
        	appConfigAttributeId = Integer.parseInt(request.getParameter("appConfigAttributeId"));
        }

        /* EndGradeFORM - fetch or create the form object and fill it with endGrade */
        if ((AppConfigAttributeForm) session.getAttribute("appConfigAttributeForm") != null) {
        	appConfigAttributeForm = (AppConfigAttributeForm) session.getAttribute("appConfigAttributeForm");
        } else {
        	appConfigAttributeForm = new AppConfigAttributeForm();
        }
        if (appConfigAttributeForm.getAppConfigAttribute() == null) {
        	appConfigAttribute = appConfigManager.findOne(appConfigAttributeId);
        } else {
        	appConfigAttribute = appConfigAttributeForm.getAppConfigAttribute(); 
        }
        appConfigAttributeForm.setAppConfigAttribute(appConfigAttribute);

        
        /* EndGradeFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (appConfigAttributeForm.getNavigationSettings() != null) {
        	navigationSettings = appConfigAttributeForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        appConfigAttributeForm.setNavigationSettings(navigationSettings);

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "showAppConfigAttributeError"))) {
        	appConfigAttributeForm.setTxtErr(ServletRequestUtils.getStringParameter(
                            request, "showAppConfigAttributeError"));
        }
        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtErr"))) {
        	appConfigAttributeForm.setTxtErr(appConfigAttributeForm.getTxtErr() + 
        			ServletRequestUtils.getStringParameter(
                            request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtMsg"))) {
        	appConfigAttributeForm.setTxtMsg(appConfigAttributeForm.getTxtErr() + 
        			ServletRequestUtils.getStringParameter(
                            request, "txtMsg"));
        }


        model.addAttribute("appConfigAttributeForm", appConfigAttributeForm); 
        
        return formView;
    }

    /**
     * @param appConfigAttributeForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("appConfigAttributeForm") AppConfigAttributeForm appConfigAttributeForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

    	NavigationSettings navigationSettings = appConfigAttributeForm.getNavigationSettings();

        HttpSession session = request.getSession(false);        
        
        AppConfigAttribute appConfigAttribute = appConfigAttributeForm.getAppConfigAttribute();
        
        if ("true".equals(request.getParameter("submitFormObject"))) {
            
            new AppConfigAttributeValidator().validate(appConfigAttributeForm, result);
            
            if (result.hasErrors()) {
            	return formView;
            }
                	
            // UPDATE appConfigAttribute
            appConfigManager.updateAppConfigAttribute(appConfigAttribute);
            status.setComplete();

            return "redirect:/college/appconfig.view?"
              + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        }
        return "redirect:/college/appconfigattribute.view";
   }

}
