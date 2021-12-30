package org.uci.opus.mulungushi.dbconversion;

import static org.junit.Assert.*;

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
public class ProgrammeMigratorTest {
	
	@Autowired
	private ProgrammeMigrator programmeMigrator;

	@Test
	public void testGetProgramYearNumber() {
		assertEquals((Integer)2, programmeMigrator.getProgramYearNumber("BABM II"));
	}

}
