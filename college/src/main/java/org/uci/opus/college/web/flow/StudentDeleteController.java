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

import java.util.List;
import java.util.Locale;

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
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.user.OpusSecurityException;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * 
 *    // TODO: move to overview controller, because in case of error - due to redirect - filter selections are lost in overview screen
 *
 */
 public class StudentDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(StudentDeleteController.class);
    private MessageSource messageSource;    
    private SecurityChecker securityChecker;    
    private StudentManagerInterface studentManager;
    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;

    @Autowired private List <Module> modules;

     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public StudentDeleteController() {
		super();
	}


	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, 
            HttpServletResponse response) {
   	   
    	HttpSession session = request.getSession(false);        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int tab = 0;
        int panel = 0;
        String showStudentError = "";
        int currentPageNumber = 0;
        Student student = null;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        /* perform privilege check. If wrong, this throws an Exception towards ErrorController */
        if (!request.isUserInRole("DELETE_STUDENTS")) {
    		String errMsg = "opusUserRole does not have the correct privilege to perform this action";
            log.warn(errMsg);
        	throw new OpusSecurityException(errMsg);
        }
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        int studentId = Integer.parseInt(request.getParameter("studentId"));

        OrganizationalUnit organizationalUnit = (OrganizationalUnit) 
                                    session.getAttribute("organizationalUnit");

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

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);
        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);
        organizationalUnitId = OpusMethods.getOrganizationalUnitId(
                                        session, request, organizationalUnit);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        // delete chosen student:
        if (studentId != 0) {

        	Locale currentLoc = RequestContextUtils.getLocale(request);
//            OpusUser opusUser = (OpusUser) session.getAttribute("opusUser");
            OpusUser opusUser = opusMethods.getOpusUser();
        	student = studentManager.findStudent(preferredLanguage, studentId);

        	// check if logged in user is not the student:
        	if (opusUser.getPersonId() == student.getPersonId()) {
        		showStudentError = messageSource.getMessage(
                        "jsp.error.general.delete.own", null, currentLoc);
        	}
        	
        	// cannot be deleted if there are studyplans attached to this student:
        	List < ? extends StudyPlan > studyPlanList = null;
            studyPlanList = studentManager.findStudyPlansForStudent(studentId);
            if (studyPlanList.size() != 0) {
                // show error for linked results
                showStudentError = showStudentError + messageSource.getMessage(
                                    "jsp.error.general.delete.linked.studyplan", null, currentLoc);
            } else {
            	if ("Y".equals(student.getScholarship())) {
            		// show error for scholarshipstudent
            		showStudentError = messageSource.getMessage(
                                    "jsp.error.general.delete.linked.scholarship", null, currentLoc);
            	} else {
            		studentManager.deleteStudent(preferredLanguage, studentId, opusMethods.getWriteWho(request));

/* MP moved to fee module
                    for(Module module:modules){
    					if ("fee".equals(module.getModule())) {
    						studentManager.deleteStudentBalancesByStudentId(studentId,
    								opusMethods.getWriteWho(session));
    					}
    				} */
            	}
            	
            }
        }

        String view = "redirect:/college/students.view?newForm=true&showStudentError=" + showStudentError
                            + "&currentPageNumber=" + currentPageNumber;

        return new ModelAndView(view);
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
     * @param newStudentManager
     */
    public void setStudentManager(final StudentManagerInterface newStudentManager) {
        studentManager = newStudentManager;
    }

    /**
     * @param newLookupCacher
     */
    public void setLookupCacher(final LookupCacher newLookupCacher) {
        lookupCacher = newLookupCacher;
    }

    /**
     * @param newOpusMethods
     */
    public void setOpusMethods(final OpusMethods newOpusMethods) {
        opusMethods = newOpusMethods;
    }

}
