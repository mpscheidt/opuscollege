package org.uci.opus.college.domain.result;

import org.uci.opus.college.domain.Authorization;

/**
 * Extended authorization object for the case of subjects, examinations and tests.
 * 
 * @author markus
 *
 */
public class AuthorizationSubExTest extends Authorization {

    private boolean staffMemberLimitedToSelf;

    public AuthorizationSubExTest() {
        super();
    }

    public AuthorizationSubExTest(boolean create, boolean read, boolean update, boolean delete, boolean staffMemberLimitedToSelf) {
        super(create, read, update, delete);
        this.staffMemberLimitedToSelf = staffMemberLimitedToSelf;
    }

    public boolean isStaffMemberLimitedToSelf() {
        return staffMemberLimitedToSelf;
    }

    public void setStaffMemberLimitedToSelf(boolean staffMemberLimitedToSelf) {
        this.staffMemberLimitedToSelf = staffMemberLimitedToSelf;
    }

    @Override
    public String toString() {
        return "AuthorizationSubExTest [" + super.toString() + ", staffMemberLimitedToSelf=" + staffMemberLimitedToSelf + "]";
    }

    
}
