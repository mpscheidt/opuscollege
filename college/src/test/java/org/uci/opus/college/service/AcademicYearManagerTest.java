package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

import java.util.List;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.fixture.AcademicYearFixture;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class AcademicYearManagerTest extends OpusDBTestCase {

	@Autowired
	private AcademicYearManagerInterface academicYearManager;
	
	private AcademicYear academicYear2014 = AcademicYearFixture.academicYear2014();
	private AcademicYear academicYear2015 = AcademicYearFixture.academicYear2015();

	@Before
	public void setUp() throws Exception {
		
		academicYearManager.addAcademicYear(academicYear2014);
		assertNotEquals(0, academicYear2014.getId());

		academicYearManager.addAcademicYear(academicYear2015);
		assertNotEquals(0, academicYear2015.getId());
		
		academicYear2014.setNextAcademicYearId(academicYear2015.getId());
		academicYearManager.updateAcademicYear(academicYear2014);
		
		AcademicYear loaded2014 = academicYearManager.findAcademicYear(academicYear2014.getId());
		assertEquals(academicYear2015.getId(), loaded2014.getNextAcademicYearId());
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.academicyear")
        });
        return dataSetToTruncate;
    }

    @Test
    public void testFindOne() {
        
        AcademicYear academicYear = academicYearManager.findAcademicYear(academicYear2014.getId());
        assertNotNull(academicYear);
        assertEquals(academicYear2014.getDescription(), academicYear.getDescription());
    }
    
	@Test
	public void testfindAllYears() {
		
		List<AcademicYear> academicYears = academicYearManager.findAllAcademicYears();
		assertEquals(2, academicYears.size());
		
		assertEquals(academicYear2015.getDescription(), academicYears.get(0).getDescription());
		assertEquals(academicYear2014.getDescription(), academicYears.get(1).getDescription());
	}

	@Test
	public void deleteAcademicYear2015() {
		
		academicYearManager.deleteAcademicYear(academicYear2015.getId());

		List<AcademicYear> academicYears = academicYearManager.findAllAcademicYears();
		assertEquals(1, academicYears.size());
		
		assertEquals(academicYear2014.getDescription(), academicYears.get(0).getDescription());
	}
	
}
