package org.uci.opus.fee.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.fee.domain.DiscountedFee;
import org.uci.opus.fee.domain.Fee;

public class StudentFeesForm {
    
    private NavigationSettings navigationSettings;
    private List < ? extends Fee > allStudentFees;
    private List <AcademicYear> allAcademicYears;
    private Organization organization ;
    private List<StudyPlan> allStudyPlans;
    private List<? extends Lookup> allFeeCategories;
    private List<StudyPlanDetail> allStudyPlanDetails;
    private List < StudyPlanCardinalTimeUnit > allStudyPlanCardinalTimeUnits;

    private List<DiscountedFee> allStudentFeesForSubjectBlockStudyGradeTypes;
    private List<DiscountedFee> allStudentFeesForSubjectStudyGradeTypes;
    private List<DiscountedFee> allStudentFeesForStudyGradeTypes;
    private List<DiscountedFee> allStudentFeesForAcademicYears;
    
    public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
    public void setNavigationSettings(NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}
	public List<? extends Fee> getAllStudentFees() {
		return allStudentFees;
	}
	public void setAllStudentFees(List<? extends Fee> allStudentFees) {
		this.allStudentFees = allStudentFees;
	}
	public List<AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}
	public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	public List<StudyPlan> getAllStudyPlans() {
		return allStudyPlans;
	}
	public void setAllStudyPlans(List<StudyPlan> allStudyPlans) {
		this.allStudyPlans = allStudyPlans;
	}
	public List<? extends Lookup> getAllFeeCategories() {
		return allFeeCategories;
	}
	public void setAllFeeCategories(List<? extends Lookup> allFeeCategories) {
		this.allFeeCategories = allFeeCategories;
	}
	public List<StudyPlanDetail> getAllStudyPlanDetails() {
		return allStudyPlanDetails;
	}
	public void setAllStudyPlanDetails(List<StudyPlanDetail> allStudyPlanDetails) {
		this.allStudyPlanDetails = allStudyPlanDetails;
	}
	public List<StudyPlanCardinalTimeUnit> getAllStudyPlanCardinalTimeUnits() {
		return allStudyPlanCardinalTimeUnits;
	}
	public void setAllStudyPlanCardinalTimeUnits(
			List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits) {
		this.allStudyPlanCardinalTimeUnits = allStudyPlanCardinalTimeUnits;
	}
	public List<DiscountedFee> getAllStudentFeesForSubjectBlockStudyGradeTypes() {
		return allStudentFeesForSubjectBlockStudyGradeTypes;
	}
	public void setAllStudentFeesForSubjectBlockStudyGradeTypes(
			List<DiscountedFee> allStudentFeesForSubjectBlockStudyGradeTypes) {
		this.allStudentFeesForSubjectBlockStudyGradeTypes = allStudentFeesForSubjectBlockStudyGradeTypes;
	}
	public List<DiscountedFee> getAllStudentFeesForSubjectStudyGradeTypes() {
		return allStudentFeesForSubjectStudyGradeTypes;
	}
	public void setAllStudentFeesForSubjectStudyGradeTypes(
			List<DiscountedFee> allStudentFeesForSubjectStudyGradeTypes) {
		this.allStudentFeesForSubjectStudyGradeTypes = allStudentFeesForSubjectStudyGradeTypes;
	}
	public List<DiscountedFee> getAllStudentFeesForStudyGradeTypes() {
		return allStudentFeesForStudyGradeTypes;
	}
	public void setAllStudentFeesForStudyGradeTypes(
			List<DiscountedFee> allStudentFeesForStudyGradeTypes) {
		this.allStudentFeesForStudyGradeTypes = allStudentFeesForStudyGradeTypes;
	}
	public List<DiscountedFee> getAllStudentFeesForAcademicYears() {
		return allStudentFeesForAcademicYears;
	}
	public void setAllStudentFeesForAcademicYears(
			List<DiscountedFee> allStudentFeesForAcademicYears) {
		this.allStudentFeesForAcademicYears = allStudentFeesForAcademicYears;
	}
	
}
