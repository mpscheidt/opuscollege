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

import java.util.Calendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.util.StringUtil;

/**
 * This implementation gives an empty student number when the new student screen is
 * displayed to the user.
 * The student number will only be created when the new student is stored into the database.
 * This is to avoid duplicate student numbers when two or more users enter students
 * at the same time.
 * @author mp
 *
 */
public class UCMStudentNumberGenerator implements StudentNumberGeneratorInterface {

    private static final String INITIAL_RUNNING_NUMBER = "0001";
    private UCMManagerInterface ucmManager;
    private BranchManagerInterface branchManager;

    private static Logger log = LoggerFactory.getLogger(UCMStudentNumberGenerator.class);

    public UCMStudentNumberGenerator() {
    }

    @Override
    public boolean applies(String key) {
        return StudentNumberGeneratorInterface.KEY_SUBMIT.equals(key);
    }

//    public String createUniqueStudentNumberOnScreen(int organizationalUnitId) {
//        return null;
//    }

    @Override
    public String createUniqueStudentCode(String key, int organizationalUnitId, Student student) {
        if (organizationalUnitId == 0 || (student != null && !StringUtil.isNullOrEmpty(student.getStudentCode()))) {
            return null;
        }

        String studentNumber = null;

        int branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
        if (branchId != 0) {
            Branch branch = branchManager.findBranch(branchId);
            String branchCode = branch.getBranchCode();
            branchCode = StringUtil.prefixChars(branchCode, 2, '0');
            String year = getCurrentYearTwoDigits();
            String currentHighestCode = ucmManager.findHighestStudentCode(branchCode, year);
            String runningNumber = null;
            if (currentHighestCode == null) {
                runningNumber = INITIAL_RUNNING_NUMBER;
            } else {
                int runningNumberIndex = currentHighestCode.length() - INITIAL_RUNNING_NUMBER.length();
                String currentRunningNumber = currentHighestCode.substring(runningNumberIndex);
                try {
                    int currRunningNrInt = Integer.parseInt(currentRunningNumber);
                    String newRunningNr = String.valueOf(currRunningNrInt + 1);
                    // running number has to have 4 digits, eventually starting with zeroes 
                    runningNumber = StringUtil.prefixChars(newRunningNr, 4, '0');
                    // if (currentRunningNumber_i < 10) { runningNumber = "00"; }
                    // else if (currentRunningNumber_i < 10) { runningNumber = "0"; }
                    // else runningNumber = "";
                } catch (Exception e) {
                    log.warn("student code is somehow wrong: " + currentHighestCode);
                    runningNumber = INITIAL_RUNNING_NUMBER; // TODO: better handling!
                }
            }

            studentNumber = "7" + branchCode + year + runningNumber;
        }

        return studentNumber;
    }


    public static String getCurrentYearTwoDigits() {
        String year = String.valueOf(Calendar.getInstance().get(Calendar.YEAR) % 100);
        if (year.length() == 1) {
            year = "0" + year;
        }
        return year;
    }


    public UCMManagerInterface getUcmManager() {
        return ucmManager;
    }

    @Autowired
    public void setUcmManager(UCMManagerInterface ucmManager) {
        this.ucmManager = ucmManager;
    }

    @Autowired
    public void setBranchManager(final BranchManagerInterface branchManager) {
        this.branchManager = branchManager;
    }

}
