/*******************************************************************************
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
 * The Original Code is Opus-College fee module code.
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
 ******************************************************************************/
package org.uci.opus.fee.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.fee.domain.Fee;

public interface FeeMapper {

    /**
     * Returns a list of fees on subject block study grade type level by study-id.
     * 
     * @param studyId
     *            id of the fees to find
     * @return List of Fee-objects or null
     */
    List<Fee> findFeesForSubjectBlockStudyGradeTypes(int studyId);

    /**
     * Returns a list of fees on subject study grade type level by study-id.
     * 
     * @param studyId
     *            id of the fees to find
     * @return List of Fee-objects or null
     */
    List<Fee> findFeesForSubjectStudyGradeTypes(int studyId);

    /**
     * Returns a list of fees on study gradetype level by their study-id.
     * 
     * @param studyId
     *            id of the fees to find
     * @return List of Fee-objects or null
     */
    List<Fee> findFeesForStudyGradeTypes(int studyId);

    List<Fee> findFeesForStudyGradeType(int studyGradeTypeId);

    /**
     * Returns a list of fees on branch level.
     * 
     * @param branchId
     *            id of the branch, the fees are linked to
     * @return List of Fee-objects or null
     */
    List<Fee> findFeesForBranch(int branchId);

    List<Fee> findFeesForEducationAreas(HashMap<String, Object> map);

    /**
     * Get all the feeIds for a given academicYearId
     * 
     * @param academicYearId
     * @return list of ids
     */
    List<Integer> findFeeIdsForAcademicYear(int academicYearId);

    /**
     * Returns fee by its id.
     * 
     * @param feeId
     *            id of the fee to find
     * @return Fee-object or null
     */
    Fee findFee(int feeId);

    /**
     * The BalanceBroughtForward (BBFwd) is a special kind of fee. The amount is exclusive to every
     * student, so it cannot be stored in the fee itself. It is stored in the appliedFee.amount.
     * There is just one general fee for BBFwd because we need to determine the feeCategory. This
     * method gets the feeId of the fee that is linked to the feeCategory BBFwd.
     * 
     * @param map
     *            contains: categoryCode code of the feeCategory BBFwd and language as the
     *            preferredLanguage of user
     * @return the feeId of the fee linked to the feeCategory BBFwd
     */
    int findFeeIdByCategoryCode(@Param("categoryCode") String categoryCode, @Param("language") String language);

    /**
     * Returns a list of all fees.
     * 
     * @return List of Fee-objects or null
     */
    List<Fee> findAllFees();

    /**
     * Returns fee by its subjectblockid/subjectid.
     * 
     * @param map
     *            subjectblockid/subjectid of the fee to find
     * @return Fee-object or null
     */
    Fee findFeeByStudyIds(Map<String, Object> map);

    /**
     * Find fees that match the given parameters.
     * 
     * @param params
     * @return
     */
    List<Fee> findFeesByParams(Map<String, Object> params);

    /**
     * Returns a list of fees by their academicYear/categoryCode for a given branch, excluding a
     * given fee. Used as a check in the FeeAcademicYearValidator
     * 
     * @param map
     *            academicYear/categoryCode and branchId of the fees to find + feeId of fee to
     *            exclude
     * @return list of Fee-objects or null
     */
    List<Fee> findFeeByAcademicYearAndCategoryCode(Map<String, Object> map);

    /**
     * Returns fee by studyGradeTypeId
     * 
     * @param map
     *            studyGradeTypeI/categoryCode of fee to find
     * @return Fee-object or null
     */
    Fee findFeeByStudyGradeTypeIdAndCategoryCode(Map<String, Object> map);

    /**
     * @param map
     *            with params
     * @return List of SubjectStudyGradeTypes or null
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypesWithoutFee(Map<String, Object> map);

    /**
     * @param map
     *            with params
     * @return List of SubjectBlockStudyGradeTypes or null
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesWithoutFee(Map<String, Object> map);

    /**
     * Find studyGradeTypes for which to add a fee
     * 
     * @param map
     *            with parameters studyId, preferredLanguage and categoryCode
     * @return List of StudyGradeTypes or null
     */
    List<StudyGradeType> findStudyGradeTypesForFee(Map<String, Object> map);

    /**
     * Returns a list of fees on subject block study grade type level for a student.
     * 
     * @param studentId
     *            id of the fees to find
     * @return List of fee-objects or null
     */
    List<Fee> findStudentFeesForSubjectBlockStudyGradeTypes(int studentId);

    /**
     * Returns a list of fees on subject study grade type level for a student.
     * 
     * @param studentId
     *            id of the fees to find
     * @return List of fee-objects or null
     */
    List<Fee> findStudentFeesForSubjectStudyGradeTypes(int studentId);

    /**
     * Returns a list of fees on study grade type level for a student.
     * 
     * @param studentId
     *            id of the fees to find
     * @return List of fee-objects or null
     */
    List<Fee> findStudentFeesForStudyGradeTypes(int studentId);

    /**
     * Returns a list of fees on academic year level for a student.
     * 
     * @param studentId
     *            id of the fees to find
     * @return List of fee-objects or null
     */
    List<Fee> findStudentFeesForAcademicYears(int studentId);

    /**
     * Find all fees already linked to a student
     * 
     * @param studentId
     *            id of the student
     * @return a list of fees
     */
    List<Fee> findExistingFeesForStudent(int studentId);

    /**
     * Find all fees that are linked to subjects in a studyPlan
     * 
     * @param studyPlanId
     *            id of the studyPlan
     * @return a list of fees
     */
    List<Fee> findPossibleSubjectFeesForStudyPlan(int studyPlanId);

    /**
     * Find all fees that are linked to subjectblocks in a studyPlan
     * 
     * @param studyPlanId
     *            id of the studyPlan
     * @return a list of fees
     */
    List<Fee> findPossibleSubjectBlockFeesForStudyPlan(int studyPlanId);

    /**
     * Find all fees that are linked to studyGradeTypes in a studyPlan
     * 
     * @param studyPlanId
     *            id of the studyPlan
     * @return a list of fees
     */
    List<Fee> findPossibleStudyGradeTypeFeesForStudyPlan(int studyPlanId);

    /**
     * Find all fees based on area of education
     * 
     * @param map
     *            containing: studyPlanId maxAcademicYear: academicYear of the latest studyPlanCtu
     *            of the student language: preferredLanguage of the user
     * @return list of fees based on area of education
     */
    List<Fee> findPossibleEducationAreaFeesForStudyPlan(HashMap<String, Object> map);

    /**
     * @param fee
     *            the fee to add
     */
    void addFee(Fee fee);

    void addFeeHistory(Fee fee);

    /**
     * @param fee
     *            the fee to update
     */
    void updateFee(Fee fee);

    void updateFeeHistory(Fee fee);

    /**
     * @param feeId
     *            of the fee to delete and who wrote it
     */
    void deleteFee(int feeId);

    void deleteFeeHistory(Fee fee);

    /**
     * Transfer fees with studyGradeTypeId
     * 
     * @param sourceStudyGradeTypeId
     *            in the source academic year
     * @param targetStudyGradeTypeId
     *            in the target academic year
     */
    void transferFeesWithStudyGradeTypeId(@Param("sourceStudyGradeTypeId") int sourceStudyGradeTypeId, @Param("targetStudyGradeTypeId") int targetStudyGradeTypeId);

    /**
     * Transfer fees for academic years.
     * 
     * @return the id of the newly inserted fee
     */
    int transferAcademicYearFee(@Param("sourceFeeId") int sourceFeeId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * Transfer fees for subjects.
     */
    void transferSubjectFees(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * Transfer fees for subject blocks.
     */
    void transferSubjectBlockFees(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * @param studyGradeTypeId
     *            of the fee to delete and who wrote it
     */
    void deleteFeesForStudyGradeType(int studyGradeTypeId);

    List<Fee> findFeesForSubjectStudyGradeType(int subjectStudyGradeTypeId);

    /**
     * @param subjectStudyGradeTypeId
     *            of the fee to delete and who wrote it
     */
    void deleteFeesForSubjectStudyGradeType(int subjectStudyGradeTypeId);

    List<Fee> findFeesForSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId);

    /**
     * @param subjectBlockStudyGradeTypeId
     *            of the fee to delete and who wrote it
     */
    void deleteFeesForSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId);

    /**
     * 
     * @param map
     * @return
     */
    boolean existsFee(Map<String, Object> map);

}
