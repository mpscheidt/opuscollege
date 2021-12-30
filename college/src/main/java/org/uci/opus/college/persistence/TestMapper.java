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
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;

/**
 * @author move
 *
 */
public interface TestMapper {

    /**
     * @param   map contains the following parameters:
     *          institutionId
     *          branchId
     *          organizationalUnitId
     *          studyId
     *          educationTypeCode              
     * @return  List of Examination objects or null
     */
    List < Test > findTests(final Map<String, Object> map);

    /**
     * Find tests of which a given staffmember is not the teacher.
     * @param  map contains the following parameters:
     *         institutionId
     *         branchId
     *         organizationalUnitId
     *         studyId
     *         staffMemberId
     *         
     * @return List of Examination objects or null
     */
    List < Test > findTestsNotForTeacher(final Map<String, Object> map);

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
     * @param testId id of Test to delete
     */
    void deleteTest(final int testId);

    /**
     * Find a given combination of test and teacher.
     * @param testTeacherId id of the combination
     * @return TestTeacher object or null
     */
    TestTeacher findTestTeacher(final int testTeacherId);

    /**
     * Find a list of given combination of test and teacher.
     * @param testId id of the combination
     * @return List of TestTeacher objects or null
     */
    List <TestTeacher > findTeachersForTest(final int testId);

    /**
     * Add a given combination of test and teacher.
     * @param testTeacher to add
     */
    void addTestTeacher(final TestTeacher testTeacher);

    /**
     * Update a given combination of test and teacher.
     * @param testTeacher to update
     */
    void updateTestTeacher(final TestTeacher testTeacher);

    /**
     * Delete a given combination of test and teacher.
     * @param testTeacherId id of testTeacher to delete
     */
    void deleteTestTeacher(final int testTeacherId);

    /**
     * Transfer the tests that belong to the given originalExaminationId
     * to the examination with the given newExaminationId.
     * @param originalExaminationId
     * @param newExaminationId
     */
    void transferTests(@Param("originalExaminationId") int originalExaminationId,
            @Param("newExaminationId")  int newExaminationId);

    /**
     * @param originalTestId
     * @param newExaminationId
     * @return number of inserted records
     */
    int transferTest(Map<String, Object> map);

    /**
     * @param originalTestId
     * @param newTestId
     * @param targetAcademicYearId
     */
    void transferTestTeachers(@Param("originalTestId") int originalTestId, @Param("newTestId") int newTestId, 
            @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * Get the sum of the weights of the selected tests.
     * @return null if no tests defined
     */
    Integer findTotalWeighingFactor(Map<String, Object> map);

}
