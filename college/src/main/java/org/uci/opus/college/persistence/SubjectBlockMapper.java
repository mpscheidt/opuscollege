package org.uci.opus.college.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockPrerequisite;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.curriculumtransition.SubjectBlockCT;

/**
 * 
 * @author Markus Pscheidt
 *
 */
public interface SubjectBlockMapper {

    /**
     * find the prerequisites (these are subjectBlocks) for following a certain subjectBlock which
     * is part of a certain study and gradeType.
     * 
     * @param subjectBlockStudyGradeTypeId
     *            id of the subjectBlock/studyGradeType combination
     * @return a list of subjectBlockPrerequisites
     */
    List<SubjectBlockPrerequisite> findSubjectBlockPrerequisites(int subjectBlockStudyGradeTypeId);

    /**
     * Find the id's of the subjectBlocks that are required for this subjectBlockStudyGradeType
     * combination
     * 
     * @param subjectBlockStudyGradeTypeId
     *            id of the subjectBlockStudyGradeType combination
     * @return list of subjectBlockId's
     */
    List<String> findPrerequisiteSubjectBlockCodes(int subjectBlockStudyGradeTypeId);

    /**
     * add a prerequisite to a subjectBlock/studyGradeType combination
     * 
     * @param subjectBlockPrerequisite
     *            to add
     */
    void addSubjectBlockPrerequisite(SubjectBlockPrerequisite subjectBlockPrerequisite);

    /**
     * delete a prerequisite from a subjectBlock/studyGradeType combination
     * 
     * @param subjectBlockPrerequisite
     *            to delete
     */
    void deleteSubjectBlockPrerequisite(SubjectBlockPrerequisite subjectBlockPrerequisite);

    /**
     * Find all subjectBlocks which are linked to a given study
     * 
     * @param map
     *            contains: studyId to which the subjectBlocks are linked
     * @return a list of subjectBlock codes
     */
    List<SubjectBlock> findSubjectBlocksByStudy(int studyId);

    /**
     * Find the subject blocks with a distinct code (and academicYearId) for the given study.
     * 
     * @param studyId
     * @return
     */
    List<SubjectBlock> findSubjectBlocksWithDistinctCodeForStudy(int studyId);

    /**
     * @param map
     * @return
     */
    @MapKey("originalId")
    Map<Integer, SubjectBlockCT> findSubjectBlocksForTransition(Object map);

    /**
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectBlockPrerequisites(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * @param studyGradeTypes
     */
    void transferSubjectBlockStudyGradeTypes(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * @param subjectBlock
     * @param toAcademicYearId
     * @return
     */
    int transferSubjectBlock(@Param("subjectBlockCT") SubjectBlockCT subjectBlock, @Param("toAcademicYearId") int toAcademicYearId);

    /**
     * 
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectSubjectBlocks(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * find a subjectBlockStudyGradeType by its id and the user's preferred language.
     * 
     * @param map
     *            should contain the following parameters: subjectBlockStudyGradeTypeId of the
     *            subjectBlockStudyGradeType to find preferredLanguage of the user
     * @return a subjectBlockStudyGradeType
     */
    SubjectBlockStudyGradeType findSubjectBlockStudyGradeType(@Param("subjectBlockStudyGradeTypeId") int subjectBlockStudyGradeTypeId,
            @Param("preferredLanguage") String preferredLanguage);

    /**
     * Find the plain object.
     * 
     * @param subjectBlockStudyGradeType
     * @return
     */
    SubjectBlockStudyGradeType findPlainSubjectBlockStudyGradeType(int subjectBlockStudyGradeType);

    /**
     * find the studyGradeTypes to which the chosen subjectBlock is assigned.
     * 
     * @param map
     *            contains: subjectBlockId preferredLanguage of the user, used to find the
     *            gradeTypeDescription in the correct language
     * @return list of subjectBlockstudyGradeTypes
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypes(Map<String, Object> map);

    /**
     * Add a subjectBlockStudyGradeType to a subjectBlock / studygradetype.
     * 
     * @param subjectBlockStudyGradeType
     *            to add
     */
    void addSubjectBlockStudyGradeType(SubjectBlockStudyGradeType subjectBlockStudyGradeType);

    /**
     * Update a subjectBlockStudyGradeType belonging to a subjectBlock / studygradetype.
     * 
     * @param subjectBlockStudyGradeType
     *            to update
     */
    void updateSubjectBlockStudyGradeType(SubjectBlockStudyGradeType subjectBlockStudyGradeType);

    /**
     * Delete subjectBlockPrerequisites for the given subjectBlockStudyGradeTypeId.
     * 
     * @param subjectBlockStudyGradeTypeId
     */
    void deleteSubjectBlockPrerequisites(int subjectBlockStudyGradeTypeId);

    /**
     * delete a studyGradeType from a subjectBlock, including any prerequisites.
     * 
     * @param subjectBlockStudyGradeTypeId
     *            id of subjectBlockStudyGradeType to delete
     */
    void deleteSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId);

    /**
     * find the subjectblocks that this studyGradeType has.
     * 
     * @param studyGradeTypeId
     *            used to find the study years
     * @return list of SubjectBlocks
     */
    List<SubjectBlockStudyGradeType> findAllSubjectBlockStudyGradeTypes(int studyGradeTypeId);

    /**
     * find the studygradetypes that a subjectblock resides under.
     * 
     * @param studyId
     *            , subjectBlockId, studyGradeTypeId used to find the study grade types
     * @return list of StudyGradeTypes
     */
    List<StudyGradeType> findGradeTypesForSubjectBlockStudies(Map<String, Object> map);

    /**
     * find the subjectblocks that this studyGradeType has.
     * 
     * @param studyGradeTypeId
     *            used to find the study years
     * @return list of SubjectBlocks
     */
    List<SubjectBlock> findAllSubjectBlocksForStudyGradeType(@Param("studyGradeTypeId") int studyGradeTypeId);

    /**
     * @param
     * @return List of SubjectBlocks
     */
    List<SubjectBlock> findAllSubjectBlocks();

    /**
     * @param map
     *            with params
     * @return List of SubjectBlocks
     */
    List<SubjectBlock> findSubjectBlocks(Map<String, Object> map);

    /**
     * @param subjectBlockId
     *            id of SubjectBlock to find
     * @return SubjectBlock
     */
    SubjectBlock findSubjectBlock(int subjectBlockId);

    /**
     * @param params
     *            map of attributes for SubjectBlock to find
     * @return SubjectBlock
     */
    SubjectBlock findSubjectBlockByParams(@Param("code") String code, @Param("currentAcademicYearId") Integer currentAcademicYearId, @Param("description") String description);

    /**
     * @param map
     * @return
     */
    List<SubjectBlock> findSubjectBlocksWithResultMap(Map<String, Object> map);

    /**
     * @param subjectBlock
     *            to add
     * @return last id of subjectBlock before insert
     */
    void addSubjectBlock(SubjectBlock subjectBlock);

    /**
     * @param subjectBlock
     *            to update
     */
    void updateSubjectBlock(SubjectBlock subjectBlock);

    /**
     * Remove all links to subjects from the subjectBlock.
     * 
     * @param subjectBlockId
     */
    void deleteAllSubjectsFromSubjectBlock(int subjectBlockId);

    /**
     * Delete a given subjectBlock and all links to: subjects, studyGradeTypes and prerequisites
     * 
     * @param subjectBlockId
     *            id of subjectBlock to delete
     */
    void deleteSubjectBlock(int subjectBlockId);

    /**
     * @param subjectBlockId
     *            to find subjects for
     * @return List of subjects
     */
    List<Subject> findSubjectsForSubjectBlock(int subjectBlockId);

    /**
     * @param map
     *            with studygradetype, subjectblock and cardinaltimeunitnumber
     * @return SubjectBlockStudyGradeType or null
     */
    SubjectBlockStudyGradeType findSubjectBlockStudyGradeTypeByParams(Map<String, Object> map);

    /**
     * @param map
     *            with subject and subjectblock
     * @return SubjectSubjectBlock or null
     */
    SubjectSubjectBlock findSubjectSubjectBlockByParams(@Param("subjectId") int subjectId, @Param("subjectBlockId") int subjectBlockId);

    /**
     * find the primaryStudyId of a subjectBlock.
     * 
     * @param subjectBlockId
     *            id of the subjectBlock of which to find the primaryStudyId
     * @return primaryStudyId of the subjectBlock
     */
    int findSubjectBlockPrimaryStudyId(int subjectBlockId);

    /**
     * Find the id of the subjectBlockStudyGradeType
     * 
     * @param map
     *            containing subjectBlockId and studyGradeTypeId
     * @return subjectBlockStudyGradeTypeId
     */
    Integer findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(@Param("subjectBlockId") int subjectBlockId, @Param("studyGradeTypeId") int studyGradeTypeId);

    /**
     * Find subjectBlockStudyGradeTypes which can be transferred if the subject blocks with the
     * given subjectBlockIds are transferred, and for which the studyGradeType records already exist
     * in the target year.
     * 
     * @param map
     * @return
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForSubjectBlockTransition(Map<String, Object> map);

    /**
     * Find subjectBlockStudyGradeTypes which can be transferred if the studyGradeTypes with the
     * given studyGradeTypesIds are transferred, and for which the subjectBlock records already
     * exist in the target year.
     * 
     * @param map
     * @return
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForStudyGradeTypeTransition(Map<String, Object> map);

    /**
     * @param map
     *            contains the following parameters: institutionId branchId organizationalUnitId
     *            studyId gradeTypeCode educationTypeCode The educationTypeCode is never empty, the
     *            other parameters are optional
     * @return a list of subjectBlockStudyGradeTypes
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypes2(Map<String, Object> map);

    /**
     * @param subjectBlockId
     *            to find subjects for
     * @return List of subjects or null
     */
    List<Subject> findSubjectsForSubjectBlockInStudyPlainDetail(int subjectBlockId);

    /**
     * @param studyPlanId
     *            the id of the studyplan
     * @return List of SubjectBlocks
     */
    List<SubjectBlock> findSubjectBlocksForStudyPlan(int studyPlanId);

    /**
     * @param studyPlanCardinalTimeUnitId
     *            the id of the studyplancardinaltimeunit
     * @return List of SubjectBlocks
     */
    List<SubjectBlock> findSubjectBlocksForStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId);
}
