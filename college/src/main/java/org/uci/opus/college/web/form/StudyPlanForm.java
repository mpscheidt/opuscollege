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
import org.uci.opus.college.domain.CareerPosition;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.domain.util.IdToSubjectBlockMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.util.CodeToLookupMap;

public class StudyPlanForm {

    private Organization organization;
    private NavigationSettings navigationSettings;
	
    private String txtErr;
    private String txtMsg;
    /* dynamic label; because of critical length of student.jsp (we would need to add constants to
       header.jsp) resolved here instead of ini studyPlan.jsp
    */
    private String disciplinesLabel;
	
    private StudyPlan studyPlan;
    private Student student;
	
    private String endGradesPerGradeType;
    private int maxNumberOfCardinalTimeUnits;
	
    private ObtainedQualification newObtainedQualification;
    private CareerPosition newCareerPosition;
    private String disciplineGroupCode;
    private boolean gradeTypeIsBachelor;
    private boolean gradeTypeIsMaster;
    private boolean firstCTU;
	
    private List <CardinalTimeUnitResult > allCardinalTimeUnitResults;
    private List <AcademicYear> allAcademicYears;
    private List <StudyPlan > allStudyPlansForStudent = null;
    private List <Study > allStudies;
    private List<SubjectStudyGradeType> allSubjectStudyGradeTypes = null;
    private List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = null;
    private List < CareerPosition > allCareerPositions = null;
    private List < ObtainedQualification > allObtainedQualifications = null;
    private List <Lookup > allDisciplines = null;
    private List<Lookup> allApplicantCategories;
    private List<Lookup9> allGradeTypes;
    private List<Lookup> allStudyPlanStatuses;
    private List < Lookup7 > allProgressStatuses;
    private List<Lookup> allStudyForms;
    private List<Lookup> allCardinalTimeUnitStatuses;

    // utility
    private IdToAcademicYearMap idToAcademicYearMap;
    private IdToOrganizationalUnitMap idToOrganizationalUnitMap;
    private IdToStudyMap idToStudyMap;
    private IdToStudyGradeTypeMap idToStudyGradeTypeMap;
    private IdToSubjectBlockMap idToSubjectBlockMap;
    private IdToSubjectMap idToSubjectMap;
    private CodeToLookupMap codeToCardinalTimeUnitMap;
    private CodeToLookupMap codeToImportanceTypeMap;
    private CodeToLookupMap codeToRigidityTypeMap;
    private CodeToLookupMap codeToStudyFormMap;
    private CodeToLookupMap codeToStudyIntensityMap;
    private CodeToLookupMap codeToStudyTimeMap;

    public StudyPlanForm() {
		txtErr = "";
		txtMsg = "";
		endGradesPerGradeType = "N";
		maxNumberOfCardinalTimeUnits = 0;
		firstCTU = false;
		gradeTypeIsBachelor = false;
		gradeTypeIsMaster = false;
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

	public String getDisciplinesLabel() {
        return disciplinesLabel;
    }

    public void setDisciplinesLabel(String disciplinesLabel) {
        this.disciplinesLabel = disciplinesLabel;
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
     * @return the endGradesPerGradeType
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
     * @return the allCardinalTimeUnitResults
     */
    public List<CardinalTimeUnitResult> getAllCardinalTimeUnitResults() {
        return allCardinalTimeUnitResults;
    }

    /**
     * @param allCardinalTimeUnitResults the allCardinalTimeUnitResults to set
     */
    public void setAllCardinalTimeUnitResults(
            final List<CardinalTimeUnitResult> allCardinalTimeUnitResults) {
        this.allCardinalTimeUnitResults = allCardinalTimeUnitResults;
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
	public void setAllAcademicYears(
			final List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	/**
	 * @return the allStudyPlansForStudent
	 */
	public List<StudyPlan> getAllStudyPlansForStudent() {
		return allStudyPlansForStudent;
	}

	/**
	 * @param allStudyPlansForStudent the allStudyPlansForStudent to set
	 */
	public void setAllStudyPlansForStudent(
			final List<StudyPlan> allStudyPlansForStudent) {
		this.allStudyPlansForStudent = allStudyPlansForStudent;
	}

	/**
	 * @return the allStudies
	 */
	public List<Study> getAllStudies() {
		return allStudies;
	}

	/**
	 * @param allStudies the allStudies to set
	 */
	public void setAllStudies(final List<Study> allStudies) {
		this.allStudies = allStudies;
	}

	/**
	 * @return the allSubjectStudyGradeTypes
	 */
	public List<SubjectStudyGradeType> getAllSubjectStudyGradeTypes() {
		return allSubjectStudyGradeTypes;
	}

	/**
	 * @param allSubjectStudyGradeTypes the allSubjectStudyGradeTypes to set
	 */
	public void setAllSubjectStudyGradeTypes(
			final List<SubjectStudyGradeType> allSubjectStudyGradeTypes) {
		this.allSubjectStudyGradeTypes = allSubjectStudyGradeTypes;
	}

	/**
	 * @return the allSubjectBlockStudyGradeTypes
	 */
	public List<SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypes() {
		return allSubjectBlockStudyGradeTypes;
	}

	/**
	 * @param allSubjectBlockStudyGradeTypes the allSubjectBlockStudyGradeTypes to set
	 */
	public void setAllSubjectBlockStudyGradeTypes(
			final List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes) {
		this.allSubjectBlockStudyGradeTypes = allSubjectBlockStudyGradeTypes;
	}

    public IdToOrganizationalUnitMap getIdToOrganizationalUnitMap() {
        return idToOrganizationalUnitMap;
    }

    public void setIdToOrganizationalUnitMap(
            IdToOrganizationalUnitMap idToOrganizationalUnitMap) {
        this.idToOrganizationalUnitMap = idToOrganizationalUnitMap;
    }

    public List< CareerPosition > getAllCareerPositions() {
        return allCareerPositions;
    }

    public void setAllCareerPositions(
            List< CareerPosition > allCareerPositions) {
        this.allCareerPositions = allCareerPositions;
    }

    public List< ObtainedQualification > getAllObtainedQualifications() {
        return allObtainedQualifications;
    }

    public void setAllObtainedQualifications(
            List< ObtainedQualification > allObtainedQualifications) {
        this.allObtainedQualifications = allObtainedQualifications;
    }

    public List<Lookup> getAllDisciplines() {
        return allDisciplines;
    }

    public void setAllDisciplines(List<Lookup> allDisciplines) {
        this.allDisciplines = allDisciplines;
    }

    public String getDisciplineGroupCode() {
        return disciplineGroupCode;
    }

    public void setDisciplineGroupCode(String disciplineGroupCode) {
        this.disciplineGroupCode = disciplineGroupCode;
    }

    public boolean isGradeTypeIsBachelor() {
        return gradeTypeIsBachelor;
    }

    public void setGradeTypeIsBachelor(final boolean gradeTypeIsBachelor) {
        this.gradeTypeIsBachelor = gradeTypeIsBachelor;
    }

    public boolean isGradeTypeIsMaster() {
        return gradeTypeIsMaster;
    }

    public void setGradeTypeIsMaster(final boolean gradeTypeIsMaster) {
        this.gradeTypeIsMaster = gradeTypeIsMaster;
    }

    public boolean isFirstCTU() {
        return firstCTU;
    }

    public void setFirstCTU(boolean firstCTU) {
        this.firstCTU = firstCTU;
    }

    public void setIdToSubjectMap(IdToSubjectMap idToSubjectMap) {
        this.idToSubjectMap = idToSubjectMap;
    }

    public IdToSubjectMap getIdToSubjectMap() {
        return idToSubjectMap;
    }

    public void setCodeToStudyIntensityMap(CodeToLookupMap codeToStudyIntensityMap) {
        this.codeToStudyIntensityMap = codeToStudyIntensityMap;
    }

    public CodeToLookupMap getCodeToStudyIntensityMap() {
        return codeToStudyIntensityMap;
    }

    public List<Lookup> getAllApplicantCategories() {
        return allApplicantCategories;
    }

    public void setAllApplicantCategories(List<Lookup> allApplicantCategories) {
        this.allApplicantCategories = allApplicantCategories;
    }

    public List<Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    public void setAllGradeTypes(List<Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public List<Lookup> getAllStudyPlanStatuses() {
        return allStudyPlanStatuses;
    }

    public void setAllStudyPlanStatuses(List<Lookup> allStudyPlanStatuses) {
        this.allStudyPlanStatuses = allStudyPlanStatuses;
    }

    public List < Lookup7 > getAllProgressStatuses() {
        return allProgressStatuses;
    }

    public void setAllProgressStatuses(List < Lookup7 > allProgressStatuses) {
        this.allProgressStatuses = allProgressStatuses;
    }

    public List<Lookup> getAllStudyForms() {
        return allStudyForms;
    }

    public void setAllStudyForms(List<Lookup> allStudyForms) {
        this.allStudyForms = allStudyForms;
    }

    public List<Lookup> getAllCardinalTimeUnitStatuses() {
        return allCardinalTimeUnitStatuses;
    }

    public void setAllCardinalTimeUnitStatuses(List<Lookup> allCardinalTimeUnitStatuses) {
        this.allCardinalTimeUnitStatuses = allCardinalTimeUnitStatuses;
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

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
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

    public IdToStudyMap getIdToStudyMap() {
        return idToStudyMap;
    }

    public void setIdToStudyMap(IdToStudyMap idToStudyMap) {
        this.idToStudyMap = idToStudyMap;
    }

    public IdToSubjectBlockMap getIdToSubjectBlockMap() {
        return idToSubjectBlockMap;
    }

    public void setIdToSubjectBlockMap(IdToSubjectBlockMap idToSubjectBlockMap) {
        this.idToSubjectBlockMap = idToSubjectBlockMap;
    }

    public IdToStudyGradeTypeMap getIdToStudyGradeTypeMap() {
        return idToStudyGradeTypeMap;
    }

    public void setIdToStudyGradeTypeMap(IdToStudyGradeTypeMap idToStudyGradeTypeMap) {
        this.idToStudyGradeTypeMap = idToStudyGradeTypeMap;
    }

    public CodeToLookupMap getCodeToCardinalTimeUnitMap() {
        return codeToCardinalTimeUnitMap;
    }

    public void setCodeToCardinalTimeUnitMap(CodeToLookupMap codeToCardinalTimeUnitMap) {
        this.codeToCardinalTimeUnitMap = codeToCardinalTimeUnitMap;
    }
	

}
