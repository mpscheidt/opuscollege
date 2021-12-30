package org.uci.opus.college.service;

import java.text.ParseException;
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
import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.Encode;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-util.xml", "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/college/applicationContext-data.xml" })
public class StaffMemberManagerTest extends OpusDBTestCase {

    @Autowired
    private StaffMemberManagerInterface staffMemberManager;

    @Before
    public void setUp() throws Exception {
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { new DefaultTable("opuscollege.institution"), new DefaultTable("opuscollege.person"),
                new DefaultTable("opuscollege.academicyear"), new DefaultTable("opuscollege.opususerrole"), new DefaultTable("opuscollege.opususer") });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/StaffMemberManagerTest-prepData.xml");
    }

    @Test
    public void testFindAllStaffMembers() {
        List<StaffMember> staffMembers = staffMemberManager.findAllStaffMembers(OpusConstants.LANGUAGE_EN);
        assertNotNull(staffMembers);
        assertEquals(2, staffMembers.size());
    }

    @Test
    public void testFindStaffMembers() {
        Map<String, Object> staffMemberMap = new HashMap<>();
        staffMemberMap.put("branchId", 118);
        staffMemberMap.put("organizationalUnitId", 18);
        List<StaffMember> staffMembers = staffMemberManager.findStaffMembers(staffMemberMap);
        assertEquals(1, staffMembers.size());

        verifyStaffMember1(staffMembers.get(0));

        staffMemberMap.put("organizationalUnitId", 0);
        staffMembers = staffMemberManager.findStaffMembers(staffMemberMap);
        assertEquals(2, staffMembers.size());

    }

    /**
     * Check staffMember with id=1 if result map works and all related records are available as expected.
     * 
     * @param staffMember
     */
    private void verifyStaffMember1(StaffMember staffMember) {
        assertEquals(2, staffMember.getFunctions().size());
        assertEquals("5", staffMember.getFunctions().get(0).getFunctionCode());

        assertEquals(1, staffMember.getContracts().size());
        assertEquals("CC1", staffMember.getContracts().get(0).getContractCode());

        assertEquals(1, staffMember.getAddresses().size());
        assertEquals("Home drive", staffMember.getAddresses().get(0).getStreet());

        assertEquals(2, staffMember.getSubjectsTaught().size());
        assertEquals(5497, staffMember.getSubjectsTaught().get(0).getSubjectId());
        assertEquals(new Integer(1), staffMember.getSubjectsTaught().get(0).getClassgroupId());
        assertEquals("Turma A", staffMember.getSubjectsTaught().get(0).getClassgroup().getDescription());

        assertEquals(2, staffMember.getExaminationsTaught().size());
        assertEquals(43, staffMember.getExaminationsTaught().get(0).getExaminationId());

        assertEquals(2, staffMember.getTestsSupervised().size());
        assertEquals(11, staffMember.getTestsSupervised().get(0).getTestId());
    }

    @Test
    public void testFindStaffMember() {
        verifyStaffMember1(staffMemberManager.findStaffMember(OpusConstants.LANGUAGE_EN, 1));
    }

    @Test
    public void testFindStaffMemberByPersonId() {
        verifyStaffMember1(staffMemberManager.findStaffMemberByPersonId(16));
    }

    @Test
    public void testFindStaffMemberIdByPersonId() {
        assertEquals(1, staffMemberManager.findStaffMemberIdByPersonId(16));
        assertEquals(2, staffMemberManager.findStaffMemberIdByPersonId(17));
        assertEquals(0, staffMemberManager.findStaffMemberIdByPersonId(0));
    }

    @Test
    public void testFindStaffMemberByCode() {
        verifyStaffMember1(staffMemberManager.findStaffMemberByCode(OpusConstants.LANGUAGE_EN, "ju"));
    }

    @Test
    public void testAlreadyExistsStaffMemberCode() {
        assertTrue(staffMemberManager.alreadyExistsStaffMemberCode("ju", 0));
        assertFalse(staffMemberManager.alreadyExistsStaffMemberCode("ju", 1));
    }

    @Test
    public void testCountStaffMembers() {
        Map<String, Object> map = new HashMap<>();
        map.put("staffMemberCode", "ju");
        assertEquals(1, staffMemberManager.countStaffMembers(map));
        
        map.put("birthdate", DateUtil.parseIsoDateNoExc("1981-03-17"));
        assertEquals(1, staffMemberManager.countStaffMembers(map));

        map.clear();
        map.put("surnameFull", "Juergens");
        assertEquals(1, staffMemberManager.countStaffMembers(map));

        map.clear();
        map.put("firstNamesFull", "Udo");
        assertEquals(1, staffMemberManager.countStaffMembers(map));

        map.clear();
        map.put("firstNamesFull", "non-existing");
        assertEquals(0, staffMemberManager.countStaffMembers(map));
    }

    @Test
    public void testFindOrganizationalUnitForStaffMember() {
        assertEquals(18, staffMemberManager.findOrganizationalUnitForStaffMember(16).getId());
        assertEquals(19, staffMemberManager.findOrganizationalUnitForStaffMember(17).getId());
        assertNull(staffMemberManager.findOrganizationalUnitForStaffMember(0));
    }

    @Test
    public void testContractsForStaffMember() {
        List<Contract> contracts = staffMemberManager.findContractsForStaffMember(2);
        assertNotNull(contracts);
        assertEquals(1, contracts.size());
        assertEquals("CC2", contracts.get(0).getContractCode());
    }

    @Test
    public void testFindFunctionsForStaffMember() {
        List<StaffMemberFunction> functions = staffMemberManager.findFunctionsForStaffMember(2);
        assertNotNull(functions);
        assertEquals(1, functions.size());
        assertEquals("12", functions.get(0).getFunctionCode());
    }

    @Test
    public void testFindSubjectsForStaffMember() {
        List<SubjectTeacher> subjectTeachers = staffMemberManager.findSubjectsForStaffMember(2);
        assertNotNull(subjectTeachers);
        assertEquals(2, subjectTeachers.size());
        assertEquals(5501, subjectTeachers.get(0).getSubjectId());
    }

    @Test
    public void testFindExaminationsForStaffMember() {
        List<ExaminationTeacher> examinationTeachers = staffMemberManager.findExaminationsForStaffMember(2);
        assertNotNull(examinationTeachers);
        assertEquals(2, examinationTeachers.size());
        assertEquals(45, examinationTeachers.get(0).getExaminationId());
    }

    @Test
    public void testFindTestsForStaffMember() {
        List<TestTeacher> testTeachers = staffMemberManager.findTestsForStaffMember(2);
        assertNotNull(testTeachers);
        assertEquals(2, testTeachers.size());
        assertEquals(13, testTeachers.get(0).getTestId());
    }

    @Test
    public void testAddFunctionToStaffMember() {
        staffMemberManager.addFunctionToStaffMember(2, "3", "2");
        List<StaffMemberFunction> functions = staffMemberManager.findFunctionsForStaffMember(2);
        assertNotNull(functions);
        assertEquals(2, functions.size());
    }

    @Test
    public void testAddStaffMember() throws ParseException {
        int organizationalUnitId = 18;
        StaffMember staffMember = new StaffMember("perscode", "Test", "Monsieur", DateUtil.parseIsoDate("1999-09-09"), "staffcode", organizationalUnitId);
        staffMember.setWriteWho("unittest");

        String userName = "mon";
        OpusUserRole staffOpusUserRole = new OpusUserRole("teacher", userName, organizationalUnitId);

        OpusUser staffOpusUser = new OpusUser(userName, OpusConstants.LANGUAGE_EN, organizationalUnitId);
        staffOpusUser.setPw(Encode.encodeMd5(staffMember.getSurnameFull() + "2014"));

        staffMemberManager.addStaffMember(staffMember, staffOpusUserRole, staffOpusUser);

        StaffMember s = staffMemberManager.findStaffMember(OpusConstants.LANGUAGE_EN, staffMember.getStaffMemberId());
        assertNotNull(s);
        assertEquals("perscode", s.getPersonCode());

    }

    @Test
    public void testUpdateStaffMember() throws ParseException {
        StaffMember s = staffMemberManager.findStaffMemberByPersonId(16);
        String jenny = "Jenny";
        s.setFirstnamesFull(jenny);
        staffMemberManager.updateStaffMember(s);
        
        StaffMember loaded = staffMemberManager.findStaffMemberByPersonId(16);
        assertEquals(jenny, loaded.getFirstnamesFull());
    }

    @Test
    public void testDeleteStaffMember() {
        staffMemberManager.deleteStaffMember(OpusConstants.LANGUAGE_EN, 2, "unittest");
        assertNull(staffMemberManager.findStaffMemberByPersonId(17));
        assertTrue(staffMemberManager.findContractsForStaffMember(2).isEmpty());
    }

    @Test
    public void testfindPersonId() {
        assertEquals(16, staffMemberManager.findPersonId(1));
        assertEquals(17, staffMemberManager.findPersonId(2));
        assertEquals(0, staffMemberManager.findPersonId(0));
    }

    @Test
    public void testfindAllContacts() {
        assertEquals(1, staffMemberManager.findAllContacts(18).size());
        assertEquals(1, staffMemberManager.findAllContacts(19).size());
    }
}
