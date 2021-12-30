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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.EndGradeManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.EndGradesForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/endgrades.view")
@SessionAttributes({ EndGradesController.END_GRADES_FORM })
public class EndGradesController {

    public static final String END_GRADES_FORM = "endGradesForm";
    private static Logger log = LoggerFactory.getLogger(EndGradesController.class);
    private String formView;

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private EndGradeManagerInterface endGradeManager;

    @Autowired
    private LookupManagerInterface lookupManager;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public EndGradesController() {
        super();
        this.formView = "admin/endgrades";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject(END_GRADES_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "admin");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /*
         * endGradesForm - fetch or create the form object and fill it with organization and navigationSettings
         */
        EndGradesForm endGradesForm = (EndGradesForm) model.get(END_GRADES_FORM);
        if (endGradesForm == null) {
            endGradesForm = new EndGradesForm();
            model.addAttribute(END_GRADES_FORM, endGradesForm);

            /* NAVIGATION SETTINGS - fetch or create the object */
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "endgrades.view");
            endGradesForm.setNavigationSettings(navigationSettings);

            Map<String, Object> findEndGradesMap = new HashMap<>();
            findEndGradesMap.put("lang", preferredLanguage);
            findEndGradesMap.put("searchValue", navigationSettings.getSearchValue());

            endGradesForm.setMapEndGrades(endGradeManager.findEndGradesAsMaps(findEndGradesMap));

            endGradesForm.setAcademicYears(academicYearManager.findAllAcademicYears());
            endGradesForm.setEndGradeTypes(lookupManager.findAllRows(preferredLanguage, "endgradetype"));

        }

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(END_GRADES_FORM) EndGradesForm endGradesForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        NavigationSettings navigationSettings = endGradesForm.getNavigationSettings();

        return "redirect:endgrades.view?&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

    @RequestMapping(method = RequestMethod.POST, params = "task=updateFormObject")
    public String updateForm(@ModelAttribute(END_GRADES_FORM) EndGradesForm endGradesForm, BindingResult result, SessionStatus status,
            HttpServletRequest request, ModelMap model) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        NavigationSettings navigationSettings = endGradesForm.getNavigationSettings();

        String endGradeTypeCode = request.getParameter("endGradeTypeCode");
        String active = request.getParameter("active");

//        int academicYearId = ServletUtil.getIntParam(request, "academicYearId", 0);
        int academicYearId = endGradesForm.getAcademicYearId();

        String searchValue = navigationSettings.getSearchValue();

        Map<String, Object> findEndGradesMap = new HashMap<>();

        if (!StringUtil.isNullOrEmpty(active, true)) {

            findEndGradesMap.put("active", active);

            model.addAttribute("active", active);
        }

        if (!StringUtil.isNullOrEmpty(endGradeTypeCode, true)) {

            findEndGradesMap.put("endGradeTypeCode", endGradeTypeCode);

            model.addAttribute("endGradeTypeCode", endGradeTypeCode);
        }

        if (academicYearId != 0) {

            findEndGradesMap.put("academicYearId", academicYearId);

            model.addAttribute("academicYearId", academicYearId);
        }
        if (!StringUtil.isNullOrEmpty(searchValue, true))
            findEndGradesMap.put("searchValue", searchValue);

        findEndGradesMap.put("lang", preferredLanguage);

        endGradesForm.setMapEndGrades(endGradeManager.findEndGradesAsMaps(findEndGradesMap));

        model.addAttribute(END_GRADES_FORM, endGradesForm);

        return formView;

    }

    @RequestMapping(method = RequestMethod.GET, params = "task=deleteEndGrade")
    public String deleteEndGrade(@RequestParam("endGradeCode") String endGradeCode, @RequestParam("academicYearId") int academicYearId,
            @RequestParam("typeCode") String endGradeTypeCode, ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        /*
         * perform session-check. If wrong, this throws an Exception towards ErrorController
         */
        securityChecker.checkSessionValid(session);

        EndGradesForm endGradeForm = (EndGradesForm) model.get(END_GRADES_FORM);

        NavigationSettings navigationSettings = endGradeForm.getNavigationSettings();

        endGradeManager.deleteEndGradeSet(endGradeCode, endGradeTypeCode, academicYearId, opusMethods.getWriteWho(request));

        return "redirect:/college/endgrades.view?newForm=true" + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();

    }

}
