package org.uci.opus.fee.service.extension;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.IStudyPlanListener;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.OpusMethods;

@Service
public class FeeStudyPlanListener implements IStudyPlanListener {

    @Autowired private OpusMethods opusMethods;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private StudentManagerInterface studentManager;

    @Override
    public void studyPlanAdded(StudyPlan studyPlan, String writeWho) {
    }

    @Override
    public void beforeStudyPlanDelete(int studyPlanId, String writeWho) {

        StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);

        List <? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = studyPlan.getStudyPlanCardinalTimeUnits();
        for(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit:studyPlanCardinalTimeUnits){
            feeManager.deleteStudentBalancesByStudyPlanCardinalTimeUnitId(
                    studyPlanCardinalTimeUnit.getId(), writeWho);   
        }

        feeManager.updateAllStudentBalances(studyPlan.getStudentId(),
                writeWho);

    }

    @Override
    public void beforeStudyPlanUpdate(StudyPlan studyPlan, String writeWho) {
    }

    @Override
    public void beforeStudyPlanStatusUpdate(StudyPlan studyPlan, String writeWho) {
    }

}
