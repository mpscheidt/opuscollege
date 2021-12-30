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

package org.uci.opus.college.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;

/**
 * @author move
 *
 */
public interface TestManagerInterface {

    /**
     * @param map
     * @return List of Examination objects or null
     */
    List<Test> findTests(final Map<String, Object> map);

    /**
     * 
     * @param testIds
     * @return
     */
    List<Test> findTests(Collection<Integer> testIds);

    /**
     * @param staffMemberId
     * @return List of Test objects or null
     */
    List< Test > findTestsNotForTeacher(final Map<String, Object> map);

    /**
     * @param testId id of Test
     * @return Test object or null
     */
    Test findTest(final int testId);

    /**
     * @param examinationId
     * @return List of Test objects or null
     */
    List<Test > findTestsForExamination(final int examinationId);

    /**
     * @param examinationId
     * @return List of Test objects or null
     */
    List<Test > findActiveTestsForExamination(final int examinationId);

    /**
     * @param map with params to find the examinatino with
     * @return Test object or null
     */
    Test findTestByParams(final Map<String, Object> map);

    /**
     * @param test to add
     */
    void addTest(final Test test);

    /**
     * @param test to update
     */
    void updateTest(final Test test);

    /**
     * Delete test and cascaded test teachers and test results.
     * 
     * @param testId id of Test to delete
     */
    void deleteTest(final int testId);

    /**
     * @param testTeacherId
     * @return TestTeacher object or null
     */
    TestTeacher findTestTeacher(final int testTeacherId);

    /**
     * Find a list of given combination of test and teacher.
     * @param testId id of the combination
     * @return List of TestTeacher objects or null
     */
    List <  TestTeacher > findTeachersForTest(final int testId);

    /**
     * @param testTeacher id of the testteacher
     * @param request TODO
     * @return 
     */
    void addTestTeacher(final TestTeacher testTeacher, HttpServletRequest request);

    /**
     * @param testTeacher id of the testteacher
     * @param request TODO
     * @return 
     */
    void updateTestTeacher(final TestTeacher testTeacher, HttpServletRequest request);

    /**
     * @param testTeacherId id of the testteacher
     * @return 
     */
    void deleteTestTeacher(final int testTeacherId);

    /**
     * Get the sum of the weights of all tests for the examination
     * with the given examinationId.
     * @param examinationId
     * @param testIdToignore the examination with the given id will not be counted.
     * @return
     */
    int findTotalWeighingFactor(int examinationId, int testIdToignore);

    /**
     * Get the sum of the weights of all tests for the examination
     * with the given examinationId.
     * @param examinationId
     * @return
     */
    int findTotalWeighingFactor(int examinationId);

    /**
     * Get the test-specific business rule for passing the test or, if not defined, the sys-option value.
     * @param test the test for which to find the business rule for passing
     * @return the business rule if found, or null
     */
    String getBRsPassingTest(Test test);

}
