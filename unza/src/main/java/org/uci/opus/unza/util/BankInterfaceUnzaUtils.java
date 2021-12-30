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
package org.uci.opus.unza.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.naming.Context;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.codec.Base64;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.fee.domain.DiscountedFee;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.finance.domain.FinancialTransaction;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.unza.domain.FinancialRequest;
import org.uci.opus.unza.service.UnzaManagerInterface;

/**
 * @author R.Rusinkiewicz
 *
 */
public class BankInterfaceUnzaUtils {
    private static Logger log = Logger.getLogger(BankInterfaceUnzaUtils.class);
	private static final String messageDigestAlgorithm = "SHA-1";
    public static final String UNAUTHORIZED_ACCESS="Unauthorized access";
    @Autowired private FinancialTransactionManager financialTransactionManager;
    @Autowired private UnzaManagerInterface unzaManager;  
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private BankInterfaceUtils bankInterfaceUtils;
    @Autowired private FeeManagerInterface feeManager;

    /**
	 * @return the key
	 */
	public static String getKey() {
		// Create the initial context
        Context ctx;
        //String shaKey = null;
         String shaKey = "59226384236485972469";
		
//        try {
//			ctx = new InitialContext();
//			//shaKey = (String) ctx.lookup("opus-sha");
//	        // Look up the environment with the properties
//			Hashtable<?, ?> properties = ctx.getEnvironment();
//			shaKey = (String) properties.get("sha-key");
//		} catch (NamingException e) {
//			log.error("Retrieving sha-key from env not succeeded: "+ e.getMessage());
//		}
		
		return shaKey;
	}

	/**
	  * Validates incoming request by calculating messageDigest and encoding used Base64 of sum encryption key and requestId parameter.    
	  * @param key
	  * @param requestId
	  * @return true if calculated String is equals incoming key parameter of request, otherwise false
	  */
	public static boolean validateKey(String key, String requestId){
	    String encodedData = null;
		boolean validated = true;
		byte[] mdDigest = null;
		String hexDigest = null;
		MessageDigest md;
		try {
			md = MessageDigest.getInstance(BankInterfaceUnzaUtils.messageDigestAlgorithm);
		    md.reset();
		    md.update((BankInterfaceUnzaUtils.getKey() + requestId).getBytes(),0,(BankInterfaceUnzaUtils.getKey() + requestId).length());
		    mdDigest = md.digest();
		    hexDigest = convertToHex(mdDigest);
		    encodedData = new String(Base64.encode(hexDigest.getBytes()));
		    if(!key.equals(encodedData)){
		    	validated = false;
		    }
		} catch (NoSuchAlgorithmException e) {
			log.error(e.getMessage());
			validated = false;
		}
		return validated;
	}
	/**
	 * Converts incoming Byte array to hexadecimal notation	
	 * @param data
	 * @return
	 */
    private static String convertToHex(byte[] data) { 
        StringBuffer buf = new StringBuffer();
        for (int i = 0; i < data.length; i++) { 
            int halfbyte = (data[i] >>> 4) & 0x0F;
            int two_halfs = 0;
            do { 
                if ((0 <= halfbyte) && (halfbyte <= 9)) 
                    buf.append((char) ('0' + halfbyte));
                else 
                    buf.append((char) ('a' + (halfbyte - 10)));
                halfbyte = data[i] & 0x0F;
            } while(two_halfs++ < 1);
        } 
        return buf.toString();
    } 
	/**
	 * Sends response back to the host of the incoming request    
	 * @param request
	 * @param xmlTemplateResponse
	 * @param errorCode
	 * @param statusCodeRequest
	 * @param statusCodeTransaction
	 * @param requestType
	 */
    public void sendResponse(HttpServletRequest request, HttpServletResponse response, String xmlTemplateResponse, int errorCode, int statusCodeRequest,int statusCodeTransaction, int requestType) throws IOException{
 	    	String statusMessageRequest = BankInterfaceUtils.getStatusMessage(statusCodeRequest);
	    	String statusMessageTransaction = BankInterfaceUtils.getStatusMessage(statusCodeTransaction);
	    	String errorMessage = BankInterfaceUtils.getErrorMessage(errorCode);
	    	String financialRequestId = "";
	    	String xmlResponse = xmlTemplateResponse;
	    	if (request.getParameter("TranID")!= null) {
	    		financialRequestId = request.getParameter("TranID");
	    	}
			
	    	if(requestType == BankInterfaceUtils.POST_TRANSACTION_TYPE_REQUEST){
	    		xmlResponse=xmlResponse.replaceAll("PostTranResponse status=\"\"","PostTranResponse status=\""+statusMessageRequest+"\"");
	    	}
	    	else if(requestType == BankInterfaceUtils.QUERY_STATUS_TYPE_REQUEST){
	    		xmlResponse=xmlResponse.replaceAll("QueryStatusResponse status=\"\"","QueryStatusResponse status=\""+statusMessageRequest+"\"");
	    	}
	       	else if(requestType == BankInterfaceUtils.REVERSE_TRANSACTION_TYPE_REQUEST){
	    		xmlResponse=xmlResponse.replaceAll("ReverseTransactionResponse status=\"\"","ReverseTransactionResponse status=\""+statusMessageRequest+"\"");
	    	} 
	    	xmlResponse=xmlResponse.replaceAll("\" status=\"\"","\" status=\""+statusMessageTransaction+"\"");    	
	    	xmlResponse=xmlResponse.replaceAll("errorMessage=\"\"","errorMessage=\""+errorMessage+"\"");
	    	xmlResponse=xmlResponse.replaceAll("Transaction id=\"\"","Transaction id=\""+financialRequestId+"\"");
	    	log.info("Sending response to recipient"+xmlResponse);
	    	
	    	response.setContentType("text/xml");
	    	PrintWriter out = null;
	    	try{
	    		out = response.getWriter();
				out.println(xmlResponse);
				out.flush();
	    	}finally{
	    		if (out != null)
	    		out.close();
	    	}
			
			
	    	//return xmlResponse;
    	/*try{
	    	HttpClient httpClient = new DefaultHttpClient();
	    	HttpPost httpPost = new HttpPost(url);
	    	StringEntity stringEntity = new StringEntity(xmlResponse);
	    	stringEntity.setContentType("application/xml");
	    	httpPost.setEntity(stringEntity);
	    	HttpResponse response = httpClient.execute(httpPost);// this is a different response object not the one passed with the request
	    	int rc = response.getStatusLine().getStatusCode();
	    	if (rc != 200) {  
	    		log.error("Error sending message"); 	    	
	    	}
	    	
    	}
    	catch(ClientProtocolException c){
    		log.error(c.getMessage());
    	}
    	catch(IOException e){
    		log.error(e.getMessage());
    	}*/
      }
	/**
	 * This method process selected FinancialRequest records to the new FinancialTrasactions records    
	 * @param financialRequestIds
	 */
    public void processToFinancialTransaction(String[] financialRequestIds){
    	FinancialTransaction financialTransaction = null;
    	FinancialRequest financialRequest = null;
		Calendar calendar = Calendar.getInstance();
		Date date  = null;
    	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
    	String year = null;
    	List<AcademicYear> academicYears = null;
        
    	for(String financialRequestId : financialRequestIds){
    		financialRequest = unzaManager.findFinancialRequest(financialRequestId);
    		if(financialTransactionManager.findFinancialTransaction(financialRequest.getFinancialRequestId())!= null)
    			continue;
    		financialTransaction = new FinancialTransaction();
    		financialTransaction.setRequestId(financialRequest.getRequestId());
    		financialTransaction.setErrorCode(financialRequest.getErrorCode());
    		financialTransaction.setErrorReportedToFinancialBankrequest("N");
    		financialTransaction.setFinancialRequestId(financialRequest.getFinancialRequestId());
    		financialTransaction.setTransactionTypeId(financialRequest.getRequestTypeId());
    		financialTransaction.setStudentCode(parseStudentCodeFromString(financialRequest.getRequestString()));
    		financialTransaction.setName(parseStudentNameFromString(financialRequest.getRequestString()));
    		financialTransaction.setStatusCode(financialRequest.getStatusCode());
    		financialTransaction.setAmount(BigDecimal.valueOf(parseAmountFromString(financialRequest.getRequestString())));
    		financialTransaction.setNationalRegistrationNumber(parseNationalRegistrationNumberFromString(financialRequest.getRequestString()));
    		financialTransaction.setProcessedToStudentbalance("N");
    		financialTransaction.setTimestampProcessed(new Date());
    		financialTransaction.setRequestString(financialRequest.getRequestString());
    		financialTransaction.setWriteWho(financialRequest.getWriteWho());
    		try {
    			date = dateFormat.parse(parseDateFromString(financialRequest.getRequestString()));
    			calendar.setTime(date);
    	    	year = new Integer(calendar.get(Calendar.YEAR)).toString();
    	    	academicYears=academicYearManager.findAcademicYears(year);
    	    	for (AcademicYear academicYear:academicYears){
    	    		if(academicYear.getDescription().equals(year)){
    	    			financialTransaction.setAcademicYearId(academicYear.getId());
    	    			break;
    	    		}
    	    	}    	    	

        	} catch (ParseException e) {
    			log.error(e.getMessage());
    		}
    		financialTransactionManager.addFinancialTransaction(financialTransaction);
    	}
    }
	 /**
	  * This methods sets errorReported field of selected FinancialRequests to "Y"   
	  * @param financialRequestIds
	  */
    public void setErrorReported(String[] financialRequestIds, HttpServletRequest request){
    	FinancialRequest financialRequest = null;
    	
    	for(String financialRequestId: financialRequestIds){
    		financialRequest = unzaManager.findFinancialRequest(financialRequestId);
    		financialRequest.setErrorReportedToFinancialSystem("Y");
    		financialRequest.setWriteWho("unza_bankrequest");
    		unzaManager.updateFinancialRequest(financialRequest);
    	}
    }
    /**
     * This method verifies remote address with the configuration White list addresses. If it is not equal to one of the saved addresses
     * returns false otherwise true;
     * @param request
     * @return
     */
    public boolean verifyRequestAddress(HttpServletRequest request){
    	String remoteAddress =request.getRemoteAddr();
       	char separator = ',';
       	int lastSeparatorIndex = 0;
       	ArrayList<String> permittedAddresses = new ArrayList<String>();
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("BANK_WHITELIST_ADDRESSES");
       	if (config!=null && config.getAppConfigAttributeName().equals("BANK_WHITELIST_ADDRESSES")){
       		for(int i=0; i <config.getAppConfigAttributeValue().length(); i++){
       			if(config.getAppConfigAttributeValue().charAt(i)==separator){
       				permittedAddresses.add(config.getAppConfigAttributeValue().substring(lastSeparatorIndex==0?lastSeparatorIndex:lastSeparatorIndex+1, i));
       				lastSeparatorIndex = i;
       			}
       		}
       		if(config.getAppConfigAttributeValue().length()>0){
       			permittedAddresses.add(config.getAppConfigAttributeValue().substring(lastSeparatorIndex==0?lastSeparatorIndex:lastSeparatorIndex+1,config.getAppConfigAttributeValue().length()));
       		}
       	}
       	for(String whiteListAddress: permittedAddresses){
       		log.info("[whitelist address] =>"+whiteListAddress+"<= [Reomte client] =>"+remoteAddress);
       		if(whiteListAddress.equals(remoteAddress)){
       			log.info("Address is accepted in the whitelist...");
       			return true;
       		}
       	}
       	return false;
      
    }
    /**
	 * Retrieves the list of financialRequests which are associated to the tuition fee, and in case it is paid less than 75 procent
	 * @param financialRequests
	 * @param request
	 * @return the list of financialRequests that meet criteria
	 */  
    public List<FinancialRequest> getTuitionFee75PercentPaid(List<FinancialRequest> financialRequests,HttpServletRequest request){
    	FinancialTransaction financialTransaction = null;
    	int studentId = 0;
    	Student student = null;
    	List<StudentBalance>allStudentBalances = null;
    	List<Payment> paymentsForStudent = null;
    	List<DiscountedFee> allStudentFeesToPay;// = new ArrayList<DiscountedFee>();
    	List<FinancialRequest> resultFinancialRequests = new ArrayList<FinancialRequest>();
//    	FinancialRequest tmpFinancialRequest = null;
    	List<DiscountedFee>feesForSubjectStudyGradeTypes = null;
    	List<DiscountedFee>feesForSubjectBlockStudyGradeTypes = null;
    	List<DiscountedFee>feesForStudyGradeTypes = null;
    	List<DiscountedFee>feesForAcademicYear = null;
    	DiscountedFee tuitionFee = null;
    	double alreadyPaid = 0.0;
//    	double tuitionFeeValue = 0.0;
        IdToAcademicYearMap idToAcademicYearMap = new IdToAcademicYearMap(academicYearManager.findAllAcademicYears());
    	BankInterfaceUtils.FeesComparatorAscending comparator = new BankInterfaceUtils().new FeesComparatorAscending(idToAcademicYearMap);
    	for(FinancialRequest financialRequest:financialRequests){
//	    	tmpFinancialRequest = financialRequest;
    		alreadyPaid = 0.0;
    		allStudentFeesToPay = new ArrayList<DiscountedFee>();
    		if(financialRequest.getStatusCode()==BankInterfaceUtils.STATUS_ERROR_IGNORED){
	    		continue;
	    	}
    		student = studentManager.findStudentByCode(financialRequest.getStudentCode());
    		if(student != null){
    			studentId = student.getStudentId();
    		}
			feesForSubjectStudyGradeTypes=bankInterfaceUtils.getStudentFeesForSubjectStudyGradeTypesWithDiscounts(studentId);
			feesForSubjectBlockStudyGradeTypes=bankInterfaceUtils.getStudentFeesForSubjectBlockStudyGradeTypesWithDiscounts(studentId);
			feesForStudyGradeTypes=bankInterfaceUtils.getStudentFeesForStudyGradeTypesWithDiscounts(studentId);
			feesForAcademicYear = bankInterfaceUtils.getStudentFeesForAcademicYearsWithDiscounts(studentId);
    		for(DiscountedFee fee:feesForSubjectStudyGradeTypes){
    			allStudentFeesToPay.add(fee);
    		}
    		for(DiscountedFee fee:feesForSubjectBlockStudyGradeTypes){
    			allStudentFeesToPay.add(fee);
    		}
    		for(DiscountedFee fee:feesForStudyGradeTypes){
    			allStudentFeesToPay.add(fee);
    		}
    		for(DiscountedFee fee:feesForAcademicYear){
    			allStudentFeesToPay.add(fee);
    		}
			financialTransaction = financialTransactionManager.findFinancialTransaction(financialRequest.getFinancialRequestId());
			if (financialTransaction != null) {
				student = studentManager.findStudentByCode(financialTransaction.getStudentCode());
	    		if(student != null){
	    			studentId = student.getStudentId();
	    		}		
				allStudentBalances = feeManager.findStudentBalances(studentId);
				paymentsForStudent=paymentManager.findPaymentsForStudent(studentId);
			}
			
			Collections.sort(allStudentFeesToPay,comparator);
			if (allStudentFeesToPay != null) {
				for(DiscountedFee fee:allStudentFeesToPay){
				    if ("1".equals(fee.getFee().getCategoryCode())) {
				        tuitionFee = fee;
				    }
				}
    		}
			if (allStudentBalances != null) {
				for(StudentBalance studentBalance: allStudentBalances){
					if(tuitionFee != null && tuitionFee.getFee().getId()== studentBalance.getFeeId()){
						for(Payment payment: paymentsForStudent){
							if(payment.getStudentBalanceId()==studentBalance.getId()){
								alreadyPaid += payment.getSumPaid().doubleValue();
							}
						}
					}
				}
			}
	        if(alreadyPaid < 0.75 *((tuitionFee==null)?-1.0:tuitionFee.getDiscountedFeeDue())){
	        	resultFinancialRequests.add(financialRequest);
	        }	
    	}
    	return resultFinancialRequests;
    }
    public static void main(String[] argv){
    	String exampleRequestId = "ECJ62ICW2";
		String exampleKey = "NmMzMzhjYjZiYWU5ZDc4MWUzNzdmZTg4NGE3ZWYxZjg2MzI5NDg0OA==";
		System.out.println(validateKey(exampleKey,exampleRequestId));
	}
	 /**
	  * Parses StudentId from the parameterString    
	  * @param parameterString
	  * @return
	  */
    private String parseStudentCodeFromString(String parameterString){
    	String matchString = "StudentID";
    	int beginIndex = parameterString.indexOf(matchString)+matchString.length()+1;
    	String studentCode = parameterString.substring(beginIndex, parameterString.indexOf("&", beginIndex));
    	return studentCode;
    }
	/**
	 * Parses Name from the parameterString    
	 * @param parameterString
	 * @return
	 */
    private String parseStudentNameFromString(String parameterString){
    	String matchString = "Name";
    	int beginIndex = parameterString.indexOf(matchString)+matchString.length()+1;
    	String studentName = parameterString.substring(beginIndex, parameterString.indexOf("&", beginIndex));
    	return studentName;
    }
	/**
	 * Parses amount from the parameterString    
	 * @param parameterString
	 * @return
	 */
    private double parseAmountFromString(String parameterString){
    	String matchString = "Amount";
    	int beginIndex = parameterString.indexOf(matchString)+matchString.length()+1;
    	String amount = parameterString.substring(beginIndex, parameterString.indexOf("&", beginIndex));
    	return Double.parseDouble(amount);
    }   
	/**
	 * Parses NRC number from the parameterString    
	 * @param parameterString
	 * @return
	 */
    private String parseNationalRegistrationNumberFromString(String parameterString){
    	String matchString = "NRC";
    	int beginIndex = parameterString.indexOf(matchString)+matchString.length()+1;
    	String nationalRegistrationNumber = parameterString.substring(beginIndex, parameterString.indexOf("&", beginIndex));
    	return nationalRegistrationNumber;
    }
	/**
	 * Parses Date from the parameterString    
	 * @param parameterString
	 * @return
	 */
    private String parseDateFromString(String parameterString){
    	String matchString = "Date";
    	int beginIndex = parameterString.indexOf(matchString)+matchString.length()+1;
    	String date = parameterString.substring(beginIndex, parameterString.indexOf("&", beginIndex));
    	return date;
    }
    
}
