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

/**
 * @author move
 */
public interface AddressMapper {
    
    /**
     * find the address with the id given by addressId.
     * This could be the address of an organizationalUnit, a staffMember
     * or a student
     * @param addressId the id of the address to be found
     * @return Address
     */
    Address findAddress(int addressId);
    
    /**
     * find the address with the id given by personId and addressTypeId.
     * @param addressTypeCode of the address to be found
     * @param personId of the address to be found
     * @return Address
     */
    Address findAddressByPersonId(@Param("addressTypeCode") final String addressTypeCode, @Param("personId") final int personId);

    /**
     * find the address with the id given by organizationalUnitId and addressTypeId.
     * @param addressTypeCode of the address to be found
     * @param organizationalUnitId of the address to be found
     * @return Address
     */
    Address findAddressByOrganizationalUnitId(@Param("addressTypeCode") final String addressTypeCode
                                            , @Param("organizationalUnitId") final int organizationalUnitId);

    /**
     * find the address with the id given by organizationalUnitId and addressTypeId.
     * @param addressTypeCode of the address to be found
     * @param studyId of the address to be found
     * @return Address
     */
    Address findAddressByStudyId(@Param("addressTypeCode") final String addressTypeCode, @Param("studyId") final int studyId);

    /**
     * find all addresses of the given entity.
     * @param map contains the following parameters:
     * entity:  the object to which the addresses belong, e.g.
     *          study, organizational unit, staffmember, student 
     * id:      id of the entity (e.g. studyId, organizationalUnitId
     *          or personId).
     * @return List of Addresses
     */
    List < Address > findAddressesForEntity(final Map<String, Object> map);

    /**
     * insert the given address.
     * This could be the address of an organizationalUnit, a staffMember
     * or a student
     * @param address the address to be inserted
     */
    void addAddress(Address address);
    
    /**
     * update the given address.
     * This could be the address of an organizationalUnit, a staffMember
     * or a student
     * @param address the address to be updated
     */
    void updateAddress(Address address);

    /**
     * delete the given address.
     * This could be the address of an organizationalUnit, a staffMember
     * or a student
     * @param addressId the address to be deleted
     */
    void deleteAddress(final int addressId);
    
    /**
     * delete addresses belonging to a study.
     * @param studyId id of the study of which to delete the addresses
     */
    void deleteAddressesForStudy(final int studyId); 
    
    /**
     * delete addresses belonging to an organizational unit.
     * @param organizationalUnitId id of the organizational unit of which to delete the addresses
     */
    void deleteAddressesForOrganizationalUnit(final int organizationalUnitId); 

    /**
     * @param personId id of the person
     */  
    void deleteStudentInAddress(final int personId);

    List<Address> findAddressesForStudent(int personId);
}
