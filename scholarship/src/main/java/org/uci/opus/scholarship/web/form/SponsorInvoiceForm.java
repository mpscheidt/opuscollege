package org.uci.opus.scholarship.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.BooleanToYesNoMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;

public class SponsorInvoiceForm {

    private NavigationSettings navigationSettings;

    private SponsorInvoice sponsorInvoice;
    private int academicYearId;
    private int sponsorId;
    private boolean sponsorInvoiceNumberWillBeGenerated;

    private List<AcademicYear> allAcademicYears;
    private List<Sponsor> allSponsors;
    private List<Scholarship> allScholarships;
    
    private BooleanToYesNoMap booleanToYesNoMap = new BooleanToYesNoMap();
    
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public SponsorInvoice getSponsorInvoice() {
        return sponsorInvoice;
    }

    public void setSponsorInvoice(SponsorInvoice sponsorInvoice) {
        this.sponsorInvoice = sponsorInvoice;
    }

    public List<Scholarship> getAllScholarships() {
        return allScholarships;
    }

    public void setAllScholarships(List<Scholarship> allScholarships) {
        this.allScholarships = allScholarships;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List<Sponsor> getAllSponsors() {
        return allSponsors;
    }

    public void setAllSponsors(List<Sponsor> allSponsors) {
        this.allSponsors = allSponsors;
    }

    public int getSponsorId() {
        return sponsorId;
    }

    public void setSponsorId(int sponsorId) {
        this.sponsorId = sponsorId;
    }

    public BooleanToYesNoMap getBooleanToYesNoMap() {
        return booleanToYesNoMap;
    }

    public void setBooleanToYesNoMap(BooleanToYesNoMap booleanToYesNoMap) {
        this.booleanToYesNoMap = booleanToYesNoMap;
    }

    public boolean isSponsorInvoiceNumberWillBeGenerated() {
        return sponsorInvoiceNumberWillBeGenerated;
    }

    public void setSponsorInvoiceNumberWillBeGenerated(boolean sponsorInvoiceNumberWillBeGenerated) {
        this.sponsorInvoiceNumberWillBeGenerated = sponsorInvoiceNumberWillBeGenerated;
    }

}
