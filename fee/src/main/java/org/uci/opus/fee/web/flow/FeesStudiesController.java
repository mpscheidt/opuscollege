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
 * The Original Code is Opus-College fee module code.
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
package org.uci.opus.fee.web.flow;

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
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet.
 */

public class FeesStudiesController extends AbstractController {

    private SecurityChecker securityChecker;    
    private String viewName;
    private StudyManagerInterface studyManager;
    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;
    private StudentManagerInterface studentManager;
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired FeeLookupCacher feeLookupCacher;

    private static Logger log = LoggerFactory.getLogger(FeesStudiesController.class);

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public FeesStudiesController() {
        super();
    }

    /** 
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
    protected ModelAndView handleRequestInternal(HttpServletRequest request, 
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int primaryStudyId = 0;
        int studyGradeTypeId = 0;
        //        int studyYearId = 0;
        String institutionTypeCode = "";
        int currentPageNumber = 1;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to fees */
        session.setAttribute("menuChoice", "fee");

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

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

        if (request.getParameter("primaryStudyId") != null) {
            primaryStudyId = Integer.parseInt(request.getParameter("primaryStudyId"));
        }
        request.setAttribute("primaryStudyId", primaryStudyId);

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
//      request = feeLookupCacher.getFeeLookups(preferredLanguage, request);
        request.setAttribute("allFeeCategories", feeLookupCacher.getAllFeeCategories(preferredLanguage));
        
        // LIST OF  ORGANIZATIONAL UNITS TO SHOW FOR EACH STUDY
        // this cannot be the same list as allOrganizationalUnits, because
        // allOrganizationalUnits is empty if the branch is not chosen
        List < ? extends OrganizationalUnit > organizationalUnitsForStudies = null;
        HashMap findOrganizationalUnitsMap = new HashMap();
        findOrganizationalUnitsMap.put("institutionTypeCode", institutionTypeCode);
        findOrganizationalUnitsMap.put("institutionId", institutionId);
        if ("finance".equals(opusUserRole.getRole()) 
        		|| "audit".equals(opusUserRole.getRole())
        			|| "library".equals(opusUserRole.getRole())
        				|| "dos".equals(opusUserRole.getRole())) {
        findOrganizationalUnitsMap.put("branchId", 0);
        } else {
        	findOrganizationalUnitsMap.put("branchId", branchId);
        }
        organizationalUnitsForStudies = organizationalUnitManager
        .findOrganizationalUnits(findOrganizationalUnitsMap);
        request.setAttribute("organizationalUnitsForStudies", organizationalUnitsForStudies);

        // LIST OF STUDIES
        // used to show the name of the primary study of each subject in the overview
        List < ? extends Study > allStudies = null;
        HashMap findStudiesMap = new HashMap();

        findStudiesMap.put("institutionId", institutionId);
        if ("finance".equals(opusUserRole.getRole()) 
        		|| "audit".equals(opusUserRole.getRole())
        			|| "library".equals(opusUserRole.getRole())
        				|| "dos".equals(opusUserRole.getRole())) {
        	findStudiesMap.put("branchId", 0);
        	findStudiesMap.put("organizationalUnitId", 0);
        } else {
        	findStudiesMap.put("branchId", branchId);
        	findStudiesMap.put("organizationalUnitId", organizationalUnitId);
        }
        findStudiesMap.put("institutionTypeCode", institutionTypeCode);
        allStudies = studyManager.findStudies(findStudiesMap);
        request.setAttribute("allStudies", allStudies);

        // LIST OF STUDYGRADEYPES
        List < ? extends StudyGradeType > allStudyGradeTypes = null;
        if (primaryStudyId != 0) {
            HashMap findStudyGradeTypesMap = new HashMap();
            findStudyGradeTypesMap.put("studyId", primaryStudyId);
            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
            allStudyGradeTypes = studyManager.findAllStudyGradeTypesForStudy(
                    findStudyGradeTypesMap);
        }
        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);

//        LIST OF STUDYYEARS
//        List < ? extends StudyYear > allStudyYears = null;
//        if (studyGradeTypeId != 0) {
//            allStudyYears = (List < ? extends StudyYear_old >
//            ) studyManager.findAllStudyYearsForStudyGradeType(studyGradeTypeId);
//        } else {
//            if (primaryStudyId != 0) {
//                allStudyYears = (List < ? extends StudyYear_old >
//                )studyManager.findAllStudyYearsForStudyGradeType(primaryStudyId);
//            }
//        }
//        request.setAttribute("allStudyYears", allStudyYears);

        /* retrieve student domain lookups */
//        List < ? extends Student > allStudents = null;
//        HashMap findStudentsMap = new HashMap();
//        findStudentsMap.put("institutionId", institutionId);
//        findStudentsMap.put("branchId", branchId);
//        findStudentsMap.put("organizationalUnitId", organizationalUnitId);
//        findStudentsMap.put("institutionTypeCode", institutionTypeCode);
//        findStudentsMap.put("studyId", primaryStudyId);
//        findStudentsMap.put("studyGradeTypeId", studyGradeTypeId);
//        
//        int iHighestGradeOfSecondarySchoolSubjects = Integer.parseInt((String) session.getAttribute("iHighestGradeOfSecondarySchoolSubjects"));
//    	int iLowestGradeOfSecondarySchoolSubjects = Integer.parseInt((String) session.getAttribute("iLowestGradeOfSecondarySchoolSubjects"));
//
//    	findStudentsMap.put("defaultMaximumGradePoint", iHighestGradeOfSecondarySchoolSubjects);
//    	findStudentsMap.put("defaultMinimumGradePoint", iLowestGradeOfSecondarySchoolSubjects);
//
//        // get the total count of students that apply to the filter criteria
//        int studentCount = studentManager.findStudentCount(findStudentsMap);
////        studentsForm.setStudentCount(studentCount);
//        request.setAttribute("studentCount", studentCount);
//        
//        // get the students themselves
//        int iPaging = opusMethods.getIPaging(session);
//        findStudentsMap.put("offset", (currentPageNumber - 1) * iPaging);
//        findStudentsMap.put("limit", iPaging);
//        allStudents = studentManager.findStudents(findStudentsMap);
//        request.setAttribute("allStudents", allStudents);

        return new ModelAndView(viewName); 

    }

    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
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

    public void setStudentManager(final StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public void setOrganizationalUnitManager(
            final OrganizationalUnitManagerInterface organizationalUnitManager) {
        this.organizationalUnitManager = organizationalUnitManager;
    }

}
