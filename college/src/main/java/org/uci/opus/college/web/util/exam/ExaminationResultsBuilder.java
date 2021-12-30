/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.college.web.util.exam;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.TestResult;

@Component
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class ExaminationResultsBuilder extends ResultLinesBuilder<ExaminationResult, ExaminationResultLine, ExaminationResultLines> {

    private static Logger log = LoggerFactory.getLogger(ExaminationResultsBuilder.class);

    Examination examination = null;
	List < ExaminationResult > allExaminationResults = null;

    public ExaminationResultsBuilder() {
        super();
    }

    @Override
    protected ExaminationResultLines newResultLines() {
        return new ExaminationResultLines();
    }

    /**
	 * Custom functionality: create 'exam results string'.
	 */
	@Override
	protected ExaminationResultLine buildLine(StudyPlanDetail sdp) {
	    ExaminationResultLine line = super.buildLine(sdp);
		
		List<? extends TestResult> testResults = ExamUtil
				.extractTestResults(sdp.getTestResults(), examination.getId());
		boolean testResultsFound = (testResults != null && !testResults.isEmpty());
		log.debug("Examinationresultsbuilder.buildLine: testResultsFound =" + testResultsFound);
		line.setSubResultsFound(testResultsFound);

		if (testResultsFound) {
			line.setSubResultsString(buildTestResultsString(testResults));
		}

        // MP 2013-09-26: create empty exampinationResult if not yet reached the possible numberOfAttempts
        List<ExaminationResult> results = line.getResults();
		if (results == null) {
		    results = new ArrayList<>();
		    line.setResults(results);
		}
        if (results.size() < examination.getNumberOfAttempts()) {
            ExaminationResult examinationResult = new ExaminationResult();
            examinationResult.setStudyPlanDetailId(sdp.getId());
            examinationResult.setExaminationId(examination.getId());
            examinationResult.setSubjectId(examination.getSubjectId());
            examinationResult.setExaminationResultDate(new Date());
            examinationResult.setAttemptNr(results.size() + 1);
            examinationResult.setActive("Y");
            results.add(examinationResult);
        }

		return line;
	}

	public String buildTestResultsString(List<? extends TestResult> testResults) {
		StringBuilder result = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        if (testResults != null && !testResults.isEmpty() && testResults.size() > 0) {
			for (Iterator<? extends TestResult> it = testResults.iterator(); it.hasNext(); ) {
				TestResult tr = it.next();
				Test ex = ExamUtil.getTest(examination.getTests(), tr.getTestId());
				if (ex != null && tr != null) {
					result.append("<br>");
                    result.append(df.format(tr.getTestResultDate()));
                    result.append(": ");
					result.append(ex.getTestDescription());
	                result.append(" (");
	                result.append(tr.getAttemptNr());
	                result.append("): ");
					result.append(tr.getMark());
	                result.append(" (");
	                result.append(tr.getPassed());
	                result.append(")");
				}
			}
        }
        return result.toString();
	}

	public Examination getExamination() {
		return examination;
	}

	public void setExamination(Examination examination) {
		this.examination = examination;
	}

	@Override
	protected List<ExaminationResult> findResults(int studyPlanDetailId) {
		return ExamUtil.extractExaminationResults(allExaminationResults, studyPlanDetailId, examination.getId());
	}

	@Override
	protected ExaminationResultLine makeNewResultLine() {
		return new ExaminationResultLine();
	}

	public List<ExaminationResult> getAllExaminationResults() {
		return allExaminationResults;
	}

	public void setAllExaminationResults(
			List<ExaminationResult> allExaminationResults) {
		this.allExaminationResults = allExaminationResults;
	}

}
