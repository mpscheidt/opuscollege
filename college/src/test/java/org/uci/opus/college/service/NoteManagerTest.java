package org.uci.opus.college.service;

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
import org.uci.opus.college.persistence.NoteMapper;
import org.uci.opus.config.OpusConstants;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "/standardTestBeans.xml", "/org/uci/opus/college/applicationContext-util.xml", "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/college/applicationContext-data.xml" })
public class NoteManagerTest extends OpusDBTestCase {

    private static final String BLA_BLA_ACTIVITY = "bla bla activity";
    private static final String BLA_BLA_AGAIN = "bla bla again";

    @Autowired
    private NoteManager noteManager;

    @Autowired
    private NoteMapper noteMapper;

    @Override
    protected IDataSet getDataSet() throws Exception {
        DataFileLoader loader = new FlatXmlDataFileLoader();
        return loader.load("/org/uci/opus/college/service/NoteManagerTest-prepData.xml");
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] { new DefaultTable("opuscollege.academicyear"), new DefaultTable("opuscollege.institution"),
                new DefaultTable("opuscollege.organizationalunit"), new DefaultTable("opuscollege.classgroup"), new DefaultTable("opuscollege.examination"),
                new DefaultTable("opuscollege.subjectclassgroup"), new DefaultTable("opuscollege.studyplan") });
        return dataSetToTruncate;
    }

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void findNote() {

        Note note = noteManager.findNote(2, OpusConstants.NOTETYPE_ACTIVITY_SHORT);
        assertEquals(BLA_BLA_ACTIVITY, note.getDescription());
        assertEquals(1982, note.getForeignId());
    }

    @Test
    public void addNote() {

        Note note = new Note(1982, "another activity");
        noteManager.addNote(note, OpusConstants.NOTETYPE_ACTIVITY_SHORT);
        assertEquals(3, noteMapper.findStudentActivities(1982).size());
    }

    @Test
    public void updateNote() {

        Note note = noteMapper.findStudentActivity(2);
        String description = "mod activitiy";
        note.setDescription(description);
        noteManager.updateNote(note, OpusConstants.NOTETYPE_ACTIVITY_SHORT);

        note = noteMapper.findStudentActivity(2);
        assertEquals(description, note.getDescription());
    }

    @Test
    public void deleteNote() {

        noteManager.deleteNote(2, OpusConstants.NOTETYPE_ACTIVITY_SHORT);

        List<Note> notes = noteMapper.findStudentActivities(1982);
        assertEquals(1, notes.size());
        assertEquals(BLA_BLA_AGAIN, notes.get(0).getDescription());

    }

    @Test
    public void deleteNotes() {

        noteManager.deleteNotes(1982);

        assertEquals(0, noteMapper.findStudentActivities(1982).size());
        assertEquals(0, noteMapper.findStudentCareers(1982).size());
        assertEquals(0, noteMapper.findStudentCounselings(1982).size());
        assertEquals(0, noteMapper.findStudentPlacements(1982).size());
    }

}
