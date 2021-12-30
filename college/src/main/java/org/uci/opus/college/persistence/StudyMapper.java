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

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.GroupedDiscipline;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.LooseSecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.curriculumtransition.StudyGradeTypeCT;

/**
 * @author J.Nooitgedagt
 *
 */
public interface StudyMapper {
    /**
     * Get a list with all studies.
     * @return list of studies
     */
    List<Study>  findAllStudies();
    
    /**
     * find list of Studies depending on the parameters in the map.
     * the more parameters are empty, the longer the list, so:
     * if the organizationalUnitId is not filled, a list of studies belonging to the branch
     * is returned; if the branchId is also empty, a list of studies belonging to the
     * university is returned; the educationTypeCode is (for now) always 3 (university)
     * @param map of parameters used to find the correct list of studies
     *        contains the following parameters:
     *        institutionId
     *        branchId
     *        organizationalUnitId
     *        educationTypeCode
     *        
     * @return list of studies
     */
    List < Study >  findStudies(Map<String, Object> map);
       
    /**
     * find the list of studyGradeTypes that student can ask admission for. This depends on 
     * the admissionPeriod set in a department and the academicYear of the studyGradeTypes
     * 
     * @return a list of studyGradeTypes or null
     */
    List < StudyGradeType > findStudyGradeTypesForAdmission(String language);
    
    
//    /**
//     * Get a list with all studies of an organizationalUnit.
//     * @param organizationalUnitId id of the organizationalUnit
//     * @return list of studies
//     */
//    List <  Study > findAllOrganizationalUnitStudies(int organizationalUnitId);
    
    /**
     * @param studyId id of the study to find
     * @return Study found
     */
    Study findStudy(int studyId);

    /**
     * @param map with params studyDescription, org unit and academic field of study to find
     * @return study
     */   
    Study findStudyByNameUnit(Map<String, Object> map);
    
    /**
     * @param groupId
     * @return
     */
    SecondarySchoolSubjectGroup findSecondarySchoolSubjectGroup(int groupId);
    
    /**
     * Find all secondarySchoolSubjects in a given language
     * @return a list of secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findAllSecondarySchoolSubjects();
    
    /**
     * Find a list of secondarySchoolSubjectGroups linked to a studyGradeType
     * @param studyGradeTypeId id of the studyGradeType the groups are linked to
     * @return a list of secondarySchoolSubjectGroups
     */
    List<SecondarySchoolSubjectGroup> findSecondarySchoolSubjectGroups(int studyGradeTypeId);

    /**
     * NB: {@link LooseSecondarySchoolSubject} represents a record in the secondaryschoolsubject table.
     * @param findParameters
     * @return
     */
    List<LooseSecondarySchoolSubject>findSecondarySchoolSubjectsAsMaps(Map<String,Object> findParameters);

    /**
     * Find a list of secondarySchoolSubjectGroups linked to a studyPlan
     * @param studyPlan id of the studyplan the groups are linked to
     * @param preferredLanguage needed to find the list of secondarySchoolSubjects per group
     * @return a list of secondarySchoolSubjectGroups
     */
    List < SecondarySchoolSubjectGroup > findSecondarySchoolSubjectGroupsForStudyPlan(
                                                    int studyPlanId);

    /**
     * Find a list of gradedSecondarySchoolSubjectIds linked to a studyPlan
     * @param studyPlan id of the studyplan the gradedSecondarySchoolSubjects are linked to
     * @return a list of gradedSecondarySchoolSubjectIds
     */
    List < Integer > findGradedSecondarySchoolSubjectIdsForStudyPlan(
    		Map<String, Object> map);
 
    /**
     * Find a gradedSecondarySchoolSubject
     * @param an id  of a gradedSecondarySchoolSubject 
     * @return a gradedSecondarySchoolSubject
     */
    SecondarySchoolSubject findGradedSecondarySchoolSubjectForStudyPlan(
    			Map<String, Object> map);

    /**
     * Add a grade to a specific secondarySchoolSubject for a studyPlan
     * @param map containing the secondarySchoolSubject and the studyPlanId
     */
    void addGradedSecondarySchoolSubject(Map<String, Object> map);
    
    /**
     * update the grade of a specific secondarySchoolSubject for a studyPlan
     * @param map containing the secondarySchoolSubject and the studyPlanId
     */
    void updateGradedSecondarySchoolSubject(Map<String, Object> map);
    
    /**
     * Delete the grade of a specific secondarySchoolSubject for a studyPlan
     * @param map containing the secondarySchoolSubject and the studyPlanId
     */
    void deleteGradedSecondarySchoolSubject(Map<String, Object> map);

    List < SecondarySchoolSubject > findSecondarySchoolSubjects(Map<String, Object> map);

    /**
     * Find a list of secondarySchoolSubjects which are part of a given group in the
     * preferred language of the user
     * @param hashmap with secondarySchoolSubjectGroupId, studyPlanId, preferredLanguage 
     *        defaultvalues gradepoint and weight
     * @return a list of secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findSecondarySchoolSubjectsForStudyPlan(Map<String, Object> map);


    /**
     * Find all secondarySchoolSubjects ids.
     * @param secondarySchoolSubjectGroupId
     * @return
     */
    List<Integer> findGroupedSecondarySchoolSubjectIds(
            int secondarySchoolSubjectGroupId);

    /**
     * @param secondarySchoolSubject
     */
    void insertGroupedSecondarySchoolSubject(SecondarySchoolSubject secondarySchoolSubject);    

    /**
     * 
     * @param studyGradeTypeId
     * @return
     */
    int getMaxSecondarySchoolSubjectGroupNumber(int studyGradeTypeId);
    
    /**
     * @param secondarySchoolSubjectGroup
     * @return
     */
    int insertSecondarySchoolSubjectGroup(SecondarySchoolSubjectGroup secondarySchoolSubjectGroup);
    
    /**
     * @param secondarySchoolSubjectGroup
     */
    void updateSecondarySchoolSubjectGroup(SecondarySchoolSubjectGroup secondarySchoolSubjectGroup);
    
    /**
     * @param secondarySchoolSubjectGroup
     */
    void deleteSecondarySchoolSubjectGroup(int secondarySchoolSubjectGroupId);
    
    /**
     * @param secondarySchoolSubjectGroup
     */
    void deleteGroupedSecondarySchoolSubjectList(int secondarySchoolSubjectGroupId);
    
    /**
     * Get a list of all Studies for universities.
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForUniversities();

    /**
     * Get a list of all Studies for one institution.
     * @param institutionId id of institution, used to find the studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForInstitution(@Param("institutionId") int institutionId);

    /**
     * Get a list of all Studies for one branch.
     * @param branchId id of branch, used to find studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForBranch(@Param("branchId") int branchId);

    /**
     * Get a list of all Studies for one organizational unit.
     * @param organizationalUnitId id of organization, used to find studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForOrganizationalUnit(@Param("organizationalUnitId") int organizationalUnitId);

    /**
     * Get a list of all Subjects for one study.
     * @param studyId id of the study for which subjects to find
     * @return List of Subject objects or null
     */  
    List <  Subject > findSubjectsForStudy(int studyId);

    /**
     * @param studyGradeTypeId id of StudyGradeType to find
     * @return StudyGradeType or null
     */   
    StudyGradeType findStudyGradeType(int studyGradeTypeId);

    /**
     * @param  map with studyId, gradeTypeCode and currentAcademicYearId
     * @return StudyGradeType or null
     */
    StudyGradeType findStudyGradeTypeByStudyAndGradeType(Map<String, Object> map);
    	
    /**
     * 'preferredLanguage' parameter required.
     * @param map with all params to find studygradetype for
     * @return StudyGradeType or null
     */   
    StudyGradeType findStudyGradeTypeByParams(Map<String, Object> map);

    /**
     * Find the simplest possible study grade type object:
     * 'preferredLanguage' parameter not required (gradeTypeDescription is not loaded).
     * @param map
     * @return
     */
    StudyGradeType findPlainStudyGradeType(Map<String, Object> map);
    
    /**
     * Get a list of all StudyGradeTypes for one study.
     * @param map with studyId, preferredLanguage and currentAcademicYearId
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findAllStudyGradeTypesForStudy(Map<String, Object> map);
    
    /**
     * Get a list of StudyGradeTypes for one study, without double gradeTypeCodes.
     * @param  map with studyId, preferredLanguage and currentAcademicYearId
     * @return List of StudyGradeType objects, with only the properties gradeTypeCode
     *         and gradeTypeDescription filled 
     */  
    List <  StudyGradeType > findDistinctStudyGradeTypesForStudy(Map<String, Object> map);

    /**
     * 
     * @param studyGradeTypeId
     * @return
     */
    List <  StudyGradeType > findStudyGradeTypePrerequisites(int studyGradeTypeId);

    /**
     * Get a list of all StudyGradeTypes.
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findAllStudyGradeTypes();

    /**
     * Get a list of all StudyGradeTypes for the logged in user.
     * @param map with studyId and preferredLanguage
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findStudyGradeTypes(Map<String, Object> map);

    /**
     * Get a list of all StudyGradeTypes for the logged in user.
     * @param map with studyId and preferredLanguage
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findStudyGradeTypesByParams(Map<String, Object> map);

    /**
     * Get a list of gradeTypes of a study, organizational unit, branch or institution,
     * depending on the value of the given parameters.
     * @param map map of id's of above mentioned objects
     * @return List of GradeType objects
     */  
    List <  StudyGradeType > findGradeTypesForSubjectStudies(Map<String, Object> map);
    
    /**
     * @param study to add
     */
    void addStudy(Study study);
    
    /**
     * @param study to update
     */
    void updateStudy(Study study);
    
    /**
     * @param studyId id of study to delete
     */
    void deleteStudy(int studyId);

    /**
     * 
     * @param studyGradeTypeId
     */
    void deleteCardinalTimeUnitStudyGradeTypes(int studyGradeTypeId);
    
    /**
     * @param studyGradeType to add
     */   
    void addStudyGradeType(StudyGradeType studyGradeType);

    /**
     * Test if a studyGradeType with the given code, but with a different id exists in the given
     * academic year already exists.
     * @param map
     * @return
     */
    boolean alreadyExistsStudyGradeTypeCode(Map<String, Object> map);
    
    /**
     * 
     * @param ct
     */
    void addCardinalTimeUnitStudyGradeType(CardinalTimeUnitStudyGradeType ct);
    
    /**
     * @param studyGradeType to update
     */    
    void updateStudyGradeType(StudyGradeType studyGradeType);
    
    /**
     * Deletes a given studyGradeType, including possible linked prerequisites.
     * @param studyGradeTypeId id of studyGradeType to delete
     */
    void deleteStudyGradeType(int studyGradeTypeId);

    /**
     * @param studyGradeTypeId id of the studygradetype
     * @return List of studyPlans or null
     */
    List <  StudyPlan > findStudyPlansForStudyGradeType(int studyGradeTypeId);

    /**
	 * Find list of academic years based on study , institution etc
	 * @return List of academic years
	 */
	List < AcademicYear > findAllAcademicYears(Map<String, Object> map);
	
	/**
	 * find an academicYear by its id
	 * @param academicYearId id of the academicYear to find
	 * @return an academiceYear (only id and description are for now filled)
	 */
	AcademicYear findAcademicYear(int academicYearId);

	/**
	 * 
	 * @param studyGradeTypeId
	 * @return
	 */
	int findAcademicYearIdForStudyGradeTypeId(int studyGradeTypeId);

	/**
	 * 
	 * @param subjectStudyGradeTypeId
	 * @return
	 */
	int findAcademicYearIdForSubjectStudyGradeTypeId(int subjectStudyGradeTypeId);
	
	/**
	 * 
	 * @param subjectStudyGradeTypeId
	 * @return
	 */
	int findAcademicYearIdForSubjectBlockStudyGradeTypeId(int subjectBlockStudyGradeTypeId);
	
    /**
     * Find a studyGradeType. Find the gradeTypeDescription in the preferred language.
     * @param map contains: studyGradeTypeId: id of the studyGradeType to find
     *                      preferredLanguage: language chosen by the user
     * @return a studyGradeType
     */
    StudyGradeType findStudyGradeTypeConsiderLanguage(Map<String, Object> map);
    
    /**
     * Add a studyGradeType as a prerequisite to another studyGradeType.
     * @param prerequisite studyGradeType linked as a prerequisite to another studyGradeType
     *        to insert
     */
    void addStudyGradeTypePrerequisite(StudyGradeTypePrerequisite prerequisite);
    
    /**
     * Remove a studyGradeType that is linked as a prerequisite to another studyGradeType.
     * @param prerequisite studyGradeType linked as a prerequisite to another studyGradeType
     *        to delete
     */
    void deleteStudyGradeTypePrerequisite(StudyGradeTypePrerequisite prerequisite);

    /**
     * 
     * @param studyGradeTypeId
     */
    void deleteStudyGradeTypePrerequisites(int studyGradeTypeId);
    
    /**
     * @param studyGradeTypeId to find max cardinal time unit number for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findMaxCardinalTimeUnitNumberForStudyGradeType(int studyGradeTypeId);

    /**
     * @param studyGradeTypeId to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyGradeType(int studyGradeTypeId);

    /**
     * @param map with studyId and gradeTypeCode to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyAndGradeType(Map<String, Object> map);

    /**
     * @param studyPlanId of studyplan to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyPlan(int studyPlanId);
    
    /**
     * @param hashmap with language and gradeTypeCode to find endgrades for
     * @return List of EndGrades or null
     */   
    List <  EndGrade > findAllEndGrades(Map<String, Object> map);

    /**
     * @param academicYearId
     * @param 
     * @return EndGradeTypeCode or null
     */   
    String findEndGradeType(int academicYearId);

    /**
     * @param gradepoint for the minimum grade to find
     * @return EndGradeTypeCode or null
     */   
    BigDecimal findMinimumEndGradeForGradeType(Map<String, Object> map);

    /**
     * @param gradepoint for the maximum grade to find
     * @return EndGradeTypeCode or null
     */   
    BigDecimal findMaximumEndGradeForGradeType(Map<String, Object> map);

    /**
     * @param map parameter map for ibatis query
     * @return
     */
    @MapKey("originalId")
    Map<Integer, StudyGradeTypeCT> findStudyGradeTypesForTransition(Map<String, Object> map);

//    /**
//     * Transfer given study grade types to the given academic year.
//     * This will make a copy of the respective study grade type records
//     * and assign the copies to the new academic year.
//     * @param studygradetypes
//     * @param toAcademicYearId
//     */
//    void transferStudyGradeTypes(List<StudyGradeTypeCT> studygradetypes,
//            int toAcademicYearId);

    /**
     * Transfer the given study grade type to the given academic year.
     * @param studyGradeType
     * @param toAcademicYearId
     * @return
     */
//    int transferStudyGradeType(@Param("originalId") int originalId, @Param("toAcademicYearId") int toAcademicYearId);
//    int transferStudyGradeType(Map<String, Object> map);
    int transferStudyGradeType(@Param("studyGradeTypeCT") StudyGradeTypeCT sgtCT, @Param("toAcademicYearId") int toAcademicYearId);

    /**
     * Transfer the prerequisites of study grade types that have not yet
     * been transferred between the given academic years.
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferStudyGradeTypePrerequisites(@Param("sourceAcademicYearId") int sourceAcademicYearId,
            @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * Transfer a CardinalTimeUnitStudyGradeType record to the given studyGradeType.
     * @param originalCardinalTimeUnitStudyGradeTypeId
     * @param newStudyGradeTypeId
     * @return
     */
    int transferCardinalTimeUnitStudyGradeType(Map<String, Object> map
//            int originalCardinalTimeUnitStudyGradeTypeId,
//            int newStudyGradeTypeId
            );

    /**
     * Transfer a Classgroup record to the given studyGradeType.
     * @param originalClassgroupId
     * @param newStudyGradeTypeId
     * @return
     */
    int transferClassgroup(@Param("originalClassgroupId") int originalClassgroupId, @Param("newStudyGradeTypeId") int newStudyGradeTypeId);

    /**
     * Transfer the given secondary school subject group.
     * @param originalSecondarySchoolSubjectGroupId
     * @param newStudygradetypeId
     * @return
     */
    int transferSecondaryschoolsubjectgroup(Map<String, Object> map);

    /**
     * Transfer the given grouped secondary school subject.
     * @param originalGroupedsecondaryschoolsubjectId
     * @param newSecondaryschoolsubjectgroupId
     * @return
     */
    int transferGroupedsecondaryschoolsubject(@Param("originalGroupedsecondaryschoolsubjectId")  int originalGroupedsecondaryschoolsubjectId,
            @Param("newSecondaryschoolsubjectgroupId") int newSecondaryschoolsubjectgroupId);
    
    /**
     * @param map with studyId and gradeTypeCode to find max academic year for
     * @return academicYearId or null
     */    
    Integer findMaxAcademicYearForStudyGradeType(Map<String, Object> map);

    /**
     * 
     * @param studyGradeTypeId
     * @return
     */
    List < CardinalTimeUnitStudyGradeType > findCardinalTimeUnitStudyGradeTypes(int studyGradeTypeId);

    /**
     * @param map with studyGradeTypeId and cardinalTimeUnitNumber to 
     * 			find CardinalTimeUnitStudyGradeType for
     * @return CardinalTimeUnitStudyGradeType or null
     */
    CardinalTimeUnitStudyGradeType findCardinalTimeUnitStudyGradeTypeByParams(
    				Map<String, Object> map);

    /**
     * Get the grade type corresponding to the given study grade type id.
     * @param studyGradeTypeId
     * @param language preferred language of the user
     * @return a Lookup (gradeType)
     */
    Lookup findGradeTypeByStudyGradeTypeId(@Param("studyGradeTypeId") int studyGradeTypeId, @Param("language") String language);

    /**
     * Get the endgrade comments belonging to a certain grade type 
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgradecomments
     */
    List < String > findEndGradeCommentsForGradeType(Map<String, Object> map);

    /**
     * Get the endgrade comments belonging to a certain grade type 
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullEndGradeCommentsForGradeType(Map<String, Object> map);

    /**
     * Get only the failed the endgrade comments belonging to a certain grade type (passed = N)
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgradecomments
     */
    List < String > findFailEndGradeCommentsForGradeType(Map<String, Object> map);

    /**
     * Get only the failed the endgrade comments belonging to a certain grade type (passed = N)
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullFailEndGradeCommentsForGradeType(Map<String, Object> map);

    /**
     * Get the endgrade comments for all fail grades 
     * @param preferredLanguage
     * @return list of endgradecomments
     */
    List < String > findEndGradeCommentsForFailGrades(String preferredLanguage);

    /**
     * Get the endgrade comments for all fail grades 
     * @param preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullEndGradeCommentsForFailGrades(String preferredLanguage);

    /**
     * Get the endgrade comments for all general grades 
     * @param preferredLanguage
     * @return list of endgradecomments
     */
    List < String > findEndGradeCommentsForGeneralGrades(String preferredLanguage);

    /**
     * Get the endgrade comments for all general grades 
     * @param preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullEndGradeCommentsForGeneralGrades(String preferredLanguage);

    /**
     * Find the number of endgrades to transfer from one
     * academic year to another.
     * @param map
     * @return 0 if the target academic year already has 1 or more endGrades.
     */
    int findNrOfEndgradesToTransfer(Map<String, Object> map);

    /**
     * Transfer all end grades from given source to given target
     * academic year
     * @param sourceAcademicYearId
     * @param targetAcademicYearId
     */
    void transferEndGrades(@Param("sourceAcademicYearId") int sourceAcademicYearId, @Param("targetAcademicYearId") int targetAcademicYearId);

    /**
     * find all studyGradeTypes for a studyPlan.
     * @param studyPlanId
     * @return List of StudyGradeTypes objects or null
     */    
    List<StudyGradeType> findStudyGradeTypesForStudyPlan(int studyPlanId);
    


    
    /**
     * Find the disciplines that belong to a given discipline group
     * @param map containing:
     *        disciplineGroupId
     *        lang of user
     * @return list of disciplines
     */
    List < Lookup >  findDisciplinesForGroup(Map<String, Object> map);
    
    /**
     * Find the disciplines that do not belong to a given discipline group
     * @param map containing:
     *        disciplineGroupId
     *        lang of user
     * @return list of disciplines
     */
    List < Lookup >  findDisciplinesNotInGroup(Map<String, Object> map);
    
    /**
     * find out if there are studyPlans linked to a given study
     * @param studyId id of the study
     * @return list of id's
     */
    List < Integer > findStudyPlansByStudyId(int studyId);
    
    /**
     * A studyPlan is linked to a branch through the study and via the organzational unit.
     * Find the branch that the studyPlan is linked to. 
     * @param studyPlanId id of the studyPlan
     * @return a Branch
     */
    Branch findBranchByStudyPlanId(int studyPlanId);
    
    /**
     * Find the number of cardinal time units per academic year
     * for the given cardinalTimeUnitCode.
     * This method does not require a language parameter; the first
     * cardinalTimeUnit lookup table record will be used.
     * @param cardinalTimeUnitCode
     * @return
     */
    int findNrOfUnitsPerYearForCardinalTimeUnitCode(String cardinalTimeUnitCode);

    
    
    /*##################### LooseSecondarySchoolSubjects queries ###############################*/
    
    
    List<LooseSecondarySchoolSubject> findLooseSecondarySchoolSubjects(Map<String, Object> map);
   
    void deleteLooseSecondarySchoolSubject(Map<String, Object> map);
    void updateLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject);
    void addLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject);
    LooseSecondarySchoolSubject findLooseSecondarySchoolSubject(Map<String, Object> map);

    
    /*##################### GroupedDiscipline queries ###############################*/
    
    void addGroupedDiscipline(GroupedDiscipline groupedDiscipline);
    void deleteGroupedDiscipline(Map<String, Object> map);
    
    /**
     * Find tables which contains values depending on a discipline
     * @param params
     * @return
     */
    Map<String, Object> findDisciplineDependencies(Map<String, Object> params);

    /**
     * Find the studygradetype.gradeTypeCode for the given studyPlanDetailId
     * @param studyPlanDetailId
     * @return
     */
    String findGradeTypeCodeForStudyPlanDetail(int studyPlanDetailId);

    /**
     * Find a classgroup in the database with the given id.
     * @param classgroupId
     * @return
     */
    Classgroup findClassgroupById(int classgroupId);

    /**
     * @param map contains the following parameters:
     *        institutionId
     *        branchId
     *        organizationalUnitId
     *        studyId
     *        studygradetypeId
     *        currentAcademicYearId
     *        ---
     *        searchValue
     *        classgroupDescription
     *        classgroupIds
     * @return a list of subjects
     */
    List<Classgroup> findClassgroups(Map<String, Object> map);

    /**
     * Find the classgroups for the given studygradetypeId.
     */
    List<Classgroup> findClassgroupsByStudygradetypeId(int studygradetypeId);

	/**
	 * Get the classgroup count.
	 * @param map
	 * @return
	 */
	int findClassgroupCount(Map<String, Object> map);
	
	/**
     *  Update an existing classgroup.
     * @param classgroup
     */
    void updateClassgroup(Classgroup classgroup);

    /**
     * Add a classgroup.
     * @param classgroup
     */
    void addClassgroup(Classgroup classgroup);

    /**
     * Deletes a classgroup
     * @param classgroupId
     */
	void deleteClassgroup(int classgroupId);

	/**
	 * Adds a student-classgroup connection
	 * @param studentId
	 * @param classgroupId
	 */
	void addStudentClassgroup(@Param("studentId") int studentId, @Param("classgroupId") int classgroupId, @Param("writeWho") String writeWho);

	/**
	 * Removes a student-classgroup connection
	 * @param studentId
	 * @param classgroupId
	 */
	void deleteStudentClassgroup(@Param("studentId") int studentId, @Param("classgroupId") int classgroupId);

	/**
	 * Adds a subject-classgroup connection
	 * @param subjectId
	 * @param classgroupId
	 */
	void addSubjectClassgroup(@Param("subjectId") int subjectId, @Param("classgroupId") int classgroupId, @Param("writeWho") String writeWho);

	/**
	 * Removes a subject-classgroup connection
	 * @param subjectId
	 * @param classgroupId
	 */
	void deleteSubjectClassgroup(@Param("subjectId") int subjectId, @Param("classgroupId") int classgroupId);

    /**
     * @param map
     *            with studyId and gradeTypeCode
     * @return brsPassingSubject
     */
    String findBRsPassingSubjectForStudyGradeType(Map<String, Object> map);

}
