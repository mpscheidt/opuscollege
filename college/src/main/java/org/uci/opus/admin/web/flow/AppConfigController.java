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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.web.form.AppConfigForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@RequestMapping("/college/appconfig.view")
@SessionAttributes({ "appConfigForm" })
public class AppConfigController {

    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public AppConfigController() {
        super();
        this.formView = "admin/appConfig";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject("appConfigForm", session, model, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "admin");

        /*
         * fetch or create the form object and fill it with organization and navigationSettings
         */
        AppConfigForm appConfigForm = (AppConfigForm) model.get("appConfigForm");
        if (appConfigForm == null) {
            appConfigForm = new AppConfigForm();
        }

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (appConfigForm.getNavigationSettings() != null) {
            navigationSettings = appConfigForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "appconfig.view");
        }
        appConfigForm.setNavigationSettings(navigationSettings);

        Map<String, Object> findAppConfigMap = new HashMap<>();
        findAppConfigMap.put("searchValue", navigationSettings.getSearchValue());

        List<Map<String, Object>> appConfig = appConfigManager.findAppConfigAsMaps(findAppConfigMap);
        appConfigForm.setMapAppConfig(appConfig);

        model.addAttribute("appConfigForm", appConfigForm);

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("appConfigForm") AppConfigForm appConfigForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = appConfigForm.getNavigationSettings();

        return "redirect:appconfig.view?currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

}
