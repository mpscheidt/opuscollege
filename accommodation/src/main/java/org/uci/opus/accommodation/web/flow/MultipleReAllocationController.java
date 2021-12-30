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
import java.util.ArrayList;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.service.expoint.AccommodationServiceExtensions;
import org.uci.opus.accommodation.web.form.StudentsForm;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: AccommodationsController.
 *
 */

@Controller
@RequestMapping("/accommodation/multiplereallocation.view")
@SessionAttributes({"accommodationForm"})
public class MultipleReAllocationController {
	
    private String formView;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private AccommodationServiceExtensions accommodationServiceExtensions;
    @Autowired private OpusMethods opusMethods;
    
    private List<Hostel> hostels=null;
	private List<HostelBlock> blocks=null;
	private List<Room> rooms=null;
	
    private static Logger log = LoggerFactory.getLogger(MultipleReAllocationController.class);

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public MultipleReAllocationController() {
		super();
		this.formView = "accommodation/students/multiplereallocation";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	    	
    	StudentsForm studentsForm = new StudentsForm();
    	
    	//Organization organization = null;
        //NavigationSettings navigationSettings = null;
		HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        loadData(studentsForm, model, request);
        return formView;
	
	}
	
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("studentsForm") StudentsForm studentsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,ModelMap model) {
    		
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        String studentAccommodationId[]=request.getParameterValues("studentAccommodationId");
    	if(studentAccommodationId!=null){
    		for(int i=0;i<studentAccommodationId.length;i++){
    			StudentAccommodation studentAccommodation=accommodationManager.findStudentAccommodation(Integer.valueOf(studentAccommodationId[i]));
    			AcademicYear academicYear=academicYearManager.findAcademicYear(studentAccommodation.getAcademicYear().getId());
    			if(academicYear!=null){
    				//get next academicYear
    				AcademicYear nextAcademicYear=academicYearManager.findAcademicYear(academicYear.getNextAcademicYearId());
    				//get the loggedOn User
//    				OpusUser opusUser=(OpusUser)request.getSession().getAttribute("opusUser");
    		        OpusUser opusUser = opusMethods.getOpusUser();
    		    	StaffMember staffMember=staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
    		    	
    		    	//check if nextAcademicYear is not null
    		    	//if not, the use it as the academicYear to which the student will be offered accommodation
    		    	//also make sure that the acadmicYear in which the student is offered accommodation, he or she is having a study
    		    	if(nextAcademicYear!=null && nextAcademicYear.getId()!=0 && getCurrentAcademicYearIdForStudent(studentAccommodation.getStudent().getStudentId())==nextAcademicYear.getId()){
    		    		//make sure that the available bespace is more than 0
    		    		//before allocating a student to the room
	    				if(studentAccommodation.getRoom().getAvailableBedSpace()>0){
	    					studentAccommodation.setAcademicYear(nextAcademicYear);
	    					studentAccommodation.setApprovedBy(staffMember);
	   					
	    					Map<String,Object> params=new HashMap<String, Object>();
	    					params.put("studentId", studentAccommodation.getStudent().getStudentId());
	    					params.put("academicYearId", studentAccommodation.getAcademicYear().getId());
	    					params.put("roomId", 0);
	    					params.put("allocated", "N");
	    					//Save accommodation details if only the fees were set as well as 
	    					//accommodation details are not found for the student
	    					if(accommodationServiceExtensions.saveBalance(studentAccommodation, opusMethods.getWriteWho(request))){
	    						studentAccommodation.setApproved("Y");
	    						studentAccommodation.setDateApproved(new Date());
	    						
	    						StudentAccommodation studentAccommodation2=accommodationManager.findStudentAccommodationByParams(params);
	    						if(studentAccommodation2==null){
	    							studentAccommodation.setAllocated("N");
	    							accommodationManager.addStudentAccommodation(studentAccommodation);
	    							studentAccommodation2=accommodationManager.findStudentAccommodationByParams(params);
	    						}
	    						
	    						studentAccommodation.setAllocated("Y");
	    						studentAccommodation.setId(studentAccommodation2.getId());
    							accommodationManager.updateStudentAccommodation(studentAccommodation, request);
        						
	    						hostelManager.reduceAvailableBedSpaceByOne(studentAccommodation.getRoom().getID());
	    					}
	    				}
	    			}
    			}
    		}
    		status.isComplete();
      		return "redirect:multiplereallocation.view?task=overview";
    	}
    	setDefaultData(model, studentsForm,OpusMethods.getPreferredLanguage(request));
    	return formView;
    }
    
    /**
     * 
     * @param model ModelMap for populating the studyGradeType
     * @param studentAccommodation 
     * @return false when accommodation fee is not set for the studytaken by the student
     */
/*    private boolean saveBalance(ModelMap model,StudentAccommodation studentAccommodation){
    
    	StudentBalance studentBalance=new StudentBalance();
		//get the academicYearId to use for determining fees to use
		int academicYearId=getAcademicYearId(studentAccommodation.getStudent().getStudentId());
		//use the studentAccommodation's academicYear to set the balance for a student
		studentBalance.setAcademicYearId(studentAccommodation.getAcademicYear().getId());
		studentBalance.setStudentId(studentAccommodation.getStudent().getStudentId());
		studentBalance.setExemption("N");
		
		Map<String,Object> params=new HashMap<String, Object>();
		params.put("hostelId",studentAccommodation.getRoom().getHostel().getId());
		params.put("academicYearId", academicYearId);
	
		AccommodationFee accommodationFee = accommodationFeeManager.findAccommodationFeeByParams(params);
		if(useHostelBlocks()){
			params.put("blockId",studentAccommodation.getRoom().getBlock().getId());
			AccommodationFee accommodationFee2 = accommodationFeeManager.findAccommodationFeeByParams(params);
			if(accommodationFee2!=null)
				accommodationFee=accommodationFee2;
		}

		params.remove("blockId");
		AccommodationFee accommodationFee2 = accommodationFeeManager.findAccommodationFeeByParams(params);
		if(accommodationFee==null)
			accommodationFee=accommodationFee2;
		
		//Check if fees were set, if not then return false;
		if(accommodationFee!=null){	
			Fee fee=accommodationManager.findFeeByAccommodationFeeId(accommodationFee.getId());
			studentBalance.setFeeId(fee.getId());
			studentBalance.setWriteWho("accommodation");
			studentManager.addStudentBalance(studentBalance);
			return true;
		}else{
			return false;
		}

    }*/
    
    /**
     * Get the academicYearId which would be used to extract accommodation details as well as accommodationFees
     * @param studentId
     * @return
     */
/*    private int getAcademicYearId(int studentId){
    	List<? extends StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(studentId);
		int studyPlanId=studyPlans.get(0).getId();
		List<? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits=studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
    	int studyGradeTypeId=0;
    	
    	//progressStatusCode 26 is for "TPT- To Part-Time" 
		if(studyPlanCardinalTimeUnits.size()>1 && !studyPlanCardinalTimeUnits.get(1).getProgressStatusCode().equals("29")){
			for(int i=1; i<studyPlanCardinalTimeUnits.size();i++){
				if(studyPlanCardinalTimeUnits.get(i).getProgressStatusCode().equals("29")){
					studyGradeTypeId=studyPlanCardinalTimeUnits.get(i-1).getStudyGradeTypeId();
					break;
				}else{
					studyGradeTypeId=studyPlanCardinalTimeUnits.get(i).getStudyGradeTypeId();
				}
			}
		}else{
			studyGradeTypeId=studyPlanCardinalTimeUnits.get(0).getStudyGradeTypeId();
		}
		
		StudyGradeType studyGradeType=studyManager.findStudyGradeType(studyGradeTypeId);
		return studyGradeType.getCurrentAcademicYearId();
    }*/
    
    private void loadData(StudentsForm studentsForm,ModelMap model, HttpServletRequest request){
       	HttpSession session = request.getSession(false);
       	session.setAttribute("menuChoice", "accommodation");
    	setDefaultData(model,studentsForm,OpusMethods.getPreferredLanguage(request));
    }
    
    private void setDefaultData(ModelMap model,StudentsForm studentsForm,String preferredLanguage){
    	List<Institution> institutions= getInstitutions();
    	List<Branch> firstLevelUnits=null;
    	List<OrganizationalUnit> secondLevelUnits=null;
    	List<Study> studies=null;
    	List<StudyGradeType> studyGradeTypes=null;
    	List<AcademicYear> academicYears=academicYearManager.findAllAcademicYears();
    	int maxCardintalTimeUnit=0;
    	Map<String,Object> roomParams=new HashMap<String, Object>();
    	Map<String,Object> blockParams=new HashMap<String, Object>();
    	List<HostelBlock> allBlocks=null;
    	List<Room> allRooms=null;
     
    	if(institutions!=null && institutions.size()>0){
    		
    		//if(studentsForm.getInstitutionId()==0) studentsForm.setInstitutionId(institutions.get(0).getId());
    		firstLevelUnits=getBranches(institutions.get(0).getId());
    		if(studentsForm.getInstitutionId()!=0){
    			studentsForm.setInstitutionId(institutions.get(0).getId());
    			firstLevelUnits=getBranches(studentsForm.getInstitutionId());
	    		if(studentsForm.getFirstLevelUnitId()!=0 && firstLevelUnits!=null && firstLevelUnits.size()>0){
	    			if(studentsForm.getFirstLevelUnitId()==0) studentsForm.setFirstLevelUnitId(firstLevelUnits.get(0).getId());
	    			
	    			secondLevelUnits=getOrganizationalUnits(studentsForm.getFirstLevelUnitId());
	    			if(secondLevelUnits!=null && secondLevelUnits.size()>0){
	    				if(studentsForm.getSecondLevelUnitId()==0 || (studentsForm.getSecondLevelUnitId()!=0 && organizationalUnitManager.findOrganizationalUnit(studentsForm.getSecondLevelUnitId()).getBranchId()!=studentsForm.getFirstLevelUnitId())) studentsForm.setSecondLevelUnitId(secondLevelUnits.get(0).getId());
	    			
	    				studies=getStudies(studentsForm.getSecondLevelUnitId(),preferredLanguage);
	    				if(studies!=null && studies.size()>0){
	    					if(studentsForm.getStudyId()==0 || (studentsForm.getStudyId()!=0 && studyManager.findStudy(studentsForm.getStudyId()).getOrganizationalUnitId()!=studentsForm.getSecondLevelUnitId())) studentsForm.setStudyId(studies.get(0).getId());
	    				
		    				studyGradeTypes=getStudyGradeTypes(studentsForm.getStudyId(),preferredLanguage);
		    				if(studyGradeTypes!=null && studyGradeTypes.size()>0){
		    					
		    					if(studentsForm.getStudyGradeTypeId()==0 || (studentsForm.getStudyGradeTypeId()!=0 && studyManager.findStudyGradeType(studentsForm.getStudyGradeTypeId()).getStudyId()!=studentsForm.getStudyId())) studentsForm.setStudyGradeTypeId(studyGradeTypes.get(0).getId());
		    				
		    					//get maximum CardinalTimeUnit
		    					maxCardintalTimeUnit=studyManager.findStudyGradeType(studentsForm.getStudyGradeTypeId()).getMaxNumberOfCardinalTimeUnits();
		    					    		
		    					if(studentsForm.getCardinalTimeUnitNumber()==0) studentsForm.setCardinalTimeUnitNumber(1);
		    					//get academic Years for the StudyGradeType
		    					//academicYears=getAcademicYears(studentsForm.getStudyGradeTypeId());
		    				}
	    				}
	    			}
	    		}
    		}	
    	}
    	
    	if(studentsForm.getHostelId()!=0 && useHostelBlocks()){
    		blockParams.put("hostelId", studentsForm.getHostelId());
    		allBlocks=hostelManager.findBlocksByParams(blockParams);
    		
    		if(studentsForm.getBlockId()!=0 && studentsForm.getHostelId()==hostelManager.findBlockById(studentsForm.getBlockId()).getHostel().getId()) roomParams.put("blockId", studentsForm.getBlockId());
        		roomParams.put("hostelId", studentsForm.getHostelId());
        		allRooms=hostelManager.findRoomsByParams(roomParams);
        	
    		
    	}else if(studentsForm.getHostelId()!=0 && !useHostelBlocks()){
	    	roomParams.put("hostelId", studentsForm.getHostelId());
	    	allRooms=hostelManager.findRoomsByParams(roomParams);
	    }
    	
    	
    	
    	model.addAttribute("allInstitutions",institutions);
		model.addAttribute("allFirstLevelUnits",firstLevelUnits);
		model.addAttribute("allSecondLevelUnits",secondLevelUnits);
    	model.addAttribute("allStudies",studies);
    	model.addAttribute("allStudyGradeTypes", studyGradeTypes);
		model.addAttribute("maxCardinalTimeUnit",maxCardintalTimeUnit);
		model.addAttribute("allAcademicYears",academicYears);
		
		model.addAttribute("allHostels", hostelManager.findAllHostels());
    	model.addAttribute("allBlocks", allBlocks);
    	model.addAttribute("allRooms", allRooms);
    	model.addAttribute("applicants",getStudentAccommodations(studentsForm));
    	model.addAttribute("studentsForm",studentsForm);
    	model.addAttribute("useHostelBlocks", useHostelBlocks());
    	
    	Map<Integer,String> mapAcademicYear=new HashMap<Integer, String>();
    	for(AcademicYear ay:academicYears) 
    		mapAcademicYear.put(ay.getId(), ay.getDescription());
    	
    	model.addAttribute("mapAcademicYear",mapAcademicYear);
    }
    
    
    private List<StudentAccommodation> getStudentAccommodations(StudentsForm studentsForm){
    	Map<String,Object> params=new HashMap<String, Object>();
    	if(studentsForm!=null){
    		
    		if(studentsForm.getInstitutionId()!=0) params.put("institutionId",studentsForm.getInstitutionId());
    		if(studentsForm.getFirstLevelUnitId()!=0) params.put("branchId",studentsForm.getFirstLevelUnitId());
    		if(studentsForm.getSecondLevelUnitId()!=0) params.put("organizationalUnitId",studentsForm.getSecondLevelUnitId());
    		if(studentsForm.getStudyGradeTypeId()!=0) params.put("studyGradeTypeId", studentsForm.getStudyGradeTypeId());
    		if(studentsForm.getAcademicYearId()!=0) params.put("academicYearId",studentsForm.getAcademicYearId());
    		if(studentsForm.getCardinalTimeUnitNumber()!=0) params.put("cardinalTimeUnitNumber", studentsForm.getCardinalTimeUnitNumber());
    		
    		if(studentsForm.getHostelId()!=0 && useHostelBlocks()){
    			params.put("hostelId", studentsForm.getHostelId());
    			if(studentsForm.getBlockId()!=0 && studentsForm.getHostelId()==hostelManager.findBlockById(studentsForm.getBlockId()).getHostel().getId()) params.put("blockId", studentsForm.getBlockId());
    			if(studentsForm.getRoomId()!=0 && studentsForm.getHostelId()==hostelManager.findRoomById(studentsForm.getRoomId()).getHostel().getId()) params.put("roomId", studentsForm.getRoomId());
    		}else if(!useHostelBlocks()){
    			if(studentsForm.getRoomId()!=0 && studentsForm.getHostelId()==hostelManager.findRoomById(studentsForm.getRoomId()).getHostel().getId()) params.put("roomId", studentsForm.getRoomId());
    		}
    		
    		List<StudentAccommodation> studentAccommodations=accommodationManager.findStudentAccommodationsToReAllocateByParams(params);
    		List<StudentAccommodation> studentAccommodations2=new ArrayList<StudentAccommodation>();
    		
    		//If progressStatus is not equal to 0 then get students who are either on fullTime or partTime
    		if(studentsForm.getProgressStatus()!=null && studentAccommodations!=null && !studentsForm.getProgressStatus().equals("0")){
	    		for(StudentAccommodation studentAccommodation:studentAccommodations){
	    			//Get students who are either on Full Time or Part Time
	    			if((studentsForm.getProgressStatus().equals("PT") && isStudentOnPartTime(studentAccommodation.getStudent().getStudentId())) || studentsForm.getProgressStatus().equals("FT")){
	    				studentAccommodations2.add(studentAccommodation);
	    			}
	    			studentAccommodations=studentAccommodations2;
	    		}
    		}
    		
    		return studentAccommodations;
    	}
    	
    	return null;
    }
    
    /**
     * Get the academicYearId which would be used to extract accommodation details as well as accommodationFees
     * @param studentId
     * @return
     */
    private boolean isStudentOnPartTime(int studentId){
    	List<? extends StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(studentId);
		int studyPlanId=studyPlans.get(0).getId();
		List<? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits=studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
    
    	//progressStatusCode 26 is for "TPT- To Part-Time" 
		if(studyPlanCardinalTimeUnits.size()>1 && !studyPlanCardinalTimeUnits.get(1).getProgressStatusCode().equals("29")){
			return true;
		}else{
			return false;
		}
    }

    private List<Institution> getInstitutions(){
		return institutionManager.findInstitutions(null);
	}
	
	private List<Branch> getBranches(int institutionId){
		Map<String, Object> param=new HashMap<String, Object>();
		param.put("institutionId", institutionId);
		return branchManager.findBranches((Map<String,Object>)param);
	}
	
	private List<OrganizationalUnit> getOrganizationalUnits(int branchId){
		Map<String, Object> param=new HashMap<String, Object>();
		param.put("branchId", branchId);
		param.put("unitLevel", 1);
		return organizationalUnitManager.findOrganizationalUnits(param);
	}
    private List<Study> getStudies(int organizationUnitId,String preferredLanguage){
    	return studyManager.findAllStudiesForOrganizationalUnit(organizationUnitId);
    }
    
    private List<StudyGradeType> getStudyGradeTypes(int studyId,String preferredLanguage){
    	Map<String, Object> param=new HashMap<String, Object>();
    	param.put("preferredLanguage",preferredLanguage);
		param.put("studyId", studyId);
		return studyManager.findStudyGradeTypesByParams(param);
    }
    
    private List<AcademicYear> getAcademicYears(int studyGradeTypeId){
    	Map<String, Object> param=new HashMap<String, Object>();
    	param.put("studyGradeTypeId", studyGradeTypeId);
		return studyManager.findAllAcademicYears(param);
    }
    
    private boolean useHostelBlocks(){
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
       	if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
       		return true;
       	}
       	return false;
    }
    
    private int getCurrentAcademicYearIdForStudent(int studentId){
    	List<? extends StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(studentId);
    	int studyGradeTypeId= studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlans.get(0).getId()).get(0).getStudyGradeTypeId();
    	return studyManager.findStudyGradeType(studyGradeTypeId).getCurrentAcademicYearId();
    }
    
    @InitBinder
    public void initBinder(WebDataBinder binder){
    	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
    }
}