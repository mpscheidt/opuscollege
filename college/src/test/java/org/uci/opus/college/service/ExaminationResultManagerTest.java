package org.uci.opus.college.service;

import java.util.HashMap;
import java.util.List;

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
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.service.result.ExaminationResultGenerator;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ExaminationResultManagerTest extends OpusDBTestCase {

	@Autowired
	private AppConfigManagerInterface appConfigManager;
	
    @Autowired
    private ResultManagerInterface resultManager;
    
	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.organizationalunit"),
                new DefaultTable("opuscollege.test"),
                new DefaultTable("opuscollege.student"),
                new DefaultTable("opuscollege.appconfig")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/ExaminationResultManagerTest-prepData.xml");
    }

    /**
     * Load the examinationResultComments according their sort order key.
     */
    @Test
    public void testFindExaminationMarkComments() {
        List<ExaminationResultComment> comments = resultManager.findExaminationResultComments(new HashMap<String, Object>());
        assertEquals(4, comments.size());
        assertEquals(10, comments.get(0).getSort());
        assertEquals(4, comments.get(0).getId());
        assertEquals(20, comments.get(1).getSort());
        assertEquals(3, comments.get(1).getId());
        assertEquals(30, comments.get(2).getSort());
        assertEquals(2, comments.get(2).getId());
        assertEquals(40, comments.get(3).getSort());
        assertEquals(1, comments.get(3).getId());
    }

    @Test
    public void testAllPositiveResultsGenerateExaminationResult() {

        ExaminationResult examinationResult = new ExaminationResult();
        BindingResult bindingResult = new BeanPropertyBindingResult(examinationResult, "examinationResult");
        String mark = resultManager.generateExaminationResultMark(110128, 4249, EN, bindingResult);

        assertFalse(bindingResult.hasErrors());
        assertNotNull(mark);
        // No rounding is to be done on the examination result, not to lose precision; the final subject result will be formatted according
        // to sys-option
        assertEquals("16.768", mark);
    }

    @Test
    public void testOneNegativeTestResultAndReject() {
        
        // make sure that value is on its default value of "0" (somehow the value gets modified in
        // testOneNegativeTestResultAndGenerate() and stays at that value even though the prep-data
        // sets it to "0")
        setMaxFailedTestResultsInDb("0");

        ExaminationResult examinationResult = new ExaminationResult();
        BindingResult bindingResult = new BeanPropertyBindingResult(examinationResult, "examinationResult");
        String mark = resultManager.generateExaminationResultMark(110130, 4249, EN, bindingResult);
        
        assertNull(mark);
        assertEquals(ExaminationResultGenerator.ERROR_FAILEDTESTRESULTS, bindingResult.getFieldError("mark").getCode());
    }

    @Test
    public void testOneNegativeTestResultAndGenerate() {

        // Setting the "max failed test results" to -1 makes it possible to calculate the examination result
        setMaxFailedTestResultsInDb("-1");

        ExaminationResult examinationResult = new ExaminationResult();
        BindingResult bindingResult = new BeanPropertyBindingResult(examinationResult, "examinationResult");
        String mark = resultManager.generateExaminationResultMark(110130, 4249, EN, bindingResult);

        assertFalse(bindingResult.hasErrors());
        assertNotNull(mark);
        assertEquals("10.2936", mark);
    }

    private void setMaxFailedTestResultsInDb(String maxFailedTestResultsValueAsString) {
        AppConfigAttribute maxFailedTestResults = appConfigManager.findAppConfigAttribute(AppConfigManagerInterface.MAX_FAILED_TEST_RESULTS);
        maxFailedTestResults.setAppConfigAttributeValue(maxFailedTestResultsValueAsString);
        appConfigManager.updateAppConfigAttribute(maxFailedTestResults);
    }

}
