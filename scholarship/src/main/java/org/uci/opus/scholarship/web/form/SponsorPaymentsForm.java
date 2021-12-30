package org.uci.opus.scholarship.web.form;

import java.util.Date;
import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;

public class SponsorPaymentsForm {
    
    private NavigationSettings navigationSettings;

    private int academicYearId;
    private int sponsorId;
    private int scholarshipId;
    private int sponsorInvoiceId;
    private Date from;
    private Date to;
    private Boolean cleared;

    private List<SponsorPayment> allSponsorPayments;
    private List<AcademicYear> allAcademicYears;
    private List<Sponsor> allSponsors;
    private List<Scholarship> allScholarships;
    private List<SponsorInvoice> allSponsorInvoices;

    private IdToAcademicYearMap idToAcademicYearMap;
    
    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
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

    public Date getFrom() {
        return from;
    }

    public void setFrom(Date from) {
        this.from = from;
    }

    public Date getTo() {
        return to;
    }

    public void setTo(Date to) {
        this.to = to;
    }

    public Boolean getCleared() {
        return cleared;
    }

    public void setCleared(Boolean cleared) {
        this.cleared = cleared;
    }

    public List<Scholarship> getAllScholarships() {
        return allScholarships;
    }

    public void setAllScholarships(List<Scholarship> allScholarships) {
        this.allScholarships = allScholarships;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public List<SponsorPayment> getAllSponsorPayments() {
        return allSponsorPayments;
    }

    public void setAllSponsorPayments(List<SponsorPayment> allSponsorPayments) {
        this.allSponsorPayments = allSponsorPayments;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public List<SponsorInvoice> getAllSponsorInvoices() {
        return allSponsorInvoices;
    }

    public void setAllSponsorInvoices(List<SponsorInvoice> allSponsorInvoices) {
        this.allSponsorInvoices = allSponsorInvoices;
    }

    public int getSponsorInvoiceId() {
        return sponsorInvoiceId;
    }

    public void setSponsorInvoiceId(int sponsorInvoiceId) {
        this.sponsorInvoiceId = sponsorInvoiceId;
    }
    
}
