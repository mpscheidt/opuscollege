package org.uci.opus.fee.web.flow;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

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
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.web.form.StudentFeeForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/fee/studentfee.view")
@SessionAttributes("studentFeeForm")
public class StudentFeeEditController {
    
    private static Logger log = LoggerFactory.getLogger(StudentFeeEditController.class);
    private String formView;
    @Autowired StudyManagerInterface studyManager;
    @Autowired StudentManagerInterface studentManager;
    @Autowired FeeManagerInterface feeManager;
    @Autowired OpusMethods opusMethods;
    @Autowired AcademicYearManagerInterface academicYearManager;
    @Autowired LookupManagerInterface lookupManager;
    @Autowired SubjectManagerInterface subjectManager;
    @Autowired SecurityChecker securityChecker;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    public StudentFeeEditController() {
        super();
        this.formView = "fee/fee/studentfee";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) 
            throws Exception {
    
        if (log.isDebugEnabled()) {
            log.debug("StudentFeeEditController.setUpForm entered...");
        }
        StudentFeeForm studentFeeForm = new StudentFeeForm();
        NavigationSettings navigationSettings = new NavigationSettings();

        int studentId = 0;
        // used in crumbs path
        Student student = null;
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        String writeWho = opusMethods.getWriteWho(request);
        
        if (StringUtil.isEmpty(writeWho, true)) {
            writeWho = "anonymous";
        }
        
        studentFeeForm.setWriteWho(writeWho);
        
        
        // studentId should always exist
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
            studentId = Integer.parseInt(request.getParameter("studentId"));
            student = studentManager.findStudent(preferredLanguage, studentId);
            studentFeeForm.setStudent(student);
            
            // get studyPlans of student: also contains studyPlanCTU's and studyPlanDetails
            List < StudyPlan > allStudyPlans = studentManager.findStudyPlansForStudent(studentId);
            studentFeeForm.setStudyPlans(allStudyPlans);

            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            studentFeeForm.setNavigationSettings(navigationSettings);
            
            
            /* find studyGradeTypes of interest to this student, in order to find the 
             * subjectBlockStudyGradeTypes and the subjectStudyGradeTypes
             */
            HashMap<String, Object> findGradeTypesMap = new HashMap<String, Object>();
            findGradeTypesMap.put("personId", student.getPersonId());
            findGradeTypesMap.put("preferredLanguage", preferredLanguage);
            List < StudyGradeType > allStudyGradeTypes = studyManager.findStudyGradeTypes(findGradeTypesMap);
            
            studentFeeForm.setAllStudyGradeTypes(allStudyGradeTypes);
            HashMap<String, Object> map = new HashMap<String, Object>();           
            map.put("studyGradeTypeIds", DomainUtil.getIds(allStudyGradeTypes));
            map.put("preferredLanguage", preferredLanguage);
            
            // subjectBlockStudyGradeTypes
            List < SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(map);
            studentFeeForm.setAllSubjectBlockStudyGradeTypes(allSubjectBlockStudyGradeTypes);
            
            // subjectStudyGradeTypes
            List < SubjectStudyGradeType > allSubjectStudyGradeTypes  = subjectManager.findSubjectStudyGradeTypes(map);
            studentFeeForm.setAllSubjectStudyGradeTypes(allSubjectStudyGradeTypes);
            
            // find studentBalances
            List < Fee > existingStudentFees = feeManager.findExistingFeesForStudent(student.getStudentId());
            studentFeeForm.setExistingStudentFees(existingStudentFees);

        } else {
            studentFeeForm.setTxtError("error studentId does not exist");
            model.addAttribute("studentFeeForm", studentFeeForm);    
            return formView;
        }
        
        List <AcademicYear> allAcademicYears = 
            academicYearManager.findAllAcademicYears();
        studentFeeForm.setAllAcademicYears(allAcademicYears);
        
        List < ? extends Lookup > allFeeCategories = lookupManager.findAllRows(preferredLanguage, "fee_feeCategory");
        studentFeeForm.setAllFeeCategories(allFeeCategories);
        List < ? extends Lookup > allFeeUnits = lookupManager.findAllRows(preferredLanguage, "fee_unit");
        studentFeeForm.setAllFeeUnits(allFeeUnits);
        List < ? extends Lookup > allStudyTimes = lookupManager.findAllRows(preferredLanguage, "studytime");
        studentFeeForm.setAllStudyTimes(allStudyTimes);
        List < ? extends Lookup > allStudyForms = lookupManager.findAllRows(preferredLanguage, "studyform");
        studentFeeForm.setAllStudyForms(allStudyForms);
        
        model.addAttribute("studentFeeForm", studentFeeForm);        
        return formView;
    }
    

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("studentFeeForm") StudentFeeForm studentFeeForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 

        NavigationSettings navigationSettings = studentFeeForm.getNavigationSettings();

        Student student = studentFeeForm.getStudent();
        int studentId = student.getStudentId();
        StudyPlan studyPlan = studentFeeForm.getStudyPlan();
        int studyPlanId = studyPlan.getId();
        String writeWho = studentFeeForm.getWriteWho();
        int cardinalTimeUnitNumber = 0;
        int studyPlanDetailId = 0;
        int studyPlanCardinalTimeUnitId = 0;
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
       
        String submitFormObject = "";
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        
        if ("true".equals(submitFormObject)) {
            // get the studyGradeTypeFees to add
            String[] studyGradeTypeFees = request.getParameterValues("possibleStudyGradeTypeFee");
            if (studyGradeTypeFees != null && studyGradeTypeFees.length != 0) {
                List feeIdsToAdd = Arrays.asList(studyGradeTypeFees);
            
                for (int i = 0; i < feeIdsToAdd.size(); i++) {
                    // add all selected fees to the student ( = create studentBalance for all selected fees)
                    int feeId = Integer.parseInt((String) feeIdsToAdd.get(i));
                    Fee fee = feeManager.findFee(feeId);
                    StudentBalance studentBalance = new StudentBalance(studentId, feeId, "N", writeWho);
                    
                    // get studyPlanCardinalTimeUnitId
                    cardinalTimeUnitNumber = studentManager
                            .findMaxCardinalTimeUnitNumberForStudyPlanCTU(studyPlanId
                                                    , fee.getStudyGradeTypeId());
                    if (cardinalTimeUnitNumber != 0) {
                        StudyPlanCardinalTimeUnit studyPlanCTU = studentManager
                                .findStudyPlanCardinalTimeUnitByParams(studyPlanId
                                        , fee.getStudyGradeTypeId(), cardinalTimeUnitNumber);
                        
                        if (studyPlanCTU != null) {
                            studyPlanCardinalTimeUnitId = studyPlanCTU.getId();
                        }
                    }
                            
                    studentBalance.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
                    feeManager.addStudentBalance(studentBalance);
                }
            }
            
            // get the subjectFees to add
            String[] subjectFees = request.getParameterValues("possibleSubjectFee");
            if (subjectFees != null && subjectFees.length != 0) {
                List subjectFeeIdsToAdd = Arrays.asList(subjectFees);

                for (int i = 0; i < subjectFeeIdsToAdd.size(); i++) {
                    // add all selected fees to the student ( = create studentBalance for all selected fees)
                    int feeId = Integer.parseInt((String) subjectFeeIdsToAdd.get(i));
                    Fee fee = feeManager.findFee(feeId);
                    StudentBalance studentBalance = new StudentBalance(studentId, feeId, "N", writeWho);
                    
                    // get studyPlanDetailId
                    HashMap<String, Object> studyPlanDetailMap = new HashMap<String, Object>();
                    studyPlanDetailMap.put("studyPlanId", studyPlanId);
                    studyPlanDetailMap.put("studyGradeTypeId", fee.getStudyGradeTypeId());
                    studyPlanDetailMap.put("subjectId", fee.getSubjectId());
                    List studyPlanDetails = studentManager.findStudyPlanDetailsByParams(studyPlanDetailMap); 
                    studyPlanDetailId = ((StudyPlanDetail) studyPlanDetails.get(0)).getId();
                    if (studyPlanDetailId != 0) {
                        studentBalance.setStudyPlanDetailId(studyPlanDetailId);
                        feeManager.addStudentBalance(studentBalance);
                    }
    
                }
            }
            
            // get the subjectBlockFees to add
            String[] subjectBlockFees = request.getParameterValues("possibleSubjectBlockFee");
            if (subjectBlockFees != null && subjectBlockFees.length != 0) {
                List subjectBlockFeeIdsToAdd = Arrays.asList(subjectBlockFees);

                for (int i = 0; i < subjectBlockFeeIdsToAdd.size(); i++) {
                    // add all selected fees to the student ( = create studentBalance for all selected fees)
                    int feeId = Integer.parseInt((String) subjectBlockFeeIdsToAdd.get(i));
                    Fee fee = feeManager.findFee(feeId);
                    StudentBalance studentBalance = new StudentBalance(studentId, feeId, "N", writeWho);
                    
                    // get studyPlanDetailId
                    HashMap<String, Object> studyPlanDetailMap = new HashMap<String, Object>();
                    studyPlanDetailMap.put("studyPlanId", studyPlanId);
                    studyPlanDetailMap.put("studyGradeTypeId", fee.getStudyGradeTypeId());
                    studyPlanDetailMap.put("subjectBlockId", fee.getSubjectBlockId());
                    List studyPlanDetails = studentManager.findStudyPlanDetailsByParams(studyPlanDetailMap); 
                    studyPlanDetailId = ((StudyPlanDetail) studyPlanDetails.get(0)).getId();
                    if (studyPlanDetailId != 0) {
                        studentBalance.setStudyPlanDetailId(studyPlanDetailId);
                        feeManager.addStudentBalance(studentBalance);
                    }
    
                }
            }

            // get the fees on area of education to add
            String[] educationAreaFees = request.getParameterValues("possibleEducationAreaFee");
            log.debug("JANO educationAreaFees.length = " + (educationAreaFees == null ? '0' : educationAreaFees.length));
            if (educationAreaFees != null && educationAreaFees.length != 0) {
            	
                List educationAreasFeeIdsToAdd = Arrays.asList(educationAreaFees);
                
                for (int i = 0; i < educationAreasFeeIdsToAdd.size(); i++) {
                	
                    // add all selected fees to the student ( = create studentBalance for all selected fees)
                    int feeId = Integer.parseInt((String) educationAreasFeeIdsToAdd.get(i));
                    
                    Fee fee = feeManager.findFee(feeId);
                    
                    /* check for which studyPlanCtu's it needs to be added */
                    /* if feeUnit = CTU and ctuNumber = Any, add for all ctu's of the academicYear */
                    if (fee.getFeeUnitCode().equals(FeeConstants.FEE_UNIT_CARDINALTIMEUNIT)) {

                        /* find all studyPlanCtu's of the student of that academicYear; the 
                    	   academicYear of the studyGradeType must be equal to the
                    	   academicYear of the fee */
                    	HashMap<String, Object> map = new HashMap<String, Object>();
                    	map.put("studyPlanId", studyPlanId);
                    	map.put("currentAcademicYearId", fee.getAcademicYearId());
                    	List <StudyPlanCardinalTimeUnit> studyPlanCtus = studentManager.findStudyPlanCardinalTimeUnitsByParams(map);
                    	
                    	for (StudyPlanCardinalTimeUnit studyPlanCtu : studyPlanCtus) {
                    		if (fee.getCardinalTimeUnitNumber() == 0 || (fee.getCardinalTimeUnitNumber() == studyPlanCtu.getCardinalTimeUnitNumber())) {
	                    		/* Assuming, that if one hasn't been added, none have been added */
	                    		StudentBalance studentBalance = new StudentBalance(studentId, feeId, "N", writeWho);
	                            studentBalance.setStudyPlanCardinalTimeUnitId(studyPlanCtu.getId());
	                            feeManager.addStudentBalance(studentBalance);
                    		}
                    	}
                    /* if feeUnit = studyGradeType, add for the first studyPlanCtu of the studyPlan
                     * but only if the academicYear of the fee is the same as the studyPlans has
                     * started. So, the year of the studyGradeType of the first studyPlanCtu must
                     * be the same as the year of the fee.  */   
                    } else if (fee.getFeeUnitCode().equals(FeeConstants.FEE_UNIT_STUDYGRADETYPE)) {

                    	StudyPlanCardinalTimeUnit studyPlanCtu = studentManager.findMinCardinalTimeUnitForStudyPlan(studyPlanId);
                    	StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanCtu.getStudyGradeTypeId());
                    	
                    	int academicYearStGrTp = studyGradeType.getCurrentAcademicYearId();

                    	if (academicYearStGrTp == fee.getAcademicYearId()) {
	                    	StudentBalance studentBalance = new StudentBalance(studentId, feeId, "N", writeWho);
	                    	studentBalance.setStudyPlanCardinalTimeUnitId(studyPlanCtu.getId());
	                        feeManager.addStudentBalance(studentBalance);
                    	}
                    }
                }
            }

            return "redirect:/fee/paymentsstudent.view?tab=" + navigationSettings.getTab()
            + "&panel=" + navigationSettings.getPanel()
            + "&studentId=" + studentId
            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        } else {
            // studyPlanId changed
            studentFeeForm.setStudyPlan(studyPlan);
            
            if (studyPlanId != 0) {
                studentFeeForm = findPossibleFees(studentId, studyPlanId, studentFeeForm, preferredLanguage);
            } else {
                studentFeeForm = findPossibleFees(0, 0, studentFeeForm, preferredLanguage);
            }
            return formView;
        }
    }
    
    // find possible fees to add
    private StudentFeeForm findPossibleFees(int studentId, int studyPlanId, StudentFeeForm studentFeeForm, String preferredLanguage) {
        
        List < Fee > possibleSubjectStudentFees = feeManager.findPossibleSubjectFeesForStudyPlan(studyPlanId);
        studentFeeForm.setPossibleSubjectStudentFees(possibleSubjectStudentFees);
        
        List < Fee > possibleSubjectBlockStudentFees = feeManager.findPossibleSubjectBlockFeesForStudyPlan(studyPlanId);
        studentFeeForm.setPossibleSubjectBlockStudentFees(possibleSubjectBlockStudentFees);
        
        List < Fee > possibleStudyGradeTypeStudentFees = feeManager.findPossibleStudyGradeTypeFeesForStudyPlan(studyPlanId);
        studentFeeForm.setPossibleStudyGradeTypeStudentFees(possibleStudyGradeTypeStudentFees);

        StudyPlanCardinalTimeUnit studyPlanCtu = studentManager.findMaxCardinalTimeUnitForStudyPlan(studyPlanId);
        int maxAcademicYearId = studyManager.findAcademicYearIdForStudyGradeTypeId(studyPlanCtu.getStudyGradeTypeId());
        String maxAcademicYear = academicYearManager.findAcademicYear(maxAcademicYearId).getDescription();
        
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("studyPlanId", studyPlanId);
        map.put("maxAcademicYear", maxAcademicYear );
        map.put("language", preferredLanguage );
        List < Fee > possibleEducationAreaFees = feeManager.findPossibleEducationAreaFees(map);
        studentFeeForm.setPossibleEducationAreaFees(possibleEducationAreaFees);
        return studentFeeForm;
    }
}
