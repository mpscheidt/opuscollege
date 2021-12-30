package org.uci.opus.accommodation.web.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.HostelsForm;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@RequestMapping("/accommodation/hostels.view")
@SessionAttributes({"hostelsForm"})
public class HostelsController {

    private static Logger log = LoggerFactory.getLogger(HostelsController.class);

    private final String formView;

    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;    

    public HostelsController() {
        formView = "accommodation/hostels/hostels";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("hostelsForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");

//        HostelsForm hostelsForm = (HostelsForm) session.getAttribute("hostelsForm");;
        HostelsForm hostelsForm = (HostelsForm) model.get("hostelsForm");;
        if (hostelsForm == null) {
            hostelsForm = new HostelsForm();
            model.addAttribute("hostelsForm", hostelsForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            hostelsForm.setNavigationSettings(navigationSettings);

            // filter values
            String hostelTypeCode=request.getParameter("hostelTypeCode");
            hostelsForm.setHostelTypeCode(hostelTypeCode);

            // primary list (hostels)
            Map<String,Object> params = new HashMap<String, Object>();
            if(hostelTypeCode!=null && !hostelTypeCode.equals("0")) params.put("hostelTypeCode",hostelTypeCode);
            hostelsForm.setAllHostels(hostelManager.findHostelsByParams(params));

            // other data
            List<Lookup> allHostelTypes = accommodationLookupCacher.getAllHostelTypes(OpusMethods.getPreferredLanguage(request));
            hostelsForm.setAllHostelTypes(allHostelTypes);
            hostelsForm.setCodeToHostelTypeMap(new CodeToLookupMap(allHostelTypes));
        }
        
        return formView;
    }
    
    // delete=true request parameter triggers this method
    @RequestMapping(method=RequestMethod.GET, params = "delete=true")
    public String delete(@RequestParam("hostelId") int hostelId,
            HostelsForm hostelsForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // validate
        Map<String,Object> params=new HashMap<String, Object>();
        params.put("hostelId", hostelId);
        
        List<Room> rooms = hostelManager.findRoomsByParams(params);
        if (rooms != null && !rooms.isEmpty()) {
            result.reject("jsp.accommodation.error.cannotDeleteHostel");
        }
        
        List<HostelBlock> blocks = hostelManager.findBlocksByParams(params);
        if (blocks != null && !blocks.isEmpty()) {
            result.reject("jsp.accommodation.error.cannotDeleteHostel");
        }

        // database operation
        String view;
        if(result.hasErrors()) { 
            view = formView;
        } else {
            hostelManager.deleteHostel(hostelId, opusMethods.getWriteWho(request));
            view =  "redirect:hostels.view?newForm=true";
        }
        return view;
    }

    
    
}
