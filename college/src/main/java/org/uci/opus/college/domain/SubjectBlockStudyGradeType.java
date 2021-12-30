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

/**
 * @author Monique in het Veld
 *
 */

public class SubjectBlockStudyGradeType implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private SubjectBlock subjectBlock;
    private StudyGradeType studyGradeType;
    private List < SubjectBlockPrerequisite > subjectBlockPrerequisites;
    private String active;
    private int cardinalTimeUnitNumber;
    private String rigidityTypeCode;
    private String importanceTypeCode;
    
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public List<SubjectBlockPrerequisite> getSubjectBlockPrerequisites() {
        return subjectBlockPrerequisites;
    }
    public void setSubjectBlockPrerequisites(
            List<SubjectBlockPrerequisite> subjectBlockPrerequisites) {
        this.subjectBlockPrerequisites = subjectBlockPrerequisites;
    }
    public SubjectBlock getSubjectBlock() {
        return subjectBlock;
    }
    public void setSubjectBlock(SubjectBlock subjectBlock) {
        this.subjectBlock = subjectBlock;
    }
    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }
    public void setStudyGradeType(StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }
    public String getActive() {
        return active;
    }
    public void setActive(String active) {
        this.active = active;
    }
    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }
    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
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

	 public String toString() {
	        String returnString = 
	        "\n SubjectBlockStudyGradeType is: "
	        + "\n id = " + this.id
	        + "\n subjectBlock = " + this.subjectBlock.toString()
	        + "\n studyGradeTypeId = " + this.studyGradeType.getId()
	        + "\n subjectBlockPrerequisites size = ";
	        if (subjectBlockPrerequisites != null) {
	            returnString += this.subjectBlockPrerequisites.size();
	        }
	        returnString += "\n active = " + this.active
	                + "\n cardinalTimeUnitNumber = " + this.cardinalTimeUnitNumber
	                + "\n rigidityTypeCode = " + this.cardinalTimeUnitNumber
	                + "\n importanceTypeCode = " + this.importanceTypeCode;
	        
	        return returnString;
	}
	 
}
