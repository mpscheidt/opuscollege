package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

import java.math.BigDecimal;
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
import org.uci.opus.college.domain.EndGrade;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class EndgradeManagerTest extends OpusDBTestCase {

	@Autowired
	private EndGradeManagerInterface endGradeManager;
	
	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.endgrade"),
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("audit.endgrade_hist")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/EndgradeManagerTest-prepData.xml");
    }

    @Test
    public void testPersonAddress() {
    	EndGrade endgrade = endGradeManager.findEndGradeById(17180);
    	assertEquals(237, endgrade.getAcademicYearId());
    	assertEquals("A", endgrade.getCode());
    	assertEquals("BSC", endgrade.getEndGradeTypeCode());
    	assertEquals(new BigDecimal("2.00"), endgrade.getGradePoint());
    }

    @Test
	public void testAddEndgrade() {
		EndGrade endgrade = new EndGrade();
        endgrade.setActive("Y");
    	endgrade.setAcademicYearId(237);
    	endgrade.setCode("B+");
    	endgrade.setComment("Meritorious");
    	endgrade.setEndGradeTypeCode("BSC");
    	endgrade.setGradePoint(new BigDecimal("3.00"));
        endgrade.setLang("en");
        endgrade.setPassed("Y");
    	endgrade.setPercentageMin(new BigDecimal("67.60"));
    	endgrade.setPercentageMax(new BigDecimal("75.59"));
    	endgrade.setWriteWho("test");
    	endGradeManager.addEndGrade(endgrade);
    	
    	assertNotEquals(0, endgrade.getId());
    	
    	EndGrade loadedEndgrade = endGradeManager.findEndGradeById(endgrade.getId());
    	assertNotNull(loadedEndgrade);
    	assertEquals("B+", loadedEndgrade.getCode());
	}

    @Test
    public void testFindEndgrade() {
        EndGrade loadedEndGrade = endGradeManager.findEndgrade("B", "MSC", 237, "en");
        assertNotNull(loadedEndGrade);
        assertEquals(new BigDecimal("3.00"), loadedEndGrade.getGradePoint());
    }
    
    @Test
    public void testFindEndgradesAsMaps() {
        Map<String, Object> findEndGradesMap = new HashMap<>();
        findEndGradesMap.put("lang", "en");
        List<Map> endgrades = endGradeManager.findEndGradesAsMaps(findEndGradesMap);
        assertEquals(4, endgrades.size());
//        assertNotNull(loadedEndGrade);
//        assertEquals(new BigDecimal("3.00"), loadedEndGrade.getGradePoint());
    }
    
    @Test
    public void testUpdateEndGrade() {
        EndGrade endGrade = endGradeManager.findEndGradeById(17187);
        assertNotNull(endGrade);
        endGrade.setComment("updated comment");
        endGradeManager.updateEndGrade(endGrade);

        // MP deactivated because not available in DAO (only in Mapper) TODO reactivate after migration to MyBatis
//        List<EndGradeHistory> endgradeHist = endGradeManager.findEndGradeHistory(endGrade.getId());
//        assertNotNull(endgradeHist);
//        assertEquals(1, endgradeHist.size());
//        assertEquals('U', endgradeHist.get(0).getOperation());
//        assertEquals("A", endgradeHist.get(0).getCode());
//        assertEquals("MSC", endgradeHist.get(0).getEndGradeTypeCode());
    }
    
    @Test
    public void deleteEndGradeSet() {
        endGradeManager.deleteEndGradeSet("A", "BSC", 237, "test");
        assertEquals(3, endGradeManager.findAllEndGrades("en").size());
        assertNull(endGradeManager.findEndgrade("A", "BSC", 237, "en"));
    }
    
    @Test
    public void testEndGradeExists() {
        EndGrade g = new EndGrade();
        g.setCode("A");
        g.setLang("en");
        g.setEndGradeTypeCode("BSC");
        g.setAcademicYearId(237);
        assertTrue(endGradeManager.isEndGradeExists(g));
        
    }
}
