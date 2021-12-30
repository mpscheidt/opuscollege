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

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
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

/**
 * @author move
 *
 */
public interface ScholarshipManagerInterface {
    
    /**
     * Returns a List of students who applied for a scholarship or not (depending on params)
     * @param map with parameters of which list to find exactly
     * @return List of students or null
     */
    List< ? extends Student > findStudentsAppliedForScholarship(final Map<String, Object> map);

    /**
     * Returns a List of scholarship-students (so only students who applied for !!)
     * @param map with parameters of which list to find exactly
     * @return List of scholarshipstudents or null
     */
    List< ? extends ScholarshipStudent > findAllScholarshipStudents(final Map<String, Object> map);

    /**
     * Returns a student by his/her id.
     * @param studentId id of the student to find
     * @return Student object or null
     */    
    ScholarshipStudent findScholarshipStudent(final int studentId);

    /**
     * 
     * @param map
     * @return
     */
    List < ScholarshipStudent > findScholarshipStudents(final Map<String, Object> map);

    /**
     * Returns a student by his/her scholarshipStudentId.
     * @param scholarshipStudentId id of the student to find
     * @return Student object or null
     */    
    Student findStudentByScholarshipStudentId(final int scholarshipStudentId);

    /**
     * Returns a the scholarshipdata for a student by his/her id.
     * @param studentId id of the student to find
     * @return ScholarshipStudentDat object or null
     */    
    ScholarshipStudentData findScholarshipStudentData(final int studentId);
 
    /**
     * Returns a list of scholarshipstudents for a bank by it's id.
     * @param bankId id of the bank for which scholarshipstudents to find
     * @return List of ScholarshipStudent objects or null
     */
    List < ScholarshipStudent > findScholarshipStudentsForBank(final int bankId);

    List<Scholarship> findAllScholarships(final Map<String, Object> map);

    Scholarship findScholarship(final Map<String, Object> map);
    
    List<Scholarship> findScholarships(final Map<String, Object> map);
    
    /**
     * Find a scholarship in a given academic year.
     */
    Scholarship findScholarship(int transferId, int academicYearId);

    List <Map<String, Object>> findScholarshipsPlusCounter(final Map<String, Object> map);
    
    List<Lookup> findScholarshipTypes(final Map<String, Object> map);

    List <Sponsor> findAllSponsors();
    
    List < ScholarshipApplication > findScholarshipApplications(final Map<String, Object> map);
    
    /**
     * Updates a complete scholarshipstudent.
     * @param scholarshipstudent object
     * @return
     */    
    void updateScholarshipStudent(final ScholarshipStudent scholarshipStudent);
    
    /**
     * Updates the scholarhip-attribute of a student.
     * @param studentId id of the student
     * @param appliedForScholarship value of this attribute
     * @return
     */    
    void updateAppliedForScholarshipForStudent(
                final Map<String, Object> map);
    
    /**
     * Add a complete scholarshipstudent.
     * @param scholarshipstudent object
     */    
    void addScholarshipStudent(final ScholarshipStudent scholarshipStudent);

    /**
     * delete a complete scholarshipstudent.
     * @param studentId
     * @return
     */    
    void deleteScholarshipStudent(final int scholarshipStudentId);

    /**
     * find all scholarship applications for a student.
     * @param scholarshipStudentId
     * @return List of ScholarshipApplication objects or null
     */    
    List < ? extends ScholarshipApplication > findStudentScholarships(final int scholarshipStudentId);

    /**
     * find all subsidies for a student.
     * @param scholarshipStudentId
     * @return List of Subsidy objects or null
     */    
    List < ? extends Subsidy > findStudentSubsidies(final int scholarshipStudentId);

    /**
     * find all scholarship applications complaints for a student.
     * @param scholarshipStudentId
     * @return List of Complaint objects or null
     */    
    List < ? extends Complaint > findStudentComplaints(final int scholarshipStudentId);

    /**
     * find a complete list of present banks.
     * @param
     * @return List of Bank objects or null;
     */    
    List<Bank> findBanks();

    /**
     * find a specific Bank
     * @param bankId
     * @return Bank object or null;
     */    
    Bank findBank(final int bankId);

    /**
     * add a bank
     * @param bank to add
     */
    void addBank(final Bank bank);
    
    /**
     * update a bank
     * @param bank to be updated
     * @return
     */
    void updateBank(final Bank bank);
    
    /**
     * delete a bank
     * @param bankId id of the bank to be deleted
     * @return
     */
    void deleteBank(final int bankId);

    /**
     * find a specific scholarshipApplication
     * @param scholarshipApplicationId
     * @return ScholarshipApplication object or null;
     */    
    ScholarshipApplication findScholarshipApplication(final int scholarshipApplicationId);
      
    /**
     * find a specific Subsidy
     * @param subsidyId
     * @return Subsidy object or null;
     */    
    Subsidy findSubsidy(final int subsidyId);

    /**
     * find a specific Complaint
     * @param complaintId
     * @return Complaint object or null;
     */    
    Complaint findComplaint(final int complaintId);
    
    /**
     * 
     * @param map
     * @return
     */
    List<Map<String, Object>> findComplaints(final Map<String, Object> map);

    /**
     * add a scholarship
     * @param scholarship to add
     */
    void addScholarship(final Scholarship scholarship);
    
    /**
     * update a scholarship
     * @param scholarship to be updated
     * @return id of the updated scholarship
     */
    int updateScholarship(final Scholarship scholarship);
    
    /**
     * delete a scholarship
     * @param scholarshipId id of the scholarship to be deleted
     * @return
     */
    String deleteScholarship(final int scholarshipId);

    /**
     * add a complete scholarshipapplication.
     * @param scholarshipApplication object
     */    
    void addScholarshipApplication(final ScholarshipApplication scholarshipApplication);

    /**
     * update a complete scholarshipapplication.
     * @param scholarshipApplication object
     * @return
     */    
    void updateScholarshipApplication(final ScholarshipApplication scholarshipApplication);

    /**
     * delete a complete scholarshipapplication.
     * @param scholarshipApplicationId
     * @return
     */    
    void deleteScholarshipApplication(final int scholarshipApplicationId);
    
    /**
     * add a complaint
     * @param complaint to add
     */
    void addComplaint(final Complaint complaint);
    
    /**
     * update a complaint
     * @param complaint to be updated
     * @return id of the updated complaint
     */
    void updateComplaint(final Complaint complaint);
    
    /**
     * delete a complaint
     * @param complaintId id of the complaint to be deleted
     */
    void deleteComplaint(final int complaintId);
    
    /**
     * find subsidies granted
     * @param map contains:
     *          institutionId
     *          branchId
     *          organizationalUnitId
     *          sponsorId
     *          
     * @return list of subsidies
     */
    List <Map<String, Object>> findSubsidies(final Map<String, Object> map);

    /**
     * add a Subsidy
     * @param Subsidy to add
     */
    void addSubsidy(final Subsidy subsidy);
    
    /**
     * update a Subsidy
     * @param Subsidy to be updated
     * @return
     */
    void updateSubsidy(final Subsidy subsidy);
    
    /**
     * delete a Subsidy
     * @param SubsidyId id of the Subsidy to be deleted
     * @return
     */
    void deleteSubsidy(final int subsidyId);
    
    /**
     * find Observation for a specific scholarshipApplication
     * @param scholarshipApplicationId
     * @return String with observation or null;
     */    
    String findScholarshipApplicationObservation(final int scholarshipApplicationId);
    /**
     * find subsidies granted
     * @param map contains:
     * institutionId
     * branchId
     * organizationalUnitId
     * sponsorId
     * selectedAcademicYearId
     * scholarshipId
     * preferredLanguage
     * processStatusCode 
     */
    List<ScholarshipApplication> findScholarshipApplications2(final Map<String, Object> map);
    
    /**
     * Find a list of academicYears that a given sponsor offers scholarships
     * @param sponsorId id of the sponsor
     * @return a list of academicYears
     */
    List < AcademicYear > findAcademicYearsForSponsor(final int sponsorId);

    /**
     * Updates a complete SponsorPayment.
     * @param request
     * @param SponsorPayment object
     * @return
     */    
    void updateSponsorPayment(final SponsorPayment sponsorPayment, HttpServletRequest request);

    /**
     * add a SponsorPayment
     * @param request
     * @param SponsorPayment to add
     */
    void addSponsorPayment(final SponsorPayment sponsorPayment, HttpServletRequest request);

    /**
     * find a specific SposorPayment
     * @param sposorPaymentId
     * @return SponsorPayment object or null;
     */    
    SponsorPayment findSponsorPaymentById(final int sponsorPaymentId);

    /**
     * Find SponsorPayment objects.
     * @param params
     * @return
     */
    List<SponsorPayment> findSponsorPayments(Map<String, Object> params);

    /**
     * delete a SponsorPayment
     * @param request
     * @param SponsorPaymentId id of the SponsorPayment to be deleted
     * @return
     */
    void deleteSponsorPayment(final int sponsorPaymentId, HttpServletRequest request);
    
    boolean doesSponsorPaymentExist(Map<String, Object> params);
    
    /* ############### Sponsor functions  ####################### */
        
    void addSponsor(Sponsor sponsor, HttpServletRequest request);
    
    void updateSponsor(Sponsor sponsor, HttpServletRequest request);
    
    void deleteSponsor(int sponsorId, String writeWho);
    
    Sponsor findSponsor(int sponsorId);
    
    List<Sponsor> findSponsors(Map<String, Object> params);
    
    List<Map<String, Object>> findSponsorsAsMaps(Map<String, Object> params);
    /**
     *Finds tables which reference sponsor with id = sponsorId 
     * @param sponsorid
     * @return
     */
    Map<String, Object> findSponsorDependencies(int sponsorId);
    
    /**
     * Checks if there is any sponsor with params equal to that of sponsor with id sponsorId
     * @param sponsorId
     * @param params
     * @return
     */
    boolean doesSponsorExist(int sponsorId, Map<String, Object> params);
    
    /* ############### ScholarshipFeePercentage functions  ####################### */
    
    void addScholarshipFeePercentage(ScholarshipFeePercentage scholarshipFeePercentage);
    
    void updateScholarshipFeePercentage(ScholarshipFeePercentage scholarshipFeePercentage);
    
    void deleteScholarshipFeePercentage(int scholarshipFeePercentageId, String writeWho);
    
    ScholarshipFeePercentage findOne(int scholarshipFeePercentageId);
    
    List<ScholarshipFeePercentage> findScholarshipFeePercentages(Map<String, Object> params);
    
    List<String> findFeeCategoriesForScholarship(int sponsorId);

    List<StudyPlanCardinalTimeUnit4Display> getAllStudyPlanCardinalTimeUnits4Display(HttpServletRequest request, String preferredLanguage, int studentId);

    SponsorInvoice findSponsorInvoiceById(int sponsorInvoiceId);
    List<SponsorInvoice> findSponsorInvoices(Map<String, Object> map);
    void addSponsorInvoice(SponsorInvoice sponsorInvoice, HttpServletRequest request);
    void updateSponsorInvoice(SponsorInvoice sponsorInvoice, HttpServletRequest request);
    int deleteSponsorInvoice(int sponsorInvoiceId, String writeWho);
    boolean doesSponsorInvoiceExist(Map<String, Object> params);

    /**
     * Increase sponsorInvoice.nrOfTimesPrinted property
     */
    void increaseSponsorInvoiceNrOfTimesPrinted(int sponsorInvoiceId, HttpServletRequest request);

    /**
     * Set the cleared flag of the sponsorInvoice depending on the payments made towards the invoice.
     * @param sponsorInvoiceId
     */
    public abstract void updateSponsorInvoiceCleared(int sponsorInvoiceId, HttpServletRequest request);

    /**
     * When a student is transferred to a new time unit, transfer the scholarship automatically, if the student is eligible for continued scholarship.
     * @param newStudyPlanCardinalTimeUnit
     * @param previousStudyPlanCardinalTimeUnit
     */
    void transferScholarship(StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit);

}
