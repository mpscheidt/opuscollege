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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.HttpRequestHandler;
import org.uci.opus.college.service.GeneralManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.unza.util.BankInterfaceUnzaUtils;
/**
 * @author R.Rusinkiewicz
 *
 */
public class BankQueryStatusReceiver implements HttpRequestHandler{
    @Autowired private FinancialTransactionManager financialTransactionManager; 
    @Autowired private BankInterfaceUnzaUtils bankInterfaceUnzaUtils;
    @Autowired private GeneralManagerInterface generalManager;
    private static Logger log = Logger.getLogger(BankQueryStatusReceiver.class);   

    /**
     * This method has to be implemented by HttPRequestHandler and is a wrapper method of
     * doGet or doPost methods of java HttpServlet class. By using Spring
     * HttPRequestHandler it is possible to access Spring application context.
     * This method process incoming BankPost Http requests.
      */    
    public void handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException{
        if(!bankInterfaceUnzaUtils.verifyRequestAddress(request)){
        	generalManager.logRequestError(request.getRemoteAddr(), request.getQueryString(), BankInterfaceUnzaUtils.UNAUTHORIZED_ACCESS);
        	return;
        }	
		int statusCodeRequest = BankInterfaceUtils.STATUS_OK;
		int statusCodeTransaction = BankInterfaceUtils.STATUS_ERROR_OPUS;
		int errorCode = validateRequest(request);
		String financialRequestId = null;
		FinancialTransaction financialTransaction = null;
		if (errorCode != BankInterfaceUtils.NO_ERR){
			statusCodeRequest = BankInterfaceUtils.STATUS_ERROR_INTERFACE;
		}
		if (request.getParameter("TranID")!= null){
			financialRequestId = request.getParameter("TranID");
		}
		if (financialRequestId != null){
			financialTransaction = financialTransactionManager.findFinancialTransaction(financialRequestId);
		}
		if(financialTransaction != null){
			statusCodeTransaction = financialTransaction.getStatusCode();
		}

    	financialRequestId = "";
    	String xmlResponse = BankInterfaceUtils.QUERY_STATUS_RESPONSE_XML_TEMPLATE;

		bankInterfaceUnzaUtils.sendResponse(request,response,BankInterfaceUtils.QUERY_STATUS_RESPONSE_XML_TEMPLATE,errorCode,statusCodeRequest,statusCodeTransaction,BankInterfaceUtils.QUERY_STATUS_TYPE_REQUEST);		
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
		return startusErrorInterface;
	}	
}

