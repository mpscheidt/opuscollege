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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet.
 *
 */

public class ComplaintsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(ComplaintsController.class);
    private SecurityChecker securityChecker;    
    private String viewName;
    private ScholarshipManagerInterface scholarshipManager;
    //    private StudyManager studyManager;
    private OpusMethods opusMethods;
    private ScholarshipLookupCacher scholarshipLookupCacher;
    private StudentManagerInterface studentManager;
    private LookupCacher lookupCacher;
    private AcademicYearManagerInterface academicYearManager;


    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public ComplaintsController() {
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
        List < AcademicYear > academicYearsForSponsor = null;
        List < Scholarship > allScholarships = null;
        List < ScholarshipStudent > allScholarshipStudents = null;
        List < ScholarshipApplication > allScholarshipApplicationComplaints = new ArrayList < ScholarshipApplication >();

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

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

        /* name of pulldown cannot be simply "academicYear" since that is also
         * the name of an attribute of scholarship
         */
        if (request.getParameter("selectedAcademicYearId") != null) {
            selectedAcademicYearId = Integer.parseInt(request.getParameter("selectedAcademicYearId"));
        }

        // should never be empty
        if (!StringUtil.isNullOrEmpty(request.getParameter("sponsorId"))) {
            sponsorId = Integer.parseInt(request.getParameter("sponsorId"));
        }

        /* fill lookup-tables with right values */
        scholarshipLookupCacher.getScholarshipLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);

        allSponsors = scholarshipManager.findAllSponsors();

        Map<String, Object> scholarshipMap = new HashMap<>();
        scholarshipMap.put("preferredLanguage", preferredLanguage);
        allScholarships = scholarshipManager.findAllScholarships(scholarshipMap);

        allScholarshipStudents = scholarshipManager.findScholarshipStudents(new HashMap<String, Object>());

        //        List < ? extends Student > allComplainingStudents = null;
        Map<String, Object> map = new HashMap<>();
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("selectedAcademicYearId", selectedAcademicYearId);
        map.put("sponsorId", sponsorId);
        //        map.put("preferredLanguage", preferredLanguage);
        map.put("complaints", "Y");

        allScholarshipApplicationComplaints = scholarshipManager.findScholarshipApplications(map);

        Map<String, Object> findacademicYearsMap = new HashMap<>();
//      findacademicYearsMap.put("institutionId", institutionId);
//      findacademicYearsMap.put("branchId", branchId);
//      findacademicYearsMap.put("organizationalUnitId",organizationalUnitId);
//      findacademicYearsMap.put("studyId", 0);
//      findacademicYearsMap.put("institutionTypeCode", OpusConstants.EDUCATION_TYPE_HIGHER_EDUCATION);
//      findacademicYearsMap.put("searchValue", "");
      allAcademicYears = (List < AcademicYear >)
              academicYearManager.findAcademicYears(findacademicYearsMap);
        
        // academicyears:
        if (sponsorId != 0) {
          academicYearsForSponsor = (List < AcademicYear >)
            scholarshipManager.findAcademicYearsForSponsor(sponsorId);
        }
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName(viewName);
        mav.getModel().put("sponsorId", sponsorId);
        mav.getModel().put("selectedAcademicYearId", selectedAcademicYearId);
        mav.getModel().put("allScholarshipApplicationComplaints", allScholarshipApplicationComplaints);
        mav.getModel().put("allSponsors", allSponsors);
        mav.getModel().put("allAcademicYears", allAcademicYears);
        mav.getModel().put("academicYearsForSponsor", academicYearsForSponsor);
        mav.getModel().put("allScholarships", allScholarships);
        mav.getModel().put("allScholarshipStudents", allScholarshipStudents);

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

    //  public void setStudyManager(final StudyManager studyManager) {
    //      this.studyManager = studyManager;
    //  }

    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

    public void setScholarshipLookupCacher(final ScholarshipLookupCacher scholarshipLookupCacher) {
        this.scholarshipLookupCacher = scholarshipLookupCacher;
    }

    /**
     * @param studentManager the studentManager to set
     */
    public void setStudentManager(final StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }
    public void setLookupCacher(
            final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    public void setAcademicYearManager(final AcademicYearManagerInterface academicYearManager) {
        this.academicYearManager = academicYearManager;
    }

}
