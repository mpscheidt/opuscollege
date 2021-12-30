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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
public class ScholarshipsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(ScholarshipsController.class);

    private final String viewName = "scholarship/scholarship/scholarships";

    @Autowired private SecurityChecker securityChecker;
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ScholarshipLookupCacher scholarshipLookupCacher;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;


    /**
     * @param lookupManager the lookupManager to set
     */
    public void setLookupManager(LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public ScholarshipsController() {
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
        int selectedAcademicYearId = 0;
        int sponsorId = 0;

        List < Sponsor > allSponsors = null;
        List < AcademicYear > allAcademicYears = null;
        List<Map<String, Object>> allScholarships = null;
        ModelAndView mav = new ModelAndView();

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        //        request.setAttribute("showError", request.getParameter("showError"));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        if (request.getParameter("currentPageNumber") != null) {
//            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
//        }
        currentPageNumber = ServletUtil.getIntParam(request, "currentPageNumber", 1);
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

        /* name of pulldown cannot be simply "academicYearId" since that is also
         * the name of an attribute of scholarship
         */
//        if (!StringUtil.isNullOrEmpty(request.getParameter("selectedAcademicYearCode"))) {
//            selectedAcademicYearId = request.getParameter("selectedAcademicYearCode");
//        }
        selectedAcademicYearId = ServletUtil.getIntParam(request, "selectedAcademicYearId", 0);

        // should never be empty
        if (!StringUtil.isNullOrEmpty(request.getParameter("sponsorId"))) {
//            String tmpSponsorId = request.getParameter("sponsorId");
            sponsorId = Integer.parseInt(request.getParameter("sponsorId"));
        }

        // should never be empty
        //        if (!StringUtil.isNullOrEmpty(request.getParameter("orderBy"))) {
        //            orderBy = request.getParameter("orderBy");
        //        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("academicYearId", selectedAcademicYearId);
        allSponsors = scholarshipManager.findSponsors(map);
        /* student lookups */
        lookupCacher.getStudentLookups(preferredLanguage, request);

        // SCHOLARSHIPS
        map = new HashMap<String, Object>();
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("sponsorId", sponsorId);
        map.put("academicYearId", selectedAcademicYearId);
        //        map.put("orderBy", orderBy);
        map.put("preferredLanguage", preferredLanguage);

        allScholarships = scholarshipManager.findScholarshipsPlusCounter(map);

        allAcademicYears = academicYearManager.findAllAcademicYears();
        mav.getModelMap().put("allSponsors", allSponsors);
        mav.getModelMap().put("allAcademicYears", allAcademicYears);
        mav.getModelMap().put("idToAcademicYearMap", new IdToAcademicYearMap(allAcademicYears));
        mav.getModelMap().put("allScholarships", allScholarships);
        mav.getModelMap().put("sponsorId", sponsorId);
        mav.getModelMap().put("selectedAcademicYearId", selectedAcademicYearId);
        //        mav.getModelMap().put("orderBy", orderBy);
        mav.getModelMap().put("action", "/scholarship/scholarships.view");
        mav.getModelMap().put("showError", request.getParameter("showError"));

        mav.setViewName(viewName);

        return mav;

    }

}
