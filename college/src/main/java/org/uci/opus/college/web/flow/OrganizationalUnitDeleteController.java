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
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author u606118
 *
 */
public class OrganizationalUnitDeleteController extends AbstractController {
    
    private static Logger log = LoggerFactory.getLogger(OrganizationalUnitDeleteController.class);
    private String viewName;    
    private SecurityChecker securityChecker;    
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    private PersonManagerInterface personManager;
    private StaffMemberManagerInterface staffMemberManager;
    private StudyManagerInterface studyManager;
    private BranchManagerInterface branchManager;
    private InstitutionManagerInterface institutionManager;
    private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public OrganizationalUnitDeleteController() {
        super();
    }


    @Override
    protected ModelAndView handleRequestInternal(
            HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);  

        if (request.getParameter("viewName") != null) {
            viewName = request.getParameter("viewName").toString();
        } else {
            viewName = "organization/organizationalunits";
        }


        int institutionId = 0;
        int branchId = 0;
        List < ? extends Branch > allBranches = null;
        String showError = "";
        int parentOUId = 0;
        int currentPageNumber = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // no form object in this controller yet
//        opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        int organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
        if (!StringUtil.isNullOrEmpty(request.getParameter("parentOUId"))) {
            parentOUId = Integer.parseInt(request.getParameter("parentOUId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // delete chosen organizationalUnit:
        if (organizationalUnitId != 0) {
        	
        	/* check if organizatonal unit is not related to staffmembers or studies anymore */
        	List < ?   extends StaffMember > allStaffMembersForUnit = null;
        	
        	HashMap staffMemberMap = new HashMap();
            staffMemberMap.put("branchId", 0);
            staffMemberMap.put("organizationalUnitId", organizationalUnitId);
            staffMemberMap.put("searchValue", "");
            
//        	allStaffMembersForUnit = staffMemberManager.findAllStaffMembersForOrganizationalUnit(
//                                        preferredLanguage, organizationalUnitId);
            allStaffMembersForUnit = staffMemberManager.findStaffMembers(staffMemberMap);
                    

        	if (allStaffMembersForUnit == null || allStaffMembersForUnit.size() == 0) {

	        	List < ? extends Study > allStudiesForUnit = null;
	        	allStudiesForUnit = studyManager.findAllStudiesForOrganizationalUnit(
                                        organizationalUnitId);
            
	        	if (allStudiesForUnit == null || allStudiesForUnit.size() == 0) {
        		
	        		/* then check if organizational unit is not related to any children anymore */
	                List < ? extends OrganizationalUnit > allChildOrganizationalUnits = null;
	                allChildOrganizationalUnits = organizationalUnitManager.
                                        findAllChildrenForOrganizationalUnit(organizationalUnitId);
	        		
	            	if (allChildOrganizationalUnits == null 
                            || allChildOrganizationalUnits.size() == 0) {
                        organizationalUnitManager.deleteOrganizationalUnit(organizationalUnitId);
	            	} else {
                        showError = "child";
                        request.setAttribute("showError", showError);
	            	}
	        	} else {
                    showError = "study";
                    request.setAttribute("showError", showError);
	        	}
        	} else {
                showError = "staffmember";
                request.setAttribute("showError", showError);
        	}
        }

        institutionId = OpusMethods.getInstitutionId(session, request);
        Institution institution = institutionManager.findInstitution(institutionId);
        // standard educationtype = "university"
        String educationTypeCode = "3";
        if (institution != null) {
            educationTypeCode = institution.getInstitutionTypeCode();
        }
        
        // a subUnit is deleted in the editscreen: go back to the editscreen
        if (viewName.equalsIgnoreCase("college/organization/organizationalunit")) {
            this.setViewName("redirect:/college/organizationalunit.view?newForm=true&tab=0&panel=0"
                    + "&from=organizationalunits&showError=" + showError + "&educationTypeCode="
                    + educationTypeCode + "&organizationalUnitId=" + parentOUId 
                    + "&childOUId=" + organizationalUnitId
                    + "&currentPageNumber=" + currentPageNumber);
        } else {
            this.setViewName("redirect:/college/organizationalunits.view?newForm=true&showError=" + showError
                                + "&currentPageNumber=" + currentPageNumber);
        }
        
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
     * @return Returns the organizationalUnitManager.
     */
    public OrganizationalUnitManagerInterface getOrganizationalUnitManager() {
        return organizationalUnitManager;
    }


    /**
     * @param organizationalUnitManager is set by Spring on application init.
     */
    public void setOrganizationalUnitManager(
            final OrganizationalUnitManagerInterface organizationalUnitManager) {
        this.organizationalUnitManager = organizationalUnitManager;
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
     * @return Returns the personManager.
     */
    public PersonManagerInterface getPersonManager() {
        return personManager;
    }


    /**
     * @param personManager is set by Spring on application init.
     */
    public void setPersonManager(final PersonManagerInterface personManager) {
        this.personManager = personManager;
    }


	public void setStaffMemberManager(final StaffMemberManagerInterface staffMemberManager) {
		this.staffMemberManager = staffMemberManager;
	}


	public void setStudyManager(final StudyManagerInterface studyManager) {
		this.studyManager = studyManager;
	}


	public void setBranchManager(final BranchManagerInterface branchManager) {
		this.branchManager = branchManager;
	}


	public void setInstitutionManager(final InstitutionManagerInterface institutionManager) {
		this.institutionManager = institutionManager;
	}

}
