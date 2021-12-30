package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

public interface IStudyGradeTypeListener {

    /**
     * This method is called when a study is about to be deleted from the database.
     * @param studyId
     * @param request
     */
    void beforeStudyGradeTypeDelete(final int studyId, HttpServletRequest request);

}
