package org.uci.opus.zambia.service.extension;

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
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/zambia/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ProgressCalculationForZambiaTest extends OpusDBTestCase {

	@Autowired
	private ProgressCalculationForZambia progressCalculation;

    @Autowired
    private StudentManagerInterface studentManager;
    
	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.organizationalunit"),
                new DefaultTable("opuscollege.student")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/zambia/service/extension/ProgressCalculationForZambiaTest-prepData.xml");
    }

    /**
     * Calculate "GRADUATE" progress status for the study plan's last time unit,
     * even though 2 subjects were exempted in the second semester and therefore do not have subject results.
     */
    @Test
    public void testCalculateProgressStatusForStudyPlanCardinalTimeUnit() {
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(489);
        progressCalculation.calculateProgressStatusForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit, EN, Locale.ENGLISH);
        assertEquals(OpusConstants.PROGRESS_STATUS_GRADUATE, studyPlanCardinalTimeUnit.getProgressStatusCode());
    }

}
