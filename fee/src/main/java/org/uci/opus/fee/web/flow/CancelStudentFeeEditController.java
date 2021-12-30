package org.uci.opus.fee.web.flow;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.web.form.CancelStudentFeeForm;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;


/* When a student has withdrawn with permission, the fees might be cancelled. This is resolved by adding
 * a cancellation fee, which is the exact amount as the fees to be paid, but negative.
 */
@Controller
@RequestMapping("/fee/cancelstudentfee.view")
@SessionAttributes("cancelStudentFeeForm")
public class CancelStudentFeeEditController {
    
    private static Logger log = LoggerFactory.getLogger(CancelStudentFeeEditController.class);
    @Autowired SecurityChecker securityChecker;
    @Autowired OpusMethods opusMethods;
    @Autowired StudentManagerInterface studentManager;
    @Autowired FeeManagerInterface feeManager;
    
    private String formView;
    
    public CancelStudentFeeEditController() {
        super();
        this.formView = "fee/fee/cancelstudentfee";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            throws Exception {
    
        if (log.isDebugEnabled()) {
            log.debug("CancelStudentFeeEditController.setUpForm entered...");
        }
        CancelStudentFeeForm cancelStudentFeeForm = new CancelStudentFeeForm();
        NavigationSettings navigationSettings = new NavigationSettings();      
        
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int latestStudyPlanCtuId = 0;
        int cancellationFeeId = 0;
        int balanceBFwdFeeId = 0;

        // used in crumbs path
        Student student = null;
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        String writeWho = opusMethods.getWriteWho(request);
        
        if (StringUtil.isEmpty(writeWho, true)) {
            writeWho = "anonymous";
        }
        
        cancelStudentFeeForm.setWriteWho(writeWho);
       
        // studentId should always exist
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
            student = studentManager.findStudent(preferredLanguage, studentId);
            cancelStudentFeeForm.setStudent(student);
            
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            cancelStudentFeeForm.setNavigationSettings(navigationSettings);
            
            // get the FeeId of the feeCategory Fee Cancellation
            cancellationFeeId = feeManager.findFeeIdByCategoryCode(
                                    FeeConstants.FEE_CANCELLATION_CAT, preferredLanguage);
            
            // get the feeId of the balanceBFwd, since this should always be paid,
            // so should not be counted/considered for the cancellation fee
            balanceBFwdFeeId = feeManager.findFeeIdByCategoryCode(
                    FeeConstants.BALANCE_BROUGHT_FORWARD_CAT, preferredLanguage);

            // get the list of allAppliedFees
            List <AppliedFee> allAppliedFees = feeManager.getAppliedFeesForStudent(
                                                            student, preferredLanguage);
            /* this list is ordered descending by academicYear and ctuNumber, so the studyPanCtuId
            of the first appliedFee is the id of the latest studyPlanCtu of this student */
            if (!ListUtil.isNullOrEmpty(allAppliedFees)) {
                latestStudyPlanCtuId = allAppliedFees.get(0).getStudyPlanCardinalTimeUnitId();
            }
            
            // create the studentBalance for the FeeCancellation
            StudentBalance studentBalance = new StudentBalance(studentId, cancellationFeeId
                                                                            , "N", writeWho);
            studentBalance.setStudyPlanCardinalTimeUnitId(latestStudyPlanCtuId);

            BigDecimal cancellationAmount = new BigDecimal(0.00);
            // Then from this, just select the ones with the correct studyPlanCtu
            for (AppliedFee appliedFee : allAppliedFees) {
                if (appliedFee.getStudyPlanCardinalTimeUnitId() == latestStudyPlanCtuId
                        && appliedFee.getFee().getId() != balanceBFwdFeeId
                        ) {
                    cancellationAmount = cancellationAmount.add(appliedFee.getFee().getFeeDue());
                }
            }
            cancellationAmount = cancellationAmount.negate();
            studentBalance.setAmount(cancellationAmount);
            cancelStudentFeeForm.setStudentBalance(studentBalance);
        } else {
            cancelStudentFeeForm.setTxtError("error studentId does not exist");
            model.addAttribute("cancelStudentFeeForm", cancelStudentFeeForm);    
            return formView;
        }

        model.addAttribute("cancelStudentFeeForm", cancelStudentFeeForm);        
        return formView;
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("cancelStudentFeeForm") CancelStudentFeeForm cancelStudentFeeForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

        NavigationSettings navigationSettings = cancelStudentFeeForm.getNavigationSettings();
        StudentBalance studentBalance = cancelStudentFeeForm.getStudentBalance();
        int studentId = cancelStudentFeeForm.getStudent().getStudentId();
        
        // if the amount entered is not 0 then add the studentBalance
        if (studentBalance.getAmount().compareTo(new BigDecimal(0.00)) != 0) {
            feeManager.addStudentBalance(studentBalance);
        } else {
            cancelStudentFeeForm.setTxtError("error amount is 0, not inserted");
        }
        return "redirect:/fee/paymentsstudent.view?tab=" + navigationSettings.getTab()
                + "&studentId=" + studentId
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&panel=" + navigationSettings.getPanel()
                + "&txtMsg=" + cancelStudentFeeForm.getTxtMsg();
    }
    
}
