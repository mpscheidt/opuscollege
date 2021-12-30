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

package org.uci.opus.ucm.web.flow;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
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
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManager;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.MarkValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.college.web.util.exam.SubjectResultLine;
import org.uci.opus.ucm.domain.StudentResult;
import org.uci.opus.ucm.service.UCMManagerInterface;
import org.uci.opus.ucm.util.CedStudentsResultsHandler;
import org.uci.opus.ucm.util.FiltersHelper;
import org.uci.opus.ucm.validator.ImportCedStudentsResultsFormValidator;
import org.uci.opus.ucm.web.form.ImportCedStudentsResultsForm;
import org.uci.opus.ucm.web.service.FileModelEnum;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/ucm/importcedstudentsresults.view")
@SessionAttributes({CedImportStudentsResultsController.FORM_NAME})
public class CedImportStudentsResultsController implements Comparator<StudentResult>{

    private final String viewName = "/ucm/ucm/exam/importCedStudentsResults";

    public static final String FORM_NAME = "resultsForm";
    private static Logger log = LoggerFactory.getLogger(CedImportStudentsResultsController.class);
    
    @Autowired private ExaminationManagerInterface examinationManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private AcademicYearManager academicYearManager;
    @Autowired private UCMManagerInterface ucmManager;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    private StudentFilterBuilder fb;
    /** 
     * Adds a property editor for dates to the binder.
     * 
     * @see org.springframework.web.servlet.mvc.BaseCommandController
     *      #initBinder(javax.servlet.http.HttpServletRequest
     *      , org.springframework.web.bind.ServletRequestDataBinder)
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) throws Exception {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
        binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
        binder.setValidator(new ImportCedStudentsResultsFormValidator());
    }
    

    @RequestMapping(method=RequestMethod.GET)
    public String setUp(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    	  HttpSession session = request.getSession(false);        
    	  
    	  securityChecker.checkSessionValid(session);
          session.setAttribute("menuChoice", "ucm");
          
          int subjectId = ServletUtil.getIntParamSetOnSession(session, request, "subjectId");
          int examinationId = ServletUtil.getIntParamSetOnSession(session, request, "examinationId");
          
          //if subjectId is set to 0 remove clean the form object
          opusMethods.removeSessionFormObject(FORM_NAME, session, model, subjectId == 0);
          
          ImportCedStudentsResultsForm resultsForm = (ImportCedStudentsResultsForm) model.get(FORM_NAME);
          if (resultsForm == null) {
              resultsForm = new ImportCedStudentsResultsForm();
              resultsForm.setFileModel(FileModelEnum.CED_PAUTA);
              model.put(FORM_NAME, resultsForm);
              
          }
          
          String resultType = ServletUtil.getParamSetAttrAsString(request, "resultType",resultsForm.getResultType());
          resultsForm.setResultType(resultType);
          
          resultsForm.setFormStatus("SetUp");
          updateSelects(request, response);
          
          
         if(subjectId != 0){
        	 loadSubjectDetails(request, subjectId, model, resultsForm);
         }
         
         //
         if(examinationId == 0){
        	 
        	 resultsForm.setSubjectExamination(null);
        	 
        //negative values are reserved to resit and final marks which are not actual exams
        //TODO find better way to do it
         } else{
        	 
        	 if(examinationId < 0){
            	 
        		 resultsForm.setSubjectExamination(resultsForm.getDefaultExamination(examinationId));
        		 
        	 } else {
        	
        		 resultsForm.setSubjectExamination(examinationManager.findExamination(examinationId)); 
        	 }
        	 
        	Map<String, Object> findStudentsMap = new HashMap<String, Object>();
        	findStudentsMap.put("subjectId", subjectId);
        	findStudentsMap.put("cardinalTimeUnitNumber", fb.getCardinalTimeUnitNumber());
        	//only list students if there is a examination set
        	resultsForm.setStudentsList(ucmManager.findStudentsResults(findStudentsMap));
        	resultsForm.setFormStatus("FiltersFilled");
         }
         
    	return viewName;
    }
    
    protected void loadSubjectDetails(HttpServletRequest request, int subjectId, ModelMap model, ImportCedStudentsResultsForm resultsForm){

    	Subject subject = null; //the subject which the results belong to
    	Study study = null; //the study the subject belongs to
    	 String brsPassing = "";
    	
    	 String preferredLanguage = OpusMethods.getPreferredLanguage(request);
         Locale currentLoc = RequestContextUtils.getLocale(request);
        int studyId = ServletUtil.getIntParam(request, "studyId", 0);

        OpusUser opusUser = opusMethods.getOpusUser();
        if (personManager.isStaffMember(opusUser.getPersonId())) {
            StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(opusUser.getPersonId());
            resultsForm.setStaffMember(staffMember);
        }

        // SUBJECT
        subject = subjectManager.findSubject(subjectId);
        resultsForm.setSubject(subject);

        List<StaffMember> teachers = null;
        List<Integer> staffMemberIds = DomainUtil.getIntProperties(subject.getSubjectTeachers(), "staffMemberId");
        if (!staffMemberIds.isEmpty()) {
            Map<String, Object> staffMemberMap = new HashMap<String, Object>();
            staffMemberMap.put("staffMemberIds", staffMemberIds);
            teachers = staffMemberManager.findStaffMembers(staffMemberMap);
        }
        resultsForm.setTeachers(teachers);
        resultsForm.setIdToSubjectTeacherMap(new IdToStaffMemberMap(teachers));

        // STUDY:
        if (studyId == 0) {
            studyId = subjectManager.findSubjectPrimaryStudyId(subjectId);
        }
        study = studyManager.findStudy(studyId);

        // BRS passing:
        brsPassing = opusMethods.getBrsPassingSubject(subject, study, currentLoc);
        resultsForm.setBrsPassing(brsPassing);

        // MINIMUM and MAXIMUM GRADE:
        // see if the endGrades are defined on studygradetype level:
        String endGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
        boolean endGradesPerGradeType = endGradeType != null && !endGradeType.isEmpty();
        resultsForm.setEndGradesPerGradeType(endGradesPerGradeType);

        if (!endGradesPerGradeType) {
            // mozambican situation
            //                    resultsForm.setMinimumGrade(study.getMinimumMarkSubject());
            //                    resultsForm.setMaximumGrade(study.getMaximumMarkSubject());
            resultsForm.setMinimumMarkValue(study.getMinimumMarkSubject());
            resultsForm.setMaximumMarkValue(study.getMaximumMarkSubject());
        } else {
            // zambian situation
            //    	            request.setAttribute("minimumMarkValue","0");
            //                	request.setAttribute("maximumMarkValue","100");
            resultsForm.setMinimumMarkValue("0");
            resultsForm.setMaximumMarkValue("100");
        }

    }
    

//    @Transactional
   // @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) ImportCedStudentsResultsForm resultsForm,
            BindingResult result, ModelMap model)
            throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.processSubmit started...");
        }
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        Subject subject = resultsForm.getSubject();

        if (resultsForm.getAllLines() == null) {
            return viewName;
        }


        MarkValidator markValidator = new MarkValidator(resultsForm.getMinimumMarkValue(), resultsForm.getMaximumMarkValue());
//        List<SubjectResult> subjectResults = new ArrayList<SubjectResult>();
        List<SubjectResultLine> subjectResultLines = new ArrayList<SubjectResultLine>();

        for (int i = 0; i < resultsForm.getAllLines().size() ; i++) {
            SubjectResultLine subjectResultLine = (SubjectResultLine) resultsForm.getAllLines().get(i);
            SubjectResult subjectResult = subjectResultLine.getSubjectResult();
            int subjectResultId = subjectResult.getId();

            String mark = subjectResult.getMark();

            // This line can be ignored if no data was entered: ie. new result && no mark entered
            // - ignore teacher because when only one teacher then always automatically selected 
            boolean ignore = subjectResultId == 0 && StringUtil.isNullOrEmpty(mark, true);
            if (ignore) {
                continue;       // ignore this line and go to next line
            }

            // -- Validation --

//            boolean lineHasErrors = false;
            result.pushNestedPath("allLines[" + i + "].subjectResult");

            // Validate: Mark correct?
//            BigDecimal markDecimal = null;
//            switch (StringUtil.checkValidDouble(mark)) {
//            case -1:
//                result.rejectValue("subjectResult.mark", "invalid.invalid");
//                lineHasErrors = true;
//                break;
//            case 1:
//                markDecimal = new BigDecimal(mark);
//                break;
//            }
//
//            // Validate: If this line hasn't been ignored (see above), then both mark and teacher have to be filled
//            if (markDecimal == null) {
//                result.rejectValue("subjectResult.mark", "invalid.empty.format");
//                lineHasErrors = true;
            
            markValidator.validate(mark, result);
//            if (result.hasFieldErrors("mark")) {
//                lineHasErrors = true;
//            }

            if (subjectResult.getStaffMemberId() == 0) {
                result.rejectValue("staffMemberId", "jsp.error.no.chosen.staffmember");
//                lineHasErrors = true;
            }

            result.popNestedPath(); // end of validation of this line

            subjectResultLines.add(subjectResultLine);  // store the ones that haven't been ingored
        }


        if (result.hasErrors()) {
            return viewName;
        }

        // store to DB
        for (SubjectResultLine subjectResultLIne : subjectResultLines) {
            SubjectResult subjectResultInDB = resultManager.findSubjectResult(subjectResultLIne.getSubjectResult().getId());    // TODO this should be in the resultLine to be shown in screen
            resultManager.saveSubjectResultIfModified(request, subjectResultLIne.getSubjectResult(), subjectResultInDB, subject.getCurrentAcademicYearId(), null);
        }
        
        sessionStatus.setComplete();

        NavigationSettings navigationSettings = resultsForm.getNavigationSettings();
        return "redirect:/college/subjectresults.view?newForm=true"
                    + "&subjectId=" + subject.getId()
//                    + "&showSubjectResultsError="+ showSubjectResultsError
//                    + "&studyGradeTypeId=" + studyGradeTypeId
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                    + "&tab=" + navigationSettings.getTab() 
                    + "&panel=" + navigationSettings.getPanel();
    }


    /**
     * Try to generate a result for all lines that have no result yet and where lower level results exist.
     * @param resultsForm
     * @param result
     * @param request
     * @param model
     * @return
     */
   // @RequestMapping(method=RequestMethod.POST, params = "generateAll")
    public String generateAllSubjectResults(ImportCedStudentsResultsForm resultsForm, BindingResult result, HttpServletRequest request, ModelMap model) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        Subject subject = resultsForm.getSubject();

        for (int i = 0; i < resultsForm.getAllLines().size() ; i++) {
            SubjectResultLine subjectResultLine = (SubjectResultLine) resultsForm.getAllLines().get(i);
            SubjectResult subjectResult = subjectResultLine.getSubjectResult();
//            int studyPlanDetailId = subjectResult.getStudyPlanDetailId();
            if (subjectResult.getId() == 0 && subjectResultLine.getExaminationResultsFound()) {
                result.pushNestedPath("allLines[" + i + "].subjectResult");
                resultManager.generateSubjectResultMark(subjectResult, preferredLanguage, result);
                result.popNestedPath();
                
//                if (!result.hasFieldErrors("allLines[" + i + "].subjectResult.mark")) {
//                    subjectResult.setMark(mark);
//                }
            }
        }

        return viewName;
    }


    /**
     * Fills select filters according to changes
     * @param request
     * @param response
     * @throws Exception
     */
    protected void updateSelects(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

    	FiltersHelper filtersHelper = new FiltersHelper(academicYearManager, subjectManager, studyManager);
        HttpSession session = request.getSession(false);        

        fb = new StudentFilterBuilder(request,
                opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        Map<String, Object> additionalFindParams = new HashMap<>();
        //      additionalFindParams.put("existStudents", Boolean.TRUE);
        Map<String, Object> parameterMap = filtersHelper.loadAndMakeParameterMap(fb, request, session, additionalFindParams);

        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");
        parameterMap.put("searchValue" , searchValue);
        
        
        //only load subjects if all other filters are filled 
        //this avoids long loading times as there are normally hundreds of subjects
        
        if((fb.getAcademicYearId() != 0) &&
        	(fb.getInstitutionId() != 0) &&
        	(fb.getBranchId() != 0) &&
        	(fb.getOrganizationalUnitId() != 0) &&
        	(fb.getPrimaryStudyId() != 0) &&
        	(fb.getStudyGradeTypeId() != 0)
        		){
        	request.setAttribute("allSubjects", subjectManager.findSubjects(parameterMap));
        }        
        
    }

    protected void readResults(ImportCedStudentsResultsForm resultsForm, ModelMap model, HttpServletRequest request) throws IOException{
    
    	Locale currentLoc = RequestContextUtils.getLocale(request);
    	
    	CedStudentsResultsHandler resultsHandler = new CedStudentsResultsHandler();
    	
    	List<StudentResult> results = new ArrayList<StudentResult>();
    	
    	int subjectId = ServletUtil.getIntParam(request, "subjectId", 0);
    	
    	InputStream inp = new ByteArrayInputStream(resultsForm.getStudentsResultsFile());
    	resultsHandler.readResultsFromStream(inp);
    	
    	//get valid entries from file. Those entries which code and result are valid
    	Map<String, String> validEntries = resultsHandler.getValidEntries();
    	
    	if(validEntries.size() > 0){
    		
    		for (Iterator<Map.Entry<String, String>> it = validEntries.entrySet().iterator(); it.hasNext();) {
    			Map.Entry<String,String> entry = it.next();
    			 
    			Map<String , Object> validateParams = new HashMap<String, Object>();
    			validateParams.put("studentCode", entry.getKey());
    			validateParams.put("subjectId", subjectId);
    			validateParams.put("cardinalTimeUnitNumber"
    					, ServletUtil.getIntValueSetOnSession(request.getSession(), request
    					,"cardinalTimeUnitNumber" ,0));
    			
    			StudentResult studentResult = ucmManager.findStudentResult(validateParams);
    		//	StudentResult student = ucmManager.findStudentWithCode(entry.getKey());
    			
    			//if student with code exists set student result
    			if(studentResult != null) {
    				
    				studentResult.setSubjectId(subjectId);
    				studentResult.setActive("Y");
    				studentResult.setMark(entry.getValue());
    				studentResult.setResult(new BigDecimal(entry.getValue()));
    				studentResult.setSubjectResultDate(new java.util.Date());
    				studentResult.setStaffMemberId(resultsForm.getTeacherId());
    				
    				
    				if(studentResult.getResult().floatValue() >= 10)
    					studentResult.setPassed("Y");
    				else
    					studentResult.setPassed("N");
    				
    				results.add(studentResult);
    			} else if(studentResult == null){
    				resultsHandler.addInvalidEntry(
    						 messageSource.getMessage("jsp.error.nostudentforcode", new Object[]{entry.getKey()}, currentLoc));
    			} /*else if(!(boolean)validatedStudent.get("isValid")){
    				resultsHandler.addInvalidEntry(
   						 messageSource.getMessage("jsp.error.subjectnotinstudyplan", new Object[]{entry.getKey()}, currentLoc));
    			}*/
			}
    	}
    	
    	CedImportStudentsResultsController comparator = new CedImportStudentsResultsController();
    	Collections.sort(results, comparator);
    	//Collections.sort(results, Collator.getInstance());
    	resultsForm.setStudentsResults(results);
    	
    	if(resultsHandler.getErrors().size() > 0)
    	model.addAttribute("resultsErrors", resultsHandler.getErrors());
    	
    	if(resultsHandler.getWarnings().size() > 0)
    	model.addAttribute("resultsWarnings", resultsHandler.getWarnings());
    	
    	if(resultsHandler.getInfo().size() > 0)
    	model.addAttribute("resultsInfo", resultsHandler.getInfo());
    	
    	if(resultsHandler.getInvalidEntries().size() > 0)
    	model.addAttribute("invalidEntries", resultsHandler.getInvalidEntries());
    	
    	if(resultsHandler.getDuplicatedEntries().size() > 0)
    	model.addAttribute("duplicatedEntries", resultsHandler.getDuplicatedEntries());
    	
    }
    
    @RequestMapping(method=RequestMethod.POST, params = "task=processResults")
    public String processResults(
           @ModelAttribute(FORM_NAME) ImportCedStudentsResultsForm resultsForm,
            BindingResult result,
            SessionStatus sessionStatus,
            HttpServletRequest request,
            HttpServletResponse response,
            ModelMap model
    		)
            throws Exception {

    	
        if (log.isDebugEnabled()) {
            log.debug("SubjectResultsEditController.processResults started...");
        }
        
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        updateSelects(request, response);

        new ImportCedStudentsResultsFormValidator().validate(resultsForm, result);
        
        if (result.hasErrors()) {
        	return viewName;
        } 

        readResults(resultsForm, model, request);
        
        resultsForm.setFormStatus("ResultsProcessed");
        model.addAttribute(FORM_NAME, resultsForm);
        
        
        return viewName;
    }
    
    @RequestMapping(method=RequestMethod.POST, params = "task=submitValidEntries")
    public String SubmitValidEntries(
           @ModelAttribute(FORM_NAME) ImportCedStudentsResultsForm resultsForm,
            SessionStatus sessionStatus,
            HttpServletRequest request,
            HttpServletResponse response,
            ModelMap model
    		)
            throws Exception {
    	
        if (log.isDebugEnabled()) {
            log.debug("UcmCedResultsImportController. Submitting valid entries");
        }
        
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        for(StudentResult result : resultsForm.getStudentsResults()){

        	if(result.getId() == 0){
        	
        		resultManager.addSubjectResult(result, request);
        		
        	} else if(result.getId() > 0) {
        		
        		resultManager.updateSubjectResult(result, request);
        	}
        	
        }
       

        resultsForm.setFormStatus("Success");
        
        model.put(FORM_NAME, resultsForm);
        
        return viewName;
    }


	@Override
	public int compare(StudentResult arg0, StudentResult arg1) {
		// TODO Auto-generated method stub
		return arg0.getStudentName().compareTo(arg1.getStudentName());
	}
}
