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

import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;

/**
 * @author J.Nooitgedagt
 *
 */
public interface BranchManagerInterface {

    /**
     * 
     * @param map
     * @return
     */
    List<Branch> findBranches(Map<String, Object> map);

    /**
     * Get branches for the given institutionId.
     * 
     * @param institutionId
     * @return
     */
    List<Branch> findBranches(int institutionId);

    /**
     * 
     * @param branchIds
     * @return
     */
    List<Branch> findBranchesByIds(List<Integer> branchIds);

    /**
     * @param branchId
     *            id of branch to find
     * @return branch
     */
    Branch findBranch(int branchId);

    /**
     * @param map
     *            with parameters of branch
     * @return branch object or null
     */
    Branch findBranchByParams(Map<String, Object> map);

    /**
     * @param branch
     *            to add
     */
    void addBranch(Branch branch);

    /**
     * @param branch
     *            to update
     */
    void updateBranch(Branch branch);

    /**
     * @param branchId
     *            id of branch to delete
     */
    void deleteBranch(int branchId);

    /**
     * 
     * @param map
     * @return
     */
    List<BranchAcademicYearTimeUnit> findBranchAcademicYearTimeUnits(Map<String, Object> map);

    /**
     * @param branchId
     * @param academicYearId
     * @param cardinalTimeUnitCode
     * @param cardinalTimeUnitNumber
     * @return
     */
    BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnit(int branchId, int academicYearId, String cardinalTimeUnitCode,
            int cardinalTimeUnitNumber);

    /**
     * 
     * @param branchAcademicYearTimeUnitId
     * @return
     */
    BranchAcademicYearTimeUnit findBranchAcademicYearTimeUnitById(int branchAcademicYearTimeUnitId);

    /**
     * @param organizationalUnitId
     * @return the branchId
     */
    int findBranchOfOrganizationalUnit(int organizationalUnitId);

    /**
     * 
     * @param branchAcademicYearTimeUnit
     */
    void addBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit);

    /**
     * 
     * @param branchAcademicYearTimeUnit
     */
    void updateBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit);

    /**
     * 
     * @param branchAcademicYearTimeUnitId
     */
    void deleteBranchAcademicYearTimeUnit(int branchAcademicYearTimeUnitId);

}
