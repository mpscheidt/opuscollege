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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

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
import org.uci.opus.college.domain.StudentStudentStatus;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.validator.StudentStudentStatusValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentStudentStatusForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/studentstudentstatus")
@SessionAttributes({ StudentStudentStatusEditController.FORM_OBJECT })
public class StudentStudentStatusEditController {

    public static final String FORM_OBJECT = "studentStudentStatusForm";
    private static final String FORM_VIEW = "college/person/studentStudentStatus";

    private static Logger log = LoggerFactory.getLogger(StudentStudentStatusEditController.class);

    private StudentStudentStatusValidator validator = new StudentStudentStatusValidator();
    
    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private LookupCacher lookupCacher;
    
    @Autowired
    private OpusMethods opusMethods;

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "studentAbsenceID" is set, the
     * specified studentAbsence is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        StudentStudentStatusForm form = new StudentStudentStatusForm();
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));
        
        // no form object in this controller yet
        // opusMethods.removeSessionFormObjects(session, opusMethods.isNewForm(request));

        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);
        ServletUtil.getParamSetAttrAsInt(request, "panel", 0);
        ServletUtil.getParamSetAttrAsInt(request, "tab", 0);
        int studentId = ServletUtil.getParamSetAttrAsInt(request, "studentId", 0);
        int studentStudentStatusId = ServletUtil.getParamSetAttrAsInt(request, "studentStudentStatusId", 0);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Student student = null;
        if (studentId != 0) {
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        form.setStudent(student);

        StudentStudentStatus studentStudentStatus;
        if (studentStudentStatusId != 0) {
            studentStudentStatus = studentManager.findStudentStudentStatus(studentStudentStatusId);
        } else {
            studentStudentStatus = new StudentStudentStatus();
            studentStudentStatus.setStudentId(studentId);
            studentStudentStatus.setStartDate(new Date());
        }

        form.setAllStudentStatuses(lookupCacher.getAllStudentStatuses(preferredLanguage));

        form.setStudentStudentStatus(studentStudentStatus);
        model.put(FORM_OBJECT, form);
        
        return FORM_VIEW;
    }

    /**
     * Saves the new or updated contract.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) StudentStudentStatusForm form, BindingResult result) {

        StudentStudentStatus studentStudentStatus = form.getStudentStudentStatus();

        result.pushNestedPath("studentStudentStatus");
        validator.validate(studentStudentStatus, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        if (studentStudentStatus.getId() == 0) {
            log.info("adding " + studentStudentStatus);;
            studentManager.addStudentStudentStatus(studentStudentStatus);
        } else {
            log.info("updating " + studentStudentStatus);;
            studentManager.updateStudentStudentStatus(studentStudentStatus);
        }

        Student student = form.getStudent();

        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/student/subscription.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&studentId=" + student.getStudentId()
                + "&currentPageNumber=" + nav.getCurrentPageNumber();
    }

}
