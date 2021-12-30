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
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * @author u606118
 *
 */
public class ThesisDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(OrganizationalUnitDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private StudentManagerInterface studentManager;
    private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public ThesisDeleteController() {
        super();
    }
    
    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);        
        
        String showError = "";
        int studyPlanId = 0;
        int studentId = 0;
        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        int thesisId = Integer.parseInt(request.getParameter("thesisId"));
        
        if (request.getParameter("studyPlanId") != null) {
            studyPlanId = Integer.parseInt(request.getParameter("studyPlanId"));
        }
        request.setAttribute("studyPlanId", studyPlanId);
        
        if (request.getParameter("studentId") != null) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }
        request.setAttribute("studentId", studentId);
        
        if (request.getParameter("tab") != null) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);
        
        if (request.getParameter("panel") != null) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);
        
        // delete thesis:
        if (thesisId != 0) {
            // thesis cannot be deleted if results are present
            // TODO
////            List < SubjectResult > subjectResultList = null;
////            subjectResultList = resultManager.findSubjectResults(subjectId);
////            if (subjectResultList.size() != 0) {
////                // show error for linked results
////               showError = "result";
////            } else {
//            	// subject cannot be deleted if it belongs to a studyplan
//                List subjectStudyPlanDetailList = null;
//                subjectStudyPlanDetailList = subjectManager.findSubjectStudyPlanDetails(subjectId);
//                if (subjectStudyPlanDetailList.size() != 0) {
//                    // show error for linked results
//                   showError = "studyplan";
//                } else {
                    // delete all linked thesisSupervisors
                    studentManager.deleteThesisStatusesByThesisId(thesisId);
                    studentManager.deleteThesisSupervisorsByThesisId(thesisId);
                	studentManager.deleteThesis(thesisId);
//                }
//            }
        }
        
        /* put lookup-tables on the request */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getAddressLookups(preferredLanguage, request);
        
        this.setViewName("redirect:/college/studyplan.view?newForm=true&showError=" + showError
                                + "&tab=" + tab + "&panel=" + panel
                                + "&studentId=" + studentId + "&studyPlanId=" + studyPlanId
                                + "&currentPageNumber=" + currentPageNumber);
        
        return new ModelAndView(viewName); 
    }


    /**
     * @return Returns the viewName.
     */

    /**
     * @param viewName is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    /**
     * @param securityChecker is set by Spring on application init.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setStudentManager(final StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

}
