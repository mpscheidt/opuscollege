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

import java.util.ArrayList;
import java.util.Date;
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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.lookup.LookupUtil;

public class FeesStudyController extends AbstractController {

    private static Logger log = LoggerFactory.getLogger(FeesStudyController.class);

    private SecurityChecker securityChecker;    
    private String viewName;
    private FeeManagerInterface feeManager;
    private StudyManagerInterface studyManager;
    private SubjectManagerInterface subjectManager;
    private OpusMethods opusMethods;
    private LookupManagerInterface lookupManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private FeeLookupCacher feeLookupCacher;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private LookupUtil lookupUtil;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public FeesStudyController() {
        super();
    }

    /** 
     * @see org.springframework.web.servlet.mvc.AbstractController
     *      #handleRequestInternal(javax.servlet.http.HttpServletRequest
     *      , javax.servlet.http.HttpServletResponse)
     */
    protected ModelAndView handleRequestInternal(HttpServletRequest request, 
            HttpServletResponse response) throws Exception {

        // declare variables
        HttpSession session = request.getSession(false);

        Study study = null;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        String institutionTypeCode = "";
        int studyId = 0;
        String showFeeEditError = "";
        int currentPageNumber = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to fees */
        session.setAttribute("menuChoice", "fee");

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // get the StudyId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("showFeeEditError"))) {
            showFeeEditError = request.getParameter("showFeeEditError");
        }
        request.setAttribute("showFeeEditError", showFeeEditError);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        if (StringUtil.isNullOrEmpty(institutionTypeCode, true)) {
            institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, institutionTypeCode, institutionId
                , branchId, organizationalUnitId);

        // EXISTING STUDY
        if (studyId != 0) {
            study = studyManager.findStudy(studyId);
        }
        request.setAttribute("study",study);

        /* domain-attributes  */
        List < ? extends Study > allStudies = null;
        allStudies = studyManager.findAllStudies();
        request.setAttribute("allStudies", allStudies);

        List < ? extends StudyGradeType > allStudyGradeTypes = null;
        Map<String, Object> findGradeTypesMap = new HashMap<String, Object>();
        findGradeTypesMap.put("institutionId", institutionId);
        findGradeTypesMap.put("branchId", branchId);
        findGradeTypesMap.put("organizationalUnitId", organizationalUnitId);
        findGradeTypesMap.put("preferredLanguage", preferredLanguage);
        findGradeTypesMap.put("institutionTypeCode", institutionTypeCode);
        allStudyGradeTypes = studyManager.findStudyGradeTypes(findGradeTypesMap);
        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);

        List < ? extends SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes = null;
        Map<String, Object> findSubjectBlockStudyGradeTypesMap = new HashMap<String, Object>();
        findSubjectBlockStudyGradeTypesMap.put("institutionId", institutionId);
        findSubjectBlockStudyGradeTypesMap.put("branchId", branchId);
        findSubjectBlockStudyGradeTypesMap.put("organizationalUnitId", organizationalUnitId);
        // do not specify study, since there might be subjectblocks from other studies:
        findSubjectBlockStudyGradeTypesMap.put("studyId", 0);
        //findSubjectBlocksMap.put("gradeTypeCode", null);
        findSubjectBlockStudyGradeTypesMap.put("institutionTypeCode", institutionTypeCode);
        findSubjectBlockStudyGradeTypesMap.put("active", "");
        allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes2(findSubjectBlockStudyGradeTypesMap);
        request.setAttribute("allSubjectBlockStudyGradeTypes", allSubjectBlockStudyGradeTypes);

        List < ? extends SubjectStudyGradeType > allSubjectStudyGradeTypes = null;
        Map<String, Object> findSubjectStudyGradeTypesMap = new HashMap<String, Object>();
        findSubjectStudyGradeTypesMap.put("institutionId", institutionId);
        findSubjectStudyGradeTypesMap.put("branchId", branchId);
        // do not specify organizationalUnit, since there might be subjects from other studies:
        findSubjectStudyGradeTypesMap.put("organizationalUnitId", 0);
        // do not specify study, since there might be subjects from other studies:
        findSubjectStudyGradeTypesMap.put("studyId", 0);
        findSubjectStudyGradeTypesMap.put("institutionTypeCode", institutionTypeCode);
        findSubjectStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
        allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes2(findSubjectStudyGradeTypesMap);
        request.setAttribute("allSubjectStudyGradeTypes", allSubjectStudyGradeTypes);

        List < ? extends Fee > allFeesForSubjectBlockStudyGradeTypes = null;
        allFeesForSubjectBlockStudyGradeTypes = feeManager.findFeesForSubjectBlockStudyGradeTypes(studyId);
        request.setAttribute("allFeesForSubjectBlockStudyGradeTypes", allFeesForSubjectBlockStudyGradeTypes);

        List < ? extends Fee > allFeesForStudyGradeTypes = null;
        allFeesForStudyGradeTypes = feeManager.findFeesForStudyGradeTypes(studyId);
        request.setAttribute("allFeesForStudyGradeTypes", allFeesForStudyGradeTypes);
        
        List < ? extends Fee > allFeesForSubjectStudyGradeTypes = null;
        allFeesForSubjectStudyGradeTypes = feeManager.findFeesForSubjectStudyGradeTypes(studyId);
        request.setAttribute("allFeesForSubjectStudyGradeTypes", allFeesForSubjectStudyGradeTypes);

        request.setAttribute("allFeeCategories",lookupManager.findAllRows(preferredLanguage, "fee_feeCategory"));
        List < ? extends Lookup > allStudyForms  = (List <?extends Lookup>) lookupManager.findAllRows(preferredLanguage, "studyForm");
        List < ? extends Lookup > allStudyTimes  = (List <?extends Lookup>) lookupManager.findAllRows(preferredLanguage, "studyTime");
        request.setAttribute("allStudyForms",allStudyForms);
        request.setAttribute("allStudyTimes",allStudyTimes);
        request.setAttribute("codeToStudyFormMap", new CodeToLookupMap(allStudyForms));
        request.setAttribute("codeToStudyTimeMap", new CodeToLookupMap(allStudyTimes));

        List<Lookup> allStudyIntensities = lookupCacher.getAllStudyIntensities(preferredLanguage);
        allStudyIntensities = new ArrayList<Lookup>(allStudyIntensities);   // make it modifyable
        allStudyIntensities.add(lookupUtil.getLookupCalledAny(request));

        CodeToLookupMap codeToStudyIntensityMap = new CodeToLookupMap(allStudyIntensities);
        request.setAttribute("codeToStudyIntensityMap", codeToStudyIntensityMap);
        request.setAttribute("allFeeUnitsMap", new CodeToLookupMap(feeLookupCacher.getAllFeeUnits(preferredLanguage)));

        List <AcademicYear> allAcademicYears = 
            academicYearManager.findAllAcademicYears();
        request.setAttribute("allAcademicYears",allAcademicYears);
        request.setAttribute("idToAcademicYearMap", new IdToAcademicYearMap(allAcademicYears));

//		List < IAccommodationFee > allAccommodationFees = new ArrayList<IAccommodationFee>();
//		log.info("feeServiceExtensions.getAccommodationFeeFinders()" + feeServiceExtensions.getAccommodationFeeFinders());
//        if (feeServiceExtensions.getAccommodationFeeFinders() != null) {
//            Map<String, Object> params = new HashMap<String, Object>();
//            params.put("active", "Y");
//	        for (AccommodationFeeFinder accommodationFeeFinder : feeServiceExtensions.getAccommodationFeeFinders()) {
//	            List fees = accommodationFeeFinder.findAccommodationFeesByParams(params);
//	            if (fees != null) {
//	                allAccommodationFees.addAll(fees);
//	            }
//	        }
//        }
//		request.setAttribute("allAccommodationFees",allAccommodationFees);
        
        request.setAttribute("currentDate", new Date());

        return new ModelAndView(viewName); 
    }

    /**
     * @param securityChecker is set by Spring on application init
     */
    public void setSecurityChecker(final SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }


    public void setStudyManager(final StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public void setFeeManager(final FeeManagerInterface feeManager) {
        this.feeManager = feeManager;
    }

    public void setSubjectManager(final SubjectManagerInterface subjectManager) {
        this.subjectManager = subjectManager;
    }

    public void setOpusMethods(final OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

    public void setLookupManager(final LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }

}
