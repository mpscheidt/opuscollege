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
import org.uci.opus.college.domain.SubjectStudyGradeType;
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

/**
 * Servlet implementation class for Servlet: StudyGradeTypeSubjectDeleteController.
 *
 */
 public class StudyGradeTypeSubjectDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(StudyGradeTypeSubjectDeleteController.class);
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
    public StudyGradeTypeSubjectDeleteController() {
        super();
    }

    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        
        int tab = 0;
        int panel = 0;
        int subjectStudyGradeTypeId = 0;
        int subjectId = 0;
        int studyId = 0;
        String showSubjectStudyGradeTypeError = "";
        int studyGradeTypeId = 0;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyGradeTypeId"))) {
            subjectStudyGradeTypeId = Integer.parseInt(
                                        request.getParameter("subjectStudyGradeTypeId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
            subjectId = Integer.parseInt(request.getParameter("subjectId"));
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
        if (subjectStudyGradeTypeId != 0) {
            
            Map<String, Object> findSubjectStudyGradeTypeMap = new HashMap<>();
            findSubjectStudyGradeTypeMap.put("preferredLanguage", preferredLanguage);
            findSubjectStudyGradeTypeMap.put("subjectStudyGradeTypeId", subjectStudyGradeTypeId);
            SubjectStudyGradeType subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(
                    findSubjectStudyGradeTypeMap);
            
            studyGradeTypeId = subjectStudyGradeType.getStudyGradeTypeId();
        	Locale currentLoc = RequestContextUtils.getLocale(request);

            Map<String, Object> findResultsMap = new HashMap<>();
            findResultsMap.put("subjectId", subjectId);
            findResultsMap.put("studyGradeTypeId", subjectStudyGradeTypeId);

        	// subjectstudygradetype cannot be deleted if a subjectresult belongs to it
        	List < SubjectResult > subjectResultList = null;
            subjectResultList = resultManager.findSubjectResultsForSubjectStudyGradeType(findResultsMap);
            if (subjectResultList.size() != 0) {
                // show error for linked results
            	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
            			+ messageSource.getMessage(
            			"jsp.error.subjectstudygradetype.delete", null, currentLoc);
            	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
            			+ messageSource.getMessage(
                        "jsp.error.general.delete.linked.subjectresult", null, currentLoc);
            } else {
            	// subjectstudygradetype cannot be deleted if an examinationresult belongs to it
                List<ExaminationResult> examinationResults = null;
                List<ExaminationResult> examinationResultList = null;
                ExaminationResult examinationResult = null;
                examinationResults = resultManager.findExaminationResultsForSubjectStudyGradeType(
                        findResultsMap);
                for (int i = 0; i < examinationResults.size(); i++) {
                	examinationResult = (ExaminationResult) examinationResults.get(i);
	                examinationResultList = resultManager.findExaminationResults(
	                		examinationResult.getExaminationId());
	                if (examinationResultList.size() != 0 && showSubjectStudyGradeTypeError == "") {
	                    // show error for linked examination results
	                	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
	                		+ messageSource.getMessage(
	                    	"jsp.error.subjectstudygradetype.delete", null, currentLoc);
	                	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
	                		+ messageSource.getMessage(
	                        "jsp.error.general.delete.linked.examinationresult", null, currentLoc);
	                } else {
	                    // subjectstudygradetype cannot be deleted if a testresult belongs to it
	                    List<TestResult> testResults = null;
	                    List<TestResult> testResultList = null;
	                    TestResult testResult = null;
	                    testResults = resultManager.findTestResultsForSubjectStudyGradeType(
	                            findResultsMap);
	                    for (int j = 0; j < testResults.size(); j++) {
	                        testResult = (TestResult) testResults.get(i);
	                        testResultList = resultManager.findTestResults(
	                                testResult.getTestId());
	                        if (testResultList.size() != 0 
	                                            && showSubjectStudyGradeTypeError == "") {
	                            // show error for linked examination results
	                        	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
	                                + messageSource.getMessage(
	                                "jsp.error.subjectstudygradetype.delete", null, currentLoc);
	                        	showSubjectStudyGradeTypeError = showSubjectStudyGradeTypeError
	                                + messageSource.getMessage(
	                                "jsp.error.general.delete.linked.testresult", null, currentLoc);
	                        }
	                    }
	                }
                }
            }

            // if no error yet, check if there are study plan details linked to this subjectStudyGradeType
            if (StringUtil.isNullOrEmpty(showSubjectStudyGradeTypeError)) {
                List<? extends StudyPlanDetail> studyPlanDetails = studentManager
                        .findStudyPlanDetailsForSubjectStudyGradeType(subjectStudyGradeTypeId);
                if (studyPlanDetails != null && studyPlanDetails.size() > 0) {
                    showSubjectStudyGradeTypeError = messageSource.getMessage(
                            "jsp.error.subjectstudygradetype.delete", null, currentLoc)
                            + " "
                            + messageSource.getMessage(
                            "jsp.error.general.delete.linked.studyplandetail", null, currentLoc);
                }
            }

            if (StringUtil.isNullOrEmpty(showSubjectStudyGradeTypeError)) {
            	subjectManager.deleteSubjectStudyGradeType(subjectStudyGradeTypeId, request);
            }
        }
        return new ModelAndView("redirect:/college/studygradetype.view?newForm=true&tab=" 
        		+ tab + "&panel=" + panel + "&studyGradeTypeId=" + studyGradeTypeId
                + "&studyId=" + studyId
                + "&showSubjectStudyGradeTypeError=" + showSubjectStudyGradeTypeError
                + "&currentPageNumber=" + currentPageNumber);
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
