package org.uci.opus.fee.service.extension;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.service.extpoint.ISubjectStudyGradeTypeListener;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.OpusMethods;

@Service
public class FeeSubjectStudyGradeTypeListener implements ISubjectStudyGradeTypeListener {

    @Autowired private OpusMethods opusMethods;
    @Autowired private FeeManagerInterface feeManager;

    @Override
    public void beforeSubjectStudyGradeTypeDelete(int subjectStudyGradeTypeId, HttpServletRequest request) {

        String writeWho = opusMethods.getWriteWho(request);

        // delete fees that are bound to the subjectStudyGradeType
        feeManager.deleteFeesForSubjectStudyGradeType(subjectStudyGradeTypeId, writeWho);
        
    }

}
