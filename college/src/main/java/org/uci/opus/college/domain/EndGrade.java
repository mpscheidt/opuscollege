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

/**
 * @author move
 *
 */
public class EndGrade implements Serializable {

    private static final long serialVersionUID = 1L;

    private String lang;
    private String code;
    private String active = "Y";
    private int id;
    private String endGradeTypeCode;
    private BigDecimal gradePoint;
    private BigDecimal percentageMin;
    private BigDecimal percentageMax;
    private String comment;
    private String passed;
    private String temporaryGrade = "N";
    private String description;
    private int academicYearId;
    private String writeWho;

    public EndGrade() {
        this.active = "Y";
        temporaryGrade = "N";
    }

    public EndGrade(String lang) {
        super();
        this.lang = lang;
    }

    public String getDescription() {
        return description;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String newCode) {
        code = newCode;
    }

    public void setDescription(String newDescription) {
        description = newDescription;
    }

    public int getId() {
        return id;
    }

    public void setId(int newId) {
        id = newId;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String newLang) {
        lang = newLang;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public String getEndGradeTypeCode() {
        return endGradeTypeCode;
    }

    public void setEndGradeTypeCode(String endGradeTypeCode) {
        this.endGradeTypeCode = endGradeTypeCode;
    }

    public BigDecimal getGradePoint() {
        return gradePoint;
    }

    public void setGradePoint(BigDecimal gradePoint) {
        this.gradePoint = gradePoint;
    }

    public BigDecimal getPercentageMin() {
        return percentageMin;
    }

    public void setPercentageMin(BigDecimal percentageMin) {
        this.percentageMin = percentageMin;
    }

    public BigDecimal getPercentageMax() {
        return percentageMax;
    }

    public void setPercentageMax(BigDecimal percentageMax) {
        this.percentageMax = percentageMax;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    /**
     * @return the passed
     */
    public String getPassed() {
        return passed;
    }

    /**
     * @param passed
     *            the passed to set
     */
    public void setPassed(String passed) {
        this.passed = passed;
    }

    public String getTemporaryGrade() {
        return temporaryGrade;
    }

    public void setTemporaryGrade(String temporaryGrade) {
        this.temporaryGrade = temporaryGrade;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public String toString() {
        return "\n EndGrade is: " + "\n id = " + id + "\n code = " + code + "\n gradePoint = " + gradePoint + "\n percentageMin = " + percentageMin
                + "\n percentageMax = " + percentageMax + "\n passed = " + passed + "\n description = " + description + "\n comment = " + comment
                + "\n endGradeTypeCode = " + endGradeTypeCode + "\n temporaryGrade = " + temporaryGrade + "\n academicYearId = " + academicYearId
                + "\n active = " + active + "\n lang = " + lang + "\n writeWho = " + writeWho;
    }

}
