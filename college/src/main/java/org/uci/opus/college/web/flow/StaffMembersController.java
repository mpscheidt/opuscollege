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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * Staff members overview controller
 */
public class StaffMembersController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(StaffMembersController.class);
    private String viewName;
    private SecurityChecker securityChecker;
    private OpusMethods opusMethods;
    private StaffMemberManagerInterface staffMemberManager;
    private LookupCacher lookupCacher;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;

    @Autowired
    private OpusUserManagerInterface opusUserManager;

    public StaffMembersController() {
        super();
    }

    @Override
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, final HttpServletResponse response) {

        HttpSession session = request.getSession(false);
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int currentPageNumber = 0;
        String showStaffMemberError = "";
        String searchValue = "";

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // no form object in this controller yet
        // opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* set menu to staffmembers */
        session.setAttribute("menuChoice", "staffmembers");

        if (!StringUtil.isNullOrEmpty(request.getParameter("showStaffMemberError"))) {
            showStaffMemberError = request.getParameter("showStaffMemberError");
        }
        request.setAttribute("showStaffMemberError", showStaffMemberError);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        // if (request.getParameter("searchValue") != null) {
        // if (!StringUtil.isNullOrEmpty(request.getParameter("searchValue").toString())) {
        // searchValue = (String) request.getParameter("searchValue");
        // }
        // }
        // request.setAttribute("searchValue", searchValue);
        // get the searchValue and put it on the session
        searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        /*
         * find a LIST OF INSTITUTIONS of the correct educationtype
         * 
         * set first the institutionTypeCode; for now studies, and therefore subjects, are only registered for universities; if in the
         * future this should change, it will be easier to alter the code
         */
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId, organizationalUnitId);

        /*
         * LIST OF ORGANIZATIONALUNITS the list retrieved in getInstitutionBranchOrganizationalUnitSelect is not correct in this case
         */

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);
        log.debug("StaffmembersController: organizationalUnitId = " + organizationalUnitId);
        /*
         * find a LIST OF INSTITUTIONS of the correct educationtype
         * 
         * the institutionTypeCode is used (set in code above) for now studies, and therefore subjects, are only registered for
         * universities; if in the future this should change, it will be easier to alter the code
         */

        // retrieve all staffmembers (or variation) from database:
        List<? extends StaffMember> allStaffMembers = null;
        // allStaffMembers = opusMethods.getAllStaffMembers(session, request);

        Map<String, Object> findStaffMembersMap = new HashMap<String, Object>();
        findStaffMembersMap.put("institutionId", institutionId);
        findStaffMembersMap.put("branchId", branchId);
        findStaffMembersMap.put("organizationalUnitId", organizationalUnitId);
        findStaffMembersMap.put("searchValue", searchValue);
        findStaffMembersMap.put("highestLevel", opusUserManager.getLevelOfLoggedInOpusUserRole(request));

        allStaffMembers = staffMemberManager.findStaffMembers(findStaffMembersMap);

        request.setAttribute("allStaffMembers", allStaffMembers);

        List<Integer> orgUnitIds = DomainUtil.getIntProperties(allStaffMembers, "primaryUnitOfAppointmentId");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("organizationalUnitIds", orgUnitIds);
        List<OrganizationalUnit> organizationalUnitsOfAppointment = organizationalUnitManager.findOrganizationalUnits(map);
        request.setAttribute("idToOrganizationalUnitMap", new IdToOrganizationalUnitMap(organizationalUnitsOfAppointment));

        lookupCacher.getPersonLookups(preferredLanguage, request);
        // set attribute for right redirect view form
        request.setAttribute("action", "/college/staffmembers.view");

        return new ModelAndView(viewName);
    }

    /**
     * @param viewName
     *            name of view to show; is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setOpusMethods(final OpusMethods newOpusMethods) {
        opusMethods = newOpusMethods;
    }

    public void setStaffMemberManager(final StaffMemberManagerInterface staffMemberManager) {
        this.staffMemberManager = staffMemberManager;
    }

    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

}
