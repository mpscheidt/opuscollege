package org.uci.opus.accommodation.web.flow;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.validator.HostelBlockValidator;
import org.uci.opus.accommodation.web.form.HostelBlockForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/accommodation/hostelBlock.view")
@SessionAttributes({"hostelBlockForm"})
public class HostelBlockEditController {

    private final String formView;

//    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private HostelBlockValidator hostelBlockValidator;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;    

    public HostelBlockEditController() {
        super();
        formView = "accommodation/hostels/hostelBlock";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("hostelBlockForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");          
        
//        HostelBlockForm hostelBlockForm = (HostelBlockForm) session.getAttribute("hostelBlockForm");
        HostelBlockForm hostelBlockForm = (HostelBlockForm) model.get("hostelBlockForm");
        if (hostelBlockForm == null) {
            hostelBlockForm = new HostelBlockForm();
            model.addAttribute("hostelBlockForm", hostelBlockForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            hostelBlockForm.setNavigationSettings(navigationSettings);

            // domain object
            int hostelBlockId = ServletUtil.getIntParam(request, "hostelBlockId", 0);
            
            HostelBlock hostelBlock;
            if(hostelBlockId != 0){
                hostelBlock = hostelManager.findBlockById(hostelBlockId);
            } else {
                hostelBlock = new HostelBlock();
            }
            hostelBlockForm.setHostelBlock(hostelBlock);

            // lists
//            String preferredLanguage=OpusMethods.getPreferredLanguage(request);
//            hostelBlockForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(preferredLanguage));
            hostelBlockForm.setAllHostels(hostelManager.findAllHostels());
        }
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, HostelBlockForm hostelBlockForm,
            BindingResult result, SessionStatus status, ModelMap model) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        HostelBlock hostelBlock = hostelBlockForm.getHostelBlock();
        hostelBlock.setWriteWho(opusMethods.getWriteWho(request));

        // validate
        result.pushNestedPath("hostelBlock");
        hostelBlockValidator.validate(hostelBlock, result);
        result.popNestedPath();
        
        if (hostelBlock.getId() == null) { // new hostel block
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("code", hostelBlock.getCode());
            if(hostelManager.findBlockByParams(params) != null) {
                result.reject("jsp.accommodation.error.blockCodeExist");
            }
        }

        // cancel in case of validation errors
        if (result.hasErrors()) {
            return formView;
        }

        // database operations
        if (hostelBlock.getId() != null) {
            hostelManager.updateBlock(hostelBlock);
        } else {
            hostelManager.addBlock(hostelBlock);
        }
        status.setComplete();

        return "redirect:hostelBlocks.view?newForm=true";
    }

}
