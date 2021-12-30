package org.uci.opus.college.domain.result;

import org.uci.opus.college.domain.Test;


public class TestResultPrivilegeFlags extends ResultPrivilegeFlags<Test> {

    @Override
    public boolean numberOfDaysAssignedHaveExpired(Test test) {
        return numberOfDaysAssignedHaveExpired(test.getTestDate());
    }

}
