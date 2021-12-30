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

package org.uci.opus.college.domain;

import java.io.Serializable;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * @author M. in het Veld
 *
 */
public class Test implements Serializable, IAttempt {

    private static final long serialVersionUID = 1L;

    private int id;
    private String testCode;
    private String testDescription;
    private int examinationId;
    private String examinationTypeCode;
    private int numberOfAttempts;
    private int weighingFactor;
    private String BRsPassingTest;
    private String active;
    private List<TestTeacher> teachersForTest;
    private Examination examination;
    private Date testDate;

    public Test() {
        super();
    }

    @Override
    public String toString() {
        return "Test [id=" + id + ", testCode=" + testCode + ", testDescription=" + testDescription + ", examinationId=" + examinationId
                + ", examinationTypeCode=" + examinationTypeCode + ", numberOfAttempts=" + numberOfAttempts + ", weighingFactor=" + weighingFactor
                + ", BRsPassingTest=" + BRsPassingTest + ", active=" + active + ", testDate=" + testDate + "]";
    }

    /**
     * Test has no lower level elements, therefore an empty list is returned.
     */
    @Override
    public List<? extends ISubjectExamTest> getSubItems() {
        return Collections.emptyList();
    }

    public String getExaminationTypeCode() {
        return examinationTypeCode;
    }

    public void setExaminationTypeCode(String examinationTypeCode) {
        this.examinationTypeCode = examinationTypeCode;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNumberOfAttempts() {
        return numberOfAttempts;
    }

    public void setNumberOfAttempts(int numberOfAttempts) {
        this.numberOfAttempts = numberOfAttempts;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public int getWeighingFactor() {
        return weighingFactor;
    }

    public void setWeighingFactor(int weighingFactor) {
        this.weighingFactor = weighingFactor;
    }

    public String getCode() {
        return getTestCode();
    }

    public String getTestCode() {
        return testCode;
    }

    public void setTestCode(String testCode) {
        this.testCode = testCode;
    }

    public String getDescription() {
        return getTestDescription();
    }

    public String getTestDescription() {
        return testDescription;
    }

    public void setTestDescription(String testDescription) {
        this.testDescription = testDescription;
    }

    public int getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(int examinationId) {
        this.examinationId = examinationId;
    }

    public String getBRsPassingTest() {
        return BRsPassingTest;
    }

    public void setBRsPassingTest(String rsPassingTest) {
        BRsPassingTest = rsPassingTest;
    }

    public List<TestTeacher> getTeachersForTest() {
        return teachersForTest;
    }

    public void setTeachersForTest(List<TestTeacher> teachersForTest) {
        this.teachersForTest = teachersForTest;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    @Override
    public boolean isAssignedTeacher(int staffMemberId, Integer classgroupId) {
        boolean isTestTeacher = false;
        int classgroupStudentId = classgroupId != null ? classgroupId : 0;
        if (getTeachersForTest() != null) {
            for (TestTeacher testTeacher : getTeachersForTest()) {
                if (staffMemberId == testTeacher.getStaffMemberId()) {
                    int classgroupTeacherId = testTeacher.getClassgroupId() != null ? testTeacher.getClassgroupId() : 0;
                    if (classgroupStudentId == 0 || classgroupTeacherId == 0) {
                        isTestTeacher = true;
                        break;
                    } else if (classgroupStudentId == classgroupTeacherId) {
                        isTestTeacher = true;
                        break;
                    }
                }
            }
        }
        return isTestTeacher;
    }

	public Date getTestDate() {
		return testDate;
	}

	public void setTestDate(Date testDate) {
		this.testDate = testDate;
	}

}
