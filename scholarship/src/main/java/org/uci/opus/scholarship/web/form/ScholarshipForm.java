package org.uci.opus.scholarship.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.util.CodeToLookupMap;

public class ScholarshipForm {

    private NavigationSettings navigationSettings;
    private Scholarship scholarship;
    private int academicYearId;

    private List<Lookup> allScholarshipTypes;
    private List<Sponsor> allSponsors;
    private List<AcademicYear> allAcademicYears;

    private CodeToLookupMap codeToFeeCategoryMap;
    

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Scholarship getScholarship() {
        return scholarship;
    }

    public void setScholarship(Scholarship scholarship) {
        this.scholarship = scholarship;
    }

    public List<Lookup> getAllScholarshipTypes() {
        return allScholarshipTypes;
    }

    public void setAllScholarshipTypes(List<Lookup> allScholarshipTypes) {
        this.allScholarshipTypes = allScholarshipTypes;
    }

    public List<Sponsor> getAllSponsors() {
        return allSponsors;
    }

    public void setAllSponsors(List<Sponsor> allSponsors) {
        this.allSponsors = allSponsors;
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

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }
}
