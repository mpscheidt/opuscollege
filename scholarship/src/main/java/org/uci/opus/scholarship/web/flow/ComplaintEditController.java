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
import java.util.Map;

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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.scholarship.domain.Complaint;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.ScholarshipApplication;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.util.ScholarshipLookupCacher;
import org.uci.opus.scholarship.validators.ComplaintValidator;
import org.uci.opus.util.LookupCacher;
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
@RequestMapping("/scholarship/complaint")
@SessionAttributes({ ComplaintEditController.FORM_OBJECT })
public class ComplaintEditController {

    public static final String FORM_OBJECT = "command";
    private static final String FORM_VIEW = "scholarship/student/complaint";

    private static Logger log = LoggerFactory.getLogger(ComplaintEditController.class);

    private ComplaintValidator validator = new ComplaintValidator();


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

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public ComplaintEditController() {
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

        int complaintId = 0;
        int scholarshipApplicationId = 0;
        Complaint complaint = null;
        int panel = 0;
        int tab = 0;
        int studentId = 0;
        int scholarshipStudentId = 0;
        Student student = null;
        ScholarshipApplication scholarshipApplication = null;
        List<Scholarship> allScholarships = null;
        int currentPageNumber = 0;

        /* set menu to subjects */
        session.setAttribute("menuChoice", "scholarship");

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        request.setAttribute("panel", panel);
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }
        request.setAttribute("tab", tab);

        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }
        request.setAttribute("currentPageNumber", currentPageNumber);

        // get the complaintId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("complaintId"))) {
            complaintId = Integer.parseInt(request.getParameter("complaintId"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }
        request.setAttribute("studentId", studentId);
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipStudentId"))) {
            scholarshipStudentId = Integer.parseInt(request.getParameter("scholarshipStudentId"));
        }
        request.setAttribute("scholarshipStudentId", scholarshipStudentId);

        // get the scholarshipApplicationId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipApplicationId"))) {
            scholarshipApplicationId = Integer.parseInt(request.getParameter("scholarshipApplicationId"));
        }
        scholarshipApplication = scholarshipManager.findScholarshipApplication(scholarshipApplicationId);
        request.setAttribute("scholarshipApplication", scholarshipApplication);

        // EXISTING COMPLAINT
        if (complaintId != 0) {
            complaint = scholarshipManager.findComplaint(complaintId);
        } else {
            complaint = new Complaint();
            complaint.setScholarshipApplicationId(scholarshipApplicationId);
            complaint.setActive("Y");
            complaint.setComplaintStatusCode("OP");
            complaint.setComplaintDate(new Date());
        }

        /* fill lookup-tables with right values */
        request = scholarshipLookupCacher.getScholarshipLookups(preferredLanguage, request);

        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        request.setAttribute("allAcademicYears", allAcademicYears);

        Map<String, Object> scholarshipMap = new HashMap<>();
        scholarshipMap.put("preferredLanguage", preferredLanguage);
        allScholarships = scholarshipManager.findAllScholarships(scholarshipMap);
        request.setAttribute("allScholarships", allScholarships);

        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        request.setAttribute("student", student);

        model.put(FORM_OBJECT, complaint);
        
        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) Complaint complaint, BindingResult result) {

        validator.validate(complaint, result);

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int tab = 0;
        int panel = 0;
        int studentId = 0;
        int scholarshipStudentId = 0;
        int scholarshipApplicationId = 0;
        int currentPageNumber = 0;

        if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
            panel = Integer.parseInt(request.getParameter("panel"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
            tab = Integer.parseInt(request.getParameter("tab"));
        }

        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipStudentId"))) {
            scholarshipStudentId = Integer.parseInt(request.getParameter("scholarshipStudentId"));
        }

        // get the scholarshipApplicationId if it exists
        if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipApplicationId"))) {
            scholarshipApplicationId = Integer.parseInt(request.getParameter("scholarshipApplicationId"));
        }
        if (request.getParameter("currentPageNumber") != null) {
            currentPageNumber = Integer.parseInt(request.getParameter("currentPageNumber"));
        }

        if (complaint.getId() == 0) {
            log.info("adding " + complaint);
            scholarshipManager.addComplaint(complaint);
        } else {
            log.info("updating " + complaint);
            scholarshipManager.updateComplaint(complaint);
        }

//        ModelAndView mav = new ModelAndView();
//        mav.getModelMap().put("tab", tab);
//        mav.getModelMap().put("panel", panel);
//        mav.getModelMap().put("studentId", studentId);
//        mav.getModelMap().put("scholarshipStudentId", scholarshipStudentId);
//        mav.getModelMap().put("scholarshipApplicationId", scholarshipApplicationId);
//        mav.getModelMap().put("currentPageNumber", currentPageNumber);
//        successView = "redirect:/scholarship/scholarshipapplication.view";
//        mav.setViewName(successView);

        return "redirect:/scholarship/scholarshipapplication.view?newForm=true&studentId=" + studentId
                + "&scholarshipStudentId=" + scholarshipStudentId + "&scholarshipApplicationId=" + scholarshipApplicationId
                + "&tab=" + tab + "&panel=" + panel + "&currentPageNumber=" + currentPageNumber;
    }

}
