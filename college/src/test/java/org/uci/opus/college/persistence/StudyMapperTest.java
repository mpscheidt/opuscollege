package org.uci.opus.college.persistence;

import static org.junit.Assert.assertNotEquals;

import java.util.Arrays;
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
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class StudyMapperTest extends OpusDBTestCase {

    @Autowired
    private StudyMapper studyMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/StudyMapperTest-prepData.xml");
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { new DefaultTable("opuscollege.academicyear"),
                new DefaultTable("opuscollege.institution"), new DefaultTable("opuscollege.organizationalunit"), new DefaultTable("opuscollege.classgroup"),
                new DefaultTable("opuscollege.subject"), new DefaultTable("opuscollege.subjectclassgroup"), new DefaultTable("opuscollege.studyplan") });
        return dataSetToTruncate;
    }
    
    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testFindClassgroupById() {

        // Classgroup 1
        Classgroup classgroup = studyMapper.findClassgroupById(1);
        verifyTurmaA(classgroup);

        // Classgroup 2
        classgroup = studyMapper.findClassgroupById(2);
        verifyTurmaB(classgroup);
    }

    private void verifyTurmaA(Classgroup classgroup) {

        assertEquals("Turma A", classgroup.getDescription());
        assertNotNull(classgroup.getSubjectClassgroups());
        assertEquals(2, classgroup.getSubjectClassgroups().size());

        List<Integer> subjectIds = Arrays.asList(1690, 1685);
        assertTrue(subjectIds.contains(classgroup.getSubjectClassgroups().get(0).getSubjectId()));
        assertTrue(subjectIds.contains(classgroup.getSubjectClassgroups().get(1).getSubjectId()));
        assertNotEquals(classgroup.getSubjectClassgroups().get(0).getSubjectId(), classgroup.getSubjectClassgroups().get(1).getSubjectId());

        assertNotNull(classgroup.getSubjectClassgroups().get(0).getSubject());
        assertNotNull(classgroup.getSubjectClassgroups().get(1).getSubject());
    }
    
    private void verifyTurmaB(Classgroup classgroup) {

        assertEquals("Turma B", classgroup.getDescription());
        assertNotNull(classgroup.getSubjectClassgroups());
        assertEquals(1, classgroup.getSubjectClassgroups().size());
        assertEquals(1709, classgroup.getSubjectClassgroups().get(0).getSubjectId());

        assertNotNull(classgroup.getSubjectClassgroups().get(0).getSubject());
        assertEquals("BIOL002", classgroup.getSubjectClassgroups().get(0).getSubject().getSubjectCode());
        assertEquals("Biology 2", classgroup.getSubjectClassgroups().get(0).getSubject().getSubjectDescription());
    }

    @Test
    public void testFindClassgroupsByStudygradetypeId() {
        
        List<Classgroup> classgroups = studyMapper.findClassgroupsByStudygradetypeId(256);
        verifyTurmas(classgroups);
    }
    
    @Test
    public void testFindClassgroupsForStaffmember() {

        // Find the classgroups for the given staffmember, who is assigned to the same classgroup in two subjects
        Map<String, Object> findClassgroupsMap = new HashMap<>();
        findClassgroupsMap.put("staffMemberId", 1);
        List<Classgroup> allClassgroups = studyMapper.findClassgroups(findClassgroupsMap);
        assertEquals(1, allClassgroups.size());
        
    }

    private void verifyTurmas(List<Classgroup> classgroups) {
        assertEquals(2, classgroups.size());
        verifyTurmaA(classgroups.get(0));
        verifyTurmaB(classgroups.get(1));
    }

    @Test
    public void testFindStudies() {
        Map<String, Object> findStudiesMap = new HashMap<>();

        findStudiesMap.put("institutionId", 107);
        findStudiesMap.put("institutionTypeCode", "3");
        List<Study> studies = studyMapper.findStudies(findStudiesMap);
        assertEquals(4, studies.size());

        findStudiesMap.put("branchId", 118);
        studies = studyMapper.findStudies(findStudiesMap);
        assertEquals(3, studies.size());

        findStudiesMap.put("organizationalUnitId", 17);
        studies = studyMapper.findStudies(findStudiesMap);
        assertEquals(2, studies.size());
        
        findStudiesMap.put("studyIds", Arrays.asList(1211));
        studies = studyMapper.findStudies(findStudiesMap);
        assertEquals(1, studies.size());
        assertEquals("Chemistry", studies.get(0).getStudyDescription());
    }

    @Test
    public void testFindStudy() {
        Study study = studyMapper.findStudy(1214);
        assertEquals("Philosophy", study.getStudyDescription());
    }

    @Test
    public void testFindStudyWithStudyGradeType() {
        Study study = studyMapper.findStudy(1213);
        assertEquals("Electronics", study.getStudyDescription());
        
        List<? extends StudyGradeType> studyGradeTypes = study.getStudyGradeTypes();
        assertNotNull(studyGradeTypes);
        assertEquals(1, studyGradeTypes.size());
    }

    @Test
    public void testFindStudyGradeTypesForStudy() {

        Map<String, Object> findStudyGradeTypesMap = new HashMap<>();
        findStudyGradeTypesMap.put("studyId", 1213);
        findStudyGradeTypesMap.put("currentAcademicYearId", 1);
        findStudyGradeTypesMap.put("preferredLanguage", "en");
        List<StudyGradeType> allStudyGradeTypes = studyMapper.findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);

        assertEquals(1, allStudyGradeTypes.size());
        StudyGradeType studyGradeType = allStudyGradeTypes.get(0);
        assertEquals("Electronics", studyGradeType.getStudyDescription());
        verifyTurmas(studyGradeType.getClassgroups());
    }
}
