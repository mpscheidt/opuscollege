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

package org.uci.opus.college.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;

/**
 * @author jano
 * @author Markus Pscheidt
 */
public interface OpusUserMapper {

    // OpusUser

    /**
     * @param opusUserName name of user to be found
     * @return OpusUser object or null when there was nothing found.
     */  
    OpusUser findOpusUserByUserName(final String opusUserName);

    /**
     * @param personId of user to be found
     * @return OpusUser object or null when there were no valid credentials.
     */  
    OpusUser findOpusUserByPersonId(final int personId);

    /**
     * Finds a user given a set of parameters in a map. 
     * The parameters names and types are the same as the properties in OpusUser (org.uci.opus.college.domain.OpusUser) class
     * @param map
     * @return
     */
    OpusUser findOpusUser(Map<String, Object> map);

    OpusUserRole findOpusUserRoleById(final int id);

    /**
     * @param opusUser to add. 
     */  
    void addOpusUser(final OpusUser opusUser);

    /**
     * Only update the password if it is changed, this is when the oldPw and 
     * opusUser.getPw() are different and opusUser.getPw() is not null.
     * @param opusUser to update. 
     */  
    void updateOpusUser(final OpusUser opusUser);

    /**
     * @param personId personId of opusUser to delete.
     */  
    void deleteOpusUser(final int personId);

    // OpusUserRole
    
    /**
     * @param opusUserRole to add. 
     * @return
     */  
    void addOpusUserRole(final OpusUserRole opusUserRole);

    /**
     * @param opusUserRole to update
     * @return
     */  
    void updateOpusUserRole(final OpusUserRole opusUserRole);

    /**
     * @param personId  personId of opusUserRole to delete.
     * @return
     */  
    void deleteOpusUserRole(final int id);
    void deleteOpusUserRoleById(final int id);

    /**
     * checks if a given userName is already in use.
     * @param userName - the name of the user
     * @param id - the id of the user
     * @return true if already in use, otherwise false
     */
    boolean isUserNameAlreadyExists(@Param("userName") String userName, @Param("id") int id);


    // Role
    
    /**
     * @param userLanguage of role to be found
     * @param roleName of role to be found
     * @return OpusUserRole object or null when there were nothing found.
     */  
    Role findRole(@Param("userLanguage") String userLanguage, @Param("roleName") String roleName);

    /**
     * @param map
     * @return
     */
    List<Role> findRolesByParams(Map<String, Object> map);

    /**
     * @param preferredLanguage the language of choice
     * @param loggedInRole the role of the logged in user
     * @return OpusUserRole object or null when there were nothing found.
     */
    List<Role> findAllRoles(@Param("preferredLanguage") String preferredLanguage, @Param("loggedInRole") String loggedInRole);

    /**
     * @param searchValue
     * @param preferredLanguage
     * @param loggedInRole
     * @return
     */
    List<Role> findRoles(@Param("searchValue") String searchValue, @Param("preferredLanguage") String preferredLanguage, @Param("loggedInRole") String loggedInRole);

    /**
     * Get the first role of the given role names that exists in the database.
     * The list of roleNames is searched in order.
     * Note: Not every installation has necessarily the same set of roles.
     * @param userLanguage
     * @param roleNames
     * @return the first role that is found in the database
     */
    Role findFirstExistingRole(String userLanguage, String[] roleNames);

    int addRole(Role role);

    void updateRole(Role role);

    // Unsorted
    
    /**
     * Find organizational units to which a user has not a role yet
     * Parameters may be institutionId,userName and branchId. 
     * Username is a required parameter 
     * @param map
     * @return - list of organizational units
     */
    List<OrganizationalUnit> findOrganizationalUnitsNotInUserRole(Map<String, Object> map);

    List<OpusUserRole> findOpusUserRolesByParams(Map<String, Object> map);

    List<Map<String, Object>> findOpusUserRolesByParams2(Map<String, Object> map);

    List<OpusUserRole> findOpusUserRolesForStudy(int studyId);

    
    
    List<OpusPrivilege> findPrivilegesForRoles(Map<String, Object> map);

    List<String> findPrivilegesCodesForRoles(Map<String, Object> map);


    List<OpusPrivilege> findOpusPrivilegesNotInRole(@Param("role") String role, @Param("preferredLanguage") String preferredLanguage);    

    void deletePrivilegeFromRole(@Param("role") String roleName, @Param("privilegeCode") String privilegeCode);

    void deleteRole(String roleName);

//    void addRoles(Role[] roles);

    void copyPrivileges(@Param("sourceRole") String sourceRole, @Param("destRole") String destRole);

    List<OpusPrivilege> findOpusPrivileges(Map<String, Object> map);

    List<Map<String, Object>> findFullOpusRolePrivilege(Map<String, Object> map);

    List<OpusRolePrivilege> findOpusRolePrivileges(Map<String, Object> map);

    void deleteOpusRolePrivilege(int id);

    void updateOpusRolePrivilege(OpusRolePrivilege opusRolePrivilege);

    /**
     * Finds roles which do not have a certain privilege.
     * @param map
     * @return List<OpusRolePrivilege>
     */
    List<Role> findRolesWithoutPrivilege(@Param("privilegeCode") String privilegeCode,
            @Param("preferredLanguage") String preferredLanguage,
            @Param("loggedInRole") String loggedInRole);

    void addOpusRolePrivilege(OpusRolePrivilege rolePrivilege);

}
