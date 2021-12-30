package org.uci.opus.fee.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
//import org.uci.opus.college.domain.Branch;
//import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.util.CodeToLookupMap;

public class FeeBranchForm {
    
    private NavigationSettings navigationSettings;
    private List < ? extends Fee > allFeesForEducationArea;
    private List <AcademicYear> allAcademicYears;
    
    private CodeToLookupMap codeToFeeCategoryMap;
    private CodeToLookupMap codeToStudyIntensityMap;
    private CodeToLookupMap codeToFeeUnitMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyFormMap;
    private CodeToLookupMap codeToNationalityGroupMap;
    
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    
    public List<? extends Fee> getAllFeesForEducationArea() {
        return allFeesForEducationArea;
    }

    public void setAllFeesForEducationArea(
            List<? extends Fee> allFeesForEducationArea) {
        this.allFeesForEducationArea = allFeesForEducationArea;
    }

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

	public CodeToLookupMap getCodeToNationalityGroupMap() {
		return codeToNationalityGroupMap;
	}

	public void setCodeToNationalityGroupMap(
			CodeToLookupMap codeToNationalityGroupMap) {
		this.codeToNationalityGroupMap = codeToNationalityGroupMap;
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
