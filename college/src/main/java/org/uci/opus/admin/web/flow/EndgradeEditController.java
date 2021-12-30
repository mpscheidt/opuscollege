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

package org.uci.opus.admin.web.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.EndGradeManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.validator.EndGradeValidator;
import org.uci.opus.college.web.form.EndGradeForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/endgrade.view")
@SessionAttributes({ "endGradeForm" })
public class EndgradeEditController {

    private static Logger log = LoggerFactory.getLogger(EndgradeEditController.class);
    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private EndGradeManagerInterface endGradeManager;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private LookupManagerInterface lookupManager;

    @Autowired
    private MessageSource messageSource;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public EndgradeEditController() {
        super();
        this.formView = "admin/endgrade";
    }

    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        // declare variables
        EndGradeForm endGradeForm = null;
        // the endGrade at hand
        EndGrade modelEndGrade = null;
        // all identical endGrades for the different languages
        List<? extends EndGrade> endGrades;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new endGrade, destroy any existing one on the session
        opusMethods.removeSessionFormObject("endGradeForm", session, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        List<String> appLanguages = opusMethods.getAppLanguages(true);

        int id = ServletUtil.getIntParam(request, "id", 0);

        /* EndGradeFORM - fetch or create the form object and fill it with endGrade */
        if ((EndGradeForm) session.getAttribute("endGradeForm") != null) {
            endGradeForm = (EndGradeForm) session.getAttribute("endGradeForm");
        } else {
            endGradeForm = new EndGradeForm();
            endGradeForm.setAppLanguagesShort(appConfigManager.getAppLanguagesShort());
        }

        // if endGrade exists, find it plus the matching endGrades with different language
        if (id != 0) {

            modelEndGrade = endGradeManager.findEndGradeById(id);

            Map<String, Object> findEndGradesMap = new HashMap<>();
            findEndGradesMap.put("code", modelEndGrade.getCode());
            findEndGradesMap.put("academicYearId", modelEndGrade.getAcademicYearId());
            findEndGradesMap.put("endGradeTypeCode", modelEndGrade.getEndGradeTypeCode());
            endGrades = endGradeManager.findEndGrades(findEndGradesMap);
            // new endGrade
        } else {
            modelEndGrade = new EndGrade(preferredLanguage);
            endGrades = endGradeForm.createNewEndGrades(appLanguages);
        }

        endGradeForm.setModelEndGrade(modelEndGrade);
        endGradeForm.setEndGrades(endGrades);

        endGradeForm.setAcademicYears(academicYearManager.findAllAcademicYears());
        endGradeForm.setEndGradeTypes(lookupManager.findAllRows(preferredLanguage, "endgradetype"));

        /* EndGradeFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (endGradeForm.getNavigationSettings() != null) {
            navigationSettings = endGradeForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }

        endGradeForm.setNavigationSettings(navigationSettings);

        model.addAttribute("endGradeForm", endGradeForm);

        return formView;
    }

    /**
     * @param endGradeForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute("endGradeForm") EndGradeForm endGradeForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = endGradeForm.getNavigationSettings();

        HttpSession session = request.getSession(false);

        EndGrade modelEndGrade = endGradeForm.getModelEndGrade();
        modelEndGrade.setWriteWho(opusMethods.getWriteWho(request));

        List<? extends EndGrade> endGrades = endGradeForm.getEndGrades();
        int id = modelEndGrade.getId();

        // set values for common fields, that is: NOT the id nor the language
        setCommons(modelEndGrade, endGrades);

        result.pushNestedPath("modelEndGrade");

        new EndGradeValidator().validate(modelEndGrade, result);

        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }

        // check if endGrade already exists
        if (endGradeManager.isEndGradeExists(modelEndGrade)) {
            endGradeForm.setTxtErr(messageSource.getMessage("jsp.error.endgrade.exists", null, RequestContextUtils.getLocale(request)));
            return formView;
        }

        // check if all comments are filled
        boolean isCommentsFilled = true;
        for (int i = 0; i < endGrades.size(); i++) {
            EndGrade endGrade = endGrades.get(i);
            if (StringUtil.isNullOrEmpty(endGrade.getComment(), true)) {
                isCommentsFilled = false;
            }
        }
        if (!isCommentsFilled) {
            endGradeForm.setTxtErr(messageSource.getMessage("jsp.error.endgrade.comment", null, RequestContextUtils.getLocale(request)));
            return formView;
        }

        // no errors: add or update
        if (id == 0) {
            endGradeManager.addEndGradeSet(endGradeForm.getEndGrades());
        } else {
            endGradeManager.updateEndGradeSet(endGradeForm.getEndGrades());
        }

        status.setComplete();

        return "redirect:/college/endgrades.view?newForm=true" + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    void setCommons(EndGrade modelEndGrade, List<? extends EndGrade> endGrades) {

        for (int i = 0; i < endGrades.size(); i++) {

            endGrades.get(i).setCode(modelEndGrade.getCode());
            endGrades.get(i).setAcademicYearId(modelEndGrade.getAcademicYearId());
            endGrades.get(i).setActive(modelEndGrade.getActive());
            endGrades.get(i).setEndGradeTypeCode(modelEndGrade.getEndGradeTypeCode());
            endGrades.get(i).setGradePoint(modelEndGrade.getGradePoint());
            endGrades.get(i).setPassed(modelEndGrade.getPassed());
            endGrades.get(i).setPercentageMax(modelEndGrade.getPercentageMax());
            endGrades.get(i).setPercentageMin(modelEndGrade.getPercentageMin());
            endGrades.get(i).setTemporaryGrade(modelEndGrade.getTemporaryGrade());
            endGrades.get(i).setWriteWho(modelEndGrade.getWriteWho());
        }
    }

}
