package org.uci.opus.college.domain.result;

import org.uci.opus.college.domain.Subject;

public class SubjectResultPrivilegeFlags extends ResultPrivilegeFlags<Subject> {

    /**
     * Never expries because there is no assessment date for subjects.
     */
    @Override
    public boolean numberOfDaysAssignedHaveExpired(Subject subject) {
        return false;
    }

}
