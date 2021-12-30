/*******************************************************************************
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
 * The Original Code is Opus-College admission module code.
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
 ******************************************************************************/
package org.uci.opus.admission.web.form;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.CareerPosition;
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Referee;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.web.form.NavigationSettings;

public class RequestAdmissionForm {
    
    Logger log = LoggerFactory.getLogger(RequestAdmissionForm.class); 

	private NavigationSettings navigationSettings;

	private int numberOfSubjectsToGrade;

	private String txtErr;
	private String txtDisciplineErr;
	private String txtMsg;
	private String preferredLanguage;
	
	private boolean gradeTypeIsBachelor;
	private boolean gradeTypeIsMaster;

	private Student student;
	private OpusUserRole opusUserRole;
	private OpusUser opusUser;
	private Address address;
	private StudyPlan studyPlan;
	
	private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
	private ObtainedQualification newObtainedQualification;
	private CareerPosition newCareerPosition;
	private Referee firstReferee;
	private Referee secondReferee;
	
	private List < ? extends AcademicYear > allAcademicYears;
	private List < Study > allStudies = null;
	private List < ? extends StudyGradeType > allStudyGradeTypes = null;
	private List < SecondarySchoolSubjectGroup > secondarySchoolSubjectGroups = null;
	private List < SecondarySchoolSubject > ungroupedSecondarySchoolSubjects = null;
	 	
	private List < ObtainedQualification > allObtainedQualifications;
	private List < CareerPosition > allCareerPositions;
	private List < ? extends Lookup9 > allGradeTypes = null;
	private List < ? extends Lookup > allDisciplines = null;
	private List < Institution > allPreviousInstitutions = null;
	private DisciplineGroup disciplineGroup = null;
	
	// if secondary studies can be chosen
	private StudyPlan secondStudyPlan;
    private StudyPlanCardinalTimeUnit secondStudyPlanCardinalTimeUnit;
	
	public RequestAdmissionForm() {
		txtErr = "";
		txtMsg = "";
	    numberOfSubjectsToGrade = 0;
	    allObtainedQualifications = new ArrayList<ObtainedQualification>();
	    allCareerPositions = new ArrayList < CareerPosition >();
	    gradeTypeIsBachelor = false;
	    gradeTypeIsMaster = false;
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

    public int getNumberOfSubjectsToGrade() {
        return numberOfSubjectsToGrade;
    }

    public void setNumberOfSubjectsToGrade(final int numberOfSubjectsToGrade) {
        this.numberOfSubjectsToGrade = numberOfSubjectsToGrade;
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
	public String getTxtDisciplineErr() {
        return txtDisciplineErr;
    }


    public void setTxtDisciplineErr(final String txtDisciplineErr) {
        this.txtDisciplineErr = txtDisciplineErr;
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
	
	public String getPreferredLanguage() {
        return preferredLanguage;
    }

    public void setPreferredLanguage(String preferredLanguage) {
        this.preferredLanguage = preferredLanguage;
    }

    public boolean isGradeTypeIsBachelor() {
        return gradeTypeIsBachelor;
    }

    public void setGradeTypeIsBachelor(boolean gradeTypeIsBachelor) {
        this.gradeTypeIsBachelor = gradeTypeIsBachelor;
    }

    public boolean isGradeTypeIsMaster() {
        return gradeTypeIsMaster;
    }

    public void setGradeTypeIsMaster(boolean gradeTypeIsMaster) {
        this.gradeTypeIsMaster = gradeTypeIsMaster;
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
	 * @return the opusUserRole
	 */
	public OpusUserRole getOpusUserRole() {
		return opusUserRole;
	}
	/**
	 * @param opusUserRole the opusUserRole to set
	 */
	public void setOpusUserRole(final OpusUserRole opusUserRole) {
		this.opusUserRole = opusUserRole;
	}

	/**
	 * @return the opusUser
	 */
	public OpusUser getOpusUser() {
		return opusUser;
	}
	/**
	 * @param opusUser the opusUser to set
	 */
	public void setOpusUser(final OpusUser opusUser) {
		this.opusUser = opusUser;
	}

	/**
	 * @return the address
	 */
	public Address getAddress() {
		return address;
	}
	/**
	 * @param address the address to set
	 */
	public void setAddress(final Address address) {
		this.address = address;
	}

    public ObtainedQualification getNewObtainedQualification() {
        return newObtainedQualification;
    }

    public void setNewObtainedQualification(
            ObtainedQualification newObtainedQualification) {
        this.newObtainedQualification = newObtainedQualification;
    }

    public CareerPosition getNewCareerPosition() {
        return newCareerPosition;
    }


    public void setNewCareerPosition(CareerPosition newCareerPosition) {
        this.newCareerPosition = newCareerPosition;
    }

    /**
     * @return the allAcademicYears
     */
    public List<? extends AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    /**
     * @param allAcademicYears the allAcademicYears to set
     */
    public void setAllAcademicYears(
            final List<? extends AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

	
    public List<Study> getAllStudies() {
        return allStudies;
    }


    public void setAllStudies(List<Study> allStudies) {
        this.allStudies = allStudies;
    }


    public DisciplineGroup getDisciplineGroup() {
        return disciplineGroup;
    }

    public void setDisciplineGroup(DisciplineGroup disciplineGroup) {
        this.disciplineGroup = disciplineGroup;
    }

    public List < ? extends StudyGradeType > getAllStudyGradeTypes() {
        return allStudyGradeTypes;
    }


    public void setAllStudyGradeTypes(
                                final List < ? extends StudyGradeType > allStudyGradeTypes) {
        this.allStudyGradeTypes = allStudyGradeTypes;
    }

    public List < SecondarySchoolSubjectGroup > getSecondarySchoolSubjectGroups() {
        return secondarySchoolSubjectGroups;
    }


    public void setSecondarySchoolSubjectGroups(
            final List < SecondarySchoolSubjectGroup > secondarySchoolSubjectGroups) {
        this.secondarySchoolSubjectGroups = secondarySchoolSubjectGroups;
    }
    
    public StudyPlan getSecondStudyPlan() {
        return secondStudyPlan;
    }


    public void setSecondStudyPlan(StudyPlan secondStudyPlan) {
        this.secondStudyPlan = secondStudyPlan;
    }


    public StudyPlanCardinalTimeUnit getSecondStudyPlanCardinalTimeUnit() {
        return secondStudyPlanCardinalTimeUnit;
    }


    public void setSecondStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit secondStudyPlanCardinalTimeUnit) {
        this.secondStudyPlanCardinalTimeUnit = secondStudyPlanCardinalTimeUnit;
    }


    /**
	 * @return the ungroupedSecondarySchoolSubjects
	 */
	public List<SecondarySchoolSubject> getUngroupedSecondarySchoolSubjects() {
		return ungroupedSecondarySchoolSubjects;
	}
	/**
	 * @param ungroupedSecondarySchoolSubjects the ungroupedSecondarySchoolSubjects to set
	 */
	public void setUngroupedSecondarySchoolSubjects(
			final List<SecondarySchoolSubject> ungroupedSecondarySchoolSubjects) {
		this.ungroupedSecondarySchoolSubjects = ungroupedSecondarySchoolSubjects;
	}

    public StudyPlan getStudyPlan() {
        return studyPlan;
    }


    public void setStudyPlan(final StudyPlan studyPlan) {
        this.studyPlan = studyPlan;
    }

    public StudyPlanCardinalTimeUnit getStudyPlanCardinalTimeUnit() {
        return studyPlanCardinalTimeUnit;
    }

    public void setStudyPlanCardinalTimeUnit(
            final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
        this.studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnit;
    }	

    public List < ObtainedQualification > getAllObtainedQualifications() {
        return allObtainedQualifications;
    }

    public void setAllObtainedQualifications(
            final List < ObtainedQualification > allObtainedQualifications) {
        this.allObtainedQualifications = allObtainedQualifications;
    }

    public List < CareerPosition > getAllCareerPositions() {
        return allCareerPositions;
    }

    public void setAllCareerPositions(
            final List < CareerPosition > allCareerPositions) {
        this.allCareerPositions = allCareerPositions;
    }

    public List<? extends Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    public void setAllGradeTypes(final List<? extends Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public List<? extends Lookup> getAllDisciplines() {
        return allDisciplines;
    }

    public void setAllDisciplines(List<? extends Lookup> allDisciplines) {
        this.allDisciplines = allDisciplines;
    }

    public List<Institution> getAllPreviousInstitutions() {
        return allPreviousInstitutions;
    }


    public void setAllPreviousInstitutions(
            final List<Institution> allPreviousInstitutions) {
        this.allPreviousInstitutions = allPreviousInstitutions;
    }


    public Referee getFirstReferee() {
        return firstReferee;
    }

    public void setFirstReferee(final Referee firstReferee) {
        this.firstReferee = firstReferee;
    }

    public Referee getSecondReferee() {
        return secondReferee;
    }

    public void setSecondReferee(final Referee secondReferee) {
        this.secondReferee = secondReferee;
    }	
}
