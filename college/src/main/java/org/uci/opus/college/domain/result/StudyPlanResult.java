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

import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.ThesisResult;

/**
 * @author M. in het Veld
 * @author markus
 */
public class StudyPlanResult implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private Date examDate;
    private String finalMark = "Y";
    private String mark;
    private BigDecimal markDecimal;
    private BigDecimal gradePoint;
    private EndGrade endGrade;
    private String endGradeComment;
    private String active;
    private String passed;
    private ThesisResult thesisResult;
    private String endGradeTypeCode;
    private List<? extends CardinalTimeUnitResult> cardinalTimeUnitResults;
    private List<SubjectResult> subjectResults;
    private String writeWho;
    
    @Override
    public String toString() {
        return "StudyPlanResult [id=" + id + ", studyPlanId=" + studyPlanId + ", examDate=" + examDate + ", finalMark=" + finalMark
                + ", mark=" + mark + ", markDecimal=" + markDecimal + ", gradePoint=" + gradePoint + ", active=" + active + ", passed="
                + passed + "]";
    }

    public String getPassed() {
        return passed;
    }

    public void setPassed(String passed) {
        this.passed = passed;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public int getStudyPlanId() {
        return studyPlanId;
    }

    public void setStudyPlanId(int studyPlanId) {
        this.studyPlanId = studyPlanId;
    }

    public Date getExamDate() {
        return examDate;
    }

    public void setExamDate(Date examDate) {
        this.examDate = examDate;
    }

    public String getFinalMark() {
        return finalMark;
    }

    public void setFinalMark(String finalMark) {
        this.finalMark = finalMark;
    }

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

    /**
     * @return the gradePoint
     * @deprecated use getEndGrade()
     */
    public BigDecimal getGradePoint() {
        return gradePoint;
    }

    /**
     * @param gradePoint
     *            the gradePoint to set
     * @deprecated use setEndGrade()
     */
    public void setGradePoint(BigDecimal gradePoint) {
        this.gradePoint = gradePoint;
    }

    /**
     * @return the endGrade
     */
    public EndGrade getEndGrade() {
        return endGrade;
    }

    /**
     * @param endGrade
     *            the endGrade to set
     */
    public void setEndGrade(EndGrade endGrade) {
        this.endGrade = endGrade;
    }

    /**
     * @return the endGradeComment
     * @deprecated use getEndGrade()
     */
    public String getEndGradeComment() {
        return endGradeComment;
    }

    /**
     * @param endGradeComment
     *            the endGradeComment to set
     * @deprecated use setEndGrade()
     */
    public void setEndGradeComment(String endGradeComment) {
        this.endGradeComment = endGradeComment;
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

    public List<SubjectResult> getSubjectResults() {
        return subjectResults;
    }

    public void setSubjectResults(List<SubjectResult> subjectResults) {
        this.subjectResults = subjectResults;
    }

    public List<? extends CardinalTimeUnitResult> getCardinalTimeUnitResults() {
        return cardinalTimeUnitResults;
    }

    public void setCardinalTimeUnitResults(List<? extends CardinalTimeUnitResult> cardinalTimeUnitResults) {
        this.cardinalTimeUnitResults = cardinalTimeUnitResults;
    }

    /**
     * @return the thesisResult
     */
    public ThesisResult getThesisResult() {
        return thesisResult;
    }

    /**
     * @param thesisResult
     *            the thesisResult to set
     */
    public void setThesisResult(ThesisResult thesisResult) {
        this.thesisResult = thesisResult;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public BigDecimal getMarkDecimal() {
        return markDecimal;
    }

    public void setMarkDecimal(BigDecimal markDecimal) {
        this.markDecimal = markDecimal;
    }

}
