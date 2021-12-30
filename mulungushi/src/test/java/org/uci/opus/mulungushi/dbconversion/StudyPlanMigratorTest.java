package org.uci.opus.mulungushi.dbconversion;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/mulungushi/applicationContext-service.xml",
    "/org/uci/opus/mulungushi/mulungushi-beans.xml"
    })
public class StudyPlanMigratorTest {
	
	@Autowired
	private StudyPlanMigrator studyPlanMigrator;

	@Test
	public void testGetCardinalTimeUnitNumbers() {
		
		List<Integer> ctuNumbers = studyPlanMigrator.getCardinalTimeUnitNumbers("BABM II", "Semester I");
		assertEquals(1, ctuNumbers.size());
		assertTrue(ctuNumbers.contains(3));
		
	}

	@Test
	public void testGetSemesterNumbers() {
		
		List<Integer> semesterNumbers = studyPlanMigrator.getSemesterNumbers("Semester II");
		assertEquals(1, semesterNumbers.size());
		assertTrue(semesterNumbers.contains(2));

		semesterNumbers = studyPlanMigrator.getSemesterNumbers("Semester I");
		assertEquals(1, semesterNumbers.size());
		assertTrue(semesterNumbers.contains(1));

		semesterNumbers = studyPlanMigrator.getSemesterNumbers("Year I");
		assertEquals(2, semesterNumbers.size());
		assertTrue(semesterNumbers.contains(1));
		assertTrue(semesterNumbers.contains(2));
		
		semesterNumbers = studyPlanMigrator.getSemesterNumbers("abc I");
		assertTrue(semesterNumbers.isEmpty());

	}

}
