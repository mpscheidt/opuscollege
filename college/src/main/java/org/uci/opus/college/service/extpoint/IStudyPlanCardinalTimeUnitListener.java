package org.uci.opus.college.service.extpoint;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;

public interface IStudyPlanCardinalTimeUnitListener {

    /**
     * This method is called when a studyPlanCardinalTimeUnit has been added to the database.
     * @param studyPlanCardinalTimeUnit
     * @param previousStudyPlanCardinalTimeUnit If the student has been transferred from a previous time unit, null otherwise.
     * @param request
     */
    void studyPlanCardinalTimeUnitAdded(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit, HttpServletRequest request);

    /**
     * If there are any objections to the deletion of the given time unit, it can be rejected through the BindingResult.
     * @param studyPlanCardinalTimeUnit
     * @param result
     */
    void isDeleteAllowed(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, BindingResult result); 
    
    /**
     * Called before the studyPlanCardinalTimeUnit is deleted from the database.
     * @param studyPlanCardinalTimeUnitId
     * @param writeWho
     */
    void beforeStudyPlanCardinalTimeUnitDelete(final int studyPlanCardinalTimeUnitId, String writeWho);

}
