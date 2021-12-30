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
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.TestTeacherValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.TestTeacherForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/testteacher.view")
@SessionAttributes({ TestTeacherEditController.FORM_NAME })
public class TestTeacherEditController {

    public static final String FORM_NAME = "testTeacherForm";
    private static Logger log = LoggerFactory.getLogger(TestTeacherEditController.class);

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private TestManagerInterface testManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private TestTeacherValidator testTeacherValidator;
    
    public TestTeacherEditController() {
        super();
    }

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request)  {
	    
	    if (log.isDebugEnabled()) {
            log.debug("TestTeacherEditController.setUpForm entered...");
        }

	    NavigationSettings navigationSettings = null;
        TestTeacher testTeacher = null;
        Organization organization = null;
        
        HttpSession session = request.getSession(false);
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int testId = 0;
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
        
	    TestTeacherForm testTeacherForm = (TestTeacherForm) model.get(FORM_NAME);
        if (testTeacherForm == null) {
        	testTeacherForm = new TestTeacherForm();
            
            /* STUDYFORM.NAVIGATIONSETTINGS - create the object */
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            testTeacherForm.setNavigationSettings(navigationSettings);
            
            /* STUDYGRADETYPEFORM.ORGANIZATION - create the object */
            // set default organization id's
            institutionId = OpusMethods.getInstitutionId(session, request);
            branchId = OpusMethods.getBranchId(session, request);
            organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
            
            organization = new Organization();
            opusMethods.fillOrganization(session, request, organization,
                    organizationalUnitId, branchId, institutionId);
            testTeacherForm.setOrganization(organization);
            
        	testTeacher = new TestTeacher();
        	testTeacher.setActive("Y");
            testTeacherForm.setTestTeacher(testTeacher);

            if (!StringUtil.isNullOrEmpty(request.getParameter("testId"))) {
            	testTeacher.setTestId(Integer.parseInt(request.getParameter("testId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("staffMemberId"))) {
            	testTeacher.setStaffMemberId(Integer.parseInt(request.getParameter("staffMemberId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectId"))) {
            	testTeacherForm.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("from"))) {
            	testTeacherForm.setFrom(request.getParameter("from"));
            }

            model.addAttribute(FORM_NAME, testTeacherForm);
        } 

    	from = testTeacherForm.getFrom();
    	navigationSettings = testTeacherForm.getNavigationSettings();
    	organization = testTeacherForm.getOrganization();
        institutionId = organization.getInstitutionId();
        branchId = organization.getBranchId();
        organizationalUnitId = organization.getOrganizationalUnitId();
        studyId = testTeacherForm.getStudyId();
        subjectId = testTeacherForm.getSubjectId();
        testId = testTeacherForm.getTestTeacher().getTestId();
        staffMemberId = testTeacherForm.getTestTeacher().getStaffMemberId();

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(testTeacherForm.getOrganization(),
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());
        
        if ("staffmember".equals(from)) {
            testTeacherForm.setFormView("college/person/testTeacher");
            
            if (staffMemberId != 0) {
                staffMember = staffMemberManager.findStaffMember(preferredLanguage, staffMemberId);
            }
            testTeacherForm.setStaffMember(staffMember);

			List<Study> allStudies = null;
			List<Subject> allSubjects = null;
			List<Test> allTests = null;
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
	       
                // TODO: Move the test/classgroup filtering to the manager
    	        HashMap<String, Object> findMap = new HashMap<>();
    	        findMap.put("institutionId", organization.getInstitutionId());
    	        findMap.put("branchId", organization.getBranchId());
    	        findMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
    	        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
    	        findMap.put("studyId", studyId);
    	        findMap.put("subjectId", subjectId);
    	        allTests = testManager.findTests(findMap);
    	        
    	        // get all classgroups that are connected with the found tests
    	        List<Integer> allTestIds = new ArrayList<>();
    	        for (Test test : allTests) {
    	        	allTestIds.add(test.getId());
    	        }
    			Map<String, Object> findClassgroupsMap = new HashMap<>();
    			findClassgroupsMap.put("institutionId", organization.getInstitutionId());
    			findClassgroupsMap.put("branchId", organization.getBranchId());
    			findClassgroupsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
    			findClassgroupsMap.put("studyId", studyId);
    			findClassgroupsMap.put("subjectId", subjectId);
    			allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

    			// create a map of all available test/classgroup combinations
    	        Map<String, Object []> testClassgroupMap = new HashMap<>();
        		for (Test test : allTests) {
        			String key = test.getId() + ":0";
        			testClassgroupMap.put(key, new Object[] { test, null });
    	    		for (SubjectClassgroup subjectClassgroup : test.getExamination().getSubject().getSubjectClassgroups()) {
    	    			key = test.getId() + ":"  + subjectClassgroup.getClassgroupId();
    	    			for (Classgroup classgroup : allClassgroups) {
    	    				if (classgroup != null && classgroup.getId() == subjectClassgroup.getClassgroupId()) {
    	    					testClassgroupMap.put(key, new Object[] { test, classgroup });
    	    					break;
    	    				}
    	    			}	    			
    	    		}
        		}

    	        // exclude already added test/classgroup combinations
    	    	for (TestTeacher testThought : testTeacherForm.getStaffMember().getTestsSupervised()) {
    	    		Integer classgroupId = testThought.getClassgroupId();
    	    		if (classgroupId == null) {
    	    			// if the teacher has a TestTeacher without a classgroup specified 
    	    			// (meaning he covers all classes), then remove all classgroups. 
    	    			String prefix = testThought.getTestId() + ":";
    	    			for (String key : testClassgroupMap.keySet().toArray(new String[testClassgroupMap.size()])) {
    	    				if (key.startsWith(prefix)) {
    	    					testClassgroupMap.remove(key);
    	    				}
    	    			}
    	    		} else {
    		    		String key = testThought.getTestId() + ":"  + classgroupId;
    		    		testClassgroupMap.remove(key);
    	    			// if the teacher has a TestTeacher with a classgroup specified 
    	    			// (meaning he covers one or more specific classes), then don't
    		    		// allow the TestTeacher without a classgroup.
    		    		key = testThought.getTestId() + ":0";
    		    		testClassgroupMap.remove(key);
    	    		}
    	    	}
    	        List<Test> retainTestList = new ArrayList<>();
    	        List<Classgroup> retainClassgroupList = new ArrayList<>();
    	    	for (Object[] obj : testClassgroupMap.values()) {
    	    		Test test = (Test)obj[0];
    	    		retainTestList.add(test);
    	    		if (testId == test.getId()) {
        				retainClassgroupList.add((Classgroup)obj[1]);
    	    		}
    	    	}
    	    	
    	    	allTests.retainAll(retainTestList);
    	    	allClassgroups.retainAll(retainClassgroupList);
    	    	
    	    	if (testId == 0) {
    	    		allClassgroups.clear();
    	    		allClassgroups.add(null);
    	    	}
            }
            
	        testTeacherForm.setAllStudies(allStudies);
            testTeacherForm.setAllSubjects(allSubjects);
            testTeacherForm.setAllTests(allTests);
    		testTeacherForm.setAllClassgroups(allClassgroups);

            // ACADEMIC YEARS
            List <AcademicYear> allAcademicYears = null;
            Map<String, Object> map = new HashMap<>();
            map.put("organizationalUnitId", organizationalUnitId);
            map.put("studyId", studyId);
            allAcademicYears = studyManager.findAllAcademicYears(map);
            testTeacherForm.setAllAcademicYears(allAcademicYears);
        }
        
        if ("subject".equals(from)) {
            testTeacherForm.setFormView("college/subject/testTeacher");
            
            // needed in crumbs path
            if (subjectId != 0) {
                subject = subjectManager.findSubject(subjectId);
            }
            testTeacherForm.setSubject(subject);
            
            Test test = null;
	        if (testId != 0) {
	        	test = testManager.findTest(testId);
	        }
	        testTeacherForm.setTest(test);
	        
	        /* testTeacher domain attributes */
	        List < TestTeacher > allTestTeachers = null;
	        // list of teachers already assigned to supervise this test 
			allTestTeachers = (ArrayList<TestTeacher>) testManager.findTeachersForTest(testId);
	        testTeacherForm.setAllTestTeachers(allTestTeachers);
	        testTeacherForm.setAllTestTeachers(allTestTeachers);

	        /* staffmember domain attributes */
	        List < StaffMember > allTeachers = null;
	        Map<String, Object> map = new HashMap<>();
	        map.put("institutionId", institutionId);
	        map.put("branchId", branchId);
	        map.put("organizationalUnitId", organizationalUnitId);
	        map.put("searchValue", "");
	        allTeachers = (ArrayList < StaffMember >) staffMemberManager.findStaffMembers(map);
	        testTeacherForm.setAllTeachers(allTeachers);
	        
			Map<String, Object> findClassgroupsMap = new HashMap<>();
			findClassgroupsMap.put("institutionId", organization.getInstitutionId());
			findClassgroupsMap.put("branchId", organization.getBranchId());
			findClassgroupsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
			findClassgroupsMap.put("studyId", studyId);
			findClassgroupsMap.put("subjectId", subjectId);
			List <Classgroup> allClassgroups = studyManager.findClassgroups(findClassgroupsMap);
			allClassgroups.add(0, null);
			testTeacherForm.setAllClassgroups(allClassgroups);
        }
        
        return testTeacherForm.getFormView();
    }


	@RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("testTeacherForm") TestTeacherForm testTeacherForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

	    if (log.isDebugEnabled()) {
            log.debug("TestTeacherEditController.processSubmit entered...");
        }

        NavigationSettings navSettings = testTeacherForm.getNavigationSettings();
        String from = testTeacherForm.getFrom();

        String submitFormObject = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
  
        TestTeacher testTeacher = testTeacherForm.getTestTeacher();
        int staffMemberId = testTeacher.getStaffMemberId();
        int testId = testTeacher.getTestId();
        
        if ("true".equals(submitFormObject)) {
        	if (testTeacher.getClassgroupId() == 0) {
        		testTeacher.setClassgroupId(null);
        	}
        	
        	result.pushNestedPath("testTeacher");
            testTeacherValidator.validate(testTeacher, result);
            result.popNestedPath();
            
            if (result.hasErrors()) {
                return testTeacherForm.getFormView();
            }
            if (testTeacher.getId() == 0) {
                if (testTeacher.getStaffMemberId() != 0 
                        && testTeacher.getTestId() != 0) {
                    testManager.addTestTeacher(testTeacher, request);
                    if ("staffmember".equals(from)) {
                        return "redirect:/college/staffmember.view?newForm=true"
                        		+ "&tab=" + navSettings.getTab() 
                        		+ "&panel=" + navSettings.getPanel()
                                + "&staffMemberId=" + staffMemberId
                                + "&currentPageNumber=" + navSettings.getCurrentPageNumber();
                    }
                    if ("subject".equals(from)) {
                        return "redirect:/college/test.view?newForm=true"
                        		+ "&tab=" + navSettings.getTab() 
                        		+ "&panel=" + navSettings.getPanel()
                        		+ "&examinationId=" + testTeacherForm.getTest().getExaminationId()
                        		+ "&testId=" + testId
                        		+ "&currentPageNumber=" + navSettings.getCurrentPageNumber();
                    }
                }
            }
        } 
        
        return "redirect:/college/testteacher.view";
	}
}
