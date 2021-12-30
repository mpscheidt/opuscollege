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
 * The Original Code is Opus-College cbu module code.
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
package org.uci.opus.mulungushi.service;

import java.util.Calendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.admission.service.listener.StudentCodeGenerationListener;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.util.StringUtil;

/**
 * This implementation gives an empty student number when the new student screen is
 * displayed to the user.
 * The student number will only be created when the new student is stored into the database.
 * This is to avoid duplicate student numbers when two or more users enter students
 * at the same time.
 * @author Markus Pscheidt
 *
 */
public class MulungushiStudentNumberGenerator implements StudentNumberGeneratorInterface {

    @Autowired private MulungushiManagerInterface muManager;

    private static Logger log = LoggerFactory.getLogger(MulungushiStudentNumberGenerator.class);
    private static final int INITIAL_RUNNING_NUMBER = 1;

    @Override
    public boolean applies(String key) {
        return StudentNumberGeneratorInterface.KEY_SUBMIT.equals(key)
                || StudentCodeGenerationListener.KEY_ADMISSION.equals(key);
    }

    /**
     * When creating a student, the 6-digit application number will be generated.
     * When the student is admitted, the 8-digit studentCode will be generated based on the application number.
     */
    @Override
    public String createUniqueStudentCode(String key, int organizationalUnitId, Student student) {
        String studentCode = null;
        if (StudentNumberGeneratorInterface.KEY_SUBMIT.equals(key)) {
            studentCode = student.getStudentCode();
            if (studentCode == null || studentCode.trim().isEmpty()) {
                studentCode = createApplicationNumber();
            }
        } else {
            String applicationNumber = student.getStudentCode();
            if (applicationNumber != null && applicationNumber.length() <= 6) {
                studentCode = createStudentNumber(applicationNumber);
            }
        }
        return studentCode;
    }

    private String createApplicationNumber() {
        String applicationNumber = null;

        Integer nextApplicationNumber = muManager.findNextApplicationNumber();
        if (nextApplicationNumber == null) {
            nextApplicationNumber = INITIAL_RUNNING_NUMBER;
        }

        // application number has to have 6 digits, eventually starting with zeroes
        applicationNumber = StringUtil.prefixChars(nextApplicationNumber.toString(), 6, '0');

        return applicationNumber;
    }

    /**
     * Add the year to the 6-digit application number
     * @param applicationNumber
     * @return the 8-digit studentCode
     */
    private String createStudentNumber(String applicationNumber) {
        String year = getNextYearTwoDigits();   // the first year of study is one later than when admission is done
        String studentNumber = year + applicationNumber;
        return studentNumber;
    }

    private static String getNextYearTwoDigits() {
        int currentYear = Calendar.getInstance().get(Calendar.YEAR) % 100;
        String year = String.valueOf(currentYear + 1);
        if (year.length() == 1) year = "0" + year;
        return year;
    }

}
