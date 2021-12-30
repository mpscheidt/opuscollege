
package org.uci.opus.accommodation.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.validator.HostelValidator;
import org.uci.opus.accommodation.web.form.HostelForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * Servlet implementation class for Servlet: AccommodationsController.
 *
 */

@Controller
@RequestMapping("/accommodation/hostel.view")
@SessionAttributes({"hostelForm"})
public class HostelEditController {

    private final String formView;
    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;    
    
    private static Logger log = LoggerFactory.getLogger(HostelEditController.class);

	public HostelEditController() {
		super();
		formView = "accommodation/hostels/hostel";
	}

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("hostelForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");          

        HostelForm hostelForm = (HostelForm) model.get("hostelForm");
        if (hostelForm == null) {
            hostelForm = new HostelForm();
            model.addAttribute("hostelForm", hostelForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            hostelForm.setNavigationSettings(navigationSettings);

            // domain object
            int hostelId = ServletUtil.getIntParam(request, "hostelId", 0);
            
            Hostel hostel;
            if(hostelId != 0){
                hostel = hostelManager.findHostelById(hostelId);
            } else {
                hostel = new Hostel();
            }
            hostelForm.setHostel(hostel);

            // lists
            String preferredLanguage=OpusMethods.getPreferredLanguage(request);
            hostelForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(preferredLanguage));
        }
        return formView;
    }


    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, HostelForm hostelForm,
            BindingResult result, SessionStatus status, ModelMap model) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        Hostel hostel = hostelForm.getHostel();

        hostel.setWriteWho(opusMethods.getWriteWho(request));
        
    	// validate
    	result.pushNestedPath("hostel");
        new HostelValidator(hostelManager).validate(hostel, result);
        result.popNestedPath();
        
        if (result.hasErrors()) {
            return formView;
        }

        // database operations
        if (hostel.getId() != null) {
        	hostelManager.updateHostel(hostel);
        	status.setComplete();
        } else {
    		hostelManager.addHostel(hostel);
        	status.setComplete();
       }

       return "redirect:hostels.view?newForm=true";
    }
    
}