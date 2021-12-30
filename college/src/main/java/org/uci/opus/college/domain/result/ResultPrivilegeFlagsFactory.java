package org.uci.opus.college.domain.result;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.OpusPrivilege;

public class ResultPrivilegeFlagsFactory {

    public SubjectResultPrivilegeFlags forSubjects(HttpServletRequest request) {
        SubjectResultPrivilegeFlags resultPrivilegeFlags = new SubjectResultPrivilegeFlags();
        standardFlags(resultPrivilegeFlags, request);
        resultPrivilegeFlags.setRoleReadOwn(request.isUserInRole(OpusPrivilege.READ_OWN_SUBJECT_RESULTS));
        return resultPrivilegeFlags;
    }

    public ExaminationResultPrivilegeFlags forExaminations(HttpServletRequest request) {
        ExaminationResultPrivilegeFlags resultPrivilegeFlags = new ExaminationResultPrivilegeFlags();
        standardFlags(resultPrivilegeFlags, request);
        resultPrivilegeFlags.setRoleReadOwn(request.isUserInRole(OpusPrivilege.READ_OWN_EXAMINATION_RESULTS));
        return resultPrivilegeFlags;
    }

    public TestResultPrivilegeFlags forTests(HttpServletRequest request) {
        TestResultPrivilegeFlags resultPrivilegeFlags = new TestResultPrivilegeFlags();
        standardFlags(resultPrivilegeFlags, request);
        resultPrivilegeFlags.setRoleReadOwn(request.isUserInRole(OpusPrivilege.READ_OWN_TEST_RESULTS));
        return resultPrivilegeFlags;
    }

    /**
     * These privileges are the same for subjects, examinations and tests.
     * (This may change when separate privileges are introduced for examinations and tests.)
     * 
     * @param request
     * @return
     */
    private void standardFlags(ResultPrivilegeFlags<? extends ISubjectExamTest> resultPrivilegeFlags, HttpServletRequest request) {
        resultPrivilegeFlags.setRoleCreate(request.isUserInRole(OpusPrivilege.CREATE_SUBJECTS_RESULTS));
        resultPrivilegeFlags.setRoleRead(request.isUserInRole(OpusPrivilege.READ_SUBJECTS_RESULTS));
        resultPrivilegeFlags.setRoleUpdate(request.isUserInRole(OpusPrivilege.UPDATE_SUBJECTS_RESULTS));
        resultPrivilegeFlags.setRoleDelete(request.isUserInRole(OpusPrivilege.DELETE_SUBJECTS_RESULTS));
        resultPrivilegeFlags.setRoleCreateAssigned(request.isUserInRole(OpusPrivilege.CREATE_RESULTS_ASSIGNED_SUBJECTS));
        resultPrivilegeFlags.setRoleReadAssigned(request.isUserInRole(OpusPrivilege.READ_RESULTS_ASSIGNED_SUBJECTS));
        resultPrivilegeFlags.setRoleUpdateAssigned(request.isUserInRole(OpusPrivilege.UPDATE_RESULTS_ASSIGNED_SUBJECTS));
        resultPrivilegeFlags.setRoleDeleteAssigned(request.isUserInRole(OpusPrivilege.DELETE_RESULTS_ASSIGNED_SUBJECTS));
    }

}
