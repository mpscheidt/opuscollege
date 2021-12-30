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

package org.uci.opus.college.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;

/**
 * Interface for OpusUser-related management methods.
 * 
 * @author move
 */
public interface OpusUserManagerInterface {

    /**
     * @param opusUserName
     *            find Opususer with this username
     * @return OpusUser object or null when there were no valid credentials.
     */
    OpusUser findOpusUserByUserName(final String opusUserName);

    /**
     * @param personId
     *            find Opususer with this person-id
     * @return OpusUser object or null when there were no valid credentials.
     */
    OpusUser findOpusUserByPersonId(final int personId);

    /**
     * Finds a user given its id
     * 
     * @param userId
     * @return
     */
    OpusUser findOpusUserById(final int userId);

    /**
     * Finds a user given a set of parameters in a map. The parameters names and types are the same as the properties in OpusUser
     * (org.uci.opus.college.domain.OpusUser) class
     * 
     * @param map
     * @return
     */
    OpusUser findOpusUser(Map<String, Object> map);

    void addOpusUser(OpusUser opusUser);

    void updateOpusUser(OpusUser opusUser, String oldPwd);

    /**
     * @param personId
     *            personId of opusUser to delete.
     */
    void deleteOpusUser(int personId);

    /**
     * @param opusUserName
     *            find OpususerRole with this username
     * @return OpusUserRole object or null when there were no valid credentials.
     */
    OpusUserRole findOpusUserRoleByUserName(final String opusUserName, final int organizationalUnitId);

    OpusUserRole findOpusUserRoleById(final int id);

    /**
     * @param preferredLanguage
     *            language of choice
     * @param loggedInRole
     *            role of logged in user
     * @return List of Role objects or null when nothing was found.
     */
    List<Role> findAllRoles(final String preferredLanguage, final String loggedInRole);

    /**
     * checks if a given userName is already in use
     * 
     * @param userName
     *            - the name of the user
     * @param id
     *            - the id of the user
     * @return true if already in use, otherwise false
     */
    boolean isUserNameAlreadyExists(String userName, int userId);

    /**
     * Encrypt a given text with ....
     * 
     * @param text
     * @return the encrypted text
     */
    // String encryptText(final String text);

    List<OpusUserRole> findOpusUserRolesByUserName(final String opusUserName);

    /**
     * Finds roles when oner or more parameters may not be present
     * 
     * @param preferredLanguage
     * @param loggedInRole
     * @return
     */
    List<Role> findRolesByParams(final String preferredLanguage, final String loggedInRole);

    int addRole(Role role);

    void updateRole(Role role);

    /**
     * 
     * @param preferredLanguage
     * @param role
     * @return
     */
    Role findRole(String preferredLanguage, String role);

    /**
     * Every user is logged in with a specific OpusUserRole. Even if the user has more roles, only one is active at any given moment. Find
     * the level of the role that currently active for the logged in user.
     * 
     * @param request
     * @return
     */
    Integer getLevelOfLoggedInOpusUserRole(HttpServletRequest request);

    /**
     * Find the highest possible role according to the role level, taking into account the leve of the logged in role
     * 
     * @param role
     *            the name of the role to find
     * @param preferredLanguage
     *            the language the role description should be presented on
     * @param loggedInRole
     *            role of the current logged in user. This will allow that only roles in levels below this user are loaded
     * @return a role object or null if role is not found
     */
    Role findRole(String role, String preferredLanguage, String loggedInRole);

    OpusPrivilege findOpusPrivilegeById(int privilegeId, String lang);

    void deleteOpusUserRoleById(final int id);

    /**
     * Find organizational units to which a user has not a role yet Parameters may be institutionId,userName and branchId. Username is a
     * required parameter
     * 
     * @param map
     * @return - list of organizational units
     */
    List<OrganizationalUnit> findOrganizationalUnitsNotInUserRole(Map<String, Object> map);

    void deletePrivilegesFromRole(String role, String[] parameterValues);

    List<OpusPrivilege> findOpusPrivilegesNotInRole(String roleStr, String preferredLanguage);

    void addPrivilegesToRole(String role, String[] parameterValues);

    void addRolesToPrivilege(String privilegeCode, String... roles);

    void copyPrivileges(String sourceRole, String destRole);

    List<OpusPrivilege> findOpusPrivileges(Map<String, Object> map);

    OpusRolePrivilege findOpusRolePrivilege(String role, String privilegeCode);

    List<OpusRolePrivilege> findOpusRolePrivileges(Map<String, Object> map);

    void deleteOpusRolePrivilege(int id);

    void deleteOpusRolePrivileges(int... ids);

    void updateOpusRolePrivilege(OpusRolePrivilege opusRolePrivilege);

    /**
     * Finds roles which do not have a certain privilege
     * 
     * @param map
     * @param loggedInRole
     * @return
     */
    List<Role> findRolesWithoutPrivilege(String privilegeCode, String preferredLanguage, String loggedInRole);

    void addOpusRolePrivilege(OpusRolePrivilege rolePrivilege);

    void deleteRole(String roleName);

    void addRoles(Role[] roles);

    List<Role> findRoles(String searchValue, String preferredLanguage, String role);

    void addOpusUserRole(OpusUserRole opusUserRole);

    void updateOpusUserRole(OpusUserRole opusUserRole);

    /**
     * @param personId
     *            personId of opusUserRole to delete.
     * @return
     */
    void deleteOpusUserRole(int personId);

    List<Map<String, Object>> findOpusUserRolesByParams2(Map<String, Object> userRolesMap);

    List<OpusUserRole> findOpusUserRolesByParams(Map<String, Object> userRolesMap);

    OpusUserRole findOpusUserRoleByOrgUnit(String userPrincipalName, int intParam);

    List<OpusUserRole> findOpusUserRolesForStudy(int studyId);

    // List findFieldPrivileges(String privilegeCode);

    List<Map<String, Object>> findFullOpusRolePrivilege(Map<String, Object> map, String loggedInRole);

    /**
     * Get the first role of the given role names that exists in the database. The list of roleNames is searched in order. Note: Not each
     * installation may have the same set of roles.
     * 
     * @param userLanguage
     * @param roleNames
     * @return the first role that is found in the database
     */
    Role findFirstExistingRole(String userLanguage, String[] roleNames);

}
