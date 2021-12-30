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
import org.uci.opus.college.domain.Student;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "/standardTestBeans.xml",
    "/org/uci/opus/college/applicationContext-util.xml",
    "/org/uci/opus/college/applicationContext-service.xml",
    "/org/uci/opus/college/applicationContext-data.xml"
    })
public class StudentManagerTest extends OpusDBTestCase {

	@Autowired
	private StudentManagerInterface studentManager;
	
	@Before
	public void setUp() throws Exception {
	}

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.examination"),
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
        return loader.load("/org/uci/opus/college/service/StudentManagerTest-prepData.xml");
    }

    @Test
    public void testFindStudent() {
        Student student = studentManager.findStudent(EN, 1);
        assertNotNull(student);
        assertEquals("hh", student.getStudentCode());
    }

    @Test
    public void testFindStudents() {
        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_DEFAULT);
        map.put("studyId", 1213);
        List<Student> students = studentManager.findStudents(map);
        assertNotNull(students);
        assertEquals(1, students.size());
    }
    
}
