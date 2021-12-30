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
 * Center for Information Services, Radboud University Nijmegen
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

import org.uci.opus.college.domain.LimitedStudyPlanAndStudent;
import org.uci.opus.college.domain.StudyPlan;

public interface StudyplanMapper {

	/**
	 * @param studentId
	 *            id of Student of whom to find the existing studyPlans
	 * @return List of StudyPlan objects or null.
	 */
	List<StudyPlan> findStudyPlansForStudent(int studentId);

	/**
	 * @param studentId
	 *            id + active of Student of whom to find the existing studyPlans
	 * @return List of StudyPlan objects or null.
	 */
	List<StudyPlan> findStudyPlansForStudentByParams(Map<String, Object> map);

	/**
	 * Find one studyplan of a Student.
	 * 
	 * @param studyPlanId
	 *            id
	 * @return studyplan
	 */
	StudyPlan findStudyPlan(int studyPlanId);

	/**
	 * Find one studyplan of a Student.
	 * 
	 * @param map
	 *            with studentId id, studyId, gradeTypeCode,
	 *            studyPlanDescription description
	 * @return studyplan or null
	 */
	StudyPlan findStudyPlanByParams(Map<String, Object> map);

	StudyPlan findStudyPlanByParams2(Map<String, Object> map);

	/**
	 * @param studyPlan
	 *            the studyplan to add
	 */
	void addStudyPlanToStudent(StudyPlan studyPlan);

	/**
	 * Update a studyplan to a Student.
	 * 
	 * @param studyPlan
	 *            the studyplan to update
	 * @return
	 */
	void updateStudyPlan(StudyPlan studyPlan);

	/**
	 * Update a studyplan statuscode.
	 * 
	 * @param studyPlan
	 */
	void updateStudyPlanStatusCode(StudyPlan studyPlan);

	/**
	 * Returns a subset of given studyPlanIds for which already exist given
	 * target studyPlanCardinalTimeUnits.
	 * 
	 * @param map
	 * @return
	 */
	List<Integer> findStudyPlansWhereExistsTargetSPCTU(Map<String, Object> map);

	/**
	 * Find studyPlanIds.
	 * 
	 * @param map
	 * @return
	 */
	List<Integer> findStudyPlanIds(Map<String, Object> map);

	/**
	 * Delete a studyplan from a Student.
	 * 
	 * @param studyPlanId
	 *            the id of the studyplan to delete
	 */
	void deleteStudyPlan(int studyPlanId);

	/**
	 * Get the total number of study plans with status "active".
	 * 
	 * <p>
	 * Note that this counts study plans of all institutions.
	 */
	int findNumberOfActiveStudyPlans();

	/**
	 * Get the total number of study plans in the system.
	 * 
	 * <p>
	 * Note that this counts study plans of all institutions.
	 */
	int findTotalNumberOfStudyPlans();

	/*
	 * Get the corresponding branchId for the given studyPlanid.
	 * 
	 * @param studyPlanId studyPlan identifier
	 */
	int findBranchIdForStudyPlan(int studyPlanId);

	/**
	 * Quick access method to a selected set of information about study plan and student.
	 */
	List<LimitedStudyPlanAndStudent> findLimitedStudyPlanAndStudent(List<Integer> studyPlanIds);

}
