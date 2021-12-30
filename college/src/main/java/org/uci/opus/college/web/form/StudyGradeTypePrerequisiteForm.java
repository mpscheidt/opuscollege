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
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;

public class StudyGradeTypePrerequisiteForm {
    
    StudyGradeTypePrerequisite studyGradeTypePrerequisite;
    StudyGradeType mainStudyGradeType;
    
    Organization organization;
    NavigationSettings navigationSettings;
    // needed in dropDown
    Study study;
    AcademicYear academicYear;
    
    int currentStudyGradeTypeId;
    
    // lists
    List < ? extends Study > allStudies;
    List < ? extends AcademicYear > allAcademicYears;
    // possible prerequisites
    List < ? extends StudyGradeType > distinctStudyGradeTypesForStudy;
    List < ? extends StudyGradeType > allStudyGradeTypesForStudy;
    List < ? extends StudyGradeType > allStudyGradeTypePrerequisites;

    public StudyGradeTypePrerequisiteForm() {
        this.academicYear = new AcademicYear();
    }
    
    public StudyGradeTypePrerequisite getStudyGradeTypePrerequisite() {
        return studyGradeTypePrerequisite;
    }
    public void setStudyGradeTypePrerequisite(
            final StudyGradeTypePrerequisite studyGradeTypePrerequisite) {
        this.studyGradeTypePrerequisite = studyGradeTypePrerequisite;
    }
    public StudyGradeType getMainStudyGradeType() {
        return mainStudyGradeType;
    }
    public void setMainStudyGradeType(final StudyGradeType mainStudyGradeType) {
        this.mainStudyGradeType = mainStudyGradeType;
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
    public Study getStudy() {
        return study;
    }
    public void setStudy(final Study study) {
        this.study = study;
    }
    public AcademicYear getAcademicYear() {
        return academicYear;
    }
    public void setAcademicYear(final AcademicYear academicYear) {
        this.academicYear = academicYear;
    }
    public int getCurrentStudyGradeTypeId() {
        return currentStudyGradeTypeId;
    }
    public void setCurrentStudyGradeTypeId(final int currentStudyGradeTypeId) {
        this.currentStudyGradeTypeId = currentStudyGradeTypeId;
    }
    public List<? extends Study> getAllStudies() {
        return allStudies;
    }
    public void setAllStudies(final List<? extends Study> allStudies) {
        this.allStudies = allStudies;
    }
    public List<? extends AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }
    public void setAllAcademicYears(
            final List < ? extends AcademicYear > allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
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
    public List<? extends StudyGradeType> getAllStudyGradeTypePrerequisites() {
        return allStudyGradeTypePrerequisites;
    }
    public void setAllStudyGradeTypePrerequisites(
            final List<? extends StudyGradeType> allStudyGradeTypePrerequisites) {
        this.allStudyGradeTypePrerequisites = allStudyGradeTypePrerequisites;
    }
}