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
package org.uci.opus.fee.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.FeeDeadline;

/**
 * @author move
 *
 */
public interface FeeManagerInterface {
    
    /**
     * Returns a list of fees on studyyear level by their study-id.
     * @param studyId id of the fees to find
     * @return List of fee-objects or null
     */    
//    List <? extends Fee > findFeesForStudyYears(int studyId);

    /**
     * Returns a list of fees on subject block level by their study-id.
     * @param studyId id of the fees to find
     * @return List of Fee-objects or null
     */    
    List <? extends Fee > findFeesForSubjectBlockStudyGradeTypes(int studyId);

    /**
     * Returns a list of fees on subject level by their study-id.
     * @param studyId id of the fees to find
     * @return List of Fee-objects or null
     */    
    List <? extends Fee > findFeesForSubjectStudyGradeTypes(int studyId);

    /**
     * Returns fee by its id.
     * @param feeId id of the fee to find
     * @return Fee-object or null
     */    
    Fee findFee(int feeId);
    
    
    /**
     * The BalanceBroughtForward (BBFwd) is a special kind of fee. The amount is exclusive to every
     * student, so it cannot be stored in the fee itself. It is stored in the appliedFee.amount.
     * There is just one general fee for BBFwd because we need to determine the feeCategory.
     * This method gets the feeId of the fee that is linked to the feeCategory BBFwd.
     * @param categoryCode code of the feeCategory BBFwd
     * @param language preferredLanguage of user
     * @return the feeId of the fee linked to the feeCategory BBFwd
     */
    int findFeeIdByCategoryCode(String categoryCode, String language);
    
    /**
     * The Fee Cancellation is a special kind of fee. It can be used to expunge the fee of
     * a specific student and is always exclusive to one student, so it cannot be stored in
     * the fee itself. It is stored in the appliedFee.amount.
     * There is just one general fee for Fee Cancellation because we need to determine the
     * feeCategory. This method gets the feeId of the fee that is linked to the feeCategory
     * Fee Cancellation.
     * @param categoryCode code of the feeCategory Fee Cancellation
     * @param language preferredLanguage of user
     * @return the feeId of the fee linked to the feeCategory Fee Cancellation
     */
//    int findFeeIdOfCancellation(String categoryCode, String language);
    
    List < Fee > findFeesForEducationAreas(HashMap<String, Object> map);
    
    /** 
     * Returns a list of all fees.
     * @return List of Fee-objects or null
     */    
    List <? extends Fee > findAllFees();
    /**
     * Returns fee by its subjectblockid/subjectid.
     * @param map subjectblockid/subjectid of the fee to find
     * @return Fee-object or null
     */    
    Fee findFeeByStudyIds(Map<String, Object> map);

     /**
     * @param map with params
     * @return List of StudyYears or null
     */   
//    List < ? extends StudyYear > findStudyYearsWithoutFee(HashMap map);

    /**
     * @param map with params
     * @return List of SubjectStudyGradeTypes or null
     */   
    List < ? extends SubjectStudyGradeType > findSubjectStudyGradeTypesWithoutFee(Map<String, Object> map);

    /**
     * @param map with params
     * @return List of SubjectBlockStudyGradeTypes or null
     */   
    List < ? extends SubjectBlockStudyGradeType > findSubjectBlockStudyGradeTypesWithoutFee(Map<String, Object> map);


    /**
     * Returns a list of fees on studyyear level for a student.
     * @param studentId id of the fees to find
     * @return List of fee-objects or null
     */    
//    List <? extends Fee > findStudentFeesForStudyYears(int studentId);

    /**
     * Returns nothing.
     * @param fee the fee to add
     * @return
     */    
    void addFee(Fee fee);

    /**
     * Returns nothing.
     * @param fee the fee to update
     * @return
     */    
    void updateFee(Fee fee);

    /**
     * Returns nothing.
     * @param feeId of the fee to delete and who wrote it
     * @return
     */    
    void deleteFee(int feeId, String writeWho);

   /**
     * Returns nothing.
     * @param studyGradeTypeId of the fee to delete and who wrote it
     * @return
     */    
    void deleteFeesForStudyGradeType(int studyGradeTypeId, String writeWho);
   
    /**
     * Returns nothing.
     * @param subjectStudyGradeTypeId of the fee to delete and who wrote it
     * @return
     */    
    void deleteFeesForSubjectStudyGradeType(int subjectStudyGradeTypeId, String writeWho);

    /**
     * Returns nothing.
     * @param subjectBlockStudyGradeTypeId of the fee to delete and who wrote it
     * @return
     */    
    void deleteFeesForSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId, String writeWho);

    /**
     * Returns a list of fees by their academicYear/categoryCode for a given branch, excluding a given fee.
     * Used as a check in the FeeAcademicYearValidator
     * @param map academicYear/categoryCode and branchId of the fees to find + feeId of fee to exclude
     * @return list of Fee-objects or null
     */
    List < Fee > findFeeByAcademicYearAndCategoryCode(Map<String, Object> map);
    /**
     * Returns fee by studyGradeTypeId
     * @param map studyGradeTypeId/categoryCode of fee to find
     * @return Fee-object or null
     */
    Fee findFeeByStudyGradeTypeIdAndCategoryCode(Map<String, Object> map);
    /**
     * Returns a list of fees on study gradetype level by their study-id.
     * @param studyId id of the fees to find
     * @return List of Fee-objects or null
     */    
    List <? extends Fee > findFeesForStudyGradeTypes(int studyId);
    /**
     * Returns a list of fees on branch level.
     *  @param branchId id of the branch, the fees are linked to
     * @return List of Fee-objects or null
     */    
    List <? extends Fee > findFeesForBranch(int branchId);
    /**
     * Returns a list of fees on subject block study grade type level for a student.
     * @param studentId id of the fees to find
     * @return List of fee-objects or null
     */    
    List <? extends Fee > findStudentFeesForSubjectBlockStudyGradeTypes(int studentId);    
    /**
     * Returns a list of fees on subject study grade type level for a student.
     * @param studentId id of the fees to find
     * @return List of fee-objects or null
     */    
    List <? extends Fee > findStudentFeesForSubjectStudyGradeTypes(int studentId);    
    /**
     * Returns a list of fees on study grade type level for a student.
     * @param studentId id of the fees to find
     * @return List of fee-objects or null
     */    
    List <? extends Fee > findStudentFeesForStudyGradeTypes(int studentId);    
    /**
     * Returns a list of fees on academic year level for a student.
     * @param studentId id of the fees to find
     * @return List of fee-objects or null
     */    
    
    /**
     * Find all fees already linked to a student
     * @param studentId id of the student
     * @return a list of fees
     */
    List < Fee > findExistingFeesForStudent(int studentId);
    
    /**
     * Find all fees that are linked to subjects in a studyPlan
     * @param studyPlanId id of the studyPlan
     * @return a list of fees
     */
    List < Fee > findPossibleSubjectFeesForStudyPlan(int studyPlanId);
    
    /**
     * Find all fees that are linked to subjectblocks in a studyPlan
     * @param studyPlanId id of the studyPlan
     * @return a list of fees
     */
    List < Fee > findPossibleSubjectBlockFeesForStudyPlan(int studyPlanId);
    
    /**
     * Find all fees that are linked to studyGradeTypes in a studyPlan
     * @param studyPlanId id of the studyPlan
     * @return a list of fees
     */
    List < Fee > findPossibleStudyGradeTypeFeesForStudyPlan(int studyPlanId);
    
    /**
     * Find all fees based on area of education
     * @param map containing:
     *        studyPlanId
     *        maxAcademicYear: academicYear of the latest studyPlanCtu of the student
     *        language: preferredLanguage of the user
     * @return list of fees based on area of education
     */
    List < Fee > findPossibleEducationAreaFees(HashMap<String, Object> map);
    
    /**
     * In progress
     * Find all fees that are linked to the branch to which a studyPlan in belongs
     * The branch is found through study and orgnizational unit
     * @param studentId 
     * @return
     */
//    List < Fee > findPossibleBranchFeesForStudent(int studentId);
    
    List <? extends Fee > findStudentFeesForAcademicYears(int studentId);           
    /**
     * Returns a list of feeCategories not bound in fee for specific studygradetypeid.
     * @param studygradetypeId of the fee
     * @return List of feeCategory-objects or null
     */    
//    List <? extends FeeCategory > findFeeCategoriesWithoutFee(int studyGradeTypeId);
    
    /**
     * Find studyGradeTypes for which to add a fee
     * @param map with parameters studyId, preferredLanguage and categoryCode
     * @return List of StudyGradeTypes or null
     */  
    List <StudyGradeType> findStudyGradeTypesForFee(Map<String, Object> map);
    
    
    /*### FeeDeadLine ######*/

    boolean isRepeatedDeadline(FeeDeadline feeDeadline);
    List<Map<String,Object>> findFeeDeadlinesAsMaps(Map<String, Object> params);
    FeeDeadline findFeeDeadline(int id);
    List<FeeDeadline> findFeeDeadlines(Map<String, Object> params);
    List<FeeDeadline> findDeadlinesForFee(int feeId);
    void addFeeDeadline(FeeDeadline feeDeadline);
    void updateFeeDeadline(FeeDeadline feeDeadline);
    void deleteFeeDeadline(int id, String writeWho);

    /**
     * Find fees that match the given parameters.
     * @param params
     * @return
     */
    List<Fee> findFeesByParams(Map<String, Object> params);

    /**
     * Create studentBalances for subjects and subjectblocks
     * @param studyPlanDetail
     * @param writeWho TODO
     * @param studentId
     * @return the the list of created StudentBalances
     */    
    List < StudentBalance > createStudentBalances(StudyPlanDetail studyPlanDetail, 
            String writeWho);

    void updateAllStudentBalances(int studentId, String writeWho); 

    /**
     * Find studentbalances of a student.
     * @param studentId of student
     * @return list of studentbalances
     */    
    List < StudentBalance > findStudentBalances(int studentId);

      /**
     * Find studentbalances based on fees
     * @param feeId 
     * @return list of studentbalances
     */    
    List < StudentBalance > findStudentBalancesByFeeId(int feeId);

    /**
     * Returns nothing.
     * @param studyPlanDetailId of the studentBalances to delete
     * @return
     */    
    void deleteStudentBalancesByStudyPlanDetailId(int studyPlanDetailId, String writeWho);    
   
    /**
     * Returns nothing.
     * @param studyPlanCardinalTimeUnitId of the studentBalances to delete
     * @param writeWho TODO
     * @param writewho the user who deleted the records
     * @return
     */    
    void deleteStudentBalancesByStudyPlanCardinalTimeUnitId(int studyPlanCardinalTimeUnitId,
           String writeWho);    
    /**
     * Returns nothing.
     * @param studentId of the studentBalances to delete
     * @param writewho the user who deleted the records
     * @return
     */    
    void deleteStudentBalancesByStudentId(int studentId, String writeWho);    
    
    /**
     * Returns nothing.
     * @param feeId of the studentBalances to delete
     * @param writewho the user who deleted the records
     * @return
     */    
    void deleteStudentBalancesByFeeId(int feeId, String writeWho);       
    
     /**
      * Add a studentBalance.
      * @param studentBalance to add 
      */    
     void addStudentBalance(StudentBalance studentBalance);

     /**
      * Create studentBalances for a StudyPlanCardinalTimeUnit.
      * @param studyPlanCardinaTimeUnit
      * @param studentId
      * @param preferredLanguage
      * @param writeWho
      * @return the the list of created StudentBalances
      */    
     List < StudentBalance > createStudentBalances(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,int studentId, 
             String preferredLanguage, String writeWho);
    /**
      * Create studentBalances for fees on branches. The branch is derived from the organization
      * of the study of the studyPlan.
      * @param academicYearId
      * @param studyPlanId
      * @param studentId
      * @param preferredLanguage
      * @param writeWho
      * @return the the list of created StudentBalances on branches
      */    
//    List < StudentBalance > createStudentBalances(int academicYearId, int studyPlanId
//            , int studentId, String preferredLanguage, String writeWho);     
    /**
     * Create payment for current fee, reverse payment for older fee (subjects/subject blocks fees)
     * @param newStudentBalance
     * @param studyPlanDetail
     * @param studentId
     * @param currentStudyGradeTypeId
     * @param writeWho TODO
     * @param who
     */
    void createPaymentsForStudentBalance(StudentBalance newStudentBalance, StudyPlanDetail studyPlanDetail,int studentId,int currentStudyGradeTypeId, String writeWho);

    /**
     * Creates payment for current fee, reverse payment for older fee (studygradetypes)
     * @param newStudentBalance
     * @param currentStudyPlanCardinalTimeUnit
     * @param studentId
     * @param currentStudyGradeTypeId
     * @param writeWho TODO
     * @param who
     */
    void createPaymentsForStudentBalance(StudentBalance newStudentBalance, StudyPlanCardinalTimeUnit currentStudyPlanCardinalTimeUnit,int studentId,int currentStudyGradeTypeId, String writeWho);  

    /**
     * Creates payment for current fee, reverse payment for older fee (academicYears)
     * @param newStudentBalance
     * @param academicYearId
     * @param studentId
     * @param writeWho TODO
     */
    public void createPaymentsForStudentBalance(StudentBalance newStudentBalance, int academicYearId ,int studentId,String writeWho);

//     /**
//      * Returns a list of all fees.
//      * @return List of Fee-objects or null
//      */    
//     List <? extends Fee > findAllFees();

    /**
     * Update a StudentBalance.
     * @param studentBalance to update
     * @return
     */    
    void updateStudentBalance(StudentBalance studentBalance);
    
    /**
     * Find the fees applied to a specific student, including the studentBalanceId
     * @param studentId id of the student of whom to find the applied fees
     * @return list of applied fees
     */
    List < AppliedFee > findAppliedFeesForStudent(int studentId);
    
    /**
     * Find the appliedFee through the studentBalanceId
     * NOTE: appliedFee should replace studentBalance in the future completely
     * @param studentBalanceId id of the studentBalance/appliedFee
     * @return appliedFee
     */
    AppliedFee findAppliedFeeForStudentBalance(int studentBalanceId);
    
    /**
     * Find the fees applied to a specific student, including the discounted feeDue
     * , amount paid, studentBalanceId. This method calls findAppliedFeesForStudent
     * and enriches the appliedFees.
     * @param studentId id of the student of whom to find the applied fees
     * @param language preferred language of the user
     * @return list of applied fees
     */
    List < AppliedFee > getAppliedFeesForStudent(Student student, String language);
    
    /**
     * When transferring a student to the next cardinal time unit, the remainder or surplus of
     * the fees to be paid are calculated and stored in a special studentBalance called 
     * the BalanceBroughtForward
     * @param newStudyPlanCtu next studyPlanCardinalTimeUnit of the student
     * @param previousStudyPlanCtu the studyPlanCardinalTimeUnit the student has just finished
     * @param language preferred language of the user
     */
    BigDecimal calculateBalanceBroughtForward(StudyPlanCardinalTimeUnit newStudyPlanCtu
            , StudyPlanCardinalTimeUnit previousStudyPlanCtu, String language
            );


}
