package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.StudyPlanDetail;

public interface IStudyPlanDetailListener {

    /**
     * This method is called when a studyPlanDetail has been added to the database.
     * @param studyPlanDetail
     * @param request
     */
    void studyPlanDetailAdded(StudyPlanDetail studyPlanDetail, HttpServletRequest request);
    
    /**
     * Called before the studyPlanDetail is deleted from the database.
     * @param studyPlanDetailId
     * @param request
     */
    void beforeStudyPlanDetailDelete(final int studyPlanDetailId, HttpServletRequest request);

}
