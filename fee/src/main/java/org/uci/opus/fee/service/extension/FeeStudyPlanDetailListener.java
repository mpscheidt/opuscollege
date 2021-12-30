package org.uci.opus.fee.service.extension;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.extpoint.IStudyPlanDetailListener;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.OpusMethods;

@Service
public class FeeStudyPlanDetailListener implements
        IStudyPlanDetailListener {
    
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;

    @Override
    public void studyPlanDetailAdded(StudyPlanDetail studyPlanDetail, HttpServletRequest request) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String writeWho = opusMethods.getWriteWho(request);

        feeManager.createStudentBalances(studyPlanDetail, writeWho);

    }

    @Override
    public void beforeStudyPlanDetailDelete(int studyPlanDetailId, HttpServletRequest request) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String writeWho = opusMethods.getWriteWho(request);

        feeManager.deleteStudentBalancesByStudyPlanDetailId(studyPlanDetailId, writeWho);
        int studentId = studentManager.findStudentIdForStudyPlanDetailId(studyPlanDetailId);
        feeManager.updateAllStudentBalances(studentId, writeWho);

    }

}
