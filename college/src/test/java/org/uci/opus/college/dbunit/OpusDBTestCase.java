package org.uci.opus.college.dbunit;

import java.util.Locale;

import javax.sql.DataSource;

import org.dbunit.DBTestCase;
import org.dbunit.DataSourceDatabaseTester;
import org.dbunit.IDatabaseTester;
import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.IDataSet;
import org.dbunit.operation.OpusDatabaseOperation;
import org.junit.After;
import org.junit.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.uci.opus.config.OpusConstants;

import util.TestDatabaseConfig;

public abstract class OpusDBTestCase extends DBTestCase {

    private static final Logger LOG = LoggerFactory.getLogger(OpusDBTestCase.class);

    protected static final String WRITEWHO_TEST = "test";
    protected static final String EN = OpusConstants.LANGUAGE_EN;
    protected static final String PT = OpusConstants.LANGUAGE_PT;
    
    @Autowired
    private DataSource dataSource;

    public OpusDBTestCase() {
        super();
    }

    public OpusDBTestCase(String name) {
        super(name);
    }

    /**
     * Override method to set custom properties/features.
     */
    @Override
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        TestDatabaseConfig.setUpDatabaseConfig(config);
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        return new DataSourceDatabaseTester(dataSource);
    }

    /**
     * Override this method to define the tables whose contents shall be deleted as they could make problems due to foreign keys
     * when inserting data from prepData.xml in super.setUp().
     * 
     * NB: Tables get apparently deleted in <i>reverse</i> order than given in the data set.
     * 
     * @return
     * @throws AmbiguousTableNameException 
     */
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        return null;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        
        // by default return an empty dataset, which will set no data in the database
        return new DefaultDataSet();
    }

    /**
     * Truncates dataset that could make problems due to foreign keys.
     * 
     * Calls super.setUp() to initialize the database content.
     * 
     * @throws Exception
     */
    @Before
    public void setUpOpusDBTestCase() throws Exception {
        LOG.debug("setUpOpusDBTestCase");

        IDataSet dataSetToTruncate = getDataSetToTruncateInSetup();
        if (dataSetToTruncate != null) {
        	
        	IDatabaseConnection con = getConnection();
			OpusDatabaseOperation.TRUNCATE_CASCADE_TABLE.execute(con, dataSetToTruncate);
			con.close();
        }

        // The super.setUp() call is important to initialize the database content
        // SpringJUnit4ClassRunner doesn't call DBTestCase.setUp(), so it needs to be done manually within a @Before annotated method
        super.setUp();

    }

    @After
    public void onTearDownInTransaction() throws Exception {
        LOG.debug("tear down");

        // will call default tearDownOperation
        super.tearDown();
    }

    /**
     * @return A request with the writeWho property set to "test" and preferred locale to "English".
     */
    protected MockHttpServletRequest mockHttpServletRequest() {

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setAttribute("writeWho", WRITEWHO_TEST);
        request.addPreferredLocale(Locale.ENGLISH);
        return request;
    }
}