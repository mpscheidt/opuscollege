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
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Student;

public interface StudentMapper {

    /**
     * @param preferredLanguage
     *            language of user's choice
     * @return list of Student objects or null.
     */
    List<Student> findAllStudents(String preferredLanguage);

    /**
     * Get the student count.
     * 
     * @param map
     * @return
     */
    int findStudentCount(Map<String, Object> map);

    /**
     * Get a list of all Students depending on parameters in Map.
     * 
     * @param map
     *            with parameters
     * @return List of Student objects
     */
    List<Student> findStudents(Map<String, Object> map);

    /**
     * Get a list of students with their study plans, and the CTU results (if existing) and the subject results (if existing).
     * 
     * @param map
     * @return
     */
    List<Student> findStudents_WithCTUAndSubjectResults(Map<String, Object> map);

    /**
     * @param preferredLanguage
     *            language of user's choice
     * @param studentId
     *            of Student to find
     * @return Student object or null when there was nothing found.
     */
    Student findStudent(@Param("preferredLanguage") String preferredLanguage, @Param("studentId") int studentId);

    /**
     * Find a plain Student object without aggregated objects. This is useful if no preferredLanguage parameter is to be used.
     * 
     * @param studentId
     * @return
     */
    Student findPlainStudent(int studentId);

    /**
     * Find a student to which a studyPlanCardinalTimeUnit belongs
     * 
     * @param studyPlanCtuId
     *            id of the studyPlanCardinalTimeUnit
     * @return a plain Student object without aggregated objects.
     */
    Student findPlainStudentByStudyPlanCtuId(int studyPlanCtuId);

    /**
     * @param personId
     *            for whom to find the Student
     * @return Student object or null when there was nothing found.
     */
    Student findStudentByPersonId(int personId);

    Student findStudentById(int studentId);

    /**
     * @param preferredLanguage
     *            language of user's choice
     * @param studentCode
     *            of Student to find
     * @return Student object or null when there was nothing found.
     */
    Student findStudentByCode(String studentCode);

    /**
     * Check if a student exists with the given studentCode and a different studentId than the given one.
     * 
     * @param studentCode
     * @param studentId
     * @return
     */
    boolean alreadyExistsStudentCode(@Param("studentCode") String studentCode, @Param("studentId") int studentId);

    /**
     * Find a student, based on parameters.
     * 
     * @param parameters
     *            for the student to find
     * @return Student or null
     */
    Student findStudentByParams(Map<String, Object> map);

    /**
     * Find a student, based on parameters where none of the parameters is obligatly
     * 
     * @param parameters
     *            for the student to find
     * @return Student or null
     */
    Student findStudentByParams2(Map<String, Object> map);

    /**
     * Finds a student including the study plan details
     * 
     * @param map
     */
    List<Student> findStudentsByStudyGradeAcademicYear(Map<String, Object> map);

    /**
     * @param personId
     *            of Student to find the addresses from
     * @return List of address objects or null.
     */
    List<Address> findAddressesForStudent(int personId);

    /**
     * @param student
     *            object
     * @return studentId
     */
    void addStudent(Student student);

    /**
     * @param student
     *            of whom to update the Student information
     */
    void updateStudent(Student student);

    /**
     * @param studentId
     *            id of student info to delete
     */
    void deleteStudent(int studentId);

    /**
     * @param studentId
     *            id of the student to delete in the studyplan
     * @return
     */
    void deleteStudentInStudyPlan(int studentId);

    /**
     * Upload a photo of the previous institution diploma of a student.
     * 
     * @param student
     *            add previnstitutiondiplomaphotograph to this student
     * @return
     */
    void updatePreviousInstitutionDiplomaPhotograph(Student student);

    /**
     * Find the corresponding personId for the given studentId.
     * 
     * @param studentId
     *            id of student to find
     * @return personId
     */
    Integer findPersonId(int studentId);

    void addStudentHistory(@Param("Student") Student student, @Param("operation") String operation);

    /**
     * Get the studentId that corresponds to the given studyPlanDetailId.
     * 
     * @param studyPlanDetailId
     */
    Integer findStudentIdForStudyPlanDetailId(int studyPlanDetailId);

    /**
     * Get the studentId that corresponds to the given studyPlanCardinalTimeUnitId
     * 
     * @param studyPlanCardinalTimeUnitId
     */
    Integer findStudentIdForStudyPlanCardinalTimeUnitId(int studyPlanCardinalTimeUnitId);

    /**
     * Get the studentId for the given studentCode.
     * 
     * @param studentCode
     * @return
     */
    Integer findStudentIdForStudentCode(String studentCode);

    /**
     * Get the studentCode for the given studentId.
     * 
     * @param studentId
     * @return
     */
    String findStudentCodeForStudentId(int studentId);

    /**
     * Get the number of subjects in the given studyPlanCardinalTimeUnit. This counts all subjects, including those in subject blocks.
     * 
     * @param studyPlanCardinalTimeUnitId
     * @return
     */
    int findNumberOfSubjectsForStudyPlanCTU(int studyPlanCardinalTimeUnitId);

    /**
     * Does the student with the given studentId have a studentCode?
     */
    boolean hasStudentCode(int studentId);

    /**
     * Find the student's identification number given a studyPlanId.
     * 
     * @param studyPlanId
     * @return
     */
    String findIdentificationNumberByStudyPlanId(int studyPlanId);

    /**
     * Ler os estudantes que estao no curso indicado.
     * 
     * @param studyId
     * @return
     */
    List<Student> findStudentsForStudy(int studyId);

}
