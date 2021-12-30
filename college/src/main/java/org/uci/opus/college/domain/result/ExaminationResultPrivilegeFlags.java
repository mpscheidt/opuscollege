package org.uci.opus.college.domain.result;

import org.uci.opus.college.domain.Examination;


public class ExaminationResultPrivilegeFlags extends ResultPrivilegeFlags<Examination> {

    @Override
    public boolean numberOfDaysAssignedHaveExpired(Examination exam) {
        return numberOfDaysAssignedHaveExpired(exam.getExaminationDate());
    }

}
