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

package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.domain.util.IdToSubjectBlockMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.util.CodeToLookupMap;

public class StudyPlanCardinalTimeUnitForm {

    private Organization organization;
    private NavigationSettings navigationSettings;
	
	private String txtMsg;

	private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
	private StudyPlan studyPlan;
    private Student student;
    private StudyGradeType studyGradeType;
    private CardinalTimeUnitStudyGradeType cardinalTimeUnitStudyGradeType;
    
    private int maxNumberOfCardinalTimeUnits;
    private int totalNumberOfSubjects;
    private int maxNumberOfSubjectsPerCardinalTimeUnit;
	
    private List <AcademicYear> allAcademicYears;
	
    private List<StudyGradeType> allStudyGradeTypes;
    private List < ? extends Study > allStudies = null;
    private List<SubjectStudyGradeType> allSubjectStudyGradeTypes = null;
    private List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = null;
//    private List < Subject > allCompulsorySubjects;
//    private List < ? extends SubjectBlock > allCompulsorySubjectBlocks;
//    private List < ? extends Subject > allElectiveSubjects;
//    private List < ? extends SubjectBlock > allElectiveSubjectBlocks;
//    private List < SubjectStudyGradeType > allCompulsorySubjectStudyGradeTypes;
//    private List < SubjectStudyGradeType > allElectiveSubjectStudyGradeTypes;
//    private List < ? extends SubjectBlockStudyGradeType > allCompulsorySubjectBlockStudyGradeTypes;
//    private List < ? extends SubjectBlockStudyGradeType > allElectiveSubjectBlockStudyGradeTypes;
    
    private List<Lookup> allCardinalTimeUnitStatuses;
    private List<Lookup> allStudyIntensities;
    private List<Lookup7> allProgressStatuses;

    private IdToAcademicYearMap idToAcademicYearMap;
    private IdToOrganizationalUnitMap idToOrganizationalUnitMap;
    private IdToStudyGradeTypeMap idToStudyGradeTypeMap;
    private IdToStudyMap idToStudyMap;
    private IdToSubjectBlockMap idToSubjectBlockMap;
    private IdToSubjectMap idToSubjectMap;

    private CodeToLookupMap codeToGradeTypeMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyIntensityMap;
    
    private CodeToLookupMap codeToImportanceTypeMap;
    private CodeToLookupMap codeToRigidityTypeMap;
    private CodeToLookupMap codeToStudyFormMap;
    
    private CodeToLookupMap codeToCardinalTimeUnitStatusMap;
    private CodeToLookupMap codeToProgressStatusMap;

	public StudyPlanCardinalTimeUnitForm() {
		txtMsg = "";
		maxNumberOfCardinalTimeUnits = 0;
	}

	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}
	/**
	 * @param organization the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}
	
	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	/**
	 * @param navigationSettings the navigationSettings to set
	 */
	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}
	
	/**
	 * @return the studyPlanCardinalTimeUnit
	 */
	public StudyPlanCardinalTimeUnit getStudyPlanCardinalTimeUnit() {
		return studyPlanCardinalTimeUnit;
	}

	/**
	 * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit to set
	 */
	public void setStudyPlanCardinalTimeUnit(
			final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
		this.studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnit;
	}

	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}

	/**
	 * @return the studyPlan
	 */
	public StudyPlan getStudyPlan() {
		return studyPlan;
	}

	/**
	 * @param studyPlan the studyPlan to set
	 */
	public void setStudyPlan(final StudyPlan studyPlan) {
		this.studyPlan = studyPlan;
	}

	/**
	 * @return the student
	 */
	public Student getStudent() {
		return student;
	}

	/**
	 * @param student the student to set
	 */
	public void setStudent(final Student student) {
		this.student = student;
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
	public void setStudyGradeType(final StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	
	
	/**
	 * @return the cardinalTimeUnitStudyGradeType
	 */
	public CardinalTimeUnitStudyGradeType getCardinalTimeUnitStudyGradeType() {
		return cardinalTimeUnitStudyGradeType;
	}

	/**
	 * @param cardinalTimeUnitStudyGradeType the cardinalTimeUnitStudyGradeType to set
	 */
	public void setCardinalTimeUnitStudyGradeType(
			final CardinalTimeUnitStudyGradeType cardinalTimeUnitStudyGradeType) {
		this.cardinalTimeUnitStudyGradeType = cardinalTimeUnitStudyGradeType;
	}

	/**
	 * @return the maxNumberOfCardinalTimeUnits
	 */
	public int getMaxNumberOfCardinalTimeUnits() {
		return maxNumberOfCardinalTimeUnits;
	}

	/**
	 * @param maxNumberOfCardinalTimeUnits the maxNumberOfCardinalTimeUnits to set
	 */
	public void setMaxNumberOfCardinalTimeUnits(
			final int maxNumberOfCardinalTimeUnits) {
		this.maxNumberOfCardinalTimeUnits = maxNumberOfCardinalTimeUnits;
	}

	
	
	/**
	 * @return the totalNumberOfSubjects
	 */
	public int getTotalNumberOfSubjects() {
		return totalNumberOfSubjects;
	}

	/**
	 * @param totalNumberOfSubjects the totalNumberOfSubjects to set
	 */
	public void setTotalNumberOfSubjects(final int totalNumberOfSubjects) {
		this.totalNumberOfSubjects = totalNumberOfSubjects;
	}

	/**
	 * @return the allAcademicYears
	 */
	public List<AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}
	/**
	 * @param allAcademicYears the allAcademicYears to set
	 */
	public void setAllAcademicYears(final List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	/**
	 * @return the allStudyGradeTypes
	 */
	public List<StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	/**
	 * @param allStudyGradeTypes the allStudyGradeTypes to set
	 */
    public void setAllStudyGradeTypes(List<StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}

	/**
	 * @return the allStudies
	 */
	public List<? extends Study> getAllStudies() {
		return allStudies;
	}

	/**
	 * @param allStudies the allStudies to set
	 */
	public void setAllStudies(final List<? extends Study> allStudies) {
		this.allStudies = allStudies;
	}

    public int getMaxNumberOfSubjectsPerCardinalTimeUnit() {
        return maxNumberOfSubjectsPerCardinalTimeUnit;
    }

    public void setMaxNumberOfSubjectsPerCardinalTimeUnit(
            int maxNumberOfSubjectsPerCardinalTimeUnit) {
        this.maxNumberOfSubjectsPerCardinalTimeUnit = maxNumberOfSubjectsPerCardinalTimeUnit;
    }

    public IdToOrganizationalUnitMap getIdToOrganizationalUnitMap() {
        return idToOrganizationalUnitMap;
    }

    public void setIdToOrganizationalUnitMap(IdToOrganizationalUnitMap idToOrganizationalUnitMap) {
        this.idToOrganizationalUnitMap = idToOrganizationalUnitMap;
    }

    public void setIdToStudyMap(IdToStudyMap idToStudyMap) {
        this.idToStudyMap = idToStudyMap;
    }

    public IdToStudyMap getIdToStudyMap() {
        return idToStudyMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        return codeToGradeTypeMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public IdToStudyGradeTypeMap getIdToStudyGradeTypeMap() {
        return idToStudyGradeTypeMap;
    }

    public void setIdToStudyGradeTypeMap(IdToStudyGradeTypeMap idToStudyGradeTypeMap) {
        this.idToStudyGradeTypeMap = idToStudyGradeTypeMap;
    }

    public CodeToLookupMap getCodeToImportanceTypeMap() {
        return codeToImportanceTypeMap;
    }

    public void setCodeToImportanceTypeMap(CodeToLookupMap codeToImportanceTypeMap) {
        this.codeToImportanceTypeMap = codeToImportanceTypeMap;
    }

    public CodeToLookupMap getCodeToRigidityTypeMap() {
        return codeToRigidityTypeMap;
    }

    public void setCodeToRigidityTypeMap(CodeToLookupMap codeToRigidityTypeMap) {
        this.codeToRigidityTypeMap = codeToRigidityTypeMap;
    }

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
    }

    public List<Lookup> getAllCardinalTimeUnitStatuses() {
        return allCardinalTimeUnitStatuses;
    }

    public void setAllCardinalTimeUnitStatuses(List<Lookup> allCardinalTimeUnitStatuses) {
        this.allCardinalTimeUnitStatuses = allCardinalTimeUnitStatuses;
    }

    public CodeToLookupMap getCodeToCardinalTimeUnitStatusMap() {
        return codeToCardinalTimeUnitStatusMap;
    }

    public void setCodeToCardinalTimeUnitStatusMap(CodeToLookupMap codeToCardinalTimeUnitStatusMap) {
        this.codeToCardinalTimeUnitStatusMap = codeToCardinalTimeUnitStatusMap;
    }

    public CodeToLookupMap getCodeToStudyIntensityMap() {
        return codeToStudyIntensityMap;
    }

    public void setCodeToStudyIntensityMap(CodeToLookupMap codeToStudyIntensityMap) {
        this.codeToStudyIntensityMap = codeToStudyIntensityMap;
    }

    public List<Lookup> getAllStudyIntensities() {
        return allStudyIntensities;
    }

    public void setAllStudyIntensities(List<Lookup> allStudyIntensities) {
        this.allStudyIntensities = allStudyIntensities;
    }

    public List<Lookup7> getAllProgressStatuses() {
        return allProgressStatuses;
    }

    public void setAllProgressStatuses(List<Lookup7> allProgressStatuses) {
        this.allProgressStatuses = allProgressStatuses;
    }

    public CodeToLookupMap getCodeToProgressStatusMap() {
        return codeToProgressStatusMap;
    }

    public void setCodeToProgressStatusMap(CodeToLookupMap codeToProgressStatusMap) {
        this.codeToProgressStatusMap = codeToProgressStatusMap;
    }

    public IdToSubjectBlockMap getIdToSubjectBlockMap() {
        return idToSubjectBlockMap;
    }

    public void setIdToSubjectBlockMap(IdToSubjectBlockMap idToSubjectBlockMap) {
        this.idToSubjectBlockMap = idToSubjectBlockMap;
    }

    public IdToSubjectMap getIdToSubjectMap() {
        return idToSubjectMap;
    }

    public void setIdToSubjectMap(IdToSubjectMap idToSubjectMap) {
        this.idToSubjectMap = idToSubjectMap;
    }

    public List<SubjectStudyGradeType> getAllSubjectStudyGradeTypes() {
        return allSubjectStudyGradeTypes;
    }

    public void setAllSubjectStudyGradeTypes(List<SubjectStudyGradeType> allSubjectStudyGradeTypes) {
        this.allSubjectStudyGradeTypes = allSubjectStudyGradeTypes;
    }

    public List<SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypes() {
        return allSubjectBlockStudyGradeTypes;
    }

    public void setAllSubjectBlockStudyGradeTypes(List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes) {
        this.allSubjectBlockStudyGradeTypes = allSubjectBlockStudyGradeTypes;
    }

}
