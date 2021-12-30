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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.persistence.AddressMapper;
import org.uci.opus.util.ExtendedArrayList;

/**
 * @author J. Nooitgedagt
 *
 */
public class AddressManager implements AddressManagerInterface {

    private static Logger log = LoggerFactory.getLogger(AddressManager.class);

    @Autowired private AddressMapper addressMapper;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;


    @Override
    public Address findAddress(final int addressId) {
        Address address = addressMapper.findAddress(addressId);
        return address;
    }

    @Override
    public Address findAddressByPersonId(final String addressTypeCode, final int personId) {
        Address address = addressMapper.findAddressByPersonId(addressTypeCode, personId);
        return address;
    }


    @Override
    public Address findAddressByOrganizationalUnitId(final String addressTypeCode
            , final int organizationalUnitId) {
        Address address = addressMapper.findAddressByOrganizationalUnitId(addressTypeCode
                , organizationalUnitId);
        return address;
    }

    @Override
    public Address findAddressByStudyId(final String addressTypeCode, final int studyId) {
        Address address = addressMapper.findAddressByStudyId(addressTypeCode, studyId);
        return address;
    }

    @Override
    public List < Address > findAddressesForEntity(final Map<String, Object> map) {
        List < Address >  addresses = addressMapper.findAddressesForEntity(map);
        return addresses;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List < Lookup > findUnboundAddressTypes(final Map<String, Object> map) {

        List < Lookup > allAddressTypes = new ArrayList < >();
        List < Address > allBoundAddresses = null;
        List < Lookup > allUnboundAddressTypes = new ExtendedArrayList();

        String preferredLanguage = (String) map.get("preferredLanguage");
        String tableName         = (String) map.get("tableName");
        String entity            = (String) map.get("entity");

        boolean blAddToUnbound = true;
        Lookup addresstype = null;
        Address address = null;

        List<Lookup> allAddressTypesActual = new ArrayList<>();
        Lookup aType = null;
        int ix = 0;

        // fetch all addresstypes:
        allAddressTypes = (ArrayList < Lookup >
                ) lookupManager.findAllRows(preferredLanguage, tableName);

        // fetch all addresses of the given entity
        allBoundAddresses = (ArrayList < Address >) findAddressesForEntity(map);

        // determine list of addresstypes based on entity
        for (int i = 0; i < allAddressTypes.size(); i++) {
            if ("staffmember".equals(entity)) { 
                //home = code 1
                //formal communication address staffmember = code 6
                if ("1".equals(allAddressTypes.get(i).getCode())
                        || "6".equals(allAddressTypes.get(i).getCode())) {
                    aType = allAddressTypes.get(i);
                    allAddressTypesActual.add(ix, aType);
                    ix = ix + 1;
                }
            }
            if ("student".equals(entity)) { 
                //home = code 1
                //formal communication address student = code 2
                //financial guardian = code 3
                //parents = code 7
                if ("1".equals(allAddressTypes.get(i).getCode())
                        || "2".equals(allAddressTypes.get(i).getCode())
                        || "3".equals(allAddressTypes.get(i).getCode())
                        || "7".equals(allAddressTypes.get(i).getCode())
                        ) {
                    aType = allAddressTypes.get(i);
                    allAddressTypesActual.add(ix, aType);
                    ix = ix + 1;
                }
            }
            if ("study".equals(entity)) { 
                //formal communication address study = code 4
                if ("4".equals(allAddressTypes.get(i).getCode())) {
                    aType = allAddressTypes.get(i);
                    allAddressTypesActual.add(ix, aType);
                    ix = ix + 1;
                }
            }
            if ("organizationalunit".equals(entity)) {
                //formal communication address organizational unit = code 5
                if ("5".equals(allAddressTypes.get(i).getCode())) {
                    aType = allAddressTypes.get(i);
                    allAddressTypesActual.add(ix, aType);
                    ix = ix + 1;
                }
            }
        }

        allAddressTypes = (ArrayList <Lookup>) allAddressTypesActual;

        // subtract the address types already assigned to an address of the given entity
        for (int i = 0; i < allAddressTypes.size(); i++) {
            addresstype = (Lookup) allAddressTypes.get(i);
            for (int j = 0; j < allBoundAddresses.size(); j++) {
                address = (Address) allBoundAddresses.get(j);
                if (addresstype.getCode().equals(address.getAddressTypeCode())) {
                    blAddToUnbound = false;
                }
            }
            // add to list or not:
            if (blAddToUnbound) {
                allUnboundAddressTypes.add(addresstype);
            }
            blAddToUnbound = true;
        }

        return allUnboundAddressTypes;
    }

    @Override
    public Address findParentAddress(final int organizationalUnitId) {
        Address parentAddress = null;
        int tempUnitLevel = 0;
        // first find the organizationalUnit and its level
        OrganizationalUnit organizationalUnit = organizationalUnitManager.findOrganizationalUnit(organizationalUnitId);
        tempUnitLevel = organizationalUnit.getUnitLevel();
        int parentOrganizationalUnitId = organizationalUnit.getParentOrganizationalUnitId();
        if (tempUnitLevel == 0) {
            // message: no level found
        } else if (tempUnitLevel == 1) {
            // message: no parent found
        } else {
            while (tempUnitLevel > 1) {
                parentAddress = findAddressByOrganizationalUnitId("5", parentOrganizationalUnitId);
                if (parentAddress != null) {
                    break;
                } else {
                    tempUnitLevel = tempUnitLevel - 1;
                    organizationalUnit = organizationalUnitManager.findOrganizationalUnit(parentOrganizationalUnitId);
                    parentOrganizationalUnitId = organizationalUnit.getParentOrganizationalUnitId();
                }
            }
            if (parentAddress == null) {
                // no address found: null returned
            } else {
                // address found
            }
        }


        return parentAddress;
    }

    @Override
    public void addAddress(final Address address) {

        addressMapper.addAddress(address);
    }
    
    @Override
    public void addAddresses(List<Address> addresses) {
    	for (Address address : addresses) {
    		addAddress(address);
    	}
    }

    @Override
    public void updateAddress(final Address newAddress) {
        addressMapper.updateAddress(newAddress);
    }

    @Override
    public void deleteAddress(final int addressId) {
        addressMapper.deleteAddress(addressId);
    }

    @Override
    public void deleteAddressesForStudy(final int studyId) {
        addressMapper.deleteAddressesForStudy(studyId);
    }

    /**
     * @param newAddressDao The addressMapper to set.
     */
//    public void setAddressDao(final AddressMapper newAddressDao) {
//        this.addressMapper = newAddressDao;
//    }
//
//    public void setLookupManager(final LookupManagerInterface lookupManager) {
//        this.lookupManager = lookupManager;
//    }

    /**
     * @param organizationalUnitManager the organizationalUnitManager to set
     */
//    public void setOrganizationalUnitManager(
//            OrganizationalUnitManagerInterface organizationalUnitManager) {
//        this.organizationalUnitManager = organizationalUnitManager;
//    }


}
