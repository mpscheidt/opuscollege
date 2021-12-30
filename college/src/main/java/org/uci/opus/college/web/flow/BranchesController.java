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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: BranchesController.
 *
 */
public class BranchesController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(InstitutionsController.class);
    private String viewName;
    private SecurityChecker securityChecker;    
    private InstitutionManagerInterface institutionManager;
    private BranchManagerInterface branchManager;
    @Autowired OpusMethods opusMethods; 
     /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public BranchesController() {
        super();
    }

    /** 
     * {@inheritDoc}.
     * @see org.springframework.web.servlet.mvc.AbstractController#handleRequestInternal
     *      (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) {
        
        HttpSession session = request.getSession(false); 
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int currentPageNumber = 0;

        List < Institution > allInstitutions = null;
        List < Branch > allBranches = null;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObject("...", session, opusMethods.isNewForm(request));
        
        // if an branch has one or more organizational units, it can not be deleted;
        // this attribute is used to show an error message.
        request.setAttribute("showError", request.getParameter("showError"));
        request.setAttribute("showBranchError", request.getParameter("showBranchError"));

        /* set menu to institutions */
        session.setAttribute("menuChoice", "institutions");
        
        if (request.getParameter("currentPageNumber") != null) {
        	currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        // get the institutionId if it is selected;
        // used when changing the institution; it's not forwarded when
        // selecting a branch, because that is a new request
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);
        
        /*
         *  find a LIST OF INSTITUTIONS of the correct educationtype
         *  
         *  set first the institutionTypeCode;
         *  for now studies, and therefore subjects, are only registered
         *  for universities; if in the future this should change, it will
         *  be easier to alter the code
         */
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);
        
        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                        session, request, institutionTypeCode, institutionId
                                    , branchId, organizationalUnitId);

        /* LIST OF ORGANIZATIONALUNITS
         * the list retrieved in getInstitutionBranchOrganizationalUnitSelect 
         * is not correct in this case
         */
        
        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);
        
        // retrieve all institutions of the correct educationType from database
        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", institutionTypeCode);

        allInstitutions = (ArrayList < Institution >
                                    ) institutionManager.findInstitutions(map);
        request.setAttribute("allInstitutions", allInstitutions);

        // retrieve all branches of the selected institution from database        
        Map<String, Object> findBranchesMap = new HashMap<>();
        findBranchesMap.put("institutionId", institutionId);
        findBranchesMap.put("institutionTypeCode", institutionTypeCode);
        
        allBranches = (ArrayList < Branch >
                            ) branchManager.findBranches(findBranchesMap);
        request.setAttribute("allBranches", allBranches);

        return new ModelAndView(viewName); 
    }
   
    /**
     * @param viewName name of view:organizationalunits; is set by Spring on application init.
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
     * @param branchManager is set by Spring on application init.
     */
    public void setBranchManager(final BranchManagerInterface branchManager) {
        this.branchManager = branchManager;
    }

}
