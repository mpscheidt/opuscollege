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
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

// TODO: move to overview controller, because in case of error - due to redirect - filter selections are lost in overview screen

public class StaffMemberDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(StaffMemberDeleteController.class);
	 private String viewName;
     private MessageSource messageSource;    
     private SecurityChecker securityChecker;    
     private StaffMemberManagerInterface staffMemberManager;
     private OpusMethods opusMethods;

     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public StaffMemberDeleteController() {
		super();
	}

    @Override
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int tab = 0;
        int panel = 0;
        String showStaffMemberError = "";
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form objects used yet in this controller
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        int staffMemberId = Integer.parseInt(request.getParameter("staffMemberId"));

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

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // delete chosen staffmember:
        if (staffMemberId != 0) {

        	Locale currentLoc = RequestContextUtils.getLocale(request);

        	// cannot be deleted if there are subjects attached to this staffmember:
            List < ? extends SubjectTeacher > subjectTeacherList = null;
            subjectTeacherList = staffMemberManager.findSubjectsForStaffMember(staffMemberId);
            if (subjectTeacherList.size() != 0) {
                // show error for linked results
                showStaffMemberError = messageSource.getMessage(
                                    "jsp.error.general.delete.linked.subject", null, currentLoc);
            } else {
            	// cannot be deleted if there are examinations attached to this staffmember:
                List < ExaminationTeacher > examinationList = null;
                examinationList = staffMemberManager.findExaminationsForStaffMember(staffMemberId);
                if (examinationList.size() != 0) {
                    // show error for linked results
                    showStaffMemberError = messageSource.getMessage(
                                            "jsp.error.general.delete.linked.examination"
                                            , null, currentLoc);
                } else {
                    log.info("Going to delete staffmember with staffmemberId = " + staffMemberId);
                	staffMemberManager.deleteStaffMember(preferredLanguage, staffMemberId, opusMethods.getWriteWho(request));
                }
            }
        }
        
        /* put lookup-tables on the request */
        //request = lookupCacher.getPersonLookups(preferredLanguage, request);
        
        this.setViewName("redirect:/college/staffmembers.view?newForm=true&showStaffMemberError="
                        + showStaffMemberError
                        + "&currentPageNumber=" + currentPageNumber);

        return new ModelAndView(viewName); 
    }
   
    /**
     * @param viewName
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
     * @param newStaffMemberManager
     */
    public void setStaffMemberManager(final StaffMemberManagerInterface newStaffMemberManager) {
        staffMemberManager = newStaffMemberManager;
    }

    /**
     * @param newOpusMethods
     */
    public void setOpusMethods(final OpusMethods newOpusMethods) {
        opusMethods = newOpusMethods;
    }

}
