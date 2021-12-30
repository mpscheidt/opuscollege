package org.uci.opus.moz.service.extension;

import java.math.BigDecimal;
import java.util.Locale;

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
import org.springframework.validation.Errors;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.service.ExaminationResultManagerTest;

/**
 * See also {@link ExaminationResultManagerTest}.
 * 
 * @author Markus Pscheidt
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml",
    "/org/uci/opus/moz/applicationContext-service.xml"
    })
public class ResultsCalculationsForMozambiqueTest extends OpusDBTestCase {

	@Autowired
	private ResultsCalculationsForMozambique resultsCalculationsForMozambique;

	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.organizationalunit"),
                new DefaultTable("opuscollege.examination"),
                new DefaultTable("opuscollege.test"),
                new DefaultTable("opuscollege.student")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/moz/service/extension/ResultsCalculationsForMozambiqueTest-prepData.xml");
    }

    @Test
    public void test() {
        
        StudyPlanResult studyPlanResult = new StudyPlanResult();
        studyPlanResult.setStudyPlanId(13232);
        Errors errors = new BeanPropertyBindingResult(studyPlanResult, "studyPlanResult");
        BigDecimal brsPassingSubjectDouble = new BigDecimal("9.5");
        
        resultsCalculationsForMozambique.calculateResultsForStudyPlan(null, studyPlanResult, brsPassingSubjectDouble , EN, new Locale(EN), errors);
        
        assertNotNull(studyPlanResult.getMark());
        assertEquals(new BigDecimal("11.73"), studyPlanResult.getMarkDecimal());
        assertEquals("12", studyPlanResult.getMark());
        
    }
    
}
