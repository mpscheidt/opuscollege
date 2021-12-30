package org.uci.opus.college.validator.result;

import java.util.HashMap;
import java.util.Map;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.util.StringUtil;

public class SubjectResultDeleteValidator implements Validator {

    private ResultManagerInterface resultManager;
    private StudentManagerInterface studentManager;

    public SubjectResultDeleteValidator(StudentManagerInterface studentManager, ResultManagerInterface resultManager) {
        this.studentManager = studentManager;
        this.resultManager = resultManager;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return SubjectResult.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {

        SubjectResult subjectResult = (SubjectResult) target;
        StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(subjectResult.getStudyPlanDetailId());

        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanCardinalTimeUnitId", studyPlanDetail.getStudyPlanCardinalTimeUnitId());
        CardinalTimeUnitResult ctuResult = resultManager.findCardinalTimeUnitResultByParams(map);
        if (ctuResult != null && !StringUtil.isEmpty(ctuResult.getMark(), true)) {
            errors.reject("jsp.error.subjectresult.delete");
            errors.reject("general.exists.cardinaltimeunitresult");
        }

    }

}
