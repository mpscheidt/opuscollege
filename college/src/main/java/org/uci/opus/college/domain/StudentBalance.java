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
package org.uci.opus.college.domain;

import java.io.Serializable;
import java.math.BigDecimal;

public class StudentBalance implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private int feeId;
    // fees on studyGradeType
    private int studyPlanCardinalTimeUnitId;
    // fees on subject(Blocks)
    private int studyPlanDetailId;
    // fees on branch level
    private int academicYearId;
    // used for the balanceBroughtForward
    private BigDecimal amount;
    private String exemption;
    private String writeWho;

    public StudentBalance() {

    }

    public StudentBalance(int studentId, int feeId, String exemption, String writeWho) {
        this.studentId = studentId;
        this.feeId = feeId;
        this.exemption = exemption;
        this.writeWho = writeWho;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getFeeId() {
        return feeId;
    }

    public void setFeeId(int feeId) {
        this.feeId = feeId;
    }

    public int getStudyPlanCardinalTimeUnitId() {
        return studyPlanCardinalTimeUnitId;
    }

    public void setStudyPlanCardinalTimeUnitId(int studyPlanCardinalTimeUnitId) {
        this.studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnitId;
    }

    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }

    public void setStudyPlanDetailId(int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getExemption() {
        return exemption;
    }

    public void setExemption(String exemption) {
        this.exemption = exemption;
    }

    /**
     * @return the writeWho
     */
    public String getWriteWho() {
        return writeWho;
    }

    /**
     * @param writeWho
     *            the writeWho to set
     */
    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public String toString() {
        return "\n StudentBalance is: " + "\n id = " + this.id + "\n studentId = " + this.studentId + "\n feeId = " + this.feeId
                + "\n studyPlanCardinalTimeUnitId = " + this.studyPlanCardinalTimeUnitId + "\n studyPlanDetailId = " + this.studyPlanDetailId
                + "\n academicYearId = " + this.academicYearId + "\n amount = " + this.amount + "\n exemption = " + this.exemption + "\n writeWho = "
                + this.writeWho;
    }

}
