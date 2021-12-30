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
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.validator.RoomValidator;
import org.uci.opus.accommodation.web.form.RoomForm;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

/**
 * Servlet implementation class for Servlet: room edit controller.
 *
 */

@Controller
@RequestMapping("/accommodation/hostels/room.view")
@SessionAttributes({"roomForm"})
public class RoomController {
	
    private final String formView;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private RoomValidator roomValidator;
    
    private static Logger log = LoggerFactory.getLogger(RoomController.class);

	public RoomController() {
		super();
		this.formView = "accommodation/rooms/room";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

	    HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("roomForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");          

//        RoomForm roomForm = (RoomForm) session.getAttribute("roomForm");
        RoomForm roomForm = (RoomForm) model.get("roomForm");
        if (roomForm == null) {
            roomForm = new RoomForm();
            model.addAttribute("roomForm", roomForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            roomForm.setNavigationSettings(navigationSettings);

            // domain object
            int roomId = ServletUtil.getIntParam(request, "roomId", 0);
            Room room;
            if (roomId != 0) {
                room = hostelManager.findRoomById(roomId);
            } else {
                room = new Room();
                room.setHostel(new Hostel());
            }
            roomForm.setRoom(room);

            // lists
            roomForm.setAllHostels(hostelManager.findAllHostels());
            roomForm.setAllHostelBlocks(hostelManager.findBlocksByHostelId(room.getHostel().getId()));
            String lang = OpusMethods.getPreferredLanguage(request);
            roomForm.setAllRoomTypes(accommodationLookupCacher.getAllRoomTypes(lang));

            // other
            roomForm.setUseHostelBlock(useHostelBlocks());
        }

        return formView; 
	
	}
	
	
	// on hostel selection change load list of blocks within selected hostel
    @RequestMapping(method=RequestMethod.POST, params="hostelChanged=true")
    public String hostelChanged(RoomForm roomForm, BindingResult result, SessionStatus status, 
            HttpServletRequest request, ModelMap model) {

        Integer hostelId = roomForm.getRoom().getHostel().getId();
        roomForm.setAllHostelBlocks(hostelManager.findBlocksByHostelId(hostelId));

        return formView;
    }
    

    // submit
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(RoomForm roomForm, BindingResult result, SessionStatus status, 
            HttpServletRequest request, ModelMap model) {

    	Room room = roomForm.getRoom();

    	room.setWriteWho(opusMethods.getWriteWho(request));
    	
        // validate
        result.pushNestedPath("room");
        roomValidator.validate(room, result);
        result.popNestedPath();

        // cancel in case of validation errors
        if (result.hasErrors()) {
            return formView;
        }

        // database operations
        if (room.getID() != null) {
            hostelManager.updateRoom(room);
        } else {
            hostelManager.addRoom(room);
        }
        status.setComplete();

        return "redirect:rooms.view?newForm=true";

        
/*    	if(room.getCode()!=null && !room.getCode().trim().equals("") && room.getHostel().getId()!=0){
    	       	
        	if(task!=null && task.toLowerCase().equals("edit")){
        		Room room2=hostelManager.findRoomById(room.getId());
        		room.setNumberOfBedSpaces(room2.getAvailableBedSpace());
        		hostelManager.updateRoom(room);
        		status.setComplete();
        		submitFormView="redirect:rooms.view?task=overview";
        	}else{
        		params.put("code", room.getCode());
        		if(room.getHostel().getId()!=0) params.put("hostelId", room.getHostel().getId());      		
        		if(useHostelBlocks() && room.getBlock()!=null && room.getBlock().getId()!=0) params.put("blockId", room.getBlock().getId());
        		
        		if(room.getHostel().getId()!=0 && save==null){
        			params.clear();
        			params.put("hostelId", room.getHostel().getId());
        			model.addAttribute("allBlocks",hostelManager.findBlockByParams(params));
        			model.addAttribute("allHostels",hostelManager.findAllHostels());
        			
        		}else if(hostelManager.findRoomByParams(params)==null){
        			
        			hostelManager.addRoom(room);
        			status.setComplete();
        			submitFormView="redirect:rooms.view?task=overview";
        		}else{
        			accommodationForm.setTxtErr("jsp.accommodation.error.roomCodeExist");
            		model.addAttribute("error",accommodationForm.getTxtErr());
            		setDefaultData(model, accommodationForm, request);
           		}
        	}
       }else {
    	   if(room.getCode().trim().equals("")){
    		 	accommodationForm.setTxtErr("jsp.accommodation.error.enterCode");
      		}else if(room.getDescription().trim().equals("")){
	       		accommodationForm.setTxtErr("jsp.accommodation.error.enterDescription");
      		}else if(room.getHostel().getId()==0){
	       		accommodationForm.setTxtErr("jsp.accommodation.error.chooseHostel");
	       	}else if(room.getFloorNumber()==0){
	       		accommodationForm.setTxtErr("jsp.accommodation.error.chooseFloorNumber");
	       	}else if(room.getNumberOfBedSpaces()==0){
	       		accommodationForm.setTxtErr("jsp.accommodation.error.chooseNumberOfBedSpace");
	       	}
    	   
    	   	setDefaultData(model, accommodationForm, request);
  			model.addAttribute("error",accommodationForm.getTxtErr());
       }
       return submitFormView; */
    }
    
    
    private boolean useHostelBlocks(){
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
       	if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
       		return true;
       	}
       	return false;
    }
}