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

import org.uci.opus.college.domain.StudyPlanDetail;

public interface StudyplanDetailMapper {

    /**
     * Delete the details of a studyplan from a Student.
     * 
     * @param studyPlanId
     *            the id of the studyplan for which details must be deleted
     * @return
     */
    void deleteStudyPlanDetailsForStudyPlan(int studyPlanId);

    /**
     * Find studyplandetails of a Student.
     * 
     * @param studentId
     *            id of Student
     * @return list of studyplandetails
     */
    List<StudyPlanDetail> findStudyPlanDetailsForStudent(Map<String, Object> map);

    /**
     * Find studyplandetails of a Studyplan.
     * 
     * @param studyPlanId
     *            id of studyplan of Student
     * @return list of studyplans
     */
    List<StudyPlanDetail> findStudyPlanDetailsForStudyPlan(int studyPlanId);

    /**
     * Find studyplandetails for a cardinal timeunit within a Studyplan.
     * 
     * @param id
     *            of the studyplancardinaltimeunit
     * @return list of studyplandetails
     */
    List<StudyPlanDetail> findStudyPlanDetailsForStudyPlanCardinalTimeUnit(int id);

    /**
     * Find studyplandetails for a cardinal timeunit within a Studyplan.
     * 
     * @param map
     *            with studyPlanId, studygradetypeid and cardinaltimeunitnumber
     * @return list of studyplandetails
     */
    List<StudyPlanDetail> findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(Map<String, Object> map);

    /**
     * Find studyplandetails of a Subject.
     * 
     * @param subjectId
     *            id of subject
     * @return list of studyplans
     */
    List<StudyPlanDetail> findStudyPlanDetailsForSubject(int subjectId);

    /**
     * Find studyplandetails of a Subject.
     * 
     * @param map
     *            with subjectId and academicYear
     * @return list of studyplans
     */
    List<StudyPlanDetail> findStudyPlanDetailsByParams(Map<String, Object> map);
    
    /**
     * Find studyplandetails, eagerly loading subjects.
     * 
     * @param map
     *            with subjectId and academicYear
     * @return list of studyplans
     */
    List<StudyPlanDetail> findStudyPlanDetailsWithEagerSubjects(Map<String, Object> map);

    /**
     * 
     * @param subjectStudyGradeTypeId
     * @return
     */
    List<StudyPlanDetail> findStudyPlanDetailsForSubjectStudyGradeType(int subjectStudyGradeTypeId);

    /**
     * @param subjectBlockId
     *            subjectBlockId of the studyplandetaillist to find
     * @return List of studyPlanDetails or null
     */
    List<StudyPlanDetail> findStudyPlanDetailsForSubjectBlock(final int subjectBlockId);

    /**
     * 
     * @param subjectBlockStudyGradeTypeId
     * @return
     */
    List<StudyPlanDetail> findStudyPlanDetailsForSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId);

    /**
     * Find studyplandetail of a studyplan.
     * 
     * @param map
     *            with subjectId, subjectblockId, studyplancardinaltimeunitId
     * @return studyplandetail or null
     */
    StudyPlanDetail findStudyPlanDetailByParams(Map<String, Object> map);

    /**
     * Find one StudyPlanDetail of a Studyplan.
     * 
     * @param studyPlanDetailId
     *            id
     * @return StudyplanDetail or null
     */
    StudyPlanDetail findStudyPlanDetail(int studyPlanDetailId);

    /**
     * Add a studyplan to a Studyplan.
     * 
     * @param studyPlanDetail
     *            the studyplandetail to add
     * @return the id of the newly created studyPlanCardinalTimeUnit
     */
    void addStudyPlanDetail(StudyPlanDetail studyPlanDetail);

    /**
     * Update a StudyPlanDetail of a Studyplan.
     * 
     * @param studyPlanDetail
     *            the studyplandetail to update
     * @return
     */
    void updateStudyPlanDetail(StudyPlanDetail studyPlanDetail);

    /**
     * Delete a studyplan for a Studyplan.
     * 
     * @param studyPlanDetailId
     *            id of the studyplandetail to delete
     * @return
     */
    void deleteStudyPlanDetail(int studyPlanDetailId);

    /**
     * Get {@link StudyPlanDetail}s.
     */
    List<StudyPlanDetail> findStudyPlanDetailsForCardinalTimeUnitResult(int cardinalTimeUnitResultId);

}
