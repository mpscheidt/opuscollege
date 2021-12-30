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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.AccommodationStudentsForm;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: AccommodationsController.
 *
 */

@Controller
@RequestMapping("/accommodation/application.view")
@SessionAttributes({"accommodationStudentsForm"})
public class AccommodationApplicationController {
	
    private final String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private OpusMethods opusMethods;
    
    private static Logger log = LoggerFactory.getLogger(AccommodationApplicationController.class);

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public AccommodationApplicationController() {
		super();
		this.formView = "accommodation/students/application";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	
    	// TODO : implement form object for controller / jsp logic (examples in college module)
    	AccommodationStudentsForm accommodationStudentsForm = new AccommodationStudentsForm();
    	//Organization organization = null;
        //NavigationSettings navigationSettings = null;
		HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        session.setAttribute("menuChoice", "accommodation");
        
        return loadData(accommodationStudentsForm, model, request);
 	}
	
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("accommodationStudentsForm") AccommodationStudentsForm accommodationStudentsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,ModelMap model) {
    	
    	String save=request.getParameter("save");
//    	String viewName="accommodation/students/application";
    	String viewName = formView;
    	
    	HttpSession session = request.getSession(false);
    	
    	Map<String,Object> params=new HashMap<String, Object>();
    	params.put("studentId", accommodationStudentsForm.getStudent().getStudentId());
    	params.put("academicYearId", accommodationStudentsForm.getAcademicYear().getId());
    	
    	if(save!=null){
    		if(accommodationStudentsForm.getAcademicYear().getId()!=0){
    			if(accommodationStudentsForm.getReasonForApplyingForAccommodation().trim()!=""){
    				if(accommodationManager.findStudentAccommodationByParams(params)==null){
		    			StudentAccommodation studentAccommodation=new StudentAccommodation();
		    			studentAccommodation.setStudent(accommodationStudentsForm.getStudent());
		    			studentAccommodation.setAcademicYear(accommodationStudentsForm.getAcademicYear());
		    			studentAccommodation.setReasonForApplyingForAccommodation(accommodationStudentsForm.getReasonForApplyingForAccommodation().replace("\r","<br />"));
		    			studentAccommodation.setDateApplied(new Date());
		    			studentAccommodation.setAccepted("N");
		    			studentAccommodation.setAllocated("N");
		    			studentAccommodation.setWriteWho(opusMethods.getWriteWho(request));
		    			
		    			accommodationManager.addStudentAccommodation(studentAccommodation);
		    			
		    			status.setComplete();
		    			viewName="redirect:application.view?task=overview";
		    		}else{
		    			accommodationStudentsForm.setTxtErr("jsp.accommodation.error.alreadyAppliedForAccommodation");
		    			model.addAttribute("error",accommodationStudentsForm.getTxtErr());
		    		}
    			}else{
    				accommodationStudentsForm.setTxtErr("jsp.accommodation.error.enterReason");
	    			model.addAttribute("error",accommodationStudentsForm.getTxtErr());
    			}
    		}else{
    			accommodationStudentsForm.setTxtErr("jsp.accommodation.error.chooseAcademicYear");
    			model.addAttribute("error",accommodationStudentsForm.getTxtErr());
    		}
    	}
    	
    	setDefaultData(model,accommodationStudentsForm);
        return viewName;
    }
    
    private String loadData(AccommodationStudentsForm accommodationStudentsForm,ModelMap model, HttpServletRequest request){
    	    	
    	HttpSession session = request.getSession(false);
//        OpusUser opusUser = (OpusUser) session.getAttribute("opusUser");
        OpusUser opusUser = opusMethods.getOpusUser();
//        String viewName="accommodation/students/application";
        String viewName = formView;
        int cardinalTimeUnit=0;
 
//        Map<String,Object> params=new HashMap<String, Object>();
        Map<String,Object> params2=new HashMap<String, Object>();
//        params.put("personId",opusUser.getPersonId());
//        Student student=studentManager.findStudentByPersonId(opusUser.getPersonId());
        Student student = opusUser.getStudent();
        
        if(student!=null){
        	//Study study=studyManager.findStudy(student.getPrimaryStudyId());
        	params2.put("studentId", student.getStudentId());
        	//get all study plans for a student
        	List<StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(student.getStudentId());
        	
        	if(studyPlans.size()>0){
	        	//get the last most study
	        	StudyPlan studyPlan=studyPlans.get(studyPlans.size()-1);
	        	//get the lastmost cardinalTimeUnit of a student
	        	cardinalTimeUnit=(Integer) studentManager.findMaxCardinalTimeUnitNumberForStudyPlan(studyPlan.getId());
	        	
	        	Study study=studyManager.findStudy(studyPlan.getStudyId());
	        	accommodationStudentsForm.setStudy(study);
        	}
        	accommodationStudentsForm.setStudent(student);
        }else{
        	accommodationStudentsForm.setStudent(new Student());
        }
        
        model.addAttribute("studentAccommodations", accommodationManager.findStudentAccommodationsByParams(params2));
        model.addAttribute("cardinalTimeUnit", cardinalTimeUnit);
        setDefaultData(model,accommodationStudentsForm);
        
        return viewName;
    }
    
    private void setDefaultData(ModelMap model,AccommodationStudentsForm accommodationStudentsForm){
      	model.addAttribute("allHostels", hostelManager.findAllHostels());
    	model.addAttribute("allBlocks", hostelManager.findAllBlocks());
    	model.addAttribute("allAcademicYears",getStudentAcadmicYears(accommodationStudentsForm.getStudent().getStudentId()));
    	model.addAttribute("useHostelBlock",useBlocks());
    	model.addAttribute("accommodationStudentsForm",accommodationStudentsForm);
    }
    
    private boolean useBlocks(){
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
       	if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
       		return true;
       	}
       	return false;
    }
    
    /**
     * Get the academicYears in which the student has been doing the studies
     * @param studentId
     * @return
     */
    private List<AcademicYear> getStudentAcadmicYears(int studentId){
    	List<AcademicYear> academicYears=new ArrayList<AcademicYear>();
    	List<? extends StudyPlan> studyPlans=studentManager.findStudyPlansForStudent(studentId);
    	
    	if(studyPlans.size()>0){
			int studyPlanId=studyPlans.get(0).getId();
			List<? extends StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits=studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
	    	    	
			for(int i=studyPlanCardinalTimeUnits.size(); i>0;i--){
				StudyGradeType studyGradeType=studyManager.findStudyGradeType(studyPlanCardinalTimeUnits.get(i-1).getStudyGradeTypeId());
				academicYears.add(academicYearManager.findAcademicYear(studyGradeType.getCurrentAcademicYearId()));
			}
    	}
		
		return academicYears;
    }
}