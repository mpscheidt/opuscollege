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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.service.extpoint.ScholarshipServiceExtensions;
import org.uci.opus.scholarship.validators.SponsorPaymentValidator;
import org.uci.opus.scholarship.web.form.SponsorPaymentForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * 
 * @author stelio
 * @author markus
 *
 */
@Controller
@SessionAttributes({SponsorPaymentEditController.SPONSORPAYMENT_FORM})
@PreAuthorize("hasAnyRole('CREATE_SPONSORPAYMENTS','UPDATE_SPONSORPAYMENTS')")
@RequestMapping(value = "/scholarship/sponsorpayment.view")
public class SponsorPaymentEditController {

    public static final String SPONSORPAYMENT_FORM = "sponsorPaymentForm";

    private static Logger log = LoggerFactory.getLogger(SponsorPaymentEditController.class);
     
    private String formView;
     
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private ScholarshipServiceExtensions scholarshipServiceExtensions;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private SponsorPaymentValidator sponsorPaymentValidator;
     
    public SponsorPaymentEditController() {
        super();
		
        this.formView = "scholarship/sponsorPayment/sponsorPayment";
    }
     
    /**
     * Adds a property editor for dates to the binder.
     * @throws Exception exception
     */
    @InitBinder
    protected void initBinder(WebDataBinder binder) throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws Exception {

        SponsorPaymentForm sponsorPaymentForm = null;
        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(SPONSORPAYMENT_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "scholarship");

        int sponsorPaymentId = ServletRequestUtils.getIntParameter(request, "sponsorPaymentId", 0);

//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        sponsorPaymentForm = (SponsorPaymentForm) model.get(SPONSORPAYMENT_FORM);
        if (sponsorPaymentForm == null) {
            sponsorPaymentForm = new SponsorPaymentForm();
            model.put(SPONSORPAYMENT_FORM, sponsorPaymentForm);

            SponsorPayment sponsorPayment;
            if (sponsorPaymentId != 0) {
                sponsorPayment = scholarshipManager.findSponsorPaymentById(sponsorPaymentId);
                Scholarship scholarship = sponsorPayment.getSponsorInvoice().getScholarship();
                Sponsor sponsor = scholarship.getSponsor();
                sponsorPaymentForm.setAcademicYearId(sponsor.getAcademicYearId());
                sponsorPaymentForm.setSponsorId(sponsor.getId());
                sponsorPaymentForm.setScholarshipId(scholarship.getId());
            } else {
                sponsorPayment = new SponsorPayment();
                sponsorPaymentForm.setAcademicYearId(opusMethods.getAcademicYearId(request));
                // For new sponsorInvoices the number can be generated
                sponsorPaymentForm.setSponsorReceiptNumberWillBeGenerated(scholarshipServiceExtensions.getSponsorReceiptNumberGenerator() != null);
            }
            sponsorPaymentForm.setSponsorPayment(sponsorPayment);

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            sponsorPaymentForm.setNavigationSettings(navigationSettings);

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            sponsorPaymentForm.setAllAcademicYears(allAcademicYears);

            loadFilters(sponsorPaymentForm);
        }

        return formView;
    }


    private void loadFilters(SponsorPaymentForm sponsorPaymentForm) {

        // -- FILTERS --
        List<Sponsor> allSponsors = null;
        int academicYearId = sponsorPaymentForm.getAcademicYearId();
        if (academicYearId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("academicYearId", academicYearId);
            allSponsors = scholarshipManager.findSponsors(map);
        }
        sponsorPaymentForm.setAllSponsors(allSponsors);

        List<Scholarship> allScholarships = null;
        int sponsorId = sponsorPaymentForm.getSponsorId();
        if (sponsorId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("sponsorId", sponsorId);
            allScholarships = scholarshipManager.findScholarships(map);
        }
        sponsorPaymentForm.setAllScholarships(allScholarships);

        List<SponsorInvoice> allSponsorInvoices = null;
        int scholarshipId = sponsorPaymentForm.getScholarshipId();
        if (scholarshipId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("scholarshipId", scholarshipId);
            // if editing, need to load referenced sponsor invoice, independent of cleared or not 
            if (sponsorPaymentForm.getSponsorPayment().getId() == 0) {
                map.put("cleared", false);
            }
            allSponsorInvoices = scholarshipManager.findSponsorInvoices(map);
        }
        sponsorPaymentForm.setAllSponsorInvoices(allSponsorInvoices);
    }
    
    @RequestMapping(method = RequestMethod.POST, params="academicYearIdChanged=true")
    public String academicYearIdChanged(@ModelAttribute(SPONSORPAYMENT_FORM) SponsorPaymentForm sponsorPaymentForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        // remember academicYearId on session
        opusMethods.setAcademicYearOnSession(request, sponsorPaymentForm.getAcademicYearId());

        // reset dependent values
        sponsorPaymentForm.setSponsorId(0);
        sponsorPaymentForm.setScholarshipId(0);
        sponsorPaymentForm.getSponsorPayment().setSponsorInvoiceId(0);
        loadFilters(sponsorPaymentForm);
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params="sponsorIdChanged=true")
    public String sponsorIdChanged(@ModelAttribute(SPONSORPAYMENT_FORM) SponsorPaymentForm sponsorPaymentForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        sponsorPaymentForm.setScholarshipId(0);
        sponsorPaymentForm.getSponsorPayment().setSponsorInvoiceId(0);
        loadFilters(sponsorPaymentForm);
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params="scholarshipIdChanged=true")
    public String scholarshipIdChanged(@ModelAttribute(SPONSORPAYMENT_FORM) SponsorPaymentForm sponsorPaymentForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        sponsorPaymentForm.getSponsorPayment().setSponsorInvoiceId(0);
        loadFilters(sponsorPaymentForm);
        return formView;
    }

    @Transactional
    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(SPONSORPAYMENT_FORM) SponsorPaymentForm sponsorPaymentForm, BindingResult result, SessionStatus status, HttpServletRequest request) {

        NavigationSettings navigationSettings = sponsorPaymentForm.getNavigationSettings();

        SponsorPayment sponsorPayment = sponsorPaymentForm.getSponsorPayment();

        // for new payments generate receiptNumber (if number generator exists)
        if (sponsorPayment.getId() == 0 && !StringUtils.hasText(sponsorPayment.getReceiptNumber())) {
            scholarshipServiceExtensions.generateSponsorReceiptNumber(sponsorPayment);
        }

        result.pushNestedPath("sponsorPayment");
        sponsorPaymentValidator.validate(sponsorPayment, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }

        if (sponsorPayment.getId() == 0) {
            scholarshipManager.addSponsorPayment(sponsorPayment, request);
        } else {
            scholarshipManager.updateSponsorPayment(sponsorPayment, request);
        }

        status.setComplete();

        return "redirect:/scholarship/sponsorpayments.view?newForm=true&currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

}
