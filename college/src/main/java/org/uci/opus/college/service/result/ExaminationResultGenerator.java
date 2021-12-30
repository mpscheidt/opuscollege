package org.uci.opus.college.service.result;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.IAttempt;
import org.uci.opus.college.domain.result.TestResult;

@Service
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class ExaminationResultGenerator extends ResultGenerator<Examination, TestResult> {

	public static final String ERROR_FAILEDTESTRESULTS = "jsp.error.failedtestresults";
	public static final String ERROR_NOTALLTESTRESULTS = "jsp.error.notalltestresults";
	public static final String ERROR_NOTESTRESULTS = "jsp.error.notestresults";

	public ExaminationResultGenerator(Examination examination, List<TestResult> testResults,
			int maxFailedLowerLevelResults, String preferredLanguage, ExaminationResultRounder rounder) {
		super(examination, testResults, maxFailedLowerLevelResults, preferredLanguage, rounder);
	}

	@Override
	public String msgKeyNoResults() {
		return ERROR_NOTESTRESULTS;
	}

	@Override
	public String msgKeyNotAllResults() {
		return ERROR_NOTALLTESTRESULTS;
	}

	@Override
	public String msgKeyFailedResults() {
		return ERROR_FAILEDTESTRESULTS;
	}

	public List<TestResult> getTestResults() {
		return getLowerLevelResults();
	}

	@Override
	public BigDecimal getLowerLevelThresholdToPassThisLevel(IAttempt attempt) {
		// not implemented yet for the test results to influence the generation of
		// an examination result
		return null;
	}

	@Override
	public Integer getLowerLevelThresholdResultCommentId(IAttempt attempt) {
		// not implemented yet
		return null;
	}

	@Override
	public boolean isFailedLowerLevelFailsThisLevel(IAttempt attempt) {
		// not implemented yet
		return false;
	}

	@Override
	public Integer getLowerLevelFailResultCommentId(IAttempt attempt) {
		// not implemented yet
		return null;
	}

}
