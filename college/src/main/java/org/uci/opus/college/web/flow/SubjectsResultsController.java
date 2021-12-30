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
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.auth.AssignedUserApplication;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;
import org.uci.opus.util.lookup.LookupUtil;

@Controller
@RequestMapping("/college/subjectsresults.view")
@SessionAttributes({ StudentsController.FORM })
public class SubjectsResultsController {

    public static final String FORM = "subjectsResultsForm";

    private String viewName = "college/exam/subjectsResults";
    private Logger log = LoggerFactory.getLogger(SubjectsResultsController.class);

    @Autowired
    private AssignedUserApplication assignedUserApplication;

    @Autowired
    private SecurityChecker securityChecker;
    
    @Autowired
    private StudyManagerInterface studyManager;
    
    @Autowired
    private SubjectManagerInterface subjectManager;
    
    @Autowired
    private OpusInit opusInit;
    
    @Autowired
    private OpusMethods opusMethods;
    
    @Autowired
    LookupCacher lookupCacher;

    public SubjectsResultsController() {
        super();
    }

    @RequestMapping
    public String setupForm(ModelMap model, HttpServletRequest request) {
		TimeTrack timer = new TimeTrack("SubjectsResultsController.setupForm");

        HttpSession session = request.getSession(false);
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int studyId = 0;
        int currentPageNumber = 1;
        int studyGradeTypeId = 0;

        // still not using form objects in this controller
        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to examinations */
        session.setAttribute("menuChoice", "exams");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

        /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        studyId = OpusMethods.getStudyId(session, request);
        request.setAttribute("studyId", studyId);

        if (!StringUtil.isNullOrEmpty(request.getParameter("currentPageNumber"))) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeIdSelect"))) {
            studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeIdSelect"));
        } else {
            if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
                studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
            }
        }
        request.setAttribute("studyGradeTypeId", studyGradeTypeId);

        int cardinalTimeUnitNumber = 0;
        if (!StringUtil.isNullOrEmpty(request.getParameter("cardinalTimeUnitNumber"))) {
            cardinalTimeUnitNumber = Integer.parseInt(request.getParameter("cardinalTimeUnitNumber"));
        }
        request.setAttribute("cardinalTimeUnitNumber", cardinalTimeUnitNumber);

        String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "").trim();

        request.setAttribute("pagingParams", "studyId=" + studyId + "&studyGradeTypeId=" + studyGradeTypeId + "&searchValue=" + searchValue);

        /*
         * find a LIST OF INSTITUTIONS of the correct educationtype
         * 
         * set first the institutionTypeCode; for now studies, and therefore subjects, are only registered for universities; if in the future
         * this should change, it will be easier to alter the code
         */
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId,
                organizationalUnitId);

        /* fill lookup-tables with right values */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);

        // year / semester / ... TODO
        LookupUtil.putCodeToDescriptionMap(request, "allCardinalTimeUnits", "allCardinalTimeUnitsMap");

        Organization organization = new Organization();
        organization.setInstitutionId(institutionId);
        organization.setBranchId(branchId);
        organization.setOrganizationalUnitId(organizationalUnitId);
        organization.setInstitutionTypeCode(institutionTypeCode);

        // ACADEMIC YEARS
        List<AcademicYear> allAcademicYears = null;
        Map<String, Object> map = new HashMap<>();
        /* perform role check. */
        if ("finance".equals(opusUserRole.getRole()) || "audit".equals(opusUserRole.getRole())) {
            map.put("organizationalUnitId", 0);
        } else {
            map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        }
        map.put("studyId", studyId);
        allAcademicYears = studyManager.findAllAcademicYears(map);
        request.setAttribute("allAcademicYears", allAcademicYears);
        timer.measure("lookups");

        // STUDIES
        List<Study> allStudies = null;
        Map<String, Object> findSubjectsMap = new HashMap<>();
        findSubjectsMap.put("institutionId", organization.getInstitutionId());
        findSubjectsMap.put("branchId", organization.getBranchId());
        findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        allStudies = studyManager.findStudies(findSubjectsMap);
        request.setAttribute("allStudies", allStudies);
        timer.measure("all studies");

        // STUDYGRADETYPES
        List<StudyGradeType> allStudyGradeTypes = null;
        findSubjectsMap.put("studyId", studyId);
        findSubjectsMap.put("preferredLanguage", preferredLanguage);
        allStudyGradeTypes = studyManager.findStudyGradeTypes(findSubjectsMap);
        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);
        timer.measure("all study grade types");

        // Cardinal time unit numbers
        List<CardinalTimeUnitStudyGradeType> allCardinalTimeUnitStudyGradeTypes = null;
        if (studyGradeTypeId != 0) {
            allCardinalTimeUnitStudyGradeTypes = studyManager.findCardinalTimeUnitStudyGradeTypes(studyGradeTypeId);
            timer.measure("findCardinalTimeUnitStudyGradeTypes");
        }
        request.setAttribute("allCardinalTimeUnitStudyGradeTypes", allCardinalTimeUnitStudyGradeTypes);

        // LIST OF SUBJECTS
        List<? extends Subject> allSubjects = null;
        findSubjectsMap.put("searchValue", searchValue);
        findSubjectsMap.put("active", "");
        findSubjectsMap.put("rigidityTypeCode", null);
        if (studyGradeTypeId != 0) {
            findSubjectsMap.put("studyGradeTypeId", studyGradeTypeId);
        }
        if (cardinalTimeUnitNumber != 0) {
            findSubjectsMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        }

        // Logged-in user has to have the privilege to read all students or be assigned to the subject or examination
        // Note: It's fine to see all subjects, examinations and tests even if user is only assigned to e.g. an examination. 
        //       The detailed authorization check is within the result screens.
        assignedUserApplication.applyAssignedStaffMember(request, findSubjectsMap, "subjectOrExaminationOrTestStaffMemberId");

        // get the total count that apply to the filter criteria
        int subjectCount = subjectManager.findSubjectCount(findSubjectsMap);
        request.setAttribute("subjectCount", subjectCount);
        timer.measure("subject count");

        // int iPaging = opusMethods.getIPaging(session);
        int iPaging = opusInit.getPaging();
        findSubjectsMap.put("offset", (currentPageNumber - 1) * iPaging);
        findSubjectsMap.put("limit", iPaging);

        allSubjects = (ArrayList<Subject>) subjectManager.findSubjects(findSubjectsMap);
        timer.measure("subjects");

        // add studyGradeTypes to each subject
        List<SubjectStudyGradeType> allSubjectStudyGradeTypes = null;
        Map<String, Object> gradeTypesMap = new HashMap<>();
        gradeTypesMap.put("preferredLanguage", preferredLanguage);

        Subject subject = null;
        for (int i = 0; i < allSubjects.size(); i++) {

            // get the subject
            subject = allSubjects.get(i);
            // set the subjectId
            gradeTypesMap.put("subjectId", subject.getId());

            // TODO BEGIN (MP 2013-08-02) - see also in JSP
            // get rid of studyGradeTypeIdForSubject - doesn't make sense: there can be more than one per subject.
            // Deal with this on a per student basis in subjectResults, examinationResults and testResults
            // (every student may follow a different study program!)
            if (studyGradeTypeId != 0) {
                gradeTypesMap.put("studyGradeTypeId", studyGradeTypeId);
            }
            // get and set the studyGradeTypes of this subject
            allSubjectStudyGradeTypes = (ArrayList<SubjectStudyGradeType>) subjectManager.findSubjectStudyGradeTypes(gradeTypesMap);
            subject.setSubjectStudyGradeTypes(allSubjectStudyGradeTypes);
            // TODO END
        }
        request.setAttribute("allSubjects", allSubjects);

        timer.end();
        return viewName;
    }

}
