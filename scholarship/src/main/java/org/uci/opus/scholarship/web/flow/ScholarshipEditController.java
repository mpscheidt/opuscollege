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
import java.util.ArrayList;
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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.validators.ScholarshipValidator;
import org.uci.opus.scholarship.web.form.ScholarshipForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@SessionAttributes({ScholarshipEditController.SCHOLARSHIP_FORM})
public class ScholarshipEditController {

    public static final String SCHOLARSHIP_FORM = "scholarshipForm";

    private static final String formView = "scholarship/scholarship/scholarship";
    private static Logger log = LoggerFactory.getLogger(ScholarshipEditController.class);

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;

    private ScholarshipValidator scholarshipValidator = new ScholarshipValidator();

    public ScholarshipEditController() {
        super();
    }


    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) 
    throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }


    @RequestMapping(value = "/scholarship/scholarship.view", method=RequestMethod.GET)
    public String setupForm(ModelMap model, HttpServletRequest request) throws Exception {

        List<Lookup> allScholarshipTypes = null;
        List<Sponsor> allSponsors = null;
        int scholarshipId = 0;
        Scholarship scholarship = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(SCHOLARSHIP_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to subjects */
        session.setAttribute("menuChoice", "scholarship");

        ScholarshipForm scholarshipForm = (ScholarshipForm) model.get(SCHOLARSHIP_FORM);
        if (scholarshipForm == null) {

            String preferredLanguage = OpusMethods.getPreferredLanguage(request);

            scholarshipForm = new ScholarshipForm();
            model.put(SCHOLARSHIP_FORM, scholarshipForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            scholarshipForm.setNavigationSettings(navigationSettings);

            // get the scholarshipId if it exists
            if (!StringUtil.isNullOrEmpty(request.getParameter("scholarshipId"))) {
                scholarshipId = Integer.parseInt(request.getParameter("scholarshipId"));
            }
            
            int academicYearId = 0; // comes from Sponsor

            // EXISTING SCHOLARSHIP
            if (scholarshipId != 0) {

                // get scholarshipType description for header
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("scholarshipId", scholarshipId);
                map.put("preferredLanguage", preferredLanguage);
                scholarship = scholarshipManager.findScholarship(map);
                academicYearId = scholarship.getSponsor() == null ? 0 : scholarship.getSponsor().getAcademicYearId();
                scholarshipForm.setAcademicYearId(academicYearId);
            } else {
                scholarship = new Scholarship();
//                Sponsor sponsor = new Sponsor();
//                scholarship.setSponsor(sponsor);
//                scholarship.setActive("Y");
            }
            scholarshipForm.setScholarship(scholarship);

            /* fill lookup-tables with right values */
//            lookupCacher.getStudentLookups(preferredLanguage, request);

            // ScholarshipTypes
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("preferredLanguage", preferredLanguage);
            allScholarshipTypes = scholarshipManager.findScholarshipTypes(map);
            scholarshipForm.setAllScholarshipTypes(allScholarshipTypes);

            // Sponsors:
            allSponsors = findSponsors(academicYearId);
            scholarshipForm.setAllSponsors(allSponsors);

            // academicyears:
            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            scholarshipForm.setAllAcademicYears(allAcademicYears);

            // -- fee percentages view --
            List<? extends Lookup> allFeeCategories = lookupManager.findAllRows(preferredLanguage, "fee_feecategory");
            scholarshipForm.setCodeToFeeCategoryMap(new CodeToLookupMap(allFeeCategories));

        }

        return formView;
    }


    private List<Sponsor> findSponsors(int academicYearId) {
        List<Sponsor> allSponsors;
        Map<String, Object> map = new HashMap<String, Object>();
        if (academicYearId != 0) {
            map.put("academicYearId", academicYearId);
            allSponsors = scholarshipManager.findSponsors(map);
        } else {
            allSponsors = new ArrayList<Sponsor>(0);
        }
        return allSponsors;
    }


    // on academicYear selection load list of sponsors for the year
    @RequestMapping(value="/scholarship/scholarship.view", method=RequestMethod.POST, params="academicYearIdChanged=true")
    public String hostelChanged(ScholarshipForm scholarshipForm, BindingResult result, SessionStatus status, 
            HttpServletRequest request, ModelMap model) {

        int academicYearId = scholarshipForm.getAcademicYearId();
        List<Sponsor> allSponsors = findSponsors(academicYearId);
        scholarshipForm.setAllSponsors(allSponsors);

        return formView;
    }
    

    @Transactional
    @RequestMapping(value="/scholarship/scholarship.view", method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            @ModelAttribute(SCHOLARSHIP_FORM) ScholarshipForm scholarshipForm,
            BindingResult result, SessionStatus status, ModelMap model)
            throws Exception {

        Scholarship scholarship = (Scholarship) scholarshipForm.getScholarship();

        result.pushNestedPath("scholarship");
        scholarshipValidator.validate(scholarship, result);
        result.popNestedPath();
        if (result.hasErrors()) {
            return formView;
        }
        
        NavigationSettings navigationSettings = scholarshipForm.getNavigationSettings();

        if (scholarship.getId() == 0) {
            scholarshipManager.addScholarship(scholarship);
        } else {
            scholarshipManager.updateScholarship(scholarship);
        }
        status.setComplete();

        return "redirect:/scholarship/scholarship.view?newForm=true&scholarshipId=" + scholarship.getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel();
    }


    @RequestMapping(value = "/scholarship/scholarshipFeePercentage_delete.view", method = RequestMethod.GET)
    public String deleteScholarshipFeePercentage(@RequestParam("feePercentageId") int feePercentageId, @RequestParam("scholarshipId") int scholarshipId, ModelMap model,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        ScholarshipForm scholarshipForm = (ScholarshipForm) model.get(SCHOLARSHIP_FORM);
        NavigationSettings navigationSettings = scholarshipForm.getNavigationSettings();

        scholarshipManager.deleteScholarshipFeePercentage(feePercentageId, opusMethods.getWriteWho(request));

        return "redirect:/scholarship/scholarship.view?newForm=true&scholarshipId=" + scholarshipId
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                + "&tab=" + navigationSettings.getTab()
                + "&panel=" + navigationSettings.getPanel();

    }


}
