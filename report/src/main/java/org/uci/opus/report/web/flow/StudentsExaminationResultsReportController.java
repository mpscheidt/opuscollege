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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.auth.AssignedUserApplication;
import org.uci.opus.college.web.form.ReportForm;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.report.config.ReportConstants;
import org.uci.opus.report.service.SubjectsReportsManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * @author Stelio Macumbe - August 14 - 2014
 */
@Controller
@SessionAttributes({ "reportForm" })
@RequestMapping(value = "/report/studentsexaminationresults.view")
public class StudentsExaminationResultsReportController extends OpusReportsController2 {

    private static Logger log = LoggerFactory.getLogger(StudentsExaminationResultsReportController.class);

    @Autowired
    private AssignedUserApplication assignedUserApplication;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private SubjectsReportsManagerInterface subjectsReportsManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    private String viewName;

    @Autowired
    public StudentsExaminationResultsReportController(ReportPropertyMapper reportPropertyMapper, ReportController reportController) {
        super();
        this.reportPropertyMapper = reportPropertyMapper;
        this.reportController = reportController;
        viewName = "/report/report/studentsExaminationResults";
    }

    @RequestMapping(method = RequestMethod.GET)
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        ModelAndView mav = new ModelAndView();

        securityChecker.checkSessionValid(session);
        session.setAttribute("menuChoice", "report");
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        Map<String, Object> additionalFindParams = new HashMap<>();
        Map<String, Object> parameterMap = this.loadAndMakeParameterMap(fb, request, session, additionalFindParams);

        // Logged-in user has to have the privilege to read all students or be assigned to the subject or examination
        // Note: It should be fine if the subject teacher has read-access to examinations, therefore subject-or-examination, not examination
        // only
        assignedUserApplication.applyAssignedStaffMember(request, parameterMap, "subjectOrExaminationStaffMemberId");

        ReportController.getParamSetAttrReportFormat(request);
        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");
        String orderBy = ServletUtil.getParamSetAttrAsString(request, "orderBy", "person_surnamefull");
        String nameFormat = ServletUtil.getParamSetAttrAsString(request, "nameFormat", ReportConstants.NAME_FORMAT_SURNAME_FIRSTNAMES);
        int subjectId = ServletUtil.getParamSetAttrAsInt(request, "subjectId", 0);

        String statusCode = ServletUtil.getParamSetAttrAsString(request, "statusCode", "0");
        String reportFormat = ServletUtil.getParamSetAttrAsString(request, "reportFormat", ReportConstants.REPORT_FORMAT_DEFAULT);

        ServletUtil.getParamSetAttrAsString(request, "titleKey", "jsp.studentsreports.studentsByTimeUnit");
        ServletUtil.getParamSetAttrAsBoolean(request, "multiSelect", true);

        parameterMap.put("searchValue", searchValue);
        parameterMap.put("subjectId", subjectId);

        mav.setViewName(viewName);

        request.setAttribute("action", "/report/studentsexaminationresults.view");

        opusMethods.removeSessionFormObject("reportForm", session, null, opusMethods.isNewForm(request));

        ReportForm reportForm = (ReportForm) session.getAttribute("reportForm");
        if (reportForm == null) {

            String reportName = request.getParameter("reportName");
            reportForm = new ReportForm();

            reportForm.setReportName(reportName);

        }
        mav.addObject("reportForm", reportForm);
        String operation = request.getParameter("operation");

        if (StringUtil.isNullOrEmpty(operation, true)) {

            List<Map<String, Object>> allExaminations = subjectsReportsManager.findExaminationsAsMaps(parameterMap);
            request.setAttribute("allExaminations", allExaminations);
            request.setAttribute("MAX_DISPLAY_ITEMS", ReportConstants.MAX_DISPLAY_ITEMS);
            // instructs the page to show all items regardless of the number of items exceed the MAX_DISPLAY_ITEMS
            ServletUtil.getParamSetAttrAsString(request, "showAll", "false");

        } else if (operation.equalsIgnoreCase("makereport")) {

            StringBuffer whereClause = new StringBuffer();
            orderBy = request.getParameter("orderBy");
            StringBuffer orderClause = new StringBuffer();

            if (!"0".equals(statusCode)) {
                // as status code is of type varchar it must be wrapped in quotes
                // for running the query in jasper report
                whereClause.append(" AND student.statuscode=");
                whereClause.append("'");
                whereClause.append(statusCode);
                whereClause.append("'");
            }

            // 2015-06-07 commented the following because unclear how this would be useful - report should be independent of any filters
            // if (parameterMap.containsKey("organizationalUnitId")) {
            // int organizationalUnitId = (Integer) parameterMap.get("organizationalUnitId");
            //
            // whereClause.append(" AND organizationalunit.id in (SELECT id FROM opuscollege.crawl_tree(");
            // whereClause.append(organizationalUnitId).append(", 0))");
            // }

            // Append order by clause to the end of the query
            // in order to the students by subject reports works properly, it
            // must be first ordered by subject_id
            orderClause.append(",");
            orderClause.append(orderBy);

            Locale locale = OpusMethods.getPreferredLocale(request);
            String requestWhereClause = reportController.generateSQLWhereClause(request);

            // at least one row needs to be selected
            if (requestWhereClause == null || requestWhereClause.trim().isEmpty()) {
                // avoid displaying all results but show empty report
                requestWhereClause = " AND false ";
            }
            mav = reportController.createReport(session, reportForm.getReportName(), requestWhereClause, reportFormat, locale);
            reportController.addWhereClause(mav, whereClause.toString());
            reportController.putModelParameter(mav, "lang", preferredLanguage);
            reportController.putModelParameter(mav, "orderClause", orderClause.toString());
            reportController.putModelParameter(mav, "nameFormat", nameFormat);
            reportController.putModelParameters(mav, getUserProperties(reportForm.getReportName()));

        }

        return mav;
    }

    /***
     * 
     * @param subjectsReportsManager
     *            The report manager for this controller
     */
    public void setSubjectsReportsManager(SubjectsReportsManagerInterface subjectsReportsManager) {
        this.subjectsReportsManager = subjectsReportsManager;
    }
}
