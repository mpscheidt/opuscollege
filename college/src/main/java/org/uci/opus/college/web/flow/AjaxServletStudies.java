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

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: AjaxServletStudies.
 * - test for ajax with jquery
 * search: jquery java asynchronous request tutorial
 * see: http://www.ajaxprojects.com/ajax/tutorialdetails.php?itemid=438
 */
 public class AjaxServletStudies {
    
     private static Logger log = LoggerFactory.getLogger(AjaxServletStudies.class);
     private SecurityChecker securityChecker;    
     private StudyManagerInterface studyManager;
     private OpusMethods opusMethods;
 
    /** 
     * {@inheritDoc}
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
	    
        HttpSession session = request.getSession(false);        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String searchValue = "";
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form objects in this controller
//        opusMethods.removeSessionFormObject("...", session, opusMethods.isNewForm(request));

        //* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);
        
        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);
        
        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);
        
        // LIST OF STUDIES
        
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);
        
        List < ? extends Study > allStudies = null;
        Map<String, Object> findStudiesMap = new HashMap<>();
        
        findStudiesMap.put("institutionId", institutionId);
        findStudiesMap.put("branchId", branchId);
        findStudiesMap.put("organizationalUnitId", organizationalUnitId);
        findStudiesMap.put("institutionTypeCode", institutionTypeCode);
        findStudiesMap.put("searchValue", searchValue);
        allStudies = studyManager.findStudies(findStudiesMap);
        request.setAttribute("allStudies", allStudies);
        
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        out.println("<report>dit is een test</report>");
        out.flush();
        out.close();
    }
   
    /**
     * @param securityChecker is set by Spring on application init.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }
 
    /**
     * @param studyManager is set by Spring on application init.
     */
    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

}
