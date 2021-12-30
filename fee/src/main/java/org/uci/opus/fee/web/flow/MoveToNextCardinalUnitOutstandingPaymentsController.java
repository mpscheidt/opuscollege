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

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManager;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.fee.util.PaymentUtil;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;


/**
 * Servlet implementation class for Servlet: ContractDeleteController.
 *
 */
public class MoveToNextCardinalUnitOutstandingPaymentsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(MoveToNextCardinalUnitOutstandingPaymentsController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    @Autowired private FeeManager feeManager;    
    @Autowired private PaymentManagerInterface paymentManager; 
    @Autowired private StudentManagerInterface studentManager; 
    @Autowired private MessageSource messageSource; 
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private PaymentUtil paymentUtil;
    @Autowired private OpusMethods opusMethods;
    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public MoveToNextCardinalUnitOutstandingPaymentsController() {
        super();
    }

    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        
 
        int studyGradeTypeId = 0;
        int academicYearId = 0;
        int studentId = 0;
        int feeType = 0;
        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;
        String showPaymentError = "";
 
        List < ? extends Fee > studentFeesToLoad = null;
         
        List < ? extends Payment > allPaymentsForStudent = null;
        List < ? extends StudentBalance > allStudentBalances = null;
        List < Payment > paymentsToPayForNextCardinalUnit = null;
//        List < Payment > rejectedPaymentsByInstallmentNumber = null;
        List < Payment > rejectedPaymentsByCardinalUnit = null;
        List <AcademicYear> allAcademicYears = null;
        String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");
		    
        
		HashMap<String,List<Payment>> allPaymentsToPayForNextCardinalUnit = new HashMap<String,List<Payment>>();
		Locale currentLoc = RequestContextUtils.getLocale(request);
		
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
            studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("academicYearId"))) {
            academicYearId = Integer.parseInt(request.getParameter("academicYearId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);
 
        allStudentBalances = feeManager.findStudentBalances(studentId);
        
        allPaymentsForStudent = paymentManager.findPaymentsForStudent(studentId);
        
        allAcademicYears = academicYearManager.findAllAcademicYears();
        
        if(!StringUtil.isNullOrEmpty(request.getParameter("feeType"))){
        	feeType= Integer.parseInt(request.getParameter("feeType")); 
        }
        if(feeType==1){
        	studentFeesToLoad=feeManager.findStudentFeesForSubjectBlockStudyGradeTypes(studentId);
        	allPaymentsToPayForNextCardinalUnit=paymentUtil.createSubjectBlockStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(studentFeesToLoad, allPaymentsForStudent, allStudentBalances, studyGradeTypeId, iUseOfPartTimeStudyGradeTypes);
        }
        else if(feeType==2){
        	studentFeesToLoad=feeManager.findStudentFeesForSubjectStudyGradeTypes(studentId);
         	allPaymentsToPayForNextCardinalUnit=paymentUtil.createSubjectStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(studentFeesToLoad, allPaymentsForStudent, allStudentBalances, studyGradeTypeId, iUseOfPartTimeStudyGradeTypes);        	
        }
        // UNZA
        else if(feeType==3){
        	studentFeesToLoad=feeManager.findStudentFeesForStudyGradeTypes(studentId);
         	allPaymentsToPayForNextCardinalUnit=paymentUtil.createStudyGradeTypesOutstandingPaymentsForNextCardinalUnit(studentFeesToLoad, allPaymentsForStudent, allStudentBalances, studyGradeTypeId, iUseOfPartTimeStudyGradeTypes);
        }
        // UNZA
        else if(feeType==4){
        	studentFeesToLoad=feeManager.findStudentFeesForAcademicYears(studentId);
            allPaymentsToPayForNextCardinalUnit=PaymentUtil.createAcademicYearOutstandingPaymentsForNextCardinalUnit(studentFeesToLoad,allPaymentsForStudent,allStudentBalances,allAcademicYears,academicYearId);
        }
   

        paymentsToPayForNextCardinalUnit=allPaymentsToPayForNextCardinalUnit.get("approevedPayments");
//        rejectedPaymentsByInstallmentNumber=allPaymentsToPayForNextCardinalUnit.get("rejectedPaymentsByInstallmentNumber");
        rejectedPaymentsByCardinalUnit=allPaymentsToPayForNextCardinalUnit.get("rejectedPaymentsByFeeNotFound");

        for(Payment payment:paymentsToPayForNextCardinalUnit){
        	paymentManager.addPayment(payment, opusMethods.getWriteWho(request));
        }
//        for(Payment payment:rejectedPaymentsByInstallmentNumber){
//        	showPaymentError = showPaymentError+ payment.getFeeId()+ " "+messageSource.getMessage("jsp.general.payments.toomuch"
//                    , null, currentLoc)+"; ";
//        }        
        for(Payment payment:rejectedPaymentsByCardinalUnit){
        	showPaymentError = showPaymentError+ payment.getFeeId()+ " "+messageSource.getMessage("jsp.general.payments.cardinalunitnotfound"
                    , null, currentLoc)+"; ";
        }          
        this.setViewName("redirect:/fee/paymentsstudent.view?tab=" + tab + "&panel=" + panel 
                + "&studentId=" + studentId
                + "&showPaymentError=" + showPaymentError
                + "&currentPageNumber=" + currentPageNumber);

        return new ModelAndView(viewName);
    }

    /**
     * @param securityChecker
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

}
