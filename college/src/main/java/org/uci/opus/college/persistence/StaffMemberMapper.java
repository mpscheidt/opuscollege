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
import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.TestTeacher;


/**
 * @author move
 *
 */
public interface StaffMemberMapper {

    /**
     * @param map
     * @return list of Staffmember objects or null.
     */  
    List < StaffMember > findAllStaffMembers(Map<String, Object> map);

    /**
     * find a list of staffmembers of an institution, branch or organizational unit
     * depending on the given parameters. 
     * @param map might contain the following parameters:
     *        institutionId
     *        branchId
     *        organizationalUnitId
     * @return list of staffmembers
     */
    List<StaffMember> findStaffMembers(final Map<String, Object> map);

    /**
     * @param preferredLanguage language of user's choice
     * @param staffMemberId of staffMember to find
     * @return StaffMember object or null when there was nothing found.
     */
    StaffMember findStaffMember(@Param("preferredLanguage") String preferredLanguage, @Param("staffMemberId") int staffMemberId);

    /**
     * Get staff member without result map so that no preferredLanguage value is necessary.
     * 
     * @param staffMemberId
     * @return
     */
    StaffMember findStaffMemberByStaffMemberId(int staffMemberId);

    /**
     * @param personId for whom to find the staffMember
     * @return StaffMember object or null when there was nothing found.
     */
    StaffMember findStaffMemberByPersonId(final int personId);

    /**
     * Find the corresponding staffMemberId for the given personId.
     * @param personId
     * @return
     */
    Integer findStaffMemberIdByPersonId(final int personId);

    /**
     * @param preferredLanguage language of user's choice
     * @param staffMemberCode of staffMember to find
     * @return StaffMember object or null when there was nothing found.
     */
    StaffMember findStaffMemberByCode(@Param("preferredLanguage") String preferredLanguage, @Param("staffMemberCode") String staffMemberCode);

    /**
     * Check if a staffMember with the given staffMemberCode exists with a different staffMemberId than the given one.
     * @param staffMemberCode
     * @param staffMemberId
     * @return
     */
    boolean alreadyExistsStaffMemberCode(@Param("staffMemberCode") String staffMemberCode, @Param("staffMemberId") int staffMemberId);

    /**
     * Find a staffMember, based on parameters.
     * @param parameters for the staffmember to find
     * @return StaffMember or null
     */
//    MP 2015-01-03: Apparently not used anymore
//    StaffMember findStaffMemberByParams(final Map<String, Object> map);

    /**
     * Get the number of staffmembers that match the given parameters.
     * @param map
     * @return
     */
    int countStaffMembers(Map<String, Object> map);

    /**
     * @param personId id of person of whom to find the organizationalUnit he belongs to
     * @return OrganizationalUnit
     */    
    OrganizationalUnit findOrganizationalUnitForStaffMember(final int personId);

    /**
     * @param staffMemberId id of staffMember of whom to find the existing contracts
     * @return List of contract objects or null.
     */  
    List <Contract> findContractsForStaffMember(final int staffMemberId);

    /**
     * @param staffMemberId id of staffMember of whom to find the existing functions
     * @return List of StaffMemberFunction objects or null.
     */  
    List<StaffMemberFunction> findFunctionsForStaffMember(final int staffMemberId);

    /**
     * @param personId of whom to find the addresses
     * @return List of address objects or null.
     */
    List<Address> findAddressesForStaffMember(final int personId);

    /**
     * @param staffMemberId id of staffMember of whom to find the existing contracts
     * @return List of subject objects or null.
     */
    List<SubjectTeacher> findSubjectsForStaffMember(final int staffMemberId);

    /**
     * @param staffMemberId id of staffMember of whom to find the taught examinations
     * @return List of examination objects or null.
     */
    List<ExaminationTeacher> findExaminationsForStaffMember(final int staffMemberId);

    /**
     * 
     * @param staffMemberId
     * @return
     */
    List<TestTeacher> findTestsForStaffMember(int staffMemberId);
    
    /**
     * @param staffMemberId id of the staffMember
     * @param functionCode  code of the function
     * @param functionLevelCode level code of the function
     * @return
     */
    void addFunctionToStaffMember(@Param("staffMemberId") int staffMemberId, @Param("functionCode") String functionCode, @Param("functionLevelCode") String functionLevelCode);

    /**
     * @param staffMember object
     * @return the id of the newly created staff member
     */  
    int addStaffMember(StaffMember staffMember);

    /**
     * 
     * @param staffMember
     * @param operation
     */
    void addStaffMemberHistory(@Param("StaffMember") StaffMember staffMember, @Param("operation") String operation);

    /**
     * @param staffMember of whom to update the staffMember information 
     */  
    void updateStaffMember(final StaffMember staffMember);

    /**
     * @param personId
     */
// MP 2015-01-03 apparently not used anywhere
//    void deleteStaffMemberInPerson(final int personId, String writeWho);

    /**
     * @param staffMemberId id of staffMember info to delete
     */
    void deleteStaffMember(final int staffMemberId);

    /**
     * @param staffMemberId id of the staffmember
     * @return 
     */  
    void deleteStaffMemberInFunction(final int staffMemberId);

    /**
     * @param staffMemberId id of the staffmember
     */  
    void deleteStaffMemberInContract(final int staffMemberId);

    /**
     * @param personId id of the person
     */  
    void deleteStaffMemberInAddress(final int personId);

    /**
     * Find the corresponding personId for the given staffMemberId.
     * @param staffMemberId
     * @return personId
     */    
    Integer findPersonId(int staffMemberId);

    /**
     * TODO: might be integrated with personDao.findAllDirectors()
     * Returns a list of persons who are staffmembers.
     * used to find (possible) contacts of studies
     * @param organizationalUnitId id of the organizational unit
     * @return List of StaffMember objects
     */  
    List < StaffMember > findAllContacts(final int organizationalUnitId);


}

