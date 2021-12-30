/*
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
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
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
*/

package org.uci.opus.college.web.flow.subject;

import java.util.ArrayList;
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
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectTeacherValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectTeacherForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectteacher.view")
@SessionAttributes("subjectTeacherForm")
public class SubjectTeacherEditController {
    
     private static Logger log = LoggerFactory.getLogger(SubjectTeacherEditController.class);
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private SubjectManagerInterface subjectManager;
     @Autowired private StaffMemberManagerInterface staffMemberManager;
     @Autowired private OpusMethods opusMethods;
     @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
     @Autowired private BranchManagerInterface branchManager;
     @Autowired private InstitutionManagerInterface institutionManager;
     @Autowired private StudyManagerInterface studyManager;
     @Autowired private SubjectTeacherValidator subjectTeacherValidator;
     
     private String formView;

    public SubjectTeacherEditController() {
        super();
        this.formView = "college/subject/subjectTeacher";
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectTeacherEditController.setUpForm entered...");
        }

        // declare variables
        SubjectTeacherForm subjectTeacherForm = null;
        Organization organization = null;
        Subject subject = null;
        NavigationSettings navSettings = null;
        
        HttpSession session = request.getSession(false);        
        SubjectTeacher subjectTeacher = null;

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int subjectId = 0;
        OrganizationalUnit unitStudy = null;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new subject, destroy any existing one on the session
        opusMethods.removeSessionFormObject("subjectTeacherForm", session, model, opusMethods.isNewForm(request));
        
        /* fetch or create the form object */
        if ((SubjectTeacherForm) session.getAttribute("subjectTeacherForm") != null) {
            subjectTeacherForm = (SubjectTeacherForm) session.getAttribute("subjectTeacherForm");
        } else {
            subjectTeacherForm = new SubjectTeacherForm();
        }

        // entering the form: the SubjectForm.subjectTeacher does not exist yet
        if (subjectTeacherForm.getSubjectTeacher() == null) {
            
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
                subjectId = Integer.parseInt(request.getParameter("subjectId"));
            }
            // subjectId should always be filled
            if (subjectId != 0) {
                // subjectTeachers are only inserted, never updated
                subjectTeacher = new SubjectTeacher();
                subjectTeacher.setSubjectId(subjectId);
                subjectTeacher.setActive("Y");
                subjectTeacherForm.setSubjectTeacher(subjectTeacher);
                
                // needed to show the subject's name in the header (bread crumbs path)
                subject = subjectManager.findSubject(subjectId);
                subjectTeacherForm.setSubject(subject);
                
                // get the list of teacher already connected to the subject
                subjectTeacherForm.setAllBoundTeachers(subjectManager.findSubjectTeachers(subjectId));
                
                // show initially the organizations of the subject, not the ones on the session
                // find organization id's matching with the subject
                int studyId = subject.getPrimaryStudyId();
                organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                                studyId)).getId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);
                
            }
        } else {
            subjectTeacher = subjectTeacherForm.getSubjectTeacher();
            subject = subjectTeacherForm.getSubject();
        }
        
        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectTeacherForm.getNavigationSettings() != null) {
            navSettings = subjectTeacherForm.getNavigationSettings();
        } else {
            navSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navSettings, "subjectteacher.view");
        }
        subjectTeacherForm.setNavigationSettings(navSettings);

        if (subjectTeacherForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                        , branchId, institutionId);
            subjectTeacherForm.setOrganization(organization);

        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectTeacherForm.getOrganization();
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pullDowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                subjectTeacherForm.getOrganization(), session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());

        // TODO: Move the teacher/classgroup filtering to the manager 
    	List<StaffMember> allTeachers = null; 
		List<Classgroup> allClassgroups = new ArrayList<Classgroup>();
		allClassgroups.add(0, null);
    	
        if (organization.getOrganizationalUnitId() != 0) {
	        HashMap<String, Object> findMap = new HashMap<String, Object>();
	        findMap.put("institutionId", organization.getInstitutionId());
	        findMap.put("branchId", organization.getBranchId());
	        findMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
	        findMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
	        allTeachers = staffMemberManager.findStaffMembers(findMap);
	        
	        // get all classgroups that are connected with the found teachers
	        List<Integer> allStaffMemberIds = new ArrayList<Integer>();
	        for (StaffMember teacher : allTeachers) {
	        	allStaffMemberIds.add(teacher.getStaffMemberId());
	        }
			Map<String, Object> findClassgroupsMap = new HashMap<String, Object>();
			findClassgroupsMap.put("subjectId", subject.getId());
			allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

			// create a map of all available teacher/classgroup combinations
	        Map<String, Object []> teacherClassgroupMap = new HashMap<String, Object []>();
    		for (StaffMember teacher : allTeachers) {
    			String key = teacher.getStaffMemberId() + ":0";
    			teacherClassgroupMap.put(key, new Object[] { teacher, null });
	    		for (SubjectClassgroup subjectClassgroup : subject.getSubjectClassgroups()) {
	    			key = teacher.getStaffMemberId() + ":"  + subjectClassgroup.getClassgroupId();
	    			for (Classgroup classgroup : allClassgroups) {
	    				if (classgroup != null && classgroup.getId() == subjectClassgroup.getClassgroupId()) {
	    					teacherClassgroupMap.put(key, new Object[] { teacher, classgroup });
	    					break;
	    				}
	    			}	    			
	    		}
    		}

	        // exclude already added teacher/classgroup combinations
	    	for (SubjectTeacher subjectThought : subject.getSubjectTeachers()) {
	    		Integer classgroupId = subjectThought.getClassgroupId();
	    		if (classgroupId == null) {
	    			// if the teacher has a SubjectTeacher without a classgroup specified 
	    			// (meaning he covers all classes), then remove all classgroups. 
	    			String prefix = subjectThought.getStaffMemberId() + ":";
	    			for (String key : teacherClassgroupMap.keySet().toArray(new String[teacherClassgroupMap.size()])) {
	    				if (key.startsWith(prefix)) {
	    					teacherClassgroupMap.remove(key);
	    				}
	    			}
	    		} else {
		    		String key = subjectThought.getStaffMemberId() + ":"  + classgroupId;
		    		teacherClassgroupMap.remove(key);
	    			// if the teacher has a SubjectTeacher with a classgroup specified 
	    			// (meaning he covers one or more specific classes), then don't
		    		// allow the SubjectTeacher without a classgroup.
		    		key = subjectThought.getStaffMemberId() + ":0";
		    		teacherClassgroupMap.remove(key);
	    		}
	    	}
	        List<StaffMember> retainTeacherList = new ArrayList<StaffMember>();
	        List<Classgroup> retainClassgroupList = new ArrayList<Classgroup>();
	    	for (Object[] obj : teacherClassgroupMap.values()) {
	    		StaffMember teacher = (StaffMember)obj[0];
	    		retainTeacherList.add(teacher);
	    		if (subjectTeacherForm.getSubjectTeacher().getStaffMemberId() == teacher.getStaffMemberId()) {
    				retainClassgroupList.add((Classgroup)obj[1]);
	    		}
	    	}
	    	
	    	allTeachers.retainAll(retainTeacherList);
	    	allClassgroups.retainAll(retainClassgroupList);
	    	
	    	if (subjectTeacherForm.getSubjectTeacher().getStaffMemberId() == 0) {
	    		allClassgroups.clear();
	    		allClassgroups.add(null);
	    	}
        }
        
        subjectTeacherForm.setAllUnboundTeachers(allTeachers);
        subjectTeacherForm.setAllClassgroups(allClassgroups);
        
        model.addAttribute("subjectTeacherForm", subjectTeacherForm);        
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectTeacherForm") SubjectTeacherForm subjectTeacherForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("SubjectTeacherEditController.processSubmit entered...");
        }
        
        SubjectTeacher subjectTeacher = subjectTeacherForm.getSubjectTeacher();
        NavigationSettings navSettings = subjectTeacherForm.getNavigationSettings();
        String submitFormObject = "";

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        
        // it's only possible to insert (and delete) not to update
        if ("true".equals(submitFormObject)) {
        	if (subjectTeacher.getClassgroupId() == 0) {
        		subjectTeacher.setClassgroupId(null);
        	}
        	
            result.pushNestedPath("subjectTeacher");
            subjectTeacherValidator.validate(subjectTeacherForm.getSubjectTeacher(), result);
            result.popNestedPath();
            
            if (result.hasErrors()) {
                return formView;
            }
            
            subjectManager.addSubjectTeacher(subjectTeacher);
            status.setComplete();

            return "redirect:/college/subject.view?newForm=true&tab=" + navSettings.getTab()
            								+ "&panel=" + navSettings.getPanel() 
                                            + "&subjectId=" + subjectTeacher.getSubjectId()
                                            + "&currentPageNumber="
                                            + navSettings.getCurrentPageNumber();
        // submit but no save
        } else {
            return "redirect:/college/subjectteacher.view";
        }
    }
}
