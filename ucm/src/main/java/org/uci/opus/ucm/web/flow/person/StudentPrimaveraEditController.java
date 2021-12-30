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

package org.uci.opus.ucm.web.flow.person;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.client.RestTemplate;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.web.flow.person.AbstractStudentEditController;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.ucm.domain.Primavera;
import org.uci.opus.ucm.domain.Result;
import org.uci.opus.ucm.web.form.person.StudentPrimaveraForm;
import org.uci.opus.util.Encode;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * Controller for personal data view and subscription view.
 */
@Controller
@RequestMapping(value = "/ucm/student-primavera")
@SessionAttributes({ StudentPrimaveraEditController.FORM_NAME, AbstractStudentEditController.FORM_NAME_SHARED })
public class StudentPrimaveraEditController extends AbstractStudentEditController<StudentPrimaveraForm> {

    private static final String REDIRECT_PRIMAVERA_VIEW = "redirect:/ucm/student/primavera.view";

    public static final String FORM_NAME = "studentPrimaveraForm";
    private Logger log = LoggerFactory.getLogger(StudentPrimaveraEditController.class);

    public StudentPrimaveraEditController() {
        super();
    }

    @Override
    protected StudentPrimaveraForm newFormInstance() {
        return new StudentPrimaveraForm();
    }

    /**
     * Load student data and return the Primavera data view.
     * 
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setUpFormPrimavera(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {
        return setupForm(model, request);
    }

    private String setupForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {

        if (log.isDebugEnabled()) {
            log.debug("setUpForm entered...");
        }

        HttpSession session = request.getSession(false);

        StudentPrimaveraForm form = super.setupFormShared(FORM_NAME, model, request);
        StudentFormShared shared = form.getStudentFormShared();
        Student student = shared.getStudent();
        if (student == null) {
            throw new RuntimeException("No student given. Note: This screen is not applicable for the creation of new students.");
        }

        /* set menu to students */
        session.setAttribute("menuChoice", "students");

        /* with each call the preferred language may be changed */
        // String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (super.isNewForm()) {
            // load data for the Primavera tab
            loadPrimaveraData(form, student.getStudentCode());
        }

        return FORM_VIEW;
    }

    private void loadPrimaveraData(StudentPrimaveraForm form, String studentCode) {
        // List<Result> primaveraPayments = new ArrayList<Result>();
        String hash = "/" + Encode.encodeMd5(new StringBuilder().append("0F5DD14AE2E38C7EBD8814D29CF6F6F0").append(studentCode).toString());
        Primavera primaveraPayments = this.getDataFromWebService(studentCode, hash);
        // model.addAttribute("primaveraPayments", primaveraPayments);
        form.setPrimavera(primaveraPayments);
    }

    private Primavera getDataFromWebService(String studentCode, String hash) {
        RestTemplate restTemplate = new RestTemplate();
        String result = (String) restTemplate.getForObject("http://ws.ucm.ac.mz/primavera/extractoconta/" + studentCode + hash, String.class, new Object[0]);
        Gson gson = new Gson();
        Primavera r = new Primavera();

        Type resultType = new TypeToken<Primavera>() {
        }.getType();
        r = (Primavera) gson.fromJson(result, resultType);
        return r;
    }

    /**
     * Store data and show Primavera view.
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmitPersonal(@ModelAttribute(FORM_NAME) StudentPrimaveraForm form, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        StudentFormShared shared = form.getStudentFormShared();
        NavigationSettings navigationSettings = shared.getNavigationSettings();
        Student student = shared.getStudent();

        return REDIRECT_PRIMAVERA_VIEW + "?tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel() + "&studentId="
                + student.getStudentId() + "&from=student" + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

}
