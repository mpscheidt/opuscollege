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
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: AddressDeleteController.
 * @author M. in het Veld
 *
 */

@Controller
@RequestMapping("/college/address_delete.view")
public class AddressDeleteController {

     private static Logger log = LoggerFactory.getLogger(AddressDeleteController.class);
     private String viewName;
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private AddressManagerInterface addressManager;
     @Autowired private StaffMemberManagerInterface staffMemberManager;
     @Autowired private StudentManagerInterface studentManager;
     @Autowired private PersonManagerInterface personManager;
     @Autowired private OpusMethods opusMethods;
     
     /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public AddressDeleteController() {
		super();
        this.viewName = "college/person/staffmember";
	}

    /** 
     * {@inheritDoc}
     * @see org.springframework.web.servlet.mvc.Controller
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
	@RequestMapping(method=RequestMethod.POST)
	protected final String deleteAddressPost(HttpServletRequest request) {

    	return deleteAddress(request);

    }

	/**
     * {@inheritDoc}.
     * @see org.springframework.web.servlet.mvc.Controller
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     *      
     * Creates a form backing object. If the request parameter "addressId" is set, the
     * specified address is deleted.
     */
    @PreAuthorize("hasRole('DELETE_STUDENT_ADDRESSES')")
    @RequestMapping(method=RequestMethod.GET)
    protected String deleteAddress(HttpServletRequest request) {

        StaffMember staffMember = null;
        Student student = null;
        int addressId = 0;
        int personId = 0;
        int organizationalUnitId = 0;
        int studyId = 0;

    	HttpSession session = request.getSession(false);        
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        if (!StringUtil.isNullOrEmpty(request.getParameter("addressId"))) {
            addressId = Integer.parseInt(request.getParameter("addressId"));
        }
        String from = request.getParameter("from");
        if ("staffmember".equals(from) || "student".equals(from)) {
            personId = Integer.parseInt(request.getParameter("personId"));
        }
        if ("organizationalunit".equals(from)) {
            organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
        }
        if ("study".equals(from)) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
        }

        NavigationSettings nav = opusMethods.createAndFillNavigationSettings(request);
        int tab = nav.getTab();
        int panel = nav.getPanel();
        int currentPageNumber = nav.getCurrentPageNumber();

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (addressId != 0) {
            // delete chosen address:
        	addressManager.deleteAddress(addressId);
        }
        
        // redirect to staffmember or student
        if (personId != 0) {
            /* put person lookup-tables on the request */
            if (personManager.isStaffMember(personId)) {
                staffMember = staffMemberManager.findStaffMemberByPersonId(
                                                        personId);

                this.viewName = "redirect:/college/staffmember.view?newForm=true&tab=" + tab 
                                    + "&panel=" + panel 
                                    + "&staffMemberId=" + staffMember.getStaffMemberId()
                                    + "&currentPageNumber=" + currentPageNumber;
            }
            if (personManager.isStudent(personId)) {
                student = studentManager.findStudentByPersonId(personId);

                this.viewName = "redirect:/college/student-addresses.view?newForm=true&tab=" + tab
                                    + "&panel=" + panel 
                                    + "&studentId=" + student.getStudentId()
                                    + "&currentPageNumber=" + currentPageNumber;
            }
        }
        // redirect to organizationalunit
        if (organizationalUnitId != 0) {
                this.viewName = "redirect:/college/organizationalunit.view?newForm=true&tab=" + tab
                                    + "&panel=" + panel
                                    + "&organizationalUnitId=" + organizationalUnitId
                                    + "&currentPageNumber=" + currentPageNumber;
        }
        // redirect to study
        if (studyId != 0) {
            this.viewName = "redirect:/college/study.view?newForm=true&tab=" + tab 
    								+ "&panel=" + panel
                                    + "&studyId=" + studyId
                                    + "&currentPageNumber=" + currentPageNumber;
        }
        return viewName;
    }


}
