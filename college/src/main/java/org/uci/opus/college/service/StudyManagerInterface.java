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

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.CareerPosition;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.GroupedDiscipline;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.LooseSecondarySchoolSubject;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.Referee;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.util.OpusInit;

/**
 * @author J.Nooitgedagt
 *
 */
public interface StudyManagerInterface {
    
    /**
     * @param map with params to find studies
     * @return List of Studies or null
     */   
    List<Study> findStudies(final Map<String, Object> map); 

    /**
     * Find study objects for the given study ids.
     * @param studyIds
     * @param preferredLanguage
     * @return
     */
    List<Study> findStudies(final List<Integer> studyIds, String preferredLanguage);

    /**
     * find the list of studyGradeTypes that student can ask admission for. This depends on 
     * the admissionPeriod set in a department and the academicYear of the studyGradeTypes
     * 
     * @return a list of studyGradeTypes or null
     */
    List < StudyGradeType > findStudyGradeTypesForAdmission(String language);
    
    /**
     * @return List of Studies or null
     */   
    List <  Study > findAllStudies();
    
//    /**
//     * @param organizationalUnitId id of the organizationalunit
//     * @return List of Studies or null
//     */   
//    List < ? extends Study > findAllOrganizationalUnitStudies(final int organizationalUnitId);         
    
    
    /**
     * @param studyId id of study to find
     * @return study
     */   
    Study findStudy(final int studyId);

    /**
     * @param map params: studyDescription, org unit and academic field of study to find
     * @return study
     */   
    Study findStudyByNameUnit(final Map<String, Object> map);

    /**
     * Get a list of all Studies for universities.
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForUniversities();

    /**
     * Get a list of all Studies for one institution.
     * @param institutionId of which to find the studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForInstitution(final int institutionId);

    /**
     * Get a list of all Studies for one branch.
     * @param branchId id of branch of which to find the studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForBranch(final int branchId);

    /**
     * Get a list of all Studies for one organizational unit.
     * @param organizationalUnitId id of organizational unit of which to find the studies
     * @return List of Study objects
     */  
    List <  Study > findAllStudiesForOrganizationalUnit(final int organizationalUnitId);

    /**
     * TODO Move to {@link SubjectManagerInterface}
     * 
     * Get a list of all Subjects for one study.
     * @param studyId id of the study
     * @return List of Subject objects or null
     */  
    List <  Subject > findSubjectsForStudy(final int studyId);

    /**
     * @param studyGradeTypeId id of StudyGradeType to find
     * @return StudyGradeType
     */   
    StudyGradeType findStudyGradeType(final int studyGradeTypeId);

    /**
     * Convenience method that calls {@link #findStudyGradeTypeConsiderLanguage(Map)}
     * 
     * @param studyGradeTypeId
     * @param language used to fill the {@link StudyGradeType#gradeTypeDescription}
     * @return
     */
    StudyGradeType findStudyGradeType(final int studyGradeTypeId, final String language);

    /**
     * Find a studyGradeType. Find the gradeTypeDescription in the preferred language.
     * @param map contains: studyGradeTypeId: id of the studyGradeType to find
     *                      preferredLanguage: language chosen by the user
     * @return a studyGradeType
     */
    StudyGradeType findStudyGradeTypeConsiderLanguage(final Map<String, Object> map);

    /**
     * @param  map with studyId, gradeTypeCode and currentAcademicYearId
     * @return StudyGradeType or null
     */
    StudyGradeType findStudyGradeTypeByStudyAndGradeType(final Map<String, Object> map);

    /**
     * Find the simplest possible study grade type object:
     * 'preferredLanguage' parameter required.
     * @param map with all params to find studygradetype for
     * @return StudyGradeType or null
     */   
    StudyGradeType findStudyGradeTypeByParams(final Map<String, Object> map);

    /**
     * @param studyGradeTypeId
     * @return
     */
    List <  StudyGradeType > findStudyGradeTypePrerequisites(
            final int studyGradeTypeId);

    /**
     * 'preferredLanguage' parameter not required (gradeTypeDescription is not loaded).
     * @param map
     * @return
     */
    StudyGradeType findPlainStudyGradeType(final Map<String, Object> map);

    /**
     * Get a list of all StudyGradeTypes for one study.
     * @param map with studyId, preferredLanguage and currentAcademicYearId
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findAllStudyGradeTypesForStudy(final Map<String, Object> map);
    
    /**
     * Get a list of StudyGradeTypes for one study, without double gradeTypeCodes.
     * @param  map with studyId, preferredLanguage and currentAcademicYearId
     * @return List of StudyGradeType objects, with only the properties gradeTypeCode
     *         and gradeTypeDescription filled 
     */  
    List <  StudyGradeType > findDistinctStudyGradeTypesForStudy(final Map<String, Object> map);
    
    
    /**
     * Get a list of all StudyGradeTypes.
     * @return List of StudyGradeType objects
     *
     * {@inheritDoc}.
     * @see org.uci.opus.college.persistence.StudyMapper#findAllStudyGradeTypes()
     */
    List <  StudyGradeType > findAllStudyGradeTypes();

    /**
     * Get a list of all StudyGradeTypes for the logged in user.
     * @param map with studyId and preferredLanguage
     * @return List of StudyGradeType objects
     */  
    List <StudyGradeType> findStudyGradeTypes(final Map<String, Object> map);

    /**
     * Get a list of studyGradeTypes with the given ids.
     * @param studyGradeTypeIds
     * @return
     */
    List <StudyGradeType> findStudyGradeTypes(final List<Integer> studyGradeTypeIds, String preferredLanguage);

    /**
     * Get a list of all StudyGradeTypes for the logged in user.
     * @param map with studyId and preferredLanguage
     * @return List of StudyGradeType objects
     */  
    List <  StudyGradeType > findStudyGradeTypesByParams(final Map<String, Object> map);
    
    /**
     * Get a list of grade types of a study, organizational unit, branch or institution,
     * depending on the value of the given parameters.
     * @param map map of id's of above mentioned objects
     * @return List of grade types
     */  
    List <  StudyGradeType > findGradeTypesForSubjectStudies(final Map<String, Object> map);

    /**
     * @param study to add
     */    
    void addStudy(final Study study);

    /**
     * @param study to update
     */    
    void updateStudy(final Study study);
    
    /**
     * @param studyId id of study to delete
     */
    void deleteStudy(final int studyId);

    /**
     * @param studyGradeType to add
     * adds a studygradetype and returns the new Id of this studygradetype
     */    
    void addStudyGradeType(final StudyGradeType studyGradeType);

    /**
     * Test if a studyGradeType with the given code, but with a different id exists in the given
     * academic year already exists.
     * @param id
     * @param academicYearId
     * @param studyGradeTypeCode
     * @return
     */
    boolean alreadyExistsStudyGradeTypeCode(int id, int academicYearId, String studyGradeTypeCode);

    /**
     * @see #alreadyExistsStudyGradeTypeCode(int, int, String)
     * @param studyGradeType
     * @return
     */
    boolean alreadyExistsStudyGradeTypeCode(StudyGradeType studyGradeType);

    /**
     * @param studyGradeType to update
     */    
    void updateStudyGradeType(final StudyGradeType studyGradeType);
    
    /**
     * @param studyGradeTypeId id of study to delete
     * @param who wrote the record
     */
    void deleteStudyGradeType(final int studyGradeTypeId, final HttpServletRequest request);

    /**
     * @param prerequisite
     */
    void addStudyGradeTypePrerequisite(final StudyGradeTypePrerequisite prerequisite);
    
    /**
     * @param prerequisite
     */
    void deleteStudyGradeTypePrerequisite(final StudyGradeTypePrerequisite prerequisite);
    
    /**
     * @param studyGradeTypeId gradeTypeId of the studyplanlist to find
     * @return List of studyPlans or null
     */
    List <  StudyPlan > findStudyPlansForStudyGradeType(final int studyGradeTypeId);

    /**
     * TODO move to {@link StudentManagerInterface}
     * 
     * @param subjectBlockId subjectBlockId of the studyplandetaillist to find
     * @return List of studyPlanDetails or null
     */
    List<StudyPlanDetail> findStudyPlanDetailsForSubjectBlock(final int subjectBlockId);

    /**
     * Finds academics years according organizationalUnit , study,
     * study year and study grade type
     * Use this if one or none of these elements is not necessary 
     * 
     * @param map 
     * @return list o academic years
     */
    List <AcademicYear>  findAllAcademicYears(final Map<String, Object> map);
    
    /**
     * find an academicYear by its id
     * @param academicYearId id of the academicYear to find
     * @return an academiceYear (only id and description are for now filled)
     */
    AcademicYear findAcademicYear(final int academicYearId);
    
    /**
     * 
     * @param studyGradeTypeId
     * @return
     */
    int findAcademicYearIdForStudyGradeTypeId(int studyGradeTypeId);
    
    /**
     * @param studyGradeTypeId to find max cardinal time unit number for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findMaxCardinalTimeUnitNumberForStudyGradeType(final int studyGradeTypeId);

    /**
     * @param studyGradeTypeId to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyGradeType(final int studyGradeTypeId);

    /**
     * @param map with studyId and gradeTypeCode to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyAndGradeType(final Map<String, Object> map);

    /**
     * @param studyPlanId of studyplan to find number of cardinal time units for
     * @return maxCardinalTimeUnitNumber or 0
     */    
    int findNumberOfCardinalTimeUnitsForStudyPlan(final int studyPlanId);

    /**
     * @param hashmap with language and gradeTypeCode to find endgrades for
     * @return List of EndGrades or null
     */   
    List <  EndGrade > findAllEndGrades(final Map<String, Object> map);

    /**
     * @param academicYearId
     * @param 
     * @return EndGradeTypeCode or null
     */   
    String findEndGradeType(int academicYearId);

    /**
     * Are end grades defined in the given academic year?
     */
    boolean useEndGrades(int academicYearId);

    /**
     * Are end grades defined at all (ie. in any academic year)?
     */
    boolean useEndGrades();

    /**
     * @param gradepoint for the minimum grade to find
     * @return EndGradeTypeCode or null
     */   
    BigDecimal findMinimumEndGradeForGradeType(final Map<String, Object> map);

    /**
     * @param gradepoint for the maximum grade to find
     * @return EndGradeTypeCode or null
     */   
    BigDecimal findMaximumEndGradeForGradeType(final Map<String, Object> map);

    /**
     * @param map with studyId and gradeTypeCode to find max academic year for
     * @return academicYearId or null
     */    
    int findMaxAcademicYearForStudyGradeType(final Map<String, Object> map);
    
    /**
     * @param map with studyGradeTypeId and cardinalTimeUnitNumber to 
     *          find CardinalTimeUnitStudyGradeType for
     * @return CardinalTimeUnitStudyGradeType or null
     */    
    CardinalTimeUnitStudyGradeType findCardinalTimeUnitStudyGradeTypeByParams(
                    final Map<String, Object> map);

    /**
     * @param studyGradeTypeId
     */
    List<CardinalTimeUnitStudyGradeType> findCardinalTimeUnitStudyGradeTypes(
            final int studyGradeTypeId);
    
    /**
     * TODO move to {@link StudentManagerInterface}
     * 
     * @param list of studyplandetails
     * @return number of subjects attached to the studyplandetails from the list
     */    
    int countSubjectsInStudyPlanDetails(final List<StudyPlanDetail> studyPlanDetails);

    /**
     * Get the grade type corresponding to the given study grade type id.
     * @param studyGradeTypeId
     * @param language preferred language of the user
     * @return a Lookup (gradeType)
     */
    Lookup findGradeTypeByStudyGradeTypeId(int studyGradeTypeId, String language);
    
    /**
     * Get the endgrade comments belonging to a certain grade type 
     *    together with failgrades and endgradesgeneral 
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullEndGradeCommentsForGradeType(final Map<String, Object> map);

    /**
     * Map a map endGradeTypeCode -> list of EndGrades.
     * Note: The parameter map is expected to have an "endGradeTypeCodes" key.
     * @param map
     * @return
     */
    Map<String, List<EndGrade>> findEndGradeTypeCodeToFullEndGradesMap(final Map<String, Object> map);

    /**
     * Get the the failed the endgrade comments belonging to a certain grade type 
     *    together with failgrades and endgradesgeneral 
     * @param map with gradetypecode, preferredLanguage
     * @return list of endgrades
     */
    List < EndGrade > findFullFailGradeCommentsForGradeType(final Map<String, Object> map);

    /**
     * Map a map endGradeTypeCode -> list of fail grades.
     * Note: The parameter map is expected to have an "endGradeTypeCodes" key.
     * @param map
     * @return
     */
    Map<String, List<EndGrade>> findEndGradeTypeCodeToFullFailGradesMap(final Map<String, Object> map);

    /**
     * Get a SecondarySchoolSubjectGroup for one studyGradeType.
     * @param preferredLanguage of user
     * @param groupId to find the SecondarySchoolSubjectGroup
     * @return SecondarySchoolSubjectGroup object
     */  
    SecondarySchoolSubjectGroup findSecondarySchoolSubjectGroup(final String preferredLanguage
                                            , final int studyGradeTypeId, final int groupId);

    /**
     * @param secondarySchoolSubjectId
     * @param studyGradeTypeId
     * @param preferredLanguage
     * @return
     */
    SecondarySchoolSubject createSecondarySchoolSubject(
            final int secondarySchoolSubjectId 
            , final int studyGradeTypeId
            , final String preferredLanguage);
    
    /**
     * Find all secondarySchoolSubjects in a given language
     * @return a list of secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findAllSecondarySchoolSubjects();
    
    List < SecondarySchoolSubject > findSecondarySchoolSubjects(final Map<String, Object> map);
    
    /**
     * Find a list of secondarySchoolSubjectGroups linked to a studyGradeType
     * @param studyGradeTypeId id of the studyGradeType the groups are linked to
     * @param preferredLanguage needed to find the list of secondarySchoolSubjects per group
     * @return a list of secondarySchoolSubjectGroups
     */
    List < SecondarySchoolSubjectGroup > findSecondarySchoolSubjectGroups(
                                                    final int studyGradeTypeId
                                                    , final String preferredLanguage);

    /**
     * Find a list of secondarySchoolSubjectGroups linked to a studyPlan
     * @param studyPlan id of the studyplan the groups are linked to
     * @param preferredLanguage needed to find the list of secondarySchoolSubjects per group
     * @return a list of secondarySchoolSubjectGroups
     */
    List < SecondarySchoolSubjectGroup > findSecondarySchoolSubjectGroupsForStudyPlan(Map<String, Object> map);

    /**
     * Find a list of gradedSecondarySchoolSubjects linked to a studyPlan
     * @param studyPlan id of the studyplan the groups are linked to
     * @return a list of gradedSecondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findGradedSecondarySchoolSubjectsForStudyPlan(
            final int studyPlanId);

    /**
     * Find a list of ungrouped gradedSecondarySchoolSubjects linked to a studyPlan
     * @param studyPlan id of the studyplan the ungrouped subjects are linked to
     * @return a list of ungrouped gradedSecondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findGradedUngroupedSecondarySchoolSubjectsForStudyPlan(
            final int studyPlanId);

    /**
     * Add a grade to a specific secondarySchoolSubject for studyPlan
     * @param secondarySchoolSubject subject
     * @param studyPlanId id of the studyPlan
     */
    void addGradedSecondarySchoolSubject(final SecondarySchoolSubject secondarySchoolSubject
            , final int studyPlanId, final int groupId, String writeWho);
    
    /**
     * @param secondarySchoolSubject
     * @param studyPlanId
     * @param groupId
     */
    void updateGradedSecondarySchoolSubject(
            final SecondarySchoolSubject secondarySchoolSubject
          , final int studyPlanId, final int groupId, final String writeWho);
    
    /**
     * @param secondarySchoolSubject
     * @param studyPlanId
     */
    void deleteGradedSecondarySchoolSubject(
            final SecondarySchoolSubject secondarySchoolSubject
                                            , final int studyPlanId, String writeWho);
    
    /**
     * Find a list of secondarySchoolSubjects which are part of a given group in the
     * preferred language of the user
     * @param secondarySchoolSubjectGroupId id of the group that the subjects belong to
     * @param preferredLanguage language of the user
     * @return a list of secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findSecondarySchoolSubjects(
            final int secondarySchoolSubjectGroupId, final String preferredLanguage);

    /**
     * Find a list of secondarySchoolSubjects which are part of a given group in the
     * preferred language of the user
     * @param hashmap with secondarySchoolSubjectGroupId, studyPlanId, preferredLanguage 
     *        defaultvalues gradepoint and weight
     * @return a list of secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findSecondarySchoolSubjectsForStudyPlan(final Map<String, Object> map);

    /**
     * Find a list of secondarySchoolSubjects which are not part of a given group, 
     * in the preferred language of the user
     * @param hashmap with secondarySchoolSubjectGroupId, studyPlanId, preferredLanguage 
     *        defaultvalues gradepoint and weight
     * @return a list of ungrouped secondarySchoolSubjects
     */
    List < SecondarySchoolSubject > findUngroupedSecondarySchoolSubjectsForStudyPlan(
            final Map<String, Object> map);

    /**
     * @param secondarySchoolSubjectGroup
     * @return
     */
    void insertSecondarySchoolSubjectGroup(final SecondarySchoolSubjectGroup secondarySchoolSubjectGroup);
    
    /**
     * @param secondarySchoolSubjectGroup
     */
    void updateSecondarySchoolSubjectGroup(final SecondarySchoolSubjectGroup secondarySchoolSubjectGroup);
    
    /**
     * @param secondarySchoolSubjectGroup
     */
    void deleteSecondarySchoolSubjectGroup(final SecondarySchoolSubjectGroup secondarySchoolSubjectGroup);

    /**
     * Find the number of endgrades to transfer from one
     * academic year to another.
     * @param map
     * @return 0 if the target academic year already has 1 or more endGrades.
     */
    int findNrOfEndgradesToTransfer(final Map<String, Object> map);
    /**
     * Find all studyGradeTypes for a studyPlan.
     * There is more than one studyGradeType as soon as a studyPlan spans more than one academic year.
     * @param studyPlanId
     * @return List of StudyGradeTypes objects or null
     */    
    List<StudyGradeType> findStudyGradeTypesForStudyPlan(final int studyPlanId);

    /**
     * add an obtained qualification to a studyPlan
     * @param obtainedQualification to add
     */
    void addObtainedQualification(final ObtainedQualification obtainedQualification);

    
    /**
     * delete an obtained qualification by it's id from a studyPlan
     * @param obtainedQualificationId of the obtained qualification to delete
     */
    void deleteObtainedQualification(final int obtainedQualificationId);
    
    /**
     * delete all obtained qualification of a studyPlan
     * @param studyPlanId id of the given studyPlan
     */
    void deleteObtainedQualificationsByStudyPlanId(final int studyPlanId);
    
    
    /**
     * find all obtained qualifications of a studyPlan
     * @param studyPlanId id of the given studyPlan
     * @return list of obtained qualifications
     */
    List < ObtainedQualification >  findObtainedQualificationsByStudyPlanId(
                                                                        final int studyPlanId);

    /**
     * add an obtained career position to a studyPlan
     * @param careerPosition to add
     */
    void addCareerPosition(final CareerPosition careerPosition);

    /**
     * delete a career position by it's id from a studyPlan
     * @param careerPositionId id of the career position to delete
     */
    void deleteCareerPosition(final int careerPositionId);

    /**
     * delete all career positions of a studyPlan
     * @param studyPlanId id of the given studyPlan
     */
    void deleteCareerPositionsByStudyPlanId(final int studyPlanId);

    /**
     * find all career positions of a studyPlan
     * @param studyPlanId id of the given studyPlan
     * @return list of career positions
     */
    List < CareerPosition >  findCareerPositionsByStudyPlanId(final int studyPlanId);

    /**
     * add a given referee to a studyPlan
     * @param referee to add
     */
    void addReferee(final Referee referee);

    /**
     * update a given referee
     * @param referee the referee to update
     */
    void updateReferee(final Referee referee);
    
    /**
     * delete a given referee from a studyPlan
     * @param refereeId id of the referee to delete
     */
    void deleteReferee(final int refereeId);
    
    /**
     * delete all referees from a studyPlan
     * @param studyPlanId id of the given studyPlan
     */
    void deleteRefereesByStudyPlanId(final int studyPlanId);
    
    /**
     * find all referees of a given studyPlan
     * @param studyPlanId id of the studyPlan
     * @return list of referees
     */
    List < Referee >  findRefereesByStudyPlanId(final int studyPlanId);
    
    /**
     * either insert or update referees of a given studyPlan
     * @param studyPlan the referees are linked to
     */
    void adaptReferees(final StudyPlan studyPlan);
    
    /**
     * Find the disciplines that belong to a given discipline group
     * @param map containing:
     *        disciplineGroupCode
     *        preferredLanguage of user
     * @return list of disciplines
     */
    List < Lookup >  findDisciplinesForGroup(final Map<String, Object> map);
    
    /**
     * find out if there are studyPlans linked to a given study
     * @param studyId id of the study
     * @return list of id's
     */
    List < Integer > findStudyPlansByStudyId(final int studyId);
    
    /**
     * A studyPlan is linked to a branch through the study and via the organzational unit.
     * Find the branch that the studyPlan is linked to. 
     * @param studyPlanId id of the studyPlan
     * @return a Branch
     */
    Branch findBranchByStudyPlanId(final int studyPlanId);
    
    /**
     * Find the number of cardinal time units per academic year
     * for the given cardinalTimeUnitCode.
     * This method does not require a language parameter; the first
     * cardinalTimeUnit lookup table record will be used.
     * @param cardinalTimeUnitCode
     * @return
     */
    int findNrOfUnitsPerYearForCardinalTimeUnitCode(final String cardinalTimeUnitCode);


    /*##################### LooseSecondarySchoolSubjects queries ###############################*/
    
    
    List<LooseSecondarySchoolSubject> findLooseSecondarySchoolSubjects(Map<String, Object> map);  
    
    LooseSecondarySchoolSubject findLooseSecondarySchoolSubject(Map<String, Object> map);
    LooseSecondarySchoolSubject findLooseSecondarySchoolSubjectById(int id);
    
    void deleteLooseSecondarySchoolSubject(Map<String, Object> map);
    void deleteLooseSecondarySchoolSubjectById(int id);
    void updateLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject);
    void addLooseSecondarySchoolSubject(LooseSecondarySchoolSubject looseSecondarySchoolSubject);
    
    /*##################### DisciplineGroups queries ###############################*/
    
    
//    List<DisciplineGroup> findDisciplineGroups(Map<String, Object> map);
//    List<Map<String, Object>> findDisciplineGroupsAsMaps(Map<String, Object> map);
//    
//    DisciplineGroup findDisciplineGroup(Map<String, Object> map);
//    DisciplineGroup findDisciplineGroupById(int id);
//    
//    void deleteDisciplineGroup(Map<String, Object> map);
//    void deleteDisciplineGroupById(int id);
//    void updateDisciplineGroup(DisciplineGroup disciplineGroup);
//    int addDisciplineGroup(DisciplineGroup disciplineGroup);


    /*##################### GroupedDiscipline queries ###############################*/
    
    void addGroupedDiscipline(GroupedDiscipline groupedDiscipline);
    void deleteGroupedDiscipline(Map<String, Object> map);
    void deleteGroupedDiscipline(int disciplineGroupId, String disciplineCode);
    void addGroupedDisciplines(List<GroupedDiscipline> groupedDisciplines);
    
    /**
     * Find the disciplines that do not belong to a given discipline group
     * @param map containing:
     *        disciplineGroupId
     *        lang of user
     * @return list of disciplines
     */
    List < Lookup >  findDisciplinesNotInGroup(final Map<String, Object> map);
    List < Lookup >  findDisciplinesNotInGroup(final int disciplineGroupId, String lang);
    List < Lookup >  findDisciplinesForGroup(final int disciplineGroupId, String lang);

    /**
     * Finds tables which contains values depending on a discipline 
     * @param params
     * @return a map containing a table name and the number of dependencies 
     */
    Map<String, Object> findDisciplineDependencies(Map<String, Object> params);
    
    /**
     * Finds tables which contains values depending on a discipline with specified code
     * @param params
     * @return
     */
    Map<String, Object> findDisciplineDependencies(String code);
    
    void deleteDiscipline(String disciplineCode);

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
     * @return a list of classgroups
     */
	List<Classgroup> findClassgroups(Map<String, Object> map);

	/**
	 * Calls {@link #findClassgroups(Map)}
	 */
    List<Classgroup> findClassgroupsBySubjectId(int subjectId);

	/**
	 * Get the classgroup count.
	 * @param map
	 * @return
	 */
	int findClassgroupCount(Map<String, Object> map);

    /**
     * Update an existing classgroup.
     * @param classgroup
     * @param writeWho
     */
    void updateClassgroup(Classgroup classgroup, String writeWho);

    /**
     * Add a classgroup.
     * @param classgroup
     * @param writeWho
     */
    void addClassgroup(Classgroup classgroup, String writeWho);

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
	void addStudentClassgroup(int studentId, int classgroupId, String writeWho);

	/**
	 * Removes a student-classgroup connection
	 * @param studentId
	 * @param classgroupId
	 */
	void deleteStudentClassgroup(int studentId, int classgroupId);

	/**
	 * Adds a subject-classgroup connection
	 * @param subjectId
	 * @param classgroupId
	 */
	void addSubjectClassgroup(int subjectId, int classgroupId, String writeWho);

    /**
     * Add multiple subjectClassgroups.
     */
    void addSubjectClassgroups(List<SubjectClassgroup> subjectClassgroups, String writeWho);

    /**
	 * Removes a subject-classgroup connection
	 * @param subjectId
	 * @param classgroupId
	 */
	void deleteSubjectClassgroup(int subjectId, int classgroupId);

    /**
     * Delete subjectClassgroups.
     */
    void deleteSubjectClassgroups(List<SubjectClassgroup> subjectClassgroups);

	/**
	 * Determine the max number of subjects per cardinalTimeUnit.
	 * If the value is not specified in the given {@link StudyGradeType}, then the Opus default value is used, see {@link OpusInit#getMaxSubjectsPerCardinalTimeUnit()}.
	 * 
	 * @param studyGradeType
	 * @return
	 */
    int getMaximumNumberOfSubjectsPerCardinalTimeUnit(StudyGradeType studyGradeType);

}
