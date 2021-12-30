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
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.persistence.BranchMapper;

/**
 * @author J.Nooitgedagt
 *
 */
public class BranchManager implements BranchManagerInterface {

    private static Logger log = LoggerFactory.getLogger("BranchManager.class");

    private BranchMapper branchMapper;

    @Autowired
    public BranchManager(BranchMapper branchMapper) {
        this.branchMapper = branchMapper;
    }

    @Override
    public List<Branch> findBranches(final Map<String, Object> map) {
        return branchMapper.findBranches(map);
    }

    @Override
    public List<Branch> findBranches(final int institutionId) {
        List<Branch> allBranches = null;
        if (institutionId != 0) {
            Map<String, Object> findBranchesMap = new HashMap<String, Object>();
            findBranchesMap.put("institutionId", institutionId);
            allBranches = findBranches(findBranchesMap);
        }
        return allBranches;
    }

    @Override
    public List<Branch> findBranchesByIds(List<Integer> branchIds) {
        Map<String, Object> map = new HashMap<>();
        map.put("branchIds", branchIds);
        return branchMapper.findBranchesByIds(map);
    }

    @Override
    public Branch findBranch(final int branchId) {

        return branchMapper.findBranch(branchId);
    }

    @Override
    public int findBranchOfOrganizationalUnit(final int organizationalUnitId) {

        return branchMapper.findBranchOfOrganizationalUnit(organizationalUnitId);
    }

    @Override
    public Branch findBranchByParams(final Map<String, Object> map) {

        return branchMapper.findBranchByParams(map);
    }

    @Override
    public void addBranch(final Branch branch) {
        branchMapper.addBranch(branch);
    }

    @Override
    public void updateBranch(final Branch branch) {
        branchMapper.updateBranch(branch);
    }

    @Override
    public void deleteBranch(final int branchId) {
        branchMapper.deleteBranch(branchId);
    }

    @Override
    public List<BranchAcademicYearTimeUnit> findBranchAcademicYearTimeUnits(Map<String,Object> map) {
        return branchMapper.findBranchAcademicYearTimeUnits(map);
    }
    
    @Override
    public BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnit(int branchId, int academicYearId, String cardinalTimeUnitCode, int cardinalTimeUnitNumber) {
        
        Map<String, Object> map = new HashMap<>();
        map.put("branchId", branchId);
        map.put("academicYearId", academicYearId);
        map.put("cardinalTimeUnitCode", cardinalTimeUnitCode);
        map.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        List<BranchAcademicYearTimeUnit> bats = findBranchAcademicYearTimeUnits(map);
        BranchAcademicYearTimeUnit branchAcademicYearTimeUnit = bats.isEmpty() ? null : bats.get(0);
        
        return branchAcademicYearTimeUnit;
    }

    @Override
    public BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnitById(int branchAcademicYearTimeUnitId) {
        return branchMapper.findBranchAcademicYearTimeUnitById(branchAcademicYearTimeUnitId);
    }

    @Override
    public void addBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit) {
        branchMapper.addBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit);
    }
    
    @Override
    public void updateBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit) {
        branchMapper.updateBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit);
    }

    @Override
    public void deleteBranchAcademicYearTimeUnit(int branchAcademicYearTimeUnitId) {
        branchMapper.deleteBranchAcademicYearTimeUnit(branchAcademicYearTimeUnitId);
    }

}
