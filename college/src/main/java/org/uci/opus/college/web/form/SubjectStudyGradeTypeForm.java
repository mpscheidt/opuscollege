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
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.util.CodeToLookupMap;

public class SubjectStudyGradeTypeForm {

    SubjectStudyGradeType subjectStudyGradeType;
    Subject subject;
    Organization organization;
    NavigationSettings navigationSettings;
    
    int currentStudyGradeTypeId;
    int maxNumberOfCardinalTimeUnits;
    int numberOfCardinalTimeUnits;
    
    // lists
    List < AcademicYear > allAcademicYears;
    List < ? extends Study > allStudies;
    List < ? extends Subject > allSubjects;
    List < ? extends StudyGradeType > allStudyGradeTypesForStudy;
    List < ? extends StudyGradeType > distinctStudyGradeTypesForStudy;
    List < ? extends StudyGradeType > allStudyGradeTypesForSubject;
    private List <Classgroup> allClassgroups;
    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToLookupMap codeToGradeTypeMap;
    // TODO can probably be removed but check first
    List < ? extends SubjectStudyGradeType > allSubjectsForStudyGradeType;
    
    // error
	String txtErr;
	String txtMsg;
    String showSubjectStudyGradeTypeError;

    public SubjectStudyGradeTypeForm() {
		txtErr = "";
		txtMsg = "";
    }

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}
	/**
	 * @param txtErr the txtErr to set
	 */
	public void setTxtErr(final String txtErr) {
		this.txtErr = txtErr;
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

    public SubjectStudyGradeType getSubjectStudyGradeType() {
        return subjectStudyGradeType;
    }
    public void setSubjectStudyGradeType(
            final SubjectStudyGradeType subjectStudyGradeType) {
        this.subjectStudyGradeType = subjectStudyGradeType;
    }
    public Subject getSubject() {
        return subject;
    }
    public void setSubject(final Subject subject) {
        this.subject = subject;
    }
    public Organization getOrganization() {
        return organization;
    }
    public void setOrganization(final Organization organization) {
        this.organization = organization;
    }
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setNavigationSettings(final NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    public int getCurrentStudyGradeTypeId() {
        return currentStudyGradeTypeId;
    }
    public void setCurrentStudyGradeTypeId(final int currentStudyGradeTypeId) {
        this.currentStudyGradeTypeId = currentStudyGradeTypeId;
    }
    public int getMaxNumberOfCardinalTimeUnits() {
        return maxNumberOfCardinalTimeUnits;
    }
    public void setMaxNumberOfCardinalTimeUnits(
            final int maxNumberOfCardinalTimeUnits) {
        this.maxNumberOfCardinalTimeUnits = maxNumberOfCardinalTimeUnits;
    }

    public int getNumberOfCardinalTimeUnits() {
        return numberOfCardinalTimeUnits;
    }
    public void setNumberOfCardinalTimeUnits(final int numberOfCardinalTimeUnits) {
        this.numberOfCardinalTimeUnits = numberOfCardinalTimeUnits;
    }
    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }
    public void setAllAcademicYears(final List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }
    public List<? extends Study> getAllStudies() {
        return allStudies;
    }
    public void setAllStudies(final List<? extends Study> allStudies) {
        this.allStudies = allStudies;
    }
    public List<? extends Subject> getAllSubjects() {
        return allSubjects;
    }
    public void setAllSubjects(final List<? extends Subject> allSubjects) {
        this.allSubjects = allSubjects;
    }
    public List<? extends StudyGradeType> getDistinctStudyGradeTypesForStudy() {
        return distinctStudyGradeTypesForStudy;
    }
    public void setDistinctStudyGradeTypesForStudy(
            final List<? extends StudyGradeType> distinctStudyGradeTypesForStudy) {
        this.distinctStudyGradeTypesForStudy = distinctStudyGradeTypesForStudy;
    }
    public List<? extends StudyGradeType> getAllStudyGradeTypesForStudy() {
        return allStudyGradeTypesForStudy;
    }
    public void setAllStudyGradeTypesForStudy(
                    final List<? extends StudyGradeType> allStudyGradeTypesForStudy) {
        this.allStudyGradeTypesForStudy = allStudyGradeTypesForStudy;
    }
    public List<? extends StudyGradeType> getAllStudyGradeTypesForSubject() {
        return allStudyGradeTypesForSubject;
    }
    public void setAllStudyGradeTypesForSubject(
                    final List<? extends StudyGradeType> allStudyGradeTypesForSubject) {
        this.allStudyGradeTypesForSubject = allStudyGradeTypesForSubject;
    }
    public List<? extends SubjectStudyGradeType> getAllSubjectsForStudyGradeType() {
        return allSubjectsForStudyGradeType;
    }
    public void setAllSubjectsForStudyGradeType(
            final List<? extends SubjectStudyGradeType> allSubjectsForStudyGradeType) {
        this.allSubjectsForStudyGradeType = allSubjectsForStudyGradeType;
    }
    public String getShowSubjectStudyGradeTypeError() {
        return showSubjectStudyGradeTypeError;
    }
    public void setShowSubjectStudyGradeTypeError(
            final String showSubjectStudyGradeTypeError) {
        this.showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError;
    }

	public List <Classgroup> getAllClassgroups() {
		return allClassgroups;
	}

	public void setAllClassgroups(List <Classgroup> allClassgroups) {
		this.allClassgroups = allClassgroups;
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

}
