package org.uci.opus.scholarship.web.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.web.form.SponsorPaymentsForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@SessionAttributes({SponsorPaymentsController.FORM_NAME})
@RequestMapping(value="/scholarship/sponsorpayments.view")
@PreAuthorize("hasAnyRole('READ_SPONSORPAYMENTS','DELETE_SPONSORPAYMENTS')")
public class SponsorPaymentsController {

    public static final String FORM_NAME = "sponsorPaymentsForm";
    private final String formView = "scholarship/sponsorPayment/sponsorPayments";

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private SecurityChecker securityChecker;    

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "scholarship");

        SponsorPaymentsForm sponsorPaymentsForm = (SponsorPaymentsForm) model.get(FORM_NAME);
        if (sponsorPaymentsForm == null) {
            sponsorPaymentsForm = new SponsorPaymentsForm();
            model.addAttribute(FORM_NAME, sponsorPaymentsForm);

            sponsorPaymentsForm.setAcademicYearId(opusMethods.getAcademicYearId(request));

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            sponsorPaymentsForm.setAllAcademicYears(allAcademicYears);
            sponsorPaymentsForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

            NavigationSettings navigationSettings = new NavigationSettings();
            sponsorPaymentsForm.setNavigationSettings(navigationSettings);
            opusMethods.fillNavigationSettings(request, navigationSettings, "/scolarship/sponsors.view");
        }

        loadFiltersAndList(sponsorPaymentsForm);

        return formView;
    }

    private void loadFiltersAndList(SponsorPaymentsForm sponsorPaymentsForm) {
        
        // -- FILTERS --
        List<Sponsor> allSponsors = null;
        int academicYearId = sponsorPaymentsForm.getAcademicYearId();
        if (academicYearId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("academicYearId", academicYearId);
            allSponsors = scholarshipManager.findSponsors(map);
        }
        sponsorPaymentsForm.setAllSponsors(allSponsors);

        List<Scholarship> allScholarships = null;
        int sponsorId = sponsorPaymentsForm.getSponsorId();
        if (sponsorId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("sponsorId", sponsorId);
            allScholarships = scholarshipManager.findScholarships(map);
        }
        sponsorPaymentsForm.setAllScholarships(allScholarships);

        List<SponsorInvoice> allSponsorInvoices = null;
        int scholarshipId = sponsorPaymentsForm.getScholarshipId();
        if (scholarshipId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("scholarshipId", scholarshipId);
            allSponsorInvoices = scholarshipManager.findSponsorInvoices(map);
        }
        sponsorPaymentsForm.setAllSponsorInvoices(allSponsorInvoices);

        
        // -- LIST --
        
        int sponsorInvoiceId = sponsorPaymentsForm.getSponsorInvoiceId();

        // TODO searchvalue
//        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("academicYearId", academicYearId);
        map.put("sponsorId", sponsorId);
        map.put("scholarshipId", scholarshipId);
        map.put("sponsorInvoiceId", sponsorInvoiceId);
//        if (!StringUtil.isNullOrEmpty(searchValue, true)) {
//            map.put("searchValue", searchValue);
//        }
        List<SponsorPayment> allSponsorPayments = scholarshipManager.findSponsorPayments(map);
        sponsorPaymentsForm.setAllSponsorPayments(allSponsorPayments);
    }

    @RequestMapping(method = RequestMethod.POST, params="academicYearIdChanged=true")
    public String academicYearIdChanged(@ModelAttribute(FORM_NAME) SponsorPaymentsForm sponsorPaymentsForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        // remember academicYearId on session
        opusMethods.setAcademicYearOnSession(request, sponsorPaymentsForm.getAcademicYearId());

        // reset dependent values
        resetSponsorId(sponsorPaymentsForm);
        loadFiltersAndList(sponsorPaymentsForm);
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params="sponsorIdChanged=true")
    public String sponsorIdChanged(@ModelAttribute(FORM_NAME) SponsorPaymentsForm sponsorPaymentsForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        resetScholarshipId(sponsorPaymentsForm);
        loadFiltersAndList(sponsorPaymentsForm);
        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params="scholarshipIdChanged=true")
    public String scholarshipIdChanged(@ModelAttribute(FORM_NAME) SponsorPaymentsForm sponsorPaymentsForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        resetSponsorInvoiceId(sponsorPaymentsForm);
        loadFiltersAndList(sponsorPaymentsForm);
        return formView;
    }

    private void resetSponsorId(SponsorPaymentsForm sponsorPaymentsForm) {
        sponsorPaymentsForm.setSponsorId(0);
        resetScholarshipId(sponsorPaymentsForm);
    }

    private void resetScholarshipId(SponsorPaymentsForm sponsorPaymentsForm) {
        sponsorPaymentsForm.setScholarshipId(0);
        resetSponsorInvoiceId(sponsorPaymentsForm);
    }

    private void resetSponsorInvoiceId(SponsorPaymentsForm sponsorPaymentsForm) {
        sponsorPaymentsForm.setSponsorInvoiceId(0);
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute(FORM_NAME) SponsorPaymentsForm sponsorPaymentsForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = sponsorPaymentsForm.getNavigationSettings();

        return "redirect:/scholarship/sponsorpayments.view?currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

    @PreAuthorize("hasRole('DELETE_SPONSORPAYMENTS')")
    @RequestMapping(method = RequestMethod.GET, params = "delete=true")
    public String deleteSponsor(@RequestParam("sponsorPaymentId") int sponsorPaymentId, ModelMap model,
            @ModelAttribute(FORM_NAME) SponsorPaymentsForm sponsorPaymentsForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

//        if (result.hasErrors()) {
//            return formView;
//        }

        scholarshipManager.deleteSponsorPayment(sponsorPaymentId, request);

        return "redirect:/scholarship/sponsorpayments.view?newForm=true";
    }

}
