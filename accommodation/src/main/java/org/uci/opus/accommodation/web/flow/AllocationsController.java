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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.AllocationsForm;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;


@Controller
@RequestMapping("/accommodation/allocations.view")
@SessionAttributes({"allocationsForm"})
@PreAuthorize("hasAnyRole('CREATE_ACCOMMODATION_DATA','READ_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA','DELETE_ACCOMMODATION_DATA','ALLOCATE_ROOM')")
public class AllocationsController {
	
    private String formView;
    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    
    private static Logger log = LoggerFactory.getLogger(AllocationsController.class);

    public AllocationsController() {
		super();
		this.formView = "accommodation/students/allocations";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
    	    	
    	AllocationsForm allocationsForm = new AllocationsForm();
    	
		HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        session.setAttribute("menuChoice", "accommodation");

        opusMethods.removeSessionFormObject("allocationsForm", session, model, opusMethods.isNewForm(request));
        
        allocationsForm.setUseHostelBlocks(useHostelBlocks());
        
        loadData(model, allocationsForm,  request, response);

        return formView;
	
	}
	
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("allocationsForm") AllocationsForm allocationsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request, HttpServletResponse response, ModelMap model) {

        loadData(model, allocationsForm,  request, response);
        
		return formView;
    }    
    
    private void loadData(ModelMap model, AllocationsForm allocationsForm,
    					  HttpServletRequest request, HttpServletResponse response){

		StudentFilterBuilder studentFilterBuilder = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
		studentFilterBuilder.setSubjectBlockMapper(subjectBlockMapper);
		
		List<AcademicYear> academicYears = academicYearManager.findAllAcademicYears();
		
		Map<String, Object> params = new HashMap<>();

    	String genderCode = ServletUtil.getParamSetAttrAsString(request, "genderCode", "0");
    	String progressStatusCode = ServletUtil.getParamSetAttrAsString(request, "progressStatusCode", "0");
    	String studyPlanStatusCode = ServletUtil.getParamSetAttrAsString(request, "studyPlanStatusCode", "0");
    	String searchValue = ServletUtil.getParamSetAttrAsString(request, "searchValue", "").trim();

    	int hostelId = ServletUtil.getIntParam(request, "hostelId", 0);
    	int blockId = ServletUtil.getIntParam(request, "blockId", 0);
    	int roomId = ServletUtil.getIntParam(request, "roomId", 0);
    	
    	studentFilterBuilder.initChosenValues(true);      // this remembers all filter selections in the session
        studentFilterBuilder.doLookups();
        studentFilterBuilder.loadStudies(params);        
        studentFilterBuilder.loadStudyGradeTypes(params, true);
        studentFilterBuilder.loadSubjectBlocks(params);
        studentFilterBuilder.loadInstitutionBranchOrgUnit();
        
    	if(studentFilterBuilder.getInstitutionId() != 0) params.put("institutionId",studentFilterBuilder.getInstitutionId());
    	if(studentFilterBuilder.getOrganizationalUnitId() != 0) params.put("organizationalUnitId",studentFilterBuilder.getOrganizationalUnitId());
    	if(studentFilterBuilder.getBranchId() != 0) params.put("branchId",studentFilterBuilder.getBranchId());
    	if(studentFilterBuilder.getPrimaryStudyId() != 0) params.put("studyId",studentFilterBuilder.getPrimaryStudyId());
    	if(studentFilterBuilder.getStudyGradeTypeId() != 0) params.put("studyGradeTypeId", studentFilterBuilder.getStudyGradeTypeId());
    	if(studentFilterBuilder.getAcademicYearId() != 0) params.put("academicYearId",studentFilterBuilder.getAcademicYearId());
    	if((studentFilterBuilder.getCardinalTimeUnitNumber() != null) && (studentFilterBuilder.getCardinalTimeUnitNumber() != 0)) 
    		params.put("cardinalTimeUnitNumber", studentFilterBuilder.getCardinalTimeUnitNumber());

        if (!"0".equals(genderCode)) params.put("genderCode", genderCode);
        if (!"0".equals(progressStatusCode)) params.put("progressStatusCode", progressStatusCode);
        if (!"0".equals(studyPlanStatusCode)) params.put("studyPlanStatusCode", studyPlanStatusCode);
        
        if(!StringUtil.isNullOrEmpty(searchValue, true))
        	params.put("searchValue", searchValue);

        if(hostelId != 0)  params.put("hostelId", hostelId);
        if(allocationsForm.getUseHostelBlocks() && (blockId != 0)) params.put("blockId", blockId);
        if(roomId != 0) params.put("roomId", roomId);
        
        
        allocationsForm.setAllocations(accommodationManager.findApplicantsByParams(params));
        
        allocationsForm.setHostels(hostelManager.findHostelsByParams(params));
        
        if(allocationsForm.getUseHostelBlocks() && (hostelId != 0))
        	allocationsForm.setBlocks(hostelManager.findBlocksByParams(params));
        else
        	allocationsForm.setBlocks(null);
        
        if(hostelId != 0)
        	allocationsForm.setRooms(hostelManager.findRoomsByParams(params));
        else
        	allocationsForm.setRooms(null);

		Map<Integer, String> mapAcademicYear = new HashMap<Integer, String>();

    	for(AcademicYear academicYear : academicYears) 
    		mapAcademicYear.put(academicYear.getId(), academicYear.getDescription());
    	
    	model.addAttribute("hostelId", hostelId);
    	model.addAttribute("blockId", blockId);
    	model.addAttribute("roomId", roomId);    	
		model.addAttribute("mapAcademicYear", mapAcademicYear);    	
		model.addAttribute("allAcademicYears", academicYears);
		model.addAttribute("allocationsForm", allocationsForm);
    	
    }    
    
    private boolean useHostelBlocks(){
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
       	if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
       		return true;
       	}
       	return false;
    }
}