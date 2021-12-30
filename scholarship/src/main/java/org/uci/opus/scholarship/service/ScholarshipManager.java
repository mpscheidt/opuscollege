/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College scholarship module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/
package org.uci.opus.scholarship.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.util.TimeUnit;
import org.uci.opus.college.util.TimeUnitInYear;
import org.uci.opus.scholarship.domain.Bank;
import org.uci.opus.scholarship.domain.Complaint;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.domain.ScholarshipFeePercentage;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.ScholarshipStudentData;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.domain.StudyPlanCardinalTimeUnit4Display;
import org.uci.opus.scholarship.domain.Subsidy;
import org.uci.opus.scholarship.persistence.BankMapper;
import org.uci.opus.scholarship.persistence.ComplaintMapper;
import org.uci.opus.scholarship.persistence.ScholarshipApplicationMapper;
import org.uci.opus.scholarship.persistence.ScholarshipFeePercentageMapper;
import org.uci.opus.scholarship.persistence.ScholarshipMapper;
import org.uci.opus.scholarship.persistence.ScholarshipStudentDataMapper;
import org.uci.opus.scholarship.persistence.ScholarshipStudentMapper;
import org.uci.opus.scholarship.persistence.SponsorInvoiceMapper;
import org.uci.opus.scholarship.persistence.SponsorMapper;
import org.uci.opus.scholarship.persistence.SponsorPaymentMapper;
import org.uci.opus.scholarship.persistence.SubsidyMapper;
import org.uci.opus.scholarship.service.extpoint.ScholarshipServiceExtensions;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.lookup.LookupUtil;

/**
 * @author move
 *
 */
@Service
public class ScholarshipManager implements ScholarshipManagerInterface {

    private static Logger log = LoggerFactory.getLogger(ScholarshipManager.class);
    
    @Autowired
    private LookupManagerInterface lookupManager;

    @Autowired
    private BankMapper bankMapper;
    
    @Autowired
    private ComplaintMapper complaintMapper;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private ScholarshipMapper scholarshipMapper;
    
    @Autowired
    private ScholarshipServiceExtensions scholarshipServiceExtensions;
    
    @Autowired
    private ScholarshipStudentDataMapper scholarshipStudentDataMapper;

    @Autowired
    private ScholarshipStudentMapper scholarshipStudentMapper;
    
    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private ScholarshipFeePercentageMapper scholarshipFeePercentageMapper;

    @Autowired
    private ScholarshipApplicationMapper scholarshipApplicationMapper;

    @Autowired
    private SponsorInvoiceMapper sponsorInvoiceMapper;

    @Autowired
    private SponsorMapper sponsorMapper;

    @Autowired
    private SponsorPaymentMapper sponsorPaymentMapper;
    
    @Autowired
    private SubsidyMapper subsidyMapper;

    @Override
    public List<Student> findStudentsAppliedForScholarship(final Map<String, Object> map) {

        return scholarshipMapper.findStudentsAppliedForScholarship(map);
    }

    @Override
    public List<ScholarshipStudent> findAllScholarshipStudents(final Map<String, Object> map) {

        return scholarshipStudentMapper.findAllScholarshipStudents(map);
    }

    @Override
    public ScholarshipStudent findScholarshipStudent(final int studentId) {

        return scholarshipStudentMapper.findScholarshipStudent(studentId);
    }

    @Override
    public List<ScholarshipStudent> findScholarshipStudents(final Map<String, Object> map) {

        return scholarshipStudentMapper.findScholarshipStudents(map);
    }

    @Override
    public Student findStudentByScholarshipStudentId(final int scholarshipStudentId) {

        return scholarshipStudentMapper.findStudentByScholarshipStudentId(scholarshipStudentId);
    }

    @Override
    public ScholarshipStudentData findScholarshipStudentData(final int studentId) {

        return scholarshipStudentDataMapper.findScholarshipStudentData(studentId);
    }

    @Override
    public List<ScholarshipStudent> findScholarshipStudentsForBank(final int bankId) {

        return scholarshipStudentMapper.findScholarshipStudentsForBank(bankId);
    }

    @Override
    public List<Lookup> findScholarshipTypes(final Map<String, Object> map) {
        return scholarshipMapper.findScholarshipTypes(map);
    }

    @Override
    public List<Sponsor> findAllSponsors() {
        return sponsorMapper.findAllSponsors();
    }

    @Override
    public List<Scholarship> findAllScholarships(final Map<String, Object> map) {

        List<Scholarship> allScholarships = null;
        Scholarship scholarship = null;
        Lookup scholarshipType = null;
        String preferredLanguage = "";

        allScholarships = scholarshipMapper.findScholarships(map);
        if ((String) map.get("preferredLanguage") != null && !"".equals((String) map.get("preferredLanguage"))) {

            preferredLanguage = (String) map.get("preferredLanguage");

            for (int i = 0; i < allScholarships.size(); i++) {

                // add the scholarship type to the scholarship
                scholarship = new Scholarship();
                scholarship = allScholarships.get(i);

                scholarshipType = new Lookup();
                scholarshipType = (Lookup) lookupManager.findLookup(preferredLanguage, scholarship.getScholarshipType().getCode(), "sch_scholarshipType");

                scholarship.setScholarshipType(scholarshipType);
            }
        }
        return allScholarships;
    }

    @Override
    public List<Scholarship> findScholarships(Map<String, Object> map) {
        return scholarshipMapper.findScholarships(map);
    }

    @Override
    public Scholarship findScholarship(int transferId, int academicYearId) {
        Map<String, Object> map = new HashMap<>();
        map.put("transferId", transferId);
        map.put("academicYearId", academicYearId);
        List<Scholarship> list = findScholarships(map);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Map<String, Object>> findScholarshipsPlusCounter(final Map<String, Object> map) {

        List<Scholarship> allScholarships = null;
        // a list of hashmaps: each hashmap holds a scholarship and the number of
        // times it has been granted
        List<Map<String, Object>> allScholarshipsCounted = new ArrayList<Map<String, Object>>();
        Lookup scholarshipType = null;
        Scholarship scholarship = null;
        // parametermap used to count the number of times a
        // scholarship has been granted
        Map<String, Object> countMap = map;
        // holds a scholarship and the number of times it has been granted
        Map<String, Object> scholarshipPlusCounterMap = new HashMap<String, Object>();
        int countApplied = 0;
        int countGranted = 0;
        String preferredLanguage = (String) map.get("preferredLanguage");

        // find the scholarships
        allScholarships = scholarshipMapper.findScholarships(map);

        for (int i = 0; i < allScholarships.size(); i++) {

            // add the scholarship type to the scholarship
            scholarship = new Scholarship();
            scholarship = allScholarships.get(i);

            scholarshipType = (Lookup) lookupManager.findLookup(preferredLanguage, scholarship.getScholarshipType().getCode(), "sch_scholarshipType");

            scholarship.setScholarshipType(scholarshipType);

            // count the number of scholarships granted
            countMap.put("id", scholarship.getId());
            countMap.put("status", "A");
            countApplied = countScholarships(countMap);

            countMap.put("status", "G");
            countGranted = countScholarships(countMap);

            // put the scholarship in the hashmap, together with the number of times
            // it has been granted
            scholarshipPlusCounterMap = new HashMap<String, Object>();
            scholarshipPlusCounterMap.put("scholarship", scholarship);
            scholarshipPlusCounterMap.put("countApplied", countApplied);
            scholarshipPlusCounterMap.put("countGranted", countGranted);

            allScholarshipsCounted.add(i, scholarshipPlusCounterMap);
        }

        return allScholarshipsCounted;
    }

    public int countScholarships(final Map<String, Object> map) {

        return scholarshipMapper.countScholarships(map);
    }

    public int countScholarshipApplications(final Map<String, Object> map) {

        return scholarshipApplicationMapper.countScholarshipApplications(map);
    }

    // allScholarshipApplications
    @Override
    public List<ScholarshipApplication> findScholarshipApplications(final Map<String, Object> map) {
        return scholarshipApplicationMapper.findScholarshipApplications(map);
    }

    // iBatis -> MyBatis migration: changed return type from List<Map<String, Object>> to
    // List<ScholarshipApplication>
    @Override
    public List<ScholarshipApplication> findScholarshipApplications2(final Map<String, Object> map) {
        return scholarshipApplicationMapper.findScholarshipApplications2(map);
    }

    @Override
    public void updateScholarshipStudent(final ScholarshipStudent scholarshipStudent) {
        this.scholarshipStudentMapper.updateScholarshipStudent(scholarshipStudent);
    }

    @Override
    public void updateAppliedForScholarshipForStudent(final Map<String, Object> map) {
        this.scholarshipStudentMapper.updateAppliedForScholarshipForStudent(map);
    }

    @Override
    public void addScholarshipStudent(final ScholarshipStudent scholarshipStudent) {
        this.scholarshipStudentMapper.addScholarshipStudent(scholarshipStudent);
    }

    @Override
    public void deleteScholarshipStudent(final int scholarshipStudentId) {
        this.complaintMapper.deleteComplaintsForStudent(scholarshipStudentId);
        log.debug("ScholarshipManager: complaints deleted");

        this.subsidyMapper.deleteSubsidiesForStudent(scholarshipStudentId);
        log.debug("ScholarshipManager: subsidies deleted");

        this.scholarshipApplicationMapper.deleteScholarshipsForStudent(scholarshipStudentId);
        log.debug("ScholarshipManager: applications for scholarships deleted");
        
        this.scholarshipStudentMapper.deleteScholarshipStudent(scholarshipStudentId);
        log.debug("ScholarshipManager: student scholarship data deleted");
    }

    @Override
    public List<ScholarshipApplication> findStudentScholarships(final int findStudentScholarships) {
        return this.scholarshipApplicationMapper.findStudentScholarships(findStudentScholarships);
    }

    @Override
    public List<Subsidy> findStudentSubsidies(final int scholarshipStudentId) {
        return subsidyMapper.findStudentSubsidies(scholarshipStudentId);
    }

    @Override
    public List<? extends Complaint> findStudentComplaints(final int scholarshipStudentId) {
        return complaintMapper.findStudentComplaints(scholarshipStudentId);
    }

    @Override
    public List<Bank> findBanks() {
        return bankMapper.findBanks();
    }

    @Override
    public Bank findBank(int bankId) {
        return this.bankMapper.findBank(bankId);
    }

    @Override
    public void addBank(Bank bank) {

        bankMapper.addBank(bank);
    }

    @Override
    public void updateBank(Bank bank) {

        bankMapper.updateBank(bank);
    }

    @Override
    public void deleteBank(final int bankId) {

        bankMapper.deleteBank(bankId);
    }

    @Override
    public ScholarshipApplication findScholarshipApplication(int scholarshipApplicationId) {
        return this.scholarshipApplicationMapper.findScholarshipApplication(scholarshipApplicationId);
    }

    @Override
    public Scholarship findScholarship(final Map<String, Object> map) {
        Scholarship scholarship = null;
        int scholarshipId = (Integer) map.get("scholarshipId");
        String preferredLanguage = (String) map.get("preferredLanguage");
        scholarship = this.scholarshipMapper.findScholarshipById(scholarshipId);

        // add scholarshipType
        Lookup scholarshipType = null;
        scholarshipType = (Lookup) lookupManager.findLookup(preferredLanguage, scholarship.getScholarshipType().getCode(), "sch_scholarshipType");

        scholarship.setScholarshipType(scholarshipType);

        return scholarship;
    }

    @Override
    public Subsidy findSubsidy(int subsidyId) {
        return subsidyMapper.findSubsidy(subsidyId);
    }

    @Override
    public Complaint findComplaint(int complaintId) {
        return this.complaintMapper.findComplaint(complaintId);
    }

    @Override
    public List<Map<String, Object>> findComplaints(final Map<String, Object> map) {

        return complaintMapper.findComplaints(map);
    }

    @Override
    public void addScholarship(Scholarship scholarship) {
        scholarshipMapper.addScholarship(scholarship);
    }

    @Override
    public int updateScholarship(Scholarship scholarship) {
        return scholarshipMapper.updateScholarship(scholarship);
    }

    @Override
    public String deleteScholarship(final int scholarshipId) {

        String showError = "";

        // check if scholarship is already applied for and / or granted
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("scholarshipId", scholarshipId);
        int applicationsCounted = countScholarshipApplications(map);
        if (applicationsCounted == 0) {
            scholarshipFeePercentageMapper.deleteScholarshipFeePercentagesForScholarshipId(scholarshipId);
            scholarshipMapper.deleteScholarship(scholarshipId);
        } else {
            // errors.reject("jsp.error.scholarship.delete");
            showError = "show";
        }

        return showError;
    }

    @Override
    public void addScholarshipApplication(ScholarshipApplication scholarshipApplication) {
        scholarshipApplicationMapper.addScholarshipApplication(scholarshipApplication);
    }

    @Override
    public void updateScholarshipApplication(ScholarshipApplication scholarshipApplication) {
        scholarshipApplicationMapper.updateScholarshipApplication(scholarshipApplication);
    }

    @Override
    public void deleteScholarshipApplication(final int scholarshipApplicationId) {

        complaintMapper.deleteComplaintsForScholarshipApplication(scholarshipApplicationId);

        scholarshipApplicationMapper.deleteScholarshipApplication(scholarshipApplicationId);
    }

    @Override
    public void addComplaint(Complaint complaint) {
        complaintMapper.addComplaint(complaint);
    }

    @Override
    public void updateComplaint(Complaint complaint) {
        complaintMapper.updateComplaint(complaint);
    }

    @Override
    public void deleteComplaint(final int complaintId) {
        complaintMapper.deleteComplaint(complaintId);
    }

    @Override
    public List<Map<String, Object>> findSubsidies(final Map<String, Object> map) {
        return subsidyMapper.findSubsidies(map);
    }

    @Override
    public void addSubsidy(Subsidy subsidy) {
        subsidyMapper.addSubsidy(subsidy);
    }

    @Override
    public void updateSubsidy(Subsidy subsidy) {
        subsidyMapper.updateSubsidy(subsidy);
    }

    @Override
    public void deleteSubsidy(final int subsidyId) {
        subsidyMapper.deleteSubsidy(subsidyId);
    }

    @Override
    public String findScholarshipApplicationObservation(int scholarshipApplicationId) {
        return scholarshipApplicationMapper.findScholarshipApplicationObservation(scholarshipApplicationId);
    }

    @Override
    public List<AcademicYear> findAcademicYearsForSponsor(final int sponsorId) {
        return sponsorMapper.findAcademicYearsForSponsor(sponsorId);
    }

    /**
     * @param lookupManager
     *            the lookupManager to set
     */
    public void setLookupManager(final LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('CREATE_SPONSORPAYMENTS')")
    public void addSponsorPayment(SponsorPayment sponsorPayment, HttpServletRequest request) {

        sponsorPayment.setWriteWho(opusMethods.getWriteWho(request));
        sponsorPaymentMapper.addSponsorPayment(sponsorPayment);
        sponsorPaymentMapper.insertSponsorPaymentHistory(sponsorPayment, "I");

        updateSponsorInvoiceCleared(sponsorPayment.getSponsorInvoiceId(), request);

    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('UPDATE_SPONSORPAYMENTS')")
    public void updateSponsorPayment(SponsorPayment sponsorPayment, HttpServletRequest request) {
        sponsorPayment.setWriteWho(opusMethods.getWriteWho(request));
        sponsorPaymentMapper.updateSponsorPayment(sponsorPayment);
        sponsorPaymentMapper.insertSponsorPaymentHistory(sponsorPayment, "U");

        updateSponsorInvoiceCleared(sponsorPayment.getSponsorInvoiceId(), request);
    }

    @Override
    @Transactional
    public void updateSponsorInvoiceCleared(int sponsorInvoiceId, HttpServletRequest request) {
        SponsorInvoice sponsorInvoice = findSponsorInvoiceById(sponsorInvoiceId);
        boolean cleared = sponsorInvoice.getOutstandingAmount().compareTo(BigDecimal.ZERO) <= 0;
        if (cleared != sponsorInvoice.isCleared()) {
            sponsorInvoice.setCleared(cleared);
            updateSponsorInvoice(sponsorInvoice, request);
        }
    }

    @Override
    public SponsorPayment findSponsorPaymentById(int sponsorPaymentId) {
        SponsorPayment sponsorPayment = sponsorPaymentMapper.findSponsorPaymentById(sponsorPaymentId);
        return sponsorPayment;
    }

    @Override
    @PreAuthorize("hasRole('READ_SPONSORPAYMENTS')")
    public List<SponsorPayment> findSponsorPayments(Map<String, Object> params) {
        return sponsorPaymentMapper.findSponsorPayments(params);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('DELETE_SPONSORPAYMENTS')")
    public void deleteSponsorPayment(final int sponsorPaymentId, HttpServletRequest request) {
        SponsorPayment sponsorPayment = findSponsorPaymentById(sponsorPaymentId);
        sponsorPayment.setWriteWho(opusMethods.getWriteWho(request));
        sponsorPaymentMapper.deleteSponsorPayment(sponsorPaymentId);
        sponsorPaymentMapper.insertSponsorPaymentHistory(sponsorPayment, "D");

        updateSponsorInvoiceCleared(sponsorPayment.getSponsorInvoiceId(), request);
    }

    @Override
    public boolean doesSponsorPaymentExist(Map<String, Object> params) {
        return sponsorPaymentMapper.doesSponsorPaymentExist(params);
    }

    /* ############### Sponsorfunctions ####################### */

    @Override
    @Transactional
    @PreAuthorize("hasRole('CREATE_SPONSORS')")
    public void addSponsor(Sponsor sponsor, HttpServletRequest request) {
        sponsor.setWriteWho(opusMethods.getWriteWho(request));
        sponsorMapper.addSponsor(sponsor);
        sponsorMapper.insertSponsorHistory(sponsor, "I");
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('UPDATE_SPONSORS')")
    public void updateSponsor(Sponsor sponsor, HttpServletRequest request) {
        sponsor.setWriteWho(opusMethods.getWriteWho(request));
        sponsorMapper.updateSponsor(sponsor);
        sponsorMapper.insertSponsorHistory(sponsor, "U");
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('DELETE_SPONSORS')")
    public void deleteSponsor(int sponsorId, String writeWho) {
        Sponsor sponsor = findSponsor(sponsorId);
        sponsor.setWriteWho(writeWho);

        sponsorMapper.deleteSponsor(sponsorId);
        sponsorMapper.insertSponsorHistory(sponsor, "I");
    }

    @Override
    public Sponsor findSponsor(int sponsorId) {
        return sponsorMapper.findSponsorById(sponsorId);
    }

    @Override
    public List<Sponsor> findSponsors(Map<String, Object> params) {
        return sponsorMapper.findSponsors(params);
    }

    @Override
    public List<Map<String, Object>> findSponsorsAsMaps(Map<String, Object> params) {
        return sponsorMapper.findSponsorsAsMaps(params);
    }

    @Override
    public boolean doesSponsorExist(int sponsorId, Map<String, Object> params) {

        if (params == null)
            params = new HashMap<String, Object>();

        params.put("id", sponsorId);

        return sponsorMapper.doesSponsorExist(params);
    }

    @Override
    public Map<String, Object> findSponsorDependencies(int sponsorId) {
        return sponsorMapper.findSponsorDependencies(sponsorId);
    }
    /* ############### ScholarshipFeePercentagefunctions ####################### */

    @Override
    public void addScholarshipFeePercentage(ScholarshipFeePercentage scholarshipFeePercentage) {
        scholarshipFeePercentageMapper.addScholarshipFeePercentage(scholarshipFeePercentage);
        scholarshipFeePercentageMapper.updateScholarshipFeePercentageHistory(scholarshipFeePercentage, "I");
    }

    @Override
    public void updateScholarshipFeePercentage(ScholarshipFeePercentage scholarshipFeePercentage) {
        scholarshipFeePercentageMapper.updateScholarshipFeePercentage(scholarshipFeePercentage);
        scholarshipFeePercentageMapper.updateScholarshipFeePercentageHistory(scholarshipFeePercentage, "U");
    }

    @Override
    public void deleteScholarshipFeePercentage(int scholarshipFeePercentageId, String writeWho) {

        ScholarshipFeePercentage feePercentage = findOne(scholarshipFeePercentageId);
        feePercentage.setWriteWho(writeWho);

        scholarshipFeePercentageMapper.deleteScholarshipFeePercentage(scholarshipFeePercentageId);
        scholarshipFeePercentageMapper.updateScholarshipFeePercentageHistory(feePercentage, "D");
    }

    @Override
    public ScholarshipFeePercentage findOne(int scholarshipFeePercentageId) {
        return scholarshipFeePercentageMapper.findOne(scholarshipFeePercentageId);
    }

    @Override
    public List<ScholarshipFeePercentage> findScholarshipFeePercentages(Map<String, Object> params) {
        return scholarshipFeePercentageMapper.findScholarshipFeePercentages(params);
    }

    @Override
    public List<String> findFeeCategoriesForScholarship(int scholarshipId) {
        return scholarshipFeePercentageMapper.findExistingFeeCategoriesForScholarship(scholarshipId);
    }

    @Override
    public List<StudyPlanCardinalTimeUnit4Display> getAllStudyPlanCardinalTimeUnits4Display(HttpServletRequest request, String preferredLanguage, int studentId) {
        List<StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits = studentManager.findStudyPlanCardinalTimeUnitsForStudent(studentId);

        lookupCacher.getStudyLookups(preferredLanguage, request);
        List<Lookup8> allCardinalTimeUnits = lookupCacher.getAllCardinalTimeUnits();

        List<StudyPlanCardinalTimeUnit4Display> allStudyPlanCardinalTimeUnits4Display = new ArrayList<StudyPlanCardinalTimeUnit4Display>(allStudyPlanCardinalTimeUnits.size());
        for (StudyPlanCardinalTimeUnit spctu : allStudyPlanCardinalTimeUnits) {
            StudyPlanCardinalTimeUnit4Display spctu4Display = new StudyPlanCardinalTimeUnit4Display(spctu);
            allStudyPlanCardinalTimeUnits4Display.add(spctu4Display);

            // get studyPlan
            StudyPlan studyPlan = studentManager.findStudyPlan(spctu.getStudyPlanId());
            spctu4Display.setStudyPlan(studyPlan);

            // get timeUnit
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(spctu.getStudyGradeTypeId());
            Lookup8 cardinalTimeUnit = (Lookup8) LookupUtil.getLookupByCode(allCardinalTimeUnits, studyGradeType.getCardinalTimeUnitCode());
            TimeUnit timeUnit = new TimeUnitInYear(cardinalTimeUnit, spctu.getCardinalTimeUnitNumber());
            spctu4Display.setTimeUnitInYear(timeUnit);
        }
        return allStudyPlanCardinalTimeUnits4Display;
    }

    @Override
    public SponsorInvoice findSponsorInvoiceById(int sponsorInvoiceId) {
        return sponsorInvoiceMapper.findSponsorInvoiceById(sponsorInvoiceId);
    }

    @Override
    @Transactional
    public List<SponsorInvoice> findSponsorInvoices(Map<String, Object> map) {
        return sponsorInvoiceMapper.findSponsorInvoices(map);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('CREATE_SPONSORINVOICES')")
    public void addSponsorInvoice(SponsorInvoice sponsorInvoice, HttpServletRequest request) {
        sponsorInvoice.setWriteWho(opusMethods.getWriteWho(request));
        sponsorInvoiceMapper.addSponsorInvoice(sponsorInvoice);
        sponsorInvoiceMapper.insertSponsorInvoiceHistory(sponsorInvoice, "I");
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('UPDATE_SPONSORINVOICES')")
    public void updateSponsorInvoice(SponsorInvoice sponsorInvoice, HttpServletRequest request) {
        sponsorInvoice.setWriteWho(opusMethods.getWriteWho(request));
        sponsorInvoiceMapper.updateSponsorInvoice(sponsorInvoice);
        sponsorInvoiceMapper.insertSponsorInvoiceHistory(sponsorInvoice, "U");
    }

    @Override
    @Transactional
    public void increaseSponsorInvoiceNrOfTimesPrinted(int sponsorInvoiceId, HttpServletRequest request) {
        SponsorInvoice sponsorInvoice = findSponsorInvoiceById(sponsorInvoiceId);
        sponsorInvoice.setNrOfTimesPrinted(sponsorInvoice.getNrOfTimesPrinted() + 1);
        updateSponsorInvoice(sponsorInvoice, request);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('DELETE_SPONSORINVOICES')")
    public int deleteSponsorInvoice(int sponsorInvoiceId, String writeWho) {
        SponsorInvoice sponsorInvoice = findSponsorInvoiceById(sponsorInvoiceId);
        sponsorInvoice.setWriteWho(writeWho);

        int n = sponsorInvoiceMapper.deleteSponsorInvoice(sponsorInvoiceId);
        sponsorInvoiceMapper.insertSponsorInvoiceHistory(sponsorInvoice, "D");
        return n;
    }

    @Override
    public boolean doesSponsorInvoiceExist(Map<String, Object> params) {
        return sponsorInvoiceMapper.doesSponsorInvoiceExist(params);
    }

    @Override
    public void transferScholarship(StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit) {
        // continue scholarship in the new time unit if applicable
        if (previousStudyPlanCardinalTimeUnit != null && previousStudyPlanCardinalTimeUnit.getStudyPlanId() == newStudyPlanCardinalTimeUnit.getStudyPlanId()) {

            Map<String, Object> map = new HashMap<String, Object>();
            map.put("studyPlanCardinalTimeUnitId", previousStudyPlanCardinalTimeUnit.getId());
            map.put("granted", "Y");

            // check if student had a scholarship in previous spctu
            List<ScholarshipApplication> scholarshipApplications = scholarshipApplicationMapper.findScholarshipApplicationsByParams(map);
            ScholarshipApplication previousScholarshipApplication = scholarshipApplications.isEmpty() ? null : scholarshipApplications.get(0);
            if (previousScholarshipApplication != null) {

                // check if there are any objections to applying the same scholarship in the new
                // time unit
                if (scholarshipServiceExtensions.isScholarshipRenewable(previousStudyPlanCardinalTimeUnit, newStudyPlanCardinalTimeUnit)) {

                    // Identify the scholarship in the new SPCTU
                    int previousAcademicYearId = studyManager.findStudyGradeType(previousStudyPlanCardinalTimeUnit.getStudyGradeTypeId()).getCurrentAcademicYearId();
                    int newAcademicYearId = studyManager.findStudyGradeType(newStudyPlanCardinalTimeUnit.getStudyGradeTypeId()).getCurrentAcademicYearId();
                    Scholarship previousScholarship = scholarshipMapper.findScholarshipById(previousScholarshipApplication.getScholarshipGrantedId());
                    Scholarship newScholarship;
                    if (previousAcademicYearId == newAcademicYearId) {
                        // Same academic year -> same scholarship
                        newScholarship = previousScholarship;
                    } else {
                        // In case of new academic year, search for scholarhip in new academic year
                        newScholarship = findScholarship(previousScholarship.getTransferId(), newAcademicYearId);
                    }

                    // assign scholarship to new time unit
                    ScholarshipApplication newScholarshipApplication = new ScholarshipApplication();
                    newScholarshipApplication.setScholarshipGrantedId(newScholarship.getId());
                    newScholarshipApplication.setScholarshipStudentId(previousScholarshipApplication.getScholarshipStudentId());
                    newScholarshipApplication.setStudyPlanCardinalTimeUnitId(newStudyPlanCardinalTimeUnit.getId());
                    scholarshipApplicationMapper.addScholarshipApplication(newScholarshipApplication);

                }
            }
        }
    }

}
