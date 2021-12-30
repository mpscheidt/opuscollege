package org.uci.opus.college.service;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.Note;
import org.uci.opus.college.persistence.NoteMapper;
import org.uci.opus.config.OpusConstants;

@Service
public class NoteManager {
    
    private static final String NOTE_MAPPER_NAME = NoteMapper.class.getName();

    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private SqlSession sqlSession;

    @Transactional
    public Note findNote(final int noteId, final String noteType) {
        String strNoteType = this.getNoteType(noteType);
        return sqlSession.selectOne(NOTE_MAPPER_NAME + ".find" + strNoteType, noteId);
    }

    @Transactional
    public void addNote(final Note note, final String noteType) {
        if (log.isDebugEnabled()) {
            log.debug("Adding note of type " + noteType + ": " + note);
        }

        String strNoteType = this.getNoteType(noteType);
        sqlSession.insert(NOTE_MAPPER_NAME + ".add" + strNoteType, note);
    }

    @Transactional
    public void updateNote(final Note note, final String noteType) {
        if (log.isDebugEnabled()) {
            log.debug("Updating note of type " + noteType + ": " + note);
        }

        String strNoteType = this.getNoteType(noteType);
        sqlSession.update(NOTE_MAPPER_NAME + ".update" + strNoteType, note);
    }

    @Transactional
    public void deleteNote(final int noteId, final String noteType) {
        if (log.isDebugEnabled()) {
            log.debug("Deleting note of type " + noteType + " with id " + noteId);
        }

        String strNoteType = this.getNoteType(noteType);
        sqlSession.delete(NOTE_MAPPER_NAME + ".delete" + strNoteType, noteId);
    }

    public void deleteNotes(final int studentId) {
        sqlSession.delete(NOTE_MAPPER_NAME + ".deleteStudentActivities", studentId);
        sqlSession.delete(NOTE_MAPPER_NAME + ".deleteStudentCareers", studentId);
        sqlSession.delete(NOTE_MAPPER_NAME + ".deleteStudentPlacements", studentId);
        sqlSession.delete(NOTE_MAPPER_NAME + ".deleteStudentCounselings", studentId);
    }

    /* find the name of the note type */
    private String getNoteType(final String noteType) {
        String note = "";
        if (noteType.equals(OpusConstants.NOTETYPE_ACTIVITY_SHORT)) {
            note = OpusConstants.NOTETYPE_ACTIVITY;
        }
        if (noteType.equals(OpusConstants.NOTETYPE_CAREER_SHORT)) {
            note = OpusConstants.NOTETYPE_CAREER;
        }
        if (noteType.equals(OpusConstants.NOTETYPE_PLACEMENT_SHORT)) {
            note = OpusConstants.NOTETYPE_PLACEMENT;
        }
        if (noteType.equals(OpusConstants.NOTETYPE_COUNSELING_SHORT)) {
            note = OpusConstants.NOTETYPE_COUNSELING;
        }
        return note;
    }

}
