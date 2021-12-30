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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.report.web.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.ReportForm;
import org.uci.opus.college.web.util.ReportControllerUtil;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.report.config.ReportConstants;
import org.uci.opus.report.service.SubjectsReportsManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

import net.sf.jasperreports.engine.JRException;

@Controller
@RequestMapping(value="/report/reportpersubject.view")
@SessionAttributes({"reportForm"})
public class ReportPerSubjectController extends OpusReportsController2 {

    private static Logger log = LoggerFactory.getLogger(StudentCertificateReportController.class);

    private String viewName;
    
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private MessageSource messageSource;
    @Autowired private SubjectsReportsManagerInterface subjectsReportsManager;

    //TODO refactor this controller Should use same controller as studentprofile sheet
    public ReportPerSubjectController() {
        super();
        viewName = "/report/report/reportpersubject";
    }

    @InitBinder
    protected final void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws ServletException {

        binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
    }

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

	   HttpSession session = request.getSession(false);

       securityChecker.checkSessionValid(session);
       /* set menu to report */
       session.setAttribute("menuChoice", "report");
       String preferredLanguage = OpusMethods.getPreferredLanguage(request);
       Locale locale = OpusMethods.getPreferredLocale(request);

       StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
       fb.setSubjectBlockMapper(subjectBlockMapper);
       Map<String, Object> parameterMap = this.loadAndMakeParameterMap(fb, request, session, null);
       ModelAndView mav = new ModelAndView(viewName);

       String reportFormat = ServletUtil.getParamSetAttrAsString(request, "reportFormat", "pdf");
       String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "StudentsResults");
       String orderBy = ServletUtil.getParamSetAttrAsString(request, "orderBy", "person_surnamefull");
       String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "").trim();
       
      String operation = request.getParameter("operation");
       
       parameterMap.put("searchValue", searchValue.trim());
       
       mav.addObject("action", "/report/reportpersubject.view");
       mav.addObject("titleKey", request.getParameter("titleKey"));
       
       ReportForm reportForm = null;
       
       opusMethods.removeSessionFormObject("reportForm", session, opusMethods.isNewForm(request));
       
       if ((ReportForm) session.getAttribute("reportForm") != null) {
       	reportForm = (ReportForm) session.getAttribute("reportForm");
       } else {

    	 // String reportName = request.getParameter("reportName");
       	reportForm = new ReportForm();
       	
    	String reportDir = session.getServletContext().getRealPath(
		"/WEB-INF/reports/jasper/");

    	
		String reportPath = reportDir + System.getProperty("file.separator") +
				 reportName + ".jasper";

       	reportForm.setProperties(ReportControllerUtil.getReportPropertiesFromFile(reportPath, reportName, messageSource, locale));
       	reportForm.setReportName(reportName);
       	
       	//session.setAttribute("reportForm", reportForm);
       	
       	//request.setAttribute("reportForm", reportForm);
       	
       }
       mav.addObject("reportForm", reportForm);
       
       if (StringUtil.isNullOrEmpty(operation ,true)) {
    	   
    	   
    	   List<Map<String, Object>> subjects = subjectsReportsManager.findStudyPlanSubjectsAsMap(parameterMap);
           mav.addObject("allSubjects", subjects);
           mav.addObject("MAX_DISPLAY_ITEMS", ReportConstants.MAX_DISPLAY_ITEMS);
           // instructs the page to show all items regardless of the number of items exceed the MAX_DISPLAY_ITEMS
           ServletUtil.getParamSetAttrAsString(request, "showAll", "false");

         /*  //List<Student> matches = this.studentReportManager.findStudentsByName(parameterMap);
           List<Map<String , Object>> students = this.studentReportManager.findStudentsByNameAsMaps(parameterMap);

           mav.addObject("students", students);

           mav.addObject("MAX_DISPLAY_ITEMS", ReportConstants.MAX_DISPLAY_ITEMS);
           
           //instructs the page to show all items regardless of the number of items exceed the MAX_DISPLAY_ITEMS 
           ServletUtil.getParamSetAttrAsString(request, "showAll", "false");
           */

       } else if ("makereport".equalsIgnoreCase(operation)) {

           String requestWhereClause = reportController.generateSQLWhereClause(request);
           
           // at least one student needs to be selected
           if (requestWhereClause == null || requestWhereClause.trim().isEmpty()) {
           	// avoid displaying all results but show empty report
           	requestWhereClause = " AND false ";
           }

           String downloadFileName = ServletUtil.getParamSetAttrAsString(request, "downloadFileName"
					//	, messageSource.getMessage("jsp.general." + reportForm.getReportName().toLowerCase(), null, locale));
           , messageSource.getMessage("report.studentdeclaration.title", null, locale));
           //spaces cause the name to be incomplete
           downloadFileName = downloadFileName.replaceAll("\\s+", "_");
           
			mav = reportController.createReport(session, reportForm.getReportName(),
                   requestWhereClause,
                   downloadFileName ,  reportFormat, locale);

           StringBuilder whereClause = new StringBuilder();

           if (parameterMap.containsKey("organizationalUnitId")) {
               int organizationalUnitId = (Integer) parameterMap.get("organizationalUnitId");

               whereClause.append(" AND organizationalunit.id in (SELECT id FROM opuscollege.crawl_tree(");
               whereClause.append(organizationalUnitId).append(", 0))");
           }

           //get global properties from database
           Map<String, Object> allProperties = getUserProperties(reportForm.getReportName().toLowerCase());
           
           //add and replace with custom properties from report page
           allProperties.putAll(getProperties(reportForm.getProperties()));

           reportController.addWhereClause(mav, whereClause.toString());
           reportController.putModelParameter(mav, "lang", preferredLanguage);
           reportController.putModelParameters(mav, allProperties);
       }


       return mav;

    }
	
	/**
	 * Update reportForm object
	 * @param reportForm
	 * @param result
	 * @param status
	 * @param request
	 * @return
	 * @throws JRException
	 */
	@RequestMapping(method=RequestMethod.POST)
    public ModelAndView processSubmit(
    		@ModelAttribute("reportForm") ReportForm reportForm,
            BindingResult result,  HttpServletRequest request) throws JRException {
		
			ModelAndView mav = new ModelAndView("redirect:/report/reportpersubject.view");
		   
			HttpSession session = request.getSession();
		   
			session.setAttribute("reportForm", reportForm);
          
			String operation = request.getParameter("operation");
			
			String reportFormat = ServletUtil.getParamSetAttrAsString(request, "reportFormat", "pdf");
		    String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "StudentsResults");
		    String orderBy = ServletUtil.getParamSetAttrAsString(request, "orderBy", "person_surnamefull");
		    
		    String preferredLanguage = OpusMethods.getPreferredLanguage(request);
  	        Locale locale = OpusMethods.getPreferredLocale(request);
 
			if ("makereport".equalsIgnoreCase(operation)) {

		           String requestWhereClause = reportController.generateSQLWhereClause(request);
		           
		           Map<String, Object> parameterMap = new HashMap<>();
		           
		           // at least one student needs to be selected
		           if (requestWhereClause == null || requestWhereClause.trim().isEmpty()) {
		           	// avoid displaying all results but show empty report
		           	requestWhereClause = " AND false ";
		           }
		           String downloadFileName = ServletUtil.getParamSetAttrAsString(request, "downloadFileName"
								//, messageSource.getMessage("jsp.general." + reportForm.getReportName().toLowerCase(), null, locale));
		        		   , messageSource.getMessage("report.studentdeclaration.title", null, locale));
		           //spaces cause the name to be incomplete
		           downloadFileName = downloadFileName.replaceAll("\\s+", "_");
		           
					mav = reportController.createReport(session, reportName,
		                   requestWhereClause,
		                   downloadFileName ,  reportFormat, locale);

		           StringBuilder whereClause = new StringBuilder();

		           if (parameterMap.containsKey("organizationalUnitId")) {
		               int organizationalUnitId = (Integer) parameterMap.get("organizationalUnitId");

		               whereClause.append(" AND organizationalunit.id in (SELECT id FROM opuscollege.crawl_tree(");
		               whereClause.append(organizationalUnitId).append(", 0))");
		           }

		           //get global properties from database
		           Map<String, Object> allProperties = getUserProperties("StudentsResults");
		           
		           //add and replace with custom properties from report page
		           allProperties.putAll(getProperties(reportForm.getProperties()));

		           reportController.addWhereClause(mav, whereClause.toString());
		           reportController.putModelParameter(mav, "lang", preferredLanguage);
		           reportController.putModelParameters(mav, allProperties);
		       }
			
          return mav;
	}

//    public void setViewName(String viewName) {
//        this.viewName = viewName;
//    }
    
    private Map<String,Object> getProperties(List<ReportProperty> properties){
    
    	Map<String, Object> propertiesMap = new HashMap<>();
    	
    	
    	for(ReportProperty property: properties){
    	
    		//ignore reportLogo and reportBackrounf as they are universal properties
    		if((!property.getName().equalsIgnoreCase("reportLogo")) && (!property.getName().equalsIgnoreCase("reportBackground")))
    			propertiesMap.put(property.getName(), property.getText());
    	}
    	
    	return propertiesMap;
    
    }
}