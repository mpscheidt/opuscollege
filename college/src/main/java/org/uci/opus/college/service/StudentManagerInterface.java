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
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.Errors;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Penalty;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentAbsence;
import org.uci.opus.college.domain.StudentExpulsion;
import org.uci.opus.college.domain.StudentList;
import org.uci.opus.college.domain.StudentStudentStatus;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisStatus;
import org.uci.opus.college.domain.ThesisSupervisor;
import org.uci.opus.college.domain.util.FailedSubjectInfo;


/**
 * @author move
 * Interface for Student-related management methods.
 */
/**
 * @author Janneke
 *
 */
public interface StudentManagerInterface {
	 
    /**
     * Get a list of all Students.
     * @param preferredLanguage of user
     * @return List of Student objects
     */  
    StudentList findAllStudents(final String preferredLanguage);

    /**
     * Get the student count.
     * @param map
     * @return
     */
    int findStudentCount(final Map<String, Object> map);

    /**
     * Get a list of all Students depending on parameters in Map.
     * @param map with params to find students
     * @return List of Student objects
     */  
    StudentList findStudents(final Map<String, Object> map);

    /**
     * 
     * @param allStudents
     * @param request
     * @param optional studyPlanStatusCode
     * @param optional cardinalTimeUnitStatusCode
     * @return
     */
    StudentList filterStudents(final StudentList allStudents,
    		final String prevStudyPlanStatusCode,
    		final String nextStudyPlanStatusCode,
    		final String prevCardinalTimeUnitStatusCode,
    		final String nextCardinalTimeUnitStatusCode, HttpServletRequest request); 
    /**
     * Get a list of students with their study plans, and the CTU results (if
     * existing) and the subject results (if existing).
     * 
     * @param map
     * @return
     */
    StudentList findStudentsWithCTUAndSubjectResults(Map<String, Object> map);

    /**
     * Find a Student.
     * @param preferredLanguage of user
     * @param studentId id of student to find
     * @return Student
     */    
    Student findStudent(final String preferredLanguage, final int studentId);

    /**
     * Find a plain Student object without aggregated objects.
     * This is useful if no preferredLanguage parameter is to be used.
     * @param studentId
     * @return
     */
    Student findPlainStudent(final int studentId);
    
    /**
     * Find a student to which a studyPlanCardinalTimeUnit belongs
     * @param studyPlanCtuId id of the studyPlanCardinalTimeUnit
     * @return a plain Student object without aggregated objects.
     */
    Student findPlainStudentByStudyPlanCtuId(final int studyPlanCtuId);

    /**
     * Find a staffMember, based on personId.
     * @param personId id of staffMember to find
     * @return StaffMember
     */    
    Student findStudentByPersonId(final int personId);

    /**
     * Find a Student, based on StudentCode.
     * @param preferredLanguage of user
     * @param studentCode of Student to find
     * @return Student
     */    
    Student findStudentByCode(final String studentCode);

    /**
     * Find a student, based on parameters.
     * @param parameters for the student to find
     * @return Student or null
     */    
    Student findStudentByParams(final Map<String, Object> map);

    /**
     * Find a student, based on parameters where none of the parameters is obligatly
     * @param parameters for the student to find
     * @return Student or null
     */    
    Student findStudentByParams2(final Map<String, Object> map);
    
     /**
     * Finds a student including the study plan details
     * @param map
     */
    List < Student > findStudentsByStudyGradeAcademicYear(Map<String, Object> map);

    /**
     * Find organizationalUnit to which the Student belongs.
     * @param personId of Student
     * @return OrganizationalUnit
     */    
    OrganizationalUnit findOrganizationalUnitForStudent(final int personId);

    /**
     * @param map of params of how to find the existing studyPlans
     * @return List of StudyPlan objects or null.
     */  
//    List < StudyPlan > findStudyPlansByParams(final Map<String, Object> map);
//    List<? extends StudyPlan> findStudyPlansByParams2(final Map<String, Object> map);

    /**
     * @param studentId id of Student of whom to find the existing studyPlans
     * @return List of StudyPlan objects or null.
     */  
    List < StudyPlan > findStudyPlansForStudent(final int studentId);

    /**
     * @param studentId id + active of Student of whom to find the existing studyPlans
     * @return List of StudyPlan objects or null.
     */  
    List < StudyPlan > findStudyPlansForStudentByParams(final Map<String, Object> map);

    /**
     * Find one studyplan of a Student, including the secondary school subjects.
     * @param studyPlanId id
     * @param default highest value sec. school subject grade
     * @param default lowest value sec. school subject grade
     * @param preferredLanguage needed to find the list of secondarySchoolSubjectGroups
     * @return studyplan
     */    
    StudyPlan findStudyPlan(final int studyPlanId, final int highestGradeOfSecondarySchoolSubjects,
    		final int lowestGradeOfSecondarySchoolSubjects, final String preferredLanguage);

    
    /**
     * Find study plan
     * @param studyPlanId
     * @return
     */
    StudyPlan findStudyPlan(final int studyPlanId);

    /**
     * Find one studyplan of a Student.
     * @param map with studentId id, studyId, gradeTypeCode, studyPlanDescription description
     * @return studyplan or null
     */    
    StudyPlan findStudyPlanByParams(final Map<String, Object> map);
    StudyPlan findStudyPlanByParams2(final Map<String, Object> map);

    /**
     * Add a studyplan to a Student.
     * @param studyPlan the studyplan to add 
     * @param writeWho
     * @return
     */    
    void addStudyPlanToStudent(final StudyPlan studyPlan, String writeWho);

	/**
	* Update a studyplan for a Student.
	* @param studyPlan  the studyplan to update
	 * @param writeWho
	 * @return
	*/    
	void updateStudyPlan(final StudyPlan studyPlan, String writeWho);

	/**
	 * Update a studyplan status code.
	 * @param studyPlan
	 * @param writeWho
	 */
    void updateStudyPlanStatusCode(final StudyPlan studyPlan, String writeWho);
	
	/**
	 * Update a cardinaltimeunit status code.
	 * @param studyPlanCardinalTimeUnit
	 */
	void updateCardinalTimeUnitStatusCode(
			final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

	/**
	* Delete a studyplan for a Student.
	* @param studyPlanId of the studyplan to delete 
	 * @param writeWho
	 * @return
	*/    
	void deleteStudyPlan(final int studyPlanId, String writeWho);

    /**
     * Find studyplandetails of a Student.
     * @param map with studentId id + active of Student
     * @return list of studyplandetails
     */    
    List < StudyPlanDetail > findStudyPlanDetailsForStudent(final Map<String, Object> map);

    /**
	  * Find studyplandetails of a Studyplan.
	  * @param map with studyPlanId id of studyplan of Student
	  * @return list of studyPlanDetails
	  */    
	 List < StudyPlanDetail > findStudyPlanDetailsForStudyPlan(final int studyPlanId);

	 /**
	  * Find studyplandetails for a cardinal timeunit within a Studyplan.
	  * @param id of the studyplancardinaltimeunit
	  * @return list of studyplandetails
	  */    
	 List < StudyPlanDetail > findStudyPlanDetailsForStudyPlanCardinalTimeUnit(
			 final int id);

    /**
	  * Find studyplandetails for a cardinal timeunit within a Studyplan.
	  * @param map with studyPlanId, studygradetypeid and cardinaltimeunitnumber
	  * @return list of studyplandetails
	  */    
	 List < StudyPlanDetail > findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(
			 final Map<String, Object> map);

	 /**
	  * Find studyplandetails of a Subject.
	  * @param subjectId id of subject
	  * @return list of studyplans
	  */    
	 List < StudyPlanDetail > findStudyPlanDetailsForSubject(final int subjectId);

	 /**
	  * Find studyplandetails of a studyplan.
	  * @param map with subjectId and academicYear
	  * @return list of studyplans or empty list
	  */    
	 List < StudyPlanDetail > findStudyPlanDetailsByParams(
	                 final Map<String, Object> map);

	 /**
	  * 
	  * @param subjectStudyGradeTypeId
	  * @return
	  */
	 List<? extends StudyPlanDetail> findStudyPlanDetailsForSubjectStudyGradeType(
	         int subjectStudyGradeTypeId);

	 /**
	  * 
	  * @param subjectBlockStudyGradeTypeId
	  * @return
	  */
     List<? extends StudyPlanDetail> findStudyPlanDetailsForSubjectBlockStudyGradeType(
             int subjectBlockStudyGradeTypeId);
	 
    /**
	  * Find studyplandetail of a studyplan.
	  * @param map with subjectId, subjectblockId, studyplancardinaltimeunitId
	  * @return studyplandetail or null
	  */
	 StudyPlanDetail findStudyPlanDetailByParams(final Map<String, Object> map);

	 /**
	  * Find one StudyPlanDetail of a Studyplan.
	  * @param studyPlanDetailId id
	  * @return StudyplanDetail or null
	  */
	 StudyPlanDetail findStudyPlanDetail(final int studyPlanDetailId);
	 
	/**
	  * Add a studyplan to a Studyplan.
	  * @param studyPlanDetail the studyplandetail to add 
	 * @param request 
	  * @return the id of the newly created studyPlanCardinalTimeUnit
	  */
    void addStudyPlanDetail(final StudyPlanDetail studyPlanDetail, HttpServletRequest request);

    /**
     * Add a collection of studyPlanDetails in a single transaction.
     * @param studyPlanDetails
     * @param request
     */
    void addStudyPlanDetails(List<StudyPlanDetail> studyPlanDetails, HttpServletRequest request);
    
	/**
	 * Update a StudyPlanDetail of a Studyplan.
	 * @param studyPlanDetail the studyplandetail to update
	 * @return
	 */    
	void updateStudyPlanDetail(final StudyPlanDetail studyPlanDetail);

	/**
	* Delete a studyplan for a Studyplan.
	* @param studyPlanDetailId of the studyplandetail to delete 
	 * @param request 
	* @return
	*/    
	void deleteStudyPlanDetail(final int studyPlanDetailId, HttpServletRequest request);

	/**
	  * Find one studentAbsence of a Student.
	  * @param studentAbsenceId the id of the studentabsence
	  * @return studentAbsence
	  */    
	StudentAbsence findStudentAbsence(final int studentAbsenceId);

    /**
     * Add one studentAbsence to a Student.
     * @param studentAbsence the studentabsence to add
     * @return
     */    
    void addStudentAbsence(final StudentAbsence studentAbsence);

    /**
     * Update one studentAbsence for a Student.
     * @param studentAbsence the studentabsence to update
     * @return
     */    
    void updateStudentAbsence(final StudentAbsence studentAbsence);
    /**
     * Delete one studentAbsence from a Student.
     * @param studentAbsenceId id of the studentabsence to delete
     * @return
     */    
    void deleteStudentAbsence(final int studentAbsenceId, String writeWho);
    
    /**
     * Find one studentExpulsion of a Student.
     * @param studentExpulsionId the id of the studentExpulsion
     * @param preferredLanguage of user 
     * @return studentExpulsion
     */    
   StudentExpulsion findStudentExpulsion(final int studentExpulsionId
                                           , final String preferredLanguage);
   
   /**
    * Find the list of studentExpulsions of a Student.
    * @param studentId the id of the student
    * @param preferredLanguage of user 
    * @return list of studentExpulsions
    */    
   List<StudentExpulsion> findStudentExpulsions(final int studentId
           , final String preferredLanguage);

   /**
    * Add one studentExpulsion to a Student.
    * @param studentExpulsion the studentExpulsion to add
    * @return
    */    
   void addStudentExpulsion(final StudentExpulsion studentExpulsion);

   /**
    * Update one studentExpulsion for a Student.
    * @param studentExpulsion the studentExpulsion to update
    * @return
    */    
   void updateStudentExpulsion(final StudentExpulsion studentExpulsion);

    /**
     * Delete one studentExpulsion from a Student.
     * 
     * @param studentExpulsionId
     *            id of the studentExpulsion to delete
     */
    void deleteStudentExpulsion(final int studentExpulsionId, String preferredLanguage, String writeWho);

    /**
     * Find one studentStudentStatus of a Student.
     * @param studentStudentStatusId
     */
    StudentStudentStatus findStudentStudentStatus(final int studentStudentStatusId);
    
    /**
     * Add one studentStudentStatus to a Student.
     * @param studentStudentStatus the studentStudentStatus to add
     * @return
     */    
    void addStudentStudentStatus(final StudentStudentStatus studentStudentStatus);

    /**
     * Update one studentStudentStatus for a Student.
     * @param studentStudentStatus the studentStudentStatus to update
     * @return
     */    
    void updateStudentStudentStatus(final StudentStudentStatus studentStudentStatus);

    /**
     * Delete one studentStudentStatus from a Student.
     * @param studentStudentStatusId id of the studentStudentStatus to delete
     * @return
     */    
    void deleteStudentStudentStatus(final int studentStudentStatusId);

    /**
     * Get the latest (i.e. current) student status.
     */
    String getStudentStatus(Student student, String language);

    /**
     * Add a new Student.
     * @param student to add
     * @param opusUserRole to add
     * @param opusUser to add
     */    
    void addStudent(final Student student, final OpusUserRole opusUserRole,
                final OpusUser opusUser);

    /**
     * Update a Student.
     * @param student to update
     * @param opusUserRole to update
     * @param opusUser to update
     * @param oldPw used to check if password has changed:
     *        the password must only be updated when changed
     * @return pwText
     */
    void updateStudent(Student student, OpusUserRole opusUserRole, OpusUser opusUser, String oldPw);

    /**
     * Write student and student history.
     */
    void updateStudent(Student student);

    /**
     * Delete a Student.
     * @param preferredLanguage of user
     * @param studentId id of Student to delete
     */    
    void deleteStudent(final String preferredLanguage, final int studentId, final String writeWho);

    /**
     * Add a lookup to a Student.
     * @param StudentId id of Student
     * @param lookupCode of lookup-table
     * @param lookupType table-name of lookup-table
     * @return
     */    
//    void addLookupToStudent(final int studentId,final String lookupCode, final String lookupType);


  /**
     * Delete a lookup from a Student.
     * @param studentId id of Student
     * @param lookupCode of lookup-table
     * @param lookupType table-name of lookup-table
     * @return
     */    
    void deleteLookupFromStudent(final int studentId, final String lookupCode,
    		final String lookupType);

    /**
     * @param studyPlanId the id of the studyplan
     * @return List of StudyYears or null
     */   
//    List < ? extends StudyYear > findStudyYearsForStudyPlan(final int studyPlanId);

    /**
     * @param studyPlanId the id of the studyplan
     * @return List of SubjectBlocks or null
     */   
    List < SubjectBlock > findSubjectBlocksForStudyPlan(final int studyPlanId);

    /**
     * @param studyPlanCardinalTimeUnitId the id of the studyplancardinaltimeunit
     * @return List of SubjectBlocks or null
     */   
    List < SubjectBlock > findSubjectBlocksForStudyPlanCardinalTimeUnit(
    			final int studyPlanCardinalTimeUnitId);

    /**
     * @param map with studyPlanCardinalTimeUnitId id and active of the studyplancardinaltimeunit
     * @return List of Subjects or null
     */   
    List<Subject> findSubjectsForStudyPlanCardinalTimeUnit(final Map<String, Object> map);

    /**
     * Puts the given id into a map a calls {@link #findSubjectsForStudyPlanCardinalTimeUnit(Map)}.
     * 
     * @param subjectsForStudyPlanCardinalTimeUnitId
     * @return
     * @see #findSubjectsForStudyPlanCardinalTimeUnit(Map)
     */
    List<Subject> findSubjectsForStudyPlanCardinalTimeUnit(int subjectsForStudyPlanCardinalTimeUnitId);

    /**
     * @param studyPlanCardinalTimeUnitId
     * @return
     */
    List < Integer > findSubjectIdsForStudyPlanCardinalTimeUnitAndInBlocks(
            final int studyPlanCardinalTimeUnitId);

    /**
     * @param studyPlanId the id of the studyplan 
     * @return List of Subjects that are active or null
     */   
    List < Subject > findActiveSubjectsForStudyPlan(final int studyPlanId);

    /**
     * @param Map with studyplanId and cardinaltimeunitnumber to find active subjects for
     * @return List of Subjects that are active or null
     */   
    List < Subject > findActiveSubjectsForCardinalTimeUnit(final Map<String, Object> map);


    /**
     * @param Map with studyplanId, studyplancardinaltimeunitId and cardinaltimeunitnumber to find active subjects for
     * @return List of Subjects that are active for this studyplancardinaltimeunit or null
     */   
    List < Subject > findActiveSubjectsForStudyPlanCardinalTimeUnit(final Map<String, Object> map);

    /**
     * Upload a photo of the previous institution diploma of a student.
     * @param student add photo to this student
     * @return
     */
    void updatePreviousInstitutionDiplomaPhotograph(Student student);
    
    /* Methods concerning Thesis */
    
    /**
     * Find a thesis by its id
     * @param thesisId id of the thesis to find
     * @return a thesis object
     */
    Thesis findThesis(final int thesisId);
    
    /**
     * Check if a thesis exists with a given code
     * @param thesisCode to check for 
     * @return thesis or null
     */
    Thesis findThesisByCode(final String thesisCode);
    
    /**
     * @param studyPlanId
     * @return
     */
    Thesis findThesisForStudyPlan(final int studyPlanId);
    
    /**
     * Add a thesis to a studyPlan
     * @param thesis to add
     */
    void addThesis(final Thesis thesis);
    
    /**
     * Update a given thesis
     * @param thesis to update
     */
    void updateThesis(final Thesis thesis);
    
    /**
     * Delete a thesis from a studyPlan
     * @param thesisId id of thesis to delete
     */
    void deleteThesis(final int thesisId);

    /**
     * @param Map with studyplanId, cardinaltimeunitnumber, academicyear to find StudyPlanCardinalTimeUnit for
     * @return List of StudyPlanCardinalTimeUnits or null
     */   
    List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnitsByParams(final Map<String, Object> map);

    /**
     * Find the StudyPlanCardinalTimeUnits with the given ids.
     * @param studyPlanCardinalTimeUnitIds
     * @return
     */
    List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnits(final List<Integer> studyPlanCardinalTimeUnitIds);

    /**
     * 
     */
    List <Integer> findStudyPlanCardinalTimeUnitIds(final Map<String, Object> map);

    /**
     * @param studyplanId to find max ctunumber for
     * @return highest ctuNumber for this studyplan
     */   
    int findMaxCardinalTimeUnitNumberForStudyPlan(final int studyPlanId);

    /**
     * 
     * @param studyPlanId
     * @return
     */
    StudyPlanCardinalTimeUnit findMaxCardinalTimeUnitForStudyPlan(final int studyPlanId);

    /**
     * @param studyplanId to find min ctunumber for
     * @return lowest ctuNumber for this studyplan (typically 1)
     */   
    int  findMinCardinalTimeUnitNumberForStudyPlan(final int studyPlanId);

    /**
     * 
     * @param studyPlanId
     * @return
     */
    StudyPlanCardinalTimeUnit findMinCardinalTimeUnitForStudyPlan(final int studyPlanId);
    
    /**
     * Find the maximum cardinalTimeUnitNumber for a studyPlan and a studyGradeType
     * @param studyPlanId id of studyPlan
     * @param studyGradeTypeId id of studyGradeType
     * @return a cardinalTimeUnitNumber
     */
    int findMaxCardinalTimeUnitNumberForStudyPlanCTU(final int studyPlanId, final int studyGradeTypeId);

    /**
     * @param id to find StudyPlanCardinalTimeUnit for
     * @return StudyPlanCardinalTimeUnit or null
     */   
    StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnit(final int studyPlanCardinalTimeUnitId);

    /**
     * @param Map with studyplanId, studyGradeTypeId, cardinalTimeUnitNumber 
     * 			to find StudyPlanCardinalTimeUnit for
     * @return StudyPlanCardinalTimeUnit or null
     */   
    StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnitByParams(final Map<String, Object> map);

    /**
     * 
     * @param studyPlanId
     * @param studyGradeTypeId
     * @param cardinalTimeUnitNumber
     * @param progressStatusCode
     * @return
     */
    StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnitByParams(
            int studyPlanId, int studyGradeTypeId, int cardinalTimeUnitNumber);
    
    /**
     * Find the StudyPlanCardinalTimeUnit that a studyPlanDetail belongs to.
     * For now only used in the fee module for calculating the discount percentage
     * on a fee
     * @param studyPlanDetailId
     * @return studyPlanCardinalTimeUnit
     */
    StudyPlanCardinalTimeUnit findStudyPlanCtuForStudyPlanDetail(int studyPlanDetailId);

    /**
     * Add a studyPlanCardinalTimeUnit to a Studyplan.
     * 
     * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit to add
     * @param previousStudyPlanCardinalTimeUnit null if no previous exists
     * @param request
     * @return the id of the newly created studyPlanCardinalTimeUnit
     */
    void addStudyPlanCardinalTimeUnit(final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit,
            HttpServletRequest request);

	/**
	 * Update a studyPlanCardinalTimeUnit of a Studyplan.
	 * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit to update
	 * @return
	 */    
	void updateStudyPlanCardinalTimeUnit(final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

	/**
	* Delete a studyPlanCardinalTimeUnit for a Studyplan.
	* @param studyPlanCardinalTimeUnitId of the studyPlanCardinalTimeUnit to delete 
	 * @param writeWho
	 * @return
	*/    
	void deleteStudyPlanCardinalTimeUnit(final int studyPlanCardinalTimeUnitId, String writeWho);

    /**
     * @param  studyplanId to find StudyPlanCardinalTimeUnits for
     * @return List of StudyPlanCardinalTimeUnits (descending) or null
     */
    List<StudyPlanCardinalTimeUnit> findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(final int studyPlanId);

    /**
     * check if the student can be safely added or if a student already
     * exists with given student number, surname, firstnames, birthdate, etc.
     * @param student
     * @return an error string if this student is not safe to add, or an empty string otherwise.
     */
    String validateNewStudent(Student student, Locale currentLoc);

    /**
     * Find the corresponding personId for the given studentId.
     * @param studentId id of student to find
     * @return personId
     */    
    int findPersonId(int studentId);

    /**
     * Converts the given String into an int and calls <code>findPersonId(int studentId)</code>.
     * @param studentId
     * @return
     * @see #findPersonId(int)
     */
    int findPersonId(String studentId);

    /**
     * Returns a subset of given studyPlanIds for which already exist given target studyPlanCardinalTimeUnits.
     * @param map
     * @return
     */
//    List<Integer> findStudyPlansWhereExistsTargetSPCTU(Map<String, Object> map);

    /**
     * Add a studyPlanDetail for the given studyPlanCardinalTimeUnit
     * @param studyPlanCardinalTimeUnit
     * @param subjectBlockId
     * @param subjectId
     */
    void addStudyPlanDetail(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, int subjectBlockId, int subjectId, HttpServletRequest request);

    /**
     * In the given studyPlanCardinalTimeUnit,
     * of all studyPlanDetails that refer to subject blocks, 
     * retain only those for given subjectBlockIds.
     * Note: The studyPlanDetails that refer to subjects remain unchanged.
     * @param studyPlanCTU
     * @param subjectBlockIds
     * @param request object
     * @return
     */
    void retainSubjectBlockStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU,
            Collection<Integer> subjectBlockIds, HttpServletRequest request);

    /**
     * In the given studyPlanCardinalTimeUnit,
     * of all studyPlanDetails that refer to subjects, 
     * retain only those for given subjectIds.
     * Note: The studyPlanDetails that refer to subject blocks remain unchanged.
     * @param studyPlanCTU
     * @param subjectIds
     * @param request object
     * @return
     */
    void retainSubjectStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU,
            Collection<Integer> subjectIds, HttpServletRequest request);

    /**
     * Make sure there exist studyPlanDetails for each of the given subjectBlockIds.
     * Create the ones that do not exist yet.
     * @param studyPlanCTU
     * @param subjectBlockIds
     * @param request
     */
    void addMissingSubjectBlockStudyPlanDetails(
            StudyPlanCardinalTimeUnit studyPlanCTU,
            Collection<Integer> subjectBlockIds,
            HttpServletRequest request);

    /**
     * Make sure there exist studyPlanDetails for each of the given subjectIds.
     * Create the ones that do not exist yet.
     * @param studyPlanCTU
     * @param subjectIds
     * @param request
     */
    void addMissingSubjectStudyPlanDetails(
            StudyPlanCardinalTimeUnit studyPlanCTU,
            Collection<Integer> subjectIds,
            HttpServletRequest request);

    /**
     * Check if a studyPlanDetail pointing to a subject block already exists 
     * that includes the subject with the given subjectId.
     * This is to check if it is feasible to add a studyPlanDetail for the given subjectId
     * to the given studyPlan.
     * @param studyPlanId
     * @param subjectId
     * @return
     */
    boolean existStudyPlanDetail(int studyPlanId, int subjectId);

    /**
     * Find studyPlanIds.
     * @param map
     * @return
     */
    List<Integer> findStudyPlanIds(List<Integer> studyPlanCardinalTimeUnitIds);

    /**
     * 
     * @param map
     * @return
     */
    List<Integer> findStudyPlanIds(Map<String, Object> map);

    /**
     * Update the selected progress statuses
     * @param progressStatuses studyPlanCardinalTimeUnitId -> progressStatusCode
     * @param writeWho
     */
    void updateProgressStatuses(Map<Integer, String> progressStatuses, String preferredLanguage, String writeWho);
    
    /**
     * 
     * @param studyPlanId
     * @param oldProgressStatusCode
     * @param newProgressStatusCode
     * @param preferredLanguage
     * @param writeWho
     */
    void updateStudyPlanStatus(int studyPlanId, String oldProgressStatusCode, String newProgressStatusCode
                                , String preferredLanguage, String writeWho);
    
    /**
     * Create a new studyplancardinaltimeunit on top of the last one of a studyplan 
     * @param request
     * @param last studyplancardinaltimeunit with progress status filled
     * @param new academicyear for selected progress statuses
     * @return new studyplancardinaltimeunit with compulsory and repeated studyplandetails filled
     */
    StudyPlanCardinalTimeUnit generateNextStudyPlanCardinalTimeUnit(
    					StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, 
    					int newAcademicYearId, HttpServletRequest request);

    
    /**
     * find the studyplancardinaltimeunits for a studyplan with the lowest
     * cardinaltimeunitnumber (may be one or more, when repeated)
     * @param new studyplanid to find the studyplancardinaltimeunits for
     * @return null or list of studyplancardinaltimeunits
     */
    List < StudyPlanCardinalTimeUnit> findLowestStudyPlanCardinalTimeUnitsForStudyPlan(
    		int studyPlanId);
    
    /**
     * Find the compulsory subjects in this studyPlan that have not been passed yet
     * @param studyPlanId id of studyPlan of a student
     * @return list of subjectStudyGradeTypes or an empty list
     */
    List<FailedSubjectInfo> findAllFailedCompulsorySubjectsForStudyPlan(int studyPlanId);

    /**
     * fill studyplandetails for a new studyplancardinaltimeunit with
     * compulsory studyplandetails for new studygradetype / cardinaltimeunitnumber
     * and repeated (selected) studyplandetails based on the previous studyplancardinaltimeunit and its progress status
     * @param oldStudyPlanCardinalTimeUnit with progress status filled
     * @param newStudyPlanCardinalTimeUnit to fill compulsory and repeated studyplandetails for
     * @param request 
     * @param errors
     */
    void generateDetailsForStudyPlanCardinalTimeUnit(
    					StudyPlanCardinalTimeUnit oldStudyPlanCardinalTimeUnit, 
    					StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit,
    					HttpServletRequest request, Errors errors);

    /**
     * Create a list of studyplandetails for all new compulsory subjects and subjectblocks 
     * to be taken in the given studyplancardinaltimeunit
     * @param new studyplancardinaltimeunit to fill compulsory and repeated studyplandetails for
     * @param locale for errormessages
     * @param preferred Language for fetch of right details
     * @param flag major/minor
     * @param flag use of parttime studygradetypes
     * @return null-string or list of found studyplandetails
     */
    List <StudyPlanDetail> createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(
    		StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit,
    		Locale currentLoc,
    		String preferredLanguage,
    		String iMajorMinor,
    		String iUseOfPartTimeStudyGradeTypes);
    
    /**
     * Find the previous studyplancardinaltimeunit for a given studyplancardinaltimeunit
     * @param new studyplancardinaltimeunit 
     * @return null-string or previous studyplancardinaltimeunit 
     */
    StudyPlanCardinalTimeUnit findPreviousStudyPlanCardinalTimeUnit(
				StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit);

    /**
     * Find the next studyplancardinaltimeunit for a given studyplancardinaltimeunit
     * @param old studyplancardinaltimeunit 
     * @param flag use of parttime studygradetypes
     * @return null-string or next studyplancardinaltimeunit 
     */
    StudyPlanCardinalTimeUnit findNextStudyPlanCardinalTimeUnit(
				StudyPlanCardinalTimeUnit oldStudyPlanCardinalTimeUnit, 
				String iUseOfPartTimeStudyGradeTypes);

	/**
	 * Find studycardinaltimeunits of a student.
	 * @param studentId of student
	 * @return list of studycardinaltimeunits
	 */    
	List < StudyPlanCardinalTimeUnit > findStudyPlanCardinalTimeUnitsForStudent(final int studentId);
 	
	/**
	 * Find a specific Note
	 * @param noteId id of the note to find
	 * @param noteType the type of note to find; possible types are:
	 *        StudentActivity
	 *        StudentCareer
	 *        StudentPlacement
	 *        StudentCounseling
	 * @return a Note
	 */
//	Note findNote(final int noteId, final String noteType);
  
	/**
	 * Add a note
	 * @param note to add
	 * @param noteType the type of note to add; see doc on "findNote" for possible types
	 */
//	void addNote(final Note note, final String noteType);
   
 	/**
     * Update a note
     * @param note to update
     * @param noteType the type of note to update; see doc on "findNote" for possible types
     */
// 	void updateNote(final Note note, final String noteType);
  
 	/**
     * Delete a note
     * @param noteId id of note to delete
     * @param noteType the type of note to delete; see doc on "findNote" for possible types
     */
// 	void deleteNote(final int noteId, final String noteType);
 	
 	/**
     * Add an advisor to a thesis
     * @param thesisSupervisor to add
     */
    void addThesisSupervisor(final ThesisSupervisor thesisSupervisor);

    /**
     * Update a given thesis advisor
     * @param thesisSupervisor to update
     */
    void updateThesisSupervisor(final ThesisSupervisor thesisSupervisor);

    /**
     * Update whether or not all supervisors of a given thesis are principal supervisors
     * @param thesisId id of the thesis the supervisors are linked to
     * @param principal Y or N
     */
    void updateThesisSupervisorsPrincipal(final int thesisId, final String principal);
  
    /**
     * Delete a given supervisor
     * @param thesisSupervisorId id of the supervisor to delete
     */
    void deleteThesisSupervisor(final int thesisSupervisorId);
    
    /**
     * Delete all thesis supervisors of a given thesis
     * @param thesisId id of the thesis to which the supervisors to delete are linked
     */
    void deleteThesisSupervisorsByThesisId(int thesisId);
    
    /**
     * Find a thesis supervisor by it's id
     * @param id of the supervisor to find
     * @return a ThesisSupervisor
     */
    ThesisSupervisor findThesisSupervisor(final int id);
    
    /**
     * Find the thesis supervisors of a given thesis
     * @param thesisId id of the thesis to which the supervisors are linked
     * @return a list of ThesisSupervisors
     */
    List < ThesisSupervisor > findThesisSupervisorsByThesisId(final int thesisId);
    
    /**
     * Find a status of a thesis by it's id
     * @param thesisStatusId id of the thesisStatus
     * @return a ThesisStatus
     */
    ThesisStatus findThesisStatus(int thesisStatusId);
    
    /**
     * Find a list of statuses of a thesis
     * @param map with thesisId id of the thesis and preferredlanguage
     * @return a list of thesisStatuses
     */
    List < ThesisStatus > findThesisStatuses(final Map<String, Object> map);

    /**
     * Add a status to a thesis
     * @param thesisStatus to add
     */
    void addThesisStatus(ThesisStatus thesisStatus);

    /**
     * Update a given a status of a thesis
     * @param thesisStatus to update
     */
    void updateThesisStatus(ThesisStatus thesisStatus);

    /**
     * Delete a given  a status of a thesis
     * @param thesisStatusId id of the status to delete
     */
    void deleteThesisStatus(int thesisStatusId);
    
    /**
     * Delete all statuses of a given thesis
     * @param thesisId id of the thesis to which the statuses to delete belong
     */
    void deleteThesisStatusesByThesisId(int thesisId);
    
    /**
     * Find one penalty of a Student.
     * @param penaltyId the id of the penalty
     * @param preferredLanguage of user 
     * @return penalty
     */    
    Penalty findPenalty(final int penaltyId, final String preferredLanguage);
   
    /**
     * Find the list of penalties of a Student.
     * @param studentId the id of the student
     * @param preferredLanguage of user 
     * @return list of penalties
     */    
    List < Penalty > findPenalties(final int studentId
           , final String preferredLanguage);

    /**
     * Add one penalty to a Student.
     * @param penalty the penalty to add
     * @return
     */    
    void addPenalty(final Penalty penalty);

    /**
     * Update one penalty for a Student.
     * @param penalty the penalty to update
     * @return
     */    
    void updatePenalty(final Penalty penalty);
    
    /**
     * Delete one penalty from a Student.
     * @param penaltyId id of the penalty to delete
     * @return
     */    
    void deletePenalty(final int penaltyId);

    /**
     * Get the studentId that corresponds to the given studyPlanDetailId.
     * @param studyPlanDetailId
     */
    int findStudentIdForStudyPlanDetailId(final int studyPlanDetailId);

    /**
     * Get the classgroupId for a student coming from the studyPlanDetail
     * @param studyPlanDetailId
     * @return
     */
	Integer findStudentsClassgroupIdForStudyPlanDetailId(int studyPlanDetailId);
	
    /**
     * Get the studentId that corresponds to the given studyPlanCardinalTimeUnitId
     * @param studyPlanCardinalTimeUnitId
     * @return
     */
    int findStudentIdForStudyPlanCardinalTimeUnitId(final int studyPlanCardinalTimeUnitId);
    
    /**
     * Get the studentId for the given studentCode.
     * @param studentCode
     * @return
     */
    int findStudentIdForStudentCode(String studentCode);

    /**
     * Get the studentCode for the given studentId.
     * @param studentId
     * @return
     */
    String findStudentCodeForStudentId(final int studentId);

    /**
     * Indicate if the studyPlan has studyPlanCardinalTimeUnits other than the one specified by studyPlanCardinalTimeUnitId.
     * @param studyPlanId
     * @param studyPlanCardinalTimeUnitId
     * @return
     */
    boolean hasOtherStudyPlanCardinalTimeUnits(int studyPlanId, int studyPlanCardinalTimeUnitId);

    /**
     * Determine, given a progress status, which will be the studyIntensityCode of the next studyPlanCardinalTimeUnit.
     * @param progressStatus
     * @return studyIntensityCode
     */
    String getNextStudyIntensityCode(Lookup7 progressStatus);

    /**
     * Call {@link #setResultsPublished(StudyPlanCardinalTimeUnit)} for each StudyPlanCardinalTimeUnit.
     * @param studyPlanCardinalTimeUnits
     */
    void setResultsPublished(List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits);

    /**
     * Find out if results have been published for the given time period as of today.
     * The branchId is determined automatically.
     * The defaultResultsPublishDate is read from appConfig.
     * @see {@link #getResultsPublished(StudyPlanCardinalTimeUnit, int, Date, Date)}
     * @param studyPlanCardinalTimeUnit
     */
    void setResultsPublished(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit);

    /**
     * Find out if results have been published for the given time period at the given date.
     * @param spctu
     * @param branchId
     * @param date
     * @param defaultResultsPublishDate
     * @return
     */
    boolean getResultsPublished(StudyPlanCardinalTimeUnit spctu, int branchId, Date date, Date defaultResultsPublishDate);
    
    /**
     * If studentBalanceInformation is empty for the given student, it will be set.
     * @param student
     */
    void fillStudentBalanceInformation(Student student);

    /**
     * Find the student's identification number given a studyPlanId.
     * @param studyPlanId
     * @return
     */
    String findIdentificationNumberByStudyPlanId(int studyPlanId);

    /**
     * Extract from the given list those studyPlanDetails that are not exempted.
     * @param studyPlanDetails
     * @return a new list containing only the non-exempted studyPlanDetails
     */
    List<StudyPlanDetail> extractNonExempted(final List<StudyPlanDetail> studyPlanDetails);

}
