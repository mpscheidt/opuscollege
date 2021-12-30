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
import org.uci.opus.college.domain.StudentAbsence;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.validator.StudentAbsenceValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentAbsenceForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/studentabsence")
@SessionAttributes({ StudentAbsenceEditController.FORM_OBJECT })
public class StudentAbsenceEditController {

    public static final String FORM_OBJECT = "studentAbsenceForm";
    private static final String FORM_VIEW = "college/person/studentAbsence";

    private StudentAbsenceValidator validator = new StudentAbsenceValidator();

    private static Logger log = LoggerFactory.getLogger(StudentAbsenceEditController.class);

    @Autowired
    private StudentManagerInterface studentManager;

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

        StudentAbsence studentAbsence = null;

        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);
        ServletUtil.getParamSetAttrAsInt(request, "panel", 0);
        ServletUtil.getParamSetAttrAsInt(request, "tab", 0);
        int studentAbsenceId = ServletUtil.getIntParam(request, "studentAbsenceId", 0);
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        
        StudentAbsenceForm form = new StudentAbsenceForm();
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        Student student = null;
        if (studentId != 0) {
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        form.setStudent(student);

        if (studentAbsenceId != 0) {
            studentAbsence = studentManager.findStudentAbsence(studentAbsenceId);
        } else {
            studentAbsence = new StudentAbsence();
            studentAbsence.setStudentId(studentId);
        }

        studentAbsence.setWriteWho(opusMethods.getWriteWho(request));

        form.setStudentAbsence(studentAbsence);
        model.put(FORM_OBJECT, form);
        
        return FORM_VIEW;
    }

    /**
     * Saves the new or updated contract.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) StudentAbsenceForm studentAbsenceForm, BindingResult result) {

        StudentAbsence studentAbsence = studentAbsenceForm.getStudentAbsence();

        result.pushNestedPath("studentAbsence");
        validator.validate(studentAbsence, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        if (studentAbsence.getId() == 0) {
            log.info("adding " + studentAbsence);
            studentManager.addStudentAbsence(studentAbsence);
        } else {
            log.info("updating " + studentAbsence);
            studentManager.updateStudentAbsence(studentAbsence);
        }

        int studentId = studentAbsence.getStudentId();
        
        NavigationSettings nav = studentAbsenceForm.getNavigationSettings();
        return "redirect:/college/student-absences.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&studentId=" + studentId + "&currentPageNumber="
                + nav.getCurrentPageNumber();
    }

}
