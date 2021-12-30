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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyPlanDetailForm;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSelection;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: StudyPlanDetailEditController.
 *
 */
@Controller
@RequestMapping("/college/studyplandetail.view")
@SessionAttributes({StudyPlanDetailEditController.STUDY_PLAN_DETAIL_FORM})
public class StudyPlanDetailEditController {

    public static final String STUDY_PLAN_DETAIL_FORM = "studyPlanDetailForm";

    private static Logger log = LoggerFactory.getLogger(StudyPlanDetailEditController.class);

    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

	public StudyPlanDetailEditController() {
		super();
		this.formView = "college/person/studyPlanDetail";
	}

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException 
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, @RequestParam("studyPlanCardinalTimeUnitId") int studyPlanCardinalTimeUnitId) 
    {
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject(STUDY_PLAN_DETAIL_FORM, session, model, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* STUDYPLANDETAIL FORM - 
         * 	fetch or create the form object and fill it with studyplandetail */
        StudyPlanDetailForm studyPlanDetailForm = (StudyPlanDetailForm) model.get(STUDY_PLAN_DETAIL_FORM);
        if (studyPlanDetailForm == null) {
        	studyPlanDetailForm = new StudyPlanDetailForm();
            model.addAttribute(STUDY_PLAN_DETAIL_FORM, studyPlanDetailForm);

            StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());

            int studyPlanId = studyPlanCardinalTimeUnit.getStudyPlanId();
            StudyPlan studyPlan = studentManager.findStudyPlan(studyPlanId);
            Student student = studentManager.findStudent(preferredLanguage, studyPlan.getStudentId());

            // init studyPlanForm
            studyPlanDetailForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            studyPlanDetailForm.setStudyPlan(studyPlan);
            studyPlanDetailForm.setStudent(student);
            studyPlanDetailForm.setStudyGradeType(studyGradeType);

            // set the default sgtId/ctuNr to the same as studyplanCTU
            studyPlanDetailForm.setChosenStudyGradeTypeId(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
            studyPlanDetailForm.setChosenCardinalTimeUnitNumber(studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
            
            
            // find organization id's matching with the study
            Study study = studyManager.findStudy(studyPlan.getStudyId());
            int organizationalUnitId = study.getOrganizationalUnitId();
            int branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            int institutionId = institutionManager.findInstitutionOfBranch(branchId);
            
            // get the organization values from study:
            Organization organization = new Organization();
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
            studyPlanDetailForm.setOrganization(organization);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            studyPlanDetailForm.setNavigationSettings(navigationSettings);

            // utility maps
            studyPlanDetailForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
            studyPlanDetailForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
            studyPlanDetailForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));

            // ACADEMIC YEARS
            Map<String, Object> academicYearMap = new HashMap<>();
            List<AcademicYear> allAcademicYears = studyManager.findAllAcademicYears(academicYearMap);
            studyPlanDetailForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

            loadStudiesAndStudyGradeTypes(request, studyPlanDetailForm);

            loadCardinalTimeUnitStudyGradeTypes(studyPlanDetailForm);
            loadSubjectsAndBlocks(studyPlanDetailForm, request);

        }
        
        return formView;
    }

    public void loadStudiesAndStudyGradeTypes(HttpServletRequest request, StudyPlanDetailForm studyPlanDetailForm) {

        // If no organization is given, then avoid any loading because this could be expensive
        Organization organization = studyPlanDetailForm.getOrganization();
        if (organization.getOrganizationalUnitId() == 0) {
            studyPlanDetailForm.getIdToStudyMap().clear();
            studyPlanDetailForm.getAllStudyGradeTypes().clear();
            return;
        }

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // STUDIES
        Map<String, Object> findMap = opusMethods.fillOrganizationMapForReadAuthorization(request, organization);
        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findMap.put("preferredLanguage", preferredLanguage);
        studyPlanDetailForm.setIdToStudyMap(new IdToStudyMap(studyManager.findStudies(findMap)));

        // STUDYGRADETYPES
        findMap.put("studyId", 0);
        StudyGradeType studyGradeType = studyPlanDetailForm.getStudyGradeType();
        findMap.put("currentAcademicYearId", studyGradeType.getCurrentAcademicYearId());
        studyPlanDetailForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findMap));
    }

	/**
	* @param studyForm
	* @param result
	* @param status
	* @param request
	* @return
	*/
    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=true")
    @PreAuthorize("hasAnyRole('CREATE_STUDYPLANDETAILS', 'CREATE_STUDYPLANDETAILS_PENDING_APPROVAL')")
	public String processSubmit(@ModelAttribute(STUDY_PLAN_DETAIL_FORM) StudyPlanDetailForm studyPlanDetailForm,
	   		BindingResult result, SessionStatus status, HttpServletRequest request) {

        int chosenStudyGradeTypeId = studyPlanDetailForm.getChosenStudyGradeTypeId();
        if (chosenStudyGradeTypeId == 0) {
            result.rejectValue("chosenStudyGradeTypeId", "invalid.empty.format");
        }
        int chosenCardinalTimeUnitNumber = studyPlanDetailForm.getChosenCardinalTimeUnitNumber();
        if (chosenCardinalTimeUnitNumber == 0) {
            result.rejectValue("chosenCardinalTimeUnitNumber", "invalid.empty.format");
        }
        
        if (result.hasErrors()) {
            return formView;
        }

        
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studyPlanDetailForm.getStudyPlanCardinalTimeUnit();
        int studyPlanCardinalTimeUnitId = studyPlanCardinalTimeUnit.getId();

        List<SubjectBlock> existingSubjectBlocksInSPD = studentManager.findSubjectBlocksForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
        List<Integer> existingSubjectBlockInSPDIds = DomainUtil.getIds(existingSubjectBlocksInSPD);
        List<Subject> existingSubjectsInSPD = studentManager.findSubjectsForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
        List<Integer> existingSubjectInSPDIds = DomainUtil.getIds(existingSubjectsInSPD);

        // Count total number of subjects (without exempted)
        List<StudyPlanDetail> allStudyPlanDetailsForCardinalTimeUnit = studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
        allStudyPlanDetailsForCardinalTimeUnit = studentManager.extractNonExempted(allStudyPlanDetailsForCardinalTimeUnit);
        int totalNumberOfSubjects = studyManager.countSubjectsInStudyPlanDetails(allStudyPlanDetailsForCardinalTimeUnit);

        // for every newly selected subject and block, validate and add to list of new studyPlanDetails
        List<Integer> subjectBlockIdsToAdd = new ArrayList<>();
        if (studyPlanDetailForm.getSubjectBlockIds() != null) {
            for (int subjectBlockId : studyPlanDetailForm.getSubjectBlockIds()) {
                if (!existingSubjectBlockInSPDIds.contains(subjectBlockId)) {
                    SubjectBlock subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockId);
                    validateSubjectBlockPrerequisistes(subjectBlockId, studyPlanDetailForm, result);
                    // Note: validation deactivated because it would prevent from adding a subject even if it was failed
                    // See comment in the method's Javadoc
                    // validateExistingSubjectOrBlock(null, subjectBlock.getSubjectBlockCode(), studyPlanCardinalTimeUnit.getStudyPlanId(), result);
                    subjectBlockIdsToAdd.add(subjectBlockId);
                    totalNumberOfSubjects += subjectBlock.getSubjectSubjectBlocks().size();
                }
            }
        }

        List<Integer> subjectIdsToAdd = new ArrayList<>();
        if (studyPlanDetailForm.getSubjectIds() != null) {
            for (int subjectId : studyPlanDetailForm.getSubjectIds()) {
                if (!existingSubjectInSPDIds.contains(subjectId)) {
                    validateSubjectPrerequisistes(subjectId, studyPlanDetailForm, result);
                    // Note: validation deactivated because it would prevent from adding a subject even if it was failed
                    // See comment in the method's Javadoc
                    // validateExistingSubjectOrBlock(subject.getSubjectCode(), null, studyPlanCardinalTimeUnit.getStudyPlanId(), result);
                    subjectIdsToAdd.add(subjectId);
                    totalNumberOfSubjects++;
                }
            }
        }
        
        // check total number of subjects
        int maxSubjects = studyManager.getMaximumNumberOfSubjectsPerCardinalTimeUnit(studyPlanDetailForm.getStudyGradeType());
        if (totalNumberOfSubjects > maxSubjects) {
            result.reject("jsp.error.maxnumber.subjects.exceeded");
        }

        // possible reasons for validation errors: subject already in studyPlan, total number of subjects too high
        if (result.hasErrors()) {
            return formView;
        }

        List<StudyPlanDetail> studyPlanDetailsToAdd = new ArrayList<>();
        for (int subjectBlockId : subjectBlockIdsToAdd) {
            StudyPlanDetail studyPlanDetail = new StudyPlanDetail(0, subjectBlockId, chosenStudyGradeTypeId, studyPlanCardinalTimeUnit.getId(),
                    studyPlanCardinalTimeUnit.getStudyPlanId());
            studyPlanDetail.setExempted(studyPlanDetailForm.isExempted());
            studyPlanDetailsToAdd.add(studyPlanDetail);
        }
        
        for (int subjectId : subjectIdsToAdd) {
            StudyPlanDetail studyPlanDetail = new StudyPlanDetail(subjectId, 0, chosenStudyGradeTypeId, studyPlanCardinalTimeUnit.getId(),
                    studyPlanCardinalTimeUnit.getStudyPlanId());
            studyPlanDetail.setExempted(studyPlanDetailForm.isExempted());
            studyPlanDetailsToAdd.add(studyPlanDetail);
        }

        studentManager.addStudyPlanDetails(studyPlanDetailsToAdd, request);

        NavigationSettings navigationSettings = studyPlanDetailForm.getNavigationSettings();
        return "redirect:/college/studyplancardinaltimeunit.view?newForm=true&tab=" + navigationSettings.getTab() 
              + "&panel=" + navigationSettings.getPanel()
              + "&studyPlanId=" + studyPlanCardinalTimeUnit.getStudyPlanId()
              + "&studyPlanCardinalTimeUnitId=" + studyPlanCardinalTimeUnit.getId()
              + "&cardinalTimeUnitNumber=" + studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber()
              + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();


    }

    /**
     * Check if given subject already is in the study plan.
     * This could happen when
     * (a) subject is part of subject block and subject block is already in study plan,
     * (b) subject exists in a different studyPlanCardinalTimeUnit.
     * 
     * TODO: This check needs to be used to question the user if he indeed
     * wants to add the subject again, or more specifically:
     * - ask if the subject has not been failed
     * - simply add the subject again if it has been failed (in previous time units)
     * 
     * @param subjectCode
     * @param subjectBlockCode
     * @param studyPlanId
     * @param errors
     */
    private void validateExistingSubjectOrBlock(String subjectCode, String subjectBlockCode, int studyPlanId, Errors errors) {
        Map<String, Object> studyPlanDetailMap = new HashMap<>();
        studyPlanDetailMap.put("studyPlanId", studyPlanId);
        studyPlanDetailMap.put("subjectBlockCode", subjectBlockCode);
        studyPlanDetailMap.put("subjectCode", subjectCode);
        List<StudyPlanDetail> existingStudyPlanDetails = studentManager.findStudyPlanDetailsByParams(studyPlanDetailMap);

        if (existingStudyPlanDetails != null && existingStudyPlanDetails.size() != 0) {
            errors.reject("jsp.error.general.parts.alreadyexist.studyplan");
        }
    }
    
    private void validateSubjectPrerequisistes(int subjectId, StudyPlanDetailForm studyPlanDetailForm, Errors errors) {
        // determine subjectStudyGradeTypeId if it exists
        Map<String, Object> map = new HashMap<>();
        map.put("studyGradeTypeId", studyPlanDetailForm.getChosenStudyGradeTypeId());
        map.put("subjectId", subjectId);
        int subjectStudyGradeTypeId = subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map);

        // prerequisites can only exist when the subject is linked to a studyGradeType
        if (subjectStudyGradeTypeId != 0) {
            // get codes of prerequisite subjects
            List<String> prerequisiteSubjectCodes = subjectManager.findPrerequisiteSubjectCodes(subjectStudyGradeTypeId);
            // get codes of subjects in the studyPlan
            List<Subject> subjectsInStudyPlan = subjectManager.findSubjectsForStudyPlan(studyPlanDetailForm.getStudyPlan().getId());
            List<String> subjectCodesInStudyPlan = DomainUtil.getStringProperties(subjectsInStudyPlan, "subjectCode");
            // new ArrayList<String>();
//            for (Subject subject : subjectsInStudyPlan) {
//                subjectCodesInStudyPlan.add(subject.getSubjectCode());
//            }
            // check for each subject if it is in (one of) the studyPlan(s) of the student
            // directly or in a subjectBlock
            for (int i = 0; i < prerequisiteSubjectCodes.size(); i++) {
                boolean prerequisiteOK = false;
                // subject(Codes) that are part of the studyPlan
                for (int j = 0; j < subjectCodesInStudyPlan.size(); j++) {
                    if (prerequisiteSubjectCodes.get(i).equals(subjectCodesInStudyPlan.get(j))) {
                        prerequisiteOK = true;
                    }
                }
                if (!prerequisiteOK){
                    errors.reject("jsp.msg.subjectprerequisites.not.met");
                }
            }
        }
    }

    private void validateSubjectBlockPrerequisistes(int subjectBlockId, StudyPlanDetailForm studyPlanDetailForm, Errors errors) {

        int subjectBlockStudyGradeTypeId = subjectBlockMapper.findSubjectBlockStudyGradeTypeIdBySubjectBlockAndStudyGradeType(
                subjectBlockId, studyPlanDetailForm.getChosenStudyGradeTypeId());

        // prerequisites can only exist when the subjectBlock is linked to a studyGradeType
        if (subjectBlockStudyGradeTypeId != 0) {
            // get codes of the prerequisite subjectBlocks
            List<String> prerequisiteSubjectBlockCodes = subjectBlockMapper.findPrerequisiteSubjectBlockCodes(subjectBlockStudyGradeTypeId);
            // get id's of subjectBlocks in the studyPlan
            List<SubjectBlock> subjectBlocksInStudyPlan = studentManager.findSubjectBlocksForStudyPlan(studyPlanDetailForm.getStudyPlan().getId());

            // check for each subjectBlock if it is in (one of ) the studyPlan(s) of the student
            for (int i = 0; i < prerequisiteSubjectBlockCodes.size(); i++) {
                boolean prerequisiteOK = false;
                // subject(Ids) that are part of the studyPlan
                for (int j = 0; j < subjectBlocksInStudyPlan.size(); j++) {
                    String tmpSubjectBlockCodeInStudyPlan = ((SubjectBlock) subjectBlocksInStudyPlan.get(j)).getSubjectBlockCode();
                    if (prerequisiteSubjectBlockCodes.get(i).equals(tmpSubjectBlockCodeInStudyPlan)) {
                        prerequisiteOK = true;
                    }
                }
                if (!prerequisiteOK) {
                    errors.reject("jsp.msg.subjectblockprerequisites.not.met");
                }
            }

        }
    }

    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=institutionId")
    public String processInstitutionCombo(
            @ModelAttribute(STUDY_PLAN_DETAIL_FORM) 
            StudyPlanDetailForm studyPlanDetailForm,
           BindingResult result, HttpServletRequest request, ModelMap model) throws ServletRequestBindingException { 

        Organization organization = studyPlanDetailForm.getOrganization();
        organization.setBranchId(0);
        organization.setOrganizationalUnitId(0);
        studyPlanDetailForm.setChosenStudyGradeTypeId(0);
        studyPlanDetailForm.setChosenCardinalTimeUnitNumber(0);

        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
        studyPlanDetailForm.getAllStudyGradeTypes().clear();
        studyPlanDetailForm.getAllCardinalTimeUnitStudyGradeTypes().clear();
        loadSubjectsAndBlocks(studyPlanDetailForm, request);    // with ctunr = 0, this will just reset subjects and blocks to empty

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=branchId")
    public String processBranchCombo(
            @ModelAttribute(STUDY_PLAN_DETAIL_FORM) 
            StudyPlanDetailForm studyPlanDetailForm,
           BindingResult result, HttpServletRequest request, ModelMap model) throws ServletRequestBindingException { 

        Organization organization = studyPlanDetailForm.getOrganization();
        organization.setOrganizationalUnitId(0);
        studyPlanDetailForm.setChosenStudyGradeTypeId(0);
        studyPlanDetailForm.setChosenCardinalTimeUnitNumber(0);

        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
        studyPlanDetailForm.getAllStudyGradeTypes().clear();
        studyPlanDetailForm.getAllCardinalTimeUnitStudyGradeTypes().clear();
        loadSubjectsAndBlocks(studyPlanDetailForm, request);    // with ctunr = 0, this will just reset subjects and blocks to empty

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=organizationalUnitId")
    public String processOrganizationalUnitCombo(
            @ModelAttribute(STUDY_PLAN_DETAIL_FORM) 
            StudyPlanDetailForm studyPlanDetailForm,
           BindingResult result, HttpServletRequest request, ModelMap model) throws ServletRequestBindingException { 

        studyPlanDetailForm.setChosenStudyGradeTypeId(0);
        studyPlanDetailForm.setChosenCardinalTimeUnitNumber(0);

        loadStudiesAndStudyGradeTypes(request, studyPlanDetailForm);
        studyPlanDetailForm.getAllCardinalTimeUnitStudyGradeTypes().clear();
        loadSubjectsAndBlocks(studyPlanDetailForm, request);    // with ctunr = 0, this will just reset subjects and blocks to empty

        return formView;
    }

    // chosenStudyGradeTypeId combo box changed
    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=chosenStudyGradeTypeId")
    public String processChosenStudyGradeTypeCombo(
            @ModelAttribute(STUDY_PLAN_DETAIL_FORM) 
            StudyPlanDetailForm studyPlanDetailForm,
           BindingResult result, HttpServletRequest request, ModelMap model) throws ServletRequestBindingException { 

        loadCardinalTimeUnitStudyGradeTypes(studyPlanDetailForm);
        studyPlanDetailForm.setChosenCardinalTimeUnitNumber(0);
        loadSubjectsAndBlocks(studyPlanDetailForm, request);    // with ctunr = 0, this will just reset subjects and blocks to empty

        return formView;
    }

    // chosenCardinalTimeUnitNumber combo box changed
    @RequestMapping(method = RequestMethod.POST, params = "submitFormObject=chosenCardinalTimeUnitNumber")
    public String processChosenCardinalTimeUnitNumber(
            @ModelAttribute(STUDY_PLAN_DETAIL_FORM) StudyPlanDetailForm studyPlanDetailForm,
            BindingResult result, SessionStatus status,
            HttpServletRequest request) {

        loadSubjectsAndBlocks(studyPlanDetailForm, request);

        return formView;
    }

    /**
     * Loads the cardinalTimeUnitStudyGradeTypes in order to fill the ctu combo.
     * 
     * @param studyPlanDetailForm
     */
    private void loadCardinalTimeUnitStudyGradeTypes(StudyPlanDetailForm studyPlanDetailForm) {
        
        List<CardinalTimeUnitStudyGradeType> ctuSgts = null;
        int chosenStudyGradeTypeId = studyPlanDetailForm.getChosenStudyGradeTypeId();
        if (chosenStudyGradeTypeId != 0) {
            ctuSgts = studyManager.findCardinalTimeUnitStudyGradeTypes(chosenStudyGradeTypeId);
        }
        studyPlanDetailForm.setAllCardinalTimeUnitStudyGradeTypes(ctuSgts);
    }

    private void loadSubjectsAndBlocks(StudyPlanDetailForm studyPlanDetailForm, HttpServletRequest request) {
        
        int studyGradeTypeId = studyPlanDetailForm.getChosenStudyGradeTypeId();
        int cardinalTimeUnitNumber = studyPlanDetailForm.getChosenCardinalTimeUnitNumber();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        SubjectAndBlockSelection sabc = subjectManager.getSubjectAndBlockSelection(studyGradeTypeId, cardinalTimeUnitNumber, preferredLanguage);
        studyPlanDetailForm.setSubjectAndBlockSelection(sabc);
        
        // Preselect (and for now also disable) the existing subjects and subject blocks of the studyPlanCTU
        StudyPlanCardinalTimeUnit spctu = studyPlanDetailForm.getStudyPlanCardinalTimeUnit();
        List<SubjectBlock> subjectBlocksInSPD = studentManager.findSubjectBlocksForStudyPlanCardinalTimeUnit(spctu.getId());
        List<Integer> subjectBlockInSPDIds = DomainUtil.getIds(subjectBlocksInSPD);
        studyPlanDetailForm.setSubjectBlockIds(subjectBlockInSPDIds);

        List<Subject> subjectsInSPD = studentManager.findSubjectsForStudyPlanCardinalTimeUnit(spctu.getId());
        List<Integer> subjectInSPDIds = DomainUtil.getIds(subjectsInSPD);
        studyPlanDetailForm.setSubjectIds(subjectInSPDIds);
        
        // fow now disable all subjects and blocks, because for de-selection of studyPlanDetails to work we need to implement the proper validation and delete logic
        Map<Integer, Boolean> disabledSubjectBlocks = new HashMap<>();
        for (int id : subjectBlockInSPDIds) {
            disabledSubjectBlocks.put(id, Boolean.TRUE);
        }
        sabc.setDisabledSubjectBlocks(disabledSubjectBlocks);
        
        Map<Integer, Boolean> disabledSubjects = new HashMap<>();
        for (int id : subjectInSPDIds) {
            disabledSubjects.put(id, Boolean.TRUE);
        }
        sabc.setDisabledSubjects(disabledSubjects);
    }

}
