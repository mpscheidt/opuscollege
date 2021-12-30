/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
 ******************************************************************************/
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
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.RoomsForm;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * Servlet implementation class for Servlet: rooms overview controller.
 *
 */

@Controller
@RequestMapping("/accommodation/hostels/rooms.view")
@SessionAttributes({"roomsForm"})
public class RoomsController {
	
    private final String formView;
    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;

    private static Logger log = LoggerFactory.getLogger(RoomsController.class);

	public RoomsController() {
		super();
		this.formView = "accommodation/rooms/rooms";
	}

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("roomsForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");

//        RoomsForm roomsForm = (RoomsForm) session.getAttribute("roomsForm");;
        RoomsForm roomsForm = (RoomsForm) model.get("roomsForm");;
        if (roomsForm == null) {
            roomsForm = new RoomsForm();
            model.addAttribute("roomsForm", roomsForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            roomsForm.setNavigationSettings(navigationSettings);

            // filter values
            String hostelTypeCode=request.getParameter("hostelTypeCode");
            roomsForm.setHostelTypeCode(hostelTypeCode);

            int hostelId = ServletUtil.getIntParam(request, "hostelId", 0);
            roomsForm.setHostelId(hostelId);

            int hostelBlockId = ServletUtil.getIntParam(request, "hostelBlockId", 0);
            roomsForm.setHostelBlockId(hostelBlockId);
            
            String roomTypeCode=request.getParameter("roomTypeCode");
            roomsForm.setRoomTypeCode(roomTypeCode);

            // filter lists
            String preferredLanguage=OpusMethods.getPreferredLanguage(request);
            roomsForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(preferredLanguage));
            
            Map<String,Object> params = new HashMap<String, Object>();
            if(hostelTypeCode!=null && !hostelTypeCode.equals("0")) params.put("hostelTypeCode",hostelTypeCode);
            roomsForm.setAllHostels(hostelManager.findHostelsByParams(params));

            if (hostelId != 0) params.put("hostelId", hostelId);
            roomsForm.setAllHostelBlocks(hostelManager.findBlocksByParams(params));

            roomsForm.setAllRoomTypes(accommodationLookupCacher.getAllRoomTypes(preferredLanguage));
            roomsForm.setCodeToRoomTypeMap(new CodeToLookupMap(roomsForm.getAllRoomTypes()));

            // primary list (rooms)
            if (hostelBlockId != 0) params.put("blockId", hostelBlockId);
            if (roomTypeCode!=null && !"0".equals(roomTypeCode)) params.put("roomTypeCode",roomTypeCode);
            roomsForm.setAllRooms(hostelManager.findRoomsByParams(params));

            // other
            AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
            if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
                roomsForm.setUseHostelBlock(true);
            }
            

        }
        
//        RoomsForm roomsForm = new RoomsForm();
//        return loadData(roomsForm,model,request);
        return formView;
    }

    // delete=true request parameter triggers this method
    @RequestMapping(method=RequestMethod.GET, params = "delete=true")
    public String delete(@RequestParam("roomId") int roomId,
            RoomsForm roomsForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // validate
        Map<String,Object> params=new HashMap<String, Object>();
        params.put("roomId", roomId);
        
        List<StudentAccommodation> accommodations = accommodationManager.findStudentAccommodationsByParams(params);
        if (accommodations != null && !accommodations.isEmpty()) {
            result.reject("jsp.accommodation.error.cannotDeleteRoom");
        }
        
        // database operation
        String view;
        if(result.hasErrors()) { 
            view = formView;
        } else {
            hostelManager.deleteRoom(roomId, opusMethods.getWriteWho(request));
            view =  "redirect:rooms.view?newForm=true";
        }
        return view;
    }

}
