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
 * The Original Code is Opus-College fee module code.
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
package org.uci.opus.fee.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

public class PaymentsStudentController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(PaymentsStudentController.class);
    private String viewName;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private AcademicYearManagerInterface academicYearManager; 
    @Autowired private BankInterfaceUtils bankInterfaceUtils;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public PaymentsStudentController() {
        super();
    }

    /** 
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *                              , javax.servlet.http.HttpServletResponse)
     */
    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        

        Student student = null;
        Study primaryStudy = null;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int studentId;
        int personId;

        String educationTypeCode = "";
        int currentPageNumber = 0;
        String showPaymentError = "";

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        studentId = ServletUtil.getIntParam(request, "studentId", 0);
        personId = ServletUtil.getIntParam(request, "personId", 0);

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        educationTypeCode = OpusMethods.getInstitutionTypeCode(request);
        if (StringUtil.isNullOrEmpty(educationTypeCode, true)) {
            educationTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        }

        // reset showPaymentError:
        if (!StringUtil.isNullOrEmpty(request.getParameter("showPaymentError"))) {
            showPaymentError = request.getParameter("showPaymentError");
            request.setAttribute("showPaymentError", showPaymentError);
        } else {
            request.setAttribute("showPaymentError", null);
        }

        // STUDENT SHOULD ALWAYS EXIST
        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        } else if (personId != 0) {
            student = studentManager.findStudentByPersonId(personId);
            studentId = student.getStudentId();
        }
        request.setAttribute("student", student);

        if (student.getPrimaryStudyId() != 0) {
            primaryStudy = studyManager.findStudy(student.getPrimaryStudyId());
        }
        request.setAttribute("primaryStudy",primaryStudy);

        if (primaryStudy != null) {
            organizationalUnitId = primaryStudy.getOrganizationalUnitId();
            session.setAttribute("organizationalUnitId", organizationalUnitId);
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, educationTypeCode, institutionId
                , branchId, organizationalUnitId);

        /* domain-attributes  */
        List < ? extends Study > allStudies = null;
        allStudies = studyManager.findAllStudies();
        request.setAttribute("allStudies", allStudies);
        
        // TODO: temporary for test purposes; needs to be removed
        List < ? extends Payment > allPaymentsForStudent = null;
        allPaymentsForStudent = paymentManager.findPaymentsForStudent(studentId);
        request.setAttribute("allPaymentsForStudent", allPaymentsForStudent);

        request.setAttribute("allFeeCategories",lookupManager.findAllRows(preferredLanguage, "fee_feeCategory"));
        
        List < AppliedFee > allAppliedFees = feeManager.getAppliedFeesForStudent(student, preferredLanguage);
        request.setAttribute("allAppliedFees", allAppliedFees);
        
        int totalNoAppliedFees = allAppliedFees.size();
        request.setAttribute("totalNoAppliedFees", totalNoAppliedFees);
     
        return new ModelAndView(viewName); 
    }

    /**
     * @param viewName name of view to show; is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

}
