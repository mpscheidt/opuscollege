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

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
import org.uci.opus.accommodation.domain.AccommodationResource;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.accommodation.domain.StudentAccommodationResource;
import org.uci.opus.accommodation.service.AccommodationManagerInterface;
import org.uci.opus.accommodation.service.HostelManagerInterface;
import org.uci.opus.accommodation.web.form.StudentAccommodationResourceForm;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;


@Controller
@RequestMapping("/accommodation/deallocateResource.view")
@SessionAttributes({"studentAccommodationResourceForm"})
@PreAuthorize("hasAnyRole('READ_ACCOMMODATION_DATA')")
public class DeallocateResourceController {
	
    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private AccommodationManagerInterface accommodationManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private HostelManagerInterface hostelManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
     
    private static Logger log = LoggerFactory.getLogger(AllocateController.class);

    public DeallocateResourceController() {
		super();
		this.formView = "accommodation/students/deallocateResource";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	
		StudentAccommodationResourceForm studentAccommodationResourceForm = new StudentAccommodationResourceForm();
    	
    	//Organization organization = null;
        //NavigationSettings navigationSettings = null;
		HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
               
        loadData(studentAccommodationResourceForm, model, request);
        
        return formView;
	
	}
	
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("studentAccommodationResourceForm") StudentAccommodationResourceForm studentAccommodationResourceForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,ModelMap model) {
    		
    	String viewName=formView;
    	StudentAccommodationResource resource=new StudentAccommodationResource();
    	resource.setId(studentAccommodationResourceForm.getId());
    	resource.setCommentWhenReturning(studentAccommodationResourceForm.getCommentWhenReturning());
    	resource.setDateReturned(new Date());
    	
      	accommodationManager.deallocateAccommodationResource(resource.getId(), resource.getDateReturned(), resource.getCommentWhenReturning());
       	setDefaultData(model, studentAccommodationResourceForm,request,OpusMethods.getPreferredLanguage(request));
    	    	
		return viewName;
    }
    
    private void loadData(StudentAccommodationResourceForm studentAccommodationResourceForm,ModelMap model, HttpServletRequest request){
       	setDefaultData(model,studentAccommodationResourceForm,request,OpusMethods.getPreferredLanguage(request));
    }
    
    private void setDefaultData(ModelMap model,StudentAccommodationResourceForm studentAccommodationResourceForm,HttpServletRequest request,String preferredLanguage){
    	HttpSession session = request.getSession(false);
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        int studentAccommodationId=Integer.parseInt(request.getParameter("studentAccommodationId"));
        int studentAccommodationResourceId=ServletUtil.getIntParam(request, "studentAccommodationResourceId", 0);
       	
       	StudentAccommodation studentAccommodation=accommodationManager.findStudentAccommodation(studentAccommodationId);
       	StudentAccommodationResource studentAccommodationResource=accommodationManager.getStudentAccommodationResource(studentAccommodationResourceId);
       	Study study=studyManager.findStudy((studentAccommodation.getStudent().getPrimaryStudyId()));
      
       	//populate the form object with values from studentAccommodationObject
        fillStudentAccommodationResourceForm(studentAccommodationResourceForm, studentAccommodationResource);  	
       	
       	//set the attributes
       	model.addAttribute("studentAccommodationResource", studentAccommodationResource);
        model.addAttribute("studentAccommodationId", studentAccommodationId); 	
       	model.addAttribute("student",studentAccommodation.getStudent());
       	model.addAttribute("accommodationResourceMap",getAccommodationResourses());
       	model.addAttribute("study",study);
       	model.addAttribute("studentAccommodationResources",accommodationManager.getStudentAccommodationResources(studentAccommodationId));
    	model.addAttribute("studentAccommodationResourceForm", studentAccommodationResourceForm);
    	model.addAttribute("accommodationResources",accommodationManager.getAccommodationResources());
     }
  
    
    private void fillStudentAccommodationResourceForm(StudentAccommodationResourceForm form,StudentAccommodationResource resource){
    	if(form!=null && resource!=null){
    		form.setId(resource.getId());
    		form.setAccommodationResourceId(resource.getAccommodationResourceId());
    		form.setCommentWhenCollecting(resource.getCommentWhenCollecting());
    		form.setDateCollected(resource.getDateCollected());
    		form.setDateReturned(resource.getDateCollected());
    		form.setStudentAccommodationId(resource.getStudentAccommodationId());
    		form.setCommentWhenReturning(resource.getCommentWhenReturning());
    	}
    }

    private Map<Integer,AccommodationResource> getAccommodationResourses(){
    	Map<Integer,AccommodationResource> map=null;
    	List<AccommodationResource> accommodationResources=accommodationManager.getAccommodationResources();
    	if(accommodationResources!=null){
    		map=new HashMap<Integer,AccommodationResource>();
    		
    		for(AccommodationResource resource:accommodationResources){
    			map.put(resource.getId(), resource);
    		}
    	}
    	return map;
    }
}