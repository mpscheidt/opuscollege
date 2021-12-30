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
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

public class SubjectBlockStudyGradeTypeDeleteController extends AbstractController {

    private Logger log = LoggerFactory.getLogger(SubjectBlockStudyGradeTypeDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private SubjectManagerInterface subjectManager;
    private MessageSource messageSource;
    private ResultManagerInterface resultManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudentManagerInterface studentManager;

    @Autowired private List <Module> modules;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public SubjectBlockStudyGradeTypeDeleteController() {
        super();
    }

    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession(false);        

        int tab = 0;
        int panel = 0;
        int subjectBlockStudyGradeTypeId = 0;
        int subjectBlockId = 0;
        int studyId = 0;
        String showSubjectBlockStudyGradeTypeError = "";
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller yet
        //       opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockStudyGradeTypeId"))) {
            subjectBlockStudyGradeTypeId = Integer.parseInt(
                    request.getParameter("subjectBlockStudyGradeTypeId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectBlockId"))) {
            subjectBlockId = Integer.parseInt(request.getParameter("subjectBlockId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
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

        // delete chosen subjectStudyGradeType
        if (subjectBlockStudyGradeTypeId != 0) {

            Map<String, Object> findSubjectBlockStudyGradeTypeMap = new HashMap<>();
            findSubjectBlockStudyGradeTypeMap.put("preferredLanguage", preferredLanguage);
            findSubjectBlockStudyGradeTypeMap.put("subjectBlockStudyGradeTypeId", subjectBlockStudyGradeTypeId);

            Locale currentLoc = RequestContextUtils.getLocale(request);

            Map<String, Object> findResultsMap = new HashMap<>();
            findResultsMap.put("subjectBlockId", subjectBlockId);
            findResultsMap.put("studyGradeTypeId", subjectBlockStudyGradeTypeId);

            // subjectBlockStudyGradeType cannot be deleted if a subjectresult belongs to it
            List < SubjectResult > subjectResultList = null;
            subjectResultList = resultManager.findSubjectResultsForSubjectBlockStudyGradeType(
                    findResultsMap);
            if (subjectResultList.size() != 0) {
                // show error for linked results
                showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                + messageSource.getMessage(
                        "jsp.error.subjectblockstudygradetype.delete", null, currentLoc);
                showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                + messageSource.getMessage(
                        "jsp.error.general.delete.linked.subjectresult", null, currentLoc);
            } else {
                // subjectblockstudygradetype cannot be deleted if an examinationresult belongs to it
                List<ExaminationResult> examinationResults = null;
                List<ExaminationResult> examinationResultList = null;
                ExaminationResult examinationResult = null;
                examinationResults = resultManager.findExaminationResultsForSubjectBlockStudyGradeType(
                        findResultsMap);
                for (int i = 0; i < examinationResults.size(); i++) {
                    examinationResult = (ExaminationResult) examinationResults.get(i);
                    examinationResultList = resultManager.findExaminationResults(
                            examinationResult.getExaminationId());
                    if (examinationResultList.size() != 0 && showSubjectBlockStudyGradeTypeError == "") {
                        // show error for linked examination results
                        showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                        + messageSource.getMessage(
                                "jsp.error.subjectblockstudygradetype.delete", null, currentLoc);
                        showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                        + messageSource.getMessage(
                                "jsp.error.general.delete.linked.examinationresult", null, currentLoc);
                    } else {
                        // subjectstudygradetype cannot be deleted if a testresult belongs to it
                        List<TestResult> testResults = null;
                        List<TestResult> testResultList = null;
                        TestResult testResult = null;
                        testResults = resultManager.findTestResultsForSubjectBlockStudyGradeType(
                                findResultsMap);
                        for (int j = 0; j < testResults.size(); j++) {
                            testResult = (TestResult) testResults.get(i);
                            testResultList = resultManager.findTestResults(
                                    testResult.getTestId());
                            if (testResultList.size() != 0 
                                    && showSubjectBlockStudyGradeTypeError == "") {
                                // show error for linked examination results
                                showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                                + messageSource.getMessage(
                                        "jsp.error.subjectblockstudygradetype.delete", null, currentLoc);
                                showSubjectBlockStudyGradeTypeError = showSubjectBlockStudyGradeTypeError
                                + messageSource.getMessage(
                                        "jsp.error.general.delete.linked.testresult", null, currentLoc);
                            }
                        }
                    }
                }
            }

            // if no error yet, check if there are study plan details linked to this subjectBlockStudyGradeType
            if (StringUtil.isNullOrEmpty(showSubjectBlockStudyGradeTypeError)) {
                List<? extends StudyPlanDetail> studyPlanDetails = studentManager
                .findStudyPlanDetailsForSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);
                if (studyPlanDetails != null && studyPlanDetails.size() > 0) {
                    showSubjectBlockStudyGradeTypeError = messageSource.getMessage(
                            "jsp.error.subjectblockstudygradetype.delete", null, currentLoc)
                            + " "
                            + messageSource.getMessage(
                                    "jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
                }
            }

            if (StringUtil.isNullOrEmpty(showSubjectBlockStudyGradeTypeError)) {
                subjectManager.deleteSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId, request);
            }
        }

        return new ModelAndView("redirect:/college/subjectblock.view?newForm=true&tab=" 
                + tab + "&panel=" + panel
                + "&studyId=" + studyId
                + "&subjectBlockId="+subjectBlockId
                + "&showSubjectBlockStudyGradeTypeError=" + showSubjectBlockStudyGradeTypeError
                + "&currentPageNumber=" + currentPageNumber
        );

    }

    /**
     * @return Returns the viewName.
     */
    public String getViewName() {
        return viewName;
    }

    /**
     * @param viewName is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    /**
     * @param securityChecker The securityChecker to set.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    /**
     * @param examinationManager The examinationManager to set.
     */
    public void setResultManager(ResultManagerInterface resultManager) {
        this.resultManager = resultManager;
    }

    /**
     * @param subjectManager The subjectManager to set.
     */
    public void setSubjectManager(final SubjectManagerInterface subjectManager) {
        this.subjectManager = subjectManager;
    }

    /**
     * @param messageSource The messageSource to set.
     */
    public void setMessageSource(MessageSource messageSource) {
        this.messageSource = messageSource;
    }
}
