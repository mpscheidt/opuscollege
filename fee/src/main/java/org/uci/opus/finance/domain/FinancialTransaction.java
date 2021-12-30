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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.finance.domain;

import java.math.BigDecimal;
import java.util.Date;
/**
 * @author R.Rusinkiewicz
 *
 */
public class FinancialTransaction {
    private int id;
    private int transactionTypeId;      
    private String  financialRequestId;     
    private String  requestId;          
    private int statusCode;         
    private int errorCode;          
    private String studentCode;      
    private String nationalRegistrationNumber;  
    private int academicYearId; 
    private Date timestampProcessed;
    private BigDecimal amount;      
    private String  name; 
    private String cell; 
    private String requestString;   
    private String processedToStudentbalance; 
    private String errorReportedToFinancialBankrequest;
    private String studentName;
    private String errorMessage;
    private String statusMessage;
    private String transactionTypeMessage;
    private String writeWho;
    
    public int getId() {
        return id;
    }
    public void setId(final int id) {
        this.id = id;
    }
    public int getTransactionTypeId() {
        return transactionTypeId;
    }
    public void setTransactionTypeId(final int transactionTypeId) {
        this.transactionTypeId = transactionTypeId;
    }
    public String getFinancialRequestId() {
        return financialRequestId;
    }
    public void setFinancialRequestId(final String financialRequestId) {
        this.financialRequestId = financialRequestId;
    }
    public String getRequestId() {
        return requestId;
    }
    public void setRequestId(final String requestId) {
        this.requestId = requestId;
    }
    public int getStatusCode() {
        return statusCode;
    }
    public void setStatusCode(final int statusCode) {
        this.statusCode = statusCode;
    }
    public int getErrorCode() {
        return errorCode;
    }
    public void setErrorCode(final int errorCode) {
        this.errorCode = errorCode;
    }
    public String getStudentCode() {
        return studentCode;
    }
    public void setStudentCode(final String studentCode) {
        this.studentCode = studentCode;
    }
    public String getNationalRegistrationNumber() {
        return nationalRegistrationNumber;
    }
    public void setNationalRegistrationNumber(
            final String nationalRegistrationNumber) {
        this.nationalRegistrationNumber = nationalRegistrationNumber;
    }
    public int getAcademicYearId() {
        return academicYearId;
    }
    public void setAcademicYearId(final int academicYearId) {
         this.academicYearId = academicYearId;
    }
    public Date getTimestampProcessed() {
        return timestampProcessed;
    }
    public void setTimestampProcessed(final Date timestampProcessed) {
        this.timestampProcessed = timestampProcessed;
    }
    public BigDecimal getAmount() {
        return amount;
    }
    public void setAmount(final BigDecimal amount) {
        this.amount = amount;
    }
    public String getName() {
        return name;
    }
    public void setName(final String name) {
        this.name = name;
    }
    public String getCell() {
        return cell;
    }
    public void setCell(final String cell) {
        this.cell = cell;
    }
    public String getRequestString() {
        return requestString;
    }
    public void setRequestString(final String requestString) {
        this.requestString = requestString;
    }
    public String getProcessedToStudentbalance() {
        return processedToStudentbalance;
    }
    public void setProcessedToStudentbalance(final String processedToStudentbalance) {
        this.processedToStudentbalance = processedToStudentbalance;
    }
    public String getErrorReportedToFinancialBankrequest() {
        return errorReportedToFinancialBankrequest;
    }
    public void setErrorReportedToFinancialBankrequest(
            final String errorReportedToFinancialBankrequest) {
        this.errorReportedToFinancialBankrequest = errorReportedToFinancialBankrequest;
    } 
    public String getStudentName() {
        return studentName;
    }
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    public String getErrorMessage() {
        return errorMessage;
    }
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    public String getStatusMessage() {
        return statusMessage;
    }
    public void setStatusMessage(String statusMessage) {
        this.statusMessage = statusMessage;
    }
    public String getTransactionTypeMessage() {
        return transactionTypeMessage;
    }
    public void setTransactionTypeMessage(String transactionTypeMessage) {
        this.transactionTypeMessage = transactionTypeMessage;
    }
    /**
     * @return the writeWho
     */
    public String getWriteWho() {
        return writeWho;
    }
    /**
     * @param writeWho the writeWho to set
     */
    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }
    
}
