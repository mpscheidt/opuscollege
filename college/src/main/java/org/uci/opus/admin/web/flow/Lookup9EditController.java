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

package org.uci.opus.admin.web.flow;

import java.util.List;

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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.validator.Lookup9Validator;
import org.uci.opus.college.web.form.Lookup9Form;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * 
 * @author Janneke Nooitgedagt
 *
 */
@Controller
@RequestMapping("/college/lookup9.view")
@SessionAttributes({ "lookup9Form" })
public class Lookup9EditController {

    private static Logger log = LoggerFactory.getLogger(Lookup9EditController.class);

    private String formView;

    @Autowired
    private SecurityChecker securityChecker;
    
    @Autowired
    private LookupManagerInterface lookupManager;
    
    @Autowired
    private OpusMethods opusMethods;
    
    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    public Lookup9EditController() {
        super();

        this.formView = "admin/lookup9";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {

        Lookup9Form lookup9Form = null;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new secondarySchool, destroy any existing one on the session
        opusMethods.removeSessionFormObject("lookup9Form", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        String lookupCode = request.getParameter("lookupCode");

        /* Lookup9Form - fetch or create the form object and fill it with secondarySchool */
        if ((Lookup9Form) session.getAttribute("lookup9Form") != null) {
            lookup9Form = (Lookup9Form) session.getAttribute("lookup9Form");
        } else {
            lookup9Form = new Lookup9Form();
        }

        lookup9Form.setLookupTable(request.getParameter("lookupTable"));
        lookup9Form.setLookupCode(lookupCode);
        lookup9Form.setAppLanguagesShort(appConfigManager.getAppLanguagesShort());

        if (StringUtil.isNullOrEmpty(lookupCode, true)) {

            List<String> appLanguages = opusMethods.getAppLanguages(true);

            lookup9Form.setLookups(lookup9Form.createNewLookups(appLanguages));
            lookup9Form.setLookupActive("Y");

        } else {

            List<Lookup9> lookups = lookupManager.findAllRowsForCode(null, lookup9Form.getLookupTable(), "code", lookupCode);
            lookup9Form.setLookups(lookups);

            lookup9Form.setLookupActive(lookup9Form.getLookups().get(0).getActive());
            lookup9Form.setLookupTitle(lookup9Form.getLookups().get(0).getTitle());
            lookup9Form.setLookupEducationLevelCode(lookup9Form.getLookups().get(0).getEducationLevelCode());
            lookup9Form.setLookupEducationAreaCode(lookup9Form.getLookups().get(0).getEducationAreaCode());
        }

        /* Lookup9Form.NAVIGATIONSETTINGS - fetch or create the object */
        if (lookup9Form.getNavigationSettings() != null) {

            navigationSettings = lookup9Form.getNavigationSettings();

        } else {

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }

        lookup9Form.setNavigationSettings(navigationSettings);

        lookup9Form.setAllEducationLevels(lookupCacher.getAllEducationLevels(preferredLanguage));
        lookup9Form.setAllEducationAreas(lookupCacher.getAllEducationAreas(preferredLanguage));

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtErr"))) {
            lookup9Form.setTxtErr(lookup9Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtMsg"))) {
            lookup9Form.setTxtMsg(lookup9Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtMsg"));
        }

        model.addAttribute("lookup9Form", lookup9Form);

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("lookup9Form") Lookup9Form lookup9Form, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = lookup9Form.getNavigationSettings();

        List<Lookup9> lookups = lookup9Form.getLookups();

        SetCommon(lookup9Form, lookups);

        new Lookup9Validator().validate(lookup9Form, result);

        if (result.hasErrors()) {

            return formView;

        } else {

            if (StringUtil.isNullOrEmpty(lookup9Form.getLookupCode(), true)) {
                lookupManager.addLookupSet(lookups, lookup9Form.getLookupTable());
            } else {
                lookupManager.updateLookups(lookups, lookup9Form.getLookupTable());
            }

            status.setComplete();
        }

        return "redirect:/college/lookups.view?newForm=true&lookupTable=" + lookup9Form.getLookupTable() + "&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

    /**
     * Set common properties of lookup to same values
     * 
     * @param lookup9Form
     * @param lookups
     */
    private void SetCommon(Lookup9Form lookup9Form, List<Lookup9> lookups) {

        for (int i = 0; i < lookups.size(); i++) {
            lookups.get(i).setActive(lookup9Form.getLookupActive());
            lookups.get(i).setCode(lookup9Form.getLookupCode());
            lookups.get(i).setTitle(lookup9Form.getLookupTitle());
            lookups.get(i).setEducationLevelCode(lookup9Form.getLookupEducationLevelCode());
            lookups.get(i).setEducationAreaCode(lookup9Form.getLookupEducationAreaCode());
        }

    }

}
