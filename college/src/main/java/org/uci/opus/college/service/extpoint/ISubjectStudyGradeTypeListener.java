package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

public interface ISubjectStudyGradeTypeListener {

    /**
     * This method is called when a subjectStudyGradeType has been added to the database.
     * @param subjectStudyGradeTypeId
     * @param request
     */
//    void subjectStudyGradeTypeAdded(SubjectStudyGradeType subjectStudyGradeType, HttpServletRequest request);

    /**
     * This method is called when a subjectStudyGradeType is about to be deleted from the database.
     * @param subjectStudyGradeTypeId
     * @param request
     */
    void beforeSubjectStudyGradeTypeDelete(final int subjectStudyGradeTypeId, HttpServletRequest request);

}
