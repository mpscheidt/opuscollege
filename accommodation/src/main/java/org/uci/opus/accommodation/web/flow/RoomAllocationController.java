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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.validator.RoomAllocationValidator;
import org.uci.opus.accommodation.web.form.RoomAllocationForm;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@RequestMapping("/accommodation/roomallocation.view")
@SessionAttributes({ "roomAllocationForm" })
@PreAuthorize("hasAnyRole('CREATE_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA')")
public class RoomAllocationController {

	private final String formView;
	
	@Autowired private OpusMethods opusMethods;
	@Autowired private SecurityChecker securityChecker;
	
	@Autowired private AppConfigManagerInterface appConfigManager;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private AccommodationManagerInterface accommodationManager;
	@Autowired private HostelManagerInterface hostelManager;
	@Autowired private StaffMemberManagerInterface staffMemberManager;
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private LookupCacher lookupCacher;
	@Autowired private RoomAllocationValidator roomAllocationValidator;

    private static Logger log = LoggerFactory.getLogger(RoomAllocationController.class);

	public RoomAllocationController() {
		super();
		this.formView = "accommodation/students/roomallocation";
	}

	@InitBinder
	public void initBinder(WebDataBinder binder) {
		DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		df.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
	}

	@RequestMapping(method = RequestMethod.GET)
	public String setUpForm(ModelMap model, HttpServletRequest request, @RequestParam("studentAccommodationId") int studentAccommodationId) {

		HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("roomAllocationForm", session, model, opusMethods.isNewForm(request));

        RoomAllocationForm roomAllocationForm;
        StudentAccommodation studentAccommodation;
    
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* set menu to accommodation */
        session.setAttribute("menuChoice", "accommodation");

        /* RoomAllocationForm - fetch or create the form object and initialize it */
        roomAllocationForm = (RoomAllocationForm) model.get("roomAllocationForm");
        if (roomAllocationForm == null) {
            roomAllocationForm = new RoomAllocationForm();
            model.addAttribute("roomAllocationForm", roomAllocationForm);
            
            roomAllocationForm.setUseHostelBlocks(useHostelBlocks());

            //there must always be a student accommodation , this is why it is not checked if studentAccommodationId = 0
            studentAccommodation = accommodationManager.findStudentAccommodation(studentAccommodationId);
            roomAllocationForm.setStudentAccommodation(studentAccommodation);

            List<AcademicYear> allAcademicYears = academicYearManager.findAcademicYears(new HashMap());
            roomAllocationForm.setAcademicYears(allAcademicYears);
            roomAllocationForm.setHostels(hostelManager.findAllHostels());
            
            // load studyplanCTUs
            List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits =
                    studentManager.findStudyPlanCardinalTimeUnitsForStudent(studentAccommodation.getStudent().getStudentId());
            roomAllocationForm.setStudyPlanCardinalTimeUnits(studyPlanCardinalTimeUnits);
            
            List<Integer> studyGradeTypeIds = DomainUtil.getIntProperties(studyPlanCardinalTimeUnits, "studyGradeTypeId");
            List<StudyGradeType> studyGradeTypes = studyManager.findStudyGradeTypes(studyGradeTypeIds, preferredLanguage);
            roomAllocationForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(studyGradeTypes));
            
            roomAllocationForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
            
            List<Lookup> allStudyIntensities = lookupCacher.getAllStudyIntensities(preferredLanguage);
            roomAllocationForm.setCodeToStudyIntensityMap(new CodeToLookupMap(allStudyIntensities));
            
            List<Lookup8> allCardinalTimeUnits = lookupCacher.getAllCardinalTimeUnits(preferredLanguage);
            roomAllocationForm.setCodeToCardinalTimeUnitMap(new CodeToLookupMap(allCardinalTimeUnits));
            
        } else {
            studentAccommodation = roomAllocationForm.getStudentAccommodation();
        }

        
        int hostelId = (studentAccommodation.getRoom() != null) ? studentAccommodation.getRoom().getHostel().getId() : 0;
        int blockId = 0;
        
        if((studentAccommodation.getRoom() != null) && (studentAccommodation.getRoom().getBlock() != null) 
                && studentAccommodation.getRoom().getBlock().getId() != null)
        	blockId = studentAccommodation.getRoom().getBlock().getId();
        	
       	if(roomAllocationForm.getUseHostelBlocks() && (hostelId != 0))
       		roomAllocationForm.setBlocks(findBlocks(hostelId));
       	
       	if(hostelId != 0)
       		roomAllocationForm.setRooms(findAvailableRooms(hostelId, blockId));
       	
		return formView;
	}

	@RequestMapping(method=RequestMethod.POST, params="task=submitFormObject")
	public String processSubmit(
			@ModelAttribute("roomAllocationForm") RoomAllocationForm roomAllocationForm,
			BindingResult result, SessionStatus status,
			HttpServletRequest request, ModelMap model) {

        StudentAccommodation studentAccommodation = roomAllocationForm.getStudentAccommodation();
        
        // -- validate

        result.pushNestedPath("studentAccommodation");
        roomAllocationValidator.validate(studentAccommodation, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }
        
        // -- write to db

        accommodationManager.updateStudentAccommodation(studentAccommodation, request);
        return "redirect:allocations.view?newForm=true";
	}

	/**
	 * Invoked when object is not being committed (to database) but when one dropdown changes and must update related dropdowns or values 
	 * @param roomAllocationForm
	 * @param result
	 * @param status
	 * @param request
	 * @param model
	 * @return
	 */
    @RequestMapping(method=RequestMethod.POST, params="task=updateFormObject")
    public String updateForm(
    		@ModelAttribute("roomAllocationForm") RoomAllocationForm roomAllocationForm,
            BindingResult result, SessionStatus status, HttpServletRequest request, ModelMap model) {

    	StudentAccommodation studentAccommodation = roomAllocationForm.getStudentAccommodation();
    	
        int hostelId = (studentAccommodation.getRoom() != null) ? studentAccommodation.getRoom().getHostel().getId() : 0;
        int blockId = 0;
        
        if((studentAccommodation.getRoom() != null) && (studentAccommodation.getRoom().getBlock() != null))
        	blockId = studentAccommodation.getRoom().getBlock().getId();
       	
        if(useHostelBlocks())
        	roomAllocationForm.setBlocks(findBlocks(hostelId));
        
       	roomAllocationForm.setRooms(findAvailableRooms(hostelId, blockId));

        model.addAttribute("roomAllocationForm", roomAllocationForm);
        
        return formView;

    }
    
    @RequestMapping(method = RequestMethod.GET, params="task=deallocate")
	public String deallocate(ModelMap model, HttpServletRequest request
			, @RequestParam("studentAccommodationId") int studentAccommodationId) {

		HttpSession session = request.getSession(false);
		
		securityChecker.checkSessionValid(session);
		
		StudentAccommodation studentAccommodation = accommodationManager
					.findStudentAccommodation(studentAccommodationId);

		accommodationManager.deallocate(studentAccommodation, request);
    	
		return "redirect:allocations.view?task=overview";
    }
    
	private boolean useHostelBlocks() {
		AppConfigAttribute config = appConfigManager
				.findAppConfigAttribute("USE_HOSTELBLOCKS");
		if (config != null
				&& config.getAppConfigAttributeName()
						.equals("USE_HOSTELBLOCKS")
				&& config.getAppConfigAttributeValue().equals("Y")) {
			return true;
		}
		return false;
	}

	private List<HostelBlock> findBlocks(int hostelId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("hostelId", hostelId);
		return hostelManager.findBlocksByParams(params);
	}

	private List<Room> findAvailableRooms(int hostelId, int blockId) {
		Map<String, Object> params = new HashMap<String, Object>();
		if (hostelId != 0)
			params.put("hostelId", hostelId);
		if (blockId != 0)
			params.put("blockId", blockId);
		return hostelManager.findAvailableRoomsByParams(params);
	}

}