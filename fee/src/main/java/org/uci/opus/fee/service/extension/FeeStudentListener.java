package org.uci.opus.fee.service.extension;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.service.extpoint.StudentListener;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.util.OpusMethods;

@Service
public class FeeStudentListener implements StudentListener {

    @Autowired private OpusMethods opusMethods;
    @Autowired private FeeManagerInterface feeManager;
//    @Autowired private StudentManagerInterface studentManager;


    @Override
    public void beforeStudentDelete(final int studentId, HttpServletRequest request) {

        String writeWho = opusMethods.getWriteWho(request);

        feeManager.deleteStudentBalancesByStudentId(studentId, writeWho);
    }

}
