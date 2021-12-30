package org.uci.opus.fee.web.form;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;

public class FeeSubjectAndSubjectBlockForm {
    
    private NavigationSettings navigationSettings;
    private Fee fee;
    private List < ? extends Lookup > feeCategories;
    private List <AcademicYear> allAcademicYears;
    private Branch branch;
    private AcademicYear academicYear;
    
    private Study study;
    private Subject subject;
    private SubjectBlock subjectBlock;
    
    List < ? extends Lookup > allStudyForms;
    List < ? extends Lookup > allStudyTimes;
    List < ? extends Lookup > allFeeCategories;

    List < ? extends SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypesWithoutFees;
    List < ? extends SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes;
    
    List < ? extends SubjectStudyGradeType > allSubjectStudyGradeTypesWithoutFees;
    List < ? extends SubjectStudyGradeType > allSubjectStudyGradeTypes;
    
    private List< Map <String, Object > > feeDeadlines;
    
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	
	public void setNavigationSettings(NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}
	public Fee getFee() {
		return fee;
	}
	public void setFee(Fee fee) {
		this.fee = fee;
	}
	public List<? extends Lookup> getFeeCategories() {
		return feeCategories;
	}
	public void setFeeCategories(List<? extends Lookup> feeCategories) {
		this.feeCategories = feeCategories;
	}
	public List<AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}
	public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}
	public Branch getBranch() {
		return branch;
	}
	public void setBranch(Branch branch) {
		this.branch = branch;
	}

	public AcademicYear getAcademicYear() {
		return academicYear;
	}

	public void setAcademicYear(AcademicYear academicYear) {
		this.academicYear = academicYear;
	}

	public Study getStudy() {
		return study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	public List<? extends Lookup> getAllStudyForms() {
		return allStudyForms;
	}

	public void setAllStudyForms(List<? extends Lookup> allStudyForms) {
		this.allStudyForms = allStudyForms;
	}

	public List<? extends Lookup> getAllStudyTimes() {
		return allStudyTimes;
	}

	public void setAllStudyTimes(List<? extends Lookup> allStudyTimes) {
		this.allStudyTimes = allStudyTimes;
	}

	public List<? extends Lookup> getAllFeeCategories() {
		return allFeeCategories;
	}

	public void setAllFeeCategories(List<? extends Lookup> allFeeCategories) {
		this.allFeeCategories = allFeeCategories;
	}

	public List<? extends SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypesWithoutFees() {
		return allSubjectBlockStudyGradeTypesWithoutFees;
	}

	public void setAllSubjectBlockStudyGradeTypesWithoutFees(
			List<? extends SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypesWithoutFees) {
		this.allSubjectBlockStudyGradeTypesWithoutFees = allSubjectBlockStudyGradeTypesWithoutFees;
	}

	public List<? extends SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypes() {
		return allSubjectBlockStudyGradeTypes;
	}

	public void setAllSubjectBlockStudyGradeTypes(
			List<? extends SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes) {
		this.allSubjectBlockStudyGradeTypes = allSubjectBlockStudyGradeTypes;
	}

	public SubjectBlock getSubjectBlock() {
		return subjectBlock;
	}

	public void setSubjectBlock(SubjectBlock subjectBlock) {
		this.subjectBlock = subjectBlock;
	}

	public List<? extends SubjectStudyGradeType> getAllSubjectStudyGradeTypesWithoutFees() {
		return allSubjectStudyGradeTypesWithoutFees;
	}

	public void setAllSubjectStudyGradeTypesWithoutFees(
			List<? extends SubjectStudyGradeType> allSubjectStudyGradeTypesWithoutFees) {
		this.allSubjectStudyGradeTypesWithoutFees = allSubjectStudyGradeTypesWithoutFees;
	}

	public List<? extends SubjectStudyGradeType> getAllSubjectStudyGradeTypes() {
		return allSubjectStudyGradeTypes;
	}

	public void setAllSubjectStudyGradeTypes(
			List<? extends SubjectStudyGradeType> allSubjectStudyGradeTypes) {
		this.allSubjectStudyGradeTypes = allSubjectStudyGradeTypes;
	}

	public List<Map<String, Object>> getFeeDeadlines() {
		return feeDeadlines;
	}

	public void setFeeDeadlines(List<Map<String, Object>> feeDeadlines) {
		this.feeDeadlines = feeDeadlines;
	}

	
}
