/*******************************************************************************
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
 * The Original Code is Opus-College ucm module code.
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
 ******************************************************************************/
package org.uci.opus.ucm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.service.BranchManagerInterface;

public class BranchManagerMock implements BranchManagerInterface {

    private Map<Integer, Branch> branches = new HashMap<>();
    private Map<Integer, Integer> orgUnits = new HashMap<>();

    @Override
    public void addBranch(Branch branch) {
        branches.put(branch.getId(), branch);
    }

    @Override
    public void deleteBranch(int branchId) {
    }

    @Override
    public Branch findBranch(int branchId) {
        return branches.get(branchId);
    }

    @Override
    public Branch findBranchByParams(Map<String, Object> map) {
        return null;
    }

    @Override
    public List<Branch> findBranches(Map<String, Object> map) {
        return null;
    }

    @Override
    public void updateBranch(Branch branch) {
    }

    /**
     * set mappings from orgUnitId to branchId.
     * @param organizationalUnitId
     * @param branchId
     */
    public void setBranchIdForOrganizationalUnit(int organizationalUnitId, int branchId) {
        orgUnits.put(organizationalUnitId, branchId);
    }

    @Override
    public int findBranchOfOrganizationalUnit(int organizationalUnitId) {
        return orgUnits.get(organizationalUnitId);
    }

    @Override
    public List<Branch> findBranchesByIds(List<Integer> branchIds) {
        return null;
    }

    @Override
    public List<BranchAcademicYearTimeUnit> findBranchAcademicYearTimeUnits(Map<String, Object> map) {
        return null;
    }

    @Override
    public BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnit(int branchId, int academicYearId, String cardinalTimeUnitCode,
            int cardinalTimeUnitNumber) {
        return null;
    }

    @Override
    public BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnitById(int branchAcademicYearTimeUnitId) {
        return null;
    }

    @Override
    public void addBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit) {
    }

    @Override
    public void updateBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit) {
    }

    @Override
    public void deleteBranchAcademicYearTimeUnit(int branchAcademicYearTimeUnitId) {
    }

    @Override
    public List<Branch> findBranches(int institutionId) {
        // TODO Auto-generated method stub
        return null;
    }

}
