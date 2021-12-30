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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: InstitutionsController.
 *
 */

public class InstitutionsController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(InstitutionsController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private InstitutionManagerInterface institutionManager;
    private LookupCacher lookupCacher;
     
     /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public InstitutionsController() {
        super();
    }

    @Override
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) {

        HttpSession session = request.getSession(false);        
        String institutionTypeCode = "";
        List < ? extends Institution > allInstitutions = null;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if an institution has one or more branches, it can not be deleted; this attribute is
        // used to show an error message.
        request.setAttribute("showError", request.getParameter("showError"));
        request.setAttribute("showInstitutionError", request.getParameter("showInstitutionError"));

        if (!StringUtil.isNullOrEmpty(request.getParameter("institutionTypeCode"))) {
            institutionTypeCode = request.getParameter("institutionTypeCode");

            request.setAttribute("institutionTypeCode", institutionTypeCode);
        }

        /* set menu to institutions */
        if ("1".equals(institutionTypeCode)) {
            session.setAttribute("menuChoice", "admin");
        } else {
            session.setAttribute("menuChoice", "institutions");
        }

        Map<String, Object> findInstitutionsMap = new HashMap<>();
        findInstitutionsMap.put("institutionTypeCode", institutionTypeCode);

        if (request.getParameter("currentPageNumber") != null) {
        	currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        /* put lookup-tables on the request */
        // educationTypes and provinces
        lookupCacher.getInstitutionLookups(preferredLanguage, request);
        
        request.setAttribute("allInstitutionTypes", lookupCacher.getAllInstitutionTypes(preferredLanguage));
        
        // retrieve all institutions of the correct educationtype from database
        allInstitutions = institutionManager.findInstitutions(findInstitutionsMap);
        request.setAttribute("allInstitutions", allInstitutions);

        return new ModelAndView(viewName); 
    }
   
    /**
     * @param viewName name of view:organizationalunits
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

    /**
     * @param newInstitutionManager is set by Spring on application init.
     */
    public void setInstitutionManager(
            final InstitutionManagerInterface newInstitutionManager) {
        institutionManager = newInstitutionManager;
    }

    /**
     * @param lookupCacher is set by Spring on application init.
     */
    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }
}
