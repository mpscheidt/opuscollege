package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

public interface StudentListener {

    /**
     * Called before the student is deleted from the database.
     * @param studentId
     * @param request
     */
    void beforeStudentDelete(final int studentId, HttpServletRequest request);

}
