/*
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
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
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
*/

package org.uci.opus.finance.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/finance/studentFinancialTransactions")
public class StudentFinancialTransactionsController {

    private static final String FORM_VIEW = "fee/finance/studentFinancialTransactions";

    @Autowired
    private FinancialTransactionManager financialTransactionManager;
    @Autowired
    private SecurityChecker securityChecker;
    @Autowired
    private OpusMethods opusMethods;
    @Autowired
    private AcademicYearManagerInterface academicYearManager;
    @Autowired
    private StudentManagerInterface studentManager;
    @Autowired
    private PersonManagerInterface personManager;
    @Autowired
    private BankInterfaceUtils bankInterfaceUtils;

    public StudentFinancialTransactionsController() {
        super();
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        int currentPageNumber = 1;
        int studentId = 0;
        Student student = null;
        String studentCode = null;
        Person person = null;
        String studentName = null;
        String NRC = null;
        if (request.getParameter("studentCode") != null) {
            studentCode = request.getParameter("studentCode");
        }
        student = studentManager.findStudentByCode(studentCode);
        if (student != null) {
            studentId = student.getStudentId();
        }
        List<FinancialTransaction> allFinancialTransactions = financialTransactionManager.findFinancialTransactionsByStudentId(studentId);
        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        HttpSession session = request.getSession(false);
        person = personManager.findPersonById(studentManager.findPersonId(studentId));
        if (person != null) {
            studentName = person.getSurnameFull();
            NRC = person.getNationalRegistrationNumber();
        }
        for (int i = 0; i < allFinancialTransactions.size(); i++) {
            allFinancialTransactions.get(i).setErrorMessage(BankInterfaceUtils.getErrorMessage(allFinancialTransactions.get(i).getErrorCode()));
            allFinancialTransactions.get(i).setStatusMessage(BankInterfaceUtils.getStatusMessage(allFinancialTransactions.get(i).getStatusCode()));
            allFinancialTransactions.get(i).setTransactionTypeMessage(BankInterfaceUtils.getTypeMessage(allFinancialTransactions.get(i).getTransactionTypeId()));
        }
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if a subject is linked to a result, it can not be deleted; this attribute is
        // used to show an error message.
        request.setAttribute("showError", request.getParameter("showError"));

        request.setAttribute("currentPageNumber", currentPageNumber);
        request.setAttribute("allFinancialTransactions", allFinancialTransactions);
        request.setAttribute("allAcademicYears", allAcademicYears);
        request.setAttribute("studentName", studentName);
        request.setAttribute("NRC", NRC);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request) {

        String[] requestIds = request.getParameterValues("financialTransactionId");
        String processedToStudentBalance = request.getParameter("progressToStudentBalance");
        String studentId = request.getParameter("studentId");

        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_fee"))) {
            panel = Integer.parseInt(request.getParameter("panel_fee"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_fee"))) {
            tab = Integer.parseInt(request.getParameter("tab_fee"));
        }
        request.setAttribute("tab", tab);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (processedToStudentBalance.equals("on")) {
            bankInterfaceUtils.processToStudentBalance(requestIds, opusMethods.getWriteWho(request));
        }

        return "redirect:/finance/studentFinancialTransactions.view?tab=" + tab + "&panel=" + panel + "&studentId=" + studentId + "&currentPageNumber=" + currentPageNumber;
    }

}
