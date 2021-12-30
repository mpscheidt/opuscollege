package org.uci.opus.unza.domain;

import java.util.Date;
/**
 * @author R.Rusinkiewicz
 *
 */
public class FinancialRequest {
	private int id;
	private String requestId;		
	private String financialRequestId;	 
	private int statusCode;		 
	private String studentCode;
	private String	requestString;	 
	private Date timestampReceived;  
	private int	requestVersion;	
	private Date timestampModified; 
	private int errorCode;
	private String	processedToFinanceTransaction;
	private String	errorReportedToFinancialSystem;
	private String errorMessage;
	private String statusMessage;
	private int academicYear;
	private int requestTypeId;
	private String requestTypeMessage;	
    private String writeWho;
	
	public final int getId() {
		return id;
	}
	public final void setId(final int id) {
		this.id = id;
	}
	public final String getRequestId() {
		return requestId;
	}
	public final void setRequestId(final String requestId) {
		this.requestId = requestId;
	}
	public final String getStudentCode() {
		return studentCode;
	}
	public final void setStudentCode(String studentCode) {
		this.studentCode = studentCode;
	}
	public final String getFinancialRequestId() {
		return financialRequestId;
	}
	public final void setFinancialRequestId(final String financialRequestId) {
		this.financialRequestId = financialRequestId;
	}
	public final int getStatusCode() {
		return statusCode;
	}
	public final void setStatusCode(final int statusCode) {
		this.statusCode = statusCode;
	}
	public final String getRequestString() {
		return requestString;
	}
	public final void setRequestString(final String requestString) {
		this.requestString = requestString;
	}
	public final Date getTimestampReceived() {
		return timestampReceived;
	}
	public final void setTimestampReceived(final Date timestampReceived) {
		this.timestampReceived = timestampReceived;
	}
	public final int getRequestVersion() {
		return requestVersion;
	}
	public final void setRequestVersion(final int requestVersion) {
		this.requestVersion = requestVersion;
	}
	public final Date getTimestampModified() {
		return timestampModified;
	}
	public final void setTimestampModified(final Date timestampModified) {
		this.timestampModified = timestampModified;
	}
	public final int getErrorCode() {
		return errorCode;
	}
	public final void setErrorCode(final int errorCode) {
		this.errorCode = errorCode;
	}
	public final String getProcessedToFinanceTransaction() {
		return processedToFinanceTransaction;
	}
	public final void setProcessedToFinanceTransaction(
			final String processedToFinanceTransaction) {
		this.processedToFinanceTransaction = processedToFinanceTransaction;
	}
	public final String getErrorReportedToFinancialSystem() {
		return errorReportedToFinancialSystem;
	}
	public final void setErrorReportedToFinancialSystem(
			final String errorReportedToFinancialSystem) {
		this.errorReportedToFinancialSystem = errorReportedToFinancialSystem;
	}
	public final String getErrorMessage() {
		return errorMessage;
	}
	public final void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public final String getStatusMessage() {
		return statusMessage;
	}
	public final void setStatusMessage(String statusMessage) {
		this.statusMessage = statusMessage;
	}
	public final int getAcademicYear() {
		return academicYear;
	}
	public final void setAcademicYear(int academicYear) {
		this.academicYear = academicYear;
	}
	public final int getRequestTypeId() {
		return requestTypeId;
	}
	public final void setRequestTypeId(int requestTypeId) {
		this.requestTypeId = requestTypeId;
	}
	public final String getRequestTypeMessage() {
		return requestTypeMessage;
	}
	public final void setRequestTypeMessage(String requestTypeMessage) {
		this.requestTypeMessage = requestTypeMessage;
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
