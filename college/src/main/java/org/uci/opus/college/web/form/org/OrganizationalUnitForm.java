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

package org.uci.opus.college.web.form.org;

import java.util.List;

import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup4;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;

public class OrganizationalUnitForm {

    private NavigationSettings navigationSettings;
    private Organization organization;

    private OrganizationalUnit organizationalUnit;
    private int childOUId;
    private OrganizationalUnit parentOrgUnit;
    private List<OrganizationalUnit> allParentOrganizationalUnits;
    private List<OrganizationalUnit> allChildOrganizationalUnits;
    private List<StaffMember> allDirectors;
    private List<Lookup> allAddressTypes;
    private List<Lookup> allUnitTypes;
    private List<Lookup> allAcademicFields;
    private List<Lookup> allUnitAreas;
    private List<Lookup3> allCountries;
    private List<Lookup5> allProvinces;
    private List<Lookup> allDistricts;
    private List<Lookup4> allAdministrativePosts;

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public int getChildOUId() {
        return childOUId;
    }

    public void setChildOUId(int childOUId) {
        this.childOUId = childOUId;
    }

    public OrganizationalUnit getOrganizationalUnit() {
        return organizationalUnit;
    }

    public void setOrganizationalUnit(OrganizationalUnit organizationalUnit) {
        this.organizationalUnit = organizationalUnit;
    }

    public OrganizationalUnit getParentOrgUnit() {
        return parentOrgUnit;
    }

    public void setParentOrgUnit(OrganizationalUnit parentOrgUnit) {
        this.parentOrgUnit = parentOrgUnit;
    }

    public List<OrganizationalUnit> getAllParentOrganizationalUnits() {
        return allParentOrganizationalUnits;
    }

    public void setAllParentOrganizationalUnits(List<OrganizationalUnit> allParentOrganizationalUnits) {
        this.allParentOrganizationalUnits = allParentOrganizationalUnits;
    }

    public List<OrganizationalUnit> getAllChildOrganizationalUnits() {
        return allChildOrganizationalUnits;
    }

    public void setAllChildOrganizationalUnits(List<OrganizationalUnit> allChildOrganizationalUnits) {
        this.allChildOrganizationalUnits = allChildOrganizationalUnits;
    }

    public List<StaffMember> getAllDirectors() {
        return allDirectors;
    }

    public void setAllDirectors(List<StaffMember> allDirectors) {
        this.allDirectors = allDirectors;
    }

    public List<Lookup> getAllAddressTypes() {
        return allAddressTypes;
    }

    public void setAllAddressTypes(List<Lookup> allAddressTypes) {
        this.allAddressTypes = allAddressTypes;
    }

    public List<Lookup> getAllUnitTypes() {
        return allUnitTypes;
    }

    public void setAllUnitTypes(List<Lookup> allUnitTypes) {
        this.allUnitTypes = allUnitTypes;
    }

    public List<Lookup> getAllAcademicFields() {
        return allAcademicFields;
    }

    public void setAllAcademicFields(List<Lookup> allAcademicFields) {
        this.allAcademicFields = allAcademicFields;
    }

    public List<Lookup> getAllUnitAreas() {
        return allUnitAreas;
    }

    public void setAllUnitAreas(List<Lookup> allUnitAreas) {
        this.allUnitAreas = allUnitAreas;
    }

    public List<Lookup3> getAllCountries() {
        return allCountries;
    }

    public void setAllCountries(List<Lookup3> allCountries) {
        this.allCountries = allCountries;
    }

    public List<Lookup5> getAllProvinces() {
        return allProvinces;
    }

    public void setAllProvinces(List<Lookup5> allProvinces) {
        this.allProvinces = allProvinces;
    }

    public List<Lookup> getAllDistricts() {
        return allDistricts;
    }

    public void setAllDistricts(List<Lookup> allDistricts) {
        this.allDistricts = allDistricts;
    }

    public List<Lookup4> getAllAdministrativePosts() {
        return allAdministrativePosts;
    }

    public void setAllAdministrativePosts(List<Lookup4> allAdministrativePosts) {
        this.allAdministrativePosts = allAdministrativePosts;
    }

}
