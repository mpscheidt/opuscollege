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

package org.uci.opus.college.web.flow.person;

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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.college.web.form.person.StudentOpusUserForm;
import org.uci.opus.college.web.util.PasswordChangeEvaluator;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/student-opususer")
@SessionAttributes({ StudentOpusUserEditController.FORM_NAME, AbstractStudentEditController.FORM_NAME_SHARED })
public class StudentOpusUserEditController extends AbstractStudentEditController<StudentOpusUserForm> {

    static final String FORM_NAME = "studentOpusUserForm";
    private static Logger log = LoggerFactory.getLogger(StudentOpusUserEditController.class);
    @Autowired
    private SecurityChecker securityChecker;
    @Autowired
    private StudentManagerInterface studentManager;
    @Autowired
    private OpusUserManagerInterface opusUserManager;
    @Autowired
    private OpusMethods opusMethods;
    @Autowired
    private LookupCacher lookupCacher;

    public StudentOpusUserEditController() {
        super();
    }

    @Override
    protected StudentOpusUserForm newFormInstance() {
        return new StudentOpusUserForm();
    }

    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        if (log.isDebugEnabled()) {
            log.debug("StudentOpusUserEditController.setUpForm entered...");
        }

        HttpSession session = request.getSession(false);

        OpusUserRole studentOpusUserRole = null;
        OpusUser studentOpusUser = null;
        String showUserNameError = "";
        String showUserLangError = "";
        String userNameError = "";

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        StudentOpusUserForm studentForm = super.setupFormShared(FORM_NAME, model, request);
        StudentFormShared shared = studentForm.getStudentFormShared();

        Student student = shared.getStudent();
        if (student == null) {
            throw new RuntimeException("No student given. Note: This screen is not applicable for the creation of new students.");
        }

        /* set menu to students */
        session.setAttribute("menuChoice", "students");

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (super.isNewForm()) {
            student.setWriteWho(opusMethods.getWriteWho(request));
            student.setStudentWriteWho(opusMethods.getWriteWho(request));

            // get all non expired roles for this user
            Map<String, Object> userRolesMap = new HashMap<>();

            userRolesMap.put("personId", student.getPersonId());

            studentOpusUserRole = opusUserManager.findOpusUserRolesByParams(userRolesMap).get(0);
            studentForm.setPersonOpusUserRole(studentOpusUserRole);

            studentOpusUser = opusUserManager.findOpusUserByPersonId(student.getPersonId());
            studentForm.setOpusUser(studentOpusUser);

            userRolesMap.put("userName", studentOpusUserRole.getUserName());
            userRolesMap.put("notExpired", "false");
            userRolesMap.put("notAvailable", "false");
            userRolesMap.put("preferredLanguage", preferredLanguage);

            List<Map<String, Object>> userRoles = (List<Map<String, Object>>) opusUserManager.findOpusUserRolesByParams2(userRolesMap);
            studentForm.setUserRoles(userRoles);

        }

        /* catch possible errors changing the opususer */
        if (!StringUtil.isNullOrEmpty(request.getParameter("showUserNameError"))) {
            showUserNameError = request.getParameter("showUserNameError");
        }
        request.setAttribute("showUserNameError", showUserNameError);
        if (!StringUtil.isNullOrEmpty(request.getParameter("showUserLangError"))) {
            showUserLangError = request.getParameter("showUserLangError");
        }
        request.setAttribute("showUserLangError", showUserLangError);
        if (!StringUtil.isNullOrEmpty(request.getParameter("userNameError"))) {
            userNameError = request.getParameter("userNameError");
        }
        request.setAttribute("userNameError", userNameError);
        return FORM_VIEW;
    }

    /**
     * @param studentForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, params = "submitopususerdata")
    public String processSubmit(@ModelAttribute(FORM_NAME) StudentOpusUserForm studentForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        StudentFormShared shared = studentForm.getStudentFormShared();
        NavigationSettings navigationSettings = shared.getNavigationSettings();
        Student student = shared.getStudent();

        HttpSession session = request.getSession(false);

        if (log.isDebugEnabled()) {
            log.debug("StudentOpusUserEditController.processSubmit entered...");
        }

        /*
         * used to create personCode and studentCode if necessary. DO NOT use the name "organizationalUnitId" in this instance: it will
         * create errors in the application.
         */
        int tmpOrganizationalUnitId = 0;
        String showUserNameError = "";
        String showUserLangError = "";

        OpusUserRole studentOpusUserRole = studentForm.getPersonOpusUserRole();
        OpusUser studentOpusUser = studentForm.getOpusUser();

        /* fill opusUser */
        if (!StringUtil.isNullOrEmpty(studentOpusUserRole.getUserName())) {
            studentOpusUser.setUserName(studentOpusUserRole.getUserName());
        }

        // reset failed login attempts if checkbox selected
        if (!StringUtil.isNullOrEmpty(request.getParameter("opusUser_resetFailedLoginAttempts"))) {
            studentOpusUser.setFailedLoginAttempts(0);
        }

        /* if personCode or studentCode are made empty, give default values */
        tmpOrganizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        if (StringUtil.isNullOrEmpty(student.getPersonCode())) {
            /* generate personCode */
            String personCode = StringUtil.createUniqueCode("P", "" + tmpOrganizationalUnitId);
            student.setPersonCode(personCode);
        }

        if (StringUtil.isNullOrEmpty(student.getStudentCode())) {
            /* generate studentCode */
            // TODO: temporarily reactivated old student code creation, because CBU situation not clear
            String studentCode = StringUtil.createUniqueCode("STU", "" + tmpOrganizationalUnitId);
            student.setStudentCode(studentCode);
            // --------------> end of temporary code

        }

        // result.pushNestedPath("student");
        // studentValidator.validate(student, result);
        // result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        // update student

        if (opusUserManager.isUserNameAlreadyExists(studentOpusUser.getUserName(), studentOpusUser.getId())
                || StringUtil.isNullOrEmpty(studentOpusUserRole.getUserName(), true)) {
            showUserNameError = "userName";
        }
        if (StringUtil.isNullOrEmpty(studentOpusUser.getLang(), true)) {
            showUserLangError = "userLang";
        }

        if (StringUtil.isNullOrEmpty(showUserNameError) && StringUtil.isNullOrEmpty(showUserLangError)) {

            studentManager.updateStudent(student, studentOpusUserRole, studentOpusUser, null);

        }

        /*
         * retrieve updated or new student for its studentId, only if no error occurred Note MP 2016-09-05: studentId never changes,
         * therefore deactivated the student reload
         */
        Student changedStudent;
        // if (StringUtil.isNullOrEmpty(showUserNameError) && StringUtil.isNullOrEmpty(showUserLangError)) {
        // changedStudent = studentManager.findStudentByCode(student.getStudentCode());
        // } else {
        changedStudent = student;
        // }

        String opusUserName = "";
        if (studentOpusUser != null) {
            opusUserName = studentOpusUser.getUserName();
        }

        return "redirect:/college/student-opususer.view?tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() + "&studentId="
                + changedStudent.getStudentId() + "&from=student" + "&showUserNameError=" + showUserNameError + "&userNameError=" + opusUserName
                + "&showUserLangError=" + showUserLangError + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    @RequestMapping(method = RequestMethod.POST, params = "submitpwuserdata")
    public String processSubmitPassword(@ModelAttribute(FORM_NAME) StudentOpusUserForm studentForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        StudentFormShared shared = studentForm.getStudentFormShared();
        NavigationSettings navigationSettings = shared.getNavigationSettings();
        Student student = shared.getStudent();

        String dbPw = "";

        if (log.isDebugEnabled()) {
            log.debug("StudentOpusUserEditController.processSubmitPassword entered...");
        }

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole studentOpusUserRole = studentForm.getPersonOpusUserRole();
        OpusUser studentOpusUser = studentForm.getOpusUser();

        // get the pw from the database if the user exists
        if (studentOpusUser != null && studentOpusUser.getPersonId() != 0) {
            dbPw = opusUserManager.findOpusUserByPersonId(studentOpusUser.getPersonId()).getPw();
        }

        PasswordChangeEvaluator pwEval = new PasswordChangeEvaluator(request, studentOpusUser, dbPw, studentForm.getCurrentPassword(),
                studentForm.getNewPassword(), studentForm.getConfirmPassword());
        pwEval.checkAndSetPassword(result);

        if (result.hasErrors()) {
            // put lookups on the request again
            lookupCacher.getPersonLookups(preferredLanguage, request);
            lookupCacher.getStudentLookups(preferredLanguage, request);

            request.setAttribute("from", "student");

            return FORM_VIEW;
        }

        boolean pwdChanged = false;
        String newPasswordInClear = null;

        // update student
        studentManager.updateStudent(student, studentOpusUserRole, studentOpusUser, dbPw);

        // SHOW NEW ACCOUNT DATA IN TEXT FILE
        if (studentOpusUser != null && !StringUtil.isNullOrEmpty(studentOpusUser.getPw()) && !studentOpusUser.getPw().equals(dbPw) && request != null) {
            pwdChanged = true;
            newPasswordInClear = studentForm.getNewPassword();
        }

        /*
         * retrieve updated or new student for its studentId, only if no error occurred Note MP 2016-09-05: studentId never changes,
         * therefore deactivated the student reload
         */
        Student changedStudent;
        // if (StringUtil.isNullOrEmpty(showUserNameError) && StringUtil.isNullOrEmpty(showUserLangError)) {
        // changedStudent = studentManager.findStudentByCode(student.getStudentCode());
        // } else {
        changedStudent = student;
        // }

        if (pwdChanged) {
            // if the user is new or the password has changed, show new password on new screen
            request.setAttribute("tab", navigationSettings.getTab());
            request.setAttribute("panel", navigationSettings.getPanel());
            request.setAttribute("username", studentOpusUser.getUsername());
            request.setAttribute("password", newPasswordInClear);
            request.setAttribute("studentId", changedStudent.getStudentId());
            request.setAttribute("from", "student");
            request.setAttribute("currentPageNumber", navigationSettings.getCurrentPageNumber());

            return "college/person/pw";

        } else {

            // status.setComplete();

            return "redirect:/college/student-opususer.view?tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() + "&studentId="
                    + changedStudent.getStudentId() + "&from=student" + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        }
    }

}
