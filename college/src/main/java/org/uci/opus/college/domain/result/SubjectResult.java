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
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.ISubjectExamTest;
import org.uci.opus.college.domain.Subject;

/**
 * @author M. in het Veld
 * @author markus
 *
 */
public class SubjectResult implements IResult, Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int subjectId;
    private int studyPlanDetailId;
    private Date subjectResultDate;
    private String mark;
    private BigDecimal markDecimal;
    private BigDecimal gradePoint;
    private String endGrade;
    private String endGradeComment;
    private int staffMemberId;
    private String active;
    private String passed;
    private String endGradeTypeCode; // loaded by Exam.SubjectResultResultMap using studyPlanDetailId and set to
                                     // studyGradeType.gradeTypeCode
    private Integer subjectResultCommentId;

    private List<ExaminationResult> examinationResults;
    private String writeWho;
    private EndGrade endGradeObject;

    private Subject subject;

    public SubjectResult() {
        active = "Y";
        endGradeTypeCode = "SR";
    }

    public SubjectResult(int subjectId, int studyPlanDetailId) {
        this();
        this.subjectId = subjectId;
        this.studyPlanDetailId = studyPlanDetailId;
    }

    public SubjectResult(int subjectId, int studyPlanDetailId, int staffMemberId, Date subjectResultDate) {
        this(subjectId, studyPlanDetailId);
        this.staffMemberId = staffMemberId;
        this.subjectResultDate = subjectResultDate;
    }

    public SubjectResult(int subjectId, int studyPlanDetailId, int staffMemberId, String mark, String passed) {
        this();
        this.subjectId = subjectId;
        this.studyPlanDetailId = studyPlanDetailId;
        this.staffMemberId = staffMemberId;
        this.mark = mark;
        this.passed = passed;
    }

    @Override
    public boolean unmodified(IResult origResult) {
        if (this == origResult)
            return true;
        if (origResult == null)
            return false;
        if (getClass() != origResult.getClass())
            return false;
        SubjectResult other = (SubjectResult) origResult;

        // difference to examination and test result is the endGradeComment
        return new EqualsBuilder().append(id, other.getId()).append(subjectId, other.getSubjectId())
                .append(studyPlanDetailId, other.getStudyPlanDetailId()).append(subjectResultDate, other.getSubjectResultDate())
                .append(mark, other.getMark()).append(passed, other.getPassed()).append(staffMemberId, other.getStaffMemberId())
                .append(active, other.getActive()).append(endGradeComment, other.getEndGradeComment()).isEquals();
    }
    
    @Override
    public List<? extends IResult> getSubResults() {
        // NB: need to call the getter (rather than returning the field value) so that lazy loading proxy can jump in
        return getExaminationResults();
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

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public Date getSubjectResultDate() {
        return subjectResultDate;
    }

    public void setSubjectResultDate(Date subjectResultDate) {
        this.subjectResultDate = subjectResultDate;
    }

    public List<ExaminationResult> getExaminationResults() {
        return examinationResults;
    }

    public void setExaminationResults(List<ExaminationResult> examinationResults) {
        this.examinationResults = examinationResults;
    }

    public String getPassed() {
        return passed;
    }

    public void setPassed(String passed) {
        this.passed = passed;
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

    public EndGrade getEndGradeObject() {
        return endGradeObject;
    }

    public void setEndGradeObject(EndGrade endGradeObject) {
        this.endGradeObject = endGradeObject;
    }

    @Override
    public String getUniqueKey() {
        String key = getStudyPlanDetailId() + "-" + getSubjectId();
        return key;
    }

    @Override
    public String toString() {
        return "SubjectResult [id=" + id + ", subjectId=" + subjectId + ", studyPlanDetailId=" + studyPlanDetailId + ", subjectResultDate="
                + subjectResultDate + ", mark=" + mark + ", endGradeComment=" + endGradeComment + ", staffMemberId=" + staffMemberId
                + ", active=" + active + ", passed=" + passed + ", subjectResultCommentId=" + subjectResultCommentId + "]";
    }

    @Override
    public int getSubjectExamTestId() {
        return subjectId;
    }

    public BigDecimal getMarkDecimal() {
        return markDecimal;
    }

    public void setMarkDecimal(BigDecimal markDecimal) {
        this.markDecimal = markDecimal;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    @Override
    public ISubjectExamTest getSubjectExamTest() {
        return getSubject();
    }

	public Integer getSubjectResultCommentId() {
		return subjectResultCommentId;
	}

	public void setSubjectResultCommentId(Integer subjectResultCommentId) {
		this.subjectResultCommentId = subjectResultCommentId;
	}
}
