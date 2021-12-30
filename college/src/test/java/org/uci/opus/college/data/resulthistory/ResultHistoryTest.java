/*
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
 * The Original Code is Opus-College college module code.
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
*/

package org.uci.opus.college.data.resulthistory;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.dbunit.Assertion;
import org.dbunit.DataSourceDatabaseTester;
import org.dbunit.IDatabaseTester;
import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.util.DateUtil;

import util.TestDatabaseConfig;

/**
 * 
 * @author markus
 * 
 */

// check out:
// - http://springtestdbunit.github.io/spring-test-dbunit/
// - http://www.disasterarea.co.uk/blog/dbunit/
// - @DatabaseSetup : http://stackoverflow.com/questions/22770521/rollback-error-in-using-spring-dbunit-spring-data-and-embedded-h2-database


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml"
    })
public class ResultHistoryTest extends OpusDBTestCase {

    private static Logger log = LoggerFactory.getLogger(ResultHistoryTest.class);

    private HttpServletRequest request;

    @Autowired private DataSource dataSource;
    @Autowired private ResultManagerInterface resultManager;

    @Override
    protected IDataSet getDataSet() throws Exception {
        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/college/data/resulthistory/prepData.xml");
        return dataSet;
    }

    /**
     * Override method to set custom properties/features.
     */
    protected void setUpDatabaseConfig(DatabaseConfig config) {
        TestDatabaseConfig.setUpDatabaseConfig(config);
    }

    @Override
    protected IDatabaseTester newDatabaseTester() throws Exception {
        log.info("in newDatabaseTester");
        return new DataSourceDatabaseTester(dataSource);
    }
    
    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.appconfig"),
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.organizationalunit"),
                new DefaultTable("opuscollege.study"),
                new DefaultTable("opuscollege.admissionregistrationconfig"),
                new DefaultTable("opuscollege.branchacademicyeartimeunit"),
                new DefaultTable("opuscollege.studyplan"),
                new DefaultTable("opuscollege.studyplancardinaltimeunit"),
                new DefaultTable("opuscollege.studyplandetail")
        });
        return dataSetToTruncate;
    }

    @Before
    public void setUp() throws Exception {
        
        // The super.setUp() call is important to initialize the database content
        // Strangely, SpringJUnit4ClassRunner doesn't call setUp() without @Before tag
        super.setUp();

        request = mockHttpServletRequest();
        
    }

    @Test
    public void testIntegrityOfPrepData() throws Exception {
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader.load("/org/uci/opus/college/data/resulthistory/prepData.xml");

        ITable actualTable = databaseDataSet.getTable("opuscollege.subject");
        ITable expectedTable = expectedDataSet.getTable("opuscollege.subject");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.studyplandetail");
        expectedTable = expectedDataSet.getTable("opuscollege.studyplandetail");
        Assertion.assertEqualsIgnoreCols(expectedTable, actualTable, new String[] { "writewhen", "writewho" });

        actualTable = databaseDataSet.getTable("opuscollege.examination");
        expectedTable = expectedDataSet.getTable("opuscollege.examination");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.test");
        expectedTable = expectedDataSet.getTable("opuscollege.test");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.studyplancardinaltimeunit");
        expectedTable = expectedDataSet.getTable("opuscollege.studyplancardinaltimeunit");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.thesis");
        expectedTable = expectedDataSet.getTable("opuscollege.thesis");
        Assertion.assertEquals(expectedTable, actualTable);

        actualTable = databaseDataSet.getTable("opuscollege.studyplan");
        expectedTable = expectedDataSet.getTable("opuscollege.studyplan");
        Assertion.assertEquals(expectedTable, actualTable);

    }

    @Test
    public void testExaminationResult() throws Exception {

        ExaminationResult examinationResult = new ExaminationResult();
        examinationResult.setExaminationId(20);
        examinationResult.setSubjectId(989);
        examinationResult.setStudyPlanDetailId(8541);
        examinationResult.setExaminationResultDate(DateUtil.parseIsoDate("2010-05-24"));
        examinationResult.setAttemptNr(1);
        examinationResult.setStaffMemberId(19);
        examinationResult.setActive("Y");
        examinationResult.setPassed("Y");
        examinationResult.setMark("12.99");
        request.setAttribute("writeWho", "insuser");
        resultManager.addExaminationResult(examinationResult, request);

        examinationResult.setMark("15.03");
        request.setAttribute("writeWho", "upduser");
        resultManager.updateExaminationResult(examinationResult, request);

        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateExaminationResult.xml");

        ITable actualExaminationResultTable = databaseDataSet.getTable("opuscollege.examinationResult");
        ITable expectedExaminationResultTable = expectedDataSet.getTable("opuscollege.examinationResult");
        Assertion.assertEqualsIgnoreCols(expectedExaminationResultTable, 
                actualExaminationResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        ITable actualExaminationResultHistoryTable = databaseDataSet.getTable("audit.examinationResult_hist");
        ITable expectedExaminationResultHistoryTable = expectedDataSet.getTable("audit.examinationResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedExaminationResultHistoryTable, 
                actualExaminationResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteExaminationResult(examinationResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteExaminationResult.xml");

        actualExaminationResultTable = databaseDataSet.getTable("opuscollege.examinationResult");
        expectedExaminationResultTable = expectedDataSet.getTable("opuscollege.examinationResult");
        Assertion.assertEqualsIgnoreCols(expectedExaminationResultTable, 
                actualExaminationResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualExaminationResultHistoryTable = databaseDataSet.getTable("audit.examinationResult_hist");
        expectedExaminationResultHistoryTable = expectedDataSet.getTable("audit.examinationResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedExaminationResultHistoryTable, 
                actualExaminationResultHistoryTable,
                new String[] {"id", "writewhen"});
        
    }

    @Test
    public void testSubjectResult() throws Exception {

        SubjectResult subjectResult = new SubjectResult();
        subjectResult.setSubjectId(989);
        subjectResult.setStudyPlanDetailId(8541);
        subjectResult.setSubjectResultDate(DateUtil.parseIsoDate("2010-05-24"));
        subjectResult.setStaffMemberId(19);
        subjectResult.setActive("Y");
        subjectResult.setPassed("Y");
        subjectResult.setEndGradeComment("abc");
        subjectResult.setMark("12.99");
        subjectResult.setMarkDecimal(new BigDecimal(subjectResult.getMark()));
        request.setAttribute("writeWho", "insuser");
        resultManager.addSubjectResult(subjectResult, request);

        Map<String, Object> map = new HashMap<>();
        map.put("subjectId", subjectResult.getSubjectId());
        map.put("studyPlanDetailId", subjectResult.getStudyPlanDetailId());
        map.put("subjectResultDate", subjectResult.getSubjectResultDate());
        map.put("mark", subjectResult.getMark());
        map.put("staffMemberId", subjectResult.getStaffMemberId());
        subjectResult = resultManager.findSubjectResultByParams(map);
        subjectResult.setMark("15.03");
        subjectResult.setMarkDecimal(new BigDecimal(subjectResult.getMark()));
        request.setAttribute("writeWho", "upduser");
        resultManager.updateSubjectResult(subjectResult, request);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateSubjectResult.xml");

        ITable actualSubjectResultTable = databaseDataSet.getTable("opuscollege.subjectResult");
        ITable expectedSubjectResultTable = expectedDataSet.getTable("opuscollege.subjectResult");
        Assertion.assertEqualsIgnoreCols(expectedSubjectResultTable, 
                actualSubjectResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        ITable actualSubjectResultHistoryTable = databaseDataSet.getTable("audit.subjectResult_hist");
        ITable expectedSubjectResultHistoryTable = expectedDataSet.getTable("audit.subjectResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedSubjectResultHistoryTable, 
                actualSubjectResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteSubjectResult(subjectResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteSubjectResult.xml");

        actualSubjectResultTable = databaseDataSet.getTable("opuscollege.subjectResult");
        expectedSubjectResultTable = expectedDataSet.getTable("opuscollege.subjectResult");
        Assertion.assertEqualsIgnoreCols(expectedSubjectResultTable, 
                actualSubjectResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualSubjectResultHistoryTable = databaseDataSet.getTable("audit.subjectResult_hist");
        expectedSubjectResultHistoryTable = expectedDataSet.getTable("audit.subjectResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedSubjectResultHistoryTable, 
                actualSubjectResultHistoryTable,
                new String[] {"id", "writewhen"});
        
    }

    @Test
    public void testTestResult() throws Exception {

        TestResult testResult = new TestResult();
        testResult.setTestId(7);
        testResult.setExaminationId(20);
        testResult.setStudyPlanDetailId(8541);
        testResult.setTestResultDate(DateUtil.parseIsoDate("2010-05-24"));
        testResult.setAttemptNr(1);
        testResult.setPassed("Y");
        testResult.setStaffMemberId(19);
        testResult.setActive("Y");
        testResult.setMark("12.99");
        request.setAttribute("writeWho", "insuser");
        resultManager.addTestResult(testResult, request);

        testResult.setMark("15.03");
        request.setAttribute("writeWho", "upduser");
        resultManager.updateTestResult(testResult, request);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateTestResult.xml");

        ITable actualTestResultTable = databaseDataSet.getTable("opuscollege.testResult");
        ITable expectedTestResultTable = expectedDataSet.getTable("opuscollege.testResult");
        Assertion.assertEqualsIgnoreCols(expectedTestResultTable, 
                actualTestResultTable,
                new String[] {"id", "writewhen", "writewho", "brspassingtest"});
        
        ITable actualTestResultHistoryTable = databaseDataSet.getTable("audit.testResult_hist");
        ITable expectedTestResultHistoryTable = expectedDataSet.getTable("audit.testResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedTestResultHistoryTable, 
                actualTestResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteTestResult(testResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteTestResult.xml");

        actualTestResultTable = databaseDataSet.getTable("opuscollege.testResult");
        expectedTestResultTable = expectedDataSet.getTable("opuscollege.testResult");
        Assertion.assertEqualsIgnoreCols(expectedTestResultTable, 
                actualTestResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualTestResultHistoryTable = databaseDataSet.getTable("audit.testResult_hist");
        expectedTestResultHistoryTable = expectedDataSet.getTable("audit.testResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedTestResultHistoryTable, 
                actualTestResultHistoryTable,
                new String[] {"id", "writewhen", "brspassingtest"});
        
    }

    @Test
    public void testCTUResult() throws Exception {

        CardinalTimeUnitResult ctuResult = new CardinalTimeUnitResult();
        ctuResult.setMark("12.99");
        ctuResult.setEndGradeComment("");
        ctuResult.setStudyPlanId(9543);
        ctuResult.setStudyPlanCardinalTimeUnitId(3600);
        ctuResult.setCardinalTimeUnitResultDate(DateUtil.parseIsoDate("2011-04-12"));
        ctuResult.setActive("Y");
        ctuResult.setPassed("Y");
        resultManager.addCardinalTimeUnitResult(ctuResult, "insuser");

        ctuResult.setMark("");
        ctuResult.setEndGradeComment("Definite Fail");
        ctuResult.setPassed("N");
        ctuResult.setCardinalTimeUnitResultDate(DateUtil.parseIsoDate("2011-05-14"));
        resultManager.updateCardinalTimeUnitResult(ctuResult, "upduser");
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateCTUResult.xml");

        ITable actualCTUResultTable = databaseDataSet.getTable("opuscollege.cardinalTimeUnitResult");
        ITable expectedCTUResultTable = expectedDataSet.getTable("opuscollege.cardinalTimeUnitResult");
        Assertion.assertEqualsIgnoreCols(expectedCTUResultTable, 
                actualCTUResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        ITable actualCTUResultHistoryTable = databaseDataSet.getTable("audit.cardinaltimeunitresult_hist");
        ITable expectedCTUResultHistoryTable = expectedDataSet.getTable("audit.cardinaltimeunitresult_hist");
        Assertion.assertEqualsIgnoreCols(expectedCTUResultHistoryTable, 
                actualCTUResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteCardinalTimeUnitResult(ctuResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteCTUResult.xml");

        actualCTUResultTable = databaseDataSet.getTable("opuscollege.cardinalTimeUnitResult");
        expectedCTUResultTable = expectedDataSet.getTable("opuscollege.cardinalTimeUnitResult");
        Assertion.assertEqualsIgnoreCols(expectedCTUResultTable, 
                actualCTUResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualCTUResultHistoryTable = databaseDataSet.getTable("audit.cardinalTimeUnitResult_hist");
        expectedCTUResultHistoryTable = expectedDataSet.getTable("audit.cardinalTimeUnitResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedCTUResultHistoryTable, 
                actualCTUResultHistoryTable,
                new String[] {"id", "writewhen"});
        
    }

    @Test
    public void testThesisResult() throws Exception {

        ThesisResult thesisResult = new ThesisResult();
        thesisResult.setStudyPlanId(9543);
        thesisResult.setThesisId(1);
        thesisResult.setThesisResultDate(DateUtil.parseIsoDate("2011-12-19"));
        thesisResult.setMark("14.25");
        thesisResult.setActive("Y");
        thesisResult.setPassed("Y");
        thesisResult.setWriteWho("insuser");
        resultManager.addThesisResult(thesisResult);

        thesisResult.setMark("");
        thesisResult.setEndGradeComment("Definite Fail");
        thesisResult.setPassed("N");
        thesisResult.setThesisResultDate(DateUtil.parseIsoDate("2011-12-20"));
        thesisResult.setWriteWho("upduser");
        resultManager.updateThesisResult(thesisResult);
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateThesisResult.xml");

        ITable actualThesisResultTable = databaseDataSet.getTable("opuscollege.thesisResult");
        ITable expectedThesisResultTable = expectedDataSet.getTable("opuscollege.thesisResult");
        Assertion.assertEqualsIgnoreCols(expectedThesisResultTable,
                actualThesisResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        ITable actualThesisResultHistoryTable = databaseDataSet.getTable("audit.thesisResult_hist");
        ITable expectedThesisResultHistoryTable = expectedDataSet.getTable("audit.thesisResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedThesisResultHistoryTable,
                actualThesisResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteThesisResult(thesisResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteThesisResult.xml");

        actualThesisResultTable = databaseDataSet.getTable("opuscollege.thesisResult");
        expectedThesisResultTable = expectedDataSet.getTable("opuscollege.thesisResult");
        Assertion.assertEqualsIgnoreCols(expectedThesisResultTable, 
                actualThesisResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualThesisResultHistoryTable = databaseDataSet.getTable("audit.thesisResult_hist");
        expectedThesisResultHistoryTable = expectedDataSet.getTable("audit.thesisResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedThesisResultHistoryTable, 
                actualThesisResultHistoryTable,
                new String[] {"id", "writewhen"});
        
    }

    @Test
    public void testStudyPlanResult() throws Exception {

        StudyPlanResult studyplanResult = new StudyPlanResult();
        studyplanResult.setStudyPlanId(9543);
        studyplanResult.setExamDate(DateUtil.parseIsoDate("2011-12-19"));
        studyplanResult.setFinalMark("Y");
        studyplanResult.setMark("11.22");
        studyplanResult.setMarkDecimal(new BigDecimal(studyplanResult.getMark()));
        studyplanResult.setActive("Y");
        studyplanResult.setPassed("Y");
        resultManager.addStudyPlanResult(studyplanResult, "insuser");

        studyplanResult.setMark("");
        studyplanResult.setMarkDecimal(null);
        studyplanResult.setPassed("N");
        studyplanResult.setExamDate(DateUtil.parseIsoDate("2011-12-20"));
        resultManager.updateStudyPlanResult(studyplanResult, "upduser");
        
        // Fetch database data after executing your code
        IDataSet databaseDataSet = getConnection().createDataSet();

        // Load expected data from an XML dataset
        DataFileLoader loader = new FlatXmlDataFileLoader();
        IDataSet expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postInsertUpdateStudyPlanResult.xml");

        ITable actualResultTable = databaseDataSet.getTable("opuscollege.studyPlanResult");
        ITable expectedResultTable = expectedDataSet.getTable("opuscollege.studyPlanResult");
        Assertion.assertEqualsIgnoreCols(expectedResultTable,
                actualResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        ITable actualResultHistoryTable = databaseDataSet.getTable("audit.studyPlanResult_hist");
        ITable expectedResultHistoryTable = expectedDataSet.getTable("audit.studyPlanResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedResultHistoryTable,
                actualResultHistoryTable,
                new String[] {"id", "writewhen"});
        
        resultManager.deleteStudyPlanResult(studyplanResult.getId(), "deluser");

        expectedDataSet = loader
                .load("/org/uci/opus/college/data/resulthistory/postDeleteStudyPlanResult.xml");

        actualResultTable = databaseDataSet.getTable("opuscollege.studyPlanResult");
        expectedResultTable = expectedDataSet.getTable("opuscollege.studyPlanResult");
        Assertion.assertEqualsIgnoreCols(expectedResultTable, 
                actualResultTable,
                new String[] {"id", "writewhen", "writewho"});
        
        actualResultHistoryTable = databaseDataSet.getTable("audit.studyPlanResult_hist");
        expectedResultHistoryTable = expectedDataSet.getTable("audit.studyPlanResult_hist");
        Assertion.assertEqualsIgnoreCols(expectedResultHistoryTable, 
                actualResultHistoryTable,
                new String[] {"id", "writewhen"});
        
    }

}
