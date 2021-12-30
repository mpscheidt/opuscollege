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

import java.math.BigDecimal;
import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StudentList;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.util.CodeToLookupMap;

/**
 * Container for all data used in the students.view
 * 
 * @author markus
 *
 */
public class StudentsForm {

    private Organization organization;
	private NavigationSettings navigationSettings;
	private StudySettings studySettings;
	
	private String txtErr;
	private String txtMsg;

	private String genderCode;
	private String studentStatusCode;
	private String cardinalTimeUnitStatusCode;
	private String relativeOfStaffMember;
	private String ruralAreaOrigin;
	private String foreignStudent;

	private List<? extends Study> dropDownListStudies;
    private List < ? extends StudyGradeType > allStudyGradeTypes;
    private StudentList allStudents;
    private List < ? extends AcademicYear > allAcademicYears;
    
    private BigDecimal cutOffPointAdmissionBachelor = BigDecimal.ZERO;
    private BigDecimal cutOffPointContinuedRegistrationBachelor = BigDecimal.ZERO;
    private BigDecimal cutOffPointContinuedRegistrationMaster = BigDecimal.ZERO;
    private BigDecimal admissionBachelorCutOffPointCreditFemale = BigDecimal.ZERO;
    private BigDecimal admissionBachelorCutOffPointCreditMale = BigDecimal.ZERO;
//    float cntdRegistrationBachelorCutOffPointCreditFemale = 0;
//    float cntdRegistrationBachelorCutOffPointCreditMale = 0;
//    float cntdRegistrationMasterCutOffPointCreditFemale = 0;
//    float cntdRegistrationMasterCutOffPointCreditMale = 0;

    /* relatives */
    private BigDecimal admissionBachelorCutOffPointRelativesCreditFemale = BigDecimal.ZERO;
    private BigDecimal admissionBachelorCutOffPointRelativesCreditMale = BigDecimal.ZERO;
//    float cntdRegistrationBachelorCutOffPointRelativesCreditFemale = 0;
//    float cntdRegistrationBachelorCutOffPointRelativesCreditMale = 0;
//    float cntdRegistrationMasterCutOffPointRelativesCreditFemale = 0;
//    float cntdRegistrationMasterCutOffPointRelativesCreditMale = 0;

    /* rural areas */
    private BigDecimal admissionBachelorCutOffPointCreditRuralAreas = BigDecimal.ZERO;

    private SubjectResultFormatter subjectResultFormatter;
    
    private int studentCount;

    // util
    private IdToStudyMap idToStudyMap;
    private CodeToLookupMap codeToGradeTypeMap;

	public StudentsForm() {
		txtErr = "";
		txtMsg = "";
		studentStatusCode = "";
		cardinalTimeUnitStatusCode = "";
		relativeOfStaffMember = "";
		ruralAreaOrigin = "";
	}
	
    /**
	 * @return the cutOffPointAdmissionBachelor
	 */
	public BigDecimal getCutOffPointAdmissionBachelor() {
		return cutOffPointAdmissionBachelor;
	}


	/**
	 * @param cutOffPointAdmissionBachelor the cutOffPointAdmissionBachelor to set
	 */
	public void setCutOffPointAdmissionBachelor(BigDecimal cutOffPointAdmissionBachelor) {
		this.cutOffPointAdmissionBachelor = cutOffPointAdmissionBachelor;
	}


	/**
	 * @return the cutOffPointContinuedRegistrationBachelor
	 */
	public BigDecimal getCutOffPointContinuedRegistrationBachelor() {
		return cutOffPointContinuedRegistrationBachelor;
	}


	/**
	 * @param cutOffPointContinuedRegistrationBaBsc the cutOffPointContinuedRegistrationBachelor to set
	 */
	public void setCutOffPointContinuedRegistrationBachelor(
	        BigDecimal cutOffPointContinuedRegistrationBachelor) {
		this.cutOffPointContinuedRegistrationBachelor = cutOffPointContinuedRegistrationBachelor;
	}


	/**
	 * @return the cutOffPointContinuedRegistrationMaMsc
	 */
	public BigDecimal getCutOffPointContinuedRegistrationMaster() {
		return cutOffPointContinuedRegistrationMaster;
	}


	/**
	 * @param cutOffPointContinuedRegistrationMaMsc the cutOffPointContinuedRegistrationMaMsc to set
	 */
	public void setCutOffPointContinuedRegistrationMaster(
	        BigDecimal cutOffPointContinuedRegistrationMaster) {
		this.cutOffPointContinuedRegistrationMaster = cutOffPointContinuedRegistrationMaster;
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
	 * @return the studySettings
	 */
	public StudySettings getStudySettings() {
		return studySettings;
	}
	/**
	 * @param studyDetails the studySettings to set
	 */
	public void setStudySettings(final StudySettings studySettings) {
		this.studySettings = studySettings;
	}

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}
	/**
	 * @param studyError the txtErr to set
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

	/**
	 * @return the studentStatusCode
	 */
	public String getStudentStatusCode() {
		return studentStatusCode;
	}
	/**
	 * @param studentStatusCode the studentStatusCode to set
	 */
	public void setStudentStatusCode(final String studentStatusCode) {
		this.studentStatusCode = studentStatusCode;
	}
	
	/**
	 * @return the cardinalTimeUnitStatusCode
	 */
	public String getCardinalTimeUnitStatusCode() {
		return cardinalTimeUnitStatusCode;
	}
	/**
	 * @param cardinalTimeUnitStatusCode the cardinalTimeUnitStatusCode to set
	 */
	public void setCardinalTimeUnitStatusCode(final String cardinalTimeUnitStatusCode) {
		this.cardinalTimeUnitStatusCode = cardinalTimeUnitStatusCode;
	}

	/**
	 * @return the relativeOfStaffMember
	 */
	public String getRelativeOfStaffMember() {
		return relativeOfStaffMember;
	}

	/**
	 * @param relativeOfStaffMember the relativeOfStaffMember to set
	 */
	public void setRelativeOfStaffMember(final String relativeOfStaffMember) {
		this.relativeOfStaffMember = relativeOfStaffMember;
	}

	
	/**
	 * @return the ruralAreaOrigin
	 */
	public String getRuralAreaOrigin() {
		return ruralAreaOrigin;
	}

	/**
	 * @param ruralAreaOrigin the ruralAreaOrigin to set
	 */
	public void setRuralAreaOrigin(final String ruralAreaOrigin) {
		this.ruralAreaOrigin = ruralAreaOrigin;
	}

	/**
	 * @return the foreignStudent
	 */
	public String getForeignStudent() {
		return foreignStudent;
	}

	/**
	 * @param foreignStudent the foreignStudent to set
	 */
	public void setForeignStudent(final String foreignStudent) {
		this.foreignStudent = foreignStudent;
	}

	/**
	 * @return the dropDownListStudies
	 */
	public List<? extends Study> getDropDownListStudies() {
		return dropDownListStudies;
	}

	/**
	 * @param dropDownListStudies the dropDownListStudies to set
	 */
	public void setDropDownListStudies(
			final List<? extends Study> dropDownListStudies) {
		this.dropDownListStudies = dropDownListStudies;
	}

	/**
	 * @return the allStudyGradeTypes
	 */
	public List<? extends StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	/**
	 * @param allStudyGradeTypes the allStudyGradeTypes to set
	 */
	public void setAllStudyGradeTypes(
			final List<? extends StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}
	
	/**
	 * @return the allStudents
	 */
	public StudentList getAllStudents() {
		return allStudents;
	}
	/**
	 * @param allStudents the allStudents to set
	 */
	public void setAllStudents(final StudentList allStudents) {
		this.allStudents = allStudents;
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

	/**
	 * @return the subjectResultFormatter
	 */
	public SubjectResultFormatter getSubjectResultFormatter() {
		return subjectResultFormatter;
	}

	/**
	 * @param subjectResultFormatter the subjectResultFormatter to set
	 */
	public void setSubjectResultFormatter(
			final SubjectResultFormatter subjectResultFormatter) {
		this.subjectResultFormatter = subjectResultFormatter;
	}

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

	/**
	 * @return the admissionBachelorCutOffPointCreditFemale
	 */
	public BigDecimal getAdmissionBachelorCutOffPointCreditFemale() {
		return admissionBachelorCutOffPointCreditFemale;
	}

	/**
	 * @param admissionBachelorCutOffPointCreditFemale the admissionBachelorCutOffPointCreditFemale to set
	 */
	public void setAdmissionBachelorCutOffPointCreditFemale(
			final BigDecimal admissionBachelorCutOffPointCreditFemale) {
		this.admissionBachelorCutOffPointCreditFemale = admissionBachelorCutOffPointCreditFemale;
	}

	/**
	 * @return the admissionBachelorCutOffPointCreditMale
	 */
	public BigDecimal getAdmissionBachelorCutOffPointCreditMale() {
		return admissionBachelorCutOffPointCreditMale;
	}

	/**
	 * @param admissionBachelorCutOffPointCreditMale the admissionBachelorCutOffPointCreditMale to set
	 */
	public void setAdmissionBachelorCutOffPointCreditMale(
			final BigDecimal admissionBachelorCutOffPointCreditMale) {
		this.admissionBachelorCutOffPointCreditMale = admissionBachelorCutOffPointCreditMale;
	}
	

	/**
	 * @return the admissionBachelorCutOffPointCreditRuralAreas
	 */
	public BigDecimal getAdmissionBachelorCutOffPointCreditRuralAreas() {
		return admissionBachelorCutOffPointCreditRuralAreas;
	}

	/**
	 * @param admissionBachelorCutOffPointCreditRuralAreas the admissionBachelorCutOffPointCreditRuralAreas to set
	 */
	public void setAdmissionBachelorCutOffPointCreditRuralAreas(
			final BigDecimal admissionBachelorCutOffPointCreditRuralAreas) {
		this.admissionBachelorCutOffPointCreditRuralAreas = admissionBachelorCutOffPointCreditRuralAreas;
	}

//	/**
//	 * @return the cntdRegistrationBachelorCutOffPointCreditFemale
//	 */
//	public float getCntdRegistrationBachelorCutOffPointCreditFemale() {
//		return cntdRegistrationBachelorCutOffPointCreditFemale;
//	}
//
//	/**
//	 * @param cntdRegistrationBachelorCutOffPointCreditFemale the cntdRegistrationBachelorCutOffPointCreditFemale to set
//	 */
//	public void setCntdRegistrationBachelorCutOffPointCreditFemale(
//			final float cntdRegistrationBachelorCutOffPointCreditFemale) {
//		this.cntdRegistrationBachelorCutOffPointCreditFemale = cntdRegistrationBachelorCutOffPointCreditFemale;
//	}
//
//	/**
//	 * @return the cntdRegistrationBachelorCutOffPointCreditMale
//	 */
//	public float getCntdRegistrationBachelorCutOffPointCreditMale() {
//		return cntdRegistrationBachelorCutOffPointCreditMale;
//	}
//
//	/**
//	 * @param cntdRegistrationBachelorCutOffPointCreditMale the cntdRegistrationBachelorCutOffPointCreditMale to set
//	 */
//	public void setCntdRegistrationBachelorCutOffPointCreditMale(
//			final float cntdRegistrationBachelorCutOffPointCreditMale) {
//		this.cntdRegistrationBachelorCutOffPointCreditMale = cntdRegistrationBachelorCutOffPointCreditMale;
//	}
//
//	/**
//	 * @return the cntdRegistrationMasterCutOffPointCreditFemale
//	 */
//	public float getCntdRegistrationMasterCutOffPointCreditFemale() {
//		return cntdRegistrationMasterCutOffPointCreditFemale;
//	}
//
//	/**
//	 * @param cntdRegistrationMasterCutOffPointCreditFemale the cntdRegistrationMasterCutOffPointCreditFemale to set
//	 */
//	public void setCntdRegistrationMasterCutOffPointCreditFemale(
//			final float cntdRegistrationMasterCutOffPointCreditFemale) {
//		this.cntdRegistrationMasterCutOffPointCreditFemale = cntdRegistrationMasterCutOffPointCreditFemale;
//	}
//
//	/**
//	 * @return the cntdRegistrationMasterCutOffPointCreditMale
//	 */
//	public float getCntdRegistrationMasterCutOffPointCreditMale() {
//		return cntdRegistrationMasterCutOffPointCreditMale;
//	}
//
//	/**
//	 * @param cntdRegistrationMasterCutOffPointCreditMale the cntdRegistrationMasterCutOffPointCreditMale to set
//	 */
//	public void setCntdRegistrationMasterCutOffPointCreditMale(
//			final float cntdRegistrationMasterCutOffPointCreditMale) {
//		this.cntdRegistrationMasterCutOffPointCreditMale = cntdRegistrationMasterCutOffPointCreditMale;
//	}

	/**
	 * @return the admissionBachelorCutOffPointRelativesCreditFemale
	 */
	public BigDecimal getAdmissionBachelorCutOffPointRelativesCreditFemale() {
		return admissionBachelorCutOffPointRelativesCreditFemale;
	}

	/**
	 * @param admissionBachelorCutOffPointRelativesCreditFemale the admissionBachelorCutOffPointRelativesCreditFemale to set
	 */
	public void setAdmissionBachelorCutOffPointRelativesCreditFemale(
			final BigDecimal admissionBachelorCutOffPointRelativesCreditFemale) {
		this.admissionBachelorCutOffPointRelativesCreditFemale = admissionBachelorCutOffPointRelativesCreditFemale;
	}

	/**
	 * @return the admissionBachelorCutOffPointRelativesCreditMale
	 */
	public BigDecimal getAdmissionBachelorCutOffPointRelativesCreditMale() {
		return admissionBachelorCutOffPointRelativesCreditMale;
	}

	/**
	 * @param admissionBachelorCutOffPointRelativesCreditMale the admissionBachelorCutOffPointRelativesCreditMale to set
	 */
	public void setAdmissionBachelorCutOffPointRelativesCreditMale(
			final BigDecimal admissionBachelorCutOffPointRelativesCreditMale) {
		this.admissionBachelorCutOffPointRelativesCreditMale = admissionBachelorCutOffPointRelativesCreditMale;
	}

	/**
	 * @return the cntdRegistrationBachelorCutOffPointRelativesCreditFemale
	 */
//	public float getCntdRegistrationBachelorCutOffPointRelativesCreditFemale() {
//		return cntdRegistrationBachelorCutOffPointRelativesCreditFemale;
//	}

	/**
	 * @param cntdRegistrationBachelorCutOffPointRelativesCreditFemale the cntdRegistrationBachelorCutOffPointRelativesCreditFemale to set
	 */
//	public void setCntdRegistrationBachelorCutOffPointRelativesCreditFemale(
//			final float cntdRegistrationBachelorCutOffPointRelativesCreditFemale) {
//		this.cntdRegistrationBachelorCutOffPointRelativesCreditFemale = cntdRegistrationBachelorCutOffPointRelativesCreditFemale;
//	}

	/**
	 * @return the cntdRegistrationBachelorCutOffPointRelativesCreditMale
	 */
//	public float getCntdRegistrationBachelorCutOffPointRelativesCreditMale() {
//		return cntdRegistrationBachelorCutOffPointRelativesCreditMale;
//	}

	/**
	 * @param cntdRegistrationBachelorCutOffPointRelativesCreditMale the cntdRegistrationBachelorCutOffPointRelativesCreditMale to set
	 */
//	public void setCntdRegistrationBachelorCutOffPointRelativesCreditMale(
//			final float cntdRegistrationBachelorCutOffPointRelativesCreditMale) {
//		this.cntdRegistrationBachelorCutOffPointRelativesCreditMale = cntdRegistrationBachelorCutOffPointRelativesCreditMale;
//	}

	/**
	 * @return the cntdRegistrationMasterCutOffPointRelativesCreditFemale
	 */
//	public float getCntdRegistrationMasterCutOffPointRelativesCreditFemale() {
//		return cntdRegistrationMasterCutOffPointRelativesCreditFemale;
//	}

	/**
	 * @param cntdRegistrationMasterCutOffPointRelativesCreditFemale the cntdRegistrationMasterCutOffPointRelativesCreditFemale to set
	 */
//	public void setCntdRegistrationMasterCutOffPointRelativesCreditFemale(
//			final float cntdRegistrationMasterCutOffPointRelativesCreditFemale) {
//		this.cntdRegistrationMasterCutOffPointRelativesCreditFemale = cntdRegistrationMasterCutOffPointRelativesCreditFemale;
//	}

	/**
	 * @return the cntdRegistrationMasterCutOffPointRelativesCreditMale
	 */
//	public float getCntdRegistrationMasterCutOffPointRelativesCreditMale() {
//		return cntdRegistrationMasterCutOffPointRelativesCreditMale;
//	}

	/**
	 * @param cntdRegistrationMasterCutOffPointRelativesCreditMale the cntdRegistrationMasterCutOffPointRelativesCreditMale to set
	 */
//	public void setCntdRegistrationMasterCutOffPointRelativesCreditMale(
//			final float cntdRegistrationMasterCutOffPointRelativesCreditMale) {
//		this.cntdRegistrationMasterCutOffPointRelativesCreditMale = cntdRegistrationMasterCutOffPointRelativesCreditMale;
//	}

	public String getGenderCode() {
		return genderCode;
	}

	public void setGenderCode(String genderCode) {
		this.genderCode = genderCode;
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

}
