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
 * The Original Code is Opus-College admission module code.
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
package org.uci.opus.admission.web.flow;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * @author move
 * Servlet implementation class for Servlet: ApprovedAdmissionController.
 * Handles initial student admission
 */
@Controller
@RequestMapping("/approved_admission.view")
@SessionAttributes({"requestAdmissionForm"})
public class ApprovedAdmissionController {

    private static Logger log = LoggerFactory.getLogger(ApprovedAdmissionController.class);
    private String formView;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public ApprovedAdmissionController(){
        super();
        this.formView = "admission/approvedAdmission";
    }

    /**
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String setRegisteredPost(HttpServletRequest request) {
    	
    	return setRegistered(request);
    }

    /**
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setRegistered(HttpServletRequest request) {

    	request.setAttribute("admittedText",(String) request.getParameter("admittedText"));
    	request.setAttribute("tab",(String) request.getParameter("tab"));
    	request.setAttribute("panel", (String) request.getParameter("panel"));
    	request.setAttribute("studentId", (String) request.getParameter("studentId"));
    	request.setAttribute("from", (String) request.getParameter("from"));
    	request.setAttribute("currentPageNumber", request.getParameter("currentPageNumber"));
    	
        return formView;
    }

}
