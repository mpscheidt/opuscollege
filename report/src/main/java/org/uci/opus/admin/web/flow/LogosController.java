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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.admin.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: LogosController.
 * @author: MoVe
 */
public class LogosController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(LogosController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    private LookupCacher lookupCacher;
    private OpusMethods opusMethods;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public LogosController() {
        super();
    }

    /** 
     * {@inheritDoc}
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to studies */
        session.setAttribute("menuChoice", "admin");

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        /* get preferred Language from request or else session and save it in the request */

        //* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, institutionTypeCode, institutionId
                , branchId, organizationalUnitId);

        return new ModelAndView(viewName); 
    }

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

    /**
     * @param organizationalUnitManager is set by Spring on application init.
     */
    public void setOrganizationalUnitManager(
            final OrganizationalUnitManagerInterface organizationalUnitManager) {
        this.organizationalUnitManager = organizationalUnitManager;
    }

    /**
     * @param newLookupCacher is set by Spring on application init.
     */
    public void setLookupCacher(final LookupCacher newLookupCacher) {
        lookupCacher = newLookupCacher;
    }

    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

}
