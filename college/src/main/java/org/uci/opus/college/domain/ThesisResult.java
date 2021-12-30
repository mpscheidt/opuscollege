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
import java.math.BigDecimal;
import java.util.Date;

public class ThesisResult implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private int thesisId;
    private Date thesisResultDate;
    private String mark;
    private BigDecimal gradePoint;
    private String endGrade;
    private String endGradeComment;
    private String active;
    private String passed;
    private String calculationMessage;
    private String endGradeTypeCode;
    private String writeWho;
    
	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return the studyPlanId
	 */
	public int getStudyPlanId() {
		return studyPlanId;
	}
	/**
	 * @param studyPlanId the studyPlanId to set
	 */
	public void setStudyPlanId(int studyPlanId) {
		this.studyPlanId = studyPlanId;
	}
	
	/**
	 * @return the thesisId
	 */
	public int getThesisId() {
		return thesisId;
	}
	/**
	 * @param thesisId the thesisId to set
	 */
	public void setThesisId(int thesisId) {
		this.thesisId = thesisId;
	}
	/**
	 * @return the thesisResultDate
	 */
	public Date getThesisResultDate() {
		return thesisResultDate;
	}
	/**
	 * @param thesisResultDate the thesisResultDate to set
	 */
	public void setThesisResultDate(Date thesisResultDate) {
		this.thesisResultDate = thesisResultDate;
	}
	/**
	 * @return the mark
	 */
	public String getMark() {
		return mark;
	}
	/**
	 * @param mark the mark to set
	 */
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
	 * @param gradePoint the gradePoint to set
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
	 * @param endGrade the endGrade to set
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
	 * @param endGradeComment the endGradeComment to set
	 */
	public void setEndGradeComment(String endGradeComment) {
		this.endGradeComment = endGradeComment;
	}
	/**
	 * @return the active
	 */
	public String getActive() {
		return active;
	}
	/**
	 * @param active the active to set
	 */
	public void setActive(String active) {
		this.active = active;
	}
	/**
	 * @return the passed
	 */
	public String getPassed() {
		return passed;
	}
	/**
	 * @param passed the passed to set
	 */
	public void setPassed(String passed) {
		this.passed = passed;
	}
	/**
	 * @return the calculationMessage
	 */
	public String getCalculationMessage() {
		return calculationMessage;
	}
	/**
	 * @param calculationMessage the calculationMessage to set
	 */
	public void setCalculationMessage(String calculationMessage) {
		this.calculationMessage = calculationMessage;
	}
	
	/**
	 * @return the endGradeTypeCode
	 */
	public String getEndGradeTypeCode() {
		return endGradeTypeCode;
	}
	/**
	 * @param endGradeTypeCode the endGradeTypeCode to set
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
    
}
