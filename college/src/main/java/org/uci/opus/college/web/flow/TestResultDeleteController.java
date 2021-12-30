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
*/

package org.uci.opus.college.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

public class TestResultDeleteController extends AbstractController {

    private Logger log = LoggerFactory.getLogger(TestResultDeleteController.class);

    private String viewName;
    private SecurityChecker securityChecker;
    private ResultManagerInterface resultManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession(false);
        int examinationResultId = 0;
        int subjectResultId = 0;
        int testResultId = 0;
        int examinationId = 0;
        int testId = 0;
        int studentId = 0;
        int tab = 0;
        int panel = 0;
        String from = "";
        StudyPlanDetail studyPlanDetail = null;
        StudyGradeType studyGradeType = null;
        TestResult testResult = null;
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller
        // opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("testResultId"))) {
            testResultId = Integer.parseInt(request.getParameter("testResultId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("examinationResultId"))) {
            examinationResultId = Integer.parseInt(request.getParameter("examinationResultId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectResultId"))) {
            subjectResultId = Integer.parseInt(request.getParameter("subjectResultId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("from"))) {
            from = request.getParameter("from");
        }

        // if ("testresults".equals(from)) {
        // if (!StringUtil.isNullOrEmpty(request.getParameter("examinationId"))) {
        // examinationId = Integer.parseInt(request.getParameter("examinationId"));
        // }
        // if (!StringUtil.isNullOrEmpty(request.getParameter("testId"))) {
        // testId = Integer.parseInt(request.getParameter("testId"));
        // }
        // }

        // delete chosen test:
        if (testResultId != 0) {
            testResult = resultManager.findTestResult(testResultId);
            resultManager.deleteTestResult(testResultId, opusMethods.getWriteWho(request));
        }

        if (testResult != null && testResult.getStudyPlanDetailId() != 0) {
            studyPlanDetail = studentManager.findStudyPlanDetail(testResult.getStudyPlanDetailId());
            studyGradeType = studyManager.findStudyGradeType(studyPlanDetail.getStudyGradeTypeId());
            examinationId = testResult.getExaminationId();
            testId = testResult.getTestId();
        }

        if ("testresults".equals(from)) {
            this.setViewName("redirect:/college/testresults.view?newForm=true&tab=" + tab + "&panel=" + panel + "&testId=" + testId + "&examinationId="
                    + examinationId + "&studyPlanDetailId=" + studyPlanDetail.getId() + "&studyGradeTypeId=" + studyPlanDetail.getStudyGradeTypeId()
                    + "&chosenAcademicYearId=" + studyGradeType.getCurrentAcademicYearId() + "&currentPageNumber=" + currentPageNumber);
        } else {
            this.setViewName("redirect:/college/examinationresult.view?newForm=true&tab=" + tab + "&panel=" + panel + "&studentId=" + studentId
                    + "&examinationResultId=" + examinationResultId + "&subjectResultId=" + subjectResultId + "&studyPlanDetailId="
                    + testResult.getStudyPlanDetailId() + "&examinationId=" + testResult.getExaminationId()
                    // + "&subjectId=" + examinationResult.getSubjectId()
                    + "&currentPageNumber=" + currentPageNumber);
        }
        return new ModelAndView(viewName);
    }

    /**
     * @param viewName
     *            name of view to show; is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setResultManager(final ResultManagerInterface resultManager) {
        this.resultManager = resultManager;
    }

}
