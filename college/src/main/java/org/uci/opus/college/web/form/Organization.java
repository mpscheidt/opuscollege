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

package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.config.OpusConstants;

public class Organization {

    private int institutionId;
    private int branchId;
    private int organizationalUnitId;
    private String institutionTypeCode;
    private List<Institution> allInstitutions;
    private List<Branch> allBranches;
    private List<OrganizationalUnit> allOrganizationalUnits;

    public Organization() {
        institutionId = 0;
        branchId = 0;
        organizationalUnitId = 0;
        institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
    }

    /**
     * @return the institutionId
     */
    public int getInstitutionId() {
        return institutionId;
    }

    /**
     * @param institutionId
     *            the institutionId to set
     */
    public void setInstitutionId(final int institutionId) {
        this.institutionId = institutionId;
    }

    /**
     * @return the branchId
     */
    public int getBranchId() {
        return branchId;
    }

    /**
     * @param branchId
     *            the branchId to set
     */
    public void setBranchId(final int branchId) {
        this.branchId = branchId;
    }

    /**
     * @return the organizationalUnitId
     */
    public int getOrganizationalUnitId() {
        return organizationalUnitId;
    }

    /**
     * @param organizationalUnitId
     *            the organizationalUnitId to set
     */
    public void setOrganizationalUnitId(final int organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }

    /**
     * @return the institutionTypeCode
     */
    public String getInstitutionTypeCode() {
        return institutionTypeCode;
    }

    /**
     * @param institutionTypeCode
     *            the institutionTypeCode to set
     */
    public void setInstitutionTypeCode(final String institutionTypeCode) {
        this.institutionTypeCode = institutionTypeCode;
    }

    public List<Institution> getAllInstitutions() {
        return allInstitutions;
    }

    public void setAllInstitutions(List<Institution> allInstitutions) {
        this.allInstitutions = allInstitutions;
    }

    public List<Branch> getAllBranches() {
        return allBranches;
    }

    public void setAllBranches(List<Branch> allBranches) {
        this.allBranches = allBranches;
    }

    public void clearBranches() {
        if (allBranches != null) {
            allBranches.clear();
        }
    }

    public List<OrganizationalUnit> getAllOrganizationalUnits() {
        return allOrganizationalUnits;
    }

    public void setAllOrganizationalUnits(List<OrganizationalUnit> allOrganizationalUnits) {
        this.allOrganizationalUnits = allOrganizationalUnits;
    }

    public void clearOrganizationalUnits() {
        if (allOrganizationalUnits != null) {
            allOrganizationalUnits.clear();
        }
    }

}
