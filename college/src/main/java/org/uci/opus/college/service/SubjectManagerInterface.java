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

import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyType;
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSGTSelection;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSelection;

/**
 * @author J. Nooitgedagt
 *
 */
public interface SubjectManagerInterface {

	/**
	 * @param map
	 *            with params
	 * @return List or null
	 */
	List<Subject> findSubjects(Map<String, Object> map);

	/**
	 * 
	 * @param subjectIds
	 * @return
	 */
    List<Subject> findSubjects(Collection<Integer> subjectIds);

	/**
	 * Find all subjects with the primaryStudyId equal to the given parameter
	 * studyId.
	 * 
	 * @param studyId id of the study to which the subjects are linked
	 * @return list of subjects
	 */
	List<Subject> findSubjectsByStudy(int studyId);

	/**
	 * @param subjectId
	 *            id of the subject
	 * @return Subject or null
	 */
	Subject findSubject(int subjectId);

	/**
	 * Needed when a subject has just been inserted and you need to show it
	 * immediately. (in subject.jsp): at that moment the id is not known yet
	 * Also needed because a subjectCode needs to be unique within a given
	 * academic year
	 * 
	 * @param map
	 *            containing a subjectCode and an academicYearId
	 * @return a subject or null
	 */
	Subject findSubjectByCode(Map<String, Object> map);

	/**
	 * @param map
	 *            params:subjectDescription, studyId
	 * @return Subject or null
	 */
	Subject findSubjectByDescriptionStudy(Map<String, Object> map);

	/**
	 * @param map
	 *            params: subjectDescription, studyId, subjectCode
	 * @return Subject or null
	 */
	Subject findSubjectByDescriptionStudyCode(Map<String, Object> map);

	Subject findSubjectByDescriptionStudyCode2(Map<String, Object> map);

	/**
	 * find the prerequisites (these are subjects) for following a certain
	 * subject which is part of a certain study and gradeType.
	 * 
	 * @param subjectStudyGradeTypeId
	 *            id combining the subjectId, studyId, and gradeTypeId
	 * @return a list of subjectPrerequisites
	 */
	List<SubjectPrerequisite> findSubjectPrerequisites(
			int subjectStudyGradeTypeId);

	/**
	 * Find the codes of the subjects that are required for this
	 * subjectStudyGradeType combination
	 * 
	 * @param subjectStudyGradeTypeId id of the subjectStudyGradeType combination
	 * @return list of subjectCodes
	 */
	List<String> findPrerequisiteSubjectCodes(int subjectStudyGradeTypeId);
	
	/**
     * find all the prerequisites of a subject within a studyPlan
     * @param map containing studyPlanId and subjectCode
     * @return a list of subjectPrerequisites or null
     */
    List < SubjectPrerequisite > findPrerequisitesBySubjectCodeAndStudyPlanId(
                                                    int studyPlanId, String subjectCode);

	/**
	 * @param subject
	 *            the subject to add
	 */
	void addSubject(Subject subject);

	/**
	 * @param subject
	 *            the subject to update
	 * @return
	 */
	void updateSubject(Subject subject);

	/**
	 * @param subjectId
	 *            id of the subject and who wrote the record
	 * @return
	 */
	void deleteSubject(int subjectId, HttpServletRequest request);

	/**
	 * @param subjectId
	 *            id of the subject to find
	 * @return primaryStudyId of the subject
	 */
	int findSubjectPrimaryStudyId(int subjectId);

	/**
	 * @param subjectTeacherId
	 *            id of subjectTeacher
	 * @return subjectTeacher object or null
	 */
	SubjectTeacher findSubjectTeacher(int subjectTeacherId);

	/**
	 * @param subjectId
	 *            id of the subject
	 * @return List of subjectTeachers or null
	 */
	List<SubjectTeacher> findSubjectTeachers(int subjectId);

	/**
	 * @param subjectTeacher
	 *            to add
	 */
	void addSubjectTeacher(SubjectTeacher subjectTeacher);

	/**
	 * @param subjectTeacher
	 *            to update
	 */
	void updateSubjectTeacher(SubjectTeacher subjectTeacher);

	/**
	 * @param subjectTeacherId
	 *            id of subjectTeacher to delete
	 */
	void deleteSubjectTeacher(int subjectTeacherId);

	/**
	 * @param map
	 *            with params
	 * @return SubjectStudyGradeType or null
	 */
	SubjectStudyGradeType findSubjectStudyGradeType(Map<String, Object> map);

	/**
	 * 
	 * @param preferredLanguage
	 * @param subjectStudyGradeTypeId
	 * @return
	 */
	SubjectStudyGradeType findSubjectStudyGradeType(String preferredLanguage,
			int subjectStudyGradeTypeId);

	/**
	 * find a subjectStudyGradeType by its id and the user's preferred language.
	 * 
	 * @param map
	 *            should contain the following parameters:
	 *            subjectStudyGradeTypeId of the subjectStudyGradeType to find
	 *            preferredLanguage of the user
	 * @return a subjectStudyGradeType
	 */
	int findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(Map<String, Object> map);

	/**
	 * @param map
	 *            with params
	 * @return List of SubjectStudyGradeTypes or null
	 */
	List<SubjectStudyGradeType> findSubjectStudyGradeTypes(Map<String, Object> map);

	/**
	 * 
	 * @param studyPlanDetailsIds
	 * @param preferredLanguage
	 * @return
	 * @see #findSubjectStudyGradeTypes(Map)
	 */
    List<SubjectStudyGradeType> findSubjectStudyGradeTypes(List<Integer> studyPlanDetailsIds, String preferredLanguage);

	/**
	 * @param map
	 *            with studyId id of the study and preferred language
	 * @return List of SubjectStudyGradeTypes or null
	 */
	List<SubjectStudyGradeType> findSubjectStudyGradeTypesForStudy(Map<String, Object> map);

	/**
	 * @param subjectStudyGradeType
	 *            the subjectstudygradetype to add
	 * @return
	 */
	void addSubjectStudyGradeType(
			SubjectStudyGradeType subjectStudyGradeType);

	/**
	 * @param subjectStudyGradeType
	 *            the subjectstudygradetype to update
	 * @return
	 */
	void updateSubjectStudyGradeType(
			SubjectStudyGradeType subjectStudyGradeType);

	/**
	 * @param subjectStudyGradeTypeId
	 *            id of the subjectstudygradetype to delete
	 * @param request
	 * @return
	 */
	void deleteSubjectStudyGradeType(int subjectStudyGradeTypeId,
			HttpServletRequest request);

	/**
	 * @param subjectId
	 *            id of the subject
	 * @return List of studyPlanDetails or null
	 */
	boolean existSubjectStudyPlanDetails(int subjectId);

	/**
     * Find the subjects in this studyPlan, including the ones that are part of
     * a subjectBlock in this studyPlan
     * @param studyPlanId id of the studyPlan
     * @return list of subjects
     */
	List<Subject> findSubjectsForStudyPlan(int studyPlanId);

	/*
     * apparently ununsed
     *  if used: move to studyManager
     */
//	int findStudyGradeTypeId(Map<String, Object> map);

	/**
	 * @param map
	 *            with params
	 * @return List of SubjectStudyTypes or null
	 */
	List<SubjectStudyType> findSubjectStudyTypes(Map<String, Object> map);

	/**
	 * @param map
	 *            with params
	 * @return SubjectStudyType or null
	 */
	SubjectStudyType findSubjectStudyType(Map<String, Object> map);

	/**
	 * @param subjectStudyYearId
	 *            id of the subjectStudyYear
	 * @return SubjectStudyYear or null
	 */
	// SubjectStudyYear findSubjectStudyYear(int subjectStudyYearId);

	/**
	 * @param subjectId
	 *            id of the subject
	 * @return List of SubjectStudyYears or null
	 */
	// List < SubjectStudyYear > findSubjectStudyYearsForSubject(int
	// subjectId);

	/**
	 * find all subjectStudyYears belonging to a certain parameter-combination.
	 * 
	 * @param map
	 *            with params used to find the subjectStudyYears
	 * @return list of subjectStudyYears
	 */
	// List < SubjectStudyYear > findSubjectStudyYears(Map map);

	/**
	 * find all subjectSubjectBlocks belonging to a certain
	 * parameter-combination.
	 * 
	 * @param map with params used to find the SubjectSubjectBlocks
	 * @return list of SubjectSubjectBlocks
	 */
	List<SubjectSubjectBlock> findSubjectSubjectBlocks(Map<String, Object> map);

	/**
	 * @param subjectStudyType the subjectStudyType to add
	 * @return
	 */
	void addSubjectStudyType(SubjectStudyType subjectStudyType);

	/**
	 * @param subjectStudyType the subjectStudyType to update
	 * @return
	 */
	void updateSubjectStudyType(SubjectStudyType subjectStudyType);

	/**
	 * @param subjectStudyTypeId
	 *            id of the subjectStudyType to delete
	 * @return
	 */
	void deleteSubjectStudyType(int subjectStudyTypeId);

	/**
	 * @param subjectStudyYear
	 *            to add
	 */
	// void addSubjectStudyYear(SubjectStudyYear subjectStudyYear);

	/**
	 * @param subjectStudyYear
	 *            to update
	 */
	// void updateSubjectStudyYear(SubjectStudyYear subjectStudyYear);

	/**
	 * @param subjectStudyYearId
	 *            id of subjectStudyYear to delete
	 */
	// void deleteSubjectStudyYear(int subjectStudyYearId);

	/**
	 * add a prerequisite to a subject/StudyGradeType combination
	 * 
	 * @param subjectPrerequisite
	 *            to add
	 */
	void addSubjectPrerequisite(SubjectPrerequisite subjectPrerequisite);

	/**
	 * delete a prerequisite from a subject/StudyGradeType combination
	 * 
	 * @param subjectPrerequisite
	 *            to delete
	 */
	void deleteSubjectPrerequisite(SubjectPrerequisite subjectPrerequisite);

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
	List<SubjectSubjectBlock> findSubjectSubjectBlocksForSubject(
			int subjectId);

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
	 * @param subjectSubjectBlockId
	 *            id of SubjectSubjectBlock to delete
	 */
	void deleteSubjectSubjectBlock(int subjectSubjectBlockId);

	/**
	 * Find the id's of all the subjects which are linked to a given
	 * studyGradeType.
	 * 
	 * @param studyGradeType
	 *            to which the subjects are linked
	 * @return a list of subject id's
	 */
	List<Integer> findSubjectsByStudyGradeType(StudyGradeType studyGradeType);

	/**
	 * Find the id's of all the subjectblocks which are linked to a given
	 * studyGradeType.
	 * 
	 * @param studyGradeType
	 *            to which the subjectblocks are linked
	 * @return a list of subjectblock id's
	 */
	List<Integer> findSubjectBlocksByStudyGradeType(StudyGradeType studyGradeType);

    /**
     * 
     * @param studyPlanDetailIds
     * @param preferredlanguage
     * @return
     * 
     * @see #findSubjectBlockStudyGradeTypes(Map)
     */
    List<SubjectBlockStudyGradeType> findSubjectBlockStudyGradeTypes(List<Integer> studyPlanDetailIds, String preferredlanguage);

	/**
	 * delete a studyGradeType from a subjectBlock, including any prerequisites.
	 * 
	 * @param subjectBlockStudyGradeTypeId
	 *            id of subjectStudyGradeType to delete
	 * @param request
	 *            - who wrote the record
	 */
	void deleteSubjectBlockStudyGradeType(
			int subjectBlockStudyGradeTypeId,
			HttpServletRequest request);

	/**
	 * @param studyGradeTypeId
	 *            to find subjects for
	 * @return List of subjectstudygradetypes or null
	 */
	List<SubjectStudyGradeType> findSubjectsForStudyGradeType(
			int studyGradeTypeId);

    /**
     * Delete a given subjectBlock and all links to: subjects, studyGradeTypes and prerequisites
     * 
     * <p>
     * IMPORTANT: a subjectBlock must not be deleted if it is linked to any studyplan(Detail). Add this check before calling this method
     * (see: SubjectBlockDeleteController)
     * 
     * @param subjectBlockId
     *            id of subjectBlock to delete
     */
    void deleteSubjectBlock(int subjectBlockId);

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
     * 
     * @param subjectBlockStudyGradeTypeIds
     * @return
     * 
     * @see #findBlockedSubjectStudyGradeTypeByParams(Map)
     */
    List<SubjectStudyGradeType> findBlockedSubjectStudyGradeTypeByParams(List<Integer> subjectBlockStudyGradeTypeIds);

	/**
	 * @param map
	 *            with params
	 * @return List of SubjectStudyGradeTypes or null
	 */
	List<SubjectStudyGradeType> findSubjectStudyGradeTypes2(Map<String, Object> map);

	/**
	 * Get the subject count.
	 * 
	 * @param map
	 * @return
	 */
	int findSubjectCount(Map<String, Object> map);

	/**
	 * Find the subjects with the given params.
	 * 
	 * @param map
	 *            with param
	 * @return List of Subjects or null
	 */
	List<Subject> findBlockedSubjects(Map<String, Object> map);

	/**
	 * Find the id of a subjectBlock with the use of studygradetypeId and subjectId.
	 * 
	 * @return return the subjectBlockId
	 */
	int findSubjectBlockIdByParams(Map<String, Object> map);
	
	/**
  	 * Find the subjects in a given subjectBlock.
  	 * @param subjectBlockId id of the given subjectBlock
  	 * @return return a list of subjects
  	 */
  	List <Subject> findSubjectsInSubjectBlock (int subjectBlockId);

    /**
     * Create a {@link SubjectAndBlockSGTSelection} object for the given studyGradeTypeId and cardinalTimeUnitNumber.
     * 
     * Note that blocked subjects are not included (yet).
     * 
     * @param studyGradeTypeId
     * @param cardinalTimeUnitNumber
     * @param preferredLanguage
     * @return
     */
    SubjectAndBlockSGTSelection getSubjectAndBlockSGTSelection(int studyGradeTypeId, Integer cardinalTimeUnitNumber, String preferredLanguage);

    /**
     * Create a {@link SubjectAndBlockSelection} object for the given studyGradeTypeId and cardinalTimeUnitNumber.
     * 
     * Note that blocked subjects are already included in the list of subjects.
     * It might be useful in the future to show the blocked subjects under the subject blocks.
     * 
     * @param studyGradeTypeId
     * @param cardinalTimeUnitNumber
     * @param preferredLanguage
     * @return
     */
    SubjectAndBlockSelection getSubjectAndBlockSelection(int studyGradeTypeId, Integer cardinalTimeUnitNumber, String preferredLanguage);

}
