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
import org.uci.opus.college.domain.ExaminationResultHistory;
import org.uci.opus.college.domain.result.ExaminationResult;

public interface ExaminationResultMapper {

    List<ExaminationResult> findExaminationResultsForStudyPlanDetailId(int studyPlanDetailId);

    /**
     * get the id's of the examinationResult combination if it exists. used to check if it is
     * allowed to delete a subjectstudygradetype
     * 
     * @param params
     *            subjectId and studyGradeTypeId
     * @return list of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForSubjectStudyGradeType(Map<String, Object> map);

    /**
     * get the id's of the examinationResult combination if it exists. used to check if it is
     * allowed to delete a subjectblockstudygradetype
     * 
     * @param params
     *            subjectBlockId and studyGradeTypeId
     * @return list of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForSubjectBlockStudyGradeType(Map<String, Object> map);

    /**
     * @param id
     *            the id of the ExaminationResult
     * @return ExaminationResult or null
     */
    ExaminationResult findExaminationResult(int id);

    /**
     * @param params
     *            for a ExaminationResult except id of the ExaminationResult
     * @return ExaminationResult or null
     */
    ExaminationResult findExaminationResultByParams(Map<String, Object> map);

    /**
     * Find the result of a given examination.
     * 
     * @param examinationId
     *            id of the examination
     * @return List of examinationResults
     */
    List<ExaminationResult> findExaminationResults(int examinationId);

    /**
     * Find the result of a given examination.
     * 
     * @param map
     *            with paramaters
     * @return List of examinationResults
     */
    List<ExaminationResult> findExaminationResultsByParams(Map<String, Object> map);

    /**
     * get the specified examinationResult combinations.
     * 
     * @param examinationId
     *            and academicYear
     * @return list of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForAcademicYear(Map<String, Object> map);

    /**
     * Find the examination results of a subject.
     * 
     * @param subjectId
     *            id of the subject
     * @return List of examinationResults
     */
    List<ExaminationResult> findExaminationResultsForSubject(int subjectId);

    /**
     * @param params
     *            id of the subject and of the studyplandetail
     * @return List of examinationResults
     */
    List<ExaminationResult> findActiveExaminationResultsForSubjectResult(Map<String, Object> map);

    /**
     * @param params
     *            id of the subject and of the studyplandetail
     * @return List of examinationResults
     */
    List<ExaminationResult> findExaminationResultsForStudyPlanDetail(Map<String, Object> map);

    /**
     * @param studyPlanId
     *            for a studyplan to find examinationresults for
     * @return List of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForStudyPlan(int studyPlanId);

    /**
     * @param examinationResult
     *            the examinationResult to add
     */
    void addExaminationResult(ExaminationResult examinationResult);

    void addExaminationResultHistory(ExaminationResult examinationResult);

    /**
     * @param examinationResult
     *            the examinationResult to update
     * @return
     */
    void updateExaminationResult(ExaminationResult examinationResult);

    void updateExaminationResultHistory(ExaminationResult examinationResult);

    /**
     * @param id
     *            id of the examinationResult
     * @param writeWho
     *            the user deleting the record
     * @return
     */
    void deleteExaminationResult(int id);

    void deleteExaminationResultHistory(ExaminationResult examinationResult);

    /**
     * @param map
     *            params for a list of examinationresults within a StudyPlan
     * @return List of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForStudyPlanByParams(Map<String, Object> map);

    /**
     * @param subjectBlockId
     *            for a subjectBlock to find examinationresults for
     * @return List of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForSubjectBlock(int subjectBlockId);

    /**
     * @param subjectSubjectBlockId
     *            for a subjectSubjectBlock to find examinationresults for
     * @return List of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForSubjectSubjectBlock(int subjectSubjectBlockId);

    /**
     * @param subjectBlockSubjectBlockId
     *            for a subjectBlockSubjectBlock to find examinationresults for
     * @return List of ExaminationResults
     */
    List<ExaminationResult> findExaminationResultsForSubjectBlockSubjectBlock(int subjectBlockSubjectBlockId);
    
    List<ExaminationResultHistory> findExaminationResultHistory (@Param("examinationId") int examinationId, @Param("studyPlanDetailId") int studyPlanDetailId);

}
