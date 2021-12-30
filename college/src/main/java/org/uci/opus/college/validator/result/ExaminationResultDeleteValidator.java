package org.uci.opus.college.validator.result;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;

@Service
public class ExaminationResultDeleteValidator {

    private ResultManagerInterface resultManager;
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    public ExaminationResultDeleteValidator(ResultManagerInterface resultManager, AppConfigManagerInterface appConfigManager) {
        this.resultManager = resultManager;
        this.appConfigManager = appConfigManager;
    }

    public void validate(ExaminationResult examinationResult, Errors errors, Map<String, AuthorizationSubExTest> authorizationMap) {

        if (examinationResult == null) {
            return;
        }

        // Assert authorization
        if (!resultManager.hasDeleteAuthorization(examinationResult, authorizationMap)) {
            errors.rejectValue("mark", "jsp.error.noauthorization.deleteresult");
            return;
        }

        // when auto generate subject result then deletion of subject result will be triggered automatically,
        // otherwise don't allow deleting examination result when subject result exists
        if (!appConfigManager.getAutoGenerateSubjectResult()) {
            
            // Check for subject result
//            Map<String, Object> map = new HashMap<>();
//            map.put("subjectId", examinationResult.getSubjectId());
//            map.put("studyPlanDetailId", examinationResult.getStudyPlanDetailId());
//            List<SubjectResult> subjectResults = resultManager.findSubjectResultsByParams(map);
//            if (subjectResults != null && !subjectResults.isEmpty()) {
            if (resultManager.findLatestSubjectResult(examinationResult.getStudyPlanDetailId(), examinationResult.getSubjectId()) != null) {
                errors.rejectValue("mark", "general.exists.subjectresult");
            }
        }


    }

}
