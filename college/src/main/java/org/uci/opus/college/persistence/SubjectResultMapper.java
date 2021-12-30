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
import org.uci.opus.college.domain.SubjectResultHistory;
import org.uci.opus.college.domain.result.SubjectResult;

public interface SubjectResultMapper {

    /**
     * @param subjectResultId
     *            id of the SubjectResult
     * @return SubjectResult or null
     */
    SubjectResult findSubjectResult(int subjectResultId);

    /**
     * @param params
     *            for a subjectResult except id of the SubjectResult
     * @return SubjectResult or null
     */
    SubjectResult findSubjectResultByParams(Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists. used to check if it is allowed to
     * delete a subject
     * 
     * @param params
     *            for a subjectResult except id of the SubjectResult
     * @return list of SubjectResults
     */
    List<SubjectResult> findSubjectResultsByParams(Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists. used to check if it is allowed to
     * delete a subject
     * 
     * @param subjectId
     *            id of subject
     * @return list of SubjectResults
     */
    List<SubjectResult> findSubjectResults(int subjectId);

    /**
     * Find out if there are one or more subjects results for the given subjectId.
     */
    boolean existSubjectResultsForSubject(int subjectId);

    /**
     * @param studentId
     *            the id of the student to find subject results for
     * @return List of SubjectResult
     */
    List<SubjectResult> findSubjectResultsForStudent(Map<String, Object> map);

    /**
     * @param studyPlanId
     *            for a studyplan to find subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForStudyPlan(int studyPlanId);

    /**
     * @param studyPlanId
     *            for a studyplan to find active subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findActiveSubjectResultsForStudyPlan(int studyPlanId);

    /**
     * @param hashmap
     *            with studyplanId and cardinaltimeunitnumber to find active subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findActiveSubjectResultsForCardinalTimeUnit(Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists. used to check if it is allowed to
     * delete a subjectstudygradetype
     * 
     * @param params
     *            subjectId and studyGradeTypeId
     * @return list of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForSubjectStudyGradeType(Map<String, Object> map);

    /**
     * get the id's of the subjectResult combination if it exists. used to check if it is allowed to
     * delete a subjectblockstudygradetype
     * 
     * @param params
     *            subjectBlockId and studyGradeTypeId
     * @return list of SubjectResults or null
     */
    List<SubjectResult> findSubjectResultsForSubjectBlockStudyGradeType(Map<String, Object> map);

    /**
     * @param subjectResult
     *            the subjectResult to add
     * @return subjectResultId
     */
    void addSubjectResult(SubjectResult subjectResult);
    
    void addSubjectResultHistory(SubjectResult subjectResult);

    /**
     * @param subjectResult
     *            the subjectResult to update
     */
    void updateSubjectResult(SubjectResult subjectResult);

    void updateSubjectResultHistory(SubjectResult subjectResult);

    /**
     * @param subjectResultId
     *            id of the subjectResult
     */
    void deleteSubjectResult(int subjectResultId);

    void deleteSubjectResultHistory(SubjectResult subjectResult);

    /**
     * @param map
     *            params for a list of subjectresults within a StudyPlan
     * @return List of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForStudyPlanByParams(Map<String, Object> map);

    /**
     * @param subjectBlockId
     *            for a subjectBlock to find subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForSubjectBlock(int subjectBlockId);

    /**
     * @param subjectSubjectBlockId
     *            for a subjectSubjectBlock to find subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForSubjectSubjectBlock(int subjectSubjectBlockId);

    /**
     * @param subjectBlockSubjectBlockId
     *            for a subjectBlockSubjectBlock to find subjectresults for
     * @return List of SubjectResults
     */
    List<SubjectResult> findSubjectResultsForSubjectBlockSubjectBlock(int subjectBlockSubjectBlockId);
    
    
    List<SubjectResultHistory> findSubjectResultHistory(@Param("subjectId") int subjectId, @Param("studyPlanDetailId") int studyPlanDetailId);

}
