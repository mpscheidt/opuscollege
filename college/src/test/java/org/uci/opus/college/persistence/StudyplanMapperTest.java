package org.uci.opus.college.persistence;

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

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class StudyplanMapperTest extends OpusDBTestCase {

    private static final String CERTIFICADO_FALSO = "Certificado falso";
    private static final String FRAUDE_ACADEMICA = "Fraude academica";
    private static final String SOMETHING_FISHY = "Something fishy";

    @Autowired
    private StudyplanMapper studyplanMapper;
    
    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/StudyplanMapperTest-prepData.xml");
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
    public void findTotalNumberOfStudyPlans() {
        
        assertEquals(3, studyplanMapper.findTotalNumberOfStudyPlans());
    }
    
    @Test
    public void findNumberOfActiveStudyPlans() {

        // All 3 study plans are active
        assertEquals(3, studyplanMapper.findNumberOfActiveStudyPlans());
    }

    @Test
    public void findOne() {
//
//        StudentExpulsion studentExpulsion = studyplanMapper.findStudentExpulsion(1, PT);
//        assertEquals(1982, studentExpulsion.getStudentId());
//        assertEquals(FRAUDE_ACADEMICA, studentExpulsion.getExpulsionType().getDescription());
//        assertEquals(SOMETHING_FISHY, studentExpulsion.getReasonForExpulsion());
//        assertEquals(DateUtil.parseIsoDateNoExc("2016-02-20"), studentExpulsion.getStartDate());
//        assertEquals(DateUtil.parseIsoDateNoExc("2016-02-29"), studentExpulsion.getEndDate());
    }

//    @Test
//    public void findMany() {
//        
//        List<StudentExpulsion> studentExpulsions = studyplanMapper.findStudentExpulsions(1982, EN);
//        assertEquals(2, studentExpulsions.size());
//        assertEquals(1, studentExpulsions.get(0).getId());
//        assertEquals(2, studentExpulsions.get(1).getId());
//    }
//
//    @Test
//    public void add() {
//        
//        // the expellationType that corresponds with the record in the database
//        Lookup expellationType = new Lookup(PT, "1", CERTIFICADO_FALSO);
//        expellationType.setId(1);
//
//        StudentExpulsion studentExpulsion = new StudentExpulsion(1993, DateUtil.parseIsoDateNoExc("2016-01-08"), expellationType, "exp reason");
//        studyplanMapper.addStudentExpulsion(studentExpulsion);
//        assertEquals(2, studyplanMapper.findStudentExpulsions(1993, EN).size());
//    }
//
//    @Test
//    public void update() {
//        
//        StudentExpulsion studentExpulsion = studyplanMapper.findStudentExpulsion(2, PT);
//        Date enddate = DateUtil.parseIsoDateNoExc("2016-02-14");
//        studentExpulsion.setEndDate(enddate);
//        studyplanMapper.updateStudentExpulsion(studentExpulsion);
//        
//        studentExpulsion = studyplanMapper.findStudentExpulsion(2, EN);
//        assertEquals(enddate, studentExpulsion.getEndDate());
//    }
//    
//    @Test
//    public void delete() {
//        
//        studyplanMapper.deleteStudentExpulsion(2);
//
//        List<StudentExpulsion> studentExpulsions = studyplanMapper.findStudentExpulsions(1982, EN);
//        assertEquals(1, studentExpulsions.size());
//        assertEquals(1, studentExpulsions.get(0).getId());
//    }
//
//    @Test
//    public void deleteMany() {
//
//        studyplanMapper.deleteStudentExpulsions(1982);
//        assertEquals(0, studyplanMapper.findStudentExpulsions(1982, PT).size());
//        
//    }
    
}
