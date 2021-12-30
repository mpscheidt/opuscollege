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

/**
 * @author M. in het Veld
 *
 */

public class CardinalTimeUnitStudyGradeType implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyGradeTypeId;
    private int cardinalTimeUnitNumber;
    private int numberOfElectiveSubjectBlocks;
    private int numberOfElectiveSubjects;

    /**
     * Constructor, set defaults.
     */
    public CardinalTimeUnitStudyGradeType() {
        numberOfElectiveSubjectBlocks = 0;
        numberOfElectiveSubjects = 0;
    }
    
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
	 * @return the studyGradeTypeId
	 */
	public int getStudyGradeTypeId() {
		return studyGradeTypeId;
	}
	/**
	 * @param studyGradeTypeId the studyGradeTypeId to set
	 */
	public void setStudyGradeTypeId(int studyGradeTypeId) {
		this.studyGradeTypeId = studyGradeTypeId;
	}
	/**
	 * @return the cardinalTimeUnitNumber
	 */
	public int getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}
	/**
	 * @param cardinalTimeUnitNumber the cardinalTimeUnitNumber to set
	 */
	public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
		this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
	}
	/**
	 * @return the numberOfElectiveSubjectBlocks
	 */
	public int getNumberOfElectiveSubjectBlocks() {
		return numberOfElectiveSubjectBlocks;
	}
	/**
	 * @param numberOfElectiveSubjectBlocks the numberOfElectiveSubjectBlocks to set
	 */
	public void setNumberOfElectiveSubjectBlocks(
			int numberOfElectiveSubjectBlocks) {
		this.numberOfElectiveSubjectBlocks = numberOfElectiveSubjectBlocks;
	}
	/**
	 * @return the numberOfElectiveSubjects
	 */
	public int getNumberOfElectiveSubjects() {
		return numberOfElectiveSubjects;
	}
	/**
	 * @param numberOfElectiveSubjects the numberOfElectiveSubjects to set
	 */
	public void setNumberOfElectiveSubjects(int numberOfElectiveSubjects) {
		this.numberOfElectiveSubjects = numberOfElectiveSubjects;
	}
    
}
