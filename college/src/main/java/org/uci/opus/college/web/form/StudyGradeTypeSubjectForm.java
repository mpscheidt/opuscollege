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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;

public class StudyGradeTypeSubjectForm {

    SubjectStudyGradeType subjectStudyGradeType;
    StudyGradeType studyGradeType;
    Subject subject;
    // year of the studyGradeType
    AcademicYear academicYear;
    Organization organization;
    NavigationSettings navigationSettings;

    int maxNumberOfCardinalTimeUnits;
    int numberOfCardinalTimeUnits;

    String txtErr;
    
    // lists
    List < ? extends Study > allStudies;
    List < ? extends Subject > allSubjects;
    List < Integer > allSubjectIdsForStudyGradeType = null;
    
    List < ? extends Lookup > allRigidityTypes;
    List < ? extends Lookup > allImportanceTypes;
    
    public SubjectStudyGradeType getSubjectStudyGradeType() {
        return subjectStudyGradeType;
    }
    public void setSubjectStudyGradeType(
            final SubjectStudyGradeType subjectStudyGradeType) {
        this.subjectStudyGradeType = subjectStudyGradeType;
    }
    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }
    public void setStudyGradeType(final StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }
    public Subject getSubject() {
        return subject;
    }
    public void setSubject(final Subject subject) {
        this.subject = subject;
    }
    public AcademicYear getAcademicYear() {
		return academicYear;
	}
	public void setAcademicYear(final AcademicYear academicYear) {
		this.academicYear = academicYear;
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
    public int getMaxNumberOfCardinalTimeUnits() {
        return maxNumberOfCardinalTimeUnits;
    }
    public void setMaxNumberOfCardinalTimeUnits(final int maxNumberOfCardinalTimeUnits) {
        this.maxNumberOfCardinalTimeUnits = maxNumberOfCardinalTimeUnits;
    }
    public int getNumberOfCardinalTimeUnits() {
        return numberOfCardinalTimeUnits;
    }
    public void setNumberOfCardinalTimeUnits(final int numberOfCardinalTimeUnits) {
        this.numberOfCardinalTimeUnits = numberOfCardinalTimeUnits;
    }
    public String getTxtErr() {
        return txtErr;
    }
    public void setTxtErr(final String txtErr) {
        this.txtErr = txtErr;
    }
    public List<? extends Study> getAllStudies() {
        return allStudies;
    }
    public void setAllStudies(final List< ? extends Study > allStudies) {
        this.allStudies = allStudies;
    }
    public List<? extends Subject> getAllSubjects() {
        return allSubjects;
    }
    public void setAllSubjects(final List < ? extends Subject > allSubjects) {
        this.allSubjects = allSubjects;
    }
    public List<Integer> getAllSubjectIdsForStudyGradeType() {
        return allSubjectIdsForStudyGradeType;
    }
    public void setAllSubjectIdsForStudyGradeType(
                            final List < Integer > allSubjectIdsForStudyGradeType) {
        this.allSubjectIdsForStudyGradeType = allSubjectIdsForStudyGradeType;
    }
    public List<? extends Lookup> getAllRigidityTypes() {
        return allRigidityTypes;
    }
    public void setAllRigidityTypes(final List< ? extends Lookup > allRigidityTypes) {
        this.allRigidityTypes = allRigidityTypes;
    }
    public List<? extends Lookup> getAllImportanceTypes() {
        return allImportanceTypes;
    }
    public void setAllImportanceTypes(final List< ? extends Lookup > allImportanceTypes) {
        this.allImportanceTypes = allImportanceTypes;
    }
    
    

}
