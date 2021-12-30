package org.uci.opus.college.domain.result;

import java.util.List;

import org.uci.opus.college.domain.ISubjectExamTest;

public interface IResult {

    int getId();

    int getStudyPlanDetailId();

    int getSubjectExamTestId();
    
    ISubjectExamTest getSubjectExamTest();

    int getStaffMemberId();

    String getMark();

    String getUniqueKey();

    String getPassed();

    void setPassed(String passed);

    /**
     * Has the result been modified or not? This is not necessarily the same as equals(), but a modification check to determine if the the
     * result needs to be stored into the database or not.
     * 
     * @param origResult
     * @return
     */
    boolean unmodified(IResult origResult);

    List<? extends IResult> getSubResults();

}
