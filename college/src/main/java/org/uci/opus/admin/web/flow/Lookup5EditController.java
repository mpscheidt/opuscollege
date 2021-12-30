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
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.validator.Lookup5Validator;
import org.uci.opus.college.web.form.Lookup5Form;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping("/college/lookup5.view")
@SessionAttributes({ "lookup5Form" })
public class Lookup5EditController {

    private static Logger log = LoggerFactory.getLogger(Lookup5EditController.class);

    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private LookupManagerInterface lookupManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    public Lookup5EditController() {
        super();

        this.formView = "admin/lookup5";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {

        Lookup5Form lookup5Form = null;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new secondarySchool, destroy any existing one on the session
        opusMethods.removeSessionFormObject("lookup5Form", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String lookupCode = request.getParameter("lookupCode");

        /* Lookup5Form - fetch or create the form object and fill it with secondarySchool */
        if ((Lookup5Form) session.getAttribute("lookup5Form") != null) {
            lookup5Form = (Lookup5Form) session.getAttribute("lookup5Form");
        } else {
            lookup5Form = new Lookup5Form();
        }

        lookup5Form.setLookupTable(request.getParameter("lookupTable"));
        lookup5Form.setLookupCode(lookupCode);
        lookup5Form.setAppLanguagesShort(appConfigManager.getAppLanguagesShort());

        List<Lookup3> allCountries = lookupManager.findAllRows(preferredLanguage, "country");
        lookup5Form.setCountries(allCountries);

        if (StringUtil.isNullOrEmpty(lookupCode, true)) {

            List<String> appLanguages = opusMethods.getAppLanguages(true);

            lookup5Form.setLookups(lookup5Form.createNewLookups(appLanguages));
            lookup5Form.setLookupActive("Y");

        } else {

            List<Lookup5> lookups = lookupManager.findAllRowsForCode(null, lookup5Form.getLookupTable(), "code", lookupCode);
            lookup5Form.setLookups(lookups);

            lookup5Form.setLookupActive(lookup5Form.getLookups().get(0).getActive());
            lookup5Form.setLookupCountryCode(lookup5Form.getLookups().get(0).getCountryCode());
        }

        /* Lookup5Form.NAVIGATIONSETTINGS - fetch or create the object */
        if (lookup5Form.getNavigationSettings() != null) {

            navigationSettings = lookup5Form.getNavigationSettings();

        } else {

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }

        lookup5Form.setNavigationSettings(navigationSettings);

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtErr"))) {
            lookup5Form.setTxtErr(lookup5Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtMsg"))) {
            lookup5Form.setTxtMsg(lookup5Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtMsg"));
        }

        model.addAttribute("lookup5Form", lookup5Form);

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("lookup5Form") Lookup5Form lookup5Form, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = lookup5Form.getNavigationSettings();

        List<Lookup5> lookups = lookup5Form.getLookups();

        SetCommon(lookup5Form, lookups);

        new Lookup5Validator().validate(lookup5Form, result);

        if (result.hasErrors()) {

            return formView;

        } else {

            if (StringUtil.isNullOrEmpty(lookup5Form.getLookupCode(), true)) {
                lookupManager.addLookupSet(lookups, lookup5Form.getLookupTable());
            } else {
                lookupManager.updateLookups(lookups, lookup5Form.getLookupTable());
            }

            status.setComplete();
        }

        return "redirect:/college/lookups.view?newForm=true&lookupTable=" + lookup5Form.getLookupTable() + "&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

    /**
     * Set common properties of lookup to same values
     * 
     * @param lookup5Form
     * @param lookups
     */
    private void SetCommon(Lookup5Form lookup5Form, List<Lookup5> lookups) {

        for (int i = 0; i < lookups.size(); i++) {
            lookups.get(i).setActive(lookup5Form.getLookupActive());
            lookups.get(i).setCode(lookup5Form.getLookupCode());
            lookups.get(i).setCountryCode(lookup5Form.getLookupCountryCode());
        }

    }

}
