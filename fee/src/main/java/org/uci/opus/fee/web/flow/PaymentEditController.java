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

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.fee.validators.PaymentValidator;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

/*
 * ATTENTION: This controller needs a ComplaintForm.
 * 
 * It has been migrated away from a SimpleFormController and works only when
 * as long as no validation errors occur, otherwise data on request (such as allXyz) is not set.
 * 
 */

@Controller
@RequestMapping("/fee/payment")
@SessionAttributes({ PaymentEditController.FORM_OBJECT })
public class PaymentEditController {

    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "fee/payment/payment";

    private static Logger log = LoggerFactory.getLogger(PaymentEditController.class);

    private PaymentValidator validator = new PaymentValidator();

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private PaymentManagerInterface paymentManager;

    @Autowired
    private SubjectManagerInterface subjectManager;

    @Autowired
    private FeeManagerInterface feeManager;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    
    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public PaymentEditController() {
        super();
    }

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        Student student = null;
        Payment payment = null;
        Fee fee = null;

        // StudyYear studyYear = null;
        Subject subject = null;
        SubjectBlock subjectBlock = null;
        AcademicYear academicYear = null;
        int studentId = 0;
        int feeId = 0;
        int paymentId = 0;

        int studyPlanDetailId = 0;
        int studentBalanceId = 0;
        int installmentNumber = 0;
        StudyPlanDetail studyPlanDetail = null;
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;
        int currentPageNumber = 0;
        int organizationalUnitId = 0;
        int studyPlanCardinalTimeUnitId = 0;
        int academicYearId = 0;
        StudyPlan studyPlan = null;
        AdmissionRegistrationConfig admissionRegistrationConfig = null;
        Date startOfRefundPeriod = null;
        Date endOfRefundPeriod = null;
        double feeDue = 0.0;

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("feeId"))) {
            feeId = Integer.parseInt(request.getParameter("feeId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentBalanceId"))) {
            studentBalanceId = Integer.parseInt(request.getParameter("studentBalanceId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("paymentId"))) {
            paymentId = Integer.parseInt(request.getParameter("paymentId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("studyPlanDetailId"))) {
            studyPlanDetailId = Integer.parseInt(request.getParameter("studyPlanDetailId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyPlanCardinalTimeUnitId"))) {
            studyPlanCardinalTimeUnitId = Integer.parseInt(request.getParameter("studyPlanCardinalTimeUnitId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("feeDue"))) {
            feeDue = Double.parseDouble(request.getParameter("feeDue"));
        }
        request.setAttribute("feeDue", feeDue);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);
        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);

        // STUDENT
        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        request.setAttribute("student", student);

        // FEE
        if (feeId != 0) {
            fee = feeManager.findFee(feeId);
        }
        request.setAttribute("fee", fee);

        // STUDYPLANDETAIL
        if (studyPlanDetailId != 0) {
            studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
            studyPlan = studentManager.findStudyPlan(studyPlanDetail.getStudyPlanId());
        }
        if (studyPlanCardinalTimeUnitId != 0) {
            studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
            studyPlan = studentManager.findStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());
        }
        request.setAttribute("studyPlanDetail", studyPlanDetail);
        request.setAttribute("studyPlan", studyPlan);

        // EXISTING OR NEW PAYMENT
        if (paymentId != 0) {
            payment = paymentManager.findPayment(paymentId);
        } else {
            payment = new Payment();
            payment.setPayDate(new Date());
            /* use first found studyplan detail */
            payment.setStudentId(studentId);
            payment.setStudentBalanceId(studentBalanceId);
            payment.setFeeId(feeId);
            List<? extends StudentBalance> allStudentBalances = feeManager.findStudentBalances(studentId);

            List<? extends Payment> allStudentPayments = paymentManager.findPaymentsForStudent(studentId);
            installmentNumber = BankInterfaceUtils.getNextPaymentInstallmentNumber(allStudentPayments, allStudentBalances, feeId);
            payment.setInstallmentNumber(installmentNumber);

            payment.setSumPaid(BigDecimal.valueOf(0.00));
            payment.setActive("Y");
        }

        /* domain-attributes */
        // if (studyPlanDetail != null && studyPlanDetail.getStudyYearId() != 0) {
        // studyYear = studyManager.findStudyYear(studyPlanDetail.getStudyYearId());
        // }
        // request.setAttribute("studyYear", studyYear);
        if (fee.getAcademicYearId() != 0) {
            academicYear = studyManager.findAcademicYear(fee.getAcademicYearId());
            academicYearId = fee.getAcademicYearId();
        } else if (studyPlanDetailId != 0) {
            academicYearId = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId()).getCurrentAcademicYearId();
        } else if (studyPlanCardinalTimeUnitId != 0) {
            academicYearId = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId()).getCurrentAcademicYearId();
        }
        request.setAttribute("academicYear", academicYear);
        admissionRegistrationConfig = organizationalUnitManager.findAdmissionRegistrationConfig(organizationalUnitId, academicYearId, true);
        if (admissionRegistrationConfig != null) {
            startOfRefundPeriod = admissionRegistrationConfig.getStartOfRefundPeriod();
            endOfRefundPeriod = admissionRegistrationConfig.getEndOfRefundPeriod();
        }
        request.setAttribute("startOfRefundPeriodTime", startOfRefundPeriod != null ? startOfRefundPeriod.getTime() : 0);
        request.setAttribute("endOfRefundPeriodTime", endOfRefundPeriod != null ? endOfRefundPeriod.getTime() : 0);

        if (studyPlanDetail != null && studyPlanDetail.getSubjectBlockId() != 0 && fee.getSubjectBlockStudyGradeTypeId() != 0) {
            subjectBlock = subjectBlockMapper.findSubjectBlock(studyPlanDetail.getSubjectBlockId());
        }
        request.setAttribute("subjectBlock", subjectBlock);
        if (studyPlanDetail != null && studyPlanDetail.getSubjectId() != 0 && fee.getSubjectStudyGradeTypeId() != 0) {
            subject = subjectManager.findSubject(studyPlanDetail.getSubjectId());
        }
        request.setAttribute("subject", subject);

        model.put(FORM_OBJECT, payment);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) Payment payment, BindingResult result) {

        validator.validate(payment, result);
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int studentId = 0;
        int tab = 0;
        int panel = 0;
        String showPaymentError = "";
        int currentPageNumber = 0;

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_payment"))) {
            panel = Integer.parseInt(request.getParameter("panel_payment"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_payment"))) {
            tab = Integer.parseInt(request.getParameter("tab_payment"));
        }
        request.setAttribute("tab", tab);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        String writeWho = opusMethods.getWriteWho(request);

        if (payment.getId() == 0) {
            // NEW PAYMENT
            // always add the new payment (more payments per fee possible)
            log.info("adding " + payment);
            paymentManager.addPayment(payment, writeWho);

        } else {
            // UPDATE PAYMENT
            log.info("updating " + payment);
            payment.setWriteWho(opusMethods.getWriteWho(request));
            paymentManager.updatePayment(payment, writeWho);
        }
        
        String view;
        if (!"".equals(showPaymentError)) {
            view = "redirect:/fee/paymentsstudent.view?tab=" + tab + "&panel=" + panel + "&studentId=" + studentId + "&showPaymentError=" + showPaymentError
                    + "&currentPageNumber=" + currentPageNumber;
        } else {
            view ="redirect:/fee/paymentsstudent.view?tab=" + tab + "&panel=" + panel + "&studentId=" + studentId + "&currentPageNumber=" + currentPageNumber;
        }
        return view;
    }

}
