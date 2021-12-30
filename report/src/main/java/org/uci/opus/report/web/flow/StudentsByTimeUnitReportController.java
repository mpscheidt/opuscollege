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

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.persistence.ReportMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.report.config.ReportConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping(value = "/report/studentsByTimeUnit.view")
public class StudentsByTimeUnitReportController extends OpusReportsController2 {

    private static Logger log = LoggerFactory.getLogger(StudentsByTimeUnitReportController.class);

    private String viewName;

    @Autowired
    private SecurityChecker securityChecker;
    @Autowired
    private OpusMethods opusMethods;
    @Autowired
    private StudyManagerInterface studyManager;
    @Autowired
    private LookupCacher lookupCacher;
    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private ReportMapper reportMapper;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    @Autowired
    private MessageSource messageSource;

    public StudentsByTimeUnitReportController() {
        viewName = "/report/report/studentsByTimeUnit";
    }

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        securityChecker.checkSessionValid(session);
        /* set menu to report */
        session.setAttribute("menuChoice", "report");

        ModelAndView mav = new ModelAndView(viewName);

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Map<String, Object> parameterMap = loadAndMakeParameterMap(fb, request, session, null);

        String reportFormat = ServletUtil.getStringValueSetOnSession(session, request, "reportFormat",
                ReportConstants.REPORT_FORMAT_DEFAULT);

        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "StudentsPerStudyGradeAcadyear");
        String titleKey = ServletUtil.getParamSetAttrAsString(request, "titleKey", "jsp.studentsreports.studentsByTimeUnit");

        String reportFlavour = ServletUtil.getParamSetAttrAsString(request, "reportFlavour", "");
        String studyPlanStatusCode = ServletUtil.getParamSetAttrAsString(request, "studyPlanStatusCode", "0");
        String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "").trim();

        String orderBy = ServletUtil.getStringValueSetOnSession(session, request, "orderBy", "");
        String nameFormat = ServletUtil.getParamSetAttrAsString(request, "nameFormat", ReportConstants.NAME_FORMAT_DEFAULT);

        ServletUtil.getParamSetAttrAsBoolean(request, "multiSelect", true);

        // get academic years , statusCode...
        // lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);

        parameterMap.put("searchValue", searchValue);

        String operation = request.getParameter("operation");

        if (StringUtil.isNullOrEmpty(operation, true)) {

        	int count = 0;

            // instructs the page to show all items regardless of the number of items exceed the MAX_DISPLAY_ITEMS
        	boolean loadItems = ServletUtil.getParamSetAttrAsBoolean(request, "showAll", false);
            
            if (!loadItems) {
            	// The count query shall only be executed if showAll is false, to avoid an unnecessary query
            	// If showAll is false, we need to count to see if it makes sense to load items now or ask user 
            	count = reportMapper.findCTUStudygradetypesCount(parameterMap);
            	loadItems = count <= ReportConstants.MAX_DISPLAY_ITEMS;
            }

            if (loadItems ) {
            	List<Map<String, Object>> items = reportMapper.findCTUStudygradetypes(parameterMap);
            	mav.addObject("items", items);
            	count = items.size();
            }

            mav.addObject("ITEM_COUNT", count);
            mav.addObject("MAX_DISPLAY_ITEMS", ReportConstants.MAX_DISPLAY_ITEMS);

        } else if ("makereport".equalsIgnoreCase(operation)) {

            String requestWhereClause = reportController.generateSQLWhereClause(request);

            // at least one row needs to be selected
            if (requestWhereClause == null || requestWhereClause.trim().isEmpty()) {
                // avoid displaying all results but show empty report
                requestWhereClause = " AND false ";
            }

            Locale locale = OpusMethods.getPreferredLocale(request);

            /* custom name for when downloading the file */
            String downloadFileName = ServletUtil.getParamSetAttrAsString(request, "downloadFileName",
                    messageSource.getMessage(titleKey, null, locale));
            downloadFileName += "_" + DateFormat.getDateInstance(DateFormat.SHORT).format(new Date());// add date to file name
            downloadFileName = downloadFileName.replaceAll("\\s+", "_");
            downloadFileName = downloadFileName.replaceAll("/", "-");// date '/' may not be accepted as a valid character file name

            mav = reportController.createReport(session, reportName + reportFlavour, requestWhereClause, downloadFileName, reportFormat,
                    locale);

            // orderBy = request.getParameter("orderBy");
            String orderClause = null;
            if (orderBy != null && !orderBy.isEmpty()) {
                orderClause = "," + orderBy;
            }

            StringBuilder whereClause = new StringBuilder();
            // if (academicYearId != 0) {
            // whereClause.append(" AND studyplandetail.academicyearid=").append(academicYearId);
            // }

            if (!"0".equals(studyPlanStatusCode)) {
                // as status code is of type varchar it must be wrapped in
                // quotes
                // for running the query in jasper report
                whereClause.append(" AND studyplan.studyplanstatuscode=");
                whereClause.append("'");
                whereClause.append(studyPlanStatusCode);
                whereClause.append("'");
            }

            reportController.putModelParameter(mav, "lang", preferredLanguage);
            reportController.putModelParameters(mav, getUserProperties(reportName));
            if (orderClause != null)
                reportController.putModelParameter(mav, "orderClause", orderClause);
            reportController.addWhereClause(mav, whereClause.toString());
            reportController.putModelParameter(mav, "nameFormat", nameFormat);

            if (searchValue != null && !searchValue.isEmpty()) {
                reportController.addWhereClause(mav, " AND person.surnameFull ILIKE '%" + searchValue + "%' ");
            }
        }
        return mav;
    }

    @Override
	public void setViewName(String viewName) {
        this.viewName = viewName;
    }

}
