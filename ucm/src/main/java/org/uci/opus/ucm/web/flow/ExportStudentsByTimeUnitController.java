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

package org.uci.opus.ucm.web.flow;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.ReportControllerUtil;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.ucm.service.UCMManagerInterface;
import org.uci.opus.ucm.util.Utils;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
@Controller
@RequestMapping(value="/ucm/exportstudentsbytimeunit.view")
public class ExportStudentsByTimeUnitController {

    private static Logger log = LoggerFactory.getLogger(ExportStudentsByTimeUnitController.class);

    private String viewName;
    
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudentManagerInterface studentManager;
    
    @Autowired private UCMManagerInterface uCMManager;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private MessageSource messageSource;
    @Autowired private AcademicYearManagerInterface academicYearManager;

    public ExportStudentsByTimeUnitController()
    {
    	viewName = "/ucm/ucm/exportStudentsByTimeUnit";
    }

    @RequestMapping(method=RequestMethod.GET)
    public ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        securityChecker.checkSessionValid(session);
        /* set menu to report */
        session.setAttribute("menuChoice", "ucm");
        Locale currentLoc = RequestContextUtils.getLocale(request);
        ModelAndView mav = new ModelAndView(viewName);
        
        Map<String,Object> studentFieldsMap = new TreeMap<>();
        
        studentFieldsMap.put("genderCode", messageSource.getMessage("jsp.general.gender", null , currentLoc));
        studentFieldsMap.put("emailAddress", messageSource.getMessage("jsp.general.email", null , currentLoc)); 
        studentFieldsMap.put("firstNamesFull", messageSource.getMessage("jsp.general.firstnames", null , currentLoc));
        studentFieldsMap.put("surnameFull", messageSource.getMessage("jsp.general.surname", null , currentLoc));
        studentFieldsMap.put("birthDate", messageSource.getMessage("jsp.general.birthdate", null , currentLoc));
        studentFieldsMap.put("identificationType", messageSource.getMessage("jsp.general.identificationtype", null , currentLoc));
        studentFieldsMap.put("identificationNumber", messageSource.getMessage("jsp.general.identificationnumber", null , currentLoc));
        studentFieldsMap.put("studentCode", messageSource.getMessage("jsp.general.studentcode", null , currentLoc));
        studentFieldsMap.put("fullName", messageSource.getMessage("general.fullname", null , currentLoc));

        
        mav.addObject("studentFieldsMap", studentFieldsMap);

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Map<String , Object> parameterMap = ReportControllerUtil.loadAndMakeParameterMap(fb, request, session, null);
        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());

        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "ucm/StudentsExport");
        
        String studyPlanStatusCode = ServletUtil.getParamSetAttrAsString(request,
                "studyPlanStatusCode", "0");
        String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "");
        String reportFlavour = ServletUtil.getParamSetAttrAsString(request, "reportFlavour", "");
        String reportFormat = ServletUtil.getParamSetAttrAsString(request, "reportFormat", "csv");
        String orderBy = ServletUtil.getStringValueSetOnSession(session, request, "orderBy", "");
        
        String errorMessage = null;

        // get academic years , statusCode...
        //  lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
        
        parameterMap.put("lang", preferredLanguage);
        parameterMap.put("searchValue", searchValue);

        List<Map<String, Object>> items = null;

        String operation = request.getParameter("operation");
         
       
        if (StringUtil.isNullOrEmpty(operation ,true)) {
            items = uCMManager.findCTUsInStudyPlans(parameterMap);
            
            mav.addObject("items", items);
            mav.addObject("MAX_DISPLAY_ITEMS", OpusConstants.MAX_ROWCOUNT_ALLOWED);
            
            //instructs the page to show all items regardless of the number of items exceed the MAX_DISPLAY_ITEMS 
            ServletUtil.getParamSetAttrAsString(request, "showAll", "false");

        } else if ("makereport".equalsIgnoreCase(operation)) {

        	String[] studyGradeIdsCardinalTimeUnits = request.getParameterValues("studyGradeIdsCardinalTimeUnits");
        	String[] fieldsToExport = request.getParameterValues("fieldsToExport");
        	List<Map<String , Object>> students = new ArrayList<Map<String , Object>>();
        	
        	String fileContent = fieldsToExport.toString();
        	
        	if( Utils.isNullOrEmpty(fieldsToExport)
        			|| Utils.isNullOrEmpty(studyGradeIdsCardinalTimeUnits)
        			){
        		
        		fileContent = messageSource.getMessage("general.nodata", null , currentLoc);
             		if("csv".equalsIgnoreCase(reportFormat)){
            			response.setContentType("text/csv");
            		} else if("xml".equalsIgnoreCase(reportFormat)){
            			response.setContentType("text/xml");
            		}
             		
             	
        	} else {
           
         	
        		parameterMap.put("studyGradeIdsCardinalTimeUnits", studyGradeIdsCardinalTimeUnits);
         			
        		students = uCMManager.findStudentsByNameAsMaps(parameterMap);
         	
        		if("csv".equalsIgnoreCase(reportFormat)){
        			fileContent = Utils.toCsv(students, fieldsToExport);
        			response.setContentType("text/csv");
        		} else if("xml".equalsIgnoreCase(reportFormat)){
        			fileContent = Utils.toXml(students, fieldsToExport);
        			response.setContentType("text/xml");
        		}
        	}
        	
         	 /*custom name for when downloading the file */
            String downloadFileName = messageSource.getMessage("jsp.general.studentslists", null , currentLoc);
         	downloadFileName += "_" + DateFormat.getDateInstance(DateFormat.SHORT).format(new Date());//add date to file name
         	downloadFileName = downloadFileName.replaceAll("\\s+", "_");
         	downloadFileName = downloadFileName.replaceAll("/", "-");//date '/' may not be accepted as a valid character file name
         	downloadFileName += "." + reportFormat;
         
         	response.setCharacterEncoding("UTF-8");
         	response.setHeader("Content-Disposition",
         	       "attachment;filename=" + downloadFileName + "");         	      
         		  
         	       response.getWriter().write(fileContent);
         	       response.getWriter().close();
         	       
         	       return null;
         	       
         	       
        }
        return mav;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }

}
