package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.util.CodeToTimeUnitMap;

public class BranchForm {

    private Branch branch;
    private NavigationSettings navigationSettings;

    private List<Institution> allInstitutions;
    private List<BranchAcademicYearTimeUnit> allBranchAcademicYearTimeUnits;

    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToTimeUnitMap codeToTimeUnitMap;
    
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

    public List<Institution> getAllInstitutions() {
        return allInstitutions;
    }

    public void setAllInstitutions(List<Institution> allInstitutions) {
        this.allInstitutions = allInstitutions;
    }

    public List<BranchAcademicYearTimeUnit> getAllBranchAcademicYearTimeUnits() {
        return allBranchAcademicYearTimeUnits;
    }

    public void setAllBranchAcademicYearTimeUnits(List<BranchAcademicYearTimeUnit> allBranchAcademicYearTimeUnits) {
        this.allBranchAcademicYearTimeUnits = allBranchAcademicYearTimeUnits;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public CodeToTimeUnitMap getCodeToTimeUnitMap() {
        return codeToTimeUnitMap;
    }

    public void setCodeToTimeUnitMap(CodeToTimeUnitMap codeToTimeUnitMap) {
        this.codeToTimeUnitMap = codeToTimeUnitMap;
    }

}
