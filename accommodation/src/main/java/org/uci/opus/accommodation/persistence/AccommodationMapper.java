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
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
package org.uci.opus.accommodation.persistence;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.accommodation.domain.AccommodationResource;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.domain.StudentAccommodationResource;

public interface AccommodationMapper {

    /**
     * The method is used to persist information on StudentAccommodation
     * 
     * @param studentAccommodation
     * @return
     */
    void addStudentAccommodation(StudentAccommodation studentAccommodation);

    /**
     * The method is used to update information on StudentAccommodation
     * 
     * @param studentAccommodation
     * @return
     */
    int updateStudentAccommodation(StudentAccommodation studentAccommodation);

    /**
     * The method is used to delete information on StudentAccommodation It returns the number of
     * affected records
     */
    int deleteStudentAccommodation(int id);

    /**
     * The method is used to find information on a specified StudentAccommodation<br>
     * It returns null if no result was found
     * 
     * @param id
     * @return
     */
    StudentAccommodation findStudentAccommodation(int id);

    /**
     * The method is used to find information on StudentAccommodations<br>
     * It returns null if no result was found
     * 
     * @param params
     * @return
     */
    List<StudentAccommodation> findStudentAccommodationsByParams(Map<String, Object> params);

    /**
     * The method is used to find information on Accommodated Students.
     */
    List<String> findAccommodatedStudentsByParams(Map<String, Object> map);

    /**
     * The method is used to retrieve all the applicants for accommodation
     * 
     * @param criteria
     * @return
     */
    List<StudentAccommodation> findApplicantsByParams(Map<String, Object> criteria);
    
    /**
     * The method is used to retrieve a collection of StudentAccommodation Objects using customized
     * parameters. It retrieves all students who were once accommodated depending on the parameters
     * being passed It returns null if no match was found
     * 
     * @param criteria
     * @return
     */
    List<StudentAccommodation> findStudentAccommodationsToReAllocateByParams(Map<String, Object> params);

    List<String> findNonAccommodatedStudentsByParams(Map<String, Object> map);
    
    List<String> findApprovedAccommodationStudentsByParams(Map<String, Object> map);
    
    List<String> findNonApprovedAccommodationStudentsByParams(Map<String, Object> map);
    
    void updateStudentAccommodationHistory(@Param("studentAccommodation") StudentAccommodation studentAccommodation, @Param("operation") String operation);

    /**
     * The method is used to allocate accommodation resources to a student;
     * 
     * @param resource
     */
    void allocateAccommodationResource(StudentAccommodationResource resource);

    /**
     * The method is used to update the details for StudentAccommodationResource i.e unallocating
     * studentAccommodationResource
     * 
     * @param studentAccommodationResourceId
     * @param dateReturned
     * @param commentWhenReturning
     */
    void deallocateAccommodationResource(@Param("id") int studentAccommodationResourceId, @Param("dateReturned") Date dateReturned, @Param("commentWhenReturning") String commentWhenReturning);

    /**
     * Deletes the resource which was allocated to a student
     * 
     * @param id
     */
    void deleteStudentAccommodationResource(int id);

    /**
     * The method is used to retrieve all available Accommodaiton Resources/Items
     * 
     * @return
     */
    List<AccommodationResource> getAccommodationResources();
    
    /**
     * The method is used to retrieve all the resources which had been assigned to the student
     * during a specific period
     * 
     * @param studentAccommodationId
     * @return
     */
    List<StudentAccommodationResource> findStudentAccommodationResourceByStudentAccommodationId(int studentAccommodationId);

    List<StudentAccommodationResource> findStudentAccommodationResourceByParams(Map<String, Object> map);


}
