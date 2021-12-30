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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * Simple <code>Controller</code> for overview of reports.
 *
 * @author Markus Pscheidt
 */
public class ScholarshipReportsController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(ScholarshipReportsController.class);

    private String viewName;
    private SecurityChecker securityChecker;    
    private OpusMethods opusMethods;
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    private StudyManagerInterface studyManager;
    private LookupCacher lookupCacher;
    private AcademicYearManagerInterface academicYearManager;


    @Autowired
    public ScholarshipReportsController(
            SecurityChecker securityChecker
            , OpusMethods opusMethods
            , OrganizationalUnitManagerInterface organizationalUnitManager
            , StudyManagerInterface studyManager) {
        super();
        this.securityChecker = securityChecker;
        this.opusMethods = opusMethods;
        this.organizationalUnitManager = organizationalUnitManager;
        this.studyManager = studyManager;
    }

    public ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to reports */
        //        session.setAttribute("menuChoice", "report");

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }

        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // set the institutionTypeCode
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, institutionTypeCode, institutionId
                , branchId, organizationalUnitId);

        /* fill lookup-tables with right values */
        lookupCacher.getStudentLookups(preferredLanguage, request);

        List < ? extends OrganizationalUnit > allOrganizationalUnits = null;
        Map findOrganizationalUnitsMap = new HashMap();
        findOrganizationalUnitsMap.put("institutionTypeCode", institutionTypeCode);
        allOrganizationalUnits = organizationalUnitManager
        .findOrganizationalUnits(findOrganizationalUnitsMap);
        request.setAttribute("allOrganizationalUnits", allOrganizationalUnits);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        request.setAttribute("organizationalUnitId", organizationalUnitId);

        int academicYearId = ServletUtil.getParamSetAttrAsInt(request, "academicYearId", 0);

        // pass where clause to report
        //        if (organizationalUnitId != 0) {  // don't pass 0 value
        //          request.setAttribute("whereOrganizationalUnitId", organizationalUnitId);
        //        }
        //        request.setAttribute("whereAcademicYearId", academicYearId);

        // academicyears:
        HashMap findacademicYearsMap = new HashMap();
        findacademicYearsMap.put("institutionId", institutionId);
        findacademicYearsMap.put("branchId", branchId);
        findacademicYearsMap.put("organizationalUnitId",organizationalUnitId);
        findacademicYearsMap.put("studyId", 0);
        findacademicYearsMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        findacademicYearsMap.put("searchValue", "");
        request.setAttribute("allAcademicYears", 
                academicYearManager.findAcademicYears(findacademicYearsMap));


        ServletUtil.getParamSetAttrAsString(request, "reportName", "schp_applyedFor");
        ReportController.getParamSetAttrReportFormat(request);

        ModelAndView mav = new ModelAndView();
        mav.setViewName(viewName);
        mav.getModelMap().put("currentPageNumber", currentPageNumber);

        return mav; 
    }

    /**
     * @param viewName
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    /**
     * @param securityChecker
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    /**
     * @param opusMethods The opusMethods to set.
     */
    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

    public void setLookupCacher(final LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    public void setAcademicYearManager(final AcademicYearManagerInterface academicYearManager) {
        this.academicYearManager = academicYearManager;
    }

}
