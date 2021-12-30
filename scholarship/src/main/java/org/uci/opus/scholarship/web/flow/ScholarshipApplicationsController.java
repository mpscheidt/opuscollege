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
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
public class ScholarshipApplicationsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(ScholarshipApplicationsController.class);

    private String viewName = "scholarship/scholarshipapplication/scholarshipapplications";

    @Autowired
    private SecurityChecker securityChecker;    

    @Autowired
    private ScholarshipManagerInterface scholarshipManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    public ScholarshipApplicationsController() {
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
        int academicYearId = 0;
        int sponsorId = 0;
        int scholarshipId = 0;

        List < Sponsor > allSponsors = null;
        List < AcademicYear > allAcademicYears = null;
        List < Scholarship > allScholarships = null;
 
        ModelAndView mav = new ModelAndView();
        String appliedForScholarship = "";
        String grantedScholarship = "";
        String grantedSubsidy = "";
        int primaryStudyId = 0;
        int studyGradeTypeId = 0;
        //        int studyYearId = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

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

        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipId"))) {
            scholarshipId = Integer.parseInt(request.getParameter("scholarshipId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("academicYearId"))) {
            academicYearId = Integer.parseInt(
                    request.getParameter("academicYearId"));
        }

        String processStatusCode = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("processStatusCode"))) {
            processStatusCode = request.getParameter("processStatusCode");
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("sponsorId"))) {
            sponsorId = Integer.parseInt(request.getParameter("sponsorId"));
        } 

        if (request.getParameter("appliedForScholarship") != null) {
            appliedForScholarship = request.getParameter("appliedForScholarship");
        } else {

            appliedForScholarship = "0";
        }
        if (request.getParameter("grantedScholarship") != null) {
            grantedScholarship = request.getParameter("grantedScholarship");
        } else {
            grantedScholarship = "0";
        }
        if (request.getParameter("grantedSubsidy") != null) {
            grantedSubsidy = request.getParameter("grantedSubsidy");
        } else {
            grantedSubsidy = "0";
        }

        // remember if study is chosen
        if (request.getParameter("primaryStudyId") != null) {
            primaryStudyId = ServletUtil.getParamSetAttrAsInt(request, "primaryStudyId", 0);

        } else if (session.getAttribute("primaryStudyId") != null) {
            primaryStudyId = (Integer) session.getAttribute("primaryStudyId");
            //            request.setAttribute("primaryStudyId", primaryStudyId);
        }
        session.setAttribute("primaryStudyId", primaryStudyId);
        //        session.setAttribute("studyId", primaryStudyId);
        studyGradeTypeId = ServletUtil.getParamSetAttrAsInt(request, "studyGradeTypeId", 0);
        //        studyYearId = ServletUtil.getParamSetAttrAsInt(request, "studyYearId", 0);
        /* fill lookup-tables with right values */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);

        allSponsors = scholarshipManager.findAllSponsors();

        Map<String, Object> scholarshipMap = new HashMap<String, Object>();
        scholarshipMap.put("preferredLanguage", preferredLanguage);
        allScholarships = scholarshipManager.findAllScholarships(scholarshipMap);

        List < ? extends Student > allScholarshipStudents = null;
        Map<String, Object> findStudentsMap = new HashMap<String, Object>();

        findStudentsMap.put("institutionId", institutionId);
        findStudentsMap.put("branchId", branchId);
        findStudentsMap.put("organizationalUnitId", organizationalUnitId);
        findStudentsMap.put("institutionTypeCode", institutionTypeCode);
        findStudentsMap.put("studyId", 0);
        findStudentsMap.put("studyGradeTypeId", studyGradeTypeId);
        //        findStudentsMap.put("studyYearId", studyYearId);
        findStudentsMap.put("appliedForScholarship", appliedForScholarship);
        findStudentsMap.put("grantedScholarship", grantedScholarship);
        findStudentsMap.put("grantedSubsidy", grantedSubsidy);
        allScholarshipStudents = scholarshipManager.findStudentsAppliedForScholarship(
                findStudentsMap);
        request.setAttribute("allScholarshipStudents", allScholarshipStudents);

        //List < ? extends ScholarshipStudent > allScholarshipStudents = null;
        //allScholarshipStudents = scholarshipManager.findAllScholarshipStudents(
        //        findStudentsMap);
        //  request.setAttribute("allScholarshipStudents", allScholarshipStudents);
        allScholarshipStudents = scholarshipManager.findScholarshipStudents(new HashMap<String, Object>());

        // SCHOLARSHIPS
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("institutionId", institutionId);
        map.put("branchId", branchId);
        map.put("organizationalUnitId", organizationalUnitId);
        map.put("sponsorId", sponsorId);
        map.put("selectedAcademicYearId", academicYearId);
        map.put("scholarshipId", scholarshipId);
        map.put("preferredLanguage", preferredLanguage);
        map.put("processStatusCode", processStatusCode);
        List<ScholarshipApplication> allScholarshipApplications = scholarshipManager.findScholarshipApplications2(map);
        
        // academicyears:
        Map<String, Object> findacademicYearsMap = new HashMap<String, Object>();
        findacademicYearsMap.put("institutionId", institutionId);
        findacademicYearsMap.put("branchId", branchId);
        findacademicYearsMap.put("organizationalUnitId",organizationalUnitId);
        findacademicYearsMap.put("studyId", 0);
        findacademicYearsMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        findacademicYearsMap.put("searchValue", "");
        
        allAcademicYears = academicYearManager.findAllAcademicYears();

        mav.setViewName(viewName);
        mav.getModel().put("sponsorId", sponsorId);
        mav.getModel().put("selectedAcademicYearId", academicYearId);
        mav.getModel().put("allScholarshipApplications", allScholarshipApplications);
        mav.getModel().put("allSponsors", allSponsors);
        mav.getModel().put("allAcademicYears", allAcademicYears);
        mav.getModel().put("allScholarships", allScholarships);
        mav.getModel().put("allScholarshipStudents", allScholarshipStudents);
        mav.getModel().put("scholarshipId", scholarshipId);

        mav.getModelMap().put("processStatusCode", processStatusCode);
         mav.getModelMap().put("action", "/scholarship/scholarshipapplications.view");

        mav.setViewName(viewName);

        return mav;

    }

}
