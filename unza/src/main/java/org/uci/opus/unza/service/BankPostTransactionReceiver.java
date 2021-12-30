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
package org.uci.opus.unza.service;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.HttpRequestHandler;
import org.uci.opus.college.service.GeneralManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.unza.domain.FinancialRequest;
import org.uci.opus.unza.util.BankInterfaceUnzaUtils;
import org.uci.opus.util.OpusMethods;
/**
 * @author R.Rusinkiewicz
 *
 */
public class BankPostTransactionReceiver implements HttpRequestHandler{
    private static Logger log = Logger.getLogger(BankPostTransactionReceiver.class);
    @Autowired private UnzaManager unzaManager; 
    @Autowired private FinancialTransactionManager financialTransactionManager; 
    @Autowired private BankInterfaceUnzaUtils bankInterfaceUnzaUtils;
    @Autowired private OpusMethods opusMethods;
    @Autowired private GeneralManagerInterface generalManager;
    /**
     * This method has to be implemented by HttPRequestHandler and is a wrapper method of
     * doGet or doPost methods of java HttpServlet class. By using Spring
     * HttPRequestHandler it is possible to access Spring application context.
     * This method process incoming BankPost Http requests.
      */
    public void handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException{
		log.info("Running the [Strange] ZANACO => BankTransactionReceiver [endpoint] [BankPostTransactionReceiver].....");
        if(!bankInterfaceUnzaUtils.verifyRequestAddress(request)){
        	log.info("[remote host]..."+request.getRemoteAddr());//get the remote address before processing
        	generalManager.logRequestError(request.getRemoteAddr(), request.getQueryString(), BankInterfaceUnzaUtils.UNAUTHORIZED_ACCESS);
        	return;
        }
        log.info("The request is valid [remote host]..."+request.getRemoteAddr());//if this prints out then the whitelist is passed
    	String queryString = request.getQueryString();
		String studentCode = null;
		int statusCode = BankInterfaceUtils.STATUS_OK;
		int errorCode = validateRequest(request);
		if (errorCode != BankInterfaceUtils.NO_ERR){
			statusCode = BankInterfaceUtils.STATUS_ERROR_INTERFACE;
		}
		int highestRequestVersion = 0;
		FinancialRequest oldFinancialRequest = null;
		FinancialRequest newFinancialRequest = null;
		FinancialTransaction oldFinancialTransaction = null;

		String financialRequestId = null;
		String requestId = null;
		boolean requestExist = false;
		boolean requestProcessedToFinance = false;
		boolean transactionProcessedToStudentBalance = false;
		Date currentDate = new Date();

		if (request.getParameter("TranID")!= null){
			financialRequestId = request.getParameter("TranID");
		}
		
		if (request.getParameter("RequestId")!= null){
			requestId = request.getParameter("RequestId");
		}
		if (request.getParameter("StudentID")!= null){
			studentCode = request.getParameter("StudentID");
		}
		
		if (financialRequestId != null){
			oldFinancialRequest = unzaManager.findFinancialRequest(financialRequestId);
			highestRequestVersion = unzaManager.findHighestFinancialRequestVersion(financialRequestId);
			if (oldFinancialRequest != null){
				requestExist = true;
				if ((oldFinancialTransaction = financialTransactionManager.findFinancialTransaction(financialRequestId))!=null || "Y".equals(oldFinancialRequest.getProcessedToFinanceTransaction()) ){
					requestProcessedToFinance = true;
					if (oldFinancialTransaction != null){
						if("Y".equals(oldFinancialTransaction.getProcessedToStudentbalance())){
					   		transactionProcessedToStudentBalance = true;
					 	}
					 }
				
				}
			}
		}
		if (errorCode == BankInterfaceUtils.NO_ERR){
			if (transactionProcessedToStudentBalance){
				newFinancialRequest = new FinancialRequest();
				newFinancialRequest.setErrorCode(errorCode);
				newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_IGNORED);
				newFinancialRequest.setErrorReportedToFinancialSystem("N");
				newFinancialRequest.setFinancialRequestId(financialRequestId);
				newFinancialRequest.setRequestId(requestId);
				newFinancialRequest.setRequestString(queryString);
				newFinancialRequest.setRequestVersion(highestRequestVersion+1);
				newFinancialRequest.setTimestampReceived(currentDate);
				newFinancialRequest.setProcessedToFinanceTransaction("N");
				newFinancialRequest.setRequestTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);
				newFinancialRequest.setStudentCode(studentCode);
				newFinancialRequest.setWriteWho("unza_bankrequest");

				unzaManager.addFinancialRequest(newFinancialRequest);
				statusCode = BankInterfaceUtils.STATUS_ERROR_IGNORED;
			}
			else if (requestProcessedToFinance){
				oldFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_IGNORED);
				oldFinancialRequest.setTimestampModified(currentDate);

				oldFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.updateFinancialRequest(oldFinancialRequest);
				newFinancialRequest = new FinancialRequest();
				newFinancialRequest.setErrorCode(errorCode);
				newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_OK);
				newFinancialRequest.setErrorReportedToFinancialSystem("N");
				newFinancialRequest.setFinancialRequestId(financialRequestId);
				newFinancialRequest.setRequestId(requestId);
				newFinancialRequest.setRequestString(queryString);
				newFinancialRequest.setRequestVersion(highestRequestVersion+1);
				newFinancialRequest.setTimestampReceived(currentDate);
				newFinancialRequest.setProcessedToFinanceTransaction("Y");
				newFinancialRequest.setRequestTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);
				newFinancialRequest.setStudentCode(studentCode);
				newFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.addFinancialRequest(newFinancialRequest);
				if (oldFinancialTransaction != null){
					oldFinancialTransaction.setStatusCode(BankInterfaceUtils.STATUS_ERROR_IGNORED);
					financialTransactionManager.updateFinancialTransaction(oldFinancialTransaction);
				}
				errorCode= financialTransactionManager.processPostTransactionRequest(request);
				if (errorCode != BankInterfaceUtils.NO_ERR){
					newFinancialRequest = unzaManager.findFinancialRequest(financialRequestId);
					if(newFinancialRequest != null){
						newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_OPUS);
						newFinancialRequest.setErrorCode(errorCode);

						newFinancialRequest.setWriteWho("unza_bankrequest");

		                unzaManager.updateFinancialRequest(newFinancialRequest);
					}
					statusCode = BankInterfaceUtils.STATUS_ERROR_OPUS;
				}
			}
			else if (requestExist){
				oldFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_IGNORED);
				oldFinancialRequest.setTimestampModified(currentDate);

				oldFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.updateFinancialRequest(oldFinancialRequest);
				newFinancialRequest = new FinancialRequest();
				newFinancialRequest.setErrorCode(errorCode);
				newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_OK);
				newFinancialRequest.setErrorReportedToFinancialSystem("N");
				newFinancialRequest.setFinancialRequestId(financialRequestId);
				newFinancialRequest.setRequestId(requestId);
				newFinancialRequest.setRequestString(queryString);
				newFinancialRequest.setRequestVersion(highestRequestVersion+1);
				newFinancialRequest.setTimestampReceived(currentDate);
				newFinancialRequest.setProcessedToFinanceTransaction("Y");
				newFinancialRequest.setRequestTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);				
				newFinancialRequest.setStudentCode(studentCode);
				newFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.addFinancialRequest(newFinancialRequest);
				errorCode= financialTransactionManager.processPostTransactionRequest(request);
				if(errorCode != BankInterfaceUtils.NO_ERR){
					newFinancialRequest = unzaManager.findFinancialRequest(financialRequestId);
					if(newFinancialRequest != null){
						newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_OPUS);
						newFinancialRequest.setErrorCode(errorCode);

						newFinancialRequest.setWriteWho("unza_bankrequest");

		                unzaManager.updateFinancialRequest(newFinancialRequest);
					}
					statusCode = BankInterfaceUtils.STATUS_ERROR_OPUS;					
				}				
			}
			
			else {
				newFinancialRequest = new FinancialRequest();
				newFinancialRequest.setErrorCode(errorCode);
				newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_OK);
				newFinancialRequest.setErrorReportedToFinancialSystem("N");
				newFinancialRequest.setFinancialRequestId(financialRequestId);
				newFinancialRequest.setRequestId(requestId);
				newFinancialRequest.setRequestString(queryString);
				newFinancialRequest.setRequestVersion(highestRequestVersion+1);
				newFinancialRequest.setTimestampReceived(currentDate);
				newFinancialRequest.setProcessedToFinanceTransaction("Y");
				newFinancialRequest.setRequestTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);				
				newFinancialRequest.setStudentCode(studentCode);
				newFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.addFinancialRequest(newFinancialRequest);
				errorCode= financialTransactionManager.processPostTransactionRequest(request);
				if (errorCode != BankInterfaceUtils.NO_ERR){
					newFinancialRequest = unzaManager.findFinancialRequest(financialRequestId);
					if(newFinancialRequest != null){
						newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_OPUS);
						newFinancialRequest.setErrorCode(errorCode);

						newFinancialRequest.setWriteWho("unza_bankrequest");

                        unzaManager.updateFinancialRequest(newFinancialRequest);
					}
					statusCode = BankInterfaceUtils.STATUS_ERROR_OPUS;
				}				
			}
		}
		// Interface error
		else {
			if (oldFinancialRequest != null){
				oldFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_IGNORED);
				oldFinancialRequest.setTimestampModified(currentDate);

				oldFinancialRequest.setWriteWho("unza_bankrequest");

                unzaManager.updateFinancialRequest(oldFinancialRequest);
			}
			newFinancialRequest = new FinancialRequest();
			newFinancialRequest.setErrorCode(errorCode);
			newFinancialRequest.setStatusCode(BankInterfaceUtils.STATUS_ERROR_INTERFACE);
			newFinancialRequest.setErrorReportedToFinancialSystem("N");
			newFinancialRequest.setFinancialRequestId(financialRequestId);
			newFinancialRequest.setRequestId(requestId);
			newFinancialRequest.setRequestString(queryString);
			newFinancialRequest.setRequestVersion(highestRequestVersion+1);
			newFinancialRequest.setTimestampReceived(currentDate);
			newFinancialRequest.setProcessedToFinanceTransaction("N");
			newFinancialRequest.setRequestTypeId(BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);			
			newFinancialRequest.setStudentCode(studentCode);
			newFinancialRequest.setWriteWho("unza_bankrequest");
            unzaManager.addFinancialRequest(newFinancialRequest);
		}
		//String msg=null;
		bankInterfaceUnzaUtils.sendResponse(request,response,BankInterfaceUtils.POST_TRANSACTION_RESPONSE_XML_TEMPLATE,errorCode,statusCode,statusCode,BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST);
		//response.setContentType("text/xml");
		//PrintWriter out = response.getWriter();
		//out.println(msg);
		//out.flush();
	}
	/**
	 * Validates incoming http request
	 * @param request
	 * @return errorCode
	 */
    public int validateRequest(HttpServletRequest request){
		int startusErrorInterface = 0;
		String requestId = null;
		String key = null;
		String studentId = null;
		String nrc = null;
		String date = null;
		String amount = null;
		String tranId = null;
		String name = null;
		String type = null;
		String phone = null;
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
		if (request.getParameter("RequestId")!= null){
			requestId = request.getParameter("RequestId");
			if(requestId.length()!=9){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_REQUESTID;
		}
		if (request.getParameter("Key")!= null){
			key = request.getParameter("Key");
			if(!BankInterfaceUnzaUtils.validateKey(key,requestId)){
				startusErrorInterface=BankInterfaceUtils.ERR_INVALID_KEY;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("StudentID")!= null){
			studentId = request.getParameter("StudentID");
			if(studentId.length()!=8){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("NRC")!= null){
			nrc = request.getParameter("NRC");
			if(nrc.length()!=11){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("Date")!= null){
			date = request.getParameter("Date");
			try {
				dateFormat.parse(date);
			} catch (ParseException e) {
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("Amount")!= null){
			amount = request.getParameter("Amount");
			if(amount.length()>10){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
			for(int i=0; i< amount.length()-1;i++){
				if(!Character.isDigit(amount.charAt(i))){
					startusErrorInterface=BankInterfaceUtils.ERR_AMOUNT_INVALID;
					break;
				}
			}			
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("TranID")!= null){
			tranId = request.getParameter("TranID");
			if(tranId.length()!=9){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_TRANID;
		}
		if (request.getParameter("Name")!= null){
			name = request.getParameter("Name");
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("Type")!= null){
			type = request.getParameter("Type");
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		if (request.getParameter("Phone")!= null){
			phone = request.getParameter("Phone");
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_FIELDS;
		}
		return startusErrorInterface;
	}
}

