package org.uci.opus.fee.web.form;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;

public class FeeAcademicYearForm {
    
    private NavigationSettings navigationSettings;
    private Fee fee;
    private List < ? extends Lookup > feeCategories;
    private List < ? extends Lookup > allStudyTimes;
    private List < ? extends Lookup > allStudyForms;
    private List < ? extends Lookup > allNationalityGroups;
    private List < ? extends Lookup > allEducationLevels;
    private List < ? extends Lookup > allEducationAreas;
    private List <AcademicYear> allAcademicYears;
    private List<Lookup> allStudyIntensities;
    private List<? extends Lookup> allFeeUnits;
    private Branch branch;
    private AcademicYear academicYear;
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

	public List<? extends Lookup> getAllNationalityGroups() {
		return allNationalityGroups;
	}

	public void setAllNationalityGroups(List<? extends Lookup> allNationalityGroups) {
		this.allNationalityGroups = allNationalityGroups;
	}

	public List<? extends Lookup> getAllEducationLevels() {
		return allEducationLevels;
	}

	public void setAllEducationLevels(List<? extends Lookup> allEducationLevels) {
		this.allEducationLevels = allEducationLevels;
	}

	public List<? extends Lookup> getAllEducationAreas() {
		return allEducationAreas;
	}

	public void setAllEducationAreas(List<? extends Lookup> allEducationAreas) {
		this.allEducationAreas = allEducationAreas;
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

	public List<Map<String, Object>> getFeeDeadlines() {
		return feeDeadlines;
	}

	public void setFeeDeadlines(List<Map<String, Object>> feeDeadlines) {
		this.feeDeadlines = feeDeadlines;
	}

    public List<Lookup> getAllStudyIntensities() {
        return allStudyIntensities;
    }

    public void setAllStudyIntensities(List<Lookup> allStudyIntensities) {
        this.allStudyIntensities = allStudyIntensities;
    }

    public List<? extends Lookup> getAllFeeUnits() {
        return allFeeUnits;
    }

    public void setAllFeeUnits(List<? extends Lookup> allFeeUnits) {
        this.allFeeUnits = allFeeUnits;
    }

}
