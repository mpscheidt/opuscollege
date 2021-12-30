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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.scholarship.domain.Bank;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.ScholarshipStudentData;
import org.uci.opus.scholarship.domain.StudyPlanCardinalTimeUnit4Display;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.scholarship.validators.ScholarshipStudentValidator;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

/*
 * ATTENTION: This controller needs a ComplaintForm.
 * 
 * It has been migrated away from a SimpleFormController and works only when
 * as long as no validation errors occur, otherwise data on request (such as allXyz) is not set.
 * 
 */

@Controller
@RequestMapping("scholarship/scholarshipstudent")
@SessionAttributes({ ScholarshipStudentEditController.FORM_OBJECT })
public class ScholarshipStudentEditController {

    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "scholarship/student/scholarshipstudent";

    private static Logger log = LoggerFactory.getLogger(ScholarshipStudentEditController.class);

    private ScholarshipStudentValidator validator = new ScholarshipStudentValidator();


    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private StudyManagerInterface studyManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private ScholarshipManagerInterface scholarshipManager;

    @Autowired
    private ScholarshipLookupCacher scholarshipLookupCacher;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;
    
    @Autowired
    private OpusInit opusInit;

    public ScholarshipStudentEditController() {
        super();
    }

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);

        ScholarshipStudent scholarshipStudent = null;
        Student student = null;
        int institutionId = 0;
        int branchId = 0;
        // id of selected organizational unit
        int organizationalUnitId = 0;
        // the organizational unit of the study and its description
        int studentId = 0;
        String deleteScholarshipDataText = "";
        int panel = 0;
        int tab = 0;
        int scholarshipStudentId = 0;
        String complaintsHeader = "";
        int currentPageNumber = 0;

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Locale currentLoc = RequestContextUtils.getLocale(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipStudentId"))) {
            scholarshipStudentId = Integer.parseInt(request.getParameter("scholarshipStudentId"));
        }

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);

        // get the searchValue and put it on the session
        // searchValue = ServletUtil.getStringParamSetOnSession(session, request, "searchValue");

        /* fetch chosen institutionId and branchId */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        // get primary study if not present
        // if (studyId == 0 && studentId != 0) {
        // studyId =
        // studentManager.findStudent(preferredLanguage, studentId).getPrimaryStudyId();
        // }
        // if (studyId != 0) {
        // unitStudy = (OrganizationalUnit)
        // organizationalUnitManager.findOrganizationalUnitOfStudy(studyId);
        // }
        // if (unitStudy != null) {
        // unitStudyDescription = unitStudy.getOrganizationalUnitDescription();
        // session.setAttribute("unitStudyDescription", unitStudyDescription);
        // }

        // set the institutionTypeCode
        String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId, organizationalUnitId);

        /*
         * get scholarship student domain lookups
         */
        List<Study> allStudies = null;
        if (organizationalUnitId != 0) {
            Map<String, Object> findStudiesMap = new HashMap<>();

            findStudiesMap.put("institutionId", institutionId);
            findStudiesMap.put("branchId", branchId);
            findStudiesMap.put("organizationalUnitId", organizationalUnitId);
            findStudiesMap.put("institutionTypeCode", institutionTypeCode);
            allStudies = studyManager.findStudies(findStudiesMap);
        }
        request.setAttribute("allStudies", allStudies);

        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        } else {
            if (scholarshipStudentId != 0) {
                student = scholarshipManager.findStudentByScholarshipStudentId(scholarshipStudentId);
                studentId = student.getStudentId();
            }
        }
        if (student != null) {
            scholarshipStudent = new ScholarshipStudent(student);
            if ("Y".equals(student.getScholarship())) {
                ScholarshipStudentData scholarshipStudentData = scholarshipManager.findScholarshipStudentData(studentId);
                if (scholarshipStudentData != null) {
                    scholarshipStudent.setAccount(scholarshipStudentData.getAccount());
                    scholarshipStudent.setAccountActivated(scholarshipStudentData.getAccountActivated());
                    scholarshipStudent.setBankId(scholarshipStudentData.getBankId());
                    scholarshipStudent.setComplaints(scholarshipStudentData.getComplaints());
                    scholarshipStudent.setScholarships(scholarshipStudentData.getScholarships());
                    scholarshipStudent.setScholarshipStudentId(scholarshipStudentData.getScholarshipStudentId());
                    scholarshipStudent.setSubsidies(scholarshipStudentData.getSubsidies());
                }
            }
        }
        request.setAttribute("student", student);

        List<? extends StudyGradeType> allStudyGradeTypes = null;
        allStudyGradeTypes = opusMethods.getAllStudyGradeTypes(session, request);
        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);
        List<StudyPlanCardinalTimeUnit4Display> allStudyPlanCardinalTimeUnits4Display = scholarshipManager.getAllStudyPlanCardinalTimeUnits4Display(request, preferredLanguage,
                studentId);
        request.setAttribute("allStudyPlanCardinalTimeUnits4Display", allStudyPlanCardinalTimeUnits4Display);

        /* put scholarship lookup-tables on the request */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);
        scholarshipLookupCacher.getScholarshipLookups(preferredLanguage, request);

        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        request.setAttribute("allAcademicYears", allAcademicYears);

        /* keep track of student having applied for scholarship or not */
        request.setAttribute("initiallyAppliedForScholarship", scholarshipStudent.getScholarship());

        List<Bank> allBanks = scholarshipManager.findBanks();
        request.setAttribute("allBanks", allBanks);

        Map<String, Object> findScholarshipsMap = new HashMap<String, Object>();
        List<Scholarship> allScholarships = scholarshipManager.findAllScholarships(findScholarshipsMap);
        request.setAttribute("allScholarships", allScholarships);

        deleteScholarshipDataText = messageSource.getMessage("jsp.scholarshipdata.delete.confirm", null, currentLoc);
        request.setAttribute("deleteScholarshipDataText", deleteScholarshipDataText);

        // complaintsHeader:
        complaintsHeader = "<b>" + messageSource.getMessage("jsp.general.date", null, currentLoc);
        complaintsHeader = complaintsHeader + "\t" + messageSource.getMessage("jsp.general.reason", null, currentLoc);
        complaintsHeader = complaintsHeader + "\t" + messageSource.getMessage("jsp.general.result", null, currentLoc);
        complaintsHeader = complaintsHeader + "\t" + messageSource.getMessage("jsp.general.status", null, currentLoc);
        complaintsHeader = complaintsHeader + "\t" + messageSource.getMessage("jsp.general.active", null, currentLoc) + "</b>";
        request.setAttribute("complaintsHeader", complaintsHeader);

        String iNationality = opusInit.getNationality();
        request.setAttribute("iNationality", iNationality);

        model.put(FORM_OBJECT, scholarshipStudent);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) ScholarshipStudent scholarshipStudent, BindingResult result) {

        validator.validate(scholarshipStudent, result);
        
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int tab = 0;
        int panel = 0;
        /*
         * used to create personCode and studentCode if necessary. DO NOT use the name
         * "organizationalUnitId" in this instance: it will create errors in the application.
         */
        String initiallyAppliedForScholarship = "";
        ScholarshipStudentData existingScholarshipStudentData = null;
        int currentPageNumber = 0;

        /* reset request attributes */
        request.setAttribute("institutionId", null);
        request.setAttribute("branchId", null);
        request.setAttribute("organizationalUnitId", null);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);

        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_personaldata"))) {
            tab = Integer.parseInt(request.getParameter("tab_personaldata"));
        } else {
            if (!StringUtil.isNullOrEmpty(request.getParameter("tab_scholarships"))) {
                tab = Integer.parseInt(request.getParameter("tab_scholarships"));
            } else {
                if (!StringUtil.isNullOrEmpty(request.getParameter("tab_subsidies"))) {
                    tab = Integer.parseInt(request.getParameter("tab_subsidies"));
                } else {
                    if (!StringUtil.isNullOrEmpty(request.getParameter("tab_complaints"))) {
                        tab = Integer.parseInt(request.getParameter("tab_complaints"));
                    } else {
                        if (!StringUtil.isNullOrEmpty(request.getParameter("tab_accountdata"))) {
                            tab = Integer.parseInt(request.getParameter("tab_accountdata"));
                        } else {
                            if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
                                tab = Integer.parseInt(request.getParameter("tab"));
                            }
                        }
                    }
                }
            }
        }
        request.setAttribute("tab", tab);

        if (!StringUtil.isNullOrEmpty((String) request.getAttribute("initiallyAppliedForScholarship"))) {
            initiallyAppliedForScholarship = (String) request.getAttribute("initiallyAppliedForScholarship");
        }

        // update ScholarshipStudent for attribute appliedForScholarship
        if (initiallyAppliedForScholarship != scholarshipStudent.getScholarship()) {
            Map<String, Object> updateAppliedForScholarshipForStudentMap = new HashMap<>();
            updateAppliedForScholarshipForStudentMap.put("studentId", scholarshipStudent.getStudentId());
            updateAppliedForScholarshipForStudentMap.put("appliedForScholarship", scholarshipStudent.getScholarship());
            scholarshipManager.updateAppliedForScholarshipForStudent(updateAppliedForScholarshipForStudentMap);

            if ("N".equals(scholarshipStudent.getScholarship())) {
                /* delete all scholarshipstudent data for this student */
                scholarshipManager.deleteScholarshipStudent(scholarshipStudent.getScholarshipStudentId());
            }
        }

        if ("Y".equals(scholarshipStudent.getScholarship())) {
            // check if scholarshipStudent already exists for this student, otherwise create new one
            existingScholarshipStudentData = scholarshipManager.findScholarshipStudentData(scholarshipStudent.getStudentId());

            if (existingScholarshipStudentData == null) {
                log.info("adding " + scholarshipStudent);
                scholarshipManager.addScholarshipStudent(scholarshipStudent);
            } else {
                log.info("updating " + scholarshipStudent);
                scholarshipManager.updateScholarshipStudent(scholarshipStudent);
            }
        }

        return "redirect:/scholarship/scholarshipstudent.view?tab=" + tab + "&panel=" + panel + "&studentId=" + scholarshipStudent.getStudentId()
                + "&currentPageNumber=" + currentPageNumber;
    }

}
