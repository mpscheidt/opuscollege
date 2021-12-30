package org.uci.opus.college.service.result;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.IAttempt;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;

@Service
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class SubjectResultGenerator extends ResultGenerator<Subject, ExaminationResult> {
	
	@Autowired
	private LookupCacher lookupCacher;
	
	private CodeToLookupMap codeToExaminationTypeMap;

    public SubjectResultGenerator(Subject subject, List<ExaminationResult> examinationResults, String preferredLanguage, SubjectResultRounder rounder) {
        // calling super with maxFailedLowerLevelResults = -1, i.e. no limit examination on failed examination results
        super(subject, examinationResults, -1, preferredLanguage, rounder);
    }

    @Override
    public String msgKeyNoResults() {
        return "jsp.error.noexaminationresults";
    }

    @Override
    public String msgKeyNotAllResults() {
        return "jsp.error.notallexaminationresults";
    }

    @Override
    public String msgKeyFailedResults() {
        return "jsp.error.failedexaminationresults";
    }

    public Subject getSubject() {
        return getSubExTest();
    }
    
    public List<ExaminationResult> getExaminationResults() {
    	return getLowerLevelResults();
    }
    
    @Override
    public BigDecimal getLowerLevelThresholdToPassThisLevel(IAttempt attempt) {

    	Lookup10 examinationType = getExaminationType((Examination) attempt);
    	if (examinationType != null) {

    		// NB: this is for now the simplistic conversion from String to BigDecimal
    		//     might one day need to use ResultManager.markDecimalTakingIntoAccountEndgrades() if letter grades are used
    		return resultUtil.toDecimalMark(examinationType.getPassSubjectThreshold());
    	}
    	
    	return null;
    }
    
    @Override
    public Integer getLowerLevelThresholdResultCommentId(IAttempt attempt) {

    	Lookup10 examinationType = getExaminationType((Examination) attempt);
    	if (examinationType != null) {
    		return examinationType.getThresholdSubjectResultCommentId();
    	}
    	
    	return null;
    }
    
    @Override
    public boolean isFailedLowerLevelFailsThisLevel(IAttempt attempt) {

    	Lookup10 examinationType = getExaminationType((Examination) attempt);
    	if (examinationType != null) {
    		return examinationType.isFailSubject();
    	}

    	return false;
    }

    @Override
    public Integer getLowerLevelFailResultCommentId(IAttempt attempt) {

    	Lookup10 examinationType = getExaminationType((Examination) attempt);
    	if (examinationType != null) {
    		return examinationType.getFailSubjectResultCommentid();
    	}
    	
    	return null;
    }

    private Lookup10 getExaminationType(Examination examination) {
    	if (codeToExaminationTypeMap == null) {
    		List<Lookup10> examinationTypes = lookupCacher.getAllExaminationTypes(preferredLanguage);
    		this.codeToExaminationTypeMap = new CodeToLookupMap(examinationTypes);
    	}

    	return (Lookup10) this.codeToExaminationTypeMap.get(examination.getExaminationTypeCode());
    }
    
}
