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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.scholarship.domain.ScholarshipStudent;
import org.uci.opus.scholarship.domain.ScholarshipStudentData;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.Subsidy;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.scholarship.validators.SubsidyValidator;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;

/*
 * ATTENTION: This controller needs a form.
 * 
 * It has been migrated away from a SimpleFormController and works only when
 * as long as no validation errors occur, otherwise data on request (such as allXyz) is not set.
 * 
 */

@Controller
@RequestMapping("/scholarship/subsidy")
@SessionAttributes({ SubsidyEditController.FORM_OBJECT })
public class SubsidyEditController {
    
    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "scholarship/student/subsidy";

    private SubsidyValidator validator = new SubsidyValidator();

    private static Logger log = LoggerFactory.getLogger(SubsidyEditController.class);

    @Autowired
    private ScholarshipManagerInterface scholarshipManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StudentManagerInterface studentManager;

    @Autowired
    private ScholarshipLookupCacher scholarshipLookupCacher;

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public SubsidyEditController() {
        super();
    }


    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        //binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }


    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);  

        Subsidy subsidy = null;
        Student student = null;
        ScholarshipStudent scholarshipStudent = null;
        int institutionId = 0;
        int branchId = 0;
        // id of selected organizational unit
        int organizationalUnitId = 0;
        int studentId = 0;
        int subsidyId = 0;
        int scholarshipStudentId = 0;
        int tab = 0;
        int panel = 0;
        int currentPageNumber = 0;

        /* set menu to scholarships */
        session.setAttribute("menuChoice", "scholarship");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipStudentId"))) {
            scholarshipStudentId = Integer.parseInt(request.getParameter("scholarshipStudentId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("subsidyId"))) {
            subsidyId = Integer.parseInt(
                    request.getParameter("subsidyId"));
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

        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);

        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);

        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);

        // set the EducationTypeCode
        String educationTypeCode = OpusMethods.getInstitutionTypeCode(request);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, educationTypeCode, institutionId
                , branchId, organizationalUnitId);

        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        request.setAttribute("student", student);

        if (scholarshipStudentId != 0) {
            scholarshipStudent = scholarshipManager.findScholarshipStudent(studentId);
        } else {
            scholarshipStudent = new ScholarshipStudent(student);
            if ("Y".equals(student.getScholarship())) {
                ScholarshipStudentData scholarshipStudentData = 
                    scholarshipManager.findScholarshipStudentData(studentId);
                if (scholarshipStudentData != null) {
                    scholarshipStudent.setAccount(scholarshipStudentData.getAccount());
                    scholarshipStudent.setAccountActivated(
                            scholarshipStudentData.getAccountActivated());
                    scholarshipStudent.setBankId(scholarshipStudentData.getBankId());
                    scholarshipStudent.setComplaints(scholarshipStudentData.getComplaints());
                    scholarshipStudent.setScholarships(scholarshipStudentData.getScholarships());
                    scholarshipStudent.setScholarshipStudentId(
                            scholarshipStudentData.getScholarshipStudentId());
                    scholarshipStudent.setSubsidies(scholarshipStudentData.getSubsidies());
                }
                scholarshipManager.addScholarshipStudent(scholarshipStudent);
                scholarshipStudentId = scholarshipStudent.getId();
            }
        }
        request.setAttribute("scholarshipStudent", scholarshipStudent);

        /* find the existing subsidy or create a new one */
        if (subsidyId != 0) {
            subsidy = scholarshipManager.findSubsidy(
                    subsidyId);
        } else {
            subsidy = new Subsidy();
            subsidy.setScholarshipStudentId(scholarshipStudentId);
            subsidy.setSubsidyDate(new Date());
            subsidy.setActive("Y");
        }

        /* put scholarship lookup-tables on the request */
        request = scholarshipLookupCacher.getScholarshipLookups(preferredLanguage, request);

        List < Sponsor > allSponsors = null;
        allSponsors = scholarshipManager.findAllSponsors();
        request.setAttribute("allSponsors", allSponsors);

        model.put(FORM_OBJECT, subsidy);
        
        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) Subsidy subsidy, BindingResult result) {

        validator.validate(subsidy, result);

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int tab = 0;
        int panel = 0;
        Student student = null;
        int currentPageNumber = 0;

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }

        /* add or update the subsidy */
        if (subsidy.getId() == 0) {
            log.info("adding " + subsidy);
            scholarshipManager.addSubsidy(subsidy);
        } else {
            log.info("updating " + subsidy);
            scholarshipManager.updateSubsidy(subsidy);
        }

        student = scholarshipManager.findStudentByScholarshipStudentId(
                subsidy.getScholarshipStudentId());

        return "redirect:/scholarship/scholarshipstudent.view?tab=" + tab 
                + "&panel=" + panel 
                + "&studentId=" +  student.getStudentId()
                + "&currentPageNumber=" + currentPageNumber;
    }

}
