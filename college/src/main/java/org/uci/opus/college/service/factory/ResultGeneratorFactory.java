package org.uci.opus.college.service.factory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.result.ExaminationResultGenerator;
import org.uci.opus.college.service.result.ExaminationResultRounder;
import org.uci.opus.college.service.result.ResultUtil;
import org.uci.opus.college.service.result.SubjectResultGenerator;
import org.uci.opus.college.service.result.SubjectResultRounder;

@Configuration
public class ResultGeneratorFactory {

    @Autowired
    private ResultManagerInterface resultManager;
    
    @Autowired
    private ResultUtil resultUtil;
    
    @Autowired
    private ExaminationResultRounder examinationResultRounder;
    
    @Autowired
    private SubjectResultRounder subjectResultRounder;
    
    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    public SubjectResultGenerator resultGenerator(Subject subject, int studyPlanDetailId, String preferredLanguage) {

        Map<String, Object> findExaminationResultsMap = new HashMap<>();
        findExaminationResultsMap.put("subjectId", subject.getId());
        findExaminationResultsMap.put("studyPlanDetailId", studyPlanDetailId);
        List<ExaminationResult> examinationResults = resultManager.findActiveExaminationResultsForSubjectResult(findExaminationResultsMap);

        // retain only the highest marks, no need for lesser results
        examinationResults = resultUtil.getHighestMarkResults(examinationResults);

        return new SubjectResultGenerator(subject, examinationResults, preferredLanguage, subjectResultRounder);
    }

    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    public ExaminationResultGenerator resultGenerator(Examination examination, int studyPlanDetailId, int maxFailedLowerLevelResults, String preferredLanguage) {
        
        Map<String, Object> findTestResultsMap = new HashMap<>();
        findTestResultsMap.put("examinationId", examination.getId());
        findTestResultsMap.put("studyPlanDetailId", studyPlanDetailId);
		List<TestResult> testResults = resultManager.findActiveTestResultsForExaminationResult(findTestResultsMap);

        return new ExaminationResultGenerator(examination, testResults, maxFailedLowerLevelResults, preferredLanguage, examinationResultRounder);
    }
    
}
