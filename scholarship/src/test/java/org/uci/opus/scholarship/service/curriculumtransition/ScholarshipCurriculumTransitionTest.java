package org.uci.opus.scholarship.service.curriculumtransition;

//
//Note that running this test requires the following in the classpath:
// - /college/src/main/java
// - /college/src/main/webapp
// - /college/src/test/java
// - /scholarship/src/test/java
// - /scholarship/src/main/webapp
//(in Eclpse just add the above to the classpath in: "Run Configuration...")
//

import javax.sql.DataSource;

import org.dbunit.Assertion;
import org.dbunit.DBTestCase;
import org.dbunit.DataSourceDatabaseTester;
import org.dbunit.IDatabaseTester;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.operation.DatabaseOperation;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.scholarship.persistence.ScholarshipFeePercentageMapper;
import org.uci.opus.scholarship.persistence.ScholarshipMapper;
import org.uci.opus.scholarship.persistence.SponsorMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-data.xml", "/org/uci/opus/college/applicationContext-util.xml",
        "/org/uci/opus/college/applicationContext-service.xml", "/org/uci/opus/scholarship/applicationContext-service.xml" })
public class ScholarshipCurriculumTransitionTest extends DBTestCase {

    private static Logger log = LoggerFactory.getLogger(ScholarshipCurriculumTransitionTest.class);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private SponsorMapper sponsorMapper;

    @Autowired
    private ScholarshipFeePercentageMapper scholarshipFeePercentageMapper;
    
    @Autowired
    private ScholarshipTransition scholarshipTransition;

    @Autowired
    private ScholarshipMapper scholarshipMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {

        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/scholarship/service/curriculumtransition/prepData-scholarshipCurriculumTransitionTest.xml");
        return dataSet;
    }

    /**
     * Override method to set custom properties/features
     */
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        config.setProperty(DatabaseConfig.FEATURE_QUALIFIED_TABLE_NAMES, true);
        config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new org.dbunit.ext.postgresql.PostgresqlDataTypeFactory());
        // TestDatabaseConfig.setUpDatabaseConfig(config);
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        return new DataSourceDatabaseTester(dataSource);
    }

    @Before
    public void setUp() throws Exception {
        log.info("Setting up...");

        // empty tables to avoid foreign key problems
        IDataSet dataSet = new DefaultDataSet(new ITable[] { new DefaultTable("opuscollege.sch_scholarshipFeePercentage"),
                new DefaultTable("opuscollege.sch_scholarshipapplication"), new DefaultTable("opuscollege.endgrade"), new DefaultTable("opuscollege.acc_studentaccommodation"),
                new DefaultTable("opuscollege.admissionregistrationconfig") });
        DatabaseOperation.DELETE_ALL.execute(getConnection(), dataSet);

        // The super.setUp() call is important to initialize the database content
        // Strangely, SpringJUnit4ClassRunner doesn't call setUp() without @Before tag
        super.setUp();

    }

    @After
    public void onTearDownInTransaction() throws Exception {
        log.info("tear down");

        super.tearDown();
    }

    @Test
    public void testIntegrityOfPrepData() throws Exception {
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/scholarship/service/curriculumtransition/prepData-scholarshipCurriculumTransitionTest.xml");

        ITable actualTable = databaseDataSet.getTable("opuscollege.sch_scholarship");
        ITable expectedTable = expectedDataSet.getTable("opuscollege.sch_scholarship");
        Assertion.assertEquals(expectedTable, actualTable);
    }

    @Test
    public void testSponsorTransfer() throws Exception {

        sponsorMapper.transferSponsors(44, 48);
        sponsorMapper.transferSponsors(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualSponsorTable = databaseDataSet.getTable("opuscollege.sch_sponsor");

        assertEquals(4, actualSponsorTable.getRowCount()); // 2 existing + 2 new = 4
        assertEquals(48, actualSponsorTable.getValue(2, "academicyearid"));
        assertEquals(48, actualSponsorTable.getValue(3, "academicyearid"));
        assertNotNull(actualSponsorTable.getValue(2, "id"));
        assertNotNull(actualSponsorTable.getValue(3, "id"));
        assertTrue(((Integer) actualSponsorTable.getValue(2, "id")) > 11);
        assertTrue(((Integer) actualSponsorTable.getValue(3, "id")) > 11);
    }

    // @Test
    // public void testSponsorPaymentTransfer() throws Exception {
    //
    // scholarshipDao.transferSponsors(44, 48);
    // scholarshipDao.transferSponsorPayments(44, 48);
    // scholarshipDao.transferSponsorPayments(44, 48);
    //
    // // Fetch database data after executing your code
    // IDataSet databaseDataSet = getConnection().createDataSet();
    //
    // ITable actualSponsorPaymentTable =
    // databaseDataSet.getTable("opuscollege.sch_sponsorpayment");
    //
    // assertEquals(4, actualSponsorPaymentTable.getRowCount()); // 2 existing + 2 new = 4
    // assertTrue(8 != (Integer) actualSponsorPaymentTable.getValue(2, "sponsorId"));
    // assertTrue(11 != (Integer) actualSponsorPaymentTable.getValue(3, "sponsorId"));
    // assertFalse(actualSponsorPaymentTable.getValue(2,
    // "sponsorId").equals(actualSponsorPaymentTable.getValue(3, "sponsorId")));
    // }

    @Test
    public void testScholarshipFeePercentagesTransfer() throws Exception {

        sponsorMapper.transferSponsors(44, 48);
        scholarshipMapper.transferScholarships(44, 48);
        scholarshipFeePercentageMapper.transferScholarshipFeePercentages(44, 48);
        scholarshipFeePercentageMapper.transferScholarshipFeePercentages(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualScholarshipFeePercentageTable = databaseDataSet.getTable("opuscollege.sch_scholarshipFeePercentage");

        assertEquals(4, actualScholarshipFeePercentageTable.getRowCount()); // 2 existing + 2 new =
                                                                            // 4
        assertTrue(8 != (Integer) actualScholarshipFeePercentageTable.getValue(2, "scholarshipId"));
        assertTrue(11 != (Integer) actualScholarshipFeePercentageTable.getValue(3, "scholarshipId"));
        assertFalse(actualScholarshipFeePercentageTable.getValue(2, "scholarshipId").equals(actualScholarshipFeePercentageTable.getValue(3, "scholarshipId")));
    }

    @Test
    public void testAcademicYearScholarshipTransfer() throws Exception {

        scholarshipTransition.transfer(44, 48);
        scholarshipTransition.transfer(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualScholarshipTable = databaseDataSet.getTable("opuscollege.sch_scholarship");
        ITable actualSponsorTable = databaseDataSet.getTable("opuscollege.sch_sponsor");

        assertEquals(4, actualScholarshipTable.getRowCount()); // 2 existing + 2 new = 4
        assertEquals(4, actualSponsorTable.getRowCount()); // 2 existing + 2 new = 4
        assertEquals(48, actualSponsorTable.getValue(2, "academicyearid"));
        assertEquals(48, actualSponsorTable.getValue(3, "academicyearid"));
        assertNotNull(actualScholarshipTable.getValue(2, "id"));
        assertNotNull(actualScholarshipTable.getValue(3, "id"));
        assertTrue(((Integer) actualScholarshipTable.getValue(2, "id")) > 8);
        assertTrue(((Integer) actualScholarshipTable.getValue(3, "id")) > 8);
        assertTrue(8 != (Integer) actualScholarshipTable.getValue(2, "sponsorId"));
        assertTrue(11 != (Integer) actualScholarshipTable.getValue(3, "sponsorId"));
        assertFalse(actualScholarshipTable.getValue(2, "sponsorId").equals(actualScholarshipTable.getValue(3, "sponsorId")));

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/scholarship/service/curriculumtransition/postData-scholarshipCurriculumTransitionTest.xml");

        ITable expectedSponsorTable = expectedDataSet.getTable("opuscollege.sch_sponsor");
        Assertion.assertEqualsIgnoreCols(expectedSponsorTable, actualSponsorTable, new String[] { "id", "academicYearId", "writewhen", "writewho" });

        ITable expectedScholarshipTable = expectedDataSet.getTable("opuscollege.sch_scholarship");
        Assertion.assertEqualsIgnoreCols(expectedScholarshipTable, actualScholarshipTable, new String[] { "id", "sponsorId", "writewhen", "writewho" });

        ITable expectedScholarshipFeePercentageTable = expectedDataSet.getTable("opuscollege.sch_scholarshipfeepercentage");
        ITable actualScholarshipFeePercentageTable = databaseDataSet.getTable("opuscollege.sch_scholarshipfeepercentage");
        Assertion.assertEqualsIgnoreCols(expectedScholarshipFeePercentageTable, actualScholarshipFeePercentageTable,
                new String[] { "id", "scholarshipId", "writewhen", "writewho" });

    }

}
