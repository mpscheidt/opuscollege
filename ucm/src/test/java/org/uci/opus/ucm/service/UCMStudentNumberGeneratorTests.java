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

import static org.junit.Assert.assertEquals;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;

public class UCMStudentNumberGeneratorTests {

    private BranchManagerMock branchManager;
    private UCMManagerMock ucmManager;
    private UCMStudentNumberGenerator studentNumberGenerator;

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
    }

    @AfterClass
    public static void tearDownAfterClass() throws Exception {
    }

    @Before
    public void setUp() throws Exception {
        branchManager = new BranchManagerMock();
        ucmManager = new UCMManagerMock();
        studentNumberGenerator = new UCMStudentNumberGenerator();
        studentNumberGenerator.setBranchManager(branchManager);
        studentNumberGenerator.setUcmManager(ucmManager);
    }

    @After
    public void tearDown() throws Exception {
    }

    @Test
    public void testCreateUniqueStudentNumber1() {
        final int branchId = 1;
        final String branchCode = "01";
        final int organizationalUnitId = 2;

        Branch branch = new Branch();
        branch.setId(branchId);
        branch.setBranchCode(branchCode);
        branchManager.addBranch(branch);
        branchManager.setBranchIdForOrganizationalUnit(organizationalUnitId, branchId);

        String year = UCMStudentNumberGenerator.getCurrentYearTwoDigits();
        ucmManager.putHighestStudentCode(branchCode, year, "701010123");

        // student parameter can be null - not used by UCM student number generator
        String studentNumber = studentNumberGenerator.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SUBMIT, organizationalUnitId, null);
        // format: 7 <branchCode> <year> <running number>
        String expectedNumber = "701" + year + "0124";
        assertEquals(expectedNumber, studentNumber);
    }

    @Test
    public void testCreateUniqueStudentNumber2() {
        final int branchId = 1;
        final String branchCode = "SCIENCE";
        final int organizationalUnitId = 2;

        Branch branch = new Branch();
        branch.setId(branchId);
        branch.setBranchCode(branchCode);
        branchManager.addBranch(branch);
        branchManager.setBranchIdForOrganizationalUnit(organizationalUnitId, branchId);

        String year = UCMStudentNumberGenerator.getCurrentYearTwoDigits();
        ucmManager.putHighestStudentCode(branchCode, year, "7" + branchCode + "010123");

        // student parameter can be null - not used by UCM student number generator
        String studentNumber = studentNumberGenerator.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SUBMIT, organizationalUnitId, null);
        // format: 7 <branchCode> <year> <running number>
        String expectedNumber = "7" + branchCode + year + "0124";
        assertEquals(expectedNumber, studentNumber);
    }

}
