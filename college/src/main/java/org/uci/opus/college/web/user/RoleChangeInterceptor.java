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

package org.uci.opus.college.web.user;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.security.AuthenticationWrapper;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

/**
 * An interceptor that is called when the role of the current user changes.
 * The privileges of the user are read from table 'opususerrole'.
 * 
 * @author markus
 *
 */
public class RoleChangeInterceptor extends HandlerInterceptorAdapter {

    private static Logger log = LoggerFactory.getLogger(RoleChangeInterceptor.class);
    private static Logger securityLog = LoggerFactory.getLogger("SECURITY." + RoleChangeInterceptor.class);

    public static final String DEFAULT_PARAM_NAME = "opusUserRoleId";

    private String paramName = DEFAULT_PARAM_NAME;

    @Autowired private BranchManagerInterface branchManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private OpusUserManagerInterface opusUserManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private OpusMethods opusMethods;

    /**
     * Set the name of the parameter that contains a user role specification
     * in a user role change request. Default is "opusUserRoleId".
     */
    public void setParamName(String paramName) {
        this.paramName = paramName;
    }

    /**
     * Return the name of the parameter that contains a user role specification
     * in a user role change request.
     */
    public String getParamName() {
        return this.paramName;
    }


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws ServletException {

        HttpSession session = request.getSession(false);
        if (request.getParameterMap().containsKey(paramName)) {
            int newOpusUserRoleId = ServletUtil.getIntParam(request, paramName, 0);

            if (newOpusUserRoleId == 0) {
                OpusUser opusUser = opusMethods.getOpusUser();
                if (opusUser != null) {
                    log.warn("Parameter '" + paramName + "' with value 0 (or empty) used for user " + opusUser.getUsername());
                }
            } else {
    
                Map<String,Object> newOpusUserRole = null;
                
                // look for the wanted role in the user's roles
                List<Map<String,Object>> opusUserRoles = (List<Map<String,Object>>) session.getAttribute("opusUserRoles");
                for (Map<String,Object> opusUserRole : opusUserRoles) {
                    if (newOpusUserRoleId == (Integer) opusUserRole.get("id")) {
                        newOpusUserRole = opusUserRole;
                        break;
                    }
                }

                if (newOpusUserRole == null) {
                    OpusUser opusUser = opusMethods.getOpusUser();
                    String err = "User " + opusUser.getUsername() + " tried to gain unauthorized access to role with id " + newOpusUserRoleId;
                    securityLog.warn(err);
                    throw new SecurityException(err);
                }
    
                /*
                 * 'preferredLanguage' might be a request parameter that has not yet been processed by LocaleChangeInterceptor
                 * (we cannot be sure about the order in which interceptors are processed)
                 * Therefore give priority to the request parameter, if none present, use preferredLanguage as provided by Spring
                 */
    //                String preferredLanguage = request.getParameter("preferredLanguage");
    //                if (preferredLanguage == null) {
    //                    preferredLanguage = OpusMethods.getPreferredLanguage(request);
    //                }
    
                OpusUserRole opusUserRole = opusUserManager.findOpusUserRoleById(newOpusUserRoleId);
                session.setAttribute("opusUserRole", opusUserRole);
    
                String role = (String) opusUserRole.getRole();
    //                Role loggedInRole = opusUserManager.findRole(preferredLanguage, role);
    //                if (loggedInRole == null) {
    //                    String err = "The user's role '" + role + "' does not exist in the language " + preferredLanguage;
    //                    securityLog.warn(err);
    //                    throw new RuntimeException(err);
    //                }
    //                session.setAttribute("loggedInRole", loggedInRole);
    
    
                Map<String, Object> userRoleMap = new HashMap<>();
                userRoleMap.put("role", role);
                List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(userRoleMap);
    
                List<GrantedAuthority> authorities = new ArrayList<>();
                for(OpusRolePrivilege opusRolePrivilege: opusRolePrivileges) {
                    authorities.add(new SimpleGrantedAuthority(opusRolePrivilege.getPrivilegeCode()));
                }

                //add user role as an authority 
                authorities.add(new SimpleGrantedAuthority(role));

                // inform listeners
                collegeServiceExtensions.authoritiesLoaded(authorities);
                
                session.setAttribute("authorities", authorities);
                
                //Adds privileges to the user
                AuthenticationWrapper auth = new AuthenticationWrapper(SecurityContextHolder.getContext().getAuthentication(), authorities);
                SecurityContextHolder.clearContext();
                SecurityContextHolder.getContext().setAuthentication(auth);

                // --- update session ---

                /* put the organizational unit, branch and institution on the session for general use */
                int organizationalUnitId = opusUserRole.getOrganizationalUnitId();
                session.setAttribute("organizationalUnitId", organizationalUnitId);

                OrganizationalUnit organizationalUnit  = null;
                Branch branch = null;
                Institution institution = null;

                /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
                organizationalUnit = organizationalUnitManager.findOrganizationalUnit(organizationalUnitId);
                session.setAttribute("organizationalUnit", organizationalUnit);
    
                int branchId = organizationalUnit.getBranchId();
                branch = branchManager.findBranch(branchId);
                session.setAttribute("branch", branch);
                session.setAttribute("branchId", branch.getId());
    
                institution = institutionManager.findInstitution(branch.getInstitutionId());
                session.setAttribute("institution", institution);
                session.setAttribute("institutionId", institution.getId());

                session.setAttribute("organizationAuthorizationForRead", opusMethods.fillOrganizationAuthorizationForRead(request));
                session.setAttribute("organizationAuthorizationForUpdate", opusMethods.fillOrganizationAuthorizationForUpdate(request));

                // add info on the org. unit to the "userName" property on the session (visible in tomcat manager)
                String userName = (String) session.getAttribute("userName");
                int idx = userName.indexOf(" @");
                if (idx != -1) {
                    userName = userName.substring(0, idx);
                }
                userName += " @ " + organizationalUnit.getOrganizationalUnitDescription()
                        + " (" + branch.getBranchDescription() + ")";
                session.setAttribute("userName", userName);
    
                securityLog.info("User '" + userName + "' changed role to: " + role);
    
            }
        }
        return true;
    }

}
