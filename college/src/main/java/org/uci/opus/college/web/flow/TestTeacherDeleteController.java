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

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletContext;
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
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: ExaminationTeacherDeleteController.
 *
 */
 public class TestTeacherDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(TestTeacherDeleteController.class);
    private String viewName;
    private MessageSource messageSource;
    private SecurityChecker securityChecker;
    private ExaminationManagerInterface examinationManager;
    private TestManagerInterface testManager;
    private ResultManagerInterface resultManager;
    @Autowired private OpusMethods opusMethods;
    
    protected ModelAndView handleRequestInternal(HttpServletRequest request, 
            HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        ServletContext context = this.getServletContext();
        int testTeacherId = 0;
        int staffMemberId = 0;
        int tab = 0;
        int panel = 0;
        String showTestTeacherError = "";
        int testId = 0;
        int examinationId = 0;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form objects used yet in this controller
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("testTeacherId"))) {
        	testTeacherId = Integer.parseInt(request.getParameter("testTeacherId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("staffMemberId"))) {
            staffMemberId = Integer.parseInt(request.getParameter("staffMemberId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("testId"))) {
        	testId = Integer.parseInt(request.getParameter("testId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("examinationId"))) {
        	examinationId = Integer.parseInt(request.getParameter("examinationId"));
        }
        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);

        // delete chosen examination/teacher combination:
        if (testTeacherId != 0) {

        	Locale currentLoc = RequestContextUtils.getLocale(request);

        	TestTeacher testTeacher = null;
        	testTeacher = testManager.findTestTeacher(testTeacherId);

        	List < TestResult > testResultList = null;
            testResultList = (ArrayList < TestResult >) 
            				resultManager.findTestResults(
            				        testTeacher.getTestId());
            if (testResultList.size() != 0) {
                for (int i = 0; i < testResultList.size(); i++) {
                    // only NOT delete if actual staffmember is in the list:
                	if (testResultList.get(i).getStaffMemberId()
                            == testTeacher.getStaffMemberId()) {
                		// show error for linked results
                	    showTestTeacherError = messageSource.getMessage(
                                "jsp.error.testteacher.delete"
                                , null, currentLoc);
                	    showTestTeacherError = showTestTeacherError + messageSource.getMessage(
                                            "jsp.error.general.delete.linked.testresult"
                                            , null, currentLoc);
                	}
                }
            }
            if (StringUtil.isNullOrEmpty(showTestTeacherError)) {
            	testManager.deleteTestTeacher(testTeacherId);
            }
        }

        if (staffMemberId != 0) {
            this.setViewName("redirect:/college/staffmember.view?newForm=true&tab=" + tab + "&panel=" + panel
            		        + "&staffMemberId=" + staffMemberId
            		        + "&showTestTeacherError=" + showTestTeacherError
            		        + "&currentPageNumber=" + currentPageNumber);
        }

        if (testId != 0) {
            this.setViewName("redirect:/college/test.view?newForm=true&tab=" + tab + "&panel=" + panel
            		+ "&examinationId=" + examinationId
            		+ "&testId=" + testId
            		+ "&showTestTeacherError=" + showTestTeacherError
            		 + "&currentPageNumber=" + currentPageNumber);
        }

        return new ModelAndView(viewName);
    }

    /**
     * @param viewName name of view to show; is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    /**
     * @param securityChecker
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    /**
     * @param newMessageSource
     */
    public void setMessageSource(final MessageSource newMessageSource) {
        messageSource = newMessageSource;
    }
    
    /**
     * @param newExaminationManager
     */
    public void setExaminationManager(final ExaminationManagerInterface newExaminationManager) {
    	examinationManager = newExaminationManager;
    }

	public void setResultManager(ResultManagerInterface resultManager) {
		this.resultManager = resultManager;
	}

    public void setTestManager(TestManagerInterface testManager) {
        this.testManager = testManager;
    }
    
}
