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

package org.uci.opus.college.domain.result;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.Test;

/**
 * @author M. in het Veld
 * @author markus
 */
public class TestResult implements IResultAttempt, Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int testId;
    private int examinationId;
    private int studyPlanDetailId;
    private Date testResultDate;
    private int attemptNr;
    private String mark;
    private BigDecimal gradePoint;
    private String endGrade;
    private String endGradeComment;
    private int staffMemberId;
    private String active;
    private String passed;
    private String endGradeTypeCode;
    private String writeWho;
    private Date writeWhen;
    private Integer testResultCommentId;

    private Test test;
    
    public TestResult() {
        endGradeTypeCode = "CA";
    }

    @Override
    public String getUniqueKey() {
        String key = getStudyPlanDetailId() + "-" + getTestId() + "-" + getAttemptNr();
        return key;
    }

    @Override
    public String toString() {
        return "TestResult [id=" + id + ", testId=" + testId + ", studyPlanDetailId=" + studyPlanDetailId + ", testResultDate=" + testResultDate
                + ", attemptNr=" + attemptNr + ", mark=" + mark + ", staffMemberId=" + staffMemberId + ", active=" + active + ", passed=" + passed + "]";
    }

    @Override
    public boolean unmodified(IResult origResult) {
        if (this == origResult)
            return true;
        if (origResult == null)
            return false;
        if (getClass() != origResult.getClass())
            return false;
        TestResult other = (TestResult) origResult;

        return new EqualsBuilder().append(id, other.getId()).append(examinationId, other.getExaminationId())
                .append(studyPlanDetailId, other.getStudyPlanDetailId()).append(testResultDate, other.getTestResultDate())
                .append(attemptNr, other.getAttemptNr()).append(mark, other.getMark()).append(testResultCommentId, other.getTestResultCommentId())
                .append(passed, other.getPassed()).append(staffMemberId, other.getStaffMemberId()).append(active, other.getActive()).isEquals();
    }

    @Override
    public int getSubjectExamTestId() {
        return getTestId();
    }

    /**
     * There are no sub results for a TestResult, therefore an empty list is returned.
     */
    @Override
    public List<? extends IResult> getSubResults() {
        return Collections.emptyList();
    }

    public int getAttemptNr() {
        return attemptNr;
    }

    public void setAttemptNr(int attemptNr) {
        this.attemptNr = attemptNr;
    }

    public int getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(int examinationId) {
        this.examinationId = examinationId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

    /**
     * @return the gradePoint
     */
    public BigDecimal getGradePoint() {
        return gradePoint;
    }

    /**
     * @param gradePoint
     *            the gradePoint to set
     */
    public void setGradePoint(BigDecimal gradePoint) {
        this.gradePoint = gradePoint;
    }

    /**
     * @return the endGrade
     */
    public String getEndGrade() {
        return endGrade;
    }

    /**
     * @param endGrade
     *            the endGrade to set
     */
    public void setEndGrade(String endGrade) {
        this.endGrade = endGrade;
    }

    /**
     * @return the endGradeComment
     */
    public String getEndGradeComment() {
        return endGradeComment;
    }

    /**
     * @param endGradeComment
     *            the endGradeComment to set
     */
    public void setEndGradeComment(String endGradeComment) {
        this.endGradeComment = endGradeComment;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public int getStaffMemberId() {
        return staffMemberId;
    }

    public void setStaffMemberId(int staffMemberId) {
        this.staffMemberId = staffMemberId;
    }

    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }

    public void setStudyPlanDetailId(int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
    }

    public String getPassed() {
        return passed;
    }

    public void setPassed(String passed) {
        this.passed = passed;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public Date getTestResultDate() {
        return testResultDate;
    }

    public void setTestResultDate(Date testResultDate) {
        this.testResultDate = testResultDate;
    }

    /**
     * @return the endGradeTypeCode
     */
    public String getEndGradeTypeCode() {
        return endGradeTypeCode;
    }

    /**
     * @param endGradeTypeCode
     *            the endGradeTypeCode to set
     */
    public void setEndGradeTypeCode(String endGradeTypeCode) {
        this.endGradeTypeCode = endGradeTypeCode;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public Integer getTestResultCommentId() {
        return testResultCommentId;
    }

    public void setTestResultCommentId(Integer testResultCommentId) {
        this.testResultCommentId = testResultCommentId;
    }

    public Date getWriteWhen() {
        return writeWhen;
    }

    public void setWriteWhen(Date writeWhen) {
        this.writeWhen = writeWhen;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    @Override
    public ISubjectExamTest getSubjectExamTest() {
        return getTest();
    }
}
