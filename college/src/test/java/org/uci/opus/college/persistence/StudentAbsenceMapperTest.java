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
import org.uci.opus.college.domain.StudentAbsence;
import org.uci.opus.util.DateUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class StudentAbsenceMapperTest extends OpusDBTestCase {

    private static final String ANULOU_A_MATRICULA = "anulou a matricula";
    @Autowired
    private StudentAbsenceMapper studentAbsenceMapper;
    
    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/StudentAbsenceMapperTest-prepData.xml");
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
    public void findStudentAbsence() {

        StudentAbsence studentAbsence = studentAbsenceMapper.findStudentAbsence(5);
        assertEquals(1982, studentAbsence.getStudentId());
        assertEquals(ANULOU_A_MATRICULA, studentAbsence.getReasonForAbsence());
        assertEquals(DateUtil.parseIsoDateNoExc("2013-04-30"), studentAbsence.getStartdateTemporaryInactivity());
        assertEquals(DateUtil.parseIsoDateNoExc("2013-05-31"), studentAbsence.getEnddateTemporaryInactivity());
    }

    @Test
    public void addStudentAbsence() {
        
        Date startdate = DateUtil.parseIsoDateNoExc("2014-01-15");
        String reason = "another good reason";
        StudentAbsence studentAbsence = new StudentAbsence(1993, startdate, reason);
        studentAbsenceMapper.addStudentAbsence(studentAbsence);

        assertEquals(2, studentAbsenceMapper.findStudentAbsencesForStudent(1993).size());
    }

    @Test
    public void updateStudentAbsence() {
        
        StudentAbsence studentAbsence = studentAbsenceMapper.findStudentAbsence(1);
        String reason = "modified reason";
        studentAbsence.setReasonForAbsence(reason);
        studentAbsenceMapper.updateStudentAbsence(studentAbsence);
        
        studentAbsence = studentAbsenceMapper.findStudentAbsence(1);
        assertEquals(reason, studentAbsence.getReasonForAbsence());
    }
    
    @Test
    public void deleteStudentAbsence() {
        
        studentAbsenceMapper.deleteStudentAbsence(5);
        
        List<StudentAbsence> studentAbsences = studentAbsenceMapper.findStudentAbsencesForStudent(1982);
        assertEquals(1, studentAbsences.size());
        assertEquals(1, studentAbsences.get(0).getId());
    }

    @Test
    public void deleteStudentAbsences() {

        studentAbsenceMapper.deleteStudentAbsences(1982);
        assertEquals(0, studentAbsenceMapper.findStudentAbsencesForStudent(1982).size());
        
    }
    
}
