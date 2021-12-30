package org.uci.opus.college.service;

import static org.junit.Assert.assertNotEquals;

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
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.persistence.ExaminationResultMapper;
import org.uci.opus.college.persistence.SubjectResultMapper;
import org.uci.opus.college.service.result.SubjectResultGenerator;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-util.xml", "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/college/applicationContext-data.xml" })
@Transactional(propagation = Propagation.REQUIRES_NEW)
public class SubjectResultManagerTest extends OpusDBTestCase {

    private MockHttpServletRequest request = mockHttpServletRequest();

    @Autowired
    private AppConfigManagerInterface appConfigManager;

	@Autowired
    private ResultManagerInterface resultManager;

	@Autowired
	private ExaminationResultMapper examinationResultMapper;
	
    @Autowired
    private SubjectResultMapper subjectResultMapper;

    @Before
    public void setUp() throws Exception {
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(
                new ITable[] { new DefaultTable("opuscollege.academicyear"), new DefaultTable("opuscollege.institution"),
                        new DefaultTable("opuscollege.organizationalunit"), new DefaultTable("opuscollege.test"), new DefaultTable("opuscollege.student") });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/SubjectResultManagerTest-prepData.xml");
    }

    /**
     * failSubject flag is true for NF with examinationResult = 7, therefore we expect passed = N, subjectResultcommentId = 1, no mark.
     * 
     * "failSubject" is true and subject result would be higher than passing rule of 10, shall however not be calculated.
     */
    @Test
    public void testFailSubjectTrueHighSubjectResult() {

        testSubjectResultGeneration(77, 485, null, "N", 1);
    }

    /**
     * "failSubject" is false and subject result is *higher* than passing rule of 10. In this case the subject result is
     * positive.
     */
    @Test
    public void testFailSubjectFalseHighSubjectResult() {

    	// Mark: 0.6 * 9 + 0.4 * 17 => 12.2
        testSubjectResultGeneration(277, 26, "12.2", "Y", null);
    }

    /**
     * "failSubject" is false and subject result is *lower* than passing rule of 10.
     */
    @Test
    public void testFailSubjectFalseLowSubjectResult() {

    	// Mark: 0.6 * 11 + 0.4 * 1 => 7
        testSubjectResultGeneration(288, 27, "7.0", "N", null);
    }

    private void testSubjectResultGeneration(int subjectId, int studyPlanDetailId, String resultExpected, String passedExpected, Integer subjectResultCommentId) {
        SubjectResult subjectResult = new SubjectResult(subjectId, studyPlanDetailId);

        BindingResult bindingResult = new BeanPropertyBindingResult(subjectResult, "subjectResult");
        SubjectResultGenerator subjectResultGenerator = resultManager.generateSubjectResultMark(subjectResult, EN, bindingResult);

        assertFalse(bindingResult.hasErrors());

        // the mark always be calculated unless there is a validation error or failSubject or passSubjectThreshold apply
        assertEquals(resultExpected, subjectResult.getMark());

        // isPassedSubjectResult with passing the subjectResultGenerator
        assertEquals(passedExpected, resultManager.isPassedSubjectResult(subjectResult, subjectResult.getMark(), EN, null, subjectResultGenerator));

        // test now the isPassedSubjectResult without passing the subjectResultGenerator, as is the case when entering a result by hand
        // instead of generating it
        assertEquals(passedExpected, resultManager.isPassedSubjectResult(subjectResult, subjectResult.getMark(), EN, null, null));

        assertEquals(subjectResultCommentId, subjectResult.getSubjectResultCommentId());
    }

    /**
     * Insert both examination results: At the first one, no subject result can be auto-generated, but at the second (and final) one, the
     * subject result auto-generation shall kick in.
     */
    @Test
    public void addUpdateDeleteExaminationResult_AutoGenerateSubjectResultTrue() {
        
        // verify that MyBatis cache (see AppConfigMapper.xml) isn't creating a mess: appconfig value is changed in other methods, cached value could be different from DB value
        // that's why the transaction is set so that a new transaction (= new MyBatis session) is created for every method and cache has no chance to interfere
        assertTrue(appConfigManager.getAutoGenerateSubjectResult());

        ExaminationResult er1 = insertExaminationResult1AndAssert("20", "Y");
        insertExaminationResult2("10", "Y");

        // assert that the subject result is automatically created, because auto generation flag is true: 20 (60%) and 10 (40%) result in subject result "16.0"
        assertSubjectResult("16.0", "Y", null);

        // now update examination result so that subject result gets recalculated
        er1 = resultManager.findExaminationResult(er1.getId());
        er1.setMark("15");
        resultManager.updateExaminationResult(er1, request);

        // 15 (60%) and 10 (40%) result in subject result "13.0"
        assertSubjectResult("13.0", "Y", null);

        // delete an examination result, which triggers removal of subject result
        resultManager.deleteExaminationResult(er1.getId(), WRITEWHO_TEST);
        assertTrue(subjectResultMapper.findSubjectResultsForStudyPlan(255).isEmpty());
    }

    private void assertSubjectResult(String expectedMark, String expectedPassed, Integer expectedSubjectResultCommentId) {
        List<SubjectResult> subjectResults = subjectResultMapper.findSubjectResultsForStudyPlan(255);
        assertEquals(1, subjectResults.size());
        assertEquals(expectedMark, subjectResults.get(0).getMark());
        assertEquals(expectedPassed, subjectResults.get(0).getPassed());
        assertEquals(expectedSubjectResultCommentId, subjectResults.get(0).getSubjectResultCommentId());
    }

    /**
     * Insert both examination results, but no subject result auto generation because app config is false.
     */
    @Test
    public void addDeleteExaminationResult_AutoGenerateSubjectResultFalse() {

        deactivateAutoGenerateSubjectResults();

        ExaminationResult er1 = insertExaminationResult1AndAssert("20", "Y");
        insertExaminationResult2("10", "Y");

        // assert that no subject result is automatically created, because auto generation flag is false
        assertTrue(subjectResultMapper.findSubjectResultsForStudyPlan(255).isEmpty());
        
        // set subject result manually
        SubjectResult subjectResult = new SubjectResult(88, 499, 1, "20", "Y");
        resultManager.addSubjectResult(subjectResult, request);
        assertNotNull(subjectResultMapper.findSubjectResult(subjectResult.getId()));
        
        // with autoGeneration=off deletion of examination result shall not trigger deletion of subject result
        resultManager.deleteExaminationResult(er1.getId(), WRITEWHO_TEST);
        assertNotNull(subjectResultMapper.findSubjectResult(subjectResult.getId()));
    }

    private void deactivateAutoGenerateSubjectResults() {
        // Deactivate the auto-generation of subject results
        appConfigManager.updateAppConfigAttribute(AppConfigManagerInterface.AUTO_GENERATE_SUBJECT_RESULT, "N");
    }
    
    // insert first examination result for examinationId = 88 and subjectResultInDB = 499
    private ExaminationResult insertExaminationResult1AndAssert(String mark, String passed) {

        ExaminationResult er = new ExaminationResult(88, 88, 499, 1, mark, passed);
        resultManager.addExaminationResult(er, request);
        assertNotEquals(0, er.getId());

        // assert that no subject result is yet created, because there is still the second examination result missing
        assertTrue(subjectResultMapper.findSubjectResultsForStudyPlan(255).isEmpty());
        
        return er;
    }

    // insert second examination result for examinationId = 88 and subjectResultInDB = 499
    private ExaminationResult insertExaminationResult2(String mark, String passed) {

        ExaminationResult er = new ExaminationResult(89, 88, 499, 1, mark, passed);
        resultManager.addExaminationResult(er, request);
        assertNotEquals(0, er.getId());

        return er;
    }

    /**
     * The point is to test if updating an examination result will create a new subject result even if no subject result existed before.
     */
    @Test
    public void updateExaminationResultForSubject77StudyPlanDetail485_AutoGenerateSubjectResultTrue() {
        
        ExaminationResult er = examinationResultMapper.findExaminationResult(485);
        er.setMark("10");
        er.setPassed("Y");
        resultManager.updateExaminationResult(er, request);
        
        // 10 (60%) and 17 (40%) result in subject result "13.0"
        assertSubjectResult("12.8", "Y", null);
    }

    /**
     * Insert both examination results, but second one is below threshold and hence a failed subject result with "reprovado" comment shall be generated.
     * Upon deleting the examination result the subject result shall be removed.
     */
    @Test
    public void addUpdateDeleteExaminationResultBelowThreshold_AutoGenerateSubjectResultTrue() {
        
        assertTrue(appConfigManager.getAutoGenerateSubjectResult());

        insertExaminationResult1AndAssert("20", "Y");
        ExaminationResult er2 = insertExaminationResult2("7", "N");

        // assert that the subject result is automatically created, because final exam result is below threshold, null mark and "reprovado" comment are expected.
        assertSubjectResult(null, "N", 2);

        // now update examination result so that subject result gets recalculated
        er2 = resultManager.findExaminationResult(er2.getId());
        er2.setMark("10");
        er2.setPassed("Y");
        resultManager.updateExaminationResult(er2, request);

        // 15 (60%) and 10 (40%) result in subject result "13.0"
        assertSubjectResult("16.0", "Y", null);

        // delete an examination result, which triggers removal of subject result
        resultManager.deleteExaminationResult(er2.getId(), WRITEWHO_TEST);
        assertTrue(subjectResultMapper.findSubjectResultsForStudyPlan(255).isEmpty());
    }

    /**
	 * Insert both examination results, but second one is between threshold and
	 * pass mark hence a the generated subject result is expected to have a mark
	 * value and no comment.
	 * 
	 * Upon deleting the examination result the subject result shall be removed.
	 */
    @Test
    public void addUpdateDeleteExaminationResultBetweenThresholdAndPassMark_AutoGenerateSubjectResultTrue() {
        
        assertTrue(appConfigManager.getAutoGenerateSubjectResult());

        ExaminationResult er1 = insertExaminationResult1AndAssert("20", "Y");
        insertExaminationResult2("9", "N");

        // assert that the subject result is automatically created
        // 0.6 * 20 + 0.4 * 9 => 15.6
        assertSubjectResult("15.6", "Y", null);

        // now update examination result so that subject result gets recalculated
        er1 = resultManager.findExaminationResult(er1.getId());
        er1.setMark("10");
        er1.setPassed("Y");
        resultManager.updateExaminationResult(er1, request);

        // 0.6 * 10 + 0.4 * 9 => 9.6
        assertSubjectResult("9.6", "N", null);

        // delete an examination result, which triggers removal of subject result
        resultManager.deleteExaminationResult(er1.getId(), WRITEWHO_TEST);
        assertTrue(subjectResultMapper.findSubjectResultsForStudyPlan(255).isEmpty());
    }

}
