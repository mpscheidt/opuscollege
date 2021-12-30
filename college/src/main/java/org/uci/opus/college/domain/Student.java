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

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;

/**
 * @author move
 *
 */
public class Student extends Person {

    private static final long serialVersionUID = 1L;

    private int personId;
    private int studentId;
    private String studentCode;
    private Date dateOfEnrolment;
    private int primaryStudyId;
    private Date expellationDate;
    private Date expellationEndDate;
    private String expellationTypeCode;
    private String reasonForExpellation;
    private int previousInstitutionId;
    private String previousInstitutionName;
    private String previousInstitutionDistrictCode;
    private String previousInstitutionProvinceCode;
    private String  previousInstitutionCountryCode;
    private String previousInstitutionTypeCode;
    private String previousInstitutionFinalGradeTypeCode;
    private String previousInstitutionFinalMark;
    private String scholarship;
    private String fatherFullName;
    private String fatherEducationCode;
    private String fatherProfessionCode;
    private String fatherProfessionDescription;
    private String fatherTelephone;
    private String motherFullName;
    private String motherEducationCode;
    private String motherProfessionCode;
    private String motherProfessionDescription;
    private String motherTelephone;
    private String financialGuardianFullName;
    private String financialGuardianRelation;
    private String financialGuardianProfession;
    private String missingDocuments;
    private String sourceOfFunding;
    private List < StudentStudentStatus > studentStudentStatuses;
    private List < StudyPlan > studyPlans;
    private List < ? extends Address > addresses;
    private List < ? extends StudentAbsence > studentAbsences;
    private List < ? extends StudentExpulsion > studentExpulsions;
    private List < StudentBalance > studentBalances;
    private List < Penalty > penalties;
    private List < Classgroup > classgroups;
    
    private List < ? extends Note > studentActivities;
    private List < ? extends Note > studentCareers;
    private List < ? extends Note > studentCounselings;
    private List < ? extends Note > studentPlacements;
    
//  private InputStream previousInstitutionDiplomaPhotograph;
    private byte[] previousInstitutionDiplomaPhotograph;
    private String previousInstitutionDiplomaPhotographName;
    private String previousInstitutionDiplomaPhotographMimeType;
    private String previousInstitutionDiplomaPhotographRemarks;
    private String subscriptionRequirementsFulfilled;
// start new fields Zambia
    private int secondaryStudyId;
    private String foreignStudent;
    private String nationalityGroupCode;
    private String relativeOfStaffMember;
    private String employeeNumberOfRelative;
    private String ruralAreaOrigin;
    private boolean hasPaidAllFees;
    private boolean hasMadeSufficientPayments;
    private StudentBalanceInformation studentBalanceInformation;
 // end new fields Zambia
    
    private boolean proceedToAdmissionProgressStatus;
    private boolean proceedToAdmissionFinalizeStatus;
    private boolean proceedToContinuedRegistrationProgressStatus; 
    private boolean proceedToContinuedRegistrationFinalizeStatus;
    
    private String studentWriteWho;
    
    public Student() {
    	// default values to prevent database NOT-NULL-exceptions
    	foreignStudent = "N";
    	relativeOfStaffMember = "N";
    	ruralAreaOrigin = "N";
    }

    public String getStudentCode() {
        return studentCode;
    }

    public List < ? extends StudentAbsence > getStudentAbsences() {
		return studentAbsences;
	}

	public void setStudentAbsences(List < ? extends StudentAbsence > studentAbsences) {
		this.studentAbsences = studentAbsences;
	}
	
	public List < ? extends StudentExpulsion > getStudentExpulsions() {
        return studentExpulsions;
    }

    public void setStudentExpulsions(List < ? extends StudentExpulsion > studentExpulsions) {
        this.studentExpulsions = studentExpulsions;
    }
    
	/**
	 * @return the studentBalances
	 */
	public List<StudentBalance> getStudentBalances() {
		return studentBalances;
	}

	/**
	 * @param studentBalances the studentBalances to set
	 */
	public void setStudentBalances(List<StudentBalance> studentBalances) {
		this.studentBalances = studentBalances;
	}

	public List < Penalty > getPenalties() {
        return penalties;
    }

    public void setPenalties(List < Penalty > penalties) {
        this.penalties = penalties;
    }

    public void setStudentCode(String newStudentCode) {
        studentCode = StringUtils.trim(newStudentCode);
    }

    public int getStudentId() {
        return studentId;
    }
    public void setStudentId(int newStudentId) {
        studentId = newStudentId;
    }

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int newPersonId) {
        personId = newPersonId;
    }

    public List < ? extends Address > getAddresses() {
        return addresses;
    }

    public void setAddresses(List < ? extends Address > newAddresses) {
        addresses = newAddresses;
    }

    public Date getDateOfEnrolment() {
        return dateOfEnrolment;
    }

    public void setDateOfEnrolment(Date newDateOfEnrolment) {
        dateOfEnrolment = newDateOfEnrolment;
    }

    public String getFatherEducationCode() {
        return fatherEducationCode;
    }

    public void setFatherEducationCode(String newFatherEducationCode) {
        fatherEducationCode = newFatherEducationCode;
    }

    public String getFatherFullName() {
        return fatherFullName;
    }

    public void setFatherFullName(String newFatherFullName) {
        fatherFullName = StringUtils.trim(newFatherFullName);
    }

    public String getFatherProfessionCode() {
        return fatherProfessionCode;
    }

    public void setFatherProfessionCode(String newFatherProfessionCode) {
        fatherProfessionCode = newFatherProfessionCode;
    }

    public String getFatherTelephone() {
        return fatherTelephone;
    }

    public void setFatherTelephone(String fatherTelephone) {
        this.fatherTelephone = StringUtils.trim(fatherTelephone);
    }

    public String getFinancialGuardianFullName() {
        return financialGuardianFullName;
    }

    public void setFinancialGuardianFullName(String newFinancialGuardianFullName) {
        financialGuardianFullName = StringUtils.trim(newFinancialGuardianFullName);
    }

    public String getFinancialGuardianProfession() {
        return financialGuardianProfession;
    }

    public void setFinancialGuardianProfession(
    		String newFinancialGuardianProfession) {
        financialGuardianProfession = StringUtils.trim(newFinancialGuardianProfession);
    }

    public String getFinancialGuardianRelation() {
        return financialGuardianRelation;
    }

    public void setFinancialGuardianRelation(
    		String newFinancialGuardianRelation) {
        financialGuardianRelation = StringUtils.trim(newFinancialGuardianRelation);
    }

    public String getMotherEducationCode() {
        return motherEducationCode;
    }

    public void setMotherEducationCode(String newMotherEducationCode) {
        motherEducationCode = newMotherEducationCode;
    }

    public String getMotherFullName() {
        return motherFullName;
    }

    public void setMotherFullName(String newMotherFullName) {
        motherFullName = StringUtils.trim(newMotherFullName);
    }

    public String getMotherProfessionCode() {
        return motherProfessionCode;
    }

    public void setMotherProfessionCode(String newMotherProfessionCode) {
        motherProfessionCode = StringUtils.trim(newMotherProfessionCode);
    }
    
    public String getMotherTelephone() {
        return motherTelephone;
    }

    public void setMotherTelephone(String motherTelephone) {
        this.motherTelephone = StringUtils.trim(motherTelephone);
    }

    public Date getExpellationDate() {
		return expellationDate;
	}

	public void setExpellationDate(Date expellationDate) {
		this.expellationDate = expellationDate;
	}

	public Date getExpellationEndDate() {
		return expellationEndDate;
	}

	public void setExpellationEndDate(Date expellationEndDate) {
		this.expellationEndDate = expellationEndDate;
	}

	public String getReasonForExpellation() {
		return reasonForExpellation;
	}

	public void setReasonForExpellation(String reasonForExpellation) {
		this.reasonForExpellation = reasonForExpellation;
	}

	public String getPreviousInstitutionCountryCode() {
        return previousInstitutionCountryCode;
    }

    public void setPreviousInstitutionCountryCode(
    		String newPreviousInstitutionCountryCode) {
        previousInstitutionCountryCode = newPreviousInstitutionCountryCode;
    }

    public String getPreviousInstitutionDistrictCode() {
        return previousInstitutionDistrictCode;
    }

    public void setPreviousInstitutionDistrictCode(
    		String newPreviousInstitutionDistrictCode) {
        previousInstitutionDistrictCode = newPreviousInstitutionDistrictCode;
    }

    public String getPreviousInstitutionTypeCode() {
        return previousInstitutionTypeCode;
    }

    public void setPreviousInstitutionTypeCode(String previousInstitutionTypeCode) {
        this.previousInstitutionTypeCode = previousInstitutionTypeCode;
    }

    public String getPreviousInstitutionFinalGradeTypeCode() {
        return previousInstitutionFinalGradeTypeCode;
    }

    public void setPreviousInstitutionFinalGradeTypeCode(
    		String newPreviousInstitutionFinalGradeTypeCode) {
        previousInstitutionFinalGradeTypeCode = newPreviousInstitutionFinalGradeTypeCode;
    }

    public String getPreviousInstitutionFinalMark() {
        return previousInstitutionFinalMark;
    }

    public void setPreviousInstitutionFinalMark(
    		String newPreviousInstitutionFinalMark) {
        previousInstitutionFinalMark = StringUtils.trim(newPreviousInstitutionFinalMark);
    }

    public int getPreviousInstitutionId() {
        return previousInstitutionId;
    }

    public void setPreviousInstitutionId(int newPreviousInstitutionId) {
        previousInstitutionId = newPreviousInstitutionId;
    }

    public String getPreviousInstitutionName() {
        return previousInstitutionName;
    }

    public void setPreviousInstitutionName(String newPreviousInstitutionName) {
        previousInstitutionName = StringUtils.trim(newPreviousInstitutionName);
    }

    public String getPreviousInstitutionProvinceCode() {
        return previousInstitutionProvinceCode;
    }

    public void setPreviousInstitutionProvinceCode(
    		String newPreviousInstitutionProvinceCode) {
        previousInstitutionProvinceCode = newPreviousInstitutionProvinceCode;
    }

    public String getScholarship() {
        return scholarship;
    }

    public void setScholarship(String newScholarship) {
        scholarship = newScholarship;
    }

//    public String getStatusCode() {
//        return statusCode;
//    }
//
//    public void setStatusCode(String newStatusCode) {
//        statusCode = newStatusCode;
//    }

    public List < StudyPlan > getStudyPlans() {
        return studyPlans;
    }

    public void setStudyPlans(List < StudyPlan > newStudyPlans) {
        studyPlans = newStudyPlans;
    }

    public int getPrimaryStudyId() {
        return primaryStudyId;
    }

    public void setPrimaryStudyId(int newPrimaryStudyId) {
        primaryStudyId = newPrimaryStudyId;
    }

    
    public String getFatherProfessionDescription() {
		return fatherProfessionDescription;
	}

	public void setFatherProfessionDescription(String fatherProfessionDescription) {
		this.fatherProfessionDescription = StringUtils.trim(fatherProfessionDescription);
	}

	public String getMotherProfessionDescription() {
		return motherProfessionDescription;
	}

	public void setMotherProfessionDescription(String motherProfessionDescription) {
		this.motherProfessionDescription = motherProfessionDescription;
	}

	public String getPreviousInstitutionDiplomaPhotographRemarks() {
		return previousInstitutionDiplomaPhotographRemarks;
	}

	public String getExpellationTypeCode() {
		return expellationTypeCode;
	}

	public void setExpellationTypeCode(String expellationTypeCode) {
		this.expellationTypeCode = expellationTypeCode;
	}

	public String getSubscriptionRequirementsFulfilled() {
        return subscriptionRequirementsFulfilled;
    }

    public void setSubscriptionRequirementsFulfilled(
            String subscriptionRequirementsFulfilled) {
        this.subscriptionRequirementsFulfilled = subscriptionRequirementsFulfilled;
    }

    public void setPreviousInstitutionDiplomaPhotographRemarks(
			String previousInstitutionDiplomaPhotographRemarks) {
		this.previousInstitutionDiplomaPhotographRemarks = 
			previousInstitutionDiplomaPhotographRemarks;
	}

	public byte[] getPreviousInstitutionDiplomaPhotograph() {
    	return previousInstitutionDiplomaPhotograph;
    }

    public void setPreviousInstitutionDiplomaPhotograph(
    		byte[] newPreviousInstitutionDiplomaPhotograph) {
    	previousInstitutionDiplomaPhotograph = newPreviousInstitutionDiplomaPhotograph;
    }

	/**
	 * Returns the current state of the boolean previousInstitutionDiplomaPhotograph.
	 * @return boolean yes or no
	 */
	public boolean getHasPrevInstDiplomaPhoto() {
		
		if (this.previousInstitutionDiplomaPhotograph != null) {
			return true;
		} else {
			return false;
		}
	}

	public String getPreviousInstitutionDiplomaPhotographName() {
		return previousInstitutionDiplomaPhotographName;
	}

	public void setPreviousInstitutionDiplomaPhotographName(
			String previousInstitutionDiplomaPhotographName) {
		this.previousInstitutionDiplomaPhotographName = previousInstitutionDiplomaPhotographName;
	}

	public String getPreviousInstitutionDiplomaPhotographMimeType() {
		return previousInstitutionDiplomaPhotographMimeType;
	}

	public void setPreviousInstitutionDiplomaPhotographMimeType(
			String previousInstitutionDiplomaPhotographMimeType) {
		this.previousInstitutionDiplomaPhotographMimeType = previousInstitutionDiplomaPhotographMimeType;
	}
	
    public int getSecondaryStudyId() {
        return secondaryStudyId;
    }

    public void setSecondaryStudyId(int secondaryStudyId) {
        this.secondaryStudyId = secondaryStudyId;
    }

    public String getForeignStudent() {
		return foreignStudent;
	}

	public void setForeignStudent(String foreignStudent) {
		this.foreignStudent = foreignStudent;
	}

	public String getNationalityGroupCode() {
        return nationalityGroupCode;
    }

    public void setNationalityGroupCode(String nationalityGroupCode) {
        this.nationalityGroupCode = nationalityGroupCode;
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
	public void setRelativeOfStaffMember(String relativeOfStaffMember) {
		this.relativeOfStaffMember = relativeOfStaffMember;
	}

	
    public String getEmployeeNumberOfRelative() {
        return employeeNumberOfRelative;
    }

    public void setEmployeeNumberOfRelative(String employeeNumberOfRelative) {
        this.employeeNumberOfRelative = employeeNumberOfRelative;
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
	public void setRuralAreaOrigin(String ruralAreaOrigin) {
		this.ruralAreaOrigin = ruralAreaOrigin;
	}

	/**
	 * @return the proceedToAdmissionProgressStatus
	 */
	public boolean getProceedToAdmissionProgressStatus() {
		return proceedToAdmissionProgressStatus;
	}

	/**
	 * @param proceedToAdmissionProgressStatus the proceedToAdmissionProgressStatus to set
	 */
	public void setProceedToAdmissionProgressStatus(
			boolean proceedToAdmissionProgressStatus) {
		this.proceedToAdmissionProgressStatus = proceedToAdmissionProgressStatus;
	}

	/**
	 * @return the proceedToAdmissionFinalizeStatus
	 */
	public boolean getProceedToAdmissionFinalizeStatus() {
		return proceedToAdmissionFinalizeStatus;
	}

	/**
	 * @param proceedToAdmissionFinalizeStatus the proceedToAdmissionFinalizeStatus to set
	 */
	public void setProceedToAdmissionFinalizeStatus(
			boolean proceedToAdmissionFinalizeStatus) {
		this.proceedToAdmissionFinalizeStatus = proceedToAdmissionFinalizeStatus;
	}

	/**
	 * @return the proceedToContinuedRegistrationProgressStatus
	 */
	public boolean getProceedToContinuedRegistrationProgressStatus() {
		return proceedToContinuedRegistrationProgressStatus;
	}
	/**
	 * @param proceedToContinuedRegistrationProgressStatus the proceedToContinuedRegistrationProgressStatus to set
	 */
	public void setProceedToContinuedRegistrationProgressStatus(
			boolean proceedToContinuedRegistrationProgressStatus) {
		this.proceedToContinuedRegistrationProgressStatus = proceedToContinuedRegistrationProgressStatus;
	}

	/**
	 * @return the proceedToContinuedRegistrationFinalizeStatus
	 */
	public boolean getProceedToContinuedRegistrationFinalizeStatus() {
		return proceedToContinuedRegistrationFinalizeStatus;
	}
	/**
	 * @param proceedToContinuedRegistrationFinalizeStatus the proceedToContinuedRegistrationFinalizeStatus to set
	 */
	public void setProceedToContinuedRegistrationFinalizeStatus(
			boolean proceedToContinuedRegistrationFinalizeStatus) {
		this.proceedToContinuedRegistrationFinalizeStatus = proceedToContinuedRegistrationFinalizeStatus;
	}

	public List <? extends Note > getStudentActivities() {
        return studentActivities;
    }

    public void setStudentActivities(List <? extends Note > studentActivities) {
        this.studentActivities = studentActivities;
    }

    public List <? extends Note > getStudentCareers() {
        return studentCareers;
    }

    public void setStudentCareers(List <? extends Note > studentCareers) {
        this.studentCareers = studentCareers;
    }

    public List <? extends Note > getStudentCounselings() {
        return studentCounselings;
    }

    public void setStudentCounselings(List <? extends Note > studentCounselings) {
        this.studentCounselings = studentCounselings;
    }

    public List <? extends Note > getStudentPlacements() {
        return studentPlacements;
    }

    public void setStudentPlacements(List <? extends Note > studentPlacements) {
        this.studentPlacements = studentPlacements;
    }

    public void setStudentStudentStatuses(List<StudentStudentStatus> studentStudentStatuses) {
        this.studentStudentStatuses = studentStudentStatuses;
    }

    public List<StudentStudentStatus> getStudentStudentStatuses() {
        return studentStudentStatuses;
    }

    public void addStudentStudentStatus(Date startDate, String studentStatusCode) {
        if (studentStudentStatuses == null) {
            studentStudentStatuses = new ArrayList<>();
        }
        StudentStudentStatus ssStatus = new StudentStudentStatus();
        ssStatus.setStudentId(studentId);
        ssStatus.setStartDate(startDate);
        ssStatus.setStudentStatusCode(studentStatusCode);
        studentStudentStatuses.add(ssStatus);
    }

	public String getStudentWriteWho() {
		return studentWriteWho;
	}

	public void setStudentWriteWho(String studentWriteWho) {
		this.studentWriteWho = studentWriteWho;
	}

    public boolean getHasMadeSufficientPayments() {
        return hasMadeSufficientPayments;
    }

    public void setHasMadeSufficientPayments(boolean hasMadeSufficientPayments) {
        this.hasMadeSufficientPayments = hasMadeSufficientPayments;
    }

    public boolean getHasPaidAllFees() {
        return hasPaidAllFees;
    }

    public void setHasPaidAllFees(boolean hasPaidAllFees) {
        this.hasPaidAllFees = hasPaidAllFees;
    }

    public StudentBalanceInformation getStudentBalanceInformation() {
        return studentBalanceInformation;
    }

    public void setStudentBalanceInformation(StudentBalanceInformation studentBalanceInformation) {
        this.studentBalanceInformation = studentBalanceInformation;
    }

	public List < Classgroup > getClassgroups() {
		return classgroups;
	}

	public void setClassgroups(List < Classgroup > classgroups) {
		this.classgroups = classgroups;
	}
    
	/**
	 * Get the "newest" student status code
	 * @return null if no stutent status has been defined
	 */
	public String getLatestStudentStatusCode() {
        List<StudentStudentStatus> statuses = getStudentStudentStatuses();
        
        // latest/newest status is the one on top; statuses are loaded in reverse order in sql query
        if (statuses != null && !statuses.isEmpty()) {
            return statuses.get(0).getStudentStatusCode();
        }
        return null;

	}

	public String getMissingDocuments() {
		return missingDocuments;
	}

	public void setMissingDocuments(String missingDocuments) {
		this.missingDocuments = missingDocuments;
	}

	public String getSourceOfFunding() {
		return sourceOfFunding;
	}

	public void setSourceOfFunding(String sourceOfFunding) {
		this.sourceOfFunding = sourceOfFunding;
	}
	
}
