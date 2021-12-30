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
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.scholarship.domain.Scholarship;
import org.uci.opus.scholarship.domain.Sponsor;
import org.uci.opus.scholarship.domain.SponsorInvoice;
import org.uci.opus.scholarship.domain.SponsorPayment;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.web.form.SponsorInvoicesForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@SessionAttributes({SponsorInvoicesController.FORM_NAME})
@RequestMapping(value="/scholarship/sponsorinvoices.view")
@PreAuthorize("hasAnyRole('READ_SPONSORINVOICES','DELETE_SPONSORINVOICES')")
public class SponsorInvoicesController {

    public static final String FORM_NAME = "sponsorInvoicesForm";
    private final String formView = "scholarship/sponsorInvoice/sponsorInvoices";

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private ReportController reportController;
    @Autowired private ScholarshipManagerInterface scholarshipManager;
    @Autowired private SecurityChecker securityChecker;    

    @RequestMapping(method=RequestMethod.GET)
    @PreAuthorize("hasRole('READ_SPONSORINVOICES')")
    public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        /* set menu to students */
        session.setAttribute("menuChoice", "scholarship");

        SponsorInvoicesForm sponsorInvoicesForm;
        NavigationSettings navigationSettings = null;

//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        sponsorInvoicesForm = (SponsorInvoicesForm) model.get(FORM_NAME);
        if (sponsorInvoicesForm == null) {
            sponsorInvoicesForm = new SponsorInvoicesForm();
            model.addAttribute(FORM_NAME, sponsorInvoicesForm);
            sponsorInvoicesForm.setAcademicYearId(opusMethods.getAcademicYearId(request));

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            sponsorInvoicesForm.setAllAcademicYears(allAcademicYears);
            sponsorInvoicesForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

            navigationSettings = new NavigationSettings();
            sponsorInvoicesForm.setNavigationSettings(navigationSettings);
            opusMethods.fillNavigationSettings(request, navigationSettings, "/scolarship/sponsors.view");
        }

        loadFiltersAndList(sponsorInvoicesForm);

        return formView;
    }

    private void loadFiltersAndList(SponsorInvoicesForm sponsorInvoicesForm) {

        // -- FILTERS --
        List<Sponsor> allSponsors = null;
        int academicYearId = sponsorInvoicesForm.getAcademicYearId();
        if (academicYearId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("academicYearId", academicYearId);
            allSponsors = scholarshipManager.findSponsors(map);
        }
        sponsorInvoicesForm.setAllSponsors(allSponsors);

        List<Scholarship> allScholarships = null;
        int sponsorId = sponsorInvoicesForm.getSponsorId();
        if (sponsorId != 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("sponsorId", sponsorId);
            allScholarships = scholarshipManager.findScholarships(map);
        }
        sponsorInvoicesForm.setAllScholarships(allScholarships);

        int scholarshipId = sponsorInvoicesForm.getScholarshipId();

        // -- LIST --

        // TODO searchvalue
//        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("academicYearId", academicYearId);
        map.put("sponsorId", sponsorId);
        map.put("scholarshipId", scholarshipId);
        map.put("cleared", sponsorInvoicesForm.getCleared());
//        if (!StringUtil.isNullOrEmpty(searchValue, true)) {
//            map.put("searchValue", searchValue);
//        }
        List<SponsorInvoice> allSponsorInvoices = scholarshipManager.findSponsorInvoices(map);
        sponsorInvoicesForm.setAllSponsorInvoices(allSponsorInvoices);
    }

    @RequestMapping(method = RequestMethod.POST, params="academicYearIdChanged=true")
    public String academicYearIdChanged(@ModelAttribute(FORM_NAME) SponsorInvoicesForm sponsorInvoicesForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        // remember academicYearId on session
        opusMethods.setAcademicYearOnSession(request, sponsorInvoicesForm.getAcademicYearId());

        // reset dependent values
        sponsorInvoicesForm.setSponsorId(0);
        sponsorInvoicesForm.setScholarshipId(0);
        loadFiltersAndList(sponsorInvoicesForm);
        return formView;
    }
    
    @RequestMapping(method = RequestMethod.POST, params="sponsorIdChanged=true")
    public String sponsorIdChanged(@ModelAttribute(FORM_NAME) SponsorInvoicesForm sponsorInvoicesForm, BindingResult result, SessionStatus status, HttpServletRequest request) {
        sponsorInvoicesForm.setScholarshipId(0);
        loadFiltersAndList(sponsorInvoicesForm);
        return formView;
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute(FORM_NAME) SponsorInvoicesForm sponsorInvoicesForm, BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        NavigationSettings navigationSettings = sponsorInvoicesForm.getNavigationSettings();

//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        loadFiltersAndList(sponsorInvoicesForm);

        return "redirect:/scholarship/sponsorinvoices.view?currentPageNumber="
                + navigationSettings.getCurrentPageNumber();
    }

    @PreAuthorize("hasRole('DELETE_SPONSORINVOICES')")
    @RequestMapping(method = RequestMethod.GET, params = "delete=true")
    public String deleteSponsor(@RequestParam("sponsorInvoiceId") int sponsorInvoiceId, ModelMap model,
            @ModelAttribute(FORM_NAME) SponsorInvoicesForm sponsorInvoicesForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // check for sponsor payments
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("sponsorInvoiceId", sponsorInvoiceId);
        List<SponsorPayment> sponsorPayments = scholarshipManager.findSponsorPayments(map);
        if (sponsorPayments != null && sponsorPayments.size() != 0) {
            result.reject("jsp.error.sponsorinvoice.delete", new Object[] {sponsorPayments.size()}, null);
        }
        
        if (result.hasErrors()) {
            return formView;
        }

        scholarshipManager.deleteSponsorInvoice(sponsorInvoiceId, opusMethods.getWriteWho(request));

        return "redirect:/scholarship/sponsorinvoices.view?newForm=true";
    }

    @PreAuthorize("hasRole('PRINT_SPONSORINVOICES')")
    @RequestMapping(method = RequestMethod.GET, params = "printSponsorInvoice=true")
    public ModelAndView printSponsorInvoice(@RequestParam("where.sch_sponsorInvoice.id") int sponsorInvoiceId, ModelMap model,
            @ModelAttribute(FORM_NAME) SponsorInvoicesForm sponsorInvoicesForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        ModelAndView mav = reportController.createReport(request);
        
        // increase nrOfTimesPrinted property
        scholarshipManager.increaseSponsorInvoiceNrOfTimesPrinted(sponsorInvoiceId, request);

        return mav;
    }


}
