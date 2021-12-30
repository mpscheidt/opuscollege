package org.uci.opus.scholarship.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;

public class SponsorPaymentForm {

    private NavigationSettings navigationSettings;

    private SponsorPayment sponsorPayment;
    private int academicYearId;
    private int sponsorId;
    private int scholarshipId;
    private boolean sponsorReceiptNumberWillBeGenerated;

    private List<AcademicYear> allAcademicYears;
    private List<Sponsor> allSponsors;
    private List<Scholarship> allScholarships;
    private List<SponsorInvoice> allSponsorInvoices;
    

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public SponsorPayment getSponsorPayment() {
        return sponsorPayment;
    }

    public void setSponsorPayment(SponsorPayment sponsorPayment) {
        this.sponsorPayment = sponsorPayment;
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

    public int getScholarshipId() {
        return scholarshipId;
    }

    public void setScholarshipId(int scholarshipId) {
        this.scholarshipId = scholarshipId;
    }

    public List<SponsorInvoice> getAllSponsorInvoices() {
        return allSponsorInvoices;
    }

    public void setAllSponsorInvoices(List<SponsorInvoice> allSponsorInvoices) {
        this.allSponsorInvoices = allSponsorInvoices;
    }

    public boolean isSponsorReceiptNumberWillBeGenerated() {
        return sponsorReceiptNumberWillBeGenerated;
    }

    public void setSponsorReceiptNumberWillBeGenerated(boolean sponsorReceiptNumberWillBeGenerated) {
        this.sponsorReceiptNumberWillBeGenerated = sponsorReceiptNumberWillBeGenerated;
    }

}
