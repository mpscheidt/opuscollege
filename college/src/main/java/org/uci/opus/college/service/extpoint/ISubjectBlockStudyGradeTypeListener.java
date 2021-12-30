package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

public interface ISubjectBlockStudyGradeTypeListener {

    /**
     * This method is called when a subjectBlockStudyGradeType has been added to the database.
     * @param subjectBlockStudyGradeTypeId
     * @param request
     */
//    void subjectBlockStudyGradeTypeAdded(SubjectBlockStudyGradeType subjectBlockStudyGradeType, HttpServletRequest request);

    /**
     * This method is called when a subjectBlockStudyGradeType is about to be deleted from the database.
     * @param subjectBlockStudyGradeTypeId
     * @param request
     */
    void beforeSubjectBlockStudyGradeTypeDelete(final int subjectBlockStudyGradeTypeId, HttpServletRequest request);

}
