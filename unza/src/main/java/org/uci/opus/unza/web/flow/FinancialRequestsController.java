package org.uci.opus.unza.web.flow;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.finance.service.FinancialTransactionManager;
import org.uci.opus.finance.util.BankInterfaceUtils;
import org.uci.opus.unza.domain.FinancialRequest;
import org.uci.opus.unza.service.UnzaManager;
import org.uci.opus.unza.util.BankInterfaceUnzaUtils;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

public class FinancialRequestsController extends SimpleFormController {
	private String viewName;
    @Autowired private FinancialTransactionManager financialTransactionManager;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;  
    @Autowired private AcademicYearManagerInterface academicYearManager;     
    @Autowired private UnzaManager unzaManager;    
    @Autowired private BankInterfaceUnzaUtils bankInterfaceUnzaUtils;    

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public FinancialRequestsController() {
		super();
	}

	@Override
	protected Object formBackingObject(HttpServletRequest request) throws Exception
	{
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        session.setAttribute("menuChoice", "unza");
        
		
		int statusCode = -1;
		int errorCode = -1;
		Date fromReceivedDate = null;
		String fromReceivedDateAsString = null;
		Date untilReceivedDate = null;
		String untilReceivedDateAsString = null;
		String studentCode = null;
		String financialRequestId = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy"); 
//		boolean tuitionFee75ProcentPaid = false;

        int currentPageNumber = 1;
	    int year =0;
	    Map<String, Object> parameterMap = new HashMap<String,Object>();
	     Calendar calendar = Calendar.getInstance();	
	     List <FinancialRequest> allFinancialRequests = null;
	     List <AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
	    
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
		else if((request.getParameter("formRequest")==null &&request.getParameter("fromReceivedDateRedirect")!=null &&!"".equals(request.getParameter("fromReceivedDateRedirect").toString()))){
			fromReceivedDate=dateFormat.parse(request.getParameter("fromReceivedDateRedirect"));
			fromReceivedDateAsString=request.getParameter("fromReceivedDateRedirect");
		}		
		if(request.getParameter("untilReceivedDate")!=null && !"".equals(request.getParameter("untilReceivedDate").toString())&&!"null".equals(request.getParameter("untilReceivedDate").toString())){
			untilReceivedDate = dateFormat.parse(request.getParameter("untilReceivedDate"));
			untilReceivedDateAsString = request.getParameter("untilReceivedDate");
		}
		else if((request.getParameter("formRequest")==null &&request.getParameter("untilReceivedDateRedirect")!=null &&!"".equals(request.getParameter("untilReceivedDateRedirect").toString()))){
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
//		if((request.getParameter("tuitionFee75Procent")!=null &&!"".equals(request.getParameter("tuitionFee75Procent").toString())||
//				(request.getParameter("formRequest")==null &&request.getParameter("tuitionFee75ProcentRedirect")!=null &&!"".equals(request.getParameter("tuitionFee75ProcentRedirect").toString())))){
//				tuitionFee75ProcentPaid= true;
//		}
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
//    		parameterMap.put("tuitionFee75Procent", tuitionFee75ProcentPaid?1:0);
    		allFinancialRequests=unzaManager.findFinancialRequestsBySelection(parameterMap);
    	}
       	else{
   			allFinancialRequests = unzaManager.findFinancialRequests();
       	}
//       	if(tuitionFee75ProcentPaid){
//       		allFinancialRequests=bankInterfaceUnzaUtils.getTuitionFee75PercentPaid(allFinancialRequests,request);
//       	}
    	

        for(int i=0; i < allFinancialRequests.size();i++){
			calendar.setTime(allFinancialRequests.get(i).getTimestampReceived());
	    	year = new Integer(calendar.get(Calendar.YEAR));
	    	allFinancialRequests.get(i).setAcademicYear(year);
			allFinancialRequests.get(i).setErrorMessage(BankInterfaceUtils.getErrorMessage(allFinancialRequests.get(i).getErrorCode()));
			allFinancialRequests.get(i).setStatusMessage(BankInterfaceUtils.getStatusMessage(allFinancialRequests.get(i).getStatusCode()));	
			allFinancialRequests.get(i).setRequestTypeMessage(BankInterfaceUtils.getTypeMessage(allFinancialRequests.get(i).getRequestTypeId()));      				
        }	
        // if a subject is linked to a result, it can not be deleted; this attribute is
        // used to show an error message.
        request.setAttribute("showError", request.getParameter("showError"));
        
        request.setAttribute("currentPageNumber", currentPageNumber);
        request.setAttribute("allFinancialRequests", allFinancialRequests);
        request.setAttribute("allAcademicYears", allAcademicYears);        
        request.setAttribute("statusCodeSelection", statusCode);
        request.setAttribute("errorCodeSelection", errorCode);    
        if(studentCode != null){
        	request.setAttribute("studentCode", studentCode); 
        }
        request.setAttribute("financialRequestIdParam", financialRequestId);
        request.setAttribute("fromReceivedDate", fromReceivedDateAsString==null?"":fromReceivedDateAsString);
        request.setAttribute("untilReceivedDate", untilReceivedDateAsString==null?"":untilReceivedDateAsString);
          
        return request;
    }

	   /**
	     * {@inheritDoc}.
	     * @see org.springframework.web.servlet.mvc.SimpleFormController
	     *      #onSubmit(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse
	     *               , java.lang.Object, org.springframework.validation.BindException)
	     */
	    @Override
	    protected ModelAndView onSubmit(HttpServletRequest request
	            , HttpServletResponse response, Object command, BindException errors)
	    throws Exception {
			int statusCode = -1;
			int errorCode = -1;
			String fromReceivedDate = null;
			String untilReceivedDate = null;
			String studentCode = null;
			String financialRequestId = null;
//			String tuitionFee75ProcentPaid = "";
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
//			if(request.getParameter("tuitionFee75Procent")!=null &&!"".equals(request.getParameter("tuitionFee75Procent").toString())){
//					tuitionFee75ProcentPaid="on";
//			}
 	        String[] requestIds = request.getParameterValues("financialRequestId");
	        String processedToTransaction = request.getParameter("progressToTransaction");
	        String errorReported = request.getParameter("errorReported");
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
	        if("true".equals(request.getParameter("submitPressed"))&& requestIds !=null){
		        if(processedToTransaction.equals("on")){
		        	bankInterfaceUnzaUtils.processToFinancialTransaction(requestIds);
		        }
		        if(errorReported.equals("on")){
		        	bankInterfaceUnzaUtils.setErrorReported(requestIds, request);
		        }
	        }
	        redirect.append("redirect:/unza/financialRequests.view?tab=");
            redirect.append(tab + "&panel=" + panel); 
            redirect.append("&currentPageNumber=" + currentPageNumber);
            redirect.append("&statusCodeSelectionRedirect=" + statusCode);
            redirect.append("&errorCodeSelectionRedirect="+errorCode);
            redirect.append("&fromReceivedDateRedirect="+fromReceivedDate);
            redirect.append("&untilReceivedDateRedirect="+untilReceivedDate);
            redirect.append("&studentCodeRedirect="+studentCode);
            redirect.append("&financialRequestIdParamRedirect="+financialRequestId);
//            redirect.append("&tuitionFee75ProcentRedirect="+tuitionFee75ProcentPaid);
	    	
            this.setSuccessView(redirect.toString());
	    	

	        return new ModelAndView(this.getSuccessView()); 
	    }
	   
	   
	public final String getViewName() {
		return viewName;
	}

	public final void setViewName(String viewName) {
		this.viewName = viewName;
	}
    
}
