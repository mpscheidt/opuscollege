package org.uci.opus.college.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.ui.ModelMap;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.OverviewForm;

public abstract class OverviewController<T, F extends OverviewForm<T>> extends FormController<T, F> {

    public OverviewController(String formName, String menuChoice) {
        super(formName, menuChoice);
    }

    @Override
    protected F initSetupForm(ModelMap model, HttpServletRequest request) {

        F form = super.initSetupForm(model, request);

        // load data that is set directly on request, not in form/session
        // this data needs to be reloaded for every request, even if form wasn't (re)created
        loadEverythingThatCouldChange(request, form);

        return form;
    }

    @Override
    protected void initForm(F form, HttpServletRequest request) {

        // all overview controllers have navigation settings
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));
    }
    
    @Override
    protected void updateForm(F form, HttpServletRequest request) {

        opusMethods.fillNavigationSettings(request, form.getNavigationSettings());
    }

    protected void loadEverythingThatCouldChange(HttpServletRequest request, F form) {
//        HttpSession session = request.getSession(false);

//        int organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
//        int branchId = ((Integer) session.getAttribute("branchId"));
//        int institutionId = ((Integer) session.getAttribute("institutionId"));
//        Organization organization = opusMethods.fillOrganization(session, request, new Organization(), organizationalUnitId, branchId, institutionId);
//        form.setOrganization(organization);

        /* retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS
         * 
         * the institutionTypeCode is used for studies, and therefore subjects,
         * Studies are only registered for universities; if in
         * the future this should change, it will be easier to alter the code
         */
//        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session,
//                request, organization.getInstitutionTypeCode(),
//                organization.getInstitutionId(), organization.getBranchId(), 
//                organization.getOrganizationalUnitId());

//        opusMethods.getInstitutionBranchOrganizationalUnitSelect(form.getOrganization(), request);

        loadDynamicLookupTableData(request, form);
        loadFilterContents(request, form);
        loadOverviewList(request, form);
    }

    /**
     * load lookup table data that is not contained in the form object. Mostly for older views that should be refactored to contain all lookup data in the form object.
     */
    protected void loadDynamicLookupTableData(HttpServletRequest request, F form) {
    }

    protected abstract void loadFilterContents(HttpServletRequest request, F form);
    
    protected abstract void loadOverviewList(HttpServletRequest request, F form);

    protected void processSubmitGeneric(F form, HttpServletRequest request) {
        rememberFilterSelectionsInSession(form, request);
        loadEverythingThatCouldChange(request, form);
    }

    /**
     * Remember filter selections (e.g. institutionId) in user session
     */
    protected void rememberFilterSelectionsInSession(F form, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        Organization organization = form.getOrganization();

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId",organization.getOrganizationalUnitId());
        session.setAttribute("branchId",organization.getBranchId());
        session.setAttribute("institutionId",organization.getInstitutionId());
    }

}
