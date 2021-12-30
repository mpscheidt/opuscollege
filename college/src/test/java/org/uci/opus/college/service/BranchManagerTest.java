package org.uci.opus.college.service;

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
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" })
public class BranchManagerTest extends OpusDBTestCase {

    @Autowired
    private BranchManagerInterface branchManager;

    @Before
    public void setUp() throws Exception {
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { new DefaultTable("opuscollege.organizationalunit") });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/BranchManagerTest-prepData.xml");
    }

    @Test
    public void testFindBranches107() {

        List<Branch> branches = branchManager.findBranches(107);
        assertNotNull(branches);
        assertEquals(2, branches.size());
    }

    @Test
    public void findBranch() {
        Branch b = branchManager.findBranch(131);
        assertNotNull(b);
        assertEquals("AB", b.getBranchCode());
        assertEquals(108, b.getInstitutionId());
    }

    @Test
    public void testFindBranchByParams() {

        Map<String, Object> map = new HashMap<>();
        map.put("institutionId", 107);
        map.put("branchCode", "06");
        map.put("branchDescription", "UCM FD");
        Branch b = branchManager.findBranchByParams(map);
        assertNotNull(b);
        assertEquals("06", b.getBranchCode());
    }

    @Test
    public void findBranchAcademicYearTimeUnitsNoArgs() {
        List<BranchAcademicYearTimeUnit> bats = branchManager.findBranchAcademicYearTimeUnits(new HashMap<String, Object>());
        assertNotNull(bats);
        assertEquals(2, bats.size());
    }

    @Test
    public void findBranchAcademicYearTimeUnitsBranchId() {
        HashMap<String, Object> map = new HashMap<>();
        map.put("branchId", 118);
        map.put("academicYearId", 44);
        List<BranchAcademicYearTimeUnit> bats = branchManager.findBranchAcademicYearTimeUnits(map);
        assertNotNull(bats);
        assertEquals(2, bats.size());

        map.put("branchId", 131);
        bats = branchManager.findBranchAcademicYearTimeUnits(map);
        assertEquals(0, bats.size());
    }

}
