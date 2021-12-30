package org.uci.opus.college.service;

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

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class QueryUtilitiesManagerTest extends OpusDBTestCase {

	@Autowired
	private QueryUtilitiesManagerInterface queryUtilitiesManager;

	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.country")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/QueryUtilitiesManagerTest-prepData.xml");
    }

    @Test
    public void testExistsTable() {
        assertTrue(queryUtilitiesManager.existsTable("country"));
        assertFalse(queryUtilitiesManager.existsTable("nonExistingTable"));
    }

    @Test
    public void testExistsValue() {
        assertTrue(queryUtilitiesManager.existsValue("country", "short3", "DNK"));
        assertFalse(queryUtilitiesManager.existsValue("country", "short3", "ZZ"));
    }

    @Test
    public void testCountValue() {
        assertEquals(2, queryUtilitiesManager.countValue("country", "short3", "DNK"));
        assertEquals(0, queryUtilitiesManager.countValue("country", "short3", "ZZ"));
    }


}
