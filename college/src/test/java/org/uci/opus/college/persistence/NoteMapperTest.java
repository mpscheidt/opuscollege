package org.uci.opus.college.persistence;

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
import org.uci.opus.college.domain.Note;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml"
    , "/org/uci/opus/college/applicationContext-util.xml"
    , "/org/uci/opus/college/applicationContext-service.xml"
    , "/org/uci/opus/college/applicationContext-data.xml" 
    })
public class NoteMapperTest extends OpusDBTestCase {

    private static final String BLA_BLA_ACTIVITY = "bla bla activity";
    private static final String BLA_BLA_AGAIN = "bla bla again";
    private static final String CAR_INTEREST = "car interest";
    private static final String CAR_AGAIN = "car again";
    private static final String A_PLACEMENT = "a placement";
    private static final String PLACE_AGAIN = "place again";
    private static final String HAS_BEEN_COUNSLD = "has been counsld";
    private static final String COUNSEL_AGAIN = "counsel again";
    
    @Autowired
    private NoteMapper noteMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/persistence/NoteMapperTest-prepData.xml");
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
    public void findStudentActivity() {

        Note note = noteMapper.findStudentActivity(2);
        assertEquals(BLA_BLA_ACTIVITY, note.getDescription());
        assertEquals(1982, note.getForeignId());
    }

    @Test
    public void findStudentActivities() {
        
        List<Note> notes = noteMapper.findStudentActivities(1982);
        assertEquals(2, notes.size());
        assertEquals(BLA_BLA_ACTIVITY, notes.get(0).getDescription());
        assertEquals(BLA_BLA_AGAIN, notes.get(1).getDescription());
    }
    
    @Test
    public void addStudentActivity() {
        
        Note note = new Note(1982, "another activity");
        noteMapper.addStudentActivity(note);
        assertEquals(3, noteMapper.findStudentActivities(1982).size());
    }

    @Test
    public void updateStudentActivity() {
        
        Note note = noteMapper.findStudentActivity(2);
        String description = "mod activitiy";
        note.setDescription(description);
        noteMapper.updateStudentActivity(note);
        
        note = noteMapper.findStudentActivity(2);
        assertEquals(description, note.getDescription());
    }
    
    @Test
    public void deleteStudentActivity() {
        
        noteMapper.deleteStudentActivity(2);
        
        List<Note> notes = noteMapper.findStudentActivities(1982);
        assertEquals(1, notes.size());
        assertEquals(BLA_BLA_AGAIN, notes.get(0).getDescription());
        
    }

    @Test
    public void deleteStudentActivities() {

        noteMapper.deleteStudentActivities(1982);
        assertEquals(0, noteMapper.findStudentActivities(1982).size());
        
    }
    
    // === student career ===
    
    @Test
    public void findStudentCareer() {

        Note note = noteMapper.findStudentCareer(2);
        assertEquals(CAR_INTEREST, note.getDescription());
        assertEquals(1982, note.getForeignId());
    }

    @Test
    public void findStudentCareers() {
        
        List<Note> notes = noteMapper.findStudentCareers(1982);
        assertEquals(2, notes.size());
        assertEquals(CAR_INTEREST, notes.get(0).getDescription());
        assertEquals(CAR_AGAIN, notes.get(1).getDescription());
    }
    
    @Test
    public void addStudentCareer() {
        
        Note note = new Note(1982, "another note");
        noteMapper.addStudentCareer(note);
        assertEquals(3, noteMapper.findStudentCareers(1982).size());
    }

    @Test
    public void updateStudentCareer() {
        
        Note note = noteMapper.findStudentCareer(2);
        String description = "mod text";
        note.setDescription(description);
        noteMapper.updateStudentCareer(note);
        
        note = noteMapper.findStudentCareer(2);
        assertEquals(description, note.getDescription());
    }
    
    @Test
    public void deleteStudentCareer() {
        
        noteMapper.deleteStudentCareer(2);
        
        List<Note> notes = noteMapper.findStudentCareers(1982);
        assertEquals(1, notes.size());
        assertEquals(CAR_AGAIN, notes.get(0).getDescription());
        
    }

    @Test
    public void deleteStudentCareers() {

        noteMapper.deleteStudentCareers(1982);
        assertEquals(0, noteMapper.findStudentCareers(1982).size());
        
    }

    // === student placements ===
    
    @Test
    public void findStudentPlacement() {

        Note note = noteMapper.findStudentPlacement(2);
        assertEquals(A_PLACEMENT, note.getDescription());
        assertEquals(1982, note.getForeignId());
    }

    @Test
    public void findStudentPlacements() {
        
        List<Note> notes = noteMapper.findStudentPlacements(1982);
        assertEquals(2, notes.size());
        assertEquals(A_PLACEMENT, notes.get(0).getDescription());
        assertEquals(PLACE_AGAIN, notes.get(1).getDescription());
    }
    
    @Test
    public void addStudentPlacement() {
        
        Note note = new Note(1982, "another note");
        noteMapper.addStudentPlacement(note);
        assertEquals(3, noteMapper.findStudentPlacements(1982).size());
    }

    @Test
    public void updateStudentPlacement() {
        
        Note note = noteMapper.findStudentPlacement(2);
        String description = "mod text";
        note.setDescription(description);
        noteMapper.updateStudentPlacement(note);
        
        note = noteMapper.findStudentPlacement(2);
        assertEquals(description, note.getDescription());
    }
    
    @Test
    public void deleteStudentPlacement() {
        
        noteMapper.deleteStudentPlacement(2);
        
        List<Note> notes = noteMapper.findStudentPlacements(1982);
        assertEquals(1, notes.size());
        assertEquals(PLACE_AGAIN, notes.get(0).getDescription());
        
    }

    @Test
    public void deleteStudentPlacements() {

        noteMapper.deleteStudentPlacements(1982);
        assertEquals(0, noteMapper.findStudentPlacements(1982).size());
        
    }

    // === student counseling ===
    
    @Test
    public void findStudentCounseling() {

        Note note = noteMapper.findStudentCounseling(2);
        assertEquals(HAS_BEEN_COUNSLD, note.getDescription());
        assertEquals(1982, note.getForeignId());
    }

    @Test
    public void findStudentCounselings() {
        
        List<Note> notes = noteMapper.findStudentCounselings(1982);
        assertEquals(2, notes.size());
        assertEquals(HAS_BEEN_COUNSLD, notes.get(0).getDescription());
        assertEquals(COUNSEL_AGAIN, notes.get(1).getDescription());
    }
    
    @Test
    public void addStudentCounseling() {
        
        Note note = new Note(1982, "another note");
        noteMapper.addStudentCounseling(note);
        assertEquals(3, noteMapper.findStudentCounselings(1982).size());
    }

    @Test
    public void updateStudentCounseling() {
        
        Note note = noteMapper.findStudentCounseling(2);
        String description = "mod text";
        note.setDescription(description);
        noteMapper.updateStudentCounseling(note);
        
        note = noteMapper.findStudentCounseling(2);
        assertEquals(description, note.getDescription());
    }
    
    @Test
    public void deleteStudentCounseling() {
        
        noteMapper.deleteStudentCounseling(2);
        
        List<Note> notes = noteMapper.findStudentCounselings(1982);
        assertEquals(1, notes.size());
        assertEquals(COUNSEL_AGAIN, notes.get(0).getDescription());
        
    }

    @Test
    public void deleteStudentCounselings() {

        noteMapper.deleteStudentCounselings(1982);
        assertEquals(0, noteMapper.findStudentCounselings(1982).size());
        
    }

}
