package org.uci.opus.fee.service.extension.curriculumtransition;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.extpoint.SubjectBlockStudyGradeTypeTransitionExtPoint;
import org.uci.opus.fee.persistence.FeeDeadlineMapper;
import org.uci.opus.fee.persistence.FeeMapper;

@Component
public class SubjectBlockFeeTransition implements
        SubjectBlockStudyGradeTypeTransitionExtPoint {

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private FeeMapper feeMapper;

    @Autowired
    private FeeDeadlineMapper feeDeadlineMapper;

    @Override
    public void transfer(int sourceAcademicYearId, int targetAcademicYearId) {

        int intervalInDays = academicYearManager.getIntervalInDaysBetweenAcademicYears(
                sourceAcademicYearId, targetAcademicYearId);

        feeMapper.transferSubjectBlockFees(sourceAcademicYearId, targetAcademicYearId);
        feeDeadlineMapper.transferSubjectBlockFeeDeadlines(sourceAcademicYearId, targetAcademicYearId, intervalInDays + " days");

    }


    @Override
    public int getOrder() {
        return 0;
    }

}
