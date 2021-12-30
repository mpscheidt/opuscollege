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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * 
 * @author stelio2
 *
 */
 public class OpusUserRoleDeleteController extends AbstractController {
    
     private static Logger log = LoggerFactory.getLogger(OpusUserRoleDeleteController.class);
	 private SecurityChecker securityChecker;    
     private OpusUserManagerInterface opusUserManager;
     

     @Autowired
    public OpusUserRoleDeleteController(SecurityChecker securityChecker, OpusUserManagerInterface opusUserManager) {
		super();
		this.securityChecker = securityChecker;
		this.opusUserManager = opusUserManager;
	}

	/** 
     * {@inheritDoc}
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
     @PreAuthorize("hasRole('DELETE_USER_ROLE')")
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        

        int id = ServletUtil.getIntParam(request, "id", 0);
        int currentPageNumber = 0;

        String from = request.getParameter("from");
        
        String mav = "";
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* reset session-from-attribute */
        if("staffmember".equalsIgnoreCase(from)) {
        	session.setAttribute("menuChoice", "staffmembers");	
        } else if("student".equalsIgnoreCase(from)) {
        	session.setAttribute("menuChoice", "students");
        }

        if("staffmember".equalsIgnoreCase(from)) {
        	int staffMemberId = ServletUtil.getIntParam(request, "staffMemberId", 0);
        	mav = "redirect:/college/staffmember.view?newForm=true&tab=1&panel=2&staffMemberId=" + staffMemberId  + "&from=" + from;
        	
        }  else  if("student".equalsIgnoreCase(from)){
        	int studentId = ServletUtil.getIntParam(request, "studentId", 0);
        	mav = "redirect:/college/student-opususer.view?newForm=true&tab=1&panel=2&studentId=" + studentId + "&from=" + from;        	
        }
        	
        
        if (request.getParameter("currentPageNumber") != null) {
        	ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);
        }
        
        session.setAttribute("overviewPageNumber", currentPageNumber);

    	opusUserManager.deleteOpusUserRoleById(id);
    	
        return new ModelAndView(mav); 
    }
   
    /**
     * @param securityChecker is set by Spring on application init.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }
	
}
