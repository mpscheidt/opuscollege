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
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.util.CodeToLookupMap;

/**
 * Properties object for StudyGradeType edit jsp.
 */
public class StudyGradeTypeForm {

    private Study study;
    private StudyGradeType studyGradeType;   
    private Organization organization;
    private NavigationSettings navigationSettings;
    private List <AcademicYear> allAcademicYears;
    private List < ? extends StaffMember > allContacts;
    private List < ? extends StudyGradeType > allStudyGradeTypesForStudy;
    private List < SecondarySchoolSubjectGroup > allSecondarySchoolSubjectGroups;
    private List < DisciplineGroup > allDisciplineGroups;
    
    private String endGradesPerGradeType;
    
    // utility
    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToLookupMap codeToStudyTimeMap;
    
    public StudyGradeTypeForm() {
        endGradesPerGradeType = "N";
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
     * @return organization.
     */
    public Organization getOrganization() {
        return organization;
    }

    /**
     * @param organization to set.
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
     * @return the study
     */
    public Study getStudy() {
        return study;
    }

    /**
     * @param study the study to set
     */
    public void setStudy(final Study study) {
        this.study = study;
    }
    
    
    public List<? extends SecondarySchoolSubjectGroup> getAllSecondarySchoolSubjectGroups() {
        return allSecondarySchoolSubjectGroups;
    }


    public void setAllSecondarySchoolSubjectGroups(final
            List < SecondarySchoolSubjectGroup> allSecondarySchoolSubjectGroups) {
        this.allSecondarySchoolSubjectGroups = allSecondarySchoolSubjectGroups;
    }


    public List<DisciplineGroup> getAllDisciplineGroups() {
		return allDisciplineGroups;
	}


	public void setAllDisciplineGroups(List<DisciplineGroup> allDisciplineGroups) {
		this.allDisciplineGroups = allDisciplineGroups;
	}


	/**
     * @return endGradesPerGradeType
     */
    public String getEndGradesPerGradeType() {
        return endGradesPerGradeType;
    }

    /**
     * @param endGradesPerGradeType the endGradesPerGradeType to set
     */
    public void setEndGradesPerGradeType(final String endGradesPerGradeType) {
        this.endGradesPerGradeType = endGradesPerGradeType;
    }

    /**
     * @return allAcademicYears.
     */
    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    /**
     * @param allAcademicYears to set.
     */
    public void setAllAcademicYears(final List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    /**
     * @return allContacts.
     */
    public List<? extends StaffMember> getAllContacts() {
        return allContacts;
    }

    /**
     * @param allContacts to set.
     */
    public void setAllContacts(final List<? extends StaffMember> allContacts) {
        this.allContacts = allContacts;
    }

    /**
     * @return allStudyGradeTypesForStudy.
     */
    public List<? extends StudyGradeType> getAllStudyGradeTypesForStudy() {
        return allStudyGradeTypesForStudy;
    }

    /**
     * @param allStudyGradeTypesForStudy to set.
     */
    public void setAllStudyGradeTypesForStudy(
            final List<? extends StudyGradeType> allStudyGradeTypesForStudy) {
        this.allStudyGradeTypesForStudy = allStudyGradeTypesForStudy;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }


    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }


    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }


    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }


}
