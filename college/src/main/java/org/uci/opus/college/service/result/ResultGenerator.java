package org.uci.opus.college.service.result;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.IAttempt;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.domain.result.ResultRounder;

/**
 * Reusable logic related to the generation of results based on lower level
 * results, ie. applicable to all results except test results (which are at the
 * lowest level).
 * 
 * The logic is reusable in the sense that it applies to various elements in the
 * hierarchy of grading, for example subjects and examinations, but could also
 * apply to cardinal time units.
 * 
 * This follows the builder pattern.
 * 
 * @author markus
 *
 */
public abstract class ResultGenerator<E extends ISubjectExamTest, R extends IResult> {

	@Autowired
	protected ResultUtil resultUtil;

	private E subExTest;
	private List<R> lowerLevelResults;
	private int maxFailedLowerLevelResults;
	protected String preferredLanguage;
	protected ResultRounder resultRounder;

	private Boolean generatedPassed;
	private Integer assessmentResultCommentId;
	private String generatedMark;
	private BigDecimal generatedMarkDec;
	private int nFailedAtLowerLevel;
	private int nMissingAtLowerLevel;

	public ResultGenerator(E subExTest, List<R> lowerLevelResults, int maxFailedLowerLevelResults,
			String preferredLanguage, ResultRounder resultRounder) {
		this.subExTest = subExTest;
		this.lowerLevelResults = lowerLevelResults;
		this.maxFailedLowerLevelResults = maxFailedLowerLevelResults;
		this.preferredLanguage = preferredLanguage;
		this.resultRounder = resultRounder;
	}

	/**
	 * @return the msk key used in case no lower level results are available.
	 */
	public abstract String msgKeyNoResults();

	/**
	 * @return the msg key used in case the available set of results does not
	 *         cover all required grading items.
	 */
	public abstract String msgKeyNotAllResults();

	/**
	 * @return the msg key used in case for one or more grading items there are
	 *         only failed results.
	 */
	public abstract String msgKeyFailedResults();

	/**
	 * A minimum mark to be able to pass the higher level mark, e.g. final exam
	 * threshold of 8 to pass subject result.
	 * 
	 * @param attempt
	 *            lower level attempt (e..g {@code examination}
	 * @return null if undefined
	 */
	public abstract BigDecimal getLowerLevelThresholdToPassThisLevel(IAttempt attempt);

	/**
	 * The comment that is set when the lower level threshold has not been reached.
	 * 
	 * <p>
	 * This only applies when
	 * {@link #getLowerLevelThresholdToPassThisLevel(IAttempt)} (for example
	 * {@code passSubjectThreshold}) is defined and unreached.
	 * 
	 * @param attempt
	 *            lower level attempt (e..g {@code examination}
	 * @return defaults to false if not available
	 */
	public abstract Integer getLowerLevelThresholdResultCommentId(IAttempt attempt);
	
	/**
	 * Flag if lower level failed result should result in failing this level.
	 * For example, {@code examinationType.failSubject}.
	 * 
	 * @param attempt
	 *            lower level attempt (e..g {@code examination}
	 * @return
	 */
	public abstract boolean isFailedLowerLevelFailsThisLevel(IAttempt attempt);

	/**
	 * The comment that is set according to the lower level assessment.
	 * 
	 * <p>
	 * This only applies when
	 * {@link #isFailedLowerLevelFailsThisLevel(IAttempt)} (for example
	 * {@code failSubject}) is true and the lower level result is failed.
	 * 
	 * @param attempt
	 *            lower level attempt (e..g {@code examination}
	 * @return defaults to false if not available
	 */
	public abstract Integer getLowerLevelFailResultCommentId(IAttempt attempt);

	/**
	 * Validate if all the lower level grading units have been passed, ie. if
	 * there are results available with a passed mark.
	 * 
	 * <p>
	 * This algorithm can deal with multiple results per examination/test.
	 * 
	 * <p>
	 * NB: Validation is immediately canceled if a (failed) result has been determined
	 * due to {@link #checkLowerLevelFailConditions()}.
	 * 
	 * @param bindingResult
	 */
	public void validate(BindingResult bindingResult) {

		// this call may already lead to a negative result, in which case the generation is successful
		// and further validation is neither necessary nor desired
		checkLowerLevelFailConditions();

		// if a (negative) result has been generated already, no need for any further validation
		if (generatedPassed != null) {
			return;
		}

		if (lowerLevelResults != null && lowerLevelResults.size() != 0) {

			determineNumberOfMissingAndFailed();

			if (nMissingAtLowerLevel != 0) {
				bindingResult.rejectValue("mark", msgKeyNotAllResults(), new Object[] { nMissingAtLowerLevel },
						"missing results");
			}
			if (maxFailedLowerLevelResults > -1 && nFailedAtLowerLevel > maxFailedLowerLevelResults) {
				bindingResult.rejectValue("mark", msgKeyFailedResults(), new Object[] { nFailedAtLowerLevel },
						"failed results");
			}

		} else {
			bindingResult.rejectValue("mark", msgKeyNoResults());
		}

	}

	/**
	 * Find out how many lower level items have been missed and how many have
	 * been failed.
	 */
	public void determineNumberOfMissingAndFailed() {

		nMissingAtLowerLevel = 0;
		nFailedAtLowerLevel = 0;
		for (ISubjectExamTest subItem : subExTest.getSubItems()) {

			// only consider active grading items
			if (!"Y".equalsIgnoreCase(subItem.getActive())) {
				continue;
			}

			boolean foundPassedResult = false;
			boolean foundNegativeResult = false;
			for (R llResult : lowerLevelResults) {
				if (subItem.getId() == llResult.getSubjectExamTestId()) {
					if ("Y".equals(llResult.getPassed())) {
						foundPassedResult = true;
						break;
					} else {
						foundNegativeResult = true;
					}
				}
			}
			if (!foundPassedResult) {
				if (foundNegativeResult) {
					nFailedAtLowerLevel++;
				} else {
					nMissingAtLowerLevel++;
				}
			}
		}
	}

	/**
	 * Check negative lower level results to see if they prohibit passing at
	 * this level.
	 * 
	 * Failed lower level results may be of a (e.g. examination) type that is
	 * configured to fail the higher level.
	 * 
	 * If a threshold is given, then only lower level marks below the threshold
	 * will result in failing this level.
	 */
	protected void checkLowerLevelFailConditions() {

		for (IResult lowerLevelResult : lowerLevelResults) {
			if (lowerLevelThresholdMissed(lowerLevelResult)) {

				// not passed, therefore set the comment if applicable
				this.generatedPassed = false;
				this.assessmentResultCommentId = getLowerLevelThresholdResultCommentId((IAttempt) lowerLevelResult.getSubjectExamTest());

			} else if (failedLowerLevelFailsThisLevel(lowerLevelResult)) {

				this.generatedPassed = false;
				this.assessmentResultCommentId = getLowerLevelFailResultCommentId((IAttempt) lowerLevelResult.getSubjectExamTest());

			}
			
			if (this.generatedPassed != null) {
				// No need to look at further (negative) results after first negative result tells us to fail this result
				//   for now we assume that it is okay to take the comment from the first identified failed lower level result
				//   and not look for comment on other failed lower level that would meet the criteria
				break;
			}
		}
	}

	/**
	 * Fail this level because lower level threshold not met?
	 */
	private boolean lowerLevelThresholdMissed(IResult lowerLevelResult) {

		IAttempt lowerLevelAssessment = (IAttempt) lowerLevelResult.getSubjectExamTest();
		BigDecimal lowerLevelThresholdToPassThisLevel = getLowerLevelThresholdToPassThisLevel(lowerLevelAssessment);
		if (lowerLevelThresholdToPassThisLevel != null) {
			BigDecimal lowerLevelMark = resultUtil.toDecimalMark(lowerLevelResult.getMark());
			if (lowerLevelMark == null || lowerLevelMark.compareTo(lowerLevelThresholdToPassThisLevel) < 0) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Fail this level because lower level result is negative and
	 * fail-this-level applies?
	 */
	private boolean failedLowerLevelFailsThisLevel(IResult lowerLevelResult) {

		if ("N".equalsIgnoreCase(lowerLevelResult.getPassed())) {
			IAttempt lowerLevelAssessment = (IAttempt) lowerLevelResult.getSubjectExamTest();
			Integer lowerLevelFailResultCommentId = getLowerLevelFailResultCommentId(lowerLevelAssessment);

			if (lowerLevelFailResultCommentId != null) {
				return true;
			}
		}

		return false;
	}

	/**
	 * This generates the various "ingredients": mark, passed, result comment.
	 * Once this is done, the Result and ResultComment domain objects can be created.
	 */
	public void build() {

		// if a (negative) result has been generated already, there is nothing further to do
		if (generatedPassed != null) {
			return;
		}

		generateMark();
		generatePassed();

	}

	protected void generatePassed() {

	}

	/**
	 * This method generates the mark based on the lower level results according
	 * to the weighing factors of each test/examination.
	 * 
	 * <p>
	 * The result is stored as a string in the field <code>generatedMark</code>
	 * and as a BigDecimal value in the field <code>generatedMarkDec</code>.
	 */
	protected void generateMark() {

		BigDecimal markDec = BigDecimal.ZERO;
		BigDecimal perc100 = new BigDecimal(100);

		for (IResult r : lowerLevelResults) {

			IAttempt attempt = (IAttempt) r.getSubjectExamTest();
			BigDecimal weighingFactor = new BigDecimal(attempt.getWeighingFactor());

			markDec = markDec.add(weighingFactor.divide(perc100).multiply(new BigDecimal(r.getMark())));
		}

		this.generatedMarkDec = markDec;
		this.generatedMark = resultRounder.roundMark(markDec).toPlainString();
	}

	public int getMaxFailedLowerLevelResults() {
		return maxFailedLowerLevelResults;
	}

	public String getGeneratedMark() {
		return generatedMark;
	}

	public BigDecimal getGeneratedMarkDec() {
		return generatedMarkDec;
	}

	public int getnFailedAtLowerLevel() {
		return nFailedAtLowerLevel;
	}

	public int getnMissingAtLowerLevel() {
		return nMissingAtLowerLevel;
	}

	public E getSubExTest() {
		return subExTest;
	}

	public List<R> getLowerLevelResults() {
		return lowerLevelResults;
	}

	public String getPreferredLanguage() {
		return preferredLanguage;
	}

	public Boolean isGeneratedPassed() {
		return generatedPassed;
	}

	public Integer getAssessmentResultCommentId() {
		return assessmentResultCommentId;
	}

}
