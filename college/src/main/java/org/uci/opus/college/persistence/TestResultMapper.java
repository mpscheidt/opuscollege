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

package org.uci.opus.college.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.TestResultHistory;
import org.uci.opus.college.domain.result.TestResult;

public interface TestResultMapper {

    List<TestResult> findTestResultsForStudyPlanDetailId(int studyPlanDetailId);

    /**
     * get the id's of the TestResult combination if it exists. used to check if it is allowed to
     * delete a subjectstudygradetype
     * 
     * @param params
     *            subjectId and studyGradeTypeId
     * @return list of TestResults
     */
    List<TestResult> findTestResultsForSubjectStudyGradeType(Map<String, Object> map);

    /**
     * get the id's of the TestResult combination if it exists. used to check if it is allowed to
     * delete a subjectblockstudygradetype
     * 
     * @param params
     *            subjectBlockId and studyGradeTypeId
     * @return list of TestResults
     */
    List<TestResult> findTestResultsForSubjectBlockStudyGradeType(Map<String, Object> map);

    /**
     * @param params
     *            id of the examinationResult and of the studyplandetail
     * @return List of testResults
     */
    List<TestResult> findTestResultsForStudyPlanDetail(Map<String, Object> map);

    /**
     * @param params
     *            id of the examinationResult and of the studyplandetail
     * @return List of testResults
     */
    List<TestResult> findActiveTestResultsForExaminationResult(Map<String, Object> map);

    /**
     * @param testResultId
     *            id of the TestResult
     * @return TestResult or null
     */
    TestResult findTestResult(int testResultId);

    /**
     * Find the result of a given test.
     * 
     * @param testId
     *            id of the test
     * @return List of testResults
     */
    List<TestResult> findTestResults(int testId);

    /**
     * Find the result of a given test.
     * 
     * @param map
     *            with parameters
     * @return List of testResults
     */
    List<TestResult> findTestResultsByParams(Map<String, Object> map);
    
    List<TestResultHistory> findTestResultHistory(@Param("testId") int testId, @Param("studyPlanDetailId") int studyPlanDetailId);

    /**
     * @param testResult
     *            the testResult to add
     */
    void addTestResult(TestResult testResult);

    void addTestResultHistory(TestResult testResult);

    /**
     * @param testResult
     *            the testResult to update
     * @return
     */
    void updateTestResult(TestResult testResult);

    void updateTestResultHistory(TestResult testResult);

    /**
     * @param testResultId
     *            id of the testResult
     * @param writeWho
     * @return
     */
    void deleteTestResult(int testResultId);

    void deleteTestResultHistory(TestResult testResult);

}
