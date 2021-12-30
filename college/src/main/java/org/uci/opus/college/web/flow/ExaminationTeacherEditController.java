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

package org.uci.opus.college.web.flow;

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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.ExaminationTeacherValidator;
import org.uci.opus.college.web.form.ExaminationTeacherForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/examinationteacher.view")
@SessionAttributes({ ExaminationTeacherEditController.FORM_NAME })
public class ExaminationTeacherEditController {

    public static final String FORM_NAME = "examinationTeacherForm";
    private static Logger log = LoggerFactory.getLogger(ExaminationTeacherEditController.class);

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private ExaminationTeacherValidator examinationTeacherValidator;

    public ExaminationTeacherEditController() {
        super();
    }

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
	    
	    if (log.isDebugEnabled()) {
            log.debug("ExaminationTeacherEditController.setUpForm entered...");
        }

	    NavigationSettings navigationSettings = null;
        ExaminationTeacher examinationTeacher = null;
        Organization organization = null;
        
        HttpSession session = request.getSession(false);
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int examinationId = 0;
        int studyId = 0;
        int staffMemberId = 0;
        int subjectId = 0;
        
        String from = "";
        
        StaffMember staffMember = null;
        Subject subject = null;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
	    ExaminationTeacherForm examinationTeacherForm = (ExaminationTeacherForm) model.get(FORM_NAME);
        if (examinationTeacherForm == null) {
        	examinationTeacherForm = new ExaminationTeacherForm();
            
            /* STUDYFORM.NAVIGATIONSETTINGS - create the object */
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            examinationTeacherForm.setNavigationSettings(navigationSettings);
            
            /* STUDYGRADETYPEFORM.ORGANIZATION - create the object */
            // set default organization id's
            institutionId = OpusMethods.getInstitutionId(session, request);
            branchId = OpusMethods.getBranchId(session, request);
            organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            
            organization = new Organization();
            opusMethods.fillOrganization(session, request, organization,
                    organizationalUnitId, branchId, institutionId);
            examinationTeacherForm.setOrganization(organization);
            
        	examinationTeacher = new ExaminationTeacher();
        	examinationTeacher.setActive("Y");
            examinationTeacherForm.setExaminationTeacher(examinationTeacher);

            if (!StringUtil.isNullOrEmpty(request.getParameter("examinationId"))) {
            	examinationTeacher.setExaminationId(Integer.parseInt(request.getParameter("examinationId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("staffMemberId"))) {
            	examinationTeacher.setStaffMemberId(Integer.parseInt(request.getParameter("staffMemberId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
            	examinationTeacherForm.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("from"))) {
            	examinationTeacherForm.setFrom(request.getParameter("from"));
            }

            model.addAttribute(FORM_NAME, examinationTeacherForm);
        } 

    	from = examinationTeacherForm.getFrom();
    	navigationSettings = examinationTeacherForm.getNavigationSettings();
    	organization = examinationTeacherForm.getOrganization();
        institutionId = organization.getInstitutionId();
        branchId = organization.getBranchId();
        organizationalUnitId = organization.getOrganizationalUnitId();
        studyId = examinationTeacherForm.getStudyId();
        subjectId = examinationTeacherForm.getSubjectId();
        examinationId = examinationTeacherForm.getExaminationTeacher().getExaminationId();
        staffMemberId = examinationTeacherForm.getExaminationTeacher().getStaffMemberId();

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(examinationTeacherForm.getOrganization(),
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());
        
        if ("staffmember".equals(from)) {
            examinationTeacherForm.setFormView("college/person/examinationTeacher");
            
            if (staffMemberId != 0) {
                staffMember = staffMemberManager.findStaffMember(preferredLanguage, staffMemberId);
            }
            examinationTeacherForm.setStaffMember(staffMember);

			List<Study> allStudies = null;
			List<Subject> allSubjects = null;
			List<Examination> allExaminations = null;
			List<Classgroup> allClassgroups = new ArrayList<>();
			allClassgroups.add(0, null);
        	
	        if (organizationalUnitId != 0) {
	            Map<String, Object> findStudiesMap = new HashMap<>();
	            findStudiesMap.put("institutionId", organization.getInstitutionId());
	            findStudiesMap.put("branchId", organization.getBranchId());
	            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
	            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
	            allStudies = (ArrayList < Study >) studyManager.findStudies(findStudiesMap);

                Map<String, Object> findSubjectsMap = new HashMap<>();
                
                findSubjectsMap.put("institutionId", organization.getInstitutionId());
                findSubjectsMap.put("branchId", organization.getBranchId());
                findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
                findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
                findSubjectsMap.put("studyId", studyId);
                allSubjects = (ArrayList < Subject >) subjectManager.findSubjects(findSubjectsMap);
	       
                // TODO: Move the examination/classgroup filtering to the manager
    	        HashMap<String, Object> findMap = new HashMap<>();
    	        findMap.put("institutionId", organization.getInstitutionId());
    	        findMap.put("branchId", organization.getBranchId());
    	        findMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
    	        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
    	        findMap.put("studyId", studyId);
    	        findMap.put("subjectId", subjectId);
    	        allExaminations = examinationManager.findExaminations(findMap);
    	        
    	        // get all classgroups that are connected with the found examinations
    	        List<Integer> allExaminationIds = new ArrayList<>();
    	        for (Examination examination : allExaminations) {
    	        	allExaminationIds.add(examination.getId());
    	        }
    			Map<String, Object> findClassgroupsMap = new HashMap<>();
    			findClassgroupsMap.put("institutionId", organization.getInstitutionId());
    			findClassgroupsMap.put("branchId", organization.getBranchId());
    			findClassgroupsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
    			findClassgroupsMap.put("studyId", studyId);
    			findClassgroupsMap.put("subjectId", subjectId);
    			allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

    			// create a map of all available examination/classgroup combinations
    	        Map<String, Object []> examinationClassgroupMap = new HashMap<>();
        		for (Examination examination : allExaminations) {
        			String key = examination.getId() + ":0";
        			examinationClassgroupMap.put(key, new Object[] { examination, null });
    	    		for (SubjectClassgroup subjectClassgroup : examination.getSubject().getSubjectClassgroups()) {
    	    			key = examination.getId() + ":"  + subjectClassgroup.getClassgroupId();
    	    			for (Classgroup classgroup : allClassgroups) {
    	    				if (classgroup != null && classgroup.getId() == subjectClassgroup.getClassgroupId()) {
    	    					examinationClassgroupMap.put(key, new Object[] { examination, classgroup });
    	    					break;
    	    				}
    	    			}	    			
    	    		}
        		}

    	        // exclude already added examination/classgroup combinations
    	    	for (ExaminationTeacher examinationTaught : examinationTeacherForm.getStaffMember().getExaminationsTaught()) {
    	    		Integer classgroupId = examinationTaught.getClassgroupId();
    	    		if (classgroupId == null) {
    	    			// if the teacher has a ExaminationTeacher without a classgroup specified 
    	    			// (meaning he covers all classes), then remove all classgroups. 
    	    			String prefix = examinationTaught.getExaminationId() + ":";
    	    			for (String key : examinationClassgroupMap.keySet().toArray(new String[examinationClassgroupMap.size()])) {
    	    				if (key.startsWith(prefix)) {
    	    					examinationClassgroupMap.remove(key);
    	    				}
    	    			}
    	    		} else {
    		    		String key = examinationTaught.getExaminationId() + ":"  + classgroupId;
    		    		examinationClassgroupMap.remove(key);
    	    			// if the teacher has a ExaminationTeacher with a classgroup specified 
    	    			// (meaning he covers one or more specific classes), then don't
    		    		// allow the ExaminationTeacher without a classgroup.
    		    		key = examinationTaught.getExaminationId() + ":0";
    		    		examinationClassgroupMap.remove(key);
    	    		}
    	    	}
    	        List<Examination> retainExaminationList = new ArrayList<>();
    	        List<Classgroup> retainClassgroupList = new ArrayList<>();
    	    	for (Object[] obj : examinationClassgroupMap.values()) {
    	    		Examination examination = (Examination)obj[0];
    	    		retainExaminationList.add(examination);
    	    		if (examinationId == examination.getId()) {
        				retainClassgroupList.add((Classgroup)obj[1]);
    	    		}
    	    	}
    	    	
    	    	allExaminations.retainAll(retainExaminationList);
    	    	allClassgroups.retainAll(retainClassgroupList);
    	    	
    	    	if (examinationId == 0) {
    	    		allClassgroups.clear();
    	    		allClassgroups.add(null);
    	    	}
            }
            
	        examinationTeacherForm.setAllStudies(allStudies);
            examinationTeacherForm.setAllSubjects(allSubjects);
            examinationTeacherForm.setAllExaminations(allExaminations);
    		examinationTeacherForm.setAllClassgroups(allClassgroups);

            // ACADEMIC YEARS
            List <AcademicYear> allAcademicYears = null;
            Map<String, Object> map = new HashMap<>();
            map.put("organizationalUnitId", organizationalUnitId);
            map.put("studyId", studyId);
            allAcademicYears = studyManager.findAllAcademicYears(map);
            examinationTeacherForm.setAllAcademicYears(allAcademicYears);
        }
        
        if ("subject".equals(from)) {
            examinationTeacherForm.setFormView("college/subject/examinationTeacher");
            
            // needed in crumbs path
            if (subjectId != 0) {
                subject = subjectManager.findSubject(subjectId);
            }
            examinationTeacherForm.setSubject(subject);
            
            Examination examination = null;
	        if (examinationId != 0) {
	        	examination = examinationManager.findExamination(examinationId);
	        }
	        examinationTeacherForm.setExamination(examination);
	        
	        // TODO: Move the teacher/classgroup filtering to the manager 
	    	List<StaffMember> allTeachers = null; 
			List<Classgroup> allClassgroups = new ArrayList<>();
			allClassgroups.add(0, null);
	    	
	        if (organization.getOrganizationalUnitId() != 0) {
		        HashMap<String, Object> findMap = new HashMap<>();
		        findMap.put("institutionId", organization.getInstitutionId());
		        findMap.put("branchId", organization.getBranchId());
		        findMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
		        findMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
		        allTeachers = staffMemberManager.findStaffMembers(findMap);
		        
		        // get all classgroups that are connected with the found teachers
		        List<Integer> allStaffMemberIds = new ArrayList<>();
		        for (StaffMember teacher : allTeachers) {
		        	allStaffMemberIds.add(teacher.getStaffMemberId());
		        }
				Map<String, Object> findClassgroupsMap = new HashMap<>();
				findClassgroupsMap.put("examinationId", examination.getId());
				allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

				// create a map of all available teacher/classgroup combinations
		        Map<String, Object []> teacherClassgroupMap = new HashMap<>();
	    		for (StaffMember teacher : allTeachers) {
	    			String key = teacher.getStaffMemberId() + ":0";
	    			teacherClassgroupMap.put(key, new Object[] { teacher, null });
		    		for (SubjectClassgroup examinationClassgroup : examination.getSubject().getSubjectClassgroups()) {
		    			key = teacher.getStaffMemberId() + ":"  + examinationClassgroup.getClassgroupId();
		    			for (Classgroup classgroup : allClassgroups) {
		    				if (classgroup != null && classgroup.getId() == examinationClassgroup.getClassgroupId()) {
		    					teacherClassgroupMap.put(key, new Object[] { teacher, classgroup });
		    					break;
		    				}
		    			}	    			
		    		}
	    		}

		        // exclude already added teacher/classgroup combinations
		    	for (ExaminationTeacher examinationThought : examination.getTeachersForExamination()) {
		    		Integer classgroupId = examinationThought.getClassgroupId();
		    		if (classgroupId == null) {
		    			// if the teacher has a ExaminationTeacher without a classgroup specified 
		    			// (meaning he covers all classes), then remove all classgroups. 
		    			String prefix = examinationThought.getStaffMemberId() + ":";
		    			for (String key : teacherClassgroupMap.keySet().toArray(new String[teacherClassgroupMap.size()])) {
		    				if (key.startsWith(prefix)) {
		    					teacherClassgroupMap.remove(key);
		    				}
		    			}
		    		} else {
			    		String key = examinationThought.getStaffMemberId() + ":"  + classgroupId;
			    		teacherClassgroupMap.remove(key);
		    			// if the teacher has a ExaminationTeacher with a classgroup specified 
		    			// (meaning he covers one or more specific classes), then don't
			    		// allow the ExaminationTeacher without a classgroup.
			    		key = examinationThought.getStaffMemberId() + ":0";
			    		teacherClassgroupMap.remove(key);
		    		}
		    	}
		        List<StaffMember> retainTeacherList = new ArrayList<>();
		        List<Classgroup> retainClassgroupList = new ArrayList<>();
		    	for (Object[] obj : teacherClassgroupMap.values()) {
		    		StaffMember teacher = (StaffMember)obj[0];
		    		retainTeacherList.add(teacher);
		    		if (examinationTeacherForm.getExaminationTeacher().getStaffMemberId() == teacher.getStaffMemberId()) {
	    				retainClassgroupList.add((Classgroup)obj[1]);
		    		}
		    	}
		    	
		    	allTeachers.retainAll(retainTeacherList);
		    	allClassgroups.retainAll(retainClassgroupList);
		    	
		    	if (examinationTeacherForm.getExaminationTeacher().getStaffMemberId() == 0) {
		    		allClassgroups.clear();
		    		allClassgroups.add(null);
		    	}
	        }
	        
	        examinationTeacherForm.setAllTeachers(allTeachers);
	        examinationTeacherForm.setAllClassgroups(allClassgroups);
        }
        
        return examinationTeacherForm.getFormView();
    }


	@RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("examinationTeacherForm") ExaminationTeacherForm examinationTeacherForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

        HttpSession session = request.getSession(false);
        
	    if (log.isDebugEnabled()) {
            log.debug("ExaminationTeacherEditController.processSubmit entered...");
        }

        NavigationSettings navSettings = examinationTeacherForm.getNavigationSettings();
        String from = examinationTeacherForm.getFrom();

        String submitFormObject = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
  
        ExaminationTeacher examinationTeacher = examinationTeacherForm.getExaminationTeacher();
        int staffMemberId = examinationTeacher.getStaffMemberId();
        int examinationId = examinationTeacher.getExaminationId();

        if ("true".equals(submitFormObject)) {
        	if (examinationTeacher.getClassgroupId() == 0) {
        		examinationTeacher.setClassgroupId(null);
        	}
        	
            result.pushNestedPath("examinationTeacher");
        	examinationTeacherValidator.validate(examinationTeacher, result);
            result.popNestedPath();
        	
            if (result.hasErrors()) {
                return examinationTeacherForm.getFormView();
            }
            
            if (examinationTeacher.getId() == 0) {
                if (examinationTeacher.getStaffMemberId() != 0 
                        && examinationTeacher.getExaminationId() != 0) {
                    examinationManager.addExaminationTeacher(examinationTeacher);
                    if ("staffmember".equals(from)) {
                        return "redirect:/college/staffmember.view?newForm=true"
                        		+ "&tab=" + navSettings.getTab() 
                        		+ "&panel=" + navSettings.getPanel()
                                + "&staffMemberId=" + staffMemberId
                                + "&currentPageNumber=" + navSettings.getCurrentPageNumber();
                    }
                    if ("subject".equals(from)) {
                        return "redirect:/college/examination.view?newForm=true"
                        		+ "&tab=" + navSettings.getTab() 
                        		+ "&panel=" + navSettings.getPanel()
                        		+ "&examinationId=" + examinationId
                        		+ "&currentPageNumber=" + navSettings.getCurrentPageNumber();
                    }
                }
            }
        } 
        
        return "redirect:/college/examinationteacher.view";
	}
}
