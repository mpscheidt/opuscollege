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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * Simple <code>Controller</code> for Statistics reports.
 *
 * @author Markus Pscheidt, Andreas Putscher
 */
public class StatisticsController extends OpusReportsController {

    private static Logger log = LoggerFactory.getLogger(StatisticsController.class);

    private SecurityChecker securityChecker;
    private OpusMethods opusMethods;
    private StudyManagerInterface studyManager;
    private LookupCacher lookupCacher;
    private StudentManagerInterface studentManager;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    private String viewName = "report/report/statisticsoverview";
    private AcademicYearManagerInterface academicYearManager;


    @Autowired
    public StatisticsController(SecurityChecker securityChecker,
            OpusMethods opusMethods, StudyManagerInterface studyManager,
            LookupCacher lookupCacher, StudentManagerInterface studentManager, ReportPropertyMapper reportPropertyMapper, AcademicYearManagerInterface academicYearManager) {
        super();
        this.securityChecker = securityChecker;
        this.opusMethods = opusMethods;
        this.studyManager = studyManager;
        this.lookupCacher = lookupCacher;
        this.studentManager = studentManager;
        this.reportPropertyMapper = reportPropertyMapper;
        this.academicYearManager = academicYearManager;
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
        fb.setSubjectBlockMapper(subjectBlockMapper);

        this.loadAndMakeParameterMap(fb, request, session, new HashMap<String, Object>());

        ReportController.getParamSetAttrReportFormat(request);
        String academicYear = ServletUtil.getParamSetAttrAsString(request, "academicYear", "0");

        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());

        request.setAttribute("action", "/report/statisticsoverview.view");
        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "StatsActiveStudies");

        lookupCacher.getStudentLookups(preferredLanguage, request);
        mav.setViewName(viewName);

        if ("makestatisticsreport".equalsIgnoreCase(request.getParameter("operation"))) {
            ReportController reportController = (ReportController) getApplicationContext().getBean("reportController");
            mav = reportController.createReport(request);

            //remove the directory name from the report name
            //only the report name is saved in the database when storing properties
            reportName = reportName.substring(reportName.indexOf("/") + 1).trim();

            reportController.putModelParameters(mav, getUserProperties(reportName));
            reportController.putModelParameter(mav, "lang", preferredLanguage);
            reportController.putModelParameter(mav, "year", new Integer(academicYear));
            //            reportController.putModelParameter(mav, "academicYearDescription", academicYearDescription);
        }
        return mav;
    }


}
