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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectTeacherValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.person.TeachersSubjectForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@SessionAttributes({ TeachersSubjectEditController.FORM_NAME })
@RequestMapping("/college/teacherssubject.view")
public class TeachersSubjectEditController extends FormController<SubjectTeacher, TeachersSubjectForm> {

    private final String viewName = "college/person/teachersSubject";

    public static final String FORM_NAME = "teachersSubjectForm";

    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private SubjectTeacherValidator subjectTeacherValidator;
    
    public TeachersSubjectEditController() {
        super(FORM_NAME, "studies");
    }
    
    @RequestMapping(method=RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {
        
        HttpSession session = request.getSession(false);

        TeachersSubjectForm teachersSubjectForm = super.initSetupForm(model, request);

//        HttpSession session = request.getSession(false);
//        securityChecker.checkSessionValid(session);
//        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        
//        /* set menu to subjects */
//        session.setAttribute("menuChoice", "studies");
//        
//        Organization organization = null;
//        SubjectTeacher subjectTeacher = null;
//        
//        TeachersSubjectForm teachersSubjectForm = (TeachersSubjectForm) model.get(FORM_NAME);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        Organization organization = teachersSubjectForm.getOrganization();
        int organizationalUnitId = organization.getOrganizationalUnitId();
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization,
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organizationalUnitId);

        SubjectTeacher subjectTeacher = teachersSubjectForm.getSubjectTeacher();
        if (organizationalUnitId == 0) {
            subjectTeacher.setSubjectId(0);
        }
        if (subjectTeacher.getSubjectId() == 0) {
            subjectTeacher.setClassgroupId(null);
        }
        int subjectId = subjectTeacher.getSubjectId(); 
        
        List<Subject> allSubjects = null; 
        List<Classgroup> allClassgroups = new ArrayList<>();
        allClassgroups.add(0, null);
        
        if (organizationalUnitId != 0) {
            
            // get studies
            List<Study> allStudies = studyManager.findAllStudiesForOrganizationalUnit(organizationalUnitId);
            teachersSubjectForm.setAllStudies(allStudies);
        }

        int studyId = teachersSubjectForm.getStudyId();
        if (studyId == 0) {
            teachersSubjectForm.setAcademicYearId(0);
            teachersSubjectForm.setAllAcademicYears(null);
        }
        
        if (studyId != 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("studyId", studyId);
            List<AcademicYear> allAcademicYears = studyManager.findAllAcademicYears(map);
            teachersSubjectForm.setAllAcademicYears(allAcademicYears);
            
            // If no academic year selected: pre-select academic year with current year if exists
            // In this case it's ok to force academic year selection: empty academic year wouldn't allow selecting a subject
            setCurrentAcademicYearIfUnset(teachersSubjectForm, allAcademicYears);
        }

        int academicYearId = teachersSubjectForm.getAcademicYearId();
        if (academicYearId != 0) {
            
            // TODO: Move the subject/classgroup filtering to the manager
            Map<String, Object> findMap = new HashMap<>();
            findMap.put("institutionId", organization.getInstitutionId());
            findMap.put("branchId", organization.getBranchId());
            findMap.put("organizationalUnitId", organizationalUnitId);
            findMap.put("studyId", studyId);
            findMap.put("currentAcademicYearId", academicYearId);
            findMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
            allSubjects = subjectManager.findSubjects(findMap);
            
            // get all classgroups that are connected with the found subjects
            List<Integer> allSubjectIds = new ArrayList<>();
            for (Subject subject : allSubjects) {
                allSubjectIds.add(subject.getId());
            }
            Map<String, Object> findClassgroupsMap = new HashMap<>();
            findClassgroupsMap.put("subjectIds", allSubjectIds);
            allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

            // create a map of all available subject/classgroup combinations
            Map<String, Object []> subjectClassgroupMap = new HashMap<>();
            for (Subject subject : allSubjects) {
                String key = subject.getId() + ":0";
                subjectClassgroupMap.put(key, new Object[] { subject, null });
                for (SubjectClassgroup subjectClassgroup : subject.getSubjectClassgroups()) {
                    key = subjectClassgroup.getSubjectId() + ":"  + subjectClassgroup.getClassgroupId();
                    for (Classgroup classgroup : allClassgroups) {
                        if (classgroup != null && classgroup.getId() == subjectClassgroup.getClassgroupId()) {
                            subjectClassgroupMap.put(key, new Object[] { subject, classgroup });
                            break;
                        }
                    }                   
                }
            }

            // exclude already added subject/classgroup combinations
            for (SubjectTeacher subjectThought : teachersSubjectForm.getStaffMember().getSubjectsTaught()) {
                Integer classgroupId = subjectThought.getClassgroupId();
                if (classgroupId == null) {
                    // if the teacher has a SubjectTeacher without a classgroup specified 
                    // (meaning he covers all classes), then remove all classgroups. 
                    String prefix = subjectThought.getSubjectId() + ":";
                    for (String key : subjectClassgroupMap.keySet().toArray(new String[subjectClassgroupMap.size()])) {
                        if (key.startsWith(prefix)) {
                            subjectClassgroupMap.remove(key);
                        }
                    }
                } else {
                    String key = subjectThought.getSubjectId() + ":"  + classgroupId;
                    subjectClassgroupMap.remove(key);
                    // if the teacher has a SubjectTeacher with a classgroup specified 
                    // (meaning he covers one or more specific classes), then don't
                    // allow the SubjectTeacher without a classgroup.
                    key = subjectThought.getSubjectId() + ":0";
                    subjectClassgroupMap.remove(key);
                }
            }
            List<Subject> retainSubjectList = new ArrayList<>();
            List<Classgroup> retainClassgroupList = new ArrayList<>();
            for (Object[] obj : subjectClassgroupMap.values()) {
                Subject subject = (Subject)obj[0];
                retainSubjectList.add(subject);
                if (subjectId == subject.getId()) {
                    retainClassgroupList.add((Classgroup)obj[1]);
                }
            }

            allSubjects.retainAll(retainSubjectList);
            allClassgroups.retainAll(retainClassgroupList);
            
            if (subjectId == 0) {
                allClassgroups.clear();
                allClassgroups.add(null);
            }
        }
        
        teachersSubjectForm.setAllSubjects(allSubjects);
        teachersSubjectForm.setAllClassgroups(allClassgroups);
        
        return viewName;
    }
    
    @Override
    protected TeachersSubjectForm createForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
//        if (teachersSubjectForm == null) {
            TeachersSubjectForm teachersSubjectForm = new TeachersSubjectForm();
//            model.put(FORM_NAME, teachersSubjectForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            teachersSubjectForm.setNavigationSettings(navigationSettings);

            // get the organization values from session:
        	Organization organization = new Organization();
            int institutionId = OpusMethods.getInstitutionId(session, request);
            int branchId = OpusMethods.getBranchId(session, request);
            int organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);            
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
            teachersSubjectForm.setOrganization(organization);
            
            int staffMemberId = ServletUtil.getIntParam(request, "staffMemberId", 0); 
            if (staffMemberId != 0) {
                StaffMember staffMember = staffMemberManager.findStaffMember(preferredLanguage, staffMemberId);
                teachersSubjectForm.setStaffMember(staffMember);
            }
            
            SubjectTeacher subjectTeacher = new SubjectTeacher();
            subjectTeacher.setStaffMemberId(staffMemberId);
            subjectTeacher.setActive("Y");            
            teachersSubjectForm.setSubjectTeacher(subjectTeacher);
//        } else {
//        	organization = teachersSubjectForm.getOrganization();
//        	subjectTeacher = teachersSubjectForm.getSubjectTeacher();
//        }
        
            return teachersSubjectForm;
    }
    
    @Transactional
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) TeachersSubjectForm teachersSubjectForm,
            BindingResult result, ModelMap model)
            {

    	Organization organization = teachersSubjectForm.getOrganization();
    	NavigationSettings navigationSettings = teachersSubjectForm.getNavigationSettings();
    	
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        String submitFormObject = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
        	SubjectTeacher subjectTeacher = teachersSubjectForm.getSubjectTeacher();
        	if (subjectTeacher.getClassgroupId() == 0) {
        		subjectTeacher.setClassgroupId(null);
        	}
            
            result.pushNestedPath("subjectTeacher");
            subjectTeacherValidator.validate(teachersSubjectForm.getSubjectTeacher(), result);
            result.popNestedPath();
            
            if (result.hasErrors()) {
                return viewName;
            }
            
            subjectManager.addSubjectTeacher(subjectTeacher);
            sessionStatus.setComplete();

            return "redirect:/college/staffmember.view"
            		+ "?newForm=true"
                    + "&staffMemberId=" + subjectTeacher.getStaffMemberId()
		            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
		            + "&tab=" + navigationSettings.getTab() 
		            + "&panel=" + navigationSettings.getPanel();
        }
        
        session.setAttribute("institutionId", organization.getInstitutionId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
        
        return "redirect:/college/teacherssubject.view";
    }
}
