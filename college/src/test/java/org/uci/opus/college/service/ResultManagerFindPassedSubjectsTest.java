package org.uci.opus.college.service;

import java.util.Arrays;
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
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.util.DomainUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class ResultManagerFindPassedSubjectsTest extends OpusDBTestCase {

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
                new DefaultTable("opuscollege.student"),
                new DefaultTable("opuscollege.studyplan"),
                new DefaultTable("opuscollege.studyplancardinaltimeunit")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/ResultManagerFindPassedSubjectsTest-prepData.xml");
    }

    @Test
    public void testFindPassedSubjects() {
        List<Integer> subjectIds = Arrays.asList(1890, 1885, 1909);
        
        List<Subject> passedSubjects = resultManager.findPassedSubjects(255, subjectIds, null);
        assertEquals(2, passedSubjects.size());
        
        List<Integer> passedSubjectIds = DomainUtil.getIds(passedSubjects);
        // 1909 = BIOL002: passed in 1st semester (subjectId = 1709)
        assertTrue(passedSubjectIds.contains(1909));
        // 1885 = PHYS001: passed in 3rd semester
        assertTrue(passedSubjectIds.contains(1885));
    }

}
