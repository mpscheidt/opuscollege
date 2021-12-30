package org.uci.opus.accommodation.data;

import javax.sql.DataSource;

import org.dbunit.Assertion;
import org.dbunit.DBTestCase;
import org.dbunit.DataSourceDatabaseTester;
import org.dbunit.IDatabaseTester;
import org.dbunit.database.DatabaseConfig;
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
import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.college.domain.Lookup;

import util.TestDatabaseConfig;

/*
 * Note: To run this test in Eclipse, add to classpath (see Run configurations...):
 * opus/src/main/webapp/WEB-INF/classes
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/accommodation/applicationContext-service.xml"})
public class HostelTester extends DBTestCase{

	@Autowired private DataSource dataSource;
	@Autowired private HostelManagerInterface hostelManager;
	@Override
	protected IDataSet getDataSet() throws Exception {
		 // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/accommodation/data/prepData.xml");
        return dataSet;
	}
	
    /**
     * Override method to set custom properties/features
     */
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        TestDatabaseConfig.setUpDatabaseConfig(config);
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        return new DataSourceDatabaseTester(dataSource);
    }
    
    @Before
    public void setUp() throws Exception {
        // The super.setUp() call is important to initialize the database content
        // Strangely, SpringJUnit4ClassRunner doesn't call setUp() without @Before tag
        super.setUp();
        
    }
    
    @Test
    public void testHostelType() throws Exception {

    	Lookup hostelType=new Lookup();
    	hostelType.setId(2);
        hostelType.setCode("NEW");
        hostelType.setDescription("New Hostel");
        hostelType.setLang("en");

        // TODO use lookupManager to persist
//        hostelDao.updateHostelType(hostelType);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/accommodation/data/postInsertUpdateTestHostel.xml");

        ITable actualTestResultTable = databaseDataSet.getTable("opuscollege.acc_hosteltype");
        ITable expectedTestResultTable = expectedDataSet.getTable("opuscollege.acc_hosteltype");
        Assertion.assertEqualsIgnoreCols(expectedTestResultTable, 
                actualTestResultTable,
                new String[] {"id", "writewhen", "writewho"});
    }
    
    @Test
    public void testHostel() throws Exception {

    	Hostel hostel=new Hostel();
        hostel.setId(20);
    	hostel.setCode("ZMB");
        hostel.setDescription("Zambezi Hostel");
        hostel.setNumberOfFloors(2);
        hostel.setHostelTypeCode("NEW");
        hostel.setWriteWho("test");
        
        hostelManager.updateHostel(hostel);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/accommodation/data/postInsertUpdateTestHostel.xml");

        ITable actualTestResultTable = databaseDataSet.getTable("opuscollege.acc_hostel");
        ITable expectedTestResultTable = expectedDataSet.getTable("opuscollege.acc_hostel");
                
        Assertion.assertEqualsIgnoreCols(expectedTestResultTable, 
                actualTestResultTable,
                new String[] {"id", "writewhen", "writewho"});
    }
    
    /*      
    @Test
    public void testAccommodationFee() throws Exception {
    	Hostel hostel=new Hostel();
        hostel.setId(20);
    	hostel.setCode("ZMB");
        hostel.setDescription("Zambezi Hostel");
        hostel.setNumberOfFloors(2);
        hostel.setHostelTypeId(2);
        
        Fee fee=new Fee();
        fee.setId(20);
        fee.setAcademicYearId(14);
        fee.setFeeDue(BigDecimal.valueOf(20000));
        fee.setStudyGradeTypeId(20);
                
        accommodationDao.updateAccommodationFee(fee);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/accommodation/data/postInsertUpdateTestHostel.xml");

        ITable actualTestResultTable = databaseDataSet.getTable("opuscollege.acc_accommodationfee");
        ITable expectedTestResultTable = expectedDataSet.getTable("opuscollege.acc_accommodationfee");
                
        Assertion.assertEqualsIgnoreCols(expectedTestResultTable, 
                actualTestResultTable,
                new String[] {"id", "writewhen", "writewho","active"});
    }
                */
}