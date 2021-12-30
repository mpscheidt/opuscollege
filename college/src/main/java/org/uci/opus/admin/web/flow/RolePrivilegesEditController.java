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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.web.form.RolePrivilegesForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping("/college/roleprivileges")
@SessionAttributes({ RolePrivilegesEditController.FORM_OBJECT })
public class RolePrivilegesEditController {

    public static final String FORM_OBJECT = "rolePrivilegesForm";
    private static final String FORM_VIEW = "admin/roleprivileges";

    private static Logger log = LoggerFactory.getLogger(RolePrivilegesEditController.class);

    @Autowired
    private OpusUserManagerInterface opusUserManager;

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        session.setAttribute("menuChoice", "admin");

        RolePrivilegesForm form = new RolePrivilegesForm();

        String roleStr = request.getParameter("roleName");
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
        Role role = null;
        // Role loggedInRole = (Role)session.getAttribute("loggedInRole");
        List<OpusPrivilege> privilegesNotInRole = (List<OpusPrivilege>) opusUserManager.findOpusPrivilegesNotInRole(roleStr, preferredLanguage);

        form.setPrivilegesNotInRole(privilegesNotInRole);
        form.setAvailableRoles(opusUserManager.findAllRoles(preferredLanguage, opusUserRole.getRole()));

        if (!StringUtil.isNullOrEmpty(roleStr, true)) {
            role = opusUserManager.findRole(roleStr, preferredLanguage, opusUserRole.getRole());
        }

        form.setRole(role);
        
        model.put(FORM_OBJECT, form);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) RolePrivilegesForm rolePrivilegesForm, BindingResult result) {

        Role role = rolePrivilegesForm.getRole();
        String roleName = role.getRole();
        boolean copyPrivileges = rolePrivilegesForm.isCopyPrivileges();
        String sourceRole = rolePrivilegesForm.getSourceRole();

        if (copyPrivileges) {
            log.info("copying privileges from role " + sourceRole + " to role " + roleName);
            opusUserManager.copyPrivileges(sourceRole, roleName);
        } else {
            String[] privilegesCodes = rolePrivilegesForm.getPrivilegesCodes();
            log.info("adding to role " + roleName + " the following privileges: " + privilegesCodes);
            opusUserManager.addPrivilegesToRole(roleName, privilegesCodes);
        }

        return "redirect:/college/role.view?roleName=" + roleName;
    }

}
