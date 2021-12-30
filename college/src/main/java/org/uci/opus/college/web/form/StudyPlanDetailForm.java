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

import java.util.Collection;
import java.util.HashSet;
import java.util.List;

import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSelection;
import org.uci.opus.util.CodeToLookupMap;

public class StudyPlanDetailForm {

    private Organization organization;
    private NavigationSettings navigationSettings;
	
    private StudyPlan studyPlan;
    private Student student;
    private StudyGradeType studyGradeType;
    private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;

    private List<StudyGradeType> allStudyGradeTypes;

    private List<CardinalTimeUnitStudyGradeType> allCardinalTimeUnitStudyGradeTypes;
    
    private int chosenStudyGradeTypeId;
    private int chosenCardinalTimeUnitNumber;
    private boolean exempted;
    
    private SubjectAndBlockSelection subjectAndBlockSelection;

    private Collection<Integer> subjectBlockIds = new HashSet<>();
    private Collection<Integer> subjectIds = new HashSet<>();

    // utility
    private IdToAcademicYearMap idToAcademicYearMap;
    private IdToStudyMap idToStudyMap;

    private CodeToLookupMap codeToGradeTypeMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyFormMap;


    public StudyPlanDetailForm() {
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
	 * @return the allStudyGradeTypes
	 */
	public List<StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	/**
	 * @param allStudyGradeTypes the allStudyGradeTypes to set
	 */
    public void setAllStudyGradeTypes(final List<StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public int getChosenStudyGradeTypeId() {
        return chosenStudyGradeTypeId;
    }

    public void setChosenStudyGradeTypeId(int chosenStudyGradeTypeId) {
        this.chosenStudyGradeTypeId = chosenStudyGradeTypeId;
    }

    public int getChosenCardinalTimeUnitNumber() {
        return chosenCardinalTimeUnitNumber;
    }

    public void setChosenCardinalTimeUnitNumber(int chosenCardinalTimeUnitNumber) {
        this.chosenCardinalTimeUnitNumber = chosenCardinalTimeUnitNumber;
    }

    public List<CardinalTimeUnitStudyGradeType> getAllCardinalTimeUnitStudyGradeTypes() {
        return allCardinalTimeUnitStudyGradeTypes;
    }

    public void setAllCardinalTimeUnitStudyGradeTypes(
            List<CardinalTimeUnitStudyGradeType> allCardinalTimeUnitStudyGradeTypes) {
        this.allCardinalTimeUnitStudyGradeTypes = allCardinalTimeUnitStudyGradeTypes;
    }

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        return codeToGradeTypeMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }

    public IdToStudyMap getIdToStudyMap() {
        return idToStudyMap;
    }

    public void setIdToStudyMap(IdToStudyMap idToStudyMap) {
        this.idToStudyMap = idToStudyMap;
    }

    public SubjectAndBlockSelection getSubjectAndBlockSelection() {
        return subjectAndBlockSelection;
    }

    public void setSubjectAndBlockSelection(SubjectAndBlockSelection subjectAndBlockSelection) {
        this.subjectAndBlockSelection = subjectAndBlockSelection;
    }

    public boolean isExempted() {
        return exempted;
    }

    public void setExempted(boolean exempted) {
        this.exempted = exempted;
    }

    public Collection<Integer> getSubjectBlockIds() {
        return subjectBlockIds;
    }

    public void setSubjectBlockIds(Collection<Integer> subjectBlockIds) {
        this.subjectBlockIds = subjectBlockIds;
    }

    public Collection<Integer> getSubjectIds() {
        return subjectIds;
    }

    public void setSubjectIds(Collection<Integer> subjectIds) {
        this.subjectIds = subjectIds;
    }

	
}
