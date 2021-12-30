package org.uci.opus.college.persistence;

import java.util.Date;
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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.StudentExpulsion;
import org.uci.opus.util.DateUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class StudentExpulsionMapperTest extends OpusDBTestCase {

    private static final String CERTIFICADO_FALSO = "Certificado falso";
    private static final String FRAUDE_ACADEMICA = "Fraude academica";
    private static final String SOMETHING_FISHY = "Something fishy";

    @Autowired
    private StudentExpulsionMapper studentExpulsionMapper;
    
    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/StudentExpulsionMapperTest-prepData.xml");
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
    public void findOne() {

        StudentExpulsion studentExpulsion = studentExpulsionMapper.findStudentExpulsion(1, PT);
        assertEquals(1982, studentExpulsion.getStudentId());
        assertEquals(FRAUDE_ACADEMICA, studentExpulsion.getExpulsionType().getDescription());
        assertEquals(SOMETHING_FISHY, studentExpulsion.getReasonForExpulsion());
        assertEquals(DateUtil.parseIsoDateNoExc("2016-02-20"), studentExpulsion.getStartDate());
        assertEquals(DateUtil.parseIsoDateNoExc("2016-02-29"), studentExpulsion.getEndDate());
    }

    @Test
    public void findMany() {
        
        List<StudentExpulsion> studentExpulsions = studentExpulsionMapper.findStudentExpulsions(1982, EN);
        assertEquals(2, studentExpulsions.size());
        assertEquals(1, studentExpulsions.get(0).getId());
        assertEquals(2, studentExpulsions.get(1).getId());
    }

    @Test
    public void add() {
        
        // the expellationType that corresponds with the record in the database
        Lookup expellationType = new Lookup(PT, "1", CERTIFICADO_FALSO);
        expellationType.setId(1);

        StudentExpulsion studentExpulsion = new StudentExpulsion(1993, DateUtil.parseIsoDateNoExc("2016-01-08"), expellationType, "exp reason");
        studentExpulsionMapper.addStudentExpulsion(studentExpulsion);
        assertEquals(2, studentExpulsionMapper.findStudentExpulsions(1993, EN).size());
    }

    @Test
    public void update() {
        
        StudentExpulsion studentExpulsion = studentExpulsionMapper.findStudentExpulsion(2, PT);
        Date enddate = DateUtil.parseIsoDateNoExc("2016-02-14");
        studentExpulsion.setEndDate(enddate);
        studentExpulsionMapper.updateStudentExpulsion(studentExpulsion);
        
        studentExpulsion = studentExpulsionMapper.findStudentExpulsion(2, EN);
        assertEquals(enddate, studentExpulsion.getEndDate());
    }
    
    @Test
    public void delete() {
        
        studentExpulsionMapper.deleteStudentExpulsion(2);

        List<StudentExpulsion> studentExpulsions = studentExpulsionMapper.findStudentExpulsions(1982, EN);
        assertEquals(1, studentExpulsions.size());
        assertEquals(1, studentExpulsions.get(0).getId());
    }

    @Test
    public void deleteMany() {

        studentExpulsionMapper.deleteStudentExpulsions(1982);
        assertEquals(0, studentExpulsionMapper.findStudentExpulsions(1982, PT).size());
        
    }
    
}
