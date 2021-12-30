
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
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.HostelBlocksForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/accommodation/hostelBlocks.view")
@SessionAttributes({"hostelBlocksForm"})
public class HostelBlocksController {
	
    private static Logger log = LoggerFactory.getLogger(HostelBlocksController.class);

    private final String formView;

    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    
    /**
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public HostelBlocksController() {
		super();
		this.formView = "accommodation/hostels/hostelBlocks";
	}

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("hostelBlocksForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");

//        HostelBlocksForm hostelBlocksForm = (HostelBlocksForm) session.getAttribute("hostelBlocksForm");;
        HostelBlocksForm hostelBlocksForm = (HostelBlocksForm) model.get("hostelBlocksForm");;
        if (hostelBlocksForm == null) {
            hostelBlocksForm = new HostelBlocksForm();
            model.addAttribute("hostelBlocksForm", hostelBlocksForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            hostelBlocksForm.setNavigationSettings(navigationSettings);

            // filter values
            String hostelTypeCode=request.getParameter("hostelTypeCode");
            hostelBlocksForm.setHostelTypeCode(hostelTypeCode);

            int hostelId = ServletUtil.getIntParam(request, "hostelId", 0);
            hostelBlocksForm.setHostelId(hostelId);

            // primary list (hostel blocks)
            String preferredLanguage=OpusMethods.getPreferredLanguage(request);
            Map<String,Object> params=new HashMap<String, Object>();
            params.put("lang", preferredLanguage);
            if (hostelTypeCode!=null && !hostelTypeCode.equals("0")) params.put("hostelTypeCode",hostelTypeCode);
            if (hostelId!=0) params.put("hostelId", hostelId);
            hostelBlocksForm.setAllHostelBlocks(hostelManager.findBlocksByParams(params));
    
            // lists
            hostelBlocksForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(preferredLanguage));
            
            params.clear();
            if(hostelTypeCode!=null && !hostelTypeCode.equals("0")) params.put("hostelTypeCode",hostelTypeCode);
            hostelBlocksForm.setAllHostels(hostelManager.findHostelsByParams(params));
        }

        return formView;
    }

    // delete=true request parameter triggers this method
    @RequestMapping(method=RequestMethod.GET, params = "delete=true")
    public String delete(@RequestParam("hostelBlockId") int hostelBlockId,
            HostelBlocksForm hostelBlocksForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        // validate
        Map<String,Object> params=new HashMap<String, Object>();
        params.put("blockId", hostelBlockId);
        
        List<Room> rooms = hostelManager.findRoomsByParams(params);
        if (rooms != null && !rooms.isEmpty()) {
            result.reject("jsp.accommodation.error.cannotDeleteBlock");
        }
        
        // database operation
        String view;
        if(result.hasErrors()) { 
            view = formView;
        } else {
            hostelManager.deleteBlock(hostelBlockId, opusMethods.getWriteWho(request));
            view =  "redirect:hostelBlocks.view?newForm=true";
        }
        return view;
    }
    
}