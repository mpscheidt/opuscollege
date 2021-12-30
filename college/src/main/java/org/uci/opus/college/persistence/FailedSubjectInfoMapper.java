package org.uci.opus.college.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.util.FailedSubjectInfo;

public interface FailedSubjectInfoMapper {

    List<FailedSubjectInfo> findAllFailedSubjectInfosForStudyPlan(@Param("studyPlanId") int studyPlanId, @Param("rigidityTypeCode") String rigidityTypeCode);

}
