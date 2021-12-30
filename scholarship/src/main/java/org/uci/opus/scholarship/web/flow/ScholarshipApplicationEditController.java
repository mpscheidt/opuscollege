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
package org.uci.opus.scholarship.web.flow;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.ScholarshipStudentData;
import org.uci.opus.scholarship.domain.StudyPlanCardinalTimeUnit4Display;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.scholarship.web.form.ScholarshipApplicationForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/scholarship/scholarshipapplication.view")
@SessionAttributes({ScholarshipApplicationEditController.SCHOLARSHIPAPPLICATION_FORM})
public class ScholarshipApplicationEditController {

    public static final String SCHOLARSHIPAPPLICATION_FORM = "scholarshipApplicationForm";

    private static String formView = "scholarship/student/scholarshipapplication";
    private static Logger log = LoggerFactory.getLogger(ScholarshipApplicationEditController.class);

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private ScholarshipLookupCacher scholarshipLookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private SubjectManagerInterface subjectManager;

    public ScholarshipApplicationEditController() {
        super();
    }


    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }


    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws Exception {

        HttpSession session = request.getSession(false);  

        ScholarshipApplication scholarshipApplication = null;
        Student student = null;
        ScholarshipStudent scholarshipStudent = null;
        int scholarshipApplicationId = 0;
 
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(SCHOLARSHIPAPPLICATION_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        Locale currentLoc = RequestContextUtils.getLocale(request);

        ScholarshipApplicationForm scholarshipApplicationForm = (ScholarshipApplicationForm) model.get(SCHOLARSHIPAPPLICATION_FORM);
        if (scholarshipApplicationForm == null) {
        
            scholarshipApplicationForm = new ScholarshipApplicationForm();
            model.put(SCHOLARSHIPAPPLICATION_FORM, scholarshipApplicationForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            scholarshipApplicationForm.setNavigationSettings(navigationSettings);


            int studentId = 0;
            if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
                studentId = Integer.parseInt(request.getParameter("studentId"));
            }
            int scholarshipStudentId = 0;
            if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipStudentId"))) {
                scholarshipStudentId = Integer.parseInt(request.getParameter("scholarshipStudentId"));
            }

            if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipApplicationId"))) {
                scholarshipApplicationId = Integer.parseInt(
                        request.getParameter("scholarshipApplicationId"));
            }

            if (studentId != 0) {
                student = studentManager.findStudent(preferredLanguage, studentId);
                // scholarshipStudentId not always passed, but can be found using the studentId
                if (scholarshipStudentId == 0) {
                	ScholarshipStudent student2 = scholarshipManager.findScholarshipStudent(studentId);
                	if(student2 != null)
                		scholarshipStudentId = student2.getScholarshipStudentId();
                }
            }
//            request.setAttribute("student", student);
            scholarshipApplicationForm.setStudent(student);

            if (scholarshipStudentId != 0) {
                scholarshipStudent = scholarshipManager.findScholarshipStudent(studentId);
            } else {
                scholarshipStudent = new ScholarshipStudent(student);
                if ("Y".equals(student.getScholarship())) {
                    ScholarshipStudentData scholarshipStudentData = 
                        scholarshipManager.findScholarshipStudentData(studentId);
                    if (scholarshipStudentData != null) {
                        scholarshipStudent.setAccount(scholarshipStudentData.getAccount());
                        scholarshipStudent.setAccountActivated(
                                scholarshipStudentData.getAccountActivated());
                        scholarshipStudent.setBankId(scholarshipStudentData.getBankId());
                        scholarshipStudent.setComplaints(scholarshipStudentData.getComplaints());
                        scholarshipStudent.setScholarships(scholarshipStudentData.getScholarships());
                        scholarshipStudent.setScholarshipStudentId(
                                scholarshipStudentData.getScholarshipStudentId());
                        scholarshipStudent.setSubsidies(scholarshipStudentData.getSubsidies());
                    }
                    scholarshipManager.addScholarshipStudent(scholarshipStudent);
                    scholarshipStudentId = scholarshipStudent.getId();
                }
            }
//            request.setAttribute("scholarshipStudent", scholarshipStudent);
            scholarshipApplicationForm.setScholarshipStudent(scholarshipStudent);

            /* find the existing scholarshipApplication or create a new one */
            if (scholarshipApplicationId != 0) {
                scholarshipApplication = scholarshipManager.findScholarshipApplication(
                        scholarshipApplicationId);
            } else {
                scholarshipApplication = new ScholarshipApplication();
                scholarshipApplication.setScholarshipStudentId(scholarshipStudentId);
                scholarshipApplication.setActive("Y");
            }
            scholarshipApplicationForm.setScholarshipApplication(scholarshipApplication);

            // Lookup tables
            scholarshipLookupCacher.getScholarshipLookups(preferredLanguage, request);
            scholarshipApplicationForm.setAllScholarshipTypes(scholarshipLookupCacher.getAllScholarshipTypes());
            scholarshipApplicationForm.setAllComplaintStatuses(scholarshipLookupCacher.getAllComplaintStatuses());

            Map<String, Object> findScholarshipsMap = new HashMap<String, Object>();
            findScholarshipsMap.put("sponsorId",0);
            findScholarshipsMap.put("academicYearId",0);
            List<Scholarship> allScholarships = scholarshipManager.findAllScholarships(findScholarshipsMap);
            //            request.setAttribute("allScholarships", allScholarships);
            scholarshipApplicationForm.setAllScholarships(allScholarships);

            /* domain lookups */
            List < AcademicYear > allAcademicYears = academicYearManager.findAllAcademicYears();
//            request.setAttribute("allAcademicYears", allAcademicYears);
            scholarshipApplicationForm.setAllAcademicYears(allAcademicYears);

            List<StudyPlanCardinalTimeUnit4Display> allStudyPlanCardinalTimeUnits4Display = scholarshipManager.getAllStudyPlanCardinalTimeUnits4Display(
                    request, preferredLanguage, studentId);
            scholarshipApplicationForm.setAllStudyPlanCardinalTimeUnits4Display(allStudyPlanCardinalTimeUnits4Display);
            
            // remove doubles:
//            allStudyGradeTypes = ListUtil.removeDuplicateWithOrder(allStudyGradeTypes);
//            request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);
//            scholarshipApplicationForm.setAllStudyGradeTypes(allStudyGradeTypes);
            
//            List<AcademicYear> allUsedAcademicYears = new ArrayList<AcademicYear>();
//            if (allAcademicYears != null) {
//                for (int m = 0; m < allStudyGradeTypes.size(); m++) {
//                    for (int x = 0; x < allAcademicYears.size(); x++) {
//                        if (allAcademicYears.get(x).getId() == allStudyGradeTypes.get(m).getCurrentAcademicYearId()) {
//                            allUsedAcademicYears.add(allAcademicYears.get(x));
//                        }
//                    }
//                }
//            }
            // do not add doubles:
//            allUsedAcademicYears = ListUtil.removeDuplicateWithOrder(allUsedAcademicYears);
//            request.setAttribute("allUsedAcademicYears", allUsedAcademicYears);
//            scholarshipApplicationForm.setAllUsedAcademicYears(allUsedAcademicYears);

            

        }


//        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//            panel = Integer.parseInt(request.getParameter("panel"));
//        }
//        request.setAttribute("panel", panel);
//        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//            tab = Integer.parseInt(request.getParameter("tab"));
//        }
//        request.setAttribute("tab", tab);
//
//        if (request.getParameter("currentPageNumber") != null) {
//            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
//        }
//        request.setAttribute("currentPageNumber", currentPageNumber);

//        institutionId = OpusMethods.getInstitutionId(session, request);
//        session.setAttribute("institutionId", institutionId);
//
//        branchId = OpusMethods.getBranchId(session, request);
//        session.setAttribute("branchId", branchId);
//
//        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
//        session.setAttribute("organizationalUnitId", organizationalUnitId);

        // set the EducationTypeCode
//        String educationTypeCode = OpusMethods.getEducationTypeCode(request);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
//        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
//                session, request, educationTypeCode, institutionId
//                , branchId, organizationalUnitId);

//        if (scholarshipApplication.getSponsorPayments() != null) {
//	        for(i = 0; i < scholarshipApplication.getSponsorPayments().size(); i++){
//	        	scholarshipApplication.getSponsorPayments().get(i).setLatePayment(ScholarshipApplicationUtil.calculateLatePayment(scholarshipApplication.getSponsorPayments().get(i)));
//	        }
//        }
        
//        List <SubjectStudyGradeType> allSubjectStudyGradeTypes = new ArrayList();
//        List <SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = new ArrayList();
//        for (int k = 0; k < allStudyGradeTypes.size(); k++) {
//        	List <? extends SubjectStudyGradeType> allSubjectStudyGradeTypesForStudyGradeType = 
//        		subjectManager.findSubjectsForStudyGradeType(
//        					allStudyGradeTypes.get(k).getId());
//        	allSubjectStudyGradeTypes.addAll(allSubjectStudyGradeTypesForStudyGradeType);
//        	HashMap findMap = new HashMap();
//        	findMap.put("studyGradeTypeId", allStudyGradeTypes.get(k).getId());
//        	List <? extends SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypesForStudyGradeType = 
//        		subjectManager.findSubjectBlockStudyGradeTypes(findMap);
//        	allSubjectBlockStudyGradeTypes.addAll(allSubjectBlockStudyGradeTypesForStudyGradeType);
//        }
//        
//        request.setAttribute("allSubjectStudyGradeTypes", allSubjectStudyGradeTypes);
//        request.setAttribute("allSubjectBlockStudyGradeTypes", allSubjectBlockStudyGradeTypes);
        
        return formView;
    }


    
//    @RequestMapping(method=RequestMethod.POST, params="studyPlanChanged=true")
//    public String hostelChanged(ScholarshipApplicationForm scholarshipApplicationForm, BindingResult result, SessionStatus status, 
//            HttpServletRequest request, ModelMap model) {
//
//        int studyPlanId = scholarshipApplicationForm.getScholarshipApplication().getStudyPlanId();
//        if (studyPlanId != 0) {
//            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);
//            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlan.getStudy);
//        }
//
//        return formView;
//    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            @ModelAttribute(SCHOLARSHIPAPPLICATION_FORM) ScholarshipApplicationForm scholarshipApplicationForm,
            BindingResult result, ModelMap model)
            throws Exception {

        HttpSession session = request.getSession(false);

        NavigationSettings navigationSettings = scholarshipApplicationForm.getNavigationSettings();

        ScholarshipApplication scholarshipApplication = scholarshipApplicationForm.getScholarshipApplication();
        List <? extends StudyGradeType> studyGradeTypesForStudyPlan = null;
//        List <SponsorPayment> missingSponsorPayments = null;
//        List <SponsorPayment> sponsorPaymentsToDelete = null;        
        List < AcademicYear > allAcademicYears = academicYearManager.findAllAcademicYears();
        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
//        ServletContext context = this.getServletContext();
        Student student = null;

//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        Locale currentLoc = RequestContextUtils.getLocale(request);

        /* add or update the scholarship application */
        if (scholarshipApplication.getId() == 0) {
            scholarshipManager.addScholarshipApplication(scholarshipApplication);
        } else {
            scholarshipManager.updateScholarshipApplication(scholarshipApplication);
        }
//        studyGradeTypesForStudyPlan = studyManager.findStudyGradeTypesForStudyPlan(scholarshipApplication.getStudyPlanId());
//        validFromYear = Integer.parseInt(yearFormat.format(scholarshipApplication.getValidFrom()));
//        validUntilYear = Integer.parseInt(yearFormat.format(scholarshipApplication.getValidUntil()));        
//        missingSponsorPayments = ScholarshipApplicationUtil.findMissingSponsorPayments(scholarshipApplication, studyGradeTypesForStudyPlan, validFromYear, validUntilYear, allAcademicYears);
//        sponsorPaymentsToDelete = ScholarshipApplicationUtil.findSponsorPaymentsToDelete(scholarshipApplication, studyGradeTypesForStudyPlan, validFromYear, validUntilYear, allAcademicYears);

//        for(SponsorPayment sponsorPayment:missingSponsorPayments){
//        	scholarshipManager.addSponsorPayment(sponsorPayment);
//        }
//
//        for(SponsorPayment sponsorPayment:sponsorPaymentsToDelete){
//        	scholarshipManager.deleteSponsorPayment(sponsorPayment.getId());
//        }

        student = scholarshipManager.findStudentByScholarshipStudentId(scholarshipApplication.getScholarshipStudentId());

        return "redirect:/scholarship/scholarshipstudent.view?tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel()
                + "&studentId=" +  student.getStudentId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }


}
