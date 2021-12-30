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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
@RequestMapping("/finance/financialTransactions")
public class FinancialTransactionsController {

    private static final String FORM_VIEW = "fee/finance/financialTransactions";

    @Autowired private FinancialTransactionManager financialTransactionManager;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;  
    @Autowired private AcademicYearManagerInterface academicYearManager;     
    @Autowired private StudentManagerInterface studentManager;    
    @Autowired private PersonManagerInterface personManager;
    @Autowired private BankInterfaceUtils bankInterfaceUtils;

	public FinancialTransactionsController() {
		super();
	}

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) throws ParseException {

        int currentPageNumber = 1;
        Person person = new Person();
		int statusCode = -1;
		int errorCode = -1;
		Date fromReceivedDate = null;
		String fromReceivedDateAsString = null;
		Date untilReceivedDate = null;
		String untilReceivedDateAsString = null;
		String studentCode = null;
		int studentId = 0;
		Student student = null;
		String financialRequestId = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy"); 
		boolean tuitionFee75ProcentPaid = false;
		
	    Map<String, Object> parameterMap = new HashMap<String,Object>();
	     Calendar calendar = Calendar.getInstance();	
	     List <FinancialTransaction> allFinancialTransactions = null;
	     List <AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
	    HttpSession session = request.getSession(false);
	     /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        session.setAttribute("menuChoice", "fee");
    
    	allAcademicYears = academicYearManager.findAllAcademicYears();
   
     
	    if (request.getParameter("currentPageNumber") != null) {
	       	currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
	    }
	    else if((request.getParameter("formRequest")==null &&request.getParameter("currenPageNumberRedirect")!=null &&!"".equals(request.getParameter("currentPageNumberRedirect").toString()))){
	    	currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumberRedirect"));
		}
		if(request.getParameter("statusCodeSelection")!= null){
			statusCode = Integer.parseInt(request.getParameter("statusCodeSelection"));
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("statusCodeSelectionRedirect")!=null &&!"".equals(request.getParameter("statusCodeSelectionRedirect").toString()))){
			statusCode = Integer.parseInt(request.getParameter("statusCodeSelectionRedirect"));
		}
		if(request.getParameter("errorCodeSelection")!=null){
			errorCode= Integer.parseInt(request.getParameter("errorCodeSelection"));
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("errorCodeSelectionRedirect")!=null &&!"".equals(request.getParameter("errorCodeSelectionRedirect").toString()))){
			errorCode = Integer.parseInt(request.getParameter("errorCodeSelectionRedirect"));
		}
		if(request.getParameter("fromReceivedDate")!=null && !"".equals(request.getParameter("fromReceivedDate").toString())&&!"null".equals(request.getParameter("fromReceivedDate").toString())){
			fromReceivedDate=dateFormat.parse(request.getParameter("fromReceivedDate"));
			fromReceivedDateAsString=request.getParameter("fromReceivedDate");
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("fromReceivedDateRedirect")!=null &&!"".equals(request.getParameter("fromReceivedDateRedirect").toString()) && !"null".equals(request.getParameter("fromReceivedDateRedirect").toString()))){
			fromReceivedDate=dateFormat.parse(request.getParameter("fromReceivedDateRedirect"));
			fromReceivedDateAsString=request.getParameter("fromReceivedDateRedirect");
		}		
		if(request.getParameter("untilReceivedDate")!=null && !"".equals(request.getParameter("untilReceivedDate").toString())&&!"null".equals(request.getParameter("untilReceivedDate").toString())){
			untilReceivedDate = dateFormat.parse(request.getParameter("untilReceivedDate"));
			untilReceivedDateAsString = request.getParameter("untilReceivedDate");
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("untilReceivedDateRedirect")!=null && !"".equals(request.getParameter("untilReceivedDateRedirect").toString()) && !"null".equals(request.getParameter("untilReceivedDateRedirect")))) {
			untilReceivedDate=dateFormat.parse(request.getParameter("untilReceivedDateRedirect"));
			untilReceivedDateAsString=request.getParameter("untilReceivedDateRedirect");
		}			
		if(request.getParameter("studentCode")!=null && !"".equals(request.getParameter("studentCode").toString())&&!"null".equals(request.getParameter("studentCode").toString())){
			studentCode = request.getParameter("studentCode");
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("studentCodeRedirect")!=null &&!"".equals(request.getParameter("studentCodeRedirect").toString())&&!"null".equals(request.getParameter("studentCodeRedirect").toString()))){
			studentCode = request.getParameter("studentCodeRedirect");
		}			

		if(request.getParameter("financialRequestIdParam")!=null && !"".equals(request.getParameter("financialRequestIdParam").toString())&& !"null".equals(request.getParameter("financialRequestIdParam").toString()))
		{
			financialRequestId = request.getParameter("financialRequestIdParam").toString();
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("financialRequestIdParamRedirect")!=null &&!"".equals(request.getParameter("financialRequestIdParamRedirect").toString())&&!"null".equals(request.getParameter("financialRequestIdParamRedirect").toString()))){
			financialRequestId = request.getParameter("financialRequestIdParamRedirect").toString();
		}
		if((request.getParameter("tuitionFee75Procent")!=null &&!"".equals(request.getParameter("tuitionFee75Procent").toString())||
				(request.getParameter("formRequest")==null &&request.getParameter("tuitionFee75ProcentRedirect")!=null &&!"".equals(request.getParameter("tuitionFee75ProcentRedirect").toString())))){
				tuitionFee75ProcentPaid= true;
		}
		if(untilReceivedDate != null){
			if(fromReceivedDate == null){
				calendar.set(1970,1,1,12,12,1);
				fromReceivedDate = calendar.getTime();
			}	
   		}
		if(fromReceivedDate != null){
			if(untilReceivedDate ==null){
				untilReceivedDate = new Date();
			}
 		}
		
       	if((statusCode >=0 || errorCode >= 0 || fromReceivedDate != null || untilReceivedDate != null || studentCode != null || financialRequestId != null)){
    		parameterMap.put("statusCode",statusCode);
    		parameterMap.put("errorCode", errorCode);
 
    		parameterMap.put("financialRequestId", financialRequestId);
    		parameterMap.put("fromReceivedDate", fromReceivedDate);
    		parameterMap.put("untilReceivedDate", untilReceivedDate);
    		parameterMap.put("studentCode",studentCode);
    		parameterMap.put("tuitionFee75Procent", tuitionFee75ProcentPaid?1:0);
    		allFinancialTransactions=financialTransactionManager.findFinancialTransactionsBySelection(parameterMap);
    	}
       	else{
   			allFinancialTransactions = financialTransactionManager.findFinancialTransactions();;
       	}
//       	if(tuitionFee75ProcentPaid){
//       		allFinancialTransactions=bankInterfaceUtils.getTuitionFee75PercentPaid(allFinancialTransactions,request);
//       	}
        for(int i=0;i < allFinancialTransactions.size();i++){
        	student = studentManager.findStudentByCode(allFinancialTransactions.get(i).getStudentCode());
        	if(student != null){
        		studentId = student.getStudentId();
        	}
        	person = personManager.findPersonById(studentId);
        	
        	if (person != null){
        		allFinancialTransactions.get(i).setStudentName(person.getSurnameFull());
        	}
			allFinancialTransactions.get(i).setErrorMessage(BankInterfaceUtils.getErrorMessage(allFinancialTransactions.get(i).getErrorCode()));
			allFinancialTransactions.get(i).setStatusMessage(BankInterfaceUtils.getStatusMessage(allFinancialTransactions.get(i).getStatusCode()));
			allFinancialTransactions.get(i).setTransactionTypeMessage(BankInterfaceUtils.getTypeMessage(allFinancialTransactions.get(i).getTransactionTypeId()));      	
        } 
        
        // if a subject is linked to a result, it can not be deleted; this attribute is
        // used to show an error message.
        request.setAttribute("showError", request.getParameter("showError"));
        
        request.setAttribute("currentPageNumber", currentPageNumber);
        request.setAttribute("allFinancialTransactions", allFinancialTransactions);
        request.setAttribute("allAcademicYears", allAcademicYears); 
        request.setAttribute("statusCodeSelection", statusCode);
        request.setAttribute("errorCodeSelection", errorCode);    
        if(studentCode != null){
        	request.setAttribute("studentCode", studentCode); 
        }
        request.setAttribute("financialRequestIdParam", financialRequestId);
        request.setAttribute("fromReceivedDate", fromReceivedDateAsString==null?"":fromReceivedDateAsString);
        request.setAttribute("untilReceivedDate", untilReceivedDateAsString==null?"":untilReceivedDateAsString);
        
        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request) {

        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;
         
		int statusCode = -1;
		int errorCode = -1;
		String fromReceivedDate = null;
		String untilReceivedDate = null;
		String studentCode = null;
		String financialRequestId = null;
		String tuitionFee75ProcentPaid = "";
		StringBuffer redirect = new StringBuffer();
    	if(request.getParameter("statusCodeSelection")!= null){
			statusCode = Integer.parseInt(request.getParameter("statusCodeSelection"));
		}
		if(request.getParameter("errorCodeSelection")!=null){
			errorCode= Integer.parseInt(request.getParameter("errorCodeSelection"));
		}
		if(request.getParameter("fromReceivedDate")!=null && !"".equals(request.getParameter("fromReceivedDate").toString())){
			fromReceivedDate=request.getParameter("fromReceivedDate");
		}else if(request.getAttribute("fromReceivedDate")!=null){
			fromReceivedDate=request.getAttribute("fromReceivedDate").toString();
		}
		
		if(request.getParameter("untilReceivedDate")!=null && !"".equals(request.getParameter("untilReceivedDate").toString())){
			untilReceivedDate = request.getParameter("untilReceivedDate");
		}else if(request.getAttribute("untilReceivedDate")!=null){
			untilReceivedDate=request.getAttribute("untilReceivedDate").toString();
		}
		
		if(request.getParameter("studentCode")!=null && !"".equals(request.getParameter("studentCode").toString())){
			studentCode = request.getParameter("studentCode");
		}
		if(request.getParameter("financialRequestIdParam")!=null && !"".equals(request.getParameter("financialRequestIdParam").toString())){
			financialRequestId = request.getParameter("financialRequestIdParam").toString();
		}
		if(request.getParameter("tuitionFee75Procent")!=null &&!"".equals(request.getParameter("tuitionFee75Procent").toString())){
				tuitionFee75ProcentPaid="on";
		}
		
        String[] requestIds = request.getParameterValues("financialTransactionId");
        String processedToStudentBalance = request.getParameter("progressToStudentBalance");

    
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
        /* with each call the preferred language may be changed */
        
        if("true".equals(request.getParameter("submitPressed"))&& requestIds !=null){        
    	
        	if(processedToStudentBalance != null && processedToStudentBalance.equals("on")){
        		bankInterfaceUtils.processToStudentBalance(requestIds, opusMethods.getWriteWho(request));
        	}
        }
        
        redirect.append("redirect:/finance/financialTransactions.view?tab=");
        redirect.append(tab + "&panel=" + panel); 
        redirect.append("&currentPageNumber=" + currentPageNumber);
        redirect.append("&statusCodeSelectionRedirect=" + statusCode);
        redirect.append("&errorCodeSelectionRedirect="+errorCode);
        redirect.append("&fromReceivedDateRedirect="+fromReceivedDate);
        redirect.append("&untilReceivedDateRedirect="+untilReceivedDate);
        redirect.append("&studentCodeRedirect="+studentCode);
        redirect.append("&financialRequestIdParamRedirect="+financialRequestId);
        redirect.append("&tuitionFee75ProcentRedirect="+tuitionFee75ProcentPaid);
        // seems to be not working, shows empty screen:
        //redirect.append("&tuitionFee75ProcentRedirect="+tuitionFee75ProcentPaid);
    	return redirect.toString();
    }
   
}
