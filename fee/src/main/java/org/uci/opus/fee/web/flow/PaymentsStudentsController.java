/*******************************************************************************
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
 * The Original Code is Opus-College fee module code.
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
 ******************************************************************************/
package org.uci.opus.fee.web.flow;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: StudentsController.
 *
 */
public class PaymentsStudentsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(PaymentsStudentsController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private OpusMethods opusMethods;
    private StudyManagerInterface studyManager;
    private LookupCacher lookupCacher;
    private StudentManagerInterface studentManager;
    @Autowired FeeLookupCacher feeLookupCacher;
    @Autowired AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusInit opusInit;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private AppConfigManagerInterface appConfigManager;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public PaymentsStudentsController() {
        super();
    }

    /** 
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *                              , javax.servlet.http.HttpServletResponse)
     */
    @Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {


        String showStudentError = "";

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to fees */
        session.setAttribute("menuChoice", "fee");

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
            showStudentError = request.getParameter("showStudentError");
        }
        request.setAttribute("showStudentError", showStudentError);

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);

        fb.initChosenValues();

        fb.doLookups();
//        request = feeLookupCacher.getFeeLookups(preferredLanguage, request);
        request.setAttribute("allFeeCategories", feeLookupCacher.getAllFeeCategories(preferredLanguage));

        fb.loadStudies();

        fb.loadStudyGradeTypes();

        fb.loadMaxCardinalTimeUnitNumber();

        // optionally extend the students here
        List allStudents = fb.loadStudents(appConfigManager, opusInit);
        
        // 1. student balances:
        Student student = null;
        List <StudentBalance> studentBalances = null;
        List <Student> allExtendedStudents = new ArrayList();
        
        for (int i = 0; i < allStudents.size(); i++) {
        	student = (Student) allStudents.get(i);
        	if (feeManager.findStudentBalances(student.getStudentId()) != null) {
        		studentBalances = feeManager.findStudentBalances(student.getStudentId());
        		student.setStudentBalances(studentBalances);
        	}
        	allExtendedStudents.add(student);
        	
        }
        request.setAttribute("allStudents", allExtendedStudents);
       
        // moved down because possibly other institutionId, branchId and/or orgId needed 
        fb.loadInstitutionBranchOrgUnit();
        // set attribute for right redirect view form

        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());
        
        request.setAttribute("action", "/fee/paymentsstudents.view");

        return new ModelAndView(viewName); 
    }

    /**
     * @param viewName name of view to show; is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setOpusMethods(final OpusMethods newOpusMethods) {
        opusMethods = newOpusMethods;
    }

    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    public void setStudentManager(final StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

}
