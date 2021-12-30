package org.uci.opus.accommodationfee.service.curriculumtransition;

/*
 * Note: To run this test in Eclipse:
 * - Run Ant build so that sqlmaps are available and up-to-date in the opus project
 * - add to classpath (see Run configurations...): opus/src/main/webapp/WEB-INF/classes
 */

import java.util.List;

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
import org.uci.opus.college.service.extpoint.AcademicYearTransitionExtPoint;
import org.uci.opus.fee.service.extension.curriculumtransition.AcademicYearFeeTransition;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/accommodation/applicationContext-service.xml",
    "/org/uci/opus/fee/applicationContext-service.xml",
    "/org/uci/opus/accommodationfee/applicationContext-service.xml"
    })
public class AccommodationFeeCurriculumTransitionTest extends DBTestCase {

    private static Logger log = LoggerFactory.getLogger(AccommodationFeeCurriculumTransitionTest.class);

    @Autowired private DataSource dataSource;
    private List<AcademicYearTransitionExtPoint> academicYearFeeTransitions;

    @Autowired
    public void setAcademicYearFeeTransitions(
            List<AcademicYearTransitionExtPoint> academicYearFeeTransitions) {
        this.academicYearFeeTransitions = academicYearFeeTransitions;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {

        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/accommodationfee/service/curriculumtransition/prepData-accommodationFeeCurriculumTransitionTest.xml");
        return dataSet;
    }

    /**
     * Set custom properties/features.
     */
    @Override
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        config.setProperty(DatabaseConfig.FEATURE_QUALIFIED_TABLE_NAMES, true);
        config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new org.dbunit.ext.postgresql.PostgresqlDataTypeFactory());
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        return new DataSourceDatabaseTester(dataSource);
    }
    
    @Before
    public void setUp() throws Exception {
        log.info("Setting up...");

        // empty tables to avoid foreign key problems (NB: tables apparently deleted in reverse order)
        IDataSet dataSet = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.fee_payment"),
                new DefaultTable("opuscollege.fee_feedeadline"),
                new DefaultTable("opuscollege.acc_studentaccommodation"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.endgrade"),
                new DefaultTable("opuscollege.sch_sponsor"),
                new DefaultTable("opuscollege.sch_scholarship"),
                new DefaultTable("opuscollege.sch_scholarshipfeepercentage")
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

        // make sure that the extensions are in the desired order
        assertTrue(AcademicYearFeeTransition.class.isAssignableFrom(academicYearFeeTransitions.get(0).getClass()));
//        assertTrue(AccommodationFeeTransition.class.isAssignableFrom(academicYearFeeTransitions.get(1).getClass()));
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/accommodationfee/service/curriculumtransition/prepData-accommodationFeeCurriculumTransitionTest.xml");

        ITable actualTable = databaseDataSet.getTable("opuscollege.fee_fee");
        ITable expectedTable = expectedDataSet.getTable("opuscollege.fee_fee");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.acc_accommodationfee");
        expectedTable = expectedDataSet.getTable("opuscollege.acc_accommodationfee");
        Assertion.assertEquals(expectedTable, actualTable);

    }

    @Test
    public void testDummyNothingToTransfer() throws Exception {
        
        // Transfer to same year -> test if problems with currval of sequence
        // TODO will only work after upgrading to mybatis; 
        //      now an error is created that the currval of fee_feeseq hasn't been set yet.
        for (AcademicYearTransitionExtPoint feeTransition : academicYearFeeTransitions) {
            feeTransition.transfer(44, 44);
        }
        
    }
    
    @Test
    public void testAccommodationFeeTransfer() throws Exception {

        for (AcademicYearTransitionExtPoint feeTransition : academicYearFeeTransitions) {
            feeTransition.transfer(44, 48);
        }

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        ITable actualAccommodationFeeTable = databaseDataSet.getTable("opuscollege.acc_accommodationfee");
        
        assertEquals(4, actualAccommodationFeeTable.getRowCount()); // 2 existing + 2 new
        assertEquals(actualFeeTable.getValue(2, "id"), actualAccommodationFeeTable.getValue(2, "feeId"));

    }

    @Test
    public void testTransferAllFees() throws Exception {

        for (AcademicYearTransitionExtPoint feeTransition : academicYearFeeTransitions) {
            feeTransition.transfer(44, 48);
        }
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/accommodationfee/service/curriculumtransition/postData-accommodationFeeCurriculumTransitionTest.xml");

        ITable actualFeeTable = databaseDataSet.getTable("opuscollege.fee_fee");
        ITable expectedFeeTable = expectedDataSet.getTable("opuscollege.fee_fee");
        Assertion.assertEqualsIgnoreCols(expectedFeeTable, 
                actualFeeTable,
                new String[] {"id", "studygradetypeid", "subjectStudyGradeTypeId", "subjectBlockStudyGradeTypeId", "writewhen", "writewho"});

        actualFeeTable = databaseDataSet.getTable("opuscollege.acc_accommodationfee");
        expectedFeeTable = expectedDataSet.getTable("opuscollege.acc_accommodationfee");
        Assertion.assertEqualsIgnoreCols(expectedFeeTable, 
                actualFeeTable,
                new String[] {"accommodationFeeId", "feeId", "writewhen", "writewho"});

    }

}
