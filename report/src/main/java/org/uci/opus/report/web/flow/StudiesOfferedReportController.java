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
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.college.web.util.ReportControllerUtil;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.report.config.ReportConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * @author Andreas Putscher - 8.1.2008 
 */
@Controller
@RequestMapping(value="/report/studiesoffered.view")
public class StudiesOfferedReportController extends OpusReportsController {

    private static Logger log = LoggerFactory.getLogger(StudiesOfferedReportController.class);

    private String viewName;

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private MessageSource messageSource;

    public StudiesOfferedReportController() {
    	super();
    	viewName = "/report/report/studiesoffered";
	
    }
    
    @Override
	public ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        
        ModelAndView mav = new ModelAndView();

        securityChecker.checkSessionValid(session);
        
        session.setAttribute("menuChoice", "report");
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);

        Map<String, Object> parameterMap = this.loadAndMakeParameterMap(fb, request, session, new HashMap<String, Object>());

        String reportFormat = ServletUtil.getStringValueSetOnSession(session,
                request, "reportFormat", ReportConstants.REPORT_FORMAT_DEFAULT);

        String reportName = ServletUtil.getParamSetAttrAsString(request,
                "reportName", "StudiesOffered");

        Locale locale = OpusMethods.getPreferredLocale(request);

        ReportController.getParamSetAttrReportFormat(request);
        mav.setViewName("/report/report/studiesoffered");

        mav.addObject("action", "/report/studiesoffered.view");
        mav.addObject("reportName", "StudiesOffered");

        lookupCacher.getStudentLookups(preferredLanguage, request);
        mav.addObject("allAcademicYears", academicYearManager.findAllAcademicYears());
        String operation = request.getParameter("operation");

        if ("makereport".equalsIgnoreCase(operation)) {
            
            String downloadFileName = ReportControllerUtil.getDownloadFileName(request, 
            		 messageSource.getMessage("jsp.report.studiesoffered", null, locale));

            mav = reportController.createReport(session, reportName,
                    reportController.generateSQLWhereClause(request),
                    downloadFileName,
                    reportFormat, locale);

            StringBuilder whereClause = new StringBuilder();

            if (parameterMap.containsKey("organizationalUnitId")) {
                int organizationalUnitId = (Integer) parameterMap.get("organizationalUnitId");

                whereClause.append(" AND organizationalunit.id in (SELECT id FROM opuscollege.crawl_tree(");
                whereClause.append(organizationalUnitId).append(", 0))");
            }


            reportController.addWhereClause(mav, whereClause.toString());
            reportController.putModelParameter(mav, "lang", preferredLanguage);
            reportController.putModelParameters(mav, getUserProperties("studiesoffered"));
        }

        return mav;
    }
}
