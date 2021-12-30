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
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.validator.RoleValidator;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * 
 * Controller for adding and editing role objects.
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping("/college/role")
@SessionAttributes({ RoleEditController.FORM_OBJECT })
public class RoleEditController {

    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "admin/role";

    private static Logger log = LoggerFactory.getLogger(RoleEditController.class);

    private OpusUserManagerInterface opusUserManager;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private RoleValidator validator;

    @Autowired
    public RoleEditController(OpusUserManagerInterface opusUserManager) {
        this.opusUserManager = opusUserManager;
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        String roleName = request.getParameter("roleName");
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

        Role role = new Role();

        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);

        session.setAttribute("menuChoice", "admin");

        request.setAttribute("preferredLanguage", preferredLanguage);

        if (!StringUtil.isNullOrEmpty(roleName, true)) {

            role = opusUserManager.findRole(roleName, preferredLanguage, opusUserRole.getRole());

            Map<String, Object> map = new HashMap<String, Object>();

            map.put("role", role.getRole());
            map.put("preferredLanguage", preferredLanguage);

            // privileges assigned to this role
            request.setAttribute("rolePrivileges", opusUserManager.findFullOpusRolePrivilege(map, opusUserRole.getRole()));

        } else {

            role.setActive("Y");
            role.setId(0);
            role.setLang(preferredLanguage);

        }

        model.put(FORM_OBJECT, role);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) Role role, BindingResult result) {

        validator.validate(role, result);
        additionalValidation(request, role, result);
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        if (role.getId() == 0) {
            log.info("adding " + role);
            opusUserManager.addRoles(getRoles(role, request));
        } else {
            log.info("updating " + role);
            opusUserManager.updateRole(role);
        }

        return "redirect:/college/role.view?roleName=" + role.getRole();
    }

    private void additionalValidation(HttpServletRequest request, Role role, BindingResult result) {

        // only allow to edit roles at a lower or equal level compared to the loggedin user role
        HttpSession session = request.getSession(false);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
        Role loggedInRole = opusUserManager.findRole(preferredLanguage, opusUserRole.getRole());

        if (role.getLevel() < loggedInRole.getLevel()) {
            result.rejectValue("level", "invalid.rolelevel.editing");
        }

    }

    /**
     * When adding a new role it, a new group of roles will be created with same values but with
     * different languages. This method ensures that the role will have the same values
     */
    private Role[] getRoles(Role editingRole, HttpServletRequest request) {

        Object[] appLanguages = appConfigManager.getAppLanguages().toArray();
        Role[] roles = new Role[appLanguages.length];// a role entry for each language

        for (int i = 0; i < appLanguages.length; i++) {
            roles[i] = new Role(0, appLanguages[i].toString(), editingRole.getActive(), editingRole.getRole(), editingRole.getRoleDescription(), editingRole.getLevel());

        }

        return roles;
    }

}
