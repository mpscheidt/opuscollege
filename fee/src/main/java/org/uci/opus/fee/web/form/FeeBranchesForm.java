package org.uci.opus.fee.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.util.CodeToLookupMap;

public class FeeBranchesForm {


    
    private Branch branch;
    private NavigationSettings navigationSettings;
    private List < ? extends Fee > allFeesForEducationAreas;
//    private List < ? extends Lookup > allFeeCategories;
    private List <AcademicYear> allAcademicYears;
//    private List < IAccommodationFee > allAccommodationFees;
    
    private CodeToLookupMap codeToFeeCategoryMap;
    private CodeToLookupMap codeToStudyIntensityMap;
    private CodeToLookupMap codeToFeeUnitMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyFormMap;
    
    
    public Branch getBranch() {
        return branch;
    }

    public void setBranch(Branch branch) {
        this.branch = branch;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public List<? extends Fee> getAllFeesForEducationAreas() {
		return allFeesForEducationAreas;
	}

	public void setAllFeesForEducationAreas(
			List<? extends Fee> allFeesForEducationAreas) {
		this.allFeesForEducationAreas = allFeesForEducationAreas;
	}

	//    public List<? extends Lookup> getAllFeeCategories() {
//        return allFeeCategories;
//    }
//
//    public void setAllFeeCategories(List<? extends Lookup> allFeeCategories) {
//        this.allFeeCategories = allFeeCategories;
//    }
//
    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public CodeToLookupMap getCodeToFeeCategoryMap() {
        return codeToFeeCategoryMap;
    }

    public void setCodeToFeeCategoryMap(CodeToLookupMap codeToFeeCategoryMap) {
        this.codeToFeeCategoryMap = codeToFeeCategoryMap;
    }

    public CodeToLookupMap getCodeToStudyIntensityMap() {
        return codeToStudyIntensityMap;
    }

    public void setCodeToStudyIntensityMap(CodeToLookupMap codeToStudyIntensityMap) {
        this.codeToStudyIntensityMap = codeToStudyIntensityMap;
    }

    public CodeToLookupMap getCodeToFeeUnitMap() {
        return codeToFeeUnitMap;
    }

    public void setCodeToFeeUnitMap(CodeToLookupMap codeToFeeUnitMap) {
        this.codeToFeeUnitMap = codeToFeeUnitMap;
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
    
    

//    public List<IAccommodationFee> getAllAccommodationFees() {
//        return allAccommodationFees;
//    }
//
//    public void setAllAccommodationFees(
//            List<IAccommodationFee> allAccommodationFees) {
//        this.allAccommodationFees = allAccommodationFees;
//    }
    
    
    

}
