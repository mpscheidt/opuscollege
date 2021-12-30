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

import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Lookup;


/**
 * @author u606118
 *
 */
public interface AddressManagerInterface {
    
    /**
     * find the address with the id given by addressId.
     * This can be the address of an organizationalUnit, a staffMember
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
    Address findAddressByPersonId(final String addressTypeCode, final int personId);

    /**
     * find the address with the id given by organizationalUnitId and addressTypeId.
     * @param addressTypeCode of the address to be found
     * @param organizationalUnitId of the address to be found
     * @return Address
     */
    Address findAddressByOrganizationalUnitId(final String addressTypeCode
                                                , final int organizationalUnitId);

    /**
     * find the address with the id given by organizationalUnitId and addressTypeId.
     * @param addressTypeCode of the address to be found
     * @param studyId of the address to be found
     * @return Address
     */
    Address findAddressByStudyId(final String addressTypeCode, final int studyId);

    /**
     * find all addresses of the given entity.
     * @param map contains the following parameters:
     * entity:  the object to which the addresses belong, e.g.
     *          study, organizational unit, staffmember, student 
     * id:      id of the entity (e.g. studyId, organizationalUnitId
     *          or personId).
     * @return List of Addresses
     */
    List<Address> findAddressesForEntity(final Map<String, Object> map);
    
    /**
     * find all addresstypes that are allowed to be assigned to an address.
     * Depending on the entity the address belongs to (e.g. study, staffmember,
     * organizational unit) this list may vary. Also an addresstype that is already
     * assigned to an address of the given entity, is not allowed.
     * 
     * @param map contains the following parameters:
     * preferredLanguage:   the user's language of choice
     * tableName:           addressType; addressTypes are Lookup-objects, therefore 
     *                      the tableName is needed to determine which table needs to
     *                      be queried.
     * @return list of Lookups (addressTypes)
     */
	List<Lookup> findUnboundAddressTypes(final Map<String, Object> map);

    Address findParentAddress(final int organizationalUnitId);

    /**
     * add a new address. 
     * @param address to add
     */
    void addAddress(Address address);

    /**
     * Add a list of addresses to the database.
     * @param addresses
     */
    void addAddresses(List<Address> addresses);

    /**
     * update the address.
     * @param address to change
     */
    void updateAddress(Address address);

    /**
     * delete the address.
     * @param addressId to delete
     */
    void deleteAddress(int addressId);
    
    /**
     * 
     * @param studyId
     */
    void deleteAddressesForStudy(final int studyId);

}
