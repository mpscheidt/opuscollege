package org.uci.opus.fee.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.fee.domain.Fee;

public class StudentFeeForm {
    
    private Student student;
    private StudyPlan studyPlan;
    private int studyPlanCTUId;
    private int studyPlanDetailId;
    private int subjectBlockId;
    private int subjectId;
    private NavigationSettings navigationSettings;
    private Organization organization;
    private String txtError;
    private String writeWho;
    private Branch branch;
    
    private List < StudyPlan > studyPlans;
    private List < Fee > existingStudentFees;
    private List < Fee > possibleSubjectStudentFees;
    private List < Fee > possibleSubjectBlockStudentFees;
    private List < Fee > possibleStudyGradeTypeStudentFees;
    private List < Fee > possibleEducationAreaFees;
    
    private List < StudyGradeType > allStudyGradeTypes;
    private List < SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes;
    private List < SubjectStudyGradeType > allSubjectStudyGradeTypes;
    private List <AcademicYear> allAcademicYears;
    private List < ? extends Lookup > allFeeCategories;
    private List < ? extends Lookup > allFeeUnits;
    private List < ? extends Lookup > allStudyTimes;
    private List < ? extends Lookup > allStudyForms;
    
    public Student getStudent() {
        return student;
    }
    public void setStudent(Student student) {
        this.student = student;
    }
    public StudyPlan getStudyPlan() {
        return studyPlan;
    }
    public void setStudyPlan(StudyPlan studyPlan) {
        this.studyPlan = studyPlan;
    }
    
    public int getStudyPlanCTUId() {
        return studyPlanCTUId;
    }
    public void setStudyPlanCTUId(int studyPlanCTUId) {
        this.studyPlanCTUId = studyPlanCTUId;
    }
    
    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }
    public void setStudyPlanDetailId(int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
    }
    
    public int getSubjectBlockId() {
        return subjectBlockId;
    }
    public void setSubjectBlockId(int subjectBlockId) {
        this.subjectBlockId = subjectBlockId;
    }
    public int getSubjectId() {
        return subjectId;
    }
    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    public Organization getOrganization() {
        return organization;
    }
    public void setOrganization(Organization organization) {
        this.organization = organization;
    }
    public String getTxtError() {
        return txtError;
    }
    public void setTxtError(String txtError) {
        this.txtError = txtError;
    }
    public String getWriteWho() {
        return writeWho;
    }
    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }
    
    public Branch getBranch() {
        return branch;
    }
    public void setBranch(Branch branch) {
        this.branch = branch;
    }
    public List<StudyPlan> getStudyPlans() {
        return studyPlans;
    }
    public void setStudyPlans(List<StudyPlan> studyPlans) {
        this.studyPlans = studyPlans;
    }
    public List<Fee> getExistingStudentFees() {
        return existingStudentFees;
    }
    public void setExistingStudentFees(List<Fee> existingStudentFees) {
        this.existingStudentFees = existingStudentFees;
    }
    public List<Fee> getPossibleSubjectStudentFees() {
        return possibleSubjectStudentFees;
    }
    public void setPossibleSubjectStudentFees(
            List<Fee> possibleSubjectStudentFees) {
        this.possibleSubjectStudentFees = possibleSubjectStudentFees;
    }
    public List<Fee> getPossibleSubjectBlockStudentFees() {
        return possibleSubjectBlockStudentFees;
    }
    public void setPossibleSubjectBlockStudentFees(
            List<Fee> possibleSubjectBlockStudentFees) {
        this.possibleSubjectBlockStudentFees = possibleSubjectBlockStudentFees;
    }
    public List<Fee> getPossibleStudyGradeTypeStudentFees() {
        return possibleStudyGradeTypeStudentFees;
    }
    public void setPossibleStudyGradeTypeStudentFees(
            List<Fee> possibleStudyGradeTypeStudentFees) {
        this.possibleStudyGradeTypeStudentFees = possibleStudyGradeTypeStudentFees;
    }
   
    public List<Fee> getPossibleEducationAreaFees() {
		return possibleEducationAreaFees;
	}
	public void setPossibleEducationAreaFees(
			List<Fee> possibleEducationAreaFees) {
		this.possibleEducationAreaFees = possibleEducationAreaFees;
	}
	public List<StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}
	public void setAllStudyGradeTypes(List<StudyGradeType> allStudyGradeTypes) {
        this.allStudyGradeTypes = allStudyGradeTypes;
    }
    
    public List<SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypes() {
        return allSubjectBlockStudyGradeTypes;
    }
    public void setAllSubjectBlockStudyGradeTypes(
            List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes) {
        this.allSubjectBlockStudyGradeTypes = allSubjectBlockStudyGradeTypes;
    }
    public List<SubjectStudyGradeType> getAllSubjectStudyGradeTypes() {
        return allSubjectStudyGradeTypes;
    }
    public void setAllSubjectStudyGradeTypes(
            List<SubjectStudyGradeType> allSubjectStudyGradeTypes) {
        this.allSubjectStudyGradeTypes = allSubjectStudyGradeTypes;
    }
    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }
    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }
    public List<? extends Lookup> getAllFeeCategories() {
        return allFeeCategories;
    }
    public void setAllFeeCategories(List<? extends Lookup> allFeeCategories) {
        this.allFeeCategories = allFeeCategories;
    }
    public List<? extends Lookup> getAllFeeUnits() {
		return allFeeUnits;
	}
	public void setAllFeeUnits(List<? extends Lookup> allFeeUnits) {
		this.allFeeUnits = allFeeUnits;
	}
	public List<? extends Lookup> getAllStudyTimes() {
        return allStudyTimes;
    }
    public void setAllStudyTimes(List<? extends Lookup> allStudyTimes) {
        this.allStudyTimes = allStudyTimes;
    }
    public List<? extends Lookup> getAllStudyForms() {
        return allStudyForms;
    }
    public void setAllStudyForms(List<? extends Lookup> allStudyForms) {
        this.allStudyForms = allStudyForms;
    }

}
