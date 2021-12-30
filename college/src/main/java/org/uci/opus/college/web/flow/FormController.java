package org.uci.opus.college.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.AcademicYearIdField;
import org.uci.opus.college.web.form.Form;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

public abstract class FormController<T, F extends Form<T>> {

    @Autowired protected AcademicYearManagerInterface academicYearManager;
    @Autowired protected OpusMethods opusMethods;
    @Autowired protected SecurityChecker securityChecker;

    protected Logger log = LoggerFactory.getLogger(getClass());

    private String formName;
    private String menuChoice;

    public FormController(String formName, String menuChoice) {
        this.formName = formName;
        this.menuChoice = menuChoice;
    }

    @SuppressWarnings("unchecked")
    protected F initSetupForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        /*
         * perform session-check. If wrong, this throws an Exception towards
         * ErrorController
         */
        securityChecker.checkSessionValid(session);

        // when entering a new form, destroy any existing objectForms on the session
        opusMethods.removeSessionFormObject(formName, session, model, opusMethods.isNewForm(request));

        // highlight the selected main menu (e.g. "students" or "studies"
        session.setAttribute("menuChoice", this.menuChoice);

        F form = (F) model.get(formName);
        if (form == null) {
            form = createForm(model, request);
            initForm(form, request);
            model.addAttribute(formName, form);
        } else {
            updateForm(form, request);
        }
        
        return form;
    }

    /**
     * Creation of a new form object.
     */
    protected abstract F createForm(ModelMap model, HttpServletRequest request);

    /**
     * Initialize form in case that no form exists yet on the session.
     */
    protected void initForm(F form, HttpServletRequest request) {
  
        // default: empty implementation
    }
        
    /**
     * Refresh the form in case it already exists, e.g. to set a new page number in overview controllers.
     */
    protected void updateForm(F form, HttpServletRequest request) {

        // default: empty implementation
    }
    
    /**
     * Utility method: Set form's academic year to current year to filter large amounts of items.
     */
    protected void setCurrentAcademicYear(AcademicYearIdField form, List<AcademicYear> allAcademicYears) {
        AcademicYear currentAcademicYear = academicYearManager.getCurrentAcademicYear(allAcademicYears);
        if (currentAcademicYear != null) {
            if (log.isDebugEnabled()) {
                log.debug("Setting filter's academic year to " + currentAcademicYear);
            }
            form.setAcademicYearId(currentAcademicYear.getId());
        }
    }

    /**
     * Calls {@link #setCurrentAcademicYear(AcademicYearIdField, List)} if the academicYearId is currently equal to zero.
     */
    protected void setCurrentAcademicYearIfUnset(AcademicYearIdField form, List<AcademicYear> allAcademicYears) {
        if (form.getAcademicYearId() == 0) {
            setCurrentAcademicYear(form, allAcademicYears);
        }
    }
    
}
