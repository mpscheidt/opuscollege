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
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.SubjectClassgroup;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestTeacher;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.TestManagerInterface;
import org.uci.opus.college.validator.TestTeacherValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.subject.TestTeacher4SubjectForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/subject/testTeacher4Subject.view")
@SessionAttributes({ TestTeacher4SubjectEditController.FORM_NAME })
public class TestTeacher4SubjectEditController {

    public static final String FORM_NAME = "testTeacher4SubjectForm";    // distinguish from person's testTeacherform
    private static Logger log = LoggerFactory.getLogger(TestTeacher4SubjectEditController.class);

    private final String formView = "college/subject/testTeacher4Subject";

    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private TestManagerInterface testManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private TestTeacherValidator testTeacherValidator;

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
        
        TestTeacher4SubjectForm testTeacherForm = (TestTeacher4SubjectForm) model.get(FORM_NAME);
        if (testTeacherForm == null) {
            testTeacherForm = new TestTeacher4SubjectForm();
            model.put(FORM_NAME, testTeacherForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            testTeacherForm.setNavigationSettings(navigationSettings);

            Organization organization = new Organization();
            opusMethods.fillOrganization(session, request, organization);
            testTeacherForm.setOrganization(organization);

            // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);

            // get the testId
            int testId = ServletUtil.getIntParam(request, "testId", 0);
            if (testId == 0) {
                throw new RuntimeException("No testId given");
            }
            Test test = testManager.findTest(testId);
            testTeacherForm.setTest(test);

            // New test teacher
            TestTeacher testTeacher = new TestTeacher();
            testTeacher.setActive("Y");
            testTeacher.setTestId(testId);
            testTeacherForm.setTestTeacher(testTeacher);
        }
		
        loadTeachersClassgroups(testTeacherForm);
        
        return formView;
    }

    /**
     * Load the list of available teachers, depending on filter values
     * @param testTeacherForm
     */
    private void loadTeachersClassgroups(TestTeacher4SubjectForm testTeacherForm) {
    	Test test = testTeacherForm.getTest();
    	Organization organization = testTeacherForm.getOrganization();
    	
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
			findClassgroupsMap.put("testId", test.getId());
			allClassgroups.addAll(studyManager.findClassgroups(findClassgroupsMap));

			// create a map of all available teacher/classgroup combinations
	        Map<String, Object []> teacherClassgroupMap = new HashMap<String, Object []>();
    		for (StaffMember teacher : allTeachers) {
    			String key = teacher.getStaffMemberId() + ":0";
    			teacherClassgroupMap.put(key, new Object[] { teacher, null });
	    		for (SubjectClassgroup testClassgroup : test.getExamination().getSubject().getSubjectClassgroups()) {
	    			key = teacher.getStaffMemberId() + ":"  + testClassgroup.getClassgroupId();
	    			for (Classgroup classgroup : allClassgroups) {
	    				if (classgroup != null && classgroup.getId() == testClassgroup.getClassgroupId()) {
	    					teacherClassgroupMap.put(key, new Object[] { teacher, classgroup });
	    					break;
	    				}
	    			}	    			
	    		}
    		}

	        // exclude already added teacher/classgroup combinations
	    	for (TestTeacher testThought : test.getTeachersForTest()) {
	    		Integer classgroupId = testThought.getClassgroupId();
	    		if (classgroupId == null) {
	    			// if the teacher has a TestTeacher without a classgroup specified 
	    			// (meaning he covers all classes), then remove all classgroups. 
	    			String prefix = testThought.getStaffMemberId() + ":";
	    			for (String key : teacherClassgroupMap.keySet().toArray(new String[teacherClassgroupMap.size()])) {
	    				if (key.startsWith(prefix)) {
	    					teacherClassgroupMap.remove(key);
	    				}
	    			}
	    		} else {
		    		String key = testThought.getStaffMemberId() + ":"  + classgroupId;
		    		teacherClassgroupMap.remove(key);
	    			// if the teacher has a TestTeacher with a classgroup specified 
	    			// (meaning he covers one or more specific classes), then don't
		    		// allow the TestTeacher without a classgroup.
		    		key = testThought.getStaffMemberId() + ":0";
		    		teacherClassgroupMap.remove(key);
	    		}
	    	}
	        List<StaffMember> retainTeacherList = new ArrayList<StaffMember>();
	        List<Classgroup> retainClassgroupList = new ArrayList<Classgroup>();
	    	for (Object[] obj : teacherClassgroupMap.values()) {
	    		StaffMember teacher = (StaffMember)obj[0];
	    		retainTeacherList.add(teacher);
	    		if (testTeacherForm.getTestTeacher().getStaffMemberId() == teacher.getStaffMemberId()) {
    				retainClassgroupList.add((Classgroup)obj[1]);
	    		}
	    	}
	    	
	    	allTeachers.retainAll(retainTeacherList);
	    	allClassgroups.retainAll(retainClassgroupList);
	    	
	    	if (testTeacherForm.getTestTeacher().getStaffMemberId() == 0) {
	    		allClassgroups.clear();
	    		allClassgroups.add(null);
	    	}
        }
        
        testTeacherForm.setAllTeachers(allTeachers);
        testTeacherForm.setAllClassgroups(allClassgroups);
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.institutionId")
    public String institutionChanged(@ModelAttribute(FORM_NAME) TestTeacher4SubjectForm testTeacherForm) {

        Organization organization = testTeacherForm.getOrganization();
        opusMethods.loadBranches(organization);
        loadTeachersClassgroups(testTeacherForm);
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.branchId")
    public String branchChanged(@ModelAttribute(FORM_NAME) TestTeacher4SubjectForm testTeacherForm) {

        opusMethods.loadOrganizationalUnits(testTeacherForm.getOrganization());
        loadTeachersClassgroups(testTeacherForm);
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=organization.organizationalUnitId")
    public String organizationalUnitChanged(@ModelAttribute(FORM_NAME) TestTeacher4SubjectForm testTeacherForm) {

        loadTeachersClassgroups(testTeacherForm);
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=testTeacher.staffMemberId")
    public String staffMemberChanged(@ModelAttribute(FORM_NAME) TestTeacher4SubjectForm testTeacherForm) {

        loadTeachersClassgroups(testTeacherForm);
        return formView;
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            @ModelAttribute(FORM_NAME) TestTeacher4SubjectForm testTeacherForm,
            BindingResult result, ModelMap model) {

        TestTeacher testTeacher = testTeacherForm.getTestTeacher();
        
        if (testTeacher.getClassgroupId() == 0) {
        	testTeacher.setClassgroupId(null);
    	}
        
        // validate
        result.pushNestedPath("testTeacher");
        testTeacherValidator.validate(testTeacher, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }

        // write to database
        testManager.addTestTeacher(testTeacher, request);

        // Success -> Redirect
        NavigationSettings navigationSettings = testTeacherForm.getNavigationSettings();
        Test test = testTeacherForm.getTest();

        return "redirect:/college/test.view?newForm=true&testId=" + test.getId()
                + "&examinationId=" + test.getExaminationId()
                + "&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }
}
