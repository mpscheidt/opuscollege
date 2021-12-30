package org.uci.opus.unza.service;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.HttpRequestHandler;

import org.uci.opus.college.service.GeneralManagerInterface;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.unza.util.BankInterfaceUnzaUtils;

public class BankReverseTransactionReceiver implements HttpRequestHandler {
    @Autowired private FinancialTransactionManager financialTransactionManager; 
    @Autowired private BankInterfaceUnzaUtils bankInterfaceUnzaUtils;
    @Autowired private GeneralManagerInterface generalManager;
    /**
     * This method has to be implemented by HttPRequestHandler and is a wrapper method of
     * doGet or doPost methods of java HttpServlet class. By using Spring
     * HttPRequestHandler it is possible to access Spring application context.
     * This method process incoming BankReverse Http requests.
      */
    public void handleRequest(HttpServletRequest request, HttpServletResponse response)throws IOException{
        if(!bankInterfaceUnzaUtils.verifyRequestAddress(request)){
        	generalManager.logRequestError(request.getRemoteAddr(), request.getQueryString(), BankInterfaceUnzaUtils.UNAUTHORIZED_ACCESS);
        	return;
        }
     	int statusCodeRequest = BankInterfaceUtils.STATUS_OK;
		int statusCodeTransaction = BankInterfaceUtils.STATUS_OK;
		int errorCode = validateRequest(request);

		if (errorCode == BankInterfaceUtils.NO_ERR){
			errorCode=financialTransactionManager.processReverseTransactionRequest(request);
			if(errorCode != BankInterfaceUtils.NO_ERR){
				statusCodeTransaction = BankInterfaceUtils.STATUS_ERROR_OPUS;
			}
		}
		else{
			statusCodeRequest = BankInterfaceUtils.STATUS_ERROR_INTERFACE;			
		}
		bankInterfaceUnzaUtils.sendResponse(request,response,BankInterfaceUtils.REVERSE_TRANSACTION_RESPONSE_XML_TEMPLATE,errorCode,statusCodeRequest,statusCodeTransaction,BankInterfaceUtils.REVERSE_TRANSACTION_TYPE_REQUEST);				
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
		String tranId = null;
		String studentId = null;
		String nrc = null;
		String date = null;
		String amount = null;
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
		if (request.getParameter("TranID")!= null){
			tranId = request.getParameter("TranID");
			if(tranId.length()!=9){
				startusErrorInterface=BankInterfaceUtils.ERR_GENERAL_FAILURE;
			}
		}
		else {
			startusErrorInterface=BankInterfaceUtils.ERR_MISSING_TRANID;
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
			if(amount.length()!=7){
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
		return startusErrorInterface;
	}		
}
