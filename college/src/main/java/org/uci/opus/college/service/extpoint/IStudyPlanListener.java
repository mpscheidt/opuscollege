package org.uci.opus.college.service.extpoint;


import org.uci.opus.college.domain.StudyPlan;

public interface IStudyPlanListener {

    /**
     * This method is called when a studyPlan has been added to the database.
     * @param writeWho TODO
     * @param studyPlanId
     */
    void studyPlanAdded(StudyPlan studyPlan, String writeWho);

    /**
     * This method is called when a study plan is about to be deleted from the database.
     * @param studyPlanId
     * @param writeWho TODO
     */
    void beforeStudyPlanDelete(final int studyPlanId, String writeWho);

    /**
     * Called before the study plan is updated in the database.
     * @param studyPlan
     * @param writeWho TODO
     */
    void beforeStudyPlanUpdate(StudyPlan studyPlan, String writeWho);

    /**
     * Called before the study plan status is updated in the database.
     * The difference to {@link #beforeStudyPlanUpdate(StudyPlan, String)}
     * is that only the status is updated.
     * @param studyPlan
     * @param writeWho TODO
     */
    void beforeStudyPlanStatusUpdate(StudyPlan studyPlan, String writeWho);

}
