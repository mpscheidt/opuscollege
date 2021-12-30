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
package org.uci.opus.finance.service;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.persistence.FinancialTransactionMapper;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.util.OpusMethods;

/**
 * @author R.Rusinkiewicz
 *
 */
public class FinancialTransactionManager implements FinancialTransactionManagerInterface {

    private static Logger log = LoggerFactory.getLogger(FinancialTransactionManager.class);

    @Autowired
    private FinancialTransactionMapper financialTransactionMapper;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private BankInterfaceUtils bankInterfaceUtils;

    @Autowired
    private FeeManagerInterface feeManager;

    @Autowired
    private OpusMethods opusMethods;

    public FinancialTransaction findFinancialTransaction(final String financialRequestId) {
        return financialTransactionMapper.findFinancialTransaction(financialRequestId);
    }

    public List<FinancialTransaction> findFinancialTransactions() {
        return financialTransactionMapper.findFinancialTransactions();
    }

    public List<FinancialTransaction> findFinancialTransactionsByStudentId(int studentId) {
        return financialTransactionMapper.findFinancialTransactionsByStudentId(studentId);
    }

    public void addFinancialTransaction(final FinancialTransaction financialTransaction) {
        financialTransactionMapper.addFinancialTransaction(financialTransaction);
        financialTransactionMapper.addFinancialTransactionHistory(financialTransaction);
    }

    public void updateFinancialTransaction(final FinancialTransaction financialTransaction) {
        financialTransactionMapper.updateFinancialTransaction(financialTransaction);
        financialTransactionMapper.updateFinancialTransactionHistory(financialTransaction);
    }

    public int processPostTransactionRequest(HttpServletRequest request) {
        int errorCode = BankInterfaceUtils.NO_ERR;
        int statusCode = BankInterfaceUtils.STATUS_OK;
        String studentCode = request.getParameter("StudentID");
        Date currentDate = new Date();
        Date date = null;
        String cell = null;
        String requestString = request.getQueryString();
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
        Calendar calendar = Calendar.getInstance();
        String year = null;
        try {
            date = dateFormat.parse(request.getParameter("Date"));
            calendar.setTime(date);
            year = new Integer(calendar.get(Calendar.YEAR)).toString();

        } catch (ParseException e) {
            errorCode = BankInterfaceUtils.ERR_GENERAL_FAILURE;
        }
        String financialRequestId = request.getParameter("TranID");
        String requestId = request.getParameter("RequestId");
        String name = request.getParameter("Name");
        String nationalRegistrationNumber = request.getParameter("NRC");
        BigDecimal amount = BigDecimal.valueOf(Double.parseDouble(request.getParameter("Amount")));
        List<AcademicYear> academicYears = null;

        FinancialTransaction financialTransaction = null;
        List<StudentBalance> studentBalances = null;
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Student student = studentManager.findStudentByCode(studentCode);

        if (student != null) {
            studentBalances = feeManager.findStudentBalances(student.getStudentId());
            if (studentBalances == null || (studentBalances != null && studentBalances.size() == 0)) {
                errorCode = BankInterfaceUtils.ERR_MISSING_SFEES;
            }
        } else {
            errorCode = BankInterfaceUtils.ERR_STUDENT_NOT_EXIST;
        }
        if (errorCode == BankInterfaceUtils.NO_ERR) {
            statusCode = BankInterfaceUtils.STATUS_OK;
        } else {
            statusCode = BankInterfaceUtils.STATUS_ERROR_OPUS;
        }
        financialTransaction = new FinancialTransaction();
        academicYears = academicYearManager.findAcademicYears(year);
        for (AcademicYear academicYear : academicYears) {
            if (academicYear.getDescription().equals(year)) {
                financialTransaction.setAcademicYearId(academicYear.getId());
                break;
            }
        }
        financialTransaction.setAmount(amount);
        financialTransaction.setErrorCode(errorCode);
        // ? financialTransaction.setCell(cell);
        financialTransaction.setErrorReportedToFinancialBankrequest("N");
        financialTransaction.setFinancialRequestId(financialRequestId);
        financialTransaction.setName(name);
        financialTransaction.setNationalRegistrationNumber(nationalRegistrationNumber);
        financialTransaction.setProcessedToStudentbalance("N");
        financialTransaction.setRequestId(requestId);
        financialTransaction.setRequestString(requestString);
        financialTransaction.setStatusCode(statusCode);
        financialTransaction.setStudentCode(studentCode);
        financialTransaction.setTimestampProcessed(currentDate);
        financialTransaction.setTransactionTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);
        financialTransaction.setErrorReportedToFinancialBankrequest("N");
        financialTransaction.setWriteWho("opus_financial_transaction");

        addFinancialTransaction(financialTransaction);
        // processing to studentBalance done automatically if no errors
        if (errorCode == BankInterfaceUtils.NO_ERR) {
            bankInterfaceUtils.processToStudentBalance(new String[] { financialRequestId }, opusMethods.getWriteWho(request));
        }
        return errorCode;
    }

    public int processReverseTransactionRequest(HttpServletRequest request) {
        int errorCode = BankInterfaceUtils.NO_ERR;
        String financialRequestId = request.getParameter("TranID");
        double amount = Double.parseDouble(request.getParameter("Amount"));
        FinancialTransaction financialTransaction = findFinancialTransaction(financialRequestId);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String studentCode = request.getParameter("StudentID");
        Student student = studentManager.findStudentByCode(studentCode);

        if (student == null) {
            errorCode = BankInterfaceUtils.ERR_STUDENT_NOT_EXIST;
        } else if (financialTransaction == null) {
            errorCode = BankInterfaceUtils.ERR_TRANS_NOT_FOUND;
        } else {
            financialTransaction.setAmount(BigDecimal.valueOf((financialTransaction.getAmount().doubleValue() - amount)));
            financialTransaction.setTransactionTypeId(BankInterfaceUtils.REVERSE_TRANSACTION_TYPE_REQUEST);
            updateFinancialTransaction(financialTransaction);
        }
        return errorCode;
    }

    public List<FinancialTransaction> findFinancialTransactionsBySelection(Map selection) {
        return financialTransactionMapper.findFinancialTransactionsBySelection(selection);
    }

}
