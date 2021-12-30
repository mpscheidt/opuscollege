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

package org.uci.opus.scholarship.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.validators.SponsorValidator;
import org.uci.opus.scholarship.web.form.SponsorForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@SessionAttributes({SponsorEditController.SPONSOR_FORM})
public class SponsorEditController {

    public static final String SPONSOR_FORM = "sponsorForm";

    private static Logger log = LoggerFactory.getLogger(SponsorEditController.class);

    private String formView;

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private LookupManagerInterface lookupManager;
     
    public SponsorEditController() {
        super();
		
        this.formView = "scholarship/sponsor/sponsor";
    }
     
    @RequestMapping(value = "/scholarship/sponsor.view", method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws Exception {

        SponsorForm sponsorForm = null;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /*
         * perform session-check. If wrong, this throws an Exception towards
         * ErrorController
         */
        securityChecker.checkSessionValid(session);

        // if adding a new sponsor, destroy any existing one on the session
        opusMethods.removeSessionFormObject(SPONSOR_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "scholarship");

        int sponsorId = ServletRequestUtils.getIntParameter(request, "sponsorId", 0);

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /*
         * SponsorForm - fetch or create the form object and fill it with
         * secondarySchool
         */
        sponsorForm = (SponsorForm) model.get(SPONSOR_FORM);
        if (sponsorForm == null) {
            sponsorForm = new SponsorForm();
            model.put(SPONSOR_FORM, sponsorForm);

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            sponsorForm.setAllAcademicYears(allAcademicYears);

            sponsorForm.setSponsorTypes(lookupManager.findAllRows(preferredLanguage, "sch_sponsortype"));

            Sponsor sponsor;
            if (sponsorId != 0) {
                sponsor = scholarshipManager.findSponsor(sponsorId);
            } else {
                sponsor = new Sponsor();
            }
            sponsorForm.setSponsor(sponsor);

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            sponsorForm.setNavigationSettings(navigationSettings);

            // -- sponsorInvoices with oustanding amounts --
/*            Map<String, Object> map = new HashMap<String, Object>();
            map.put("sponsorId", sponsor.getId());
            map.put("onlyOutstanding", "Y");
            List<SponsorInvoice> outstandingSponsorInvoices = scholarshipManager.findSponsorInvoices(map);
            sponsorForm.setOutstandingSponsorInvoices(outstandingSponsorInvoices);*/
        }

        return formView;
    }

    @Transactional
    @RequestMapping(value = "/scholarship/sponsor.view", method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(SPONSOR_FORM) SponsorForm sponsorForm, BindingResult result, SessionStatus status, HttpServletRequest request) {

        NavigationSettings navigationSettings = sponsorForm.getNavigationSettings();

        Sponsor sponsor = sponsorForm.getSponsor();

        result.pushNestedPath("sponsor");
        new SponsorValidator(scholarshipManager).validate(sponsor, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        } else {
            if (sponsor.getId() == 0) {
                scholarshipManager.addSponsor(sponsor, request);
            } else {
                scholarshipManager.updateSponsor(sponsor, request);
            }

            status.setComplete();
        }

        return "redirect:/scholarship/sponsors.view?newForm=true&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

}
