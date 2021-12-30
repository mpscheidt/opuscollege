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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

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
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.validator.OpusRolePrivilegeValidator;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping("/college/privilegeroles")
@SessionAttributes({ PrivilegeRolesEditController.FORM_OBJECT })
public class PrivilegeRolesEditController {

    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "admin/privilegeroles";

    private static Logger log = LoggerFactory.getLogger(PrivilegeRolesEditController.class);

    private OpusRolePrivilegeValidator validator = new OpusRolePrivilegeValidator();

    @Autowired
    private SecurityChecker securityChecker;
    @Autowired
    private OpusUserManagerInterface opusUserManager;

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        session.setAttribute("menuChoice", "admin");

        int id = ServletUtil.getParamSetAttrAsInt(request, "privilegeId", 0);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
        OpusPrivilege privilege = opusUserManager.findOpusPrivilegeById(id, preferredLanguage);

        request.setAttribute("privilege", privilege);
        request.setAttribute("availableRoles", opusUserManager.findRolesWithoutPrivilege(privilege.getCode(), preferredLanguage, opusUserRole.getRole()));
        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);

        OpusRolePrivilege rolePrivilege = new OpusRolePrivilege();

        rolePrivilege.setActive("Y");
        rolePrivilege.setPrivilegeCode(privilege.getCode());

        /*
         * OpusRolePrivilegeValidator does not accept empty roles a dummy role is added so validator
         * does not stops from submitting
         */
        rolePrivilege.setRole("dummy");

        model.put(FORM_OBJECT, rolePrivilege);
        
        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) OpusRolePrivilege rolePrivilege, BindingResult result) {

        validator.validate(rolePrivilege, result);
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        String[] roles = request.getParameterValues("privilegeRoles");

        log.info("adding to privilege" + rolePrivilege.getPrivilegeCode() + ": " + roles);
        opusUserManager.addRolesToPrivilege(rolePrivilege.getPrivilegeCode(), roles);

        return "redirect:/college/privilege.view?privilegeId=" + ServletUtil.getIntParam(request, "privilegeId", 0);
    }

}
