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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.persistence.AddressMapper;
import org.uci.opus.college.persistence.OrganizationalUnitMapper;

/**
 * @author J.Nooitgedagt
 */
public class OrganizationalUnitManager implements OrganizationalUnitManagerInterface {

    private static Logger log = LoggerFactory.getLogger(OrganizationalUnitManager.class);

    @Autowired
    private OrganizationalUnitMapper organizationalUnitMapper;

    @Autowired
    private AddressMapper addressDao;

    @Override
    public List<OrganizationalUnit> findOrganizationalUnits(final Map<String, Object> map) {
        return organizationalUnitMapper.findOrganizationalUnits(map);
    }

    @Override
    public List<OrganizationalUnit> findOrganizationalUnits(int branchId) {
        Map<String, Object> map = new HashMap<>();
        map.put("branchId", branchId);
        return this.findOrganizationalUnits(map);
    }

    @Override
    public List<OrganizationalUnit> findOrganizationalUnitsByIds(List<Integer> organizationalUnitIds) {
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitIds", organizationalUnitIds);
        return this.findOrganizationalUnits(map);
    }

    @Override
    public OrganizationalUnit findOrganizationalUnit(final int organizationalUnitId) {

        OrganizationalUnit organizationalUnit = null;
        organizationalUnit = organizationalUnitMapper.findOrganizationalUnit(organizationalUnitId);

        return organizationalUnit;
    }

    @Override
    public OrganizationalUnit findOrganizationalUnitOfStudy(final int studyId) {
        OrganizationalUnit organizationalUnit = organizationalUnitMapper.findOrganizationalUnitOfStudy(studyId);

        return organizationalUnit;
    }

    @Override
    public List<OrganizationalUnit> findAllOrganizationalUnitAtLevel(final int unitLevel, final int branchId) {

        List<OrganizationalUnit> allOrganizationalUnits = null;
        allOrganizationalUnits = organizationalUnitMapper.findAllOrganizationalUnitAtLevel(unitLevel, branchId);

        return allOrganizationalUnits;
    }

    @Override
    public List<OrganizationalUnit> findAllChildrenForOrganizationalUnit(final int organizationalUnitId) {

        List<OrganizationalUnit> allOrganizationalUnits = null;
        allOrganizationalUnits = organizationalUnitMapper.findAllChildrenForOrganizationalUnit(organizationalUnitId);

        return allOrganizationalUnits;
    }

    @Override
    public void addOrganizationalUnit(final OrganizationalUnit organizationalUnit) {

        organizationalUnitMapper.addOrganizationalUnit(organizationalUnit);
    }

    @Override
    public void updateOrganizationalUnit(final OrganizationalUnit organizationalUnit) {

        organizationalUnitMapper.updateOrganizationalUnit(organizationalUnit);
    }

    @Override
    public void deleteOrganizationalUnit(final int organizationalUnitId) {

        addressDao.deleteAddressesForOrganizationalUnit(organizationalUnitId);
        organizationalUnitMapper.deleteOrganizationalUnit(organizationalUnitId);
    }

    /**
     * 
     * @param addressDao
     */
    public void setAddressDao(final AddressMapper addressDao) {
        this.addressDao = addressDao;
    }

    @Override
    public void deleteAdmissionRegistrationConfig(int admissionRegistrationConfigId) {
        organizationalUnitMapper.deleteAdmissionRegistrationConfig(admissionRegistrationConfigId);
    }

    @Override
    public AdmissionRegistrationConfig findAdmissionRegistrationConfig(int admissionRegistrationConfigId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", admissionRegistrationConfigId);
        return organizationalUnitMapper.findAdmissionRegistrationConfig(map);
    }

    @Override
    public String updateOrAddAdmissionRegistrationConfig(AdmissionRegistrationConfig admissionRegistrationConfig) {
        String msg = null;

        if (0 != admissionRegistrationConfig.getId()) {
            organizationalUnitMapper.updateAdmissionRegistrationConfig(admissionRegistrationConfig);
        } else {
            organizationalUnitMapper.addAdmissionRegistrationConfig(admissionRegistrationConfig);
        }
        return msg;
    }

    @Override
    public AdmissionRegistrationConfig findAdmissionRegistrationConfig(int organizationalUnitId, int academicYearId, boolean crawlUp) {
        AdmissionRegistrationConfig admissionRegistrationConfig = null;

        do {
            admissionRegistrationConfig = findAdmissionRegistrationConfig(organizationalUnitId, academicYearId);
            if (admissionRegistrationConfig == null) {
                OrganizationalUnit organizationalUnit = organizationalUnitMapper.findOrganizationalUnit(organizationalUnitId);
                organizationalUnitId = organizationalUnit.getParentOrganizationalUnitId();
            }
        } while (crawlUp && admissionRegistrationConfig == null && organizationalUnitId != 0);

        return admissionRegistrationConfig;
    }

    @Override
    public AdmissionRegistrationConfig findAdmissionRegistrationConfig(int organizationalUnitId, int academicYearId) {
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("academicYearId", academicYearId);
        return organizationalUnitMapper.findAdmissionRegistrationConfig(map);
    }

    @Override
    public List<Integer> findTreeOfOrganizationalUnitIds(Integer organizationalUnidId) {
        return organizationalUnitMapper.findTreeOfOrganizationalUnitIds(organizationalUnidId);
    }
}
