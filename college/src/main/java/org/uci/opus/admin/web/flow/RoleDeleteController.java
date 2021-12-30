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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.QueryUtilitiesManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * @author Stelio Macumbe
 * 
 */
public class RoleDeleteController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(RoleDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;
    private OpusUserManagerInterface opusUserManager;
    private QueryUtilitiesManagerInterface queryUtilitiesManager;

    @Autowired
    public RoleDeleteController(SecurityChecker securityChecker,
            OpusUserManagerInterface opusUserManager,
            QueryUtilitiesManagerInterface queryUtilitiesManager,
            OpusMethods opusMethods) {
        super();
        this.securityChecker = securityChecker;
        this.opusUserManager = opusUserManager;
        this.queryUtilitiesManager = queryUtilitiesManager;
    }

    @Override
    protected final ModelAndView handleRequestInternal(
            HttpServletRequest request, 
            HttpServletResponse response) {

        HttpSession session = request.getSession(false);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String roleName = request.getParameter("role");      
        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
        Role loggedInRole = opusUserManager.findRole(preferredLanguage, opusUserRole.getRole());
        //get details of role that is about to be deleted
        Role role = opusUserManager.findRole(roleName, preferredLanguage, loggedInRole.getRole());

        ModelAndView mav = new ModelAndView(viewName);

        securityChecker.checkSessionValid(session);
        session.setAttribute("menuChoice", "admin");

        //only allow to delete roles in a level equal or below this user role
        if(loggedInRole.getLevel() <=  role.getLevel()) {

            //verifies if there is any user with this role before deleting it
            if(queryUtilitiesManager.existsValue("opususerrole", "role", roleName)) {
                mav = new ModelAndView("redirect:roles.view?roleHasUsersError=true&roleName=" + roleName);
            } else {
                log.info("deleting " + roleName);
                opusUserManager.deleteRole(roleName);
            }	   
        } else {
            mav = new ModelAndView("redirect:roles.view?notAuthorizedToDeleteRole=true&roleName=" + roleName);
        }



        return mav;
    }

    public String getViewName() {
        return viewName;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }


}
