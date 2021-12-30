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
import java.util.Date;

/**
 * @author move
 *
 */
public class Payment implements Serializable {

    private int id;
    private Date payDate;
    private int studentId;
    private int studyPlanDetailId;
    private int subjectBlockId;
    private int subjectId;
    private BigDecimal sumPaid;
    private String active;
    private int feeId;
    private int studentBalanceId;
    private int installmentNumber;
    private String writeWho;
    
    public int getId() {
        return id;
    }
    public void setId(final int newId) {
        id = newId;
    }

    public Date getPayDate() {
        return payDate;
    }
    public void setPayDate(final Date payDate) {
        this.payDate = payDate;
    }
    public int getStudentId() {
        return studentId;
    }
    public void setStudentId(final int studentId) {
        this.studentId = studentId;
    }

    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }
    public void setStudyPlanDetailId(final int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
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

    public BigDecimal getSumPaid() {
        return sumPaid;
    }
    public void setSumPaid(final BigDecimal sumPaid) {
        this.sumPaid = sumPaid;
    }
    public String getActive() {
        return active;
    }
    public void setActive(final String newactive) {
        active = newactive;
    }
    public int getFeeId() {
        return feeId;
    }
    public void setFeeId(final int feeId) {
        this.feeId = feeId;
    }
    public int getStudentBalanceId() {
        return studentBalanceId;
    }
    public void setStudentBalanceId(final int studentBalanceId) {
        this.studentBalanceId = studentBalanceId;
    }
    public int getInstallmentNumber() {
        return installmentNumber;
    }
    public void setInstallmentNumber(final int installmentNumber) {
        this.installmentNumber = installmentNumber;
    }
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

}
