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
import java.util.List;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

/**
 * @author J. Nooitgedagt
 *
 */
public class SubjectStudyGradeType implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int subjectId;
    private int studyId;
    private String gradeTypeCode;
    private int studyGradeTypeId;
    private Subject subject;
    private StudyGradeType studyGradeType;
    private String studyDescription;
    private String gradeTypeDescription;
    private List < SubjectPrerequisite > subjectPrerequisites;
    private String active;
    
    // Integer (not int) so that an empty value can be selected in the GUI
    // Reason is that 0 has a special meaning (0=Any), but field is compulsory (user needs to actively select CTUnr)  
    private Integer cardinalTimeUnitNumber;
    private String rigidityTypeCode;
    private String importanceTypeCode;
    
    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 31)
                .append(id)
                .append(subjectId)
                .append(studyId)
                .append(gradeTypeCode)
                .append(studyGradeTypeId)
                .append(active)
                .append(cardinalTimeUnitNumber)
                .append(rigidityTypeCode)
                .append(importanceTypeCode)
                .toHashCode();
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;
        if (obj == this)
            return true;
        if (!(obj instanceof SubjectStudyGradeType))
            return false;
        
        SubjectStudyGradeType other = (SubjectStudyGradeType) obj;
        return new EqualsBuilder()
                .append(id, other.getId())
                .append(subjectId, other.getSubjectId())
                .append(studyId, other.getStudyId())
                .append(gradeTypeCode, other.getGradeTypeCode())
                .append(studyGradeTypeId, other.getStudyGradeTypeId())
                .append(active, other.getActive())
                .append(cardinalTimeUnitNumber, other.getCardinalTimeUnitNumber())
                .append(rigidityTypeCode, other.getRigidityTypeCode())
                .append(importanceTypeCode, other.getImportanceTypeCode())
                .isEquals();
    }
    
    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public String getGradeTypeDescription() {
        return gradeTypeDescription;
    }

    public void setGradeTypeDescription(String gradeTypeDescription) {
        this.gradeTypeDescription = gradeTypeDescription;
    }

    public String getStudyDescription() {
        return studyDescription;
    }

    public void setStudyDescription(String studyDescription) {
        this.studyDescription = studyDescription;
    }

    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    public void setStudyGradeTypeId(int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    /**
	 * @return the subject
	 */
	public Subject getSubject() {
		return subject;
	}
	/**
	 * @param subject the subject to set
	 */
	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	/**
	 * @return the studyGradeType
	 */
	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}
	/**
	 * @param studyGradeType the studyGradeType to set
	 */
	public void setStudyGradeType(StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	public String getGradeTypeCode() {
        return gradeTypeCode;
    }

    public void setGradeTypeCode(String gradeTypeCode) {
        this.gradeTypeCode = gradeTypeCode;
    }

    public int getStudyId() {
        return studyId;
    }

    public void setStudyId(int studyId) {
        this.studyId = studyId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public List < SubjectPrerequisite > getSubjectPrerequisites() {
        return subjectPrerequisites;
    }

    public void setSubjectPrerequisites(
                        List < SubjectPrerequisite > subjectPrerequisites) {
        this.subjectPrerequisites = subjectPrerequisites;
    }

    public Integer getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }
    public void setCardinalTimeUnitNumber(Integer cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

    public String getRigidityTypeCode() {
        return rigidityTypeCode;
    }

    public void setRigidityTypeCode(String rigidityTypeCode) {
        this.rigidityTypeCode = rigidityTypeCode;
    }

	/**
	 * @return the importanceTypeCode
	 */
	public String getImportanceTypeCode() {
		return importanceTypeCode;
	}

	/**
	 * @param importanceTypeCode the importanceTypeCode to set
	 */
	public void setImportanceTypeCode(String importanceTypeCode) {
		this.importanceTypeCode = importanceTypeCode;
	}


}
