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
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.validator.Lookup8Validator;
import org.uci.opus.college.web.form.Lookup8Form;
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
@RequestMapping("/college/lookup8.view")
@SessionAttributes({ "lookup8Form" })
public class Lookup8EditController {

    private static Logger log = LoggerFactory.getLogger(Lookup8EditController.class);

    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private LookupManagerInterface lookupManager;
    
    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    public Lookup8EditController() {
        super();

        this.formView = "admin/lookup8";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {

        Lookup8Form lookup8Form = null;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new secondarySchool, destroy any existing one on the session
        opusMethods.removeSessionFormObject("lookup8Form", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "admin");

        String lookupCode = request.getParameter("lookupCode");

        /* Lookup8Form - fetch or create the form object and fill it with secondarySchool */
        if ((Lookup8Form) session.getAttribute("lookup8Form") != null) {
            lookup8Form = (Lookup8Form) session.getAttribute("lookup8Form");
        } else {
            lookup8Form = new Lookup8Form();
        }

        lookup8Form.setLookupTable(request.getParameter("lookupTable"));
        lookup8Form.setLookupCode(lookupCode);
        lookup8Form.setAppLanguagesShort(appConfigManager.getAppLanguagesShort());

        if (StringUtil.isNullOrEmpty(lookupCode, true)) {

            List<String> appLanguages = opusMethods.getAppLanguages(true);

            lookup8Form.setLookups(lookup8Form.createNewLookups(appLanguages));
            lookup8Form.setLookupActive("Y");

        } else {

            List<Lookup8> lookups = lookupManager.findAllRowsForCode(null, lookup8Form.getLookupTable(), "code", lookupCode);
            lookup8Form.setLookups(lookups);

            lookup8Form.setLookupActive(lookup8Form.getLookups().get(0).getActive());
            lookup8Form.setLookupNrOfUnitsPerYear(lookup8Form.getLookups().get(0).getNrOfUnitsPerYear());
        }

        /* Lookup8Form.NAVIGATIONSETTINGS - fetch or create the object */
        if (lookup8Form.getNavigationSettings() != null) {

            navigationSettings = lookup8Form.getNavigationSettings();

        } else {

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }

        lookup8Form.setNavigationSettings(navigationSettings);

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtErr"))) {
            lookup8Form.setTxtErr(lookup8Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtMsg"))) {
            lookup8Form.setTxtMsg(lookup8Form.getTxtErr() + ServletRequestUtils.getStringParameter(request, "txtMsg"));
        }

        model.addAttribute("lookup8Form", lookup8Form);

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("lookup8Form") Lookup8Form lookup8Form, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = lookup8Form.getNavigationSettings();

        List<Lookup8> lookups = lookup8Form.getLookups();

        SetCommon(lookup8Form, lookups);

        new Lookup8Validator().validate(lookup8Form, result);

        if (result.hasErrors()) {

            return formView;

        } else {

            if (StringUtil.isNullOrEmpty(lookup8Form.getLookupCode(), true)) {
                lookupManager.addLookupSet(lookups, lookup8Form.getLookupTable());
            } else {
                lookupManager.updateLookups(lookups, lookup8Form.getLookupTable());
            }

            status.setComplete();
        }

        return "redirect:/college/lookups.view?newForm=true&lookupTable=" + lookup8Form.getLookupTable() + "&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

    /**
     * Set common properties of lookup to same values
     * 
     * @param lookup8Form
     * @param lookups
     */
    private void SetCommon(Lookup8Form lookup8Form, List<Lookup8> lookups) {

        for (int i = 0; i < lookups.size(); i++) {
            lookups.get(i).setActive(lookup8Form.getLookupActive());
            lookups.get(i).setCode(lookup8Form.getLookupCode());
            lookups.get(i).setNrOfUnitsPerYear(lookup8Form.getLookupNrOfUnitsPerYear());
        }

    }

}
