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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.web.form.FunctionForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@RequestMapping("/college/function")
@SessionAttributes({ FunctionEditController.FORM_OBJECT })
public class FunctionEditController {

    public static final String FORM_OBJECT = "functionForm";
    private static final String FORM_VIEW = "college/person/function";

    private static Logger log = LoggerFactory.getLogger(FunctionEditController.class);

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private OpusMethods opusMethods;

    public FunctionEditController() {
    }

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "lookupId" is set, the specified
     * lookup is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_OBJECT, session, model, opusMethods.isNewForm(request));

        FunctionForm functionForm = (FunctionForm) model.get(FORM_OBJECT);
        if (functionForm == null) {

            functionForm = new FunctionForm();
            model.put(FORM_OBJECT, functionForm);

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);

            functionForm.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

            functionForm.setLookupCode(request.getParameter("lookupCode"));
            int staffMemberId = Integer.parseInt(request.getParameter("staffMemberId"));
            functionForm.setStaffMember(staffMemberManager.findStaffMember(preferredLanguage, staffMemberId));

            List<StaffMemberFunction> allStaffMemberFunctions = staffMemberManager.findFunctionsForStaffMember(staffMemberId);
            functionForm.setAllStaffMemberFunctions(allStaffMemberFunctions);

            functionForm.setAllFunctions(lookupCacher.getAllFunctions());
            functionForm.setAllFunctionLevels(lookupCacher.getAllFunctionLevels());
        }

        return FORM_VIEW;
    }

    /**
     * Saves the new or updated lookupForEntity.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) FunctionForm functionForm, BindingResult result) {

        NavigationSettings navigationSettings = functionForm.getNavigationSettings();

        int staffMemberId = functionForm.getStaffMember().getStaffMemberId();
        log.info("adding " + functionForm.getLookupCode() + " / " + functionForm.getFunctionLevelCode() + " to staffMemberId " + staffMemberId);
        staffMemberManager.addFunctionToStaffMember(staffMemberId, functionForm.getLookupCode(), functionForm.getFunctionLevelCode());

        String view = "redirect:/college/staffmember.view?newForm=true&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() + "&staffMemberId="
                + staffMemberId + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();

        return view;
    }

}
