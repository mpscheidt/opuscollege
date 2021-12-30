package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
})
public class OpusUserManagerTest extends OpusDBTestCase {

    @Autowired
    private OpusUserManagerInterface opusUserManager;

    @Before
    public void setUp() throws Exception {
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.person"),
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.appconfig"),
                new DefaultTable("opuscollege.opususerrole"),
                new DefaultTable("opuscollege.opususer")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/OpusUserManagerTest-prepData.xml");
    }

    // -- OpusUser --

    @Test
    public void testFindOpusUserByUserName() {
        // TODO implement after student manager has been migrated
    }

    @Test
    public void testFindOpusUserByPersonId() {
        OpusUser opusUser = opusUserManager.findOpusUserByPersonId(16);
        verifyOpusUser11(opusUser);
        
        assertNull(opusUserManager.findOpusUserByPersonId(0));
    }

    private void verifyOpusUser11(OpusUser opusUser) {
        assertNotNull(opusUser);
        assertEquals(11, opusUser.getId());
        assertEquals(true, opusUser.isAccountNonLocked());
    }

    @Test
    public void testFindOpusUser() {
        Map<String, Object> map = new HashMap<>();
        map.put("userName", "pal");
        OpusUser opusUser = opusUserManager.findOpusUser(map);
        verifyOpusUser12(opusUser);
    }

    private void verifyOpusUser12(OpusUser opusUser) {
        assertNotNull(opusUser);
        assertEquals(12, opusUser.getId());
        assertEquals(false, opusUser.isAccountNonLocked());
    }

    @Test
    public void testFindOpusUserById() {
        OpusUser opusUser = opusUserManager.findOpusUserById(11);
        verifyOpusUser11(opusUser);
    }
    
    @Test
    public void testAddOpusUser() {
        OpusUser opusUser = new OpusUser("mylogin", EN, 18, 0);
        opusUserManager.addOpusUser(opusUser);

        OpusUser myUser = opusUserManager.findOpusUserByPersonId(0);
        assertEquals(18, myUser.getPreferredOrganizationalUnitId());
    }
    
    @Test
    public void testUpdateOpusUser() {
        OpusUser opusUser = opusUserManager.findOpusUserById(12);
        opusUser.setFailedLoginAttempts(0);
        String updatedPw = "322b2f02978fce66b1c883ac6dbfe9f2";
        opusUser.setPw(updatedPw);
        opusUserManager.updateOpusUser(opusUser, null);
        
        opusUser = opusUserManager.findOpusUserById(12);
        assertEquals(0, opusUser.getFailedLoginAttempts());
        assertEquals(updatedPw, opusUser.getPw());
    }
    
    @Test
    public void testDeleteOpusUser() {
        opusUserManager.deleteOpusUser(17);
        assertNull(opusUserManager.findOpusUserById(12));
    }

    @Test
    public void testIsUserNameAlreadyExists() {
        assertTrue(opusUserManager.isUserNameAlreadyExists("uju", 0));
        assertFalse(opusUserManager.isUserNameAlreadyExists("uju", 11));
    }

    // -- OpusUserRole --

    @Test
    public void testFindOpusUserRoleByUserName() {
        OpusUserRole ouRole = opusUserManager.findOpusUserRoleByUserName("uju", 18);
        verifyOpusUserRole11(ouRole);
    }

    private void verifyOpusUserRole11(OpusUserRole ouRole) {
        assertNotNull(ouRole);
        assertEquals(11, ouRole.getId());
        assertEquals("teacher", ouRole.getRole());
    }
    
    @Test
    public void testFindOpusUserRolesByParams() {
        Map<String, Object> map = new HashMap<>();
        map.put("personId", 16);
        List<OpusUserRole> opusUserRoles = opusUserManager.findOpusUserRolesByParams(map);
        assertEquals(1, opusUserRoles.size());
        verifyOpusUserRole11(opusUserRoles.get(0));
    }

    @Test
    public void testFindOpusUserRolesByParams2() {
        Map<String, Object> userRolesMap = new HashMap<>();
        userRolesMap.put("userName", "uju");
        userRolesMap.put("excludeExpired", "true");
        userRolesMap.put("excludeUnavailable", "true");
        userRolesMap.put("preferredLanguage", EN);
        List<Map<String, Object>> opusUserRoles = opusUserManager.findOpusUserRolesByParams2(userRolesMap);
        assertEquals(1, opusUserRoles.size());
        Map<String, Object> opusUserRole = opusUserRoles.get(0);
        assertEquals(11, opusUserRole.get("id"));
        assertEquals("Delegacao de Tete", opusUserRole.get("branchDescription"));
    }

    @Test
    public void testFindOpusUserRolesByUserName() {
        List<OpusUserRole> opusUserRoles = opusUserManager.findOpusUserRolesByUserName("uju");
        assertEquals(1, opusUserRoles.size());
        verifyOpusUserRole11(opusUserRoles.get(0));
    }

    @Test
    public void testFindOpusUserRoleByOrgUnit() {
        verifyOpusUserRole11(opusUserManager.findOpusUserRoleByOrgUnit("uju", 18));
    }

    @Test
    public void testFindOpusUserRoleById() {
        verifyOpusUserRole11(opusUserManager.findOpusUserRoleById(11));
    }

    @Test
    public void testFindOrganizationalUnitsNotInUserRole() {
        Map<String, Object> map = new HashMap<>();
        map.put("userName", "uju");
        List<OrganizationalUnit> organizationalUnits = opusUserManager.findOrganizationalUnitsNotInUserRole(map);
        assertEquals(1, organizationalUnits.size());
        assertEquals(19, organizationalUnits.get(0).getId());
    }

    @Test
    public void testAddOpusUserRole() {
        String role = "student";
        String userName = "mylogin";
        int organizationalUnitId = 18;

        // Need to have an OpusUser to be able to add a OpusUserRole
        OpusUser opusUser = new OpusUser(userName, EN, organizationalUnitId, 0);
        opusUserManager.addOpusUser(opusUser);
        
        OpusUserRole opusUserRole = new OpusUserRole(userName, role, organizationalUnitId);
        opusUserManager.addOpusUserRole(opusUserRole);
        
        opusUserRole = opusUserManager.findOpusUserRoleByUserName(userName, organizationalUnitId);
        assertEquals(role, opusUserRole.getRole());
        assertEquals(organizationalUnitId, opusUserRole.getOrganizationalUnitId());
    }

    @Test
    public void testUpdateOpusUserRole() {
        OpusUserRole opusUserRole = opusUserManager.findOpusUserRoleById(12);
        String role = "admin-B";
        opusUserRole.setRole(role);
        opusUserManager.updateOpusUserRole(opusUserRole);

        opusUserRole = opusUserManager.findOpusUserRoleById(12);
        assertEquals(role, opusUserRole.getRole());
    }

    @Test
    public void testDeleteOpusUserRoleById() {
        opusUserManager.deleteOpusUserRoleById(21);
        assertNull(opusUserManager.findOpusUserRoleById(21));
    }

    @Test
    public void testDeleteOpusUserRole() {
        opusUserManager.deleteOpusUserRole(26);
        assertNull(opusUserManager.findOpusUserRoleById(21));
    }

    // ---------- Role -------------
    
    @Test
    public void testFindRole() {
        String role = "student";
        Role student = opusUserManager.findRole(EN, role);
        verifyStudentRoleEn(student);

        student = opusUserManager.findRole(PT, role);
        verifyStudentRolePt(student);
    }

    private void verifyStudentRoleEn(Role student) {
        assertEquals("Student", student.getRoleDescription());
    }
    
    private void verifyStudentRolePt(Role student) {
        assertEquals("Estudante", student.getRoleDescription());
    }

    @Test
    public void testFindRoleLoggedIn() {
        Role student = opusUserManager.findRole("student", EN, "admin");
        verifyStudentRoleEn(student);
        
        // logged in user with role "student" does not have the right to read "admin" role
        assertNull(opusUserManager.findRole("admin", PT, "student"));
    }

    @Test
    public void testFindRolesByParams() {
        List<Role> roles = opusUserManager.findRolesByParams(EN, "teacher");
        assertEquals(2, roles.size());
        assertEquals("teacher", roles.get(0).getRole());
        assertEquals("student", roles.get(1).getRole());
    }

    @Test
    public void testFindRoles() {
        List<Role> roles = opusUserManager.findRoles("a", PT, "teacher");
        
        // must not include "admin" role because level is lower than that of teacher
        assertEquals(1, roles.size());
        assertEquals("teacher", roles.get(0).getRole());
    }
    
    @Test
    public void testFindAllRoles() {
        List<Role> roles = opusUserManager.findAllRoles(EN, "admin");
        assertEquals(3, roles.size());
        
        roles = opusUserManager.findAllRoles(EN, "teacher");
        assertEquals(2, roles.size());
        
        roles = opusUserManager.findAllRoles(EN, "student");
        assertEquals(1, roles.size());
    }
    
    @Test
    public void testAddRole() {
        Role role = new Role(EN, "guest", "Guest", 8);
        opusUserManager.addRole(role);
        
        role = opusUserManager.findRole(EN, "guest");
        assertNotNull(role);
        assertNotEquals(0, role.getId());
        assertEquals(8, role.getLevel());
    }
    
    @Test
    public void testUpdateRole() {
        String roleName = "student";
        String roleDescription = "modified description";

        Role role = opusUserManager.findRole(EN, roleName);
        role.setRoleDescription(roleDescription);
        opusUserManager.updateRole(role);

        role = opusUserManager.findRole(EN, roleName);
        assertEquals(30, role.getId());
        assertEquals(roleDescription, role.getRoleDescription());
    }

    @Test
    public void testDeleteRole() {
        opusUserManager.deleteRole("teacher");
        assertNull(opusUserManager.findRole(EN, "teacher"));
        assertNull(opusUserManager.findRole(PT, "teacher"));
    }

    @Test
    public void testFindRolesWithoutPrivilege() {
        List<Role> roles = opusUserManager.findRolesWithoutPrivilege("ADMINISTER_SYSTEM", EN, "admin");
        assertEquals(2, roles.size());
        assertEquals("student", roles.get(0).getRole());
        assertEquals("teacher", roles.get(1).getRole());
        
        roles = opusUserManager.findRolesWithoutPrivilege("READ_STAFFMEMBERS", EN, "admin");
        assertEquals(0, roles.size());
    }

    @Test
    public void testFindFirstExistingRole() {
        Role role = opusUserManager.findFirstExistingRole(EN, new String[] {"staff", "student"});
        assertEquals("student", role.getRole());
    }

    
    // ----- OpusPrivilege ------
    
    @Test
    public void testFindOpusPrivilegeById() {
        OpusPrivilege opusPrivilege = opusUserManager.findOpusPrivilegeById(250, EN);
        assertEquals("READ_STAFFMEMBERS", opusPrivilege.getCode());
    }

    @Test
    public void testFindOpusPrivileges() {
        Map<String, Object> map = new HashMap<>();
        map.put("preferredLanguage", EN);
        map.put("searchValue", "create");
        List<OpusPrivilege> opusPrivileges = opusUserManager.findOpusPrivileges(map);

        assertEquals(2, opusPrivileges.size());
        assertEquals("Create academic years", opusPrivileges.get(0).getDescription());
        assertEquals("Create subject results by assigned subject teachers", opusPrivileges.get(1).getDescription());
    }

    @Test
    public void testFindOpusPrivilegesNotInRole() {
        List<OpusPrivilege> opusPrivileges = opusUserManager.findOpusPrivilegesNotInRole("admin", EN);
        assertEquals(1, opusPrivileges.size());
        assertEquals("CREATE_RESULTS_ASSIGNED_SUBJECTS", opusPrivileges.get(0).getCode());
    }
    

    // ----- OpusRolePrivilege ------
    
    @Test
    public void testFindOpusRolePrivileges() {
        Map<String, Object> map = new HashMap<>();
        map.put("role", "student");
        map.put("lang", EN);
        List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(map);
        assertEquals(1, opusRolePrivileges.size());
        assertEquals("READ_STAFFMEMBERS", opusRolePrivileges.get(0).getPrivilegeCode());
        
        map.clear();
        map.put("privilegeId", 251);
        opusUserManager.findOpusRolePrivileges(map);
        assertEquals(1, opusRolePrivileges.size());
        assertEquals("READ_STAFFMEMBERS", opusRolePrivileges.get(0).getPrivilegeCode());
    }
    
    @Test
    public void testFindFullOpusRolePrivilege() {
        Map<String, Object> map = new HashMap<>();
        map.put("role", "student");
        map.put("preferredLanguage", EN);
        List<Map<String,Object>> opusRolePrivileges = opusUserManager.findFullOpusRolePrivilege(map, "teacher");
        assertEquals(1, opusRolePrivileges.size());
        assertEquals("READ_STAFFMEMBERS", opusRolePrivileges.get(0).get("privilegeCode"));
        assertEquals("Student", opusRolePrivileges.get(0).get("roleDescription"));
    }
    
    @Test
    public void testAddOpusRolePrivilege() {
        String role = "teacher";
        String privilegeCode = "CREATE_ACADEMIC_YEARS";

        OpusRolePrivilege opusRolePrivilege = new OpusRolePrivilege(role, privilegeCode);
        opusUserManager.addOpusRolePrivilege(opusRolePrivilege);
        
        opusRolePrivilege = opusUserManager.findOpusRolePrivilege(role, privilegeCode);
        assertNotEquals(0, opusRolePrivilege.getId());
        assertEquals(role, opusRolePrivilege.getRole());
    }

    @Test
    public void testAddPrivilegesToRole() {
        String role = "teacher";
        String[] privilegesCodes = new String[] {"ADMINISTER_SYSTEM", "CREATE_ACADEMIC_YEARS"};
        opusUserManager.addPrivilegesToRole(role, privilegesCodes);

        Map<String, Object> map = new HashMap<>();
        map.put("role", role);
        map.put("lang", EN);
        List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(map);
        assertEquals(4, opusRolePrivileges.size());
    }

    @Test
    public void testAddRolesToPrivilege() {
        
        String privilegeCode = "CREATE_ACADEMIC_YEARS";
        String[] roles = new String[] {"teacher", "student"};
        opusUserManager.addRolesToPrivilege(privilegeCode, roles);

        Map<String, Object> map = new HashMap<>();
        map.put("privilegeCode", privilegeCode);
        List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(map);
        assertEquals(3, opusRolePrivileges.size());
    }
    
    @Test
    public void testCopyPrivileges() {
        Role role = new Role(EN, "dummyRole", "A dummy role to copy privileges", 5);
        opusUserManager.addRole(role);
        opusUserManager.copyPrivileges("teacher", "dummyRole");
        
        Map<String, Object> map = new HashMap<>();
        map.put("role", "dummyRole");
        map.put("lang", EN);
        List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(map);
        assertEquals(2, opusRolePrivileges.size());
        
    }
    
    @Test
    public void testUpdateOpusRolePrivilege() {
        OpusRolePrivilege opusRolePrivilege = opusUserManager.findOpusRolePrivilege("teacher", "READ_STAFFMEMBERS");
        opusRolePrivilege.setActive("N");
        opusUserManager.updateOpusRolePrivilege(opusRolePrivilege);
        
        opusRolePrivilege = opusUserManager.findOpusRolePrivilege("teacher", "READ_STAFFMEMBERS");
        assertEquals("N", opusRolePrivilege.getActive());
    }
    
    @Test
    public void testDeleteOpusRolePrivilege() {
        opusUserManager.deleteOpusRolePrivilege(1823);
        assertNull(opusUserManager.findOpusRolePrivilege("teacher", "READ_STAFFMEMBERS"));
    }

    @Test
    public void testDeletePrivilegesFromRole() {
        opusUserManager.deletePrivilegesFromRole("teacher", new String[] {"CREATE_RESULTS_ASSIGNED_SUBJECTS", "READ_STAFFMEMBERS"});
        
        Map<String, Object> map = new HashMap<>();
        map.put("role", "teacher");
        List<OpusRolePrivilege> opusRolePrivileges = opusUserManager.findOpusRolePrivileges(map);
        assertEquals(0, opusRolePrivileges.size());

    }

}
