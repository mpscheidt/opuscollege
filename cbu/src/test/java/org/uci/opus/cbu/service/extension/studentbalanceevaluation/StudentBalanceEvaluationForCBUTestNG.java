/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College cbu module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/
package org.uci.opus.cbu.service.extension.studentbalanceevaluation;

import javax.sql.DataSource;

import org.dbunit.DefaultOperationListener;
import org.dbunit.IDatabaseTester;
import org.dbunit.IOperationListener;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.operation.DatabaseOperation;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import org.uci.opus.cbu.service.extension.StudentBalanceEvaluationForCBU;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;

//ContextConfiguration tag will look for <class name>-context.xml file as application context
@ContextConfiguration({"/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/cbu/applicationContext-service.xml",
    "StudentBalanceEvaluationForCBUTestNG-context.xml"
    })
public class StudentBalanceEvaluationForCBUTestNG extends AbstractTestNGSpringContextTests {

    private IOperationListener operationListener;   // set dbunit's DBTestCase: allows to set DB configuration features

    @Autowired
    private DataSource dataSource;
    
    @Autowired
    private DataSource dimensionsDataSource;
    
    @Autowired
    private StudentBalanceEvaluationForCBU studentBalanceEvaluationForCBU;
    
    @Autowired
    private IDatabaseTester databaseTester;

    @Autowired
    private IDatabaseTester dimensionsDatabaseTester;

    private IDataSet getDataSet() {

        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/cbu/service/extension/studentbalanceevaluation/prepData.xml");
        return dataSet;
    }

    private IDataSet getDimensionsDataSet() {

        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/cbu/service/extension/studentbalanceevaluation/prepDataDimensions.xml");
        return dataSet;
    }

    @BeforeMethod
    public void setUp() throws Exception {

        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.endgrade")
        });
        DatabaseOperation.DELETE_ALL.execute(getConnection(databaseTester), dataSetToTruncate);

        databaseTester.setSetUpOperation(DatabaseOperation.CLEAN_INSERT);
        databaseTester.setDataSet(getDataSet());
        databaseTester.setOperationListener(getOperationListener());
        databaseTester.onSetup();
        
        dimensionsDatabaseTester.setSetUpOperation(DatabaseOperation.CLEAN_INSERT);
        dimensionsDatabaseTester.setDataSet(getDimensionsDataSet());
        dimensionsDatabaseTester.setOperationListener(getOperationListener());
        dimensionsDatabaseTester.onSetup();
    }
    
    private IDatabaseConnection getConnection(IDatabaseTester databaseTester) throws Exception {
        IDatabaseConnection connection = databaseTester.getConnection();
        setUpDatabaseConfig(connection.getConfig());
        return connection;
    }

    private  void setUpDatabaseConfig(DatabaseConfig config) {
        config.setProperty(DatabaseConfig.FEATURE_QUALIFIED_TABLE_NAMES, true);
        config.setProperty(DatabaseConfig.FEATURE_CASE_SENSITIVE_TABLE_NAMES, true);
        config.setProperty(DatabaseConfig.PROPERTY_ESCAPE_PATTERN, "\"?\"");  // surround table/column names (the ?) with quotes: "TableName", "ColumnName"
      config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new org.dbunit.ext.postgresql.PostgresqlDataTypeFactory());
    }

    private IOperationListener getOperationListener()
    {
        logger.debug("getOperationListener() - start");
        if(this.operationListener==null){
            this.operationListener = new DefaultOperationListener(){
                public void connectionRetrieved(IDatabaseConnection connection) {
                    super.connectionRetrieved(connection);
                    // When a new connection has been created then invoke the setUp method
                    // so that user defined DatabaseConfig parameters can be set.
                    setUpDatabaseConfig(connection.getConfig());
                }
            };
        }
        return this.operationListener;
    }

    @Test
    public void testHasMadeSufficientPaymentsForAdmission() {
        boolean sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForAdmission(277);
        Assert.assertTrue(sufficient);

        sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForAdmission(278);
        Assert.assertTrue(sufficient);

        sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForAdmission(279);
        Assert.assertFalse(sufficient);

    }

    @Test
    public void testHasMadeSufficientPaymentsForRegistration() {
        StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluationForCBU.getStudentBalanceInformation("10271008");
        boolean sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation);
        Assert.assertTrue(sufficient);

        studentBalanceInformation = studentBalanceEvaluationForCBU.getStudentBalanceInformation("07044083");
        sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation);
        Assert.assertTrue(sufficient);

        studentBalanceInformation = studentBalanceEvaluationForCBU.getStudentBalanceInformation("07078698");
        sufficient = studentBalanceEvaluationForCBU.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation);
        Assert.assertFalse(sufficient);
    }

}
