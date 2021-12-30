package org.uci.opus.college.persistence;

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
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ReportMapperTest extends OpusDBTestCase {

	@Autowired
	private ReportMapper reportMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/ReportMapperTest-prepData.xml");
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.studyplandetail"),
                new DefaultTable("opuscollege.subject")
        });
        return dataSetToTruncate;
    }

    @Test
    public void testFindStudents() {
        
        Map<String, Object> map = makeMap();
        
        List<Map<String, Object>> students = reportMapper.findStudents(map);
        assertEquals(1, students.size());

        Map<String, Object> student = students.get(0);
        assertEquals("Mary", student.get("firstnamesfull"));
        assertEquals("Adams", student.get("surnamefull"));
        assertEquals(317, student.get("studentid"));
        assertEquals(36, student.get("personid"));
        assertEquals("am", student.get("studentcode"));
        assertEquals("Physics", student.get("studydescription"));

    }
    
	@Test
	public void testFindStudyplanCardinalTimeUnits() {
		
		Map<String, Object> map = makeMap();
		
		List<Map<String, Object>> studyplanctus = reportMapper.findStudyplanCardinalTimeUnits(map);
		
		// Expect two records because student has two spctus 
		assertEquals(2, studyplanctus.size());
		Map<String, Object> spctu0 = studyplanctus.get(0);
		assertMaryAdams(spctu0, 415, 1);

		Map<String, Object> spctu1 = studyplanctus.get(1);
		assertMaryAdams(spctu1, 485, 2);
	}

	private void assertMaryAdams(Map<String, Object> spctu, Integer spctuId, Integer ctunr) {
		assertEquals("Mary", spctu.get("firstnamesfull"));
		assertEquals("Adams", spctu.get("surnamefull"));
		assertEquals(317, spctu.get("studentid"));
		assertEquals(36, spctu.get("personid"));
		assertEquals("am", spctu.get("studentcode"));
		assertEquals("Bachelor", spctu.get("gradetypedescription"));
		assertEquals(spctuId, (Integer) spctu.get("studyPlanCardinalTimeUnitId"));
		assertEquals("Semester", spctu.get("cardinaltimeunitdescription"));
		assertEquals(ctunr, (Integer) spctu.get("cardinaltimeunitnumber"));
	}

	private Map<String, Object> makeMap() {
		Map<String, Object> map = new HashMap<>();
		map.put("institutionId", 107);
		map.put("branchId", 118);
		map.put("organizationalUnitId", 18);
		map.put("studyId", 1213);
		map.put("studyGradeTypeId", 256);
		map.put("academicYearId", 1);
		map.put("lang", "en");
		map.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
		return map;
	}

	@Test
	public void testFindStudyPlansByName() {
		
		Map<String, Object> map = makeMap();
		
		List<Map<String, Object>> studyplans = reportMapper.findStudyPlansByName(map);
		assertEquals(1, studyplans.size());

		Map<String, Object> studyplan = studyplans.get(0);
		assertEquals("Mary", studyplan.get("firstnamesFull"));
		assertEquals("Adams", studyplan.get("surnameFull"));
		assertEquals(36, studyplan.get("personId"));
	}

	@Test
	public void testFindCTUStudygradetypes() {

		Map<String, Object> map = makeMap();
		
		List<Map<String, Object>> ctusgts = reportMapper.findCTUStudygradetypes(map);
		assertEquals(2, ctusgts.size());
		
		assertCtusgt(ctusgts.get(0), 1);
		assertCtusgt(ctusgts.get(1), 2);
	}

	private void assertCtusgt(Map<String, Object> ctusgt, int cardinaltimeunitnumber) {
		assertEquals(256, ctusgt.get("studygradetypeid"));
		assertEquals(1, ctusgt.get("currentacademicyearid"));
		assertEquals(new Long(1), ctusgt.get("count"));
		assertEquals("Semester", ctusgt.get("cardinaltimeunitdescription"));
		assertEquals(cardinaltimeunitnumber, ctusgt.get("cardinaltimeunitnumber"));
	}

}
