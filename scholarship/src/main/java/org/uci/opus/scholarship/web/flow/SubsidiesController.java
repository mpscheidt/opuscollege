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
 * The Original Code is Opus-College scholarship module code.
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
package org.uci.opus.scholarship.web.flow;

import java.util.ArrayList;
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
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet.
 *
 */

public class SubsidiesController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(SubsidiesController.class);
    private SecurityChecker securityChecker;    
    private String viewName;
    private ScholarshipManagerInterface scholarshipManager;
    private StudyManagerInterface studyManager;
    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public SubsidiesController() {
        super();
    }

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, 
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String institutionTypeCode = "";
        int currentPageNumber = 0;
        int sponsorId = 0;

        List < Sponsor > allSponsors = null;
        List < Map<String, Object> > allSubsidies = new ArrayList < Map<String, Object> >();

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("sponsorId"))) {
            sponsorId = Integer.parseInt(request.getParameter("sponsorId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        institutionTypeCode = request.getParameter("institutionTypeCode");
        if (StringUtil.isNullOrEmpty(institutionTypeCode, true)) {
            institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        }
        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, institutionTypeCode, institutionId
                , branchId, organizationalUnitId);

        /* fill lookup-tables with right values */
        lookupCacher.getPersonLookups(preferredLanguage, request);

        allSponsors = scholarshipManager.findAllSponsors();

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("sponsorId", sponsorId);
        map.put("preferredLanguage", preferredLanguage);

        allSubsidies = (List < Map<String, Object> >)  scholarshipManager.findSubsidies(map);

        ModelAndView mav = new ModelAndView();
        mav.setViewName(viewName);
        mav.getModel().put("sponsorId", sponsorId);
        mav.getModel().put("allSubsidies", allSubsidies);
        mav.getModel().put("allSponsors", allSponsors);

        return mav;
    }

    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setScholarshipManager(final ScholarshipManagerInterface scholarshipManager) {
        this.scholarshipManager = scholarshipManager;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

}
