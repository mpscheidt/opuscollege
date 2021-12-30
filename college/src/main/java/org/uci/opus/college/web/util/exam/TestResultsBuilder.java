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

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.TestResult;

@Component
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class TestResultsBuilder extends ResultLinesBuilder<TestResult, TestResultLine, TestResultLines> {

    private Test test = null;
	List < TestResult > allTestResults = null;

	public TestResultsBuilder() {
        super();
    }

	@Override
	protected TestResultLines newResultLines() {
	    return new TestResultLines();
	}

	@Override
	protected TestResultLine buildLine(StudyPlanDetail sdp) {
		TestResultLine line = super.buildLine(sdp);
		
        // MP 2013-09-26: create empty testResult if not yet reached the possible numberOfAttempts
        List<TestResult> results = line.getResults();
        if (results == null) {
            results = new ArrayList<>();
            line.setResults(results);
        }
        if (results.size() < test.getNumberOfAttempts()) {
            TestResult testResult = new TestResult();
            testResult.setStudyPlanDetailId(sdp.getId());
            testResult.setTestId(test.getId());
            testResult.setExaminationId(test.getExaminationId());
            testResult.setTestResultDate(new Date());
            testResult.setAttemptNr(results.size() + 1);
            testResult.setActive("Y");
            results.add(testResult);
        }

        return line;
	}

	@Override
	protected List<TestResult> findResults(int studyPlanDetailId) {
		return ExamUtil.extractTestResults(allTestResults, studyPlanDetailId, test.getId());
	}

	@Override
	protected TestResultLine makeNewResultLine() {
		return new TestResultLine();
	}

	public List<TestResult> getAllTestResults() {
		return allTestResults;
	}

	public void setAllTestResults(
			List<TestResult> allTestResults) {
		this.allTestResults = allTestResults;
	}

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }


}
