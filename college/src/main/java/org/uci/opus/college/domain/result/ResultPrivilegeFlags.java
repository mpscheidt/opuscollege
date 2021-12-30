package org.uci.opus.college.domain.result;

import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang3.time.DateUtils;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.service.result.ResultPrivilegeFlagsFactory;

/**
 * A set of privilege flags for a subject, an examination or a test.
 * 
 * @author Markus Pscheidt
 * @see ResultPrivilegeFlagsFactory
 *
 */
public abstract class ResultPrivilegeFlags<T extends ISubjectExamTest> {

    private boolean roleCreate;
    private boolean roleRead;
    private boolean roleUpdate;
    private boolean roleDelete;
    private boolean roleEditHistoric;
    private boolean roleCreateAssigned;
    private boolean roleReadAssigned;
    private boolean roleUpdateAssigned;
    private boolean roleDeleteAssigned;
    private boolean roleReadOwn;

    /**
     * The number of days assigned staff members can enter results (for examinations and tests, because subjects do not have a subject
     * date).
     */
    private Integer numberOfDaysAssigned;

    /**
     * Empty constructor. Flags are not initialized.
     */
    public ResultPrivilegeFlags() {
    }

    /**
     * Verify if the number of days have expired during which staff members are allowed to enter examination and test results.
     * 
     * <p>
     * NB: Subject results do not have a result date and hence are not applicable to this check.
     * 
     * @param subExamTest
     * @return
     */
    public abstract boolean numberOfDaysAssignedHaveExpired(T subExamTest);

    public boolean isRoleCreate() {
        return roleCreate;
    }

    public void setRoleCreate(boolean roleCreate) {
        this.roleCreate = roleCreate;
    }

    public boolean isRoleRead() {
        return roleRead;
    }

    public void setRoleRead(boolean roleRead) {
        this.roleRead = roleRead;
    }

    public boolean isRoleUpdate() {
        return roleUpdate;
    }

    public void setRoleUpdate(boolean roleUpdate) {
        this.roleUpdate = roleUpdate;
    }

    public boolean isRoleDelete() {
        return roleDelete;
    }

    public void setRoleDelete(boolean roleDelete) {
        this.roleDelete = roleDelete;
    }

    public boolean isRoleCreateAssigned() {
        return roleCreateAssigned;
    }

    public void setRoleCreateAssigned(boolean roleCreateAssigned) {
        this.roleCreateAssigned = roleCreateAssigned;
    }

    public boolean isRoleReadAssigned() {
        return roleReadAssigned;
    }

    public void setRoleReadAssigned(boolean roleReadAssigned) {
        this.roleReadAssigned = roleReadAssigned;
    }

    public boolean isRoleUpdateAssigned() {
        return roleUpdateAssigned;
    }

    public void setRoleUpdateAssigned(boolean roleUpdateAssigned) {
        this.roleUpdateAssigned = roleUpdateAssigned;
    }

    public boolean isRoleDeleteAssigned() {
        return roleDeleteAssigned;
    }

    public void setRoleDeleteAssigned(boolean roleDeleteAssigned) {
        this.roleDeleteAssigned = roleDeleteAssigned;
    }

    public boolean isRoleReadOwn() {
        return roleReadOwn;
    }

    public void setRoleReadOwn(boolean roleReadOwn) {
        this.roleReadOwn = roleReadOwn;
    }

    public Integer getNumberOfDaysAssigned() {
        return numberOfDaysAssigned;
    }

    public void setNumberOfDaysAssigned(Integer numberOfDaysAssigned) {
        this.numberOfDaysAssigned = numberOfDaysAssigned;
    }

    public boolean numberOfDaysAssignedHaveExpired(Date date) {
        if (date != null && numberOfDaysAssigned != null) {
            Date expiryDate = DateUtils.addDays(date, numberOfDaysAssigned);

            // return true if today is later than the expiryDate
            // time (hour, minute, etc.) is ignored in the comparison, only date part is taking into consideration
            return DateUtils.truncatedCompareTo(new Date(), expiryDate, Calendar.DAY_OF_MONTH) > 0;
        }

        return false;
    }

    public boolean isRoleEditHistoric() {
        return roleEditHistoric;
    }

    public void setRoleEditHistoric(boolean roleEditHistoric) {
        this.roleEditHistoric = roleEditHistoric;
    }

}
