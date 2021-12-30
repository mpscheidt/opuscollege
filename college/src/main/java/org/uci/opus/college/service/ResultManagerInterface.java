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

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Authorization;
import org.uci.opus.college.domain.AuthorizationMap;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.ThesisResult;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.domain.result.IResultAttempt;
import org.uci.opus.college.domain.result.ResultPrivilegeFlags;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.result.TestResultComment;
import org.uci.opus.college.service.result.SubjectResultGenerator;

/**
 * @author move
 *
 */
public interface ResultManagerInterface {
    
    
    /**
     *  A precision or scale must be used for {@link BigDecimal#divide(BigDecimal)} operations, especially if the divisor is dynamic and unknown,
     *  otherwise the result may not be representable, e.g. the operation 1/3 will throw an {@link ArithmeticException}
     *  because it would need an unlimited number of digits.
     *  If the divisor is even (e.g. 100), the use of the precision/scale is not strictly necessary, since the result is representable.
     *  
     *  The precision set in the MathContext specifies the total number of digits, both left and right of the comma.
     *  The precision is set to 10, but may be altered if a different precision is seen more useful.
     */
    MathContext MC = new MathContext(10, RoundingMode.HALF_UP);

    /**
     * @param subjectResultId id of the SubjectResult
     * @return SubjectResult or null
     */
    SubjectResult findSubjectResult(final int subjectResultId);

    /**
     * @param params for a subjectResult except id of the SubjectResult
     * @return SubjectResult or null
     */
    SubjectResult findSubjectResultByParams(final Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists.
     * used to check if it is allowed to delete a subject 
     * @param params for a subjectResult except id of the SubjectResult
     * @return list of SubjectResults or null
     */
    List<SubjectResult> findSubjectResultsByParams(final Map<String, Object> map);
    
    /**
     * Calls {@link #findSubjectResultsByParams(Map)}.
     */
    List<SubjectResult> findSubjectResultsBySubjectIdAndStudyplanId(int subjectId, int studyPlanDetailId);
    
    /**
     * Find the newest subject result for the given parameters.
     * @return null if no subject result exists
     */
    SubjectResult findLatestSubjectResult(int studyPlanDetailId, int subjectId);

    /**
     * get the id's of the subjectResult combination if it exists.
     * used to check if it is allowed to delete a subject 
     * @param subjectId id of subject
     * @return list of id's
     */
    List<SubjectResult> findSubjectResults(final int subjectId);

    /**
     * @param studentId the id of the student to find subject results for
     * @return List of SubjectResult or null
     */   
    List<SubjectResult> findSubjectResultsForStudent(final int studentId);

    /**
     * @param map
     * @return List of SubjectResult or null
     */   
    List<SubjectResult> findSubjectResultsForStudent(Map<String, Object> map);

    /**
     * @param studyPlanId for a studyplan to find subjectresults for
     * @return List of SubjectResults or null
     */
    List<SubjectResult> findSubjectResultsForStudyPlan(final int studyPlanId);

    /**
     * Get the list of subjects that have been passed in any academic year by the given studyPlanId.
     * The subjects in the returned list only includes subjects with the given subjectIds.
     * @param studyPlanId
     * @param subjectIds
     * @param cardinalTimeUnitIdLessThan we expect that the order of the spctus is ascending over time,
     *           so that earlier ones have a lower id (attention with data migration from other systems)
     * @return
     */
    List<Subject> findPassedSubjects(int studyPlanId, Collection<Integer> subjectIds, Integer cardinalTimeUnitIdLessThan);

    /**
     * @param studyPlanId and cardinaltimeunit for a studyplan to find a studyplancardinaltimeunit for
     * @return StudyPlanCardinalTimeUnit or null
     */
    StudyPlanCardinalTimeUnit findCalculatableStudyPlanCardinalTimeUnit(final Map<String, Object> map);

    /**
     * 
     * @param studyPlanId
     * @return
     */
    StudyPlanCardinalTimeUnit findMaxCalculatableStudyPlanCardinalTimeUnit(final int studyPlanId);

    /**
     * @param studyYearId for a studyYearId to find subjectresults for
     * @return List of SubjectResults or null
     */
//    List <  SubjectResult > findSubjectResultsForStudyYear(
//                        final int studyYearId);

    /**
     * @param studyPlanId for a studyplan to find subjectresults in studyyears for
     * @return List of SubjectResults or null
     */
//    List <  SubjectResult > findSubjectResultsForStudyYearsInStudyPlan(
//                        final int studyPlanId);

    /**
     * @param studyPlanId for a studyplan to find active subjectresults in studyyears for
     * @return List of SubjectResults or null
     */
//    List <  SubjectResult > findActiveSubjectResultsForStudyYearsInStudyPlan(
//                        final int studyPlanId);

    /**
     * get the id's of the subjectResult combination if it exists.
     * used to check if it is allowed to delete a subjectstudygradetype 
     * @param params subjectId and studyGradeTypeId
     * @return list of SubjectResults or null
     */
    List <  SubjectResult > findSubjectResultsForSubjectStudyGradeType(final Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists.
     * used to check if it is allowed to delete a subjectblockstudygradetype 
     * @param params subjectBlockId and studyGradeTypeId
     * @return list of SubjectResults or null
     */
    List <  SubjectResult > findSubjectResultsForSubjectBlockStudyGradeType(
    			final Map<String, Object> map);


    /**
     * get the id's of the examinationResult combination if it exists.
     * used to check if it is allowed to delete a subjectstudygradetype 
     * @param params subjectId and studyGradeTypeId
     * @return list of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubjectStudyGradeType(
    			final Map<String, Object> map);

    /**
     * get the id's of the examinationResult combination if it exists.
     * used to check if it is allowed to delete a subjectblockstudygradetype 
     * @param params subjectBlockId and studyGradeTypeId
     * @return list of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubjectBlockStudyGradeType(
                    final Map<String, Object> map);

    /**
     * get the id's of the TestResult combination if it exists.
     * used to check if it is allowed to delete a subjectstudygradetype 
     * @param params subjectId and studyGradeTypeId
     * @return list of TestResults or null
     */
    List <  TestResult > findTestResultsForSubjectStudyGradeType(final Map<String, Object> map);

    /**
     * get the id's of the TestResult combination if it exists.
     * used to check if it is allowed to delete a subjectblockstudygradetype 
     * @param params subjectBlockId and studyGradeTypeId
     * @return list of TestResults or null
     */
    List <  TestResult > findTestResultsForSubjectBlockStudyGradeType(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List<SubjectResult> findActiveSubjectResultsForCardinalTimeUnit(final Map<String, Object> map);

    /**
     * @param subjectBlockId for a subjectBlock to find subjectresults for
     * @return List of SubjectResults or null
     */
    List <  SubjectResult > findSubjectResultsForSubjectBlock(
                        final int subjectBlockId);

    /**
     * @param subjectBlockId for a subjectBlock to find examinationresults for
     * @return List of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubjectBlock(
                        final int subjectBlockId);


    /**
     * @param subjectSubjectBlockId for a subjectSubjectBlock to find subjectresults for
     * @return List of SubjectResults or null
     */
    List <  SubjectResult > findSubjectResultsForSubjectSubjectBlock(
                        final int subjectSubjectBlockId);

    /**
     * @param subjectSubjectBlockId for a subjectSubjectBlock to find examinationresults for
     * @return List of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubjectSubjectBlock(
                        final int subjectSubjectBlockId);
    
    /**
     * @param subjectBlockSubjectBlockId for a subjectBlockSubjectBlock to find subjectresults for
     * @return List of SubjectResults or null
     */
    List <  SubjectResult > findSubjectResultsForSubjectBlockSubjectBlock(
                        final int subjectBlockSubjectBlockId);

    /**
     * @param subjectBlockSubjectBlockId for a subjectBlockSubjectBlock to find examinationresults for
     * @return List of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubjectBlockSubjectBlock(
                        final int subjectBlockSubjectBlockId);

    /**
     * Add subjectResult if new, or update subjectResult if mark or staff member has changed.
     * Only if modified, determine passed and endGradeComment, which are expensive operations.
     * @param request
     * @param subjectResult
     * @param subjectResultInDB
     * @param academicYearId
     * @param subjectResultGenerator TODO
     */
    void saveSubjectResultIfModified(HttpServletRequest request, SubjectResult subjectResult, SubjectResult subjectResultInDB, int academicYearId, SubjectResultGenerator subjectResultGenerator);

    /**
     * Add result if new, or update result if mark or staff member has changed.
     * Only if modified, determine passed, which is an expensive operations.
     * @param request
     * @param result
     * @param resultInDB
     */
    void saveResultIfModified(HttpServletRequest request, IResult result, IResult resultInDB);

    /**
     * Generic save method for subject/examination/test result, which forwards to the specific add method.
     * @param result
     * @param request
     */
    void addResult(IResult result, HttpServletRequest request);

    /**
     * @param subjectResult the subjectResult to add
     * @param request
     */
    void addSubjectResult(final SubjectResult subjectResult, HttpServletRequest request);

    /**
     * Generic update method for subject/examination/test result, which forwards to the specific update method.
     * @param result
     * @param request
     */
    void updateResult(final IResult result, HttpServletRequest request);

    /**
     * @param subjectResult the subjectResult to update
     * @param request
     * @return 
     */
    void updateSubjectResult(final SubjectResult subjectResult, HttpServletRequest request);
    
    /**
     * @param subjectResultId id of the subjectResult
     * @param writeWho
     * @return
     */
    void deleteSubjectResult(final int subjectResultId, String writeWho);


    /**
     * @param id id of the ExaminationResult
     * @return ExaminationResult or null
     */
    ExaminationResult findExaminationResult(final int id);

    /**
     * @param params for a ExaminationResult except id of the ExaminationResult
     * @return ExaminationResult or null
     */
    ExaminationResult findExaminationResultByParams(final Map<String, Object> map);

    /**
     * Find the result of a given examination.
     * @param examinationId id of the examination
     * @return List of examinationResults or null
     */
    List <  ExaminationResult > findExaminationResults(final int examinationId);

    /**
     * Find the result of a given examination.
     * @param map with paramaters
     * @return List of examinationResults or null
     */
    List <  ExaminationResult > findExaminationResultsByParams(final Map<String, Object> map);

    /**
     * Calls {@link #findExaminationResultsByParams(Map)}
     */
    List <  ExaminationResult > findExaminationResultsByExaminationIdAndStudyPlanId(int examinationId, int studyPlanId);

    /**
     * get the specified examinationResult combinations.
     * @param examinationId and academicYear
     * @return list of ExaminationResults or null
     */
    List < ExaminationResult > findExaminationResultsForAcademicYear(final Map<String, Object> map);


    /**
     * Find the examination results of a subject.
     * @param subjectId id of the subject
     * @return List of examinationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForSubject(final int subjectId);

    /**
     * @param params id of the subject and of the studyplandetail
     * @return List of examinationResults or null
     */
    List<ExaminationResult> findExaminationResultsForStudyPlanDetail(final Map<String, Object> map);

    /**
     * 
     * @param subjectId
     * @param studyPlanDetailId
     * @return
     */
    List<ExaminationResult> findExaminationResultsForSubject(int subjectId, final int studyPlanDetailId);
    
    /**
     * @param params id of the subject and of the studyplandetail
     * @return List of examinationResults or null
     */
    List <  ExaminationResult > findActiveExaminationResultsForSubjectResult(
                            final Map<String, Object> map);

    /**
     * @param params id of the examinationResult and of the studyplandetail
     * @return List of testResults or null
     */
    List < TestResult > findTestResultsForStudyPlanDetail(
                final Map<String, Object> map);

    /**
     * @param params id of the examinationResult and of the studyplandetail
     * @return List of testResults or null
     */
    List < TestResult > findActiveTestResultsForExaminationResult(
                final Map<String, Object> map);

    /**
     * @param testResultId id of the TestResult
     * @return TestResult or null
     */
    TestResult findTestResult(final int testResultId);

    /**
     * Find the result of a given test.
     * @param testId id of the test
     * @return List of testResults or null
     */
    List <  TestResult > findTestResults(final int testId);

    /**
     * Find the result of a given test.
     * @param map with parameters
     * @return List of testResults or null
     */
    List<TestResult> findTestResultsByParams(final Map<String, Object> map);

    /**
     * Calls {@link #findTestResultsByParams(Map)}.
     */
    List<TestResult> findTestResultsByTestIdAndStudyPlanId(int testId, int studyPlanId);

    /**
     * 
     * @param studyPlanDetailId
     * @return
     */
    List<TestResult> findTestResultsForExamination(int examinationId, int studyPlanDetailId);
    
    /**
     * @param testResult the testResult to add
     * @param request
     */
    void addTestResult(final TestResult testResult, HttpServletRequest request);
    
    /**
     * @param testResult the testResult to update
     * @param request
     * @return 
     */
    void updateTestResult(final TestResult testResult, HttpServletRequest request);

    /**
     * @param testResultId id of the testResult
     * @param writeWho
     * @return
     */
    void deleteTestResult(final int testResultId, final String writeWho);

    
    /**
     * @param studyPlanId for a studyplan to find examinationresults for
     * @return List of ExaminationResults or null
     */
    List <  ExaminationResult > findExaminationResultsForStudyPlan(final int studyPlanId);

    /**
     * @param examinationResult the examinationResult to add
     * @param request
     */
    void addExaminationResult(final ExaminationResult examinationResult, HttpServletRequest request);
    
    /**
     * @param examinationResult the examinationResult to update
     * @param request
     * @return 
     */
    void updateExaminationResult(final ExaminationResult examinationResult, HttpServletRequest request);
    
    /**
     * @param  the id of the examinationResult
     * @param writeWho
     * @return
     */
    void deleteExaminationResult(final int id, String writeWho);

    /**
     * @param StudyPlanResultId of the StudyPlanResult
     * @return StudyPlanResult or null
     */
    StudyPlanResult findStudyPlanResult(final int studyPlanResultId);

    /**
     * @param thesisResultId of the ThesisResult
     * @return ThesisResult or null
     */
    ThesisResult findThesisResult(final int thesisResultId);

    /**
     * @param thesisId of the ThesisResult
     * @return ThesisResult or null
     */
    ThesisResult findThesisResultByThesisId(final int thesisId);

    /**
     * Find cardinalTimeUnitResults of a Student.
     * @param map with studentId id + active of Student
     * @return list of cardinalTimeUnitResults or null
     */    
    List<CardinalTimeUnitResult> findCardinalTimeUnitResultsForStudent(final Map<String, Object> map);

    /**
     * Find cardinalTimeUnitResults of a Studyplan.
     * @param map with studyPlanId
     * @return list of cardinalTimeUnitResults or null
     */    
    List <  CardinalTimeUnitResult > findCardinalTimeUnitResultsForStudyPlan(
    		final int studyPlanId);

    /**
     * @param cardinalTimeUnitResultId of the cardinalTimeUnitResult
     * @return CardinalTimeUnitResult or null
     */
    CardinalTimeUnitResult findCardinalTimeUnitResult(final int cardinalTimeUnitResultId);

    /**
     * @param hashmap with a number of params
     * @return CardinalTimeUnitResult or null
     */
    CardinalTimeUnitResult findCardinalTimeUnitResultByParams(final Map<String, Object> ctuMap);

    /**
     * @param map params for a StudyPlanResult except id of the StudyPlanResult
     * @return List of StudyPlanResults or null
     */
    StudyPlanResult findStudyPlanResultByParams(final Map<String, Object> map);

    /**
     * @param map params for a list of subjectresults within a StudyPlan
     * @return List of SubjectResults or null
     */
    List < SubjectResult> findSubjectResultsForStudyPlanByParams(final Map<String, Object> map);

    /**
     * @param map params for a list of examinationresults within a StudyPlan
     * @return List of ExaminationResults or null
     */
    List < ExaminationResult> findExaminationResultsForStudyPlanByParams(final Map<String, Object> map);


    /**
     * @param studyPlanId for a StudyPlanResult except id of the StudyPlanResult
     * @return StudyPlanResult or null
     */
    StudyPlanResult findStudyPlanResultByStudyPlanId(final int studyPlanId);

    /**
     * @param studyPlanDetailId for an ExaminationResult
     * @param examinationId
     * @param preferredLanguage for a user
     * @param result
     * @return mark of the examinationResult
     */
    String generateExaminationResultMark(final int studyPlanDetailId
                ,int examinationId, final String preferredLanguage
                , BindingResult result);

    /**
     * Calculate the subject result for the given parameters.
     * Both studyPlanDetailId and subjectId need to be given, since in the case of subject blocks
     * the studyPlanDetailId is not sufficient.
     * @param studyPlanDetailId
     * @param subjectId
     * @param preferredLanguage
     * @param result
     * @return TODO
     * @return mark of the subjectResult
     */
    SubjectResultGenerator generateSubjectResultMark(SubjectResult subjectResult, String preferredLanguage, BindingResult result);

    /**
     * @param preferredLanguage for a user
     * @param currentLoc to be able to make messages
     * @param endGradeType to define the type of StudyPlanResult (bachelor, master, diploma, etc.)
     * @param academicYearId
     * @param errors
     * @param studyplanresult for generation of a studyPlanMark
     * @return studyplanresult with updated studyPlanMark
     */
    StudyPlanResult generateStudyPlanMark(final StudyPlanResult studyPlanResult, 
    		final String preferredLanguage, final Locale currentLoc, 
    		final String endGradeType, int academicYearId, Errors errors);

    /**
     * @param preferredLanguage for a user
     * @param academicYearId
     * @param studyplanresult for defining if the result is passed
     * @param endGradeType to define the type of StudyPlanResult (bachelor, master, diploma, etc.)
     * @return Y/N if passed the studyPlanResult
     */
    String isPassedStudyPlanResult(final StudyPlanResult studyPlanResult, String preferredLanguage,
    		final String endGradeTyp, int academicYearId);

    /**
     * @param studyPlanId of the studyplan for the studyplanresult
     * @param preferredLanguage for a user
     * @param academicYearid
     * @param thesis for a StudyPlanResult
     * @param endGradeType to define the type of thesis (bachelor, master, diploma, etc.)
     * @return Y/N if passed the thesis
     * 
     */
    String isPassedThesisResult(final int studyPlanId,
    		final ThesisResult thesisResult, String preferredLanguage,
    		final String endGradeTypeCode, int academicYearid);

    /**
     * @param cardinalTimeUnitResult
     * @param preferredLanguage for a user
     * @param currentLoc to be able to make messages
     * @param errors
     */
    void generateCardinalTimeUnitMark(
    		final CardinalTimeUnitResult cardinalTimeUnitResult, 
    		String preferredLanguage, final Locale currentLoc, Errors errors);

    /**
     * @param cardinalTimeUnitResult for an CardinalTimeUnitResult
     * @param preferredLanguage for a user
     * @return Y/N if passed the cardinalTimeUnitResult
     */
    String isPassedCardinalTimeUnitResult(final int studyPlanCardinalTimeUnitId,
    		final CardinalTimeUnitResult cardinalTimeUnitResult,
    		String preferredLanguage, final String endGradeTypeCode);

    /**
     * Forwards to the respective method that tests if subject, examination or test has been passed.
     * 
     * @param result
     * @param resultMark
     * @param preferredLanguage
     * @return
     */
    String isPassedResult(IResult result, String resultMark, String preferredLanguage);

    /**
     * @param subjectResult for a SubjectResult
     * @param preferredLanguage for a user
     * @param subjectResultGenerator TODO
     * @return mark of the SubjectResult
     */
    String isPassedSubjectResult(final SubjectResult subjectResult, 
            final String subjectResultMark, String preferredLanguage,
            final String endGradeTypeCode, SubjectResultGenerator subjectResultGenerator);

    /**
     * @param examinationResult for an ExaminationResult
     * @return mark of the examinationResult
     * @param preferredLanguage for a user
     */
    String isPassedExaminationResult(final ExaminationResult examinationResult, final String examinationResultMark, String preferredLanguage);

    /**
     * @param testResult for a TestResult
     * @return mark of the testResult
     * @param preferredLanguage for a user
     */
    String isPassedTestResult(final TestResult testResult, final String testResultMark, String preferredLanguage);

    /**
     * @param writeWho
     * @param exam the StudyPlanResult to add
     */
    void addStudyPlanResult(final StudyPlanResult studyPlanResult, String writeWho);
    
    /**
     * @param writeWho
     * @param StudyPlanResult the StudyPlanResult to update
     * @return 
     */
    void updateStudyPlanResult(final StudyPlanResult studyPlanResult, String writeWho);
    
    /**
     * @param writeWho
     * @param StudyPlanResultId id of the StudyPlanResult
     * @return
     */
    void deleteStudyPlanResult(final int studyPlanResultId, String writeWho);

    /**
     * @param cardinalTimeUnitResult the CardinalTimeUnitResult to add
     * @param writeWho
     */
    void addCardinalTimeUnitResult(final CardinalTimeUnitResult cardinalTimeUnitResult, String writeWho);
    
    /**
     * @param cardinalTimeUnitResult the CardinalTimeUnitResult to update
     * @param writeWho
     * @return 
     */
    void updateCardinalTimeUnitResult(final CardinalTimeUnitResult cardinalTimeUnitResult, String writeWho);
    
    /**
     * @param cardinalTimeUnitResultId id of the CardinalTimeUnitResult
     * @return
     */
    void deleteCardinalTimeUnitResult(final int cardinalTimeUnitResultId, final String writeWho);

    /**
     * @param ThesisResult the ThesisResult to add
     */
    void addThesisResult(final ThesisResult thesisResult);
    
    /**
     * @param ThesisResult the ThesisResult to update
     * @return 
     */
    void updateThesisResult(final ThesisResult thesisResult);
    
    /**
     * @param writeWho
     * @param id id of the ThesisResult
     * @return
     */
    void deleteThesisResult(final int thesisResult, String writeWho);

    /**
     *Finds academic years which have at least a student assigned 
     * @param map
     * @return
     */
    List<AcademicYear> findAcademicYearsInStudyPlan(Map<String , Object> map);
    
    /** 
     * method to hierarchically find the appropriate business rules for a subject
     * @param number of objects
     * @return String with businessrules
     */
	String getBusinessRulesForPassingStudyPlan(final StudyPlan studyPlan,
			final List < ? extends EndGrade > allEndGrades, final Study study, 
			final String endGradeTypeCode);

	/**
	 * Determine the lowest possible percentage with which to pass, given the list of end grades.
	 * The lowest possible percentage is the lowest percentageMin of all endgrades with <code>pass</code> equal to 'Y'.
	 * <br>
	 * Note: no additional DB operations needed.
	 * @param allEndGrades
	 * @return
	 */
	BigDecimal getLowestPassPercentage(final List<? extends EndGrade> allEndGrades);

	/** 
     * method to hierarchically find the appropriate business rules for a subject
     * @param number of objects
     * @return String with businessrules
     */
	String getBusinessRulesForPassingStudyGradeType(final Study study,
			final StudyGradeType studyGradeType, 
			final List < ? extends EndGrade > allEndGrades);

	/** 
     * method to find the appropriate business rules for a subject through studygradetype
     * @param number of objects
     * @return String with businessrules
     */
	String getBRsPassingSubjectForStudyGradeType(final Map<String, Object> map);

	
	
    /** 
     * method to calculate the gradepoint based on the mark
     * @param mark
     * @param endGradeTypeCode
     * @param preferredLanguage
     * @param academicYearId
     * @return gradePoint
     */
// 	BigDecimal calculateGradePointForMark(
// 			final String mark, final String endGradeTypeCode, final String preferredLanguage, int academicYearId);

    /** 
     * method to calculate the endGrade based on the mark
     * @param mark
     * @param endGradeTypeCode
     * @param preferredLanguage
     * @param academicYearId
     * @return endGrade
     */
    EndGrade calculateEndGradeForMark(final String mark, final String endGradeTypeCode, final String preferredLanguage, int academicYearId);

    /** 
     * public method to calculate the total credit amount for a specific cardinal time unit
     *  @param allSubjectsForCardinalTimeUnit
     *  @return creditamount
     */
    BigDecimal getCreditAmountForCardinalTimeUnitNumber(
    		final List <Subject> allSubjectsForCardinalTimeUnit);

 	/** 
     *  public method to find only those subjectresults for a specific studyplan
     * 	that should be calculated (e.g. most recent academicYearId 
     *  combined with a number of subjects to count)
     *  @param allStudyPlanDetailsFromList
     *  @param allSubjectsFromList
     *  @param studyPlan
     *  @param afterExclude if true, only consider the subjectResults after the student has come back from being excluded
     *  @return list of subjectresults
     */
    public List < SubjectResult > findCalculatableSubjectResultsForStudyPlan(
    		List < StudyPlanDetail > allStudyPlanDetailsFromList,
    		List < Subject > allSubjectsFromList, StudyPlan studyPlan, boolean afterExclude);
    	


    /** 
     *  public method to find only those subjects for a specific studyplan
     * 	that should be calculated (e.g. most recent academicYearId 
     *  combined with a number of subjects to count)
     *  @param allEndGrades
     *  @param studyPlan
     *  @param subjectResultsForStudyPlan
     *  @param numberOfSubjectsToCount
     *  @return list of subjects
     */
    public List < Subject > findSpecificNumberOfCalculatableSubjectsForStudyPlan(
    		final List < ? extends EndGrade > allEndGrades, 
    		final StudyPlan studyPlan,
    		final List < SubjectResult > subjectResultsForStudyPlan, 
    		final int numberOfSubjectsToCount);

    /**
     * Find those subjects for the senior years in a specific studyplan that
     * should be calculated.
     * 
     * 2013-06-14 MP: If program has less time than indicated by numberOfYearsToCount,
     * simply count all years, otherwise shorter programs with one or two years may not be calculated at all.
     * 
     * @param preferredLanguage
     * @param studyPlan
     * @param numberOfYearsToCount
     * @return list of subjects
     */
    public List < Subject > findCalculatableSubjectsForStudyPlan(
    		String preferredLanguage, StudyPlan studyPlan,
    		String numberOfYearsToCount);

    /** 
     * public method to find only those subjectresults for a specific ctu list
     * 	that should be calculated (e.g. most recent academicYearId)
     * 
     */
    public List < SubjectResult > findCalculatableSubjectResultsForCardinalTimeUnit(
    		final List < StudyPlanDetail > allStudyPlanDetailsFromList, final Map<String, Object> map);

    
    /** 
     * method to calculate the subjectresults for one cardinaltimeunit
     * @param study
     * @param cardinalTimeUnitResult
     * @param subjectResults
     * @param allSubjectsForCardinalTimeUnit
     * @param brsPassingSubjectDouble
     * @param preferredLanguage
     * @param currentLoc
     * @param errors
     * @return endGradeComment
     */
 	String calculateSubjectResultsForCardinalTimeUnit(final Study study, 
 			CardinalTimeUnitResult cardinalTimeUnitResult,
 			final List <SubjectResult > subjectResults,
 			final List <Subject> allSubjectsForCardinalTimeUnit,
            final BigDecimal brsPassingSubjectDouble,
            final String preferredLanguage,
            final Locale currentLoc, Errors errors);
 	

 	/**
 	 * The returned map has a key of studyPlanCardinalTimeUnitId - not cardinalTimeUnitId -
 	 * because the cardinalTimeUnitResult may not exist yet, so the create privilege can not be associated
 	 * with a non-existing cardinalTimeUnitResult, but only with the studyPlanCardinalTimeUnit.
 	 * @param request
 	 * @param cardinalTimeUnitResults
 	 * @return map studyPlanCardinalTimeUnitId -> Authorization object
 	 */
 	Map<Integer, Authorization> determineAuthorizationForCardinalTimeUnitResults(final List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits, final HttpServletRequest request);

 	Authorization determineAuthorizationForCardinalTimeUnitResult(final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, final HttpServletRequest request);

 	/**
 	 * Get a map that points to Authorization objects.
 	 * The key of the map is a string "studyPlanDetailId-subjectId" (the two ids separated by a dash).
 	 * @param allStudyPlanDetails
 	 * @param allStudyPlanCardinalTimeUnits the studyPlanCardinalTimeUnit.resultsPublished flag is expected to be set correctly.
 	 * @param subjectResults
 	 * @param request
 	 * @return
 	 */
 	AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForSubjectResults(List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, final List<SubjectResult> subjectResults, final HttpServletRequest request);

 	// for one subject only
 	AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForSubjectResults(Subject subject, List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, final List<SubjectResult> subjectResults, final HttpServletRequest request);

 	/**
 	 * 
 	 * @param studyPlanDetail
 	 * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit.resultsPublished flag is expected to be set correctly.
 	 * @param result
 	 * @param subjectExamTest
 	 * @param resultPrivilegeFlags
 	 * @return
 	 */
 	<T extends ISubjectExamTest> AuthorizationSubExTest determineAuthorizationForSubExTestResult(StudyPlanDetail studyPlanDetail, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, final IResult result,
            final T subjectExamTest, final ResultPrivilegeFlags<T> resultPrivilegeFlags);

 	/**
 	 * Calls {@link #determineAuthorizationForSubExTestResult(StudyPlanDetail, StudyPlanCardinalTimeUnit, IResult, ISubjectExamTest, HttpServletRequest)}
 	 * and performs additional checks.
 	 * @param studyPlanDetail
 	 * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit.resultsPublished flag is expected to be set correctly.
 	 * @param resultAttempts
 	 * @param resultAttempt
 	 * @param subjectExamTest
 	 * @param resultPrivilegeFlags
 	 * @return
 	 */
 	<T extends ISubjectExamTest> AuthorizationSubExTest determineAuthorizationForMultipleAttemptResult(StudyPlanDetail studyPlanDetail, StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, final List<? extends IResultAttempt> resultAttempts, final IResultAttempt resultAttempt,
            final T subjectExamTest, final ResultPrivilegeFlags<T> resultPrivilegeFlags);

 	/**
 	 * Get a map that points to Authorization objects.
     * The key of the map is a string "studyPlanDetailId-examinationId-attemptNr" (the values separated by a dash).
     * This method calls {@link #determineAuthorizationForMultipleAttemptResult(StudyPlanDetail, StudyPlanCardinalTimeUnit, List, IResultAttempt, ISubjectExamTest, ResultPrivilegeFlags)}.
 	 * @param allStudyPlanDetails
 	 * @param allStudyPlanCardinalTimeUnits the studyPlanCardinalTimeUnit.resultsPublished flag is expected to be set correctly.
 	 * @param resultAttempts
 	 * @param request
 	 * @return
 	 */
 	AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForExaminationResults(List<StudyPlanDetail> allStudyPlanDetails,
 	        List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, final List<ExaminationResult> resultAttempts, final HttpServletRequest request);

 	// limit to single examination, avoid loading all subjects and examinations for given studyplandetails
    AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForExaminationResults(Examination examination, List<StudyPlanDetail> allStudyPlanDetails,
            List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, List<ExaminationResult> resultAttempts, HttpServletRequest request);

 	
 	/**
     * Get a map that points to Authorization objects.
     * The key of the map is a string "studyPlanDetailId-testId-attemptNr" (the values separated by a dash).
     * This method calls {@link #determineAuthorizationForMultipleAttemptResult(StudyPlanDetail, StudyPlanCardinalTimeUnit, List, IResultAttempt, ISubjectExamTest, ResultPrivilegeFlags)}.
 	 * @param allStudyPlanDetails
 	 * @param allStudyPlanCardinalTimeUnits
 	 * @param resultAttempts
 	 * @param request
 	 * @return
 	 */
 	AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForTestResults(List<StudyPlanDetail> allStudyPlanDetails,
 	        List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, final List<TestResult> resultAttempts, final HttpServletRequest request);

 	// limit to single test, avoid loading all subjects, examinations and tests for given studyplandetails
 	AuthorizationMap<AuthorizationSubExTest> determineAuthorizationForTestResults(Test test, List<StudyPlanDetail> allStudyPlanDetails,
 	        List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits, final List<TestResult> resultAttempts, final HttpServletRequest request);


 	/**
 	 * 
 	 * @param result
 	 * @param authorizationMap
 	 * @return
 	 */
 	boolean hasDeleteAuthorization(IResult result, Map<String, ? extends Authorization> authorizationMap);

 	/**
 	 * Assert that the currently logged in user has the delete authorization for the given result.
 	 * If not, a log entry is written to the security log and a security exception is thrown.
 	 * @param result
 	 * @param authorizationMap
 	 * @param user
 	 */
 	void assertDeleteAuthorization(IResult result, Map<String, ? extends Authorization> authorizationMap, String user);

 	/**
 	 * 
 	 * @param cardinalTimeUnitResult
 	 * @param request
 	 */
 	void assertDeleteAuthorization(CardinalTimeUnitResult cardinalTimeUnitResult, HttpServletRequest request);

 	/**
 	 * Determine for every element in the assessment structure, i.e. subject, its examinations and tests, if read access is to be granted to the results
 	 * @param request
 	 * @param subject
 	 * @return
 	 */
 	AssessmentStructurePrivilege determineReadPrivilegesForAssessmentStructure(HttpServletRequest request, Subject subject);
 	
 	/** 
     * method to calculate the authorization for a list of studyplandetails and their subjectresults
     * @param allStudyPlanDetails
     * @param allSubjectResults
     * @param allWriteableSubjects
     * @param allWriteableSubjectBlocks
     * @param opusUser
     * @param staffMember
     * @param student
     * @param request
     * @return list of subjectresults, enriched with authorization information
     */
// 	List<SubjectResult> calculateAuthorizationForSubjectResults(
//    		final List <StudyPlanDetail> allStudyPlanDetails,
//    		final List <SubjectResult > allSubjectResults,
//            final List <Subject> allWriteableSubjects,
//            final List <SubjectBlock> allWriteableSubjectBlocks,
//            final OpusUser opusUser,
//            final StaffMember staffMember,
//            final Student student,
//            HttpServletRequest request);

    /**
     * For continued registration BA/BSC the cut-off point is a desired max total 
     * of all subject gradepoints in a studyplancardinaltimeunit
	 * So for a number of 4 counted subject gradepoints the highest cut-offpoint would be
	 *       (maximumgradepoint * numberOfSubjects)
	 *       (     1       *         4     		= 4)
     * @param studyPlan
     * @param allSubjects
     * @param allSubjectResults
     * @param cutOffPointTotal
     * @param numberOfSubjectsPerCardinalTimeUnit
     * @param gradeTypeCode
     * @param preferredLanguage
     * @param gender
     * @param cntdRegistrationBachelorCutOffPointCreditFemale
     * @param cntdRegistrationBachelorCutOffPointCreditMale
     * @return true or false
	 */
//	public boolean passCutOffPointContinuedRegistrationBachelor(
//			StudyPlan studyPlan,
//			List<? extends Subject> subjects, List<? extends SubjectResult> subjectResults,
//			float cutOffPointTotal, int numberOfSubjectsPerCardinalTimeUnit, 
//			String gradeTypeCode, String preferredLanguage, String gender,
//			float cntdRegistrationBachelorCutOffPointCreditFemale, float cntdRegistrationBachelorCutOffPointCreditMale);

    /**
     * For continued registration MA/MSC/Master ... the cut-off point is an average: 
     * We want to scale the cutoffpoint so we can compare all maximum gradepoints.
     * For example: we have grades from 6 (maximumGrade) to 0 (minimumGrade) and the cutoffpoint is 3.6. 
     * Master asks for average score, not total, but credit amount per subject must be balanced
     * for example with a total weight of 24 for 4 subjects: 
     * So we scale by dividing: 108 / 24 = 4.5
     * @param studyPlan
     * @param allSubjects
     * @param allSubjectResults
     * @param cutOffPointTotal
     * @param numberOfSubjectsPerCardinalTimeUnit
     * @param gradeTypeCode
     * @param preferredLanguage
     * @param gender
     * @param cntdRegistrationMasterCutOffPointCreditFemale
     * @param cntdRegistrationMasterCutOffPointCreditMale
     * @return true or false
	 */
	public boolean passCutOffPointContinuedRegistrationMaster(
			StudyPlan studyPlan,
			List<? extends Subject> subjects, List<? extends SubjectResult> subjectResults,
			BigDecimal cutOffPointTotal, int numberOfSubjectsPerCardinalTimeUnit, 
			String gradeTypeCode, String preferredLanguage, String gender,
			BigDecimal cntdRegistrationMasterCutOffPointCreditFemale, BigDecimal cntdRegistrationMasterCutOffPointCreditMale);

    /**
     * to calculate the progress status for a studyplancardinaltimeunit
     * based on business rules for a university or country
     * @param studyPlanCardinalTimeUnit 
     * @param preferredLanguage
     * @param currentLoc 
     * @return studyplancardinaltimeunit
     */
    public StudyPlanCardinalTimeUnit calculateProgressStatusForStudyPlanCardinalTimeUnit (
            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit,
            final String preferredLanguage, 
            Locale currentLoc);

    /**
     * Get the number of different subjects of the given subjectResults
     * @param subjectResults
     * @return
     */
    int getNumberOfDifferentSubjects(Collection<SubjectResult> subjectResults);

    /**
     * 
     * @param endGradesPerGradeType
     * @param study
     * @return
     */
    String getMinimumMarkValue(boolean endGradesPerGradeType, Study study);

    /**
     * 
     * @param endGradesPerGradeType
     * @param study
     * @return
     */
    String getMaximumMarkValue(boolean endGradesPerGradeType, Study study);

    /**
     * 
     * @param map
     * @return
     */
    List<ExaminationResultComment> findExaminationResultComments(Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List<TestResultComment> findTestResultComments(Map<String, Object> map);

}
