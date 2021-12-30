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

package org.uci.opus.college.service.curriculumtransition;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectBlockCT;
import org.uci.opus.college.domain.curriculumtransition.SubjectCT;
import org.uci.opus.college.web.flow.study.CurriculumTransitionData;

public interface CurriculumTransitionManagerInterface {

    /**
     * Load data structures that are needed during the transition process.
     * This will also preselect all eligible study grade types, subject blocks and subjects
     * to be included in the transition. Manually deactivate as required.
     * @param fromAcademicYearId
     * @param toAcademicYearId
     * @return
     */
    CurriculumTransitionData loadCurriculumTransitionData(
            int fromAcademicYearId, int toAcademicYearId, Map<String, Object> params);

    void loadCurriculumTransitionData(
            CurriculumTransitionData data, Map<String, Object> params);
    
    /**
     * Perform the actual transition.
     * This is a write operation to the database.
     * @param data
     */
    void transferCurriculum(CurriculumTransitionData data);

    void transferSubjects(final List<SubjectCT> subjects,
            final int toAcademicYearId);

    int transferSubject(final SubjectCT subject,
            final int toAcademicYearId);

    /**
     * Transfer subject teachers for already transferred subjects.
     * @param sourceAcademicYear
     * @param targetAcademicYear
     */
    void transferSubjectTeachers(int sourceAcademicYear,
            int targetAcademicYear);

    /**
     * Transfer subjectStudyTypes for already transferred subjects.
     * @param sourceAcademicYear
     * @param targetAcademicYear
     */
    void transferSubjectStudyTypes(int sourceAcademicYearId,
            int targetAcademicYearId);
    
    /**
     * Transfer the prerequisites of subjects to subjectstudygradetypes.
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectPrerequisites(int sourceAcademicYearId,
            int targetAcademicYearId);
    
    /**
     * Transfer the prerequisites of subjectblocks to subjectblockstudygradetypes.
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectBlockPrerequisites(int sourceAcademicYearId,
            int targetAcademicYearId);

    void transferExaminations(final int originalSubjectId,
            int newSubjectId, int toAcademicYearId);
    
    int transferExamination(Examination examination, int newSubjectId, int toAcademicYearId);
    
    void transferExaminationTeachers(final int originalExaminationId, final int newExaminationId, int toAcademicYearId);
    
    void transferTests(final int originalExaminationId, final int newExaminationId, final int toAcademicYearId);
    
    void transferTest(Test test, int newExaminationId, final int toAcademicYearId);

    void transferStudyGradeTypes(List<StudyGradeTypeCT> eligibleStudyGradeTypes,
            int toAcademicYearId);

    int transferStudyGradeType(
            final StudyGradeTypeCT studyGradeType,
            int toAcademicYearId);

    void transferStudyGradeTypePrerequisites(int sourceAcademicYearId,
            int targetAcademicYearId);

    void transferCardinalTimeUnitStudyGradeTypes(final int originalStudyGradeTypeId,
            int newStudyGradeTypeId);
    
    int transferCardinalTimeUnitStudyGradeType(CardinalTimeUnitStudyGradeType studyGradeType, 
            int newStudyGradeTypeId);
    
    void transferClassgroups(final int originalStudyGradeTypeId,
            int newStudyGradeTypeId);
    
    void transferClassgroup(Classgroup classgroup, 
            int newStudyGradeTypeId);
    
    void transferSecondaryschoolsubjectgroups(final int originalStudygradetypeId,
            int newStudygradetypeId);

    int transferSecondaryschoolsubjectgroup(SecondarySchoolSubjectGroup subjectGroup, int newStudygradetypeId);

    void transferGroupedsecondaryschoolsubjects(final int originalSecondaryschoolsubjectgroupId,
            int newSecondaryschoolsubjectgroupId);

    void transferGroupedsecondaryschoolsubject(int groupedSubjectId, int newSecondaryschoolsubjectgroupId);
    
    /**
     * Transfer subjectStudyGradeTypes for already transferred subjects
     * and studyGradeTypes.
     * @param sourceAcademicYear
     * @param targetAcademicYear
     */
    void transferSubjectStudyGradeTypes(int sourceAcademicYear,
            int targetAcademicYear);

    void transferSubjectBlocks(List<SubjectBlockCT> eligibleSubjectBlocks,
            int toAcademicYearId);

    /**
     * Transfer subjectBlockStudyGradeTypes for already transferred subject blocks
     * and study grade types.
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectBlockStudyGradeTypes(int sourceAcademicYearId,
            int targetAcademicYearId);

    /**
     * Transfer subjectSubjectBlocks for already transferred subjects
     * and subject blocks.
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferSubjectSubjectBlocks(int sourceAcademicYearId,
            int targetAcademicYearId);

    /**
     * 
     * @param map
     * @return
     */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypesForSubjectTransition(
            Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List < SubjectStudyGradeType > findSubjectStudyGradeTypesForSGTTransition(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List <? extends SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForSubjectBlockTransition(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List <? extends SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypesForStudyGradeTypeTransition(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List <? extends SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectTransition(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List <? extends SubjectSubjectBlock> findSubjectSubjectBlocksForSubjectBlockTransition(final Map<String, Object> map);

    /**
     * 
     * @param sourceAcademicYear
     * @param targetAcademicYear
     */
    void transferEndGrades(int sourceAcademicYear,
            int targetAcademicYear);

}
