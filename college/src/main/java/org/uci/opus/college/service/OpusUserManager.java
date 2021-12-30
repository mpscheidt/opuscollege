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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.persistence.OpusUserMapper;
import org.uci.opus.util.OpusMethods;

/**
 * @author move Service class that contains OpusUser-related management methods.
 */
public class OpusUserManager implements OpusUserManagerInterface, UserDetailsService {

    private static final Logger LOG = LoggerFactory.getLogger(OpusUserManager.class);

    private OpusUserMapper opusUserMapper;

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    public OpusUserManager(OpusUserMapper opusUserMapper) {
        this.opusUserMapper = opusUserMapper;
    }

    @Override
    public OpusUser findOpusUserByUserName(final String opusUserName) {

        OpusUser opusUser = opusUserMapper.findOpusUserByUserName(opusUserName);

        if (opusUser != null) {
            determineAccountLocked(opusUser);

            // if user is staffmember or student, fill this information
            int personId = opusUser.getPersonId();
            opusUser.setStudent(studentManager.findStudentByPersonId(personId));
            opusUser.setStaffMember(staffMemberManager.findStaffMemberByPersonId(personId));
        }

        return opusUser;
    }

    @Override
    public OpusUser findOpusUserByPersonId(final int personId) {

        OpusUser opusUser = opusUserMapper.findOpusUserByPersonId(personId);
        determineAccountLocked(opusUser);

        return opusUser;
    }

    @Override
    public OpusUser findOpusUser(Map<String, Object> map) {
        OpusUser opusUser = opusUserMapper.findOpusUser(map);
        determineAccountLocked(opusUser);
        return opusUser;
    }

    @Override
    public OpusUser findOpusUserById(int userId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", userId);
        return findOpusUser(map);
    }

    /**
     * Decide if account is locked and set the flag with {@link OpusUser#setAccountNonLocked(boolean)}.
     * 
     * @param opusUser
     */
    private void determineAccountLocked(OpusUser opusUser) {
        if (opusUser != null) {
            int maxFailedLoginAttempts = appConfigManager.getMaxFailedLoginAttempts();
            opusUser.setAccountNonLocked(maxFailedLoginAttempts <= 0 || opusUser.getFailedLoginAttempts() < maxFailedLoginAttempts);
        }
    }

    @Override
    public OpusUserRole findOpusUserRoleByUserName(final String opusUserName, final int organizationalUnitId) {

        Map<String, Object> map = new HashMap<>();
        map.put("userName", opusUserName);
        map.put("organizationalUnitId", organizationalUnitId);
        return sqlSession.selectOne("findOpusUserRolesByParams", map);
    }

    @Override
    public List<OpusUserRole> findOpusUserRolesByParams(final Map<String, Object> map) {
        return this.opusUserMapper.findOpusUserRolesByParams(map);
    }

    @Override
    public List<Map<String, Object>> findOpusUserRolesByParams2(final Map<String, Object> map) {
        return this.opusUserMapper.findOpusUserRolesByParams2(map);
    }

    @Override
    public List<OpusUserRole> findOpusUserRolesByUserName(final String userName) {
        Map<String, Object> map = new HashMap<>();
        map.put("userName", userName);
        return this.findOpusUserRolesByParams(map);
    }

    @Override
    public List<Role> findAllRoles(final String preferredLanguage, final String loggedInRole) {

        return opusUserMapper.findAllRoles(preferredLanguage, loggedInRole);
    }

    @Override
    public OpusUserRole findOpusUserRoleByOrgUnit(final String userName, final int organizationalUnitId) {

        Map<String, Object> map = new HashMap<>();
        map.put("userName", userName);
        map.put("organizationalUnitId", organizationalUnitId);
        return sqlSession.selectOne("findOpusUserRolesByParams", map);
    }

    @Override
    public List<OpusUserRole> findOpusUserRolesForStudy(int studyId) {
        return opusUserMapper.findOpusUserRolesForStudy(studyId);
    }

    @Override
    public void deleteOpusUserRoleById(int id) {
        this.opusUserMapper.deleteOpusUserRoleById(id);
    }

    @Override
    public void deleteOpusUserRole(int personId) {
        opusUserMapper.deleteOpusUserRole(personId);
    }

    @Override
    public boolean isUserNameAlreadyExists(String userName, int userId) {
        return opusUserMapper.isUserNameAlreadyExists(userName, userId);
    }

    /**
     * @param opusUserDao
     *            is set by spring on application init.
     */
    public void setOpusUserDao(final OpusUserMapper opusUserDao) {
        this.opusUserMapper = opusUserDao;
    }

    @Override
    public void addOpusUserRole(final OpusUserRole opusUserRole) {
        LOG.info("Adding user role " + opusUserRole);
        this.opusUserMapper.addOpusUserRole(opusUserRole);
    }

    @Override
    public void updateOpusUserRole(final OpusUserRole opusUserRole) {
        LOG.info("Updating user role " + opusUserRole);
        this.opusUserMapper.updateOpusUserRole(opusUserRole);
    }

    @Override
    public OpusUserRole findOpusUserRoleById(int id) {
        return this.opusUserMapper.findOpusUserRoleById(id);
    }

    @Override
    public UserDetails loadUserByUsername(String opusUserName) {

        LOG.info("Login attempt with username '" + opusUserName + "'");

        OpusUser user = findOpusUserByUserName(opusUserName);

        if (user == null) {
            throw new UsernameNotFoundException("user name not found");
        }

        return user;
    }

    @Override
    public List<Role> findRoles(final String searchValue, final String preferredLanguage, final String loggedInRole) {

        return opusUserMapper.findRoles(searchValue, preferredLanguage, loggedInRole);
    }

    @Override
    public List<Role> findRolesByParams(final String preferredLanguage, final String loggedInRole) {

        Map<String, Object> map = new HashMap<>();
        map.put("preferredLanguage", preferredLanguage);
        map.put("loggedInRole", loggedInRole);
        return opusUserMapper.findRolesByParams(map);
    }

    @Override
    public int addRole(Role role) {
        return opusUserMapper.addRole(role);
    }

    @Override
    public void updateRole(Role role) {
        opusUserMapper.updateRole(role);
    }

    @Override
    public Role findRole(String preferredLanguage, String role) {
        return opusUserMapper.findRole(preferredLanguage, role);
    }

    @Override
    public Role findRole(String role, String preferredLanguage, String loggedInRole) {

        Map<String, Object> map = new HashMap<>();
        map.put("role", role);
        map.put("preferredLanguage", preferredLanguage);
        map.put("loggedInRole", loggedInRole);
        return sqlSession.selectOne("findRolesByParams", map);
    }

    @Override
    public Integer getLevelOfLoggedInOpusUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
        Role role = findRole(OpusMethods.getPreferredLanguage(request), opusUserRole.getRole());
        return role.getLevel();
    }

    /*----------------------------- OpusPrivilege Methods ---------------------------*/

    @Override
    public OpusPrivilege findOpusPrivilegeById(int privilegeId, String lang) {

        Map<String, Object> map = new HashMap<>();
        map.put("privilegeId", privilegeId);
        map.put("preferredLanguage", lang);

        return sqlSession.selectOne("findOpusPrivileges", map);
    }

    @Override
    public List<OpusPrivilege> findOpusPrivilegesNotInRole(String roleName, String preferredLanguage) {
        return this.opusUserMapper.findOpusPrivilegesNotInRole(roleName, preferredLanguage);
    }

    @Override
    @Transactional
    public void addPrivilegesToRole(String roleName, String[] privilegesCodes) {
        for (String privilegeCode : privilegesCodes) {
            OpusRolePrivilege opusRolePrivilege = new OpusRolePrivilege(roleName, privilegeCode);
            opusUserMapper.addOpusRolePrivilege(opusRolePrivilege);
        }
    }

    @Override
    @Transactional
    public void addRolesToPrivilege(String privilegeCode, String... roles) {

        for (String role : roles) {
            OpusRolePrivilege opusRolePrivilege = new OpusRolePrivilege(role, privilegeCode);
            opusUserMapper.addOpusRolePrivilege(opusRolePrivilege);
        }
    }

    @Override
    @Transactional
    public void deletePrivilegesFromRole(String roleName, String[] privilegesCodes) {

        for (String privilegeCode : privilegesCodes) {
            opusUserMapper.deletePrivilegeFromRole(roleName, privilegeCode);
        }
    }

    @Override
    public void deleteRole(String roleName) {
        opusUserMapper.deleteRole(roleName);

    }

    @Override
    @Transactional
    public void addRoles(Role[] roles) {

        for (Role role : roles) {
            this.opusUserMapper.addRole(role);
        }
    }

    @Override
    public List<OrganizationalUnit> findOrganizationalUnitsNotInUserRole(Map<String, Object> map) {
        return this.opusUserMapper.findOrganizationalUnitsNotInUserRole(map);
    }

    @Override
    public void addOpusUser(OpusUser opusUser) {
        this.opusUserMapper.addOpusUser(opusUser);

    }

    @Override
    public void updateOpusUser(OpusUser opusUser, final String oldPwd) {

        // only update password if it has been changed and is not empty
        String newPwd = opusUser.getPw();
        if (StringUtils.isBlank(newPwd) || newPwd.equals(oldPwd)) {
            opusUser.setPw(null);
        }

        // if ( !StringUtil.isNullOrEmpty(newPwd)) {
        // if (!newPwd.equals(oldPwd)) {
        // opusUser.setPw(newPwd);
        // } else {
        // opusUser.setPw(null);
        // }
        // } else {
        // opusUser.setPw(null);
        // }

        opusUserMapper.updateOpusUser(opusUser);
    }

    @Override
    public void deleteOpusUser(final int personId) {
        opusUserMapper.deleteOpusUser(personId);
    }

    @Override
    public void copyPrivileges(String sourceRole, String destRole) {
        this.opusUserMapper.copyPrivileges(sourceRole, destRole);

    }

    @Override
    public List<OpusPrivilege> findOpusPrivileges(Map<String, Object> map) {
        return opusUserMapper.findOpusPrivileges(map);
    }

    public List<OpusRolePrivilege> findOpusRolePrivileges(Map<String, Object> map) {
        return opusUserMapper.findOpusRolePrivileges(map);
    }

    @Override
    public OpusRolePrivilege findOpusRolePrivilege(String role, String privilegeCode) {
        Map<String, Object> map = new HashMap<>();
        map.put("role", role);
        map.put("privilegeCode", privilegeCode);
        return sqlSession.selectOne("findOpusRolePrivileges", map);
    }

    @Override
    public void deleteOpusRolePrivilege(int id) {
        opusUserMapper.deleteOpusRolePrivilege(id);
    }

    @Transactional
    @Override
    public void deleteOpusRolePrivileges(int... ids) {

        for (int id : ids) {
            opusUserMapper.deleteOpusRolePrivilege(id);
        }
    }

    @Override
    public void updateOpusRolePrivilege(OpusRolePrivilege opusRolePrivilege) {
        opusUserMapper.updateOpusRolePrivilege(opusRolePrivilege);
    }

    @Override
    public List<Role> findRolesWithoutPrivilege(String privilegeCode, String preferredLanguage, String loggedInRole) {
        return opusUserMapper.findRolesWithoutPrivilege(privilegeCode, preferredLanguage, loggedInRole);
    }

    @Override
    public Role findFirstExistingRole(String userLanguage, String[] roleNames) {
        Role role = null;

        for (String roleName : roleNames) {
            role = findRole(userLanguage, roleName);
            if (role != null)
                break;
        }

        return role;
    }

    @Override
    public void addOpusRolePrivilege(OpusRolePrivilege rolePrivilege) {
        opusUserMapper.addOpusRolePrivilege(rolePrivilege);
    }

    @Override
    public List<Map<String, Object>> findFullOpusRolePrivilege(Map<String, Object> map, String loggedInRole) {

        if (map == null) {
            map = new HashMap<>();
        }

        map.put("loggedInRole", loggedInRole);

        return this.opusUserMapper.findFullOpusRolePrivilege(map);
    }

}
