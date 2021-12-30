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

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectCT;

/**
 * @author J. Nooitgedagt
 *
 */
public interface SubjectMapper {

    /**
     * @param map
     *            contains the following parameters: institutionId branchId organizationalUnitId
     *            studyId gradeTypeCode educationTypeCode The educationTypeCode is never empty, the
     *            other parameters are optional
     * @return a list of subjects
     */
    List<Subject> findSubjects(Map<String, Object> map);

    /**
     * Find all subjects with the primaryStudyId equal to the given parameter studyId
     * 
     * @param map
     *            contains: studyId to which the subjects are linked
     * @return list of subjects
     */
    List<Subject> findSubjectsByStudy(Map<String, Object> map);

    /**
     * @param subjectId
     *            id of subject to find
     * @return a subject
     */
    Subject findSubject(int subjectId);

    /**
     * Needed when a subject has just been inserted and you need to show it immediately. (in
     * subject.jsp): at that moment the id is not known yet Also needed because a subjectCode needs
     * to be unique within a given academic year
     * 
     * @param map
     *            containing a subjectCode and an academicYearId
     * @return a subject or null
     */
    Subject findSubjectByCode(Map<String, Object> map);

    /**
     * @param map
     *            parameters: subjectDescription, studyId and academicYearId
     * @return Subject or null
     */
    Subject findSubjectByDescriptionStudy(Map<String, Object> map);

    /**
     * @param map
     *            parameters: subjectDescription, studyId, subjectCode
     * @return Subject or null
     */
    Subject findSubjectByDescriptionStudyCode(Map<String, Object> map);

    Subject findSubjectByDescriptionStudyCode2(Map<String, Object> map);

    /**
     * @param subject
     *            to add
     */
    void addSubject(Subject subject);

    /**
     * @param subject
     *            to update
     */
    void updateSubject(Subject subject);

    /**
     * 
     * @param subjectId
     */
    void deleteSubjectStudyTypes(int subjectId);

    /**
     * 
     * @param subjectId
     */
    void deleteAllSubjectTeachers(int subjectId);

    /**
     * @param subjectId
     *            id of subject to delete
     */
    void deleteSubject(int subjectId);

    /**
     * find the primaryStudyId of a subject.
     * 
     * @param subjectId
     *            id of the subject of which to find the primaryStudyId
     * @return primaryStudyId
     */
    int findSubjectPrimaryStudyId(int subjectId);

    /**
     * @param subjectTeacherId
     *            id of teacher-subject combination to be found.
     * @return subjectTeacher object or null
     */
    SubjectTeacher findSubjectTeacher(int subjectTeacherId);

    /**
     * find all the teachers of a given subject.
     * 
     * @param subjectId
     *            id of subject, used to find a list of teachers
     * @return list of SubjectTeacher objects or null
     */
    List<SubjectTeacher> findSubjectTeachers(int subjectId);

    /**
     * @param subjectTeacher
     *            to add
     * @return
     */
    void addSubjectTeacher(SubjectTeacher subjectTeacher);

    /**
     * @param subjectTeacher
     *            id of teacher-subject combination to be updated.
     * @return
     */
    void updateSubjectTeacher(SubjectTeacher subjectTeacher);

    /**
     * @param subjectTeacherId
     *            id of teacher-subject combination to be removed
     */
    void deleteSubjectTeacher(int subjectTeacherId);

    /**
     * find a subjectStudyGradeType by its id and the user's preferred language.
     * 
     * @param map
     *            should contain the following parameters: subjectStudyGradeTypeId of the
     *            subjectStudyGradeType to find preferredLanguage of the user
     * @return a subjectStudyGradeType
     */
    SubjectStudyGradeType findSubjectStudyGradeType(Map<String, Object> map);

    /**
     * Find a plain object.
     * 
     * @param subjectStudyGradeTypeId
     * @return
     */
    SubjectStudyGradeType findPlainSubjectStudyGradeType(int subjectStudyGradeTypeId);

    /**
     * find the id of a subjectStudyGradeType by its subjectId and studyGradeTypeId. Needed when the
     * subjectStudyGradeType has just been inserted and the id is not known yet.
     * 
     * @param map
     *            containing subjectId and studyGradeTypeId
     * @return a subjectStudyGradeTypeId
     */
    Integer findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(Map<String, Object> map);

    /**
     * find all the prerequisites of a subject/studyGradeType combination
     * 
     * @param subjectStudyGradeTypeId
     *            id of the subject/studyGradeType combination
     * @return a list of subjectPrerequisites
     */
    List<SubjectPrerequisite> findSubjectPrerequisites(int subjectStudyGradeTypeId);

    /**
     * Find the codes of the subjects that are required for this subjectStudyGradeType combination
     * 
     * @param subjectStudyGradeTypeId
     *            id of the subjectStudyGradeType combination
     * @return list of subjectCodes
     */
    List<String> findPrerequisiteSubjectCodes(int subjectStudyGradeTypeId);

    /**
     * find all the prerequisites of a subject within a studyPlan
     * 
     * @param map
     *            containing studyPlanId and subjectCode
     * @return a list of subjectPrerequisites or null
     */
    List<SubjectPrerequisite> findPrerequisitesBySubjectCodeAndStudyPlanId(Map<String, Object> map);

    /**
     * find the studyGradeTypes to which the chosen subject is assigned.
     * 
     * @param map
     *            contains: subjectId preferredLanguage of the user, used to find the
     *            gradeTypeDescription in the correct language
     * @return list of subjectstudyGradeTypes
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypes(Map<String, Object> map);

    /**
     * @param map
     *            with studyId id of the study and preferred language
     * @return List of SubjectStudyGradeTypes or null
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypesForStudy(Map<String, Object> map);

    /**
     * Add a subjectStudyGradeType to a subject.
     * 
     * @param subjectStudyGradeType
     *            to add
     */
    void addSubjectStudyGradeType(SubjectStudyGradeType subjectStudyGradeType);

    /**
     * Update a subjectStudyGradeType belonging to a subject.
     * 
     * @param subjectStudyGradeType
     *            to update
     */
    void updateSubjectStudyGradeType(SubjectStudyGradeType subjectStudyGradeType);

    /**
     * delete a subjectStudyGradeType from a subject.
     * 
     * @param subjectStudyGradeTypeId
     *            id of subjectStudyGradeType to delete
     */
    void deleteSubjectStudyGradeType(int subjectStudyGradeTypeId);

    /**
     * @param subjectId
     *            id of the subject of which to find the studyplans.
     * @return List of studyPlanDetails or null
     */
    boolean existSubjectStudyPlanDetails(int subjectId);

    /**
     * find a subjectStudyType.
     * 
     * @param map
     *            contains: subjectStudyTypeId id of subjectStudyType preferredLanguage of the user
     * @return list of subjectStudyTypes
     */
    SubjectStudyType findSubjectStudyType(Map<String, Object> map);

    // TODO move to SubjectDao
    int findStudyGradeTypeId(Map<String, Object> map);

    /**
     * find subjectStudyTypes of a subject.
     * 
     * @param map
     *            contains: subjectId id of subject preferredLanguage of the user
     * @return list of subjectStudyTypes
     */
    List<SubjectStudyType> findSubjectStudyTypes(Map<String, Object> map);

    /**
     * add a subjectStudyType.
     * 
     * @param subjectStudyType
     *            to add
     */
    void addSubjectStudyType(SubjectStudyType subjectStudyType);

    /**
     * update a subjectStudyType.
     * 
     * @param subjectStudyType
     *            to update
     */
    void updateSubjectStudyType(SubjectStudyType subjectStudyType);

    /**
     * delete a subjectStudyType.
     * 
     * @param subjectStudyTypeId
     *            id of subjectStudyType to delete
     */
    void deleteSubjectStudyType(int subjectStudyTypeId);

    /**
     * find a subjectStudyYear.
     * 
     * @param subjectStudyYearId
     *            id of subjectStudyYear to find
     * @return subjectStudyYear or null
     */
    // SubjectStudyYear findSubjectStudyYear(int subjectStudyYearId);

    /**
     * find all subjectStudyYears belonging to a subject.
     * 
     * @param subjectId
     *            id of subject, used to find the subjectStudyYears
     * @return list of subjectStudyYears
     */
    // List < SubjectStudyYear > findSubjectStudyYearsForSubject(int subjectId);

    /**
     * find all subjectStudyYears belonging to a certain parameter-combination.
     * 
     * @param map
     *            with params used to find the subjectStudyYears
     * @return list of subjectStudyYears
     */
    // List < SubjectStudyYear > findSubjectStudyYears(Map<String, Object> map);

    /**
     * Add a subjectStudyYear.
     * 
     * @param subjectStudyYear
     *            to add
     */
    // void addSubjectStudyYear(SubjectStudyYear subjectStudyYear);

    /**
     * Update a subjectStudyYear.
     * 
     * @param subjectStudyYear
     *            to update
     */
    // void updateSubjectStudyYear(SubjectStudyYear subjectStudyYear);

    /**
     * delete a subjectStudyYear from a studyYear.
     * 
     * @param subjectStudyYearId
     *            id of subjectStudyYear to delete
     */
    // void deleteSubjectStudyYear(int subjectStudyYearId);

    /**
     * add a prerequisite to a subject/studyGradeType combination
     * 
     * @param subjectPrerequisite
     *            to add
     */
    void addSubjectPrerequisite(SubjectPrerequisite subjectPrerequisite);

    /**
     * delete a prerequisite from a subject/studyGradeType combination
     * 
     * @param subjectPrerequisite
     *            to delete
     */
    void deleteSubjectPrerequisite(SubjectPrerequisite subjectPrerequisite);

    /**
     * delete all prerequisites from a subject/studyGradeType combination
     * 
     * @param subjectPrerequisite
     *            to delete
     */
    void deleteSubjectPrerequisites(int subjectStudyGradeTypeId);

    /**
     * find all subjectSubjectBlocks belonging to a certain parameter-combination.
     * 
     * @param map
     *            with params used to find the subjectSubjectBlocks
     * @return list of subjectSubjectBlocks
     */
    List<SubjectSubjectBlock> findSubjectSubjectBlocks(Map<String, Object> map);

    /**
     * @param subjectSubjectBlockId
     *            id of the subjectSubjectBlock
     * @return SubjectSubjectBlock or null
     */
    SubjectSubjectBlock findSubjectSubjectBlock(int subjectSubjectBlockId);

    /**
     * @param subjectId
     *            id of the subject
     * @return List of SubjectSubjectBlocks or null
     */
    List<SubjectSubjectBlock> findSubjectSubjectBlocksForSubject(int subjectId);

    /**
     * @param subjectSubjectBlock
     *            to add
     */
    void addSubjectSubjectBlock(SubjectSubjectBlock subjectSubjectBlock);

    /**
     * @param subjectSubjectBlock
     *            to update
     */
    void updateSubjectSubjectBlock(SubjectSubjectBlock subjectSubjectBlock);

    /**
     * delete a subjectSubjectBlock from a subjectBlock.
     * 
     * @param subjectSubjectBlockId
     *            id of subjectSubjectBlock to delete
     */
    void deleteSubjectSubjectBlock(int subjectSubjectBlockId);

    /**
     * Find the id's of all the subjects which are linked to a given studyGradeType.
     * 
     * @param studyGradeType
     *            to which the subjects are linked
     * @return a list of subject id's
     */
    List<Integer> findSubjectsByStudyGradeType(StudyGradeType studyGradeType);

    /**
     * Find the id's of all the subjectblocks which are linked to a given studyGradeType.
     * 
     * @param studyGradeType
     *            to which the subjectblocks are linked
     * @return a list of subjectblock id's
     */
    List<Integer> findSubjectBlocksByStudyGradeType(StudyGradeType studyGradeType);

    /**
     * @param map
     * @return
     */
    @MapKey("originalId")
    Map<Integer, SubjectCT> findSubjectsForTransition(Object map);

    /**
     * @param studyGradeTypes
     * @return
     */
    List<Map<String, Integer>> findSubjectStudyGradeTypesForTransition(List<StudyGradeTypeCT> studyGradeTypes);

    /**
     * @param studyGradeTypeIDs
     * @return
     */
    List<Map<String, Integer>> findSubjectStudyGradeTypesForTransitionByIDs(List<Integer> studyGradeTypeIDs);

    /**
     * @param studyGradeTypes
     * @return
     */
    // List<Map<String,Integer>> findSubjectBlockStudyGradeTypesForTransition(List<StudyGradeTypeCT>
    // studyGradeTypes);

    /**
     * @param subjectBlocks
     * @return
     */
    // List<Map<String, Integer>> findSubjectSubjectBlocksForTransition(
    // List<SubjectBlockCT> subjectBlocks);

    /**
     * @param studyGradeTypeIDs
     * @return
     */
    // List<Map<String, Integer>> findSubjectSubjectBlocksForTransitionByIDs(
    // List<Integer> studyGradeTypeIDs);

    /**
     * @param subjectCT
     * @param toAcademicYearId
     * @return
     */
    int transferSubject(@Param("subjectCT") SubjectCT subjectCT, @Param("toAcademicYearId") int toAcademicYearId);

    /**
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectTeachers(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectStudyTypes(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectPrerequisites(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectStudyGradeTypes(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * delete a number of subjectSubjectBlock based on the subjectId.
     * 
     * @param subjectId
     *            id of subjectSubjectBlocks to delete
     */
    void deleteSubjectSubjectBlocks(int subjectId);

    /**
     * @param studyGradeTypeId
     *            to find subjects for
     * @return List of subjectstudygradetypes or null
     */
    List<SubjectStudyGradeType> findSubjectsForStudyGradeType(int studyGradeTypeId);

    /**
     * @param map
     *            with studygradetype, subject and cardinaltimeunitnumber
     * @return SubjectStudyGradeType or null
     */
    SubjectStudyGradeType findSubjectStudyGradeTypeByParams(Map<String, Object> map);

    /**
     * @param map
     *            with studygradetype, subject and cardinaltimeunitnumber
     * @return List of SubjectStudyGradeTypes or null
     */
    List<SubjectStudyGradeType> findBlockedSubjectStudyGradeTypeByParams(Map<String, Object> map);

    /**
     * Find subjectStudyGradeTypes which can be transferred if the subjects with the given
     * subjectIds are transferred, and for which the studyGradeType records already exist in the
     * target year.
     * 
     * @param map
     * @return
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypesForSubjectTransition(Map<String, Object> map);

    /**
     * Find subjectStudyGradeTypes which can be transferred if the studyGradeTypes with the given
     * studyGradeTypeIds are transferred, and for which the subject records already exist in the
     * target year.
     * 
     * @param map
     * @return
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypesForSGTTransition(Map<String, Object> map);

    /**
     * Find subjectSubjectBlocks which can be transferred if the subjects with the given subjectIds
     * are transferred, and for which the subjectBlock records already exist in the target year.
     * 
     * @param map
     * @return
     */
    List<SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectTransition(Map<String, Object> map);

    /**
     * Find subjectSubjectBlocks which can be transferred if the subject blocks with the given
     * subjectBlockIds are transferred, and for which the subject records already exist in the
     * target year.
     * 
     * @param map
     * @return
     */
    List<SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectBlockTransition(Map<String, Object> map);

    /**
     * @param map
     *            contains the following parameters: institutionId branchId organizationalUnitId
     *            studyId gradeTypeCode educationTypeCode The educationTypeCode is never empty, the
     *            other parameters are optional
     * @return a list of subjectStudyGradeTypes
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypes2(Map<String, Object> map);

    /**
     * Get the subject count.
     * 
     * @param map
     * @return
     */
    int findSubjectCount(Map<String, Object> map);

    List<Subject> findBlockedSubjects(Map<String, Object> map);

    int findSubjectBlockIdByParams(Map<String, Object> map);

    List<Subject> findSubjectsInSubjectBlock(int subjectBlockId);

    List<Subject> findSubjectsForStudyPlanDetailAndInBlocks(int studyplanDetailId);

    /**
     * Find subjects for given study plan, including the ones that are linked by subject blocks.
     * 
     * @param studyPlanId
     *            id of the studyplan
     * @return List of Subjects
     */
    List<Subject> findSubjectsForStudyPlan(int studyPlanId);

    /**
     * @param map
     *            with studyPlanCardinalTimeUnitId id and active of the studyplancardinaltimeunit
     * @return List of Subjects
     */
    List<Subject> findSubjectsForStudyPlanCardinalTimeUnit(Map<String, Object> map);

    /**
     * @param studyPlanCardinalTimeUnitId
     * @return
     */
    List<Integer> findSubjectIdsForStudyPlanCardinalTimeUnitAndInBlocks(int studyPlanCardinalTimeUnitId);

    /**
     * @param studyPlanId
     *            the id of the studyplan
     * @return List of Subjects that are active
     */
    List<Subject> findActiveSubjectsForStudyPlan(int studyPlanId);

    /**
     * @param Map
     *            with studyplanId and cardinaltimeunitnumber to find active subjects for
     * @return List of Subjects that are active
     */
    List<Subject> findActiveSubjectsForCardinalTimeUnit(Map<String, Object> map);

    /**
     * @param Map
     *            with studyplanId, studyplancardinaltimeunitId and cardinaltimeunitnumber to find
     *            active subjects for
     * @return List of Subjects that are active for this studyplancardinaltimeunit
     */
    List<Subject> findActiveSubjectsForStudyPlanCardinalTimeUnit(Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List<Subject> findPassedSubjects(Map<String, Object> map);

}
