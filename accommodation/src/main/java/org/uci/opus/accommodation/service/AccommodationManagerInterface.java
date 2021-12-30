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
 * The Original Code is Opus-College accommodation module code.
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
package org.uci.opus.accommodation.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.accommodation.domain.AccommodationResource;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.domain.StudentAccommodationResource;
import org.uci.opus.college.domain.Student;

public interface AccommodationManagerInterface {
	
	void addStudentAccommodation(StudentAccommodation studentAccommodation);

	int updateStudentAccommodation(StudentAccommodation studentAccommodation, HttpServletRequest request);
	
	void deallocate(StudentAccommodation studentAccommodation, HttpServletRequest request);
	
    StudentAccommodation findStudentAccommodation(int id);

    /**
     * The method is used to find information on Accommodated Students in a given academicYear<br>
     * @return  null if no result was found
     */
	List<Student> findAccommodatedStudents(int academicYearId);

    /**
     * The method is used to find information on Non-Accommodated Students in a given academicYear<br>
     * @return  null if no result was found
     */
	List<Student> findNonAccommodatedStudents(int academicYearId);

    /**
     * The method is used to find information on Approved Students to be granted Accommodation in a
     * given academicYear<br>
     * @return  null if no result was found
     */
	List<Student> findApprovedAccommodationStudents(int academicYearId);

    /**
     * The method is used to find information on Non-Approved Students to be granted (or not
     * granted) Accommodation in a given academicYear<br>
     * @return null if no result was found
     */
	List<Student> findNonApprovedAccommodationStudents(int academicYearId);

	StudentAccommodation findStudentAccommodationByParams(Map<String, Object> criteria);
	
	List<StudentAccommodation> findStudentAccommodationsByParams(Map<String, Object> criteria);

	int deleteStudentAccommodation(int id, String writeWho);

	List<StudentAccommodation> findApplicantsByParams(
			Map<String, Object> params);
	
	List<StudentAccommodation> findStudentAccommodationsToReAllocateByParams(
			Map<String, Object> params);

    public abstract int getAcademicYearId(int studentId);
	
    void allocateAccommodationResource(StudentAccommodationResource resource);
    void deallocateAccommodationResource(int studentAccommodationResourceId,Date dateReturned, String commentWhenReturning);
    StudentAccommodationResource getStudentAccommodationResource(int id);
    List<StudentAccommodationResource> getStudentAccommodationResources(int studentAccommodationId);
    
    /**
     * The method is used to retrieve all available Accommodaiton Resources/Items
     * @return
     */
    List<AccommodationResource> getAccommodationResources();
    
    void deleteStudentAccommodationResource(int id);
}
