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
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author J.Nooitgedagt
 *
 */
public class BranchDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(InstitutionDeleteController.class);
    private String viewName;
    private SecurityChecker securityChecker;
    private InstitutionManagerInterface institutionManager;
    private BranchManagerInterface branchManager;
    private LookupCacher lookupCacher;
    private StaffMemberManagerInterface staffMemberManager;
    private StudyManagerInterface studyManager;
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private OpusMethods opusMethods;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public BranchDeleteController() {
        super();
    }


    /**
     * {@inheritDoc}.
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     *      
     * Creates a form backing object. If the request parameter "branchId" is set, the
     * specified branch is deleted (if possible).
     */
    @Override
    protected final ModelAndView handleRequestInternal(
            HttpServletRequest request, final HttpServletResponse response) {

    	HttpSession session = request.getSession(false);        
        
        int institutionId = 0;
        int branchId = 0;
        List < Institution > allInstitutions = null;
//        List < Branch > allBranches = null;
        String showError = "";
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObject("...", session, opusMethods.isNewForm(request));

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        branchId = Integer.parseInt(request.getParameter("branchId"));

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        // delete chosen branch:
        if (branchId != 0) {
        	
        	/* first check if branch is not related to staffmembers  anymore */
        	List < StaffMember > allStaffMembersForBranch = null;
        	Map<String, Object> staffMemberMap = new HashMap<String, Object>();
        	staffMemberMap.put("branchId", branchId);
        	staffMemberMap.put("organizationalUnitId", 0);
        	allStaffMembersForBranch = (ArrayList < StaffMember >) staffMemberManager.findStaffMembers(staffMemberMap);
//        	allStaffMembersForBranch = (ArrayList < StaffMember >) staffMemberManager.
//                                        findAllStaffMembersForBranch(preferredLanguage, branchId);
        	if (allStaffMembersForBranch == null || allStaffMembersForBranch.size() == 0) {
            	/* then check if branch is not related to studies anymore */
        		List < Study > allStudiesForBranch = null;
        		allStudiesForBranch = (ArrayList < Study >) studyManager.
                                        findAllStudiesForBranch(branchId);
            
	        	if (allStudiesForBranch == null || allStudiesForBranch.size() == 0) {
	        		/* then check if there are organizational units related to the branch */
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
                    map.put("branchId", branchId);
	            	List < OrganizationalUnit > allOUsForBranch = null;
                    allOUsForBranch = organizationalUnitManager.findOrganizationalUnits(map);
	        		if (allOUsForBranch == null || allOUsForBranch.size() == 0) {
	        			branchManager.deleteBranch(branchId);
                    } else {
                        // show error for linked organizationalunits
                        showError = "organizationalunit";
                        request.setAttribute("showError", showError);
                    }
                } else {
                    // show error for linked studies
                    showError = "study";
                    request.setAttribute("showError", showError);
                }
        	} else {
        	    // show error for linked staffmembers
                showError = "staffmember";
                request.setAttribute("showError", showError);
            }
        }
        
        // get the correct institutionId
        institutionId = OpusMethods.getInstitutionId(session, request);
        
        String institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        if (!StringUtil.isNullOrEmpty(request.getParameter("institutionTypeCode"))) {
            institutionTypeCode = request.getParameter("institutionTypeCode");
        }
        
        /* 
         * These lists are needed in the overview form which is opened 
         * after the insert or update.
         *  
         * retrieve all institutions from database
         * used to show the correct institutionnames with the branches
         */ 
        
        // retrieve all institutions of the correct educationType from database
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("institutionTypeCode", institutionTypeCode);

        allInstitutions = (ArrayList < Institution >) institutionManager.findInstitutions(map);
        request.setAttribute("allInstitutions", allInstitutions);
        
        // retrieve all branches of the selected institution from database        
//        HashMap findBranchesMap = new HashMap();
//        findBranchesMap.put("institutionId", institutionId);
//        findBranchesMap.put("institutionTypeCode", institutionTypeCode);
//        
//        allBranches = (ArrayList < Branch >) branchManager.findBranches(findBranchesMap);
//        request.setAttribute("allBranches", allBranches);
//        session.setAttribute("allBranches", allBranches);

        this.viewName = "redirect:/college/branches.view?newForm=true&institutionTypeCode=" + institutionTypeCode 
                        + "&showError=" + showError
                        + "&currentPageNumber=" + currentPageNumber;
        
        return new ModelAndView(viewName);
    }


    /**
     * @return Returns the viewName.
     */
    public String getViewName() {
        return viewName;
    }


    /**
     * @param viewName is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }


    /**
     * @return Returns the lookupCacher.
     */
    public LookupCacher getLookupCacher() {
        return lookupCacher;
    }


    /**
     * @param lookupCacher is set by Spring on application init.
     */
    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    /**
     * @param institutionManager is set by Spring on application init.
     */
    public void setInstitutionManager(
            final InstitutionManagerInterface institutionManager) {
        this.institutionManager = institutionManager;
    }

    /**
     * @return Returns the securityChecker.
     */
    public SecurityChecker getSecurityChecker() {
        return securityChecker;
    }

    /**
     * @param securityChecker is set by Spring on application init.
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    /**
     * @param branchManager The branchManager to set.
     */
    public void setBranchManager(final BranchManagerInterface branchManager) {
        this.branchManager = branchManager;
    }


	public void setStaffMemberManager(final StaffMemberManagerInterface staffMemberManager) {
		this.staffMemberManager = staffMemberManager;
	}


	public void setStudyManager(final StudyManagerInterface studyManager) {
		this.studyManager = studyManager;
	}


	/**
	 * @param organizationalUnitManager is set by Spring on application init.
	 */
	public void setOrganizationalUnitManager(
            final OrganizationalUnitManagerInterface organizationalUnitManager) {
		this.organizationalUnitManager = organizationalUnitManager;
	}
}
