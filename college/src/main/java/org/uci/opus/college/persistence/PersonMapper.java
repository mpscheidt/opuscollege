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

import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.StaffMember;

/**
 * @author move
 *
 */
public interface PersonMapper {
	
    /**
     * Returns a person by his/her id.
     * @param personId id of the person to find
     * @return Person object or null
     */
    Person findPersonById(final int personId);
    
    /**
     * Returns a person by his/her code.
     * @param personCode code of the person to find
     * @return Person object or null
     */
    Person findPersonByCode(final String personCode);
    
    /**
     * Find all persons who could become Directors of organizationalUnits.
     * These are all staffmembers within an institution.
     * @param map with institutionId,branchid, orgunitid,educationtype
     * @return List of possible Directors (staffmember objects)
     */
    List<StaffMember> findDirectors(final Map<String, Object> map);

    /**
     * Returns a list of persons who are staffmembers.
     * @param institutionId where the directors may reside
     * @return List of Person objects
     */
//    List<StaffMember> findAllDirectors(final int institutionId);    
   
    /**
     * @param person to add.
     */
    void addPerson(final Person person);

    /**
     * @param person to update.
     */
    void updatePerson(final Person person);

    /**
     * @param personId id of person of whom to delete
     */  
    void deletePerson(final int personId);

    /**
     * Upload a photo of a staffmember/student.
     * @param person add photo to this person
     * @return
     */
    void updatePersonPhotograph(Person person);

    void UpdatePersonHistory(Person person, String operation);
    
}

