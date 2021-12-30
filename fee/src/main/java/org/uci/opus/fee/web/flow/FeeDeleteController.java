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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;


public class FeeDeleteController {

    private static Logger log = LoggerFactory.getLogger(FeeDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private FeeManagerInterface feeManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private StudentManagerInterface studentManager;    

    
    @RequestMapping(method=RequestMethod.GET)
    public String delete(@RequestParam("feeId") int feeId,
            Fee fee, BindingResult result, HttpServletRequest request) throws Exception {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        //        StaffMember staffMember = null;
        int studyId = 0;
        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        if (!StringUtil.isNullOrEmpty(request.getParameter("feeId"))) {
            feeId = Integer.parseInt(request.getParameter("feeId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
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

        // database operation
        String view;
        if(result.hasErrors()) { 
            view = viewName;
        } else {
            // delete chosen fee:
            String writeWho = opusMethods.getWriteWho(request);
            feeManager.deleteFee(feeId, writeWho);
            feeManager.deleteStudentBalancesByFeeId(feeId, writeWho);

            view = "redirect:/fee/feesstudy.view?tab=" + tab + "&panel=" + panel 
                    + "&studyId=" + studyId
                    + "&currentPageNumber=" + currentPageNumber;
        }

        return view;
    }

    /**
     * @param securityChecker
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }


    public void setFeeManager(FeeManagerInterface feeManager) {
        this.feeManager = feeManager;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    public void validate(BindingResult result, int feeId) {
        
        // if student payments already made -> error message
        // if only student balances made: OK; they will be deleted together with the fee
        
//        List<StudentBalance> studentBalances = studentManager.findStudentBalancesByFeeId(feeId);
//        if (studentBalances != null && !studentBalances.isEmpty()) {
//            result.reject("jsp.fee.error.cannotDeleteFee", studentBalances.toArray(), "");
//        }

        Map<String,Object> params=new HashMap<String, Object>();
        params.put("feeId", feeId);

        List<Payment> payments = paymentManager.findPaymentsByParams(params);
        if (payments != null && !payments.isEmpty()) {
            result.reject("jsp.fee.error.cannotDeleteFee", payments.toArray(), "");
        }
    }
    


}
