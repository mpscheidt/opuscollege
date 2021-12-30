package org.uci.opus.college.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.FailedSubjectInfo;

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
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ResultManagerTest extends OpusDBTestCase {

	@Autowired
    private ResultManagerInterface resultManager;
    
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
                new DefaultTable("opuscollege.examination"),
                new DefaultTable("opuscollege.student")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/ResultManagerTest-prepData.xml");
    }

    /**
     * {@link StudentManagerInterface#findAllFailedCompulsorySubjectsForStudyPlan(int)} must not consider exempted subjects as failed.
     */
    @Test
    public void testFindAllFailedCompulsorySubjectsForStudyPlan() {
        List<FailedSubjectInfo> ssgts = studentManager.findAllFailedCompulsorySubjectsForStudyPlan(255);
        assertEquals(0, ssgts.size());
    }

    /**
     * In the study plan's 6th and last semester there is one studyPlanDetail/subject and a respective subject result.
     */
    @Test
    public void testFindCalculatableSubjectResultsForCardinalTimeUnit() {
        List<StudyPlanDetail> studyPlanDetails = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(489);
        
        Map<String, Object> map = new HashMap<>();
        map.put("studyId", 255);
        map.put("gradeTypeCode", "B");
        map.put("cardinalTimeUnitNumber", 6);
        
        List<SubjectResult> subjectResults = resultManager.findCalculatableSubjectResultsForCardinalTimeUnit(studyPlanDetails, map);
        
        assertEquals(1, subjectResults.size());
        assertEquals(518, subjectResults.get(0).getId());
    }

}
