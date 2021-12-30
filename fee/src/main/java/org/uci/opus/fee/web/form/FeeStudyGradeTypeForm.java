package org.uci.opus.fee.web.form;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.util.CodeToLookupMap;

public class FeeStudyGradeTypeForm {

    private NavigationSettings navigationSettings;
    private Fee fee;
    private StudyGradeType studyGradeType;
    private Study study;
    
    // lists
    private List<? extends Lookup> allFeeCategories;
    private List <? extends Lookup> allStudyForms;
    private List <? extends Lookup> allStudyTimes;
    private List <? extends Lookup> allNationalityGroups;
    private CodeToLookupMap codeToStudyFormMap;
    private CodeToLookupMap codeToStudyTimeMap;
//    private CodeToLookupMap codeToNationalityGroupMap;
    private List<? extends Lookup> allStudyIntensities;
    private List<? extends Lookup> allFeeUnits;
    private List <AcademicYear> allAcademicYears;
    private IdToAcademicYearMap idToAcademicYearMap;
    private List <StudyGradeType> allStudyGradeTypesForFees;
    private List< Map <String, Object > > feeDeadlines;


    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setFee(Fee fee) {
        this.fee = fee;
    }

    public Fee getFee() {
        return fee;
    }

    public void setStudyGradeType(StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }

    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }

    public void setStudy(Study study) {
        this.study = study;
    }

    public Study getStudy() {
        return study;
    }

    public void setAllFeeCategories(List<? extends Lookup> allFeeCategories) {
        this.allFeeCategories = allFeeCategories;
    }

    public List<? extends Lookup> getAllFeeCategories() {
        return allFeeCategories;
    }

    public void setAllStudyForms(List <? extends Lookup> allStudyForms) {
        this.allStudyForms = allStudyForms;
    }

    public List <? extends Lookup> getAllStudyForms() {
        return allStudyForms;
    }

    public void setAllStudyTimes(List <? extends Lookup> allStudyTimes) {
        this.allStudyTimes = allStudyTimes;
    }

    public List<? extends Lookup> getAllNationalityGroups() {
		return allNationalityGroups;
	}

	public void setAllNationalityGroups(List<? extends Lookup> allNationalityGroups) {
		this.allNationalityGroups = allNationalityGroups;
	}

	public List <? extends Lookup> getAllStudyTimes() {
        return allStudyTimes;
    }

    public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
        this.codeToStudyFormMap = codeToStudyFormMap;
    }

    public CodeToLookupMap getCodeToStudyFormMap() {
        return codeToStudyFormMap;
    }

    public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
        this.codeToStudyTimeMap = codeToStudyTimeMap;
    }

    public CodeToLookupMap getCodeToStudyTimeMap() {
        return codeToStudyTimeMap;
    }

//    public CodeToLookupMap getCodeToNationalityGroupMap() {
//		return codeToNationalityGroupMap;
//	}
//
//	public void setCodeToNationalityGroupMap(
//			CodeToLookupMap codeToNationalityGroupMap) {
//		this.codeToNationalityGroupMap = codeToNationalityGroupMap;
//	}

	public void setAllStudyIntensities(List<? extends Lookup> allStudyIntensities) {
        this.allStudyIntensities = allStudyIntensities;
    }

    public List<? extends Lookup> getAllStudyIntensities() {
        return allStudyIntensities;
    }

    public void setAllFeeUnits(List<? extends Lookup> allFeeUnits) {
        this.allFeeUnits = allFeeUnits;
    }

    public List<? extends Lookup> getAllFeeUnits() {
        return allFeeUnits;
    }

    public void setAllAcademicYears(List <AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List <AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setAllStudyGradeTypesForFees(
            List <StudyGradeType> allStudyGradeTypesForFees) {
        this.allStudyGradeTypesForFees = allStudyGradeTypesForFees;
    }

    public List <StudyGradeType> getAllStudyGradeTypesForFees() {
        return allStudyGradeTypesForFees;
    }

	public List<Map<String, Object>> getFeeDeadlines() {
		return feeDeadlines;
	}

	public void setFeeDeadlines(List<Map<String, Object>> feeDeadlines) {
		this.feeDeadlines = feeDeadlines;
	}

}
