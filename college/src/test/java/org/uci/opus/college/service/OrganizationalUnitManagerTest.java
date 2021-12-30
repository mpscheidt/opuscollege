package org.uci.opus.college.service;

import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;
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
import org.springframework.test.context.web.WebAppConfiguration;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.util.DateUtil;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-util.xml",
        "/org/uci/opus/college/applicationContext-service.xml", })
public class OrganizationalUnitManagerTest extends OpusDBTestCase {

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;

    @Before
    public void setUp() throws Exception {
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(
				new ITable[] { new DefaultTable("opuscollege.institution")
						, new DefaultTable("opuscollege.academicyear")
						});
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/OrganizationalUnitManagerTest-prepData.xml");
    }

    @Test
    public void testFindOrganizationalUnitsInstitutionId0() {
        Map<String, Object> map = new HashMap<>();
        map.put("institutionId", 0);
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnits(map);
        assertNotNull(organizationalUnits);
        assertEquals(5, organizationalUnits.size());

    }

    @Test
    public void testFindOrganizationalUnits() {
        Map<String, Object> map = new HashMap<>();
        map.put("branchId", 118);
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnits(map);
        assertNotNull(organizationalUnits);
        assertEquals(3, organizationalUnits.size());
    }

    @Test
    public void testFindOrganizationalUnitsByBranchId() {
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnits(119);
        assertNotNull(organizationalUnits);
        assertEquals(2, organizationalUnits.size());
    }

    @Test
    public void testFindOrganizationalUnitsCrawlTree() {
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitId", 18);
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnits(map);
        assertNotNull(organizationalUnits);
        // One parent with two children = 3
        assertEquals(3, organizationalUnits.size());

    }

    @Test
    public void findTreeOfOrganizationalUnitIds() {
        List<Integer> organizationalUnitIds = organizationalUnitManager.findTreeOfOrganizationalUnitIds(18);
        assertNotNull(organizationalUnitIds);
        assertEquals(3, organizationalUnitIds.size());
        assertTrue(organizationalUnitIds.contains(18));
        assertTrue(organizationalUnitIds.contains(19));
        assertTrue(organizationalUnitIds.contains(20));
    }

    @Test
    public void testFindOrganizationalUnitsOrgUnitIds() {
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitIds", Arrays.asList(18, 19));
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findOrganizationalUnits(map);
        assertNotNull(organizationalUnits);
        assertEquals(2, organizationalUnits.size());

    }

    @Test
    public void testFindOrganizationalUnit() throws ParseException {
        OrganizationalUnit ou = organizationalUnitManager.findOrganizationalUnit(19);
        assertNotNull(ou);
        assertEquals("O1-1", ou.getOrganizationalUnitCode());
        assertEquals(1, ou.getAdmissionRegistrationConfigs().size());
        assertEquals(DateUtil.parseIsoDate("2012-01-01"), ou.getAdmissionRegistrationConfigs().get(0).getStartOfRegistration());
    }

    @Test
    public void testFindOrganizationalUnitOfStudy() {
        OrganizationalUnit ou = organizationalUnitManager.findOrganizationalUnitOfStudy(38);
        assertNotNull(ou);
        assertEquals(18, ou.getId());
    }

    @Test
    public void testFindAllOrganizationalUnitAtLevel() {
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findAllOrganizationalUnitAtLevel(2, 118);
        assertNotNull(organizationalUnits);
        assertEquals(2, organizationalUnits.size());
    }

    @Test
    public void testFindAllChildrenForOrganizationalUnit() {
        List<OrganizationalUnit> organizationalUnits = organizationalUnitManager.findAllChildrenForOrganizationalUnit(18);
        assertNotNull(organizationalUnits);
        assertEquals(2, organizationalUnits.size());
    }

    @Test
    public void testFindAddOrganizationalUnit() {
        OrganizationalUnit newOu = new OrganizationalUnit("outest", "Test Org. Unit", 18);
        organizationalUnitManager.addOrganizationalUnit(newOu);
        assertTrue(newOu.getId() != 0);
    }

    @Test
    public void testUpdateOrganizationalUnit() {
        String description = "modified description";
        OrganizationalUnit ou = organizationalUnitManager.findOrganizationalUnit(32);
        ou.setOrganizationalUnitDescription(description);
        organizationalUnitManager.updateOrganizationalUnit(ou);

        ou = organizationalUnitManager.findOrganizationalUnit(32);
        assertEquals(description, ou.getOrganizationalUnitDescription());
    }

    @Test
    public void testDeleteOrganizationalUnit() {
    	// make sure to delete an org unit for which there are no study records to avoid referential integrity violations
        organizationalUnitManager.deleteOrganizationalUnit(33);
        OrganizationalUnit ou = organizationalUnitManager.findOrganizationalUnit(33);
        assertNull(ou);
    }

    @Test
    public void testFindAdmissionRegistrationConfig() {
        AdmissionRegistrationConfig config = organizationalUnitManager.findAdmissionRegistrationConfig(1);
        assertNotNull(config);
        assertEquals(19, config.getOrganizationalUnitId());
    }

    @Test
    public void testDeleteAdmissionRegistrationConfig() {
        organizationalUnitManager.deleteAdmissionRegistrationConfig(1);
        assertNull(organizationalUnitManager.findAdmissionRegistrationConfig(1));
    }

    @Test
    public void testFindAdmissionRegistrationConfigByOrgUnitAndAcadYear() {
        AdmissionRegistrationConfig config = organizationalUnitManager.findAdmissionRegistrationConfig(19, 44);
        assertNotNull(config);

        config = organizationalUnitManager.findAdmissionRegistrationConfig(20, 44);
        assertNull(config);

        config = organizationalUnitManager.findAdmissionRegistrationConfig(20, 44, true);
        assertNotNull(config);
        assertEquals(5, config.getId());
    }

    @Test
    public void testUpdateOrAddAdmissionRegistrationConfig() {
        AdmissionRegistrationConfig config = organizationalUnitManager.findAdmissionRegistrationConfig(1);
        Date date = new Date();
        config.setStartOfAdmission(date);
        config.setWriteWho("unittest");
        organizationalUnitManager.updateOrAddAdmissionRegistrationConfig(config);
        assertEquals(config.getId(), organizationalUnitManager.findAdmissionRegistrationConfig(19, 44).getId());

        config = new AdmissionRegistrationConfig(20, 44);
        config.setWriteWho("unittest");
        organizationalUnitManager.updateOrAddAdmissionRegistrationConfig(config);
        assertTrue(organizationalUnitManager.findAdmissionRegistrationConfig(20, 44).getId() != 0);
    }

}
