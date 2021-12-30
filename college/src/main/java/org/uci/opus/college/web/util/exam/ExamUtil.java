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
import java.util.Iterator;
import java.util.List;

import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;

public abstract class ExamUtil {

	/**
	 * Extracts all examination results which belong to the given subjectId.
	 * @param allExaminationResults
	 * @param subjectId
	 * @return
	 */
	public static List<? extends ExaminationResult> extractExaminationResults(List<? extends ExaminationResult> allExaminationResults, int subjectId) {
		if (allExaminationResults == null) return null;
		List<ExaminationResult> result = new ArrayList<ExaminationResult>(allExaminationResults.size());
		if (allExaminationResults != null && allExaminationResults.size() > 0) {
			for (Iterator<? extends ExaminationResult> it = allExaminationResults.iterator(); it.hasNext(); ) {
				ExaminationResult er = it.next();
				if (er.getSubjectId() == subjectId) {
					result.add(er);
				}
			}
		}
		return result;
	}

	/**
	 * Extracts all test results which belong to the given examinationId.
	 * @param allTestResults
	 * @param examinationId
	 * @return
	 */
	public static List<? extends TestResult> extractTestResults(List<? extends TestResult> allTestResults, int examinationId) {
		if (allTestResults == null) return null;
		List<TestResult> result = new ArrayList<TestResult>(allTestResults.size());
		if (allTestResults != null && allTestResults.size() > 0) {
			for (Iterator<? extends TestResult> it = allTestResults.iterator(); it.hasNext(); ) {
				TestResult t = it.next();
				if (t.getExaminationId() == examinationId) {
					result.add(t);
				}
			}
		}
		return result;
	}

	public static Examination getExamination(List < ? extends Examination > allExaminations, int examinationId) {
		Examination result = null;
		if (allExaminations != null && allExaminations.size() > 0) {
			for (Iterator<? extends Examination> it = allExaminations.iterator(); it.hasNext(); ) {
				Examination ex = it.next();
				if (ex.getId() == examinationId) {
					result = ex;
					break;
				}
			}
		}
		return result;
	}

	public static Test getTest(List <? extends Test> allTests, int testId) {
		Test result = null;
		if (allTests != null && allTests.size() > 0) {
			for (Iterator<? extends Test> it = allTests.iterator(); it.hasNext(); ) {
				Test t = it.next();
				if (t.getId() == testId) {
					result = t;
					break;
				}
			}
		}
		return result;
	}

	/**
	 * Check if there exists a subject result for the given studyPlanDetailId.
	 * The first result is returned (because there should be only one result).
	 * @param allSubjectResults
	 * @param studyPlanDetailId
	 * @return
	 */
	public static SubjectResult extractSubjectResult(List < SubjectResult > allSubjectResults, int studyPlanDetailId, int subjectId) {
		SubjectResult result = null;
		if (allSubjectResults != null && allSubjectResults.size() > 0) {
			for (Iterator<SubjectResult> it = allSubjectResults.iterator(); it.hasNext(); ) {
				SubjectResult sr = it.next();
				if (sr.getStudyPlanDetailId() == studyPlanDetailId
						&& sr.getSubjectId() == subjectId) {
					result = sr;
					break;
				}
			}
		}
		return result;
	}

	/**
	 * Check if there exists one or more examination results for the given studyPlanDetailId.
	 * A list of of results is returned.
	 * @param allExaminationResults
	 * @param studyPlanDetailId
	 * @return
	 */
	public static List<ExaminationResult> extractExaminationResults(
			List < ExaminationResult > allExaminationResults,
			int studyPlanDetailId, int examinationId) {
		List<ExaminationResult> result = new ArrayList<ExaminationResult>();
		if (allExaminationResults != null && allExaminationResults.size() > 0) {
			for (Iterator<ExaminationResult> it = allExaminationResults.iterator(); it.hasNext(); ) {
				ExaminationResult er = it.next();
				if (er.getStudyPlanDetailId() == studyPlanDetailId
						&& er.getExaminationId() == examinationId) {
					result.add(er);
				}
			}
		}
		return result;
	}

    /**
     * Check if there exists one or more test results for the given studyPlanDetailId.
     * A list of of results is returned.
     * @param allExaminationResults
     * @param studyPlanDetailId
     * @return
     */
    public static List<TestResult> extractTestResults(
            List < TestResult > allTestResults,
            int studyPlanDetailId, int testId) {
        List<TestResult> result = new ArrayList<TestResult>();
        if (allTestResults != null && allTestResults.size() > 0) {
            for (Iterator<TestResult> it = allTestResults.iterator(); it.hasNext(); ) {
                TestResult tr = it.next();
                if (tr.getStudyPlanDetailId() == studyPlanDetailId
                        && tr.getTestId() == testId) {
                    result.add(tr);
                }
            }
        }
        return result;
    }

}
