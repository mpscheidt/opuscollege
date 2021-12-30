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
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.OrganizationalUnit;

/**
 * @author move
 */
public interface OrganizationalUnitMapper {

    /**
     * @param map
     *            contains the following parameters: institutionId branchId educationTypeCode
     * @return list of organizational units
     */
    List<OrganizationalUnit> findOrganizationalUnits(Map<String, Object> map);

    /**
     * Find the organizational units for the given branchId.
     * 
     * @param branchId
     */
    List<OrganizationalUnit> findOrganizationalUnits(int branchId);

    /**
     * @param studyId
     *            id of study of which to find the organizational units
     * @return List of OrganizationalUnit objects or null.
     */
    OrganizationalUnit findOrganizationalUnitOfStudy(int studyId);

    /**
     * @param organizationalUnitId
     *            id of organizationalUnit to find
     * @return OrganizationalUnit object or null when there was nothing found.
     */
    OrganizationalUnit findOrganizationalUnit(int organizationalUnitId);

    /**
     * @param organizationalUnitDescription
     *            of organizationalUnit to find
     * @return organizationalUnit
     */
    // OrganizationalUnit findOrganizationalUnitByName(String organizationalUnitDescription);

    /**
     * @param map
     *            with organizationalUnitDescription and -code of organizationalUnit to find
     * @return organizationalUnit
     */
    OrganizationalUnit existsDuplicate(Map<String, Object> map);

    /**
     * @param organizationalUnitId
     *            id of institution to find
     * @return Institution
     */
    // Institution findInstitutionForOrganizationalUnit(int organizationalUnitId);

    /**
     * @param organizationalUnitId
     *            id of Branch to find
     * @return Branch
     */
    // Branch findBranchForOrganizationalUnit(int organizationalUnitId);

    /**
     * @param unitLevel
     *            of parentunits
     * @param branchId
     *            of parentunits
     * @return List of OrganizationalUnits
     */
    List<OrganizationalUnit> findAllOrganizationalUnitAtLevel(@Param("unitLevel") int unitLevel, @Param("branchId") int branchId);

    /**
     * @param organizationalUnitId
     *            of unit where to find the children for
     * @return List of OrganizationalUnits
     */
    List<OrganizationalUnit> findAllChildrenForOrganizationalUnit(int organizationalUnitId);

    /**
     * @param organizationalUnit
     *            to add
     */
    void addOrganizationalUnit(OrganizationalUnit organizationalUnit);

    /**
     * @param organizationalUnit
     *            to update
     */
    void updateOrganizationalUnit(OrganizationalUnit organizationalUnit);

    /**
     * delete a given organizationalUnit and if present the linked registration periods
     * 
     * @param organizationalUnitId
     *            id of organizationalUnit to delete
     */
    void deleteOrganizationalUnit(int organizationalUnitId);

    /**
     * 
     */
    void deleteAdmissionRegistrationConfig(int admissionRegistrationConfigId);

    /**
     * 
     */
    AdmissionRegistrationConfig findAdmissionRegistrationConfig(Map<String, Object> map);

    // /**
    // * @param organizationalUnitId
    // * @param academicYearId
    // * @return
    // */
    // AdmissionRegistrationConfig findAdmissionRegistrationConfig(int organizationalUnitId, int
    // academicYearId);

    /**
     * 
     */
    void updateAdmissionRegistrationConfig(AdmissionRegistrationConfig admissionRegistrationConfig);

    /**
     * 
     */
    void addAdmissionRegistrationConfig(AdmissionRegistrationConfig admissionRegistrationConfig);

    /**
     * @param personId
     *            id of Student of whom to find the organizationalUnit he belongs to
     * @return OrganizationalUnit
     */
    OrganizationalUnit findOrganizationalUnitForStudent(int personId);

    /**
     * Find all organizationalUnitIds that are equal to the given organizationalUnidId or its child units.
     * 
     * @param organizationalUnidId
     * @return list of organizationalUnidIds
     */
    List<Integer> findTreeOfOrganizationalUnitIds(Integer organizationalUnidId);

}
