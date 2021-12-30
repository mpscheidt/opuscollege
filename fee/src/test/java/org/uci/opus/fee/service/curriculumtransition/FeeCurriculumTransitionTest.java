package org.uci.opus.fee.service.curriculumtransition;

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
import org.uci.opus.fee.service.extension.curriculumtransition.AcademicYearFeeTransition;
import org.uci.opus.fee.service.extension.curriculumtransition.StudyGradeTypeFeeTransition;
import org.uci.opus.fee.service.extension.curriculumtransition.SubjectBlockFeeTransition;
import org.uci.opus.fee.service.extension.curriculumtransition.SubjectFeeTransition;

/*
 * Note: To run this test in Eclipse:
 * - Run Ant build so that sqlmaps are available and up-to-date in the opus project
 * - add to classpath (see Run configurations...): opus/src/main/webapp/WEB-INF/classes
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/fee/applicationContext-service.xml",
    })
public class FeeCurriculumTransitionTest extends DBTestCase {

    private static Logger log = LoggerFactory.getLogger(FeeCurriculumTransitionTest.class);

    @Autowired private DataSource dataSource;
    @Autowired private StudyGradeTypeFeeTransition studyGradeTypeFeeTransition;
    @Autowired private AcademicYearFeeTransition academicYearFeeTransition;
    @Autowired private SubjectFeeTransition subjectFeeTransition;
    @Autowired private SubjectBlockFeeTransition subjectBlockFeeTransition;

    @Override
    protected IDataSet getDataSet() throws Exception {

        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/fee/service/curriculumtransition/prepData-feeCurriculumTransitionTest.xml");
        return dataSet;
    }

    /**
     * Override method to set custom properties/features
     */
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        config.setProperty(DatabaseConfig.FEATURE_QUALIFIED_TABLE_NAMES, true);
        config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new org.dbunit.ext.postgresql.PostgresqlDataTypeFactory());
//        TestDatabaseConfig.setUpDatabaseConfig(config);
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        return new DataSourceDatabaseTester(dataSource);
    }
    

    @Before
    public void setUp() throws Exception {
        log.info("Setting up...");

        // empty tables to avoid foreign key problems
        IDataSet dataSet = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.fee_payment"),
                new DefaultTable("opuscollege.acc_accommodationfee"),
                new DefaultTable("opuscollege.endgrade"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.acc_studentaccommodation"),
                new DefaultTable("opuscollege.sch_sponsor"),
                new DefaultTable("opuscollege.sch_scholarship"),
                new DefaultTable("opuscollege.sch_scholarshipFeePercentage")
        });
        DatabaseOperation.DELETE_ALL.execute(getConnection(), dataSet);

        // The super.setUp() call is important to initialize the database content
        // Strangely, SpringJUnit4ClassRunner doesn't call setUp() without @Before tag
        super.setUp();

    }
    
    @After
    public void onTearDownInTransaction()
    throws Exception {
        log.info("tear down");

        super.tearDown();
    }


    @Test
    public void testIntegrityOfPrepData() throws Exception {
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/fee/service/curriculumtransition/prepData-feeCurriculumTransitionTest.xml");

        ITable actualTable = databaseDataSet.getTable("opuscollege.fee_fee");
        ITable expectedTable = expectedDataSet.getTable("opuscollege.fee_fee");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.fee_feedeadline");
        expectedTable = expectedDataSet.getTable("opuscollege.fee_feedeadline");
        Assertion.assertEquals(expectedTable, actualTable);

    }
    
    @Test
    public void testTransferFeesForStudyGradeType() throws Exception {
        
        studyGradeTypeFeeTransition.transfer(970, 1234);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        
        assertEquals(16, actualFeeTable.getRowCount()); // 14 existing + 2 new
        assertEquals(1234, actualFeeTable.getValue(14, "studygradetypeid"));
        assertEquals(1234, actualFeeTable.getValue(15, "studygradetypeid"));
        assertNotNull(actualFeeTable.getValue(14, "id")); // new records at indices 8 and 9
        assertNotNull(actualFeeTable.getValue(15, "id"));
        assertTrue(((Integer)actualFeeTable.getValue(14, "id")) > 14);
        assertTrue(((Integer)actualFeeTable.getValue(15, "id")) > 14);

    }
    
    @Test
    public void testAcademicYearFeeTransfer() throws Exception {

        academicYearFeeTransition.transfer(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        
        assertEquals(16, actualFeeTable.getRowCount()); // 14 existing + 2 new
        assertEquals(48, actualFeeTable.getValue(14, "academicyearid"));
        assertEquals(48, actualFeeTable.getValue(15, "academicyearid"));
        assertNotNull(actualFeeTable.getValue(14, "id")); // new records at indices 8 and 9
        assertNotNull(actualFeeTable.getValue(15, "id"));
        assertTrue(((Integer)actualFeeTable.getValue(14, "id")) > 14);
        assertTrue(((Integer)actualFeeTable.getValue(15, "id")) > 14);

    }

    @Test
    public void testSubjectFeeTransfer() throws Exception {

        subjectFeeTransition.transfer(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        
        assertEquals(15, actualFeeTable.getRowCount()); // 14 existing + 1 new
        assertNotNull(actualFeeTable.getValue(14, "id")); // new records at indices 8 and 9
        assertTrue(((Integer)actualFeeTable.getValue(14, "id")) > 14);

    }

    @Test
    public void testSubjectBlockFeeTransfer() throws Exception {

        subjectBlockFeeTransition.transfer(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        
        assertEquals(15, actualFeeTable.getRowCount()); // 14 existing + 1 new
        assertNotNull(actualFeeTable.getValue(14, "id")); // new records at indices 8 and 9
        assertTrue(((Integer)actualFeeTable.getValue(14, "id")) > 14);

    }

    @Test
    public void testTransferAllFees() throws Exception {

        academicYearFeeTransition.transfer(44, 48);
        studyGradeTypeFeeTransition.transfer(970, 1234);
        subjectFeeTransition.transfer(44, 48);
        subjectBlockFeeTransition.transfer(44, 48);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/fee/service/curriculumtransition/postData-feeCurriculumTransitionTest.xml");

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        ITable expectedFeeTable = expectedDataSet.getTable("opuscollege.fee_fee");
        Assertion.assertEqualsIgnoreCols(expectedFeeTable, 
                actualFeeTable,
                new String[] {"id", "studygradetypeid", "subjectStudyGradeTypeId", "subjectBlockStudyGradeTypeId", "writewhen", "writewho"});

        actualFeeTable = databaseDataSet.getTable("opuscollege.fee_feeDeadline");
        expectedFeeTable = expectedDataSet.getTable("opuscollege.fee_feeDeadline");
        Assertion.assertEqualsIgnoreCols(expectedFeeTable, 
                actualFeeTable,
                new String[] {"id", "feeId", "writewhen", "writewho"});

    }

}
