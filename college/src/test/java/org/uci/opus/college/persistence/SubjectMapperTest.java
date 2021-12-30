package org.uci.opus.college.persistence;

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
import org.uci.opus.college.domain.Subject;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class SubjectMapperTest extends OpusDBTestCase {

    @Autowired
    private SubjectMapper subjectMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/SubjectMapperTest-prepData.xml");
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { 
                new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"), 
                new DefaultTable("opuscollege.organizationalunit"), 
                new DefaultTable("opuscollege.classgroup"),
                new DefaultTable("opuscollege.examination"), 
                new DefaultTable("opuscollege.subjectclassgroup"),
                new DefaultTable("opuscollege.studyplan")
                });
        return dataSetToTruncate;
    }

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testFindSubjectsUsingSubjectCode() {
        
        Map<String, Object> map = new HashMap<>();
        map.put("studyGradeTypeId", 59);
        map.put("subjectCode", "BIOL001");
        map.put("cardinalTimeUnitNumberExact", 1);
        map.put("currentAcademicYearId", 1);
        List<Subject> subjects = subjectMapper.findSubjects(map);
        assertEquals(1, subjects.size());
        Subject subject = subjects.get(0);
        assertEquals("BIOL001", subject.getCode());
        assertEquals(77, subject.getId());
    }
}
