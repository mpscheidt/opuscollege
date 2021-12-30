/*******************************************************************************
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
 * The Original Code is Opus-College scholarship module code.
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
 ******************************************************************************/
package org.uci.opus.scholarship.persistence;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Student;
import org.uci.opus.scholarship.domain.ScholarshipStudent;

public interface ScholarshipStudentMapper {

    /**
     * Returns a List of scholarship-students (so only students who applied for !!)
     * @param map with parameters of which list to find exactly
     * @return List of scholarshipstudents or null
     */
    List<ScholarshipStudent> findAllScholarshipStudents(Map<String, Object> map);

    List<ScholarshipStudent> findScholarshipStudents(Map<String, Object> map);

    /**
     * Returns a student by his/her scholarshipStudentId.
     * @param scholarshipStudentId id of the student to find
     * @return Student object or null
     */    
    Student findStudentByScholarshipStudentId(int scholarshipStudentId);

    /**
     * Returns a list of scholarshipstudents for a bank by it's id.
     * @param bankId id of the bank for which scholarshipstudents to find
     * @return List of ScholarshipStudent objects or null
     */
    List<ScholarshipStudent> findScholarshipStudentsForBank(int bankId);

    /**
     * Returns a student by his/her id.
     * @param studentId id of the student to find
     * @return ScholarshipStudent object or null
     */
    ScholarshipStudent findScholarshipStudent(int studentId);
    
    /**
     * Updates a complete scholarshipstudent.
     * @param scholarshipstudent object
     * @return
     */    
    void updateScholarshipStudent(ScholarshipStudent scholarshipStudent);

    /**
     * Updates the scholarhip-attribute of a student.
     * 
     * @param studentId
     *            id of the student
     * @param appliedForScholarship
     *            value of this attribute
     */
    void updateAppliedForScholarshipForStudent(Map<String, Object> map);

    /**
     * Add a complete scholarshipstudent.
     * @param scholarshipstudent object
     * @return id of the new scholarshipstudent
     */    
    void addScholarshipStudent(ScholarshipStudent scholarshipStudent);

    /**
     * Delete a complete scholarshipstudent.
     * @param scholarshipStudentId
     * @return
     */    
    void deleteScholarshipStudent(int scholarshipStudentId);

}
