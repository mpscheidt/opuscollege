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

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StaffMemberFunction;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.domain.TestTeacher;

/**
 * @author move
 * Interface for StaffMember-related management methods.
 */
public interface StaffMemberManagerInterface {

    /**
     * Get a list of all staffMembers.
     * @param preferredLanguage of user
     * @return List of StaffMember objects
     */  
    List <  StaffMember > findAllStaffMembers(final String preferredLanguage);

    /**
     * Get a list of specified staffMembers.
     * @param map with parameters
     * @return List of StaffMember objects
     */  
    List <  StaffMember > findStaffMembers(final Map<String, Object> map);

    /**
     * 
     * @param map
     * @return
     */
    List < StaffMember > findUnboundTeachers(final Map<String, Object> map);

    /**
     * Find a staffMember.
     * @param preferredLanguage of user
     * @param staffMemberId id of staffMember to find
     * @return StaffMember
     */    
    StaffMember findStaffMember(final String preferredLanguage, final int staffMemberId);

    /**
     * Find a staffMember, based on personId.
     * @param personId id of staffMember to find
     * @return StaffMember
     */    
    StaffMember findStaffMemberByPersonId(final int personId);

    /**
     * Find the corresponding staffMemberId for the given personId.
     * @param personId
     * @return
     */
    int findStaffMemberIdByPersonId(final int personId);

    /**
     * Find a staffMember, based on staffMemberCode.
     * @param preferredLanguage of user
     * @param staffMemberCode of staffMember to find
     * @return StaffMember
     */    
    StaffMember findStaffMemberByCode(final String preferredLanguage, final String staffMemberCode);

    /**
     * Find a staffMember, based on parameters.
     * @param parameters for the staffmember to find
     * @return StaffMember or null
     */    
//  MP 2015-01-03: Apparently not used anymore
//    StaffMember findStaffMemberByParams(final Map<String, Object> map);

    /**
     * Find organizationalUnit to which the staffMember belongs.
     * @param personId of staffMember
     * @return OrganizationalUnit
     */    
    OrganizationalUnit findOrganizationalUnitForStaffMember(final int personId);

    /**
     * Find contracts of a staffMember.
     * @param staffMemberId id of staffMember
     * @return list of contracts
     */    
    List<Contract> findContractsForStaffMember(final int staffMemberId);

    /**
     * Find subjects for a staffMember.
     * @param staffMemberId id of staffMember of whom to find the taught subjects
     * @return List of subjectteacher objects or null.
     */  
    List<SubjectTeacher> findSubjectsForStaffMember(final int staffMemberId);

    /**
     * Find examinations for a staffMember.
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
     * Find functions of a stafMember.
     * @param staffMemberId id of staffMember
     * @return list of staffmemberfunctions
     */    
    List <  StaffMemberFunction > findFunctionsForStaffMember(final int staffMemberId);

    /**
     * Add a new staffMember.
     * @param staffMember to add
     * @param staffOpusUserRole to add
     * @param staffOpusUser to add
     * @return id of newly created staff member
     */
    int addStaffMember(final StaffMember staffMember, final OpusUserRole staffOpusUserRole,
            final OpusUser staffOpusUser);

    /**
     * Update a staffMember and the opusUser (to update the user's password).
     * 
     * @param staffMember to update
     * @param staffOpusUser to update
     * @param oldPw value of the password before updating;
     *        used to check if the password has been changed; if so a textfile 
     *        showing the new account data is opened
     */
    void updateStaffMemberAndOpusUser(final StaffMember staffMember, final OpusUser staffOpusUser, final String oldPw);

    /**
     * Update the staff member only.
     * 
     * @param staffMember
     */
    void updateStaffMember(final StaffMember staffMember);

    /**
     * Delete a staffMember.
     * @param preferredLanguage of user
     * @param staffMemberId id of staffMember to delete
     */    
    void deleteStaffMember(final String preferredLanguage, final int staffMemberId, final String writeWho);

    /**
     * Add a lookup to a stafMember.
     * @param staffMemberId id of staffMember
     * @param lookupCode of lookup-table
     * @param lookupType table-name of lookup-table
     * @return
     */    
    //    void addLookupToStaffMember(final int staffMemberId,final String lookupCode,
    //					    final String lookupType);

    /**
     * Add a function to a stafMember.
     * @param staffMemberId id of staffmember
     * @param functionCode  code of function
     * @param functionLevelCode cod of level of function
     * @return
     */    
    void addFunctionToStaffMember(final int staffMemberId, final String functionCode,
            final String functionLevelCode);

    /**
     * Delete a lookup from a stafMember.
     * @param staffMemberId id of staffMember
     * @param lookupCode of lookup-table
     * @param lookupType table-name of lookup-table
     * @return
     */    
    void deleteLookupFromStaffMember(final int staffMemberId, final String lookupCode,
            final String lookupType);

    /**
     * Find the corresponding personId for the given staffMemberId.
     * @param staffMemberId
     * @return personId
     */    
    int findPersonId(int staffMemberId);

    /**
     * Converts the given String into an int and calls <code>findPersonId(int staffMemberId)</code>.
     * @param staffMemberId
     * @return
     * @see  #findPersonId(int)
     */
    int findPersonId(String staffMemberId);

    /**
     * TODO: might be integrated with findAllDirectors()
     * Returns a list of persons who are staffmembers.
     * used to find (possible) contacts of studies
     * @param organizationalUnitId
     * @return List of StaffMember objects
     */  
    List < StaffMember > findAllContacts(final int organizationalUnitId);





    /**
     * Check if a staffmember with the given staffMemberCode exists with a different staffMemberId than the given one.
     * @param staffMemberCode
     * @param staffMemberId
     * @return
     */
    boolean alreadyExistsStaffMemberCode(String staffMemberCode, int staffMemberId);

    /**
     * Get the number of staffmembers that match the given parameters.
     * @param map
     * @return
     */
    int countStaffMembers(Map<String, Object> map);

}
