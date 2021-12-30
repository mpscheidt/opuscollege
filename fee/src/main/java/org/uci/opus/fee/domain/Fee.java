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
 * The Original Code is Opus-College fee module code.
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
package org.uci.opus.fee.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;


/**
 * @author move
 *
 */
public class Fee implements Serializable {

    private int id;
    private BigDecimal feeDue;
    private int subjectBlockId;
    private int subjectId;
    private String active;
    private String categoryCode;
    private int subjectBlockStudyGradeTypeId;
    private int subjectStudyGradeTypeId;
    private int studyGradeTypeId;
    private int academicYearId;
    private int branchId;
    private int numberOfInstallments;
//    private int tuitionWaiverDiscountPercentage;
//    private int fulltimeStudentDiscountPercentage;
//    private int localStudentDiscountPercentage;
//    private int continuedRegistrationDiscountPercentage;
//    private int postgraduateDiscountPercentage;
    private String feeUnitCode;
    private String studyIntensityCode = "0";    // 0 = Any, F = fulltime, P = parttime
    private String studyTimeCode = "";
    private String studyFormCode = "";
    private String nationalityGroupCode = "0";  // 0 = other (non-national) , SADC = Southern African Development Community, OTNA = other national 
    private String educationLevelCode;
    private String educationAreaCode;
    private String applicationMode = "A";       // A = Auto, M = manual
    private int cardinalTimeUnitNumber;
    private String writeWho;
    private List<FeeDeadline> deadlines;
    
    public Fee() {
    	feeDue = new BigDecimal(0.00);
    	categoryCode  = "";
    	active = "";
    	feeUnitCode = "";
    	writeWho = "";
    }

    public int getId() {
        return id;
    }
    public void setId(final int newId) {
        id = newId;
    }

    public BigDecimal getFeeDue() {
        return feeDue;
    }
    public void setFeeDue(final BigDecimal feeDue) {
        this.feeDue = feeDue;
    }
    public int getSubjectBlockId() {
        return subjectBlockId;
    }
    public void setSubjectBlockId(final int subjectBlockId) {
        this.subjectBlockId = subjectBlockId;
    }
    public int getSubjectId() {
        return subjectId;
    }
    public void setSubjectId(final int subjectId) {
        this.subjectId = subjectId;
    }
    public String getActive() {
        return active;
    }
    public void setActive(final String newactive) {
        active = newactive;
    }
    public String getCategoryCode() {
        return categoryCode;
    }
    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }
    public int getSubjectBlockStudyGradeTypeId() {
        return subjectBlockStudyGradeTypeId;
    }
    public void setSubjectBlockStudyGradeTypeId(
            final int subjectBlockStudyGradeTypeId) {
        this.subjectBlockStudyGradeTypeId = subjectBlockStudyGradeTypeId;
    }
    public int getSubjectStudyGradeTypeId() {
        return subjectStudyGradeTypeId;
    }
    public void setSubjectStudyGradeTypeId(final int subjectStudyGradeTypeId) {
        this.subjectStudyGradeTypeId = subjectStudyGradeTypeId;
    }
    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }
    public void setStudyGradeTypeId(final int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }
    public int getAcademicYearId() {
        return academicYearId;
    }
    public void setAcademicYearId(final int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public int getBranchId() {
        return branchId;
    }
    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }
    public int getNumberOfInstallments() {
        return numberOfInstallments;
    }
    public void setNumberOfInstallments(final int numberOfInstallments) {
        this.numberOfInstallments = numberOfInstallments;
    }
//    public int getTuitionWaiverDiscountPercentage() {
//        return tuitionWaiverDiscountPercentage;
//    }
//    public void setTuitionWaiverDiscountPercentage(
//            final int tuitionWaiverDiscountPercentage) {
//        this.tuitionWaiverDiscountPercentage = tuitionWaiverDiscountPercentage;
//    }
//    public int getFulltimeStudentDiscountPercentage() {
//        return fulltimeStudentDiscountPercentage;
//    }
//    public void setFulltimeStudentDiscountPercentage(
//            final int fulltimeStudentDiscountPercentage) {
//        this.fulltimeStudentDiscountPercentage = fulltimeStudentDiscountPercentage;
//    }
//    public int getLocalStudentDiscountPercentage() {
//        return localStudentDiscountPercentage;
//    }
//    public void setLocalStudentDiscountPercentage(
//            final int localStudentDiscountPercentage) {
//        this.localStudentDiscountPercentage = localStudentDiscountPercentage;
//    }
//    public int getContinuedRegistrationDiscountPercentage() {
//        return continuedRegistrationDiscountPercentage;
//    }
//    public void setContinuedRegistrationDiscountPercentage(
//            final int continuedRegistrationDiscountPercentage) {
//        this.continuedRegistrationDiscountPercentage = continuedRegistrationDiscountPercentage;
//    }
//    public int getPostgraduateDiscountPercentage() {
//        return postgraduateDiscountPercentage;
//    }
//    public void setPostgraduateDiscountPercentage(
//            final int postgraduateDiscountPercentage) {
//        this.postgraduateDiscountPercentage = postgraduateDiscountPercentage;
//    }
    /**
     * @return the writeWho
     */
    public String getWriteWho() {
        return writeWho;
    }
    /**
     * @param writeWho the writeWho to set
     */
    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

	public List<FeeDeadline> getDeadlines() {
		return deadlines;
	}
	public void setDeadlines(List<FeeDeadline> deadlines) {
		this.deadlines = deadlines;
	}

    public void setFeeUnitCode(String feeUnitCode) {
        this.feeUnitCode = feeUnitCode;
    }
    public String getFeeUnitCode() {
        return feeUnitCode;
    }
    public void setStudyIntensityCode(String studyIntensityCode) {
        this.studyIntensityCode = studyIntensityCode;
    }
    public String getStudyIntensityCode() {
        return studyIntensityCode;
    }
    
    public String getStudyTimeCode() {
		return studyTimeCode;
	}

	public void setStudyTimeCode(String studyTimeCode) {
		this.studyTimeCode = studyTimeCode;
	}

	public String getStudyFormCode() {
		return studyFormCode;
	}

	public void setStudyFormCode(String studyFormCode) {
		this.studyFormCode = studyFormCode;
	}

	public String getNationalityGroupCode() {
		return nationalityGroupCode;
	}

	public void setNationalityGroupCode(String nationalityGroupCode) {
		this.nationalityGroupCode = nationalityGroupCode;
	}

	public String getEducationLevelCode() {
		return educationLevelCode;
	}

	public void setEducationLevelCode(String educationLevelCode) {
		this.educationLevelCode = educationLevelCode;
	}

	public String getEducationAreaCode() {
		return educationAreaCode;
	}

	public void setEducationAreaCode(String educationAreaCode) {
		this.educationAreaCode = educationAreaCode;
	}

	public void setApplicationMode(String applicationMode) {
        this.applicationMode = applicationMode;
    }
    public String getApplicationMode() {
        return applicationMode;
    }
    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }
    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }

    public String toString() {
        return
        "\n Fee is: "
        + "\n id = " + this.id
        + "\n feeDue = " + this.feeDue
        + "\n categoryCode = " + this.categoryCode
        + "\n studyGradeTypeId = " + this.studyGradeTypeId 
        + "\n academicYearId = " + this.academicYearId
        + "\n feeUnitCode = " + this.feeUnitCode
        + "\n cardinalTimeUnitNumber = " + this.cardinalTimeUnitNumber;
    }

}
