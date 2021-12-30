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
import java.util.Date;
import java.util.List;

/**
 * @author M. in het Veld
 * 
 */
public class Examination implements IAttempt, Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String examinationCode;
    private String examinationDescription;
    private int subjectId;
    private String examinationTypeCode;
    private int numberOfAttempts;
    private int weighingFactor;
    private String BRsPassingExamination;
    private Date examinationDate;
    private String active;
    private List<ExaminationTeacher> teachersForExamination;
    private List<Test> tests;
    private Subject subject;
    
    public Examination() {
        super();
    }
    
    @Override
    public String toString() {
        return "Examination [id=" + id + ", examinationCode=" + examinationCode + ", examinationDescription=" + examinationDescription + ", subjectId="
                + subjectId + ", examinationTypeCode=" + examinationTypeCode + ", numberOfAttempts=" + numberOfAttempts + ", weighingFactor=" + weighingFactor
                + ", BRsPassingExamination=" + BRsPassingExamination + ", examinationDate=" + examinationDate + ", active=" + active + "]";
    }

    @Override
    public List<? extends ISubjectExamTest> getSubItems() {
        // NB: need to call the getter (rather than returning the field value) so that lazy loading proxy can jump in
        return getTests();
    }

    public String getBRsPassingExamination() {
        return BRsPassingExamination;
    }

    public void setBRsPassingExamination(String rsPassingExamination) {
        BRsPassingExamination = rsPassingExamination;
    }

    public String getCode() {
        return getExaminationCode();
    }
    
    public String getExaminationCode() {
        return examinationCode;
    }

    public void setExaminationCode(String examinationCode) {
        this.examinationCode = examinationCode;
    }

    public String getDescription() {
        return getExaminationDescription();
    }

    public String getExaminationDescription() {
        return examinationDescription;
    }

    public void setExaminationDescription(String examinationDescription) {
        this.examinationDescription = examinationDescription;
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

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getWeighingFactor() {
        return weighingFactor;
    }

    public void setWeighingFactor(int weighingFactor) {
        this.weighingFactor = weighingFactor;
    }

    public List<ExaminationTeacher> getTeachersForExamination() {
        return teachersForExamination;
    }

    public void setTeachersForExamination(List<ExaminationTeacher> teachersForExamination) {
        this.teachersForExamination = teachersForExamination;
    }

    public List<Test> getTests() {
        return tests;
    }

    public void setTests(List<Test> tests) {
        this.tests = tests;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }
    
    
    public Date getExaminationDate() {
		return examinationDate;
	}

	public void setExaminationDate(Date examinationDate) {
		this.examinationDate = examinationDate;
	}

    @Override
    public boolean isAssignedTeacher(int staffMemberId, Integer classgroupId) {
        boolean isExaminationTeacher = false;
        int classgroupStudentId = classgroupId != null ? classgroupId : 0;
        if (getTeachersForExamination() != null) {
            for (ExaminationTeacher examinationTeacher : getTeachersForExamination()) {
                if (staffMemberId == examinationTeacher.getStaffMemberId()) {
                    int classgroupTeacherId = examinationTeacher.getClassgroupId() != null ? examinationTeacher.getClassgroupId() : 0;
                    if (classgroupStudentId == 0 || classgroupTeacherId == 0) {
                        isExaminationTeacher = true;
                        break;
                    } else if (classgroupStudentId == classgroupTeacherId) {
                        isExaminationTeacher = true;
                        break;
                    }
                }
            }
        }
        return isExaminationTeacher;
    }

	

}
