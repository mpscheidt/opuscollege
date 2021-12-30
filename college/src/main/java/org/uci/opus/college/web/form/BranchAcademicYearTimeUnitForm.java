package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.util.TimeUnitInYear;

public class BranchAcademicYearTimeUnitForm {

    private BranchAcademicYearTimeUnit branchAcademicYearTimeUnit;
    private Branch branch;
    private String educationTypeCode;
    private NavigationSettings navigationSettings;
    private String timeUnitId;

    private List<AcademicYear> allAcademicYears;
    private IdToAcademicYearMap idToAcademicYearMap;
    private List<TimeUnitInYear> allTimeUnits;
    
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

    public String getEducationTypeCode() {
        return educationTypeCode;
    }

    public void setEducationTypeCode(String educationTypeCode) {
        this.educationTypeCode = educationTypeCode;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public BranchAcademicYearTimeUnit getBranchAcademicYearTimeUnit() {
        return branchAcademicYearTimeUnit;
    }

    public void setBranchAcademicYearTimeUnit(BranchAcademicYearTimeUnit branchAcademicYearTimeUnit) {
        this.branchAcademicYearTimeUnit = branchAcademicYearTimeUnit;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List<TimeUnitInYear> getAllTimeUnits() {
        return allTimeUnits;
    }

    public void setAllTimeUnits(List<TimeUnitInYear> allTimeUnits) {
        this.allTimeUnits = allTimeUnits;
    }

    public String getTimeUnitId() {
        return timeUnitId;
    }

    public void setTimeUnitId(String timeUnitId) {
        this.timeUnitId = timeUnitId;
    }

}
