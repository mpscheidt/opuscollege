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
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;

public interface StudyplanCardinaltimeunitMapper {

    /**
     * @param Map
     *            with studyplanId, cardinaltimeunitnumber, academicyear to find
     *            StudyPlanCardinalTimeUnit for
     * @return List of StudyPlanCardinalTimeUnits
     */
    List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnitsByParams(Map<String, Object> map);

    /**
     * Search for studyPlanCardinalTimeUnits, but instead of returning the objects return the IDs.
     */
    List<Integer> findStudyPlanCardinalTimeUnitIds(Map<String, Object> map);

    /**
     * Find the StudyPlanCardinalTimeUnit that a studyPlanDetail belongs to. For now only used in
     * the fee module for calculating the discount percentage on a fee
     * 
     * @return studyPlanCardinalTimeUnit
     */
    StudyPlanCardinalTimeUnit findStudyPlanCtuForStudyPlanDetail(int studyPlanDetailId);

    /**
     * @param id
     *            to find StudyPlanCardinalTimeUnit for
     * @return StudyPlanCardinalTimeUnit or null
     */
    StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId);

    /**
     * @param map
     *            with studyplanId, studyGradeTypeId, cardinalTimeUnitNumber to find
     *            StudyPlanCardinalTimeUnit for
     * @return StudyPlanCardinalTimeUnit or null
     */
    StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnitByParams(Map<String, Object> map);

    /**
     * @param studyplanId
     *            to find max ctunumber for
     * @return highest ctuNumber for this studyplan
     */
    int findMaxCardinalTimeUnitNumberForStudyPlan(int studyPlanId);

    /**
     * Find the latest time unit of the given study plan. If two or more time units exist for the
     * same cardinaltimeUnitNumber, then the latest one is taken according to the
     * academicyear.startDate
     * 
     * @param studyPlanId
     * @return
     */
    StudyPlanCardinalTimeUnit findMaxCardinalTimeUnitForStudyPlan(int studyPlanId);

    /**
     * @param studyplanId
     *            to find min ctunumber for
     * @return lowest ctuNumber for this studyplan
     */
    int findMinCardinalTimeUnitNumberForStudyPlan(int studyPlanId);

    /**
     * 
     */
    StudyPlanCardinalTimeUnit findMinCardinalTimeUnitForStudyPlan(int studyPlanId);

    /**
     * Find the maximum cardinalTimeUnitNumber for a studyPlan and a studyGradeType
     * 
     * @param studyPlanId
     *            id of studyPlan
     * @param studyGradeTypeId
     *            id of studyGradeType
     * @return a cardinalTimeUnitNumber
     */
    int findMaxCardinalTimeUnitNumberForStudyPlanCTU(@Param("studyPlanId") int studyPlanId, @Param("studyGradeTypeId") int studyGradeTypeId);

    /**
     * Add a studyPlanCardinalTimeUnit to a Studyplan.
     * 
     * @param studyPlanCardinalTimeUnit
     *            the studyPlanCardinalTimeUnit to add
     * @return the id of the newly created studyPlanCardinalTimeUnit
     */
    void addStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

    /**
     * Update a studyPlanCardinalTimeUnit of a Studyplan.
     * 
     * @param studyPlanCardinalTimeUnit
     *            the studyPlanCardinalTimeUnit to update
     */
    void updateStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

    /**
     * Delete a studyPlanCardinalTimeUnit for a Studyplan.
     * 
     * @param studyPlanCardinalTimeUnitId
     *            of the studyPlanCardinalTimeUnit to delete
     */
    void deleteStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId);

    /**
     * @param studyplanId
     *            to find StudyPlanCardinalTimeUnits for
     * @return List of StudyPlanCardinalTimeUnits (descending)
     */
    List<StudyPlanCardinalTimeUnit> findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(int studyPlanId);

    /**
     * Update a cardinaltimeunit status code.
     * 
     * @param studyPlanCardinalTimeUnit
     */
    void updateCardinalTimeUnitStatusCode(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

    /**
     * find the studyplancardinaltimeunits for a studyplan with the lowest cardinaltimeunitnumber
     * (may be one or more, when repeated)
     * 
     * @param new
     *            studyplanid to find the studyplancardinaltimeunits for
     * @return list of studyplancardinaltimeunits
     */
    List<StudyPlanCardinalTimeUnit> findLowestStudyPlanCardinalTimeUnitsForStudyPlan(int studyPlanId);

    /**
     * Find studycardinaltimeunits of a student.
     * 
     * @param studentId
     *            of student
     * @return list of studycardinaltimeunits
     */
    List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnitsForStudent(int studentId);

}
