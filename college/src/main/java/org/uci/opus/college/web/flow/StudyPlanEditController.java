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
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Referee;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.domain.util.IdToSubjectBlockMap;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.validator.StudyPlanDetailDeleteValidator;
import org.uci.opus.college.validator.StudyPlanValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyPlanForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.LookupCacherKey;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping(value="/college/studyplan.view")
@SessionAttributes({ StudyPlanEditController.FORM })
public class StudyPlanEditController {

    public static final String FORM = "studyPlanForm";

    private static Logger log = LoggerFactory.getLogger(StudyPlanEditController.class);
    private final String formView;

    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private OpusInit opusInit;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private StudyPlanDetailDeleteValidator studyPlanDetailDeleteValidator;
    @Autowired private SubjectBlockMapper subjectBlockMapper;
    @Autowired private SubjectManagerInterface subjectManager;

	public StudyPlanEditController() {
		super();
		this.formView = "college/person/studyPlan";
	}

    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        // declare variables
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        StudyPlan studyPlan = null;
        Student student = null;
        StudyGradeType initStudyGradeType = null;
        int studentId;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        int maxNumberOfCardinalTimeUnits = 0;
//        Lookup gradeType = null;
        Study study = null;
        
        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");

//        if (request.getParameter("studyPlanId") != null 
//                && !"".equals(request.getParameter("studyPlanId"))) {
//            studyPlanId = Integer.parseInt(request.getParameter("studyPlanId"));
//        }
        int studyPlanId = ServletUtil.getIntParam(request, "studyPlanId", 0);
        
        /* STUDYPLAN FORM - fetch or create the form object and fill it with studyPlanForm */
        StudyPlanForm studyPlanForm = (StudyPlanForm) model.get(FORM);
        if (studyPlanForm == null) {
        	studyPlanForm = new StudyPlanForm();
            model.addAttribute(FORM, studyPlanForm);        
        }

        /* STUDYPLAN FORM - STUDYPLAN */
        if (studyPlanForm.getStudyPlan() == null) {
            if (studyPlanId != 0) {
                // EXISTING STUDYPLAN
                int lowestGradeOfSecondarySchoolSubjects  = appConfigManager.getSecondarySchoolSubjectsLowestGrade();
                int highestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsHighestGrade();
                studyPlan = studentManager.findStudyPlan(studyPlanId, 
                		highestGradeOfSecondarySchoolSubjects, lowestGradeOfSecondarySchoolSubjects,
                		preferredLanguage);

                // check if firstCTU is present
                List <StudyPlanCardinalTimeUnit > studyPlanCTUs = studyPlan.getStudyPlanCardinalTimeUnits();
                if (studyPlanCTUs != null) {
                    for (int i= 0; i < studyPlanCTUs.size(); i++) {
                        if (studyPlanCTUs.get(i).getCardinalTimeUnitNumber() == 1) {
                            studyPlanForm.setFirstCTU(true);
                            break;
                        }
                    }
                }
                // find organization id's matching with the study
                study = studyManager.findStudy(studyPlan.getStudyId());
                organizationalUnitId = study.getOrganizationalUnitId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);
                
                /* set if gradeType is bachelor */
                studyPlanForm.setGradeTypeIsBachelor(opusMethods.isGradeTypeIsBachelor(
                        preferredLanguage, studyPlan.getGradeTypeCode()));
                
                /* if the gradeType of the studyPlan is a master and there is a first
                 * cardinaltimeunit then a previous discipline might be set
                 */
                studyPlanForm = this.findDisciplines(studyPlan.getGradeTypeCode(), studyPlan
                                                , preferredLanguage, studyPlanForm, request);
                
                studentId = studyPlan.getStudentId();
            } else {
                // NEW STUDYPLAN
                studyPlan = new StudyPlan();
                // fetch organization from session
                organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
                branchId = ((Integer) session.getAttribute("branchId"));
                institutionId = ((Integer) session.getAttribute("institutionId"));
                
                studentId = Integer.parseInt(request.getParameter("studentId"));
                if (studentId == 0) {
                    throw new RuntimeException("Neither studyPlanId nor studentId given");
                }

                studyPlan.setStudentId(studentId);
                studyPlan.setActive("Y");

            }
            studyPlanForm.setStudyPlan(studyPlan);

            /* STUDYPLAN FORM - STUDENT */
//            if (studyPlanForm.getStudent() == null) {
//                if (studyPlanForm.getStudyPlan() != null) {
//                    student = studentManager.findStudent(preferredLanguage, 
//                            studyPlanForm.getStudyPlan().getStudentId());
//                } else {
//                    if (studentId != 0) {
                        student = studentManager.findStudent(preferredLanguage, studentId);
//                    }
//                }
                studyPlanForm.setStudent(student);
//            } else {
//            }
            
            if (studyPlanForm.getAllStudyPlansForStudent() != null) {
                studyPlanForm.setAllStudyPlansForStudent(
                    studentManager.findStudyPlansForStudent(student.getStudentId()));
            }

        } else {
        	studyPlan = studyPlanForm.getStudyPlan();
            student = studyPlanForm.getStudent();
        	/* set if gradeType is bachelor */
            studyPlanForm.setGradeTypeIsBachelor(opusMethods.isGradeTypeIsBachelor(preferredLanguage, studyPlan.getGradeTypeCode()));
        }
        
        // make sure there are always 2 referees
        if (studyPlan.getAllReferees() == null) {
            studyPlan.setAllReferees(new ArrayList< Referee >());
        }
        
        int listSize = studyPlan.getAllReferees().size();
        for (int j = 2; j > listSize; j--) {
            Referee referee = new Referee();
            referee.setStudyPlanId(studyPlan.getId());
            studyPlan.getAllReferees().add(referee);
        }

        if (studyPlan.getId() != 0) {
            studyPlanForm.setAllCardinalTimeUnitResults(resultManager.findCardinalTimeUnitResultsForStudyPlan(studyPlan.getId()));
        }
        // use the session default to define the max number of cardinal time units shown
   		if (studyPlan.getId() != 0) {
   			if (studyPlan.getStudyPlanCardinalTimeUnits() != null && studyPlan.getStudyPlanCardinalTimeUnits().size() != 0) {
   				List <StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = 
   						studentManager.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
                initStudyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnits.get(0).getStudyGradeTypeId());
   			} else {
   				AcademicYear currentAcademicYear = academicYearManager.getCurrentAcademicYear();
   	   	        Map<String, Object> map = new HashMap<>();
   	   	        map.put("studyId", studyPlan.getStudyId());
   	   	        map.put("gradeTypeCode", studyPlan.getGradeTypeCode());
   				map.put("currentAcademicYearId", currentAcademicYear.getId());
   				map.put("studyTimeCode", OpusConstants.STUDY_TIME_DAYTIME);
   				map.put("studyFormCode", OpusConstants.STUDY_FORM_REGULAR);
   				map.put("preferredLanguage", preferredLanguage);
   				if ("Y".equals(iUseOfPartTimeStudyGradeTypes)) {
   					map.put("studyIntensityCode", OpusConstants.STUDY_INTENSITY_FULLTIME);
   				}
   				initStudyGradeType = studyManager.findStudyGradeTypeByParams(map);
   			}
   		}
   		if (initStudyGradeType != null) {
   			maxNumberOfCardinalTimeUnits = initStudyGradeType.getMaxNumberOfCardinalTimeUnits();
   		}
   		if (maxNumberOfCardinalTimeUnits == 0) {
   			maxNumberOfCardinalTimeUnits = opusInit.getMaxCardinalTimeUnits();
   		}
        studyPlanForm.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);

        /* STUDYPLANFORM.ORGANIZATION - fetch or create the object */
        if (studyPlanForm.getOrganization() != null) {
        	organization = studyPlanForm.getOrganization();
        } else {
        	organization = new Organization();

        	// get the organization values from study:
            organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
        }
        studyPlanForm.setOrganization(organization);

        /* STUDYPLANFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (studyPlanForm.getNavigationSettings() != null) {
        	navigationSettings = studyPlanForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        studyPlanForm.setNavigationSettings(navigationSettings);

        // ERRORS:
//        if (!StringUtil.isNullOrEmpty(request.getParameter("txtError"))) {
//            studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
//            		request.getParameter("txtError"));
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("showThesisError"))) {
//            studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
//            		request.getParameter("showThesisError"));
//        }
//        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudyPlanError"))) {
//            studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
//            		request.getParameter("showStudyPlanError"));
//        }
        
        // if not enough subjects are graded for a bachelor, first ctu, show message
        if (!StringUtil.isNullOrEmpty(request.getParameter("showTxtMsg"))) {
            studyPlanForm.setTxtMsg(studyPlanForm.getTxtMsg() + request.getParameter("showTxtMsg"));
        } else {
        	studyPlanForm.setTxtMsg("");
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                            session, request, organization.getInstitutionTypeCode(),
                            organization.getInstitutionId(), organization.getBranchId(), 
                            organization.getOrganizationalUnitId());

        /* put lookup-tables on the request */
//        lookupCacher.getPersonLookups(preferredLanguage, request);
//        lookupCacher.getStudentLookups(preferredLanguage, request);
//        lookupCacher.getStudyLookups(preferredLanguage, request);
//        lookupCacher.getAddressLookups(preferredLanguage, request);
//        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
//        lookupCacher.getSubjectLookups(preferredLanguage, request);
        
        studyPlanForm.setAllApplicantCategories(lookupCacher.getAllApplicantCategories());
        studyPlanForm.setAllGradeTypes(lookupCacher.getAllGradeTypes(preferredLanguage));
        studyPlanForm.setAllStudyPlanStatuses(lookupCacher.getAllStudyPlanStatuses(preferredLanguage));
        studyPlanForm.setAllProgressStatuses(lookupCacher.getAllProgressStatuses(preferredLanguage));
        studyPlanForm.setAllStudyForms(lookupCacher.getAllStudyForms(preferredLanguage));
        studyPlanForm.setAllCardinalTimeUnitStatuses(lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage));

        studyPlanForm.setCodeToCardinalTimeUnitMap(new CodeToLookupMap(lookupCacher.getAllCardinalTimeUnits(new LookupCacherKey(preferredLanguage, LookupCacherKey.CAPITALIZE))));
        studyPlanForm.setCodeToImportanceTypeMap(new CodeToLookupMap(lookupCacher.getAllImportanceTypes(preferredLanguage)));
        studyPlanForm.setCodeToRigidityTypeMap(new CodeToLookupMap(lookupCacher.getAllRigidityTypes(preferredLanguage)));
        studyPlanForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));
        studyPlanForm.setCodeToStudyIntensityMap(new CodeToLookupMap(lookupCacher.getAllStudyIntensities(preferredLanguage)));
        studyPlanForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));

        /* study domain attributes */
		Map<String, Object> academicYearMap = new HashMap<>();
		//academicYearMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        List<AcademicYear> allAcademicYears = studyManager.findAllAcademicYears(academicYearMap);
        studyPlanForm.setAllAcademicYears(allAcademicYears);
        studyPlanForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        
        // STUDIES
        Map<String, Object> findMap = new HashMap<>();
        findMap = opusMethods.fillOrganizationMapForReadStudyPlanAuthorization(request, organization);
        findMap.put("preferredLanguage", preferredLanguage);
        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        List<Study> allStudies = studyManager.findStudies(findMap);
        studyPlanForm.setAllStudies(allStudies);

//        findMap.put("studyId", 0);
//        studyPlanForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findMap));
        
        String endGradesPerGradeType = studyManager.findEndGradeType(0);
        if (endGradesPerGradeType != null || !"".equals(endGradesPerGradeType)) {
            studyPlanForm.setEndGradesPerGradeType("Y");
        }

        // number of secondarySchoolSubjects that need to be graded for the first studyplanctu
    	// necessary for finding out if enough sec. school subjects are there to grade:
        if (studyPlan.getStudyPlanCardinalTimeUnits() != null && studyPlan.getStudyPlanCardinalTimeUnits().size() != 0) {
            

        	if (studyPlan.getStudyPlanCardinalTimeUnits().get(0) != null) {
	        	StudyPlanCardinalTimeUnit studyPlanCTU = 
	        		studyPlan.getStudyPlanCardinalTimeUnits().get(0);
	        	StudyGradeType studyGradeType = studyManager.findStudyGradeType(
	        			studyPlanCTU.getStudyGradeTypeId());
	        	AcademicYear currentAcademicYear = null;
	        	if (studyGradeType != null) {
	        	    currentAcademicYear = academicYearManager.findAcademicYear(studyGradeType.getCurrentAcademicYearId());
	        	}
	            // number of secondarySchoolSubjects that need to be graded
	        	// TODO replace with appconfig and set default to 5 (as is the value now in web.xml)
	        	Integer numberOfSubjectsToGrade = null;
                if (currentAcademicYear != null && currentAcademicYear.getStartDate() != null) {
                    numberOfSubjectsToGrade = academicYearManager.findRequestAdmissionNumberOfSubjectsToGrade(currentAcademicYear.getStartDate());
	        	}
                if (numberOfSubjectsToGrade == null || numberOfSubjectsToGrade == 0) {
                    numberOfSubjectsToGrade = appConfigManager.getSecondarySchoolSubjectsCount();
                }
                studyPlan.setNumberOfSubjectsToGrade(numberOfSubjectsToGrade);
                
                
                // if not enough subjects graded, show message, not a warning
                // #775: but only show if student is actually in a state when it matter, e.g. when student is admitted, there is no sense in showing this message anymore
                if (OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION.equals(studyPlan.getStudyPlanStatusCode()) && !studyPlan.isEnoughGradedSubjects()) {
                	studyPlanForm.setTxtMsg(messageSource.getMessage(
                			"jsp.error.secondaryschoolsubject.graded.total", null
							, RequestContextUtils.getLocale(request)) 
							+ studyPlan.getNumberOfSubjectsToGrade());
                } else {
                	studyPlanForm.setTxtMsg("");
                }
        	} else {
        		studyPlan.setNumberOfSubjectsToGrade(appConfigManager.getSecondarySchoolSubjectsCount());
        	}
        } else {
        	studyPlan.setNumberOfSubjectsToGrade(appConfigManager.getSecondarySchoolSubjectsCount());
        }
        if (log.isDebugEnabled()) {
        	log.debug("StudyPlanEdit - numberOfSubjectsToGrade = " + studyPlan.getNumberOfSubjectsToGrade());
        }
        
        // SUBJECTBLOCKS & SUBJECTS
//        findMap.put("active", "");
//        findMap.put("rigidityTypeCode", null);
//        String iMajorMinor = opusInit.getMajorMinor();
//   		if ("Y".equals(iMajorMinor)) {
//			findMap.put("minor1Id", studyPlan.getMinor1Id());
//	   		findMap.put("importanceTypeMajor", OpusConstants.IMPORTANCE_TYPE_MAJOR);
//	   		findMap.put("importanceTypeMinor", OpusConstants.IMPORTANCE_TYPE_MINOR);
//	   	}

        List<Study> allPlusAdditionalStudies = new ArrayList<>(allStudies);
        if (studyPlanId != 0) {

            // STUDYGRADETYPES
            List<StudyPlanDetail> studyPlanDetails = DomainUtil.getMergedCollectionProperties(studyPlan.getStudyPlanCardinalTimeUnits(), "studyPlanDetails");
            List<Integer> studyGradeTypeIds = DomainUtil.getProperties(studyPlan.getStudyPlanCardinalTimeUnits(), "studyGradeTypeId");
            List<StudyGradeType> allStudyGradeTypes = studyManager.findStudyGradeTypes(studyGradeTypeIds, preferredLanguage);
            studyPlanForm.setIdToStudyGradeTypeMap(new IdToStudyGradeTypeMap(allStudyGradeTypes));

            // SUBJECT BLOCKS & SUBJECTS
            List<SubjectBlock> allSubjectBlocks = studentManager.findSubjectBlocksForStudyPlan(studyPlanId);
            studyPlanForm.setIdToSubjectBlockMap(new IdToSubjectBlockMap(allSubjectBlocks));

            List<Subject> allSubjects = subjectManager.findSubjectsForStudyPlan(studyPlanId);
            studyPlanForm.setIdToSubjectMap(new IdToSubjectMap(allSubjects));

            //  SUBJECTBLOCKSTUDYGRADETYPES & SUBJECTSTUDYGRADETYPES

            List<Integer> studyPlanDetailIds = DomainUtil.getIds(studyPlanDetails);

            List<SubjectBlockStudyGradeType> subjectBlockStudyGradeTypes = subjectManager.findSubjectBlockStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
            studyPlanForm.setAllSubjectBlockStudyGradeTypes(subjectBlockStudyGradeTypes);

            List<SubjectStudyGradeType> allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes(studyPlanDetailIds, preferredLanguage);
            // add the (virtual) blocked subjectstudygradetypes from the previous studyplancardinaltimeunit too, in case one or more have to be repeated:
            List<Integer> subjectBlockStudyGradeTypeIds = DomainUtil.getIds(subjectBlockStudyGradeTypes);
            List<SubjectStudyGradeType> blockedSubjectStudyGradeTypes = subjectManager.findBlockedSubjectStudyGradeTypeByParams(subjectBlockStudyGradeTypeIds);
            allSubjectStudyGradeTypes.addAll(blockedSubjectStudyGradeTypes);
            studyPlanForm.setAllSubjectStudyGradeTypes(allSubjectStudyGradeTypes);

            // allStudies: for allStudygradetypes, allSubjectBlocks and allSubjects
            List<Integer> studyIds = DomainUtil.getIntProperties(allStudyGradeTypes, "studyId");
            studyIds.addAll(DomainUtil.getIntProperties(allSubjects, "primaryStudyId"));
            studyIds.addAll(DomainUtil.getIntProperties(allSubjectBlocks, "primaryStudyId"));
            allPlusAdditionalStudies.addAll(studyManager.findStudies(studyIds, preferredLanguage));

        }
        studyPlanForm.setIdToStudyMap(new IdToStudyMap(allPlusAdditionalStudies));

        // Org. units
        List<Integer> organizationalUnitIds = DomainUtil.getIntProperties(allPlusAdditionalStudies, "organizationalUnitId");
        List<OrganizationalUnit> allOrgUnits = organizationalUnitManager.findOrganizationalUnitsByIds(organizationalUnitIds);
        studyPlanForm.setIdToOrganizationalUnitMap(new IdToOrganizationalUnitMap(allOrgUnits));

        return formView;
    }
    /**
     * @param studyPlanForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute(FORM) StudyPlanForm studyPlanForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

    	if (log.isDebugEnabled()) {
    		log.debug("StudyPlanEdit: process submit entered");
    	}
    	
    	HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
    	
    	NavigationSettings navigationSettings = studyPlanForm.getNavigationSettings();
    	
        String submitFormObject = "";

        Student student = studyPlanForm.getStudent();
        StudyPlan studyPlan = studyPlanForm.getStudyPlan();
        StudyPlan changedStudyPlan = null;
        
        Locale currentLoc = RequestContextUtils.getLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        
        String writeWho = opusMethods.getWriteWho(request);
                
        if ("true".equals(submitFormObject)) {

        	if (log.isDebugEnabled()) {
        		log.debug("StudyPlanEdit: process submit - submitFormObject is true");
        	}

            new StudyPlanValidator().validate(studyPlanForm, result);
            if (result.hasErrors()) {

            	/* fill lookup-tables with right values */
//                lookupCacher.getPersonLookups(preferredLanguage, request);
//                lookupCacher.getStudyLookups(preferredLanguage, request);
//                lookupCacher.getAddressLookups(preferredLanguage, request);
            	return formView;
            }
            
            Map<String, Object> map = new HashMap<>();
            map.put("studentId", studyPlan.getStudentId());
            map.put("studyId", studyPlan.getStudyId());
            map.put("gradeTypeCode", studyPlan.getGradeTypeCode());
            map.put("studyPlanDescription", studyPlan.getStudyPlanDescription());

            if (studyPlanForm.getStudyPlan().getId() == 0) {
	            /* test if the combination already exists */
	        	if (studentManager.findStudyPlanByParams(map)!= null) {
	
	                studyPlanForm.setTxtErr(student.getStudentCode() + ". "
	                	+ messageSource.getMessage(
	                        "jsp.error.studyplan.edit", null, currentLoc)
	                    + messageSource.getMessage(
	                        "jsp.error.general.alreadyexists", null, currentLoc));

	                //status.setComplete();
                	return "redirect:studyplan.view";

	        	} else {
	                studentManager.addStudyPlanToStudent(studyPlan, writeWho);
	                studyManager.adaptReferees(studyPlan);
                }
	        } else {
	            studentManager.updateStudyPlan(studyPlan, writeWho);
	            studyManager.adaptReferees(studyPlan);
	            
	            // SECONDARY SCHOOL SUBJECTS - only for BA / BSC studyplans with CTU 1
	            boolean chkSchoolSubjects = false;
	            // groups are filled only for BA / BSC studyplans
	            if (studyPlan.getSecondarySchoolSubjectGroups() != null
                        && studyPlan.getSecondarySchoolSubjectGroups().size() > 0) {
                     // check if CTU 1 is present
                    if (!ListUtil.isNullOrEmpty(studyPlan.getStudyPlanCardinalTimeUnits())) {
                        for (StudyPlanCardinalTimeUnit studyPlanCTU:studyPlan.getStudyPlanCardinalTimeUnits()) {
                            if (studyPlanCTU.getCardinalTimeUnitNumber() == 1) {
                                chkSchoolSubjects = true;
                            }
                        }
                    }
	            }
	            
                if (chkSchoolSubjects) {
                	if (log.isDebugEnabled()) {
                		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups entered");
                	}
    	            // test if there are enough subjects so the correct number can be graded
		            if (!opusMethods.checkTotalNumberOfSubjects(
		            		studyPlan.getSecondarySchoolSubjectGroups(),
	            				studyPlan.getNumberOfSubjectsToGrade())) {
		            	studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
		            			messageSource.getMessage(
	                        "jsp.error.secondaryschoolsubject.missing", null, currentLoc));
		            }

	                // test if there are enough subjects in every group so the correct number can be graded
	                boolean isCorrectNumberOfSubjectsInGroup = true;
                	if (log.isDebugEnabled()) {
                		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups - isCorrectNumberOfSubjectsInGroup1 = " + isCorrectNumberOfSubjectsInGroup);
                	}
	                if (studyPlan.getSecondarySchoolSubjectGroups() != null && studyPlan.getSecondarySchoolSubjectGroups().size() > 0) {
	                    for (SecondarySchoolSubjectGroup group : studyPlan.getSecondarySchoolSubjectGroups()) {
	                    	isCorrectNumberOfSubjectsInGroup = opusMethods.checkNumberOfSubjectsInGroup(group);
	                    	if (!isCorrectNumberOfSubjectsInGroup) {
	                            break;
	                        }
	                    }
	                } else {
	                    isCorrectNumberOfSubjectsInGroup = false;
	                }
	                
	                if (!isCorrectNumberOfSubjectsInGroup) {
	                    studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
	                    messageSource.getMessage(
	                    		"jsp.error.secondaryschoolsubject.missing.in.group", null, currentLoc));
	                }
                	if (log.isDebugEnabled()) {
                		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups - isCorrectNumberOfSubjectsInGroup2 = " + isCorrectNumberOfSubjectsInGroup);
                	}
                	
                	// check if the correct number of subjects is graded
                	if (!studyPlan.isEnoughGradedSubjects()) {
                    	studyPlanForm.setTxtMsg(messageSource.getMessage(
                    			"jsp.error.secondaryschoolsubject.graded.total", null
    							, RequestContextUtils.getLocale(request)) 
    							+ studyPlan.getNumberOfSubjectsToGrade());
                    } else {
                    	studyPlanForm.setTxtMsg("");
                    }
    	           
                	List < SecondarySchoolSubject > compareSubjects = new ArrayList<>();
                	
                    // check for doubles in sec. school subjects:
                    for (SecondarySchoolSubjectGroup subjectGroup : studyPlan.getSecondarySchoolSubjectGroups()) {
                        if (subjectGroup.getSecondarySchoolSubjects() != null 
                              && subjectGroup.getSecondarySchoolSubjects().size() > 0) { 
                        	compareSubjects.addAll(subjectGroup.getSecondarySchoolSubjects());
                        }
                	}
                	if (log.isDebugEnabled()) {
                		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups - compareSubjects.size = " + compareSubjects.size());
                	}
                    if (compareSubjects.size() != 0) {
	                    for (SecondarySchoolSubject checkSubject : compareSubjects) {
		                    if (!StringUtil.isNullOrEmpty(checkSubject.getGrade(), true) && !"0".equals(checkSubject.getGrade())) {
		                    	int countSubject = 0;
		                    	for (SecondarySchoolSubject compareSubject : compareSubjects) {
		                    		if (!StringUtil.isNullOrEmpty(compareSubject.getGrade(), true) 
		                            		&& !"0".equals(compareSubject.getGrade())) {
		                            	if (checkSubject.getId() == compareSubject.getId()) {
		                            		if (log.isDebugEnabled()) {
	                                    		log.debug("StudyPlanEdit: counted subject: " + checkSubject.getId() + ", grade = " + checkSubject.getGrade() + ", level = " + checkSubject.getLevel());
	                                    	}
		                            		countSubject = countSubject+1;
		                        		}
		                    		}
		                    	}
		                    	if (log.isDebugEnabled()) {
		                    		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups - countSubject = " + countSubject);
		                    	}

		                    	if (countSubject > 1) {
		                    		studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
		                                    student.getStudentCode() + ". "
		                                 + messageSource.getMessage(
		                                     "jsp.error.studyplan.edit", null, currentLoc)
		                                 + messageSource.getMessage(
		                                    "jsp.error.secondaryschoolsubject.already.graded", null, currentLoc)
		                            );
		                			break;
		                		}                       	
		                   	
		                    }
		            	}
	            	}
	            	// if all checks okay: add or update the graded secondary school subjects
	            	if (StringUtil.isNullOrEmpty(studyPlanForm.getTxtErr(), true)) {
	                    for (SecondarySchoolSubjectGroup subjectGroup : studyPlan.getSecondarySchoolSubjectGroups()) {
	                    	if (subjectGroup.getSecondarySchoolSubjects() != null 
	                                      && subjectGroup.getSecondarySchoolSubjects().size() > 0) {                         	
	                    		if (StringUtil.isNullOrEmpty(studyPlanForm.getTxtErr(), true)) {
			                    	if (log.isDebugEnabled()) {
			                    		log.debug("StudyPlanEdit: getSecondarySchoolSubjectGroups - start add/update");
			                    	}

	                    			// add or update, depending if graded secondary school subject exists already
		                        	for (SecondarySchoolSubject subject : subjectGroup.getSecondarySchoolSubjects()) {
		                                if (!StringUtil.isNullOrEmpty(subject.getGrade(), true) && !"0".equals(subject.getGrade())) {
		                                    if (subject.getGradedSecondarySchoolSubjectId() == 0) {
		                                    	if (log.isDebugEnabled()) {
		                                    		log.debug("StudyPlanEdit: add gradedsec school subject: " + subject.getId() + ", grade = " + subject.getGrade() + ", level = " + subject.getLevel());
		                                    	}
		                                    	// add gradedSecondarySchoolSubject
		                                    	studyManager.addGradedSecondarySchoolSubject(subject, studyPlan.getId(), subjectGroup.getId(), opusMethods.getWriteWho(request));
		                                    } else {
		                                    	if (log.isDebugEnabled()) {
		                                    		log.debug("StudyPlanEdit: update gradedsec school subject: " + subject.getId() + ", grade = " + subject.getGrade() + ", level = " + subject.getLevel());
		                                    	}
		                                        // update gradedSecondarySchoolSubject
		                                        studyManager.updateGradedSecondarySchoolSubject(subject, studyPlan.getId(), subjectGroup.getId(), opusMethods.getWriteWho(request));
		                                    }
		                                } else {
		                                    if (subject.getGradedSecondarySchoolSubjectId() != 0) {
		                                        // delete gradedSecondarySchoolSubject
		                                        studyManager.deleteGradedSecondarySchoolSubject(subject, studyPlan.getId(), opusMethods.getWriteWho(request));
		                                    }
		                                }
		                            }
	                        	}
	                        }
	                    }
	            	}
		            // 2. Graded Ungrouped SecondarySchoolSubjects - only for BA / BSC studyplans
	                if (studyPlan.getUngroupedSecondarySchoolSubjects() != null && studyPlan.getUngroupedSecondarySchoolSubjects().size() > 0) {
	                	if (log.isDebugEnabled()) {
	                		log.debug("StudyPlanEdit: getUngroupedSecondarySchoolSubjects entered");
	                	}
	    	           
	                	List < SecondarySchoolSubject > compareUngroupedSubjects = 
	                		studyPlan.getUngroupedSecondarySchoolSubjects();
	                	
	                	if (log.isDebugEnabled()) {
	                		log.debug("StudyPlanEdit: getUngroupedSecondarySchoolSubjects - compareUngroupedSubjects.size = " + compareUngroupedSubjects.size());
	                	}
	                    if (compareUngroupedSubjects.size() != 0) {
		                    for (SecondarySchoolSubject checkUngroupedSubject : compareUngroupedSubjects) {
			                    if (!StringUtil.isNullOrEmpty(checkUngroupedSubject.getGrade(), true) && !"0".equals(checkUngroupedSubject.getGrade())) {
			                    	int countSubject = 0;
			                    	for (SecondarySchoolSubject compareSubject : compareSubjects) {
			                    		if (!StringUtil.isNullOrEmpty(compareSubject.getGrade(), true) 
			                            		&& !"0".equals(compareSubject.getGrade())) {
			                            	if (checkUngroupedSubject.getId() == compareSubject.getId()) {
			                            		if (log.isDebugEnabled()) {
		                                    		log.debug("StudyPlanEdit: counted subject: " + checkUngroupedSubject.getId() + ", grade = " + checkUngroupedSubject.getGrade() + ", level = " + checkUngroupedSubject.getLevel());
		                                    	}
			                            		countSubject = countSubject+1;
			                        		}
			                    		}
			                    	}
			                    	if (log.isDebugEnabled()) {
			                    		log.debug("StudyPlanEdit: getUngroupedSecondarySchoolSubjects - countSubject = " + countSubject);
			                    	}

			                    	if (countSubject > 1) {
			                    		studyPlanForm.setTxtErr(studyPlanForm.getTxtErr() + 
			                                    student.getStudentCode() + ". "
			                                 + messageSource.getMessage(
			                                     "jsp.error.studyplan.edit", null, currentLoc)
			                                 + messageSource.getMessage(
			                                    "jsp.error.ungroupedsecondaryschoolsubject.already.graded", null, currentLoc)
			                            );
			                			break;
			                		}                       	
			                   	
			                    }
			            	}
		            	}
		            	// if all checks okay: add or update the graded ungrouped secondary school subjects
		            	if (StringUtil.isNullOrEmpty(studyPlanForm.getTxtErr(), true)) {
		     
                			// add or update, depending if graded ungrouped secondary school subject exists already
                        	for (SecondarySchoolSubject ungroupedSubject : studyPlan.getUngroupedSecondarySchoolSubjects()) {
                                if (!StringUtil.isNullOrEmpty(ungroupedSubject.getGrade(), true) && !"0".equals(ungroupedSubject.getGrade())) {
                                	if (log.isDebugEnabled()) {
                                		log.debug("StudyPlanEdit: gradedsec school ungroupedSubject: ungroupedSubject.getGradedSecondarySchoolSubjectId() = " + ungroupedSubject.getGradedSecondarySchoolSubjectId());
                                	}
                                	if (ungroupedSubject.getGradedSecondarySchoolSubjectId() == 0) {
                                    	if (log.isDebugEnabled()) {
                                    		log.debug("StudyPlanEdit: add gradedsec school ungroupedSubject: " + ungroupedSubject.getId() + ", grade = " + ungroupedSubject.getGrade() + ", level = " + ungroupedSubject.getLevel());
                                    	}
                                    	// add gradedUngroupedSecondarySchoolSubject
                                    	studyManager.addGradedSecondarySchoolSubject(ungroupedSubject, studyPlan.getId(), 0, opusMethods.getWriteWho(request));
                                    } else {
                                    	if (log.isDebugEnabled()) {
                                    		log.debug("StudyPlanEdit: update gradedsec school ungroupedSubject: " + ungroupedSubject.getId() + ", grade = " + ungroupedSubject.getGrade() + ", level = " + ungroupedSubject.getLevel());
                                    	}
                                        // update gradedUngroupedSecondarySchoolSubject
                                        studyManager.updateGradedSecondarySchoolSubject(ungroupedSubject, studyPlan.getId(), 0, opusMethods.getWriteWho(request));
                                    }
                                } else {
                                    if (ungroupedSubject.getGradedSecondarySchoolSubjectId() != 0) {
                                        // delete gradedUngroupedSecondarySchoolSubject
                                        studyManager.deleteGradedSecondarySchoolSubject(ungroupedSubject, studyPlan.getId(), opusMethods.getWriteWho(request));
                                    }
                                }
                            }
		            	}
	                }
                }
	        }
            changedStudyPlan = studentManager.findStudyPlanByParams(map);

            status.setComplete();
            
            return "redirect:studyplan.view?newForm=true&tab=" + navigationSettings.getTab() 
        		+ "&panel=" + navigationSettings.getPanel() 
        		+ "&studentId=" + student.getStudentId()
        		+ "&studyPlanId=" + changedStudyPlan.getId()
//        		+ "&showStudyPlanError="+ studyPlanForm.getTxtErr()
        		+ "&showTxtMsg="+ studyPlanForm.getTxtMsg()
        		+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();          
        } else {
            // submit but no save
            
            /* put lookup-tables on the request */
//            lookupCacher.getPersonLookups(preferredLanguage, request);
//            lookupCacher.getStudyPlanLookups(preferredLanguage, request);

            /* set if gradeType is bachelor */
            studyPlanForm.setGradeTypeIsBachelor(opusMethods.isGradeTypeIsBachelor(
                    preferredLanguage, studyPlan.getGradeTypeCode()));
           
            // check it the gradetype is a master and if so get the correct list of disciplines
            studyPlanForm = this.findDisciplines(studyPlan.getGradeTypeCode(), studyPlan, preferredLanguage, studyPlanForm, request);
        	//status.setComplete();

            return formView;
        }
     }
    
    private StudyPlanForm findDisciplines( 
            final String gradeTypeCode, final StudyPlan studyPlan, final String language, 
            final StudyPlanForm studyPlanForm, HttpServletRequest request) {
        
        /* if the gradeType of the studyPlan is a master and there is a first
         * cardinaltimeunit then a previous discipline might be set
         */
        if (opusMethods.isGradeTypeIsMaster(language, gradeTypeCode)) {
            studyPlanForm.setGradeTypeIsMaster(true);

            // determine whether of not there is a CTU 1
            String disciplineGroupCode = "";
            List <? extends StudyPlanCardinalTimeUnit > studyPlanCTUs = studyPlan.getStudyPlanCardinalTimeUnits();
            if (studyPlanCTUs != null) {
                // find the disciplinegroup of studygradetype
                int studyGradeTypeId = 0;
                for (int i= 0; i < studyPlanCTUs.size(); i++) {
                    if (studyPlanCTUs.get(i).getCardinalTimeUnitNumber() == 1) {
                        studyGradeTypeId = studyPlanCTUs.get(i).getStudyGradeTypeId();
                    }
                }

                if (studyGradeTypeId != 0) {
                    // since studyGradeTypeId is only filled when the CTU = 1
                    disciplineGroupCode = (studyManager.findStudyGradeType(studyGradeTypeId))
                                                                    .getDisciplineGroupCode();
                    if (!StringUtil.isNullOrEmpty(disciplineGroupCode, true)) {
                        studyPlanForm.setDisciplineGroupCode(disciplineGroupCode);
                        // set list of disciplines
                        Map<String, Object> disciplinesMap = new HashMap<>();
                        disciplinesMap.put("preferredLanguage", language);
                        disciplinesMap.put("disciplineGroupCode", disciplineGroupCode);
                        studyPlanForm.setAllDisciplines(studyManager
                                            .findDisciplinesForGroup(disciplinesMap));
                        // determine label for disciplines dropdown
                        Locale currentLoc = RequestContextUtils.getLocale(request);
                        if (studyPlanForm.getDisciplineGroupCode().equals(OpusConstants.DISCIPLINEGROUP_CODE_MA_HRM)) {
                            studyPlanForm.setDisciplinesLabel(messageSource.getMessage(
                                             "jsp.discipline.ma.hrm", null, currentLoc));
                        } else if (studyPlanForm.getDisciplineGroupCode().equals(OpusConstants.DISCIPLINEGROUP_CODE_MBA_FINANCIAL)) {
                            studyPlanForm.setDisciplinesLabel(messageSource.getMessage(
                                    "jsp.discipline.mba.financial", null, currentLoc));
                        } else if (studyPlanForm.getDisciplineGroupCode().equals(OpusConstants.DISCIPLINEGROUP_CODE_MBA_GENERAL)) {
                            studyPlanForm.setDisciplinesLabel(messageSource.getMessage(
                                    "jsp.discipline.mba.general", null, currentLoc));
                        } else if (studyPlanForm.getDisciplineGroupCode().equals(OpusConstants.DISCIPLINEGROUP_CODE_MSC_PM)) {
                            studyPlanForm.setDisciplinesLabel(messageSource.getMessage(
                                    "jsp.discipline.msc.pm", null, currentLoc));
                        }
                    } else {
                        
                        // TODO error
                    }
                }
            }
        
        } else {
            studyPlanForm.setGradeTypeIsMaster(false);
            if (opusMethods.isGradeTypeIsBachelor(language, gradeTypeCode)) {
                studyPlanForm.setGradeTypeIsBachelor(true);
            }
        }
        
        return studyPlanForm;

    }

    /* MP: commented, because sending an admisison letter via email to the student
     *      doesn't seem useful, since the letter needs to be signed by academic staff.
     *      So better print directly by academic staff, sign and hand over to student.
    @RequestMapping(method=RequestMethod.GET,  params = "printadmissionletter=true")
    public String sendAdmissionLetter(@RequestParam("studyPlanId") int studyPlanId, ModelMap model, HttpServletRequest request) throws JRException, SQLException{
    	
    	HttpSession session = request.getSession(false);        
        
        securityChecker.checkSessionValid(session);
        
    	StudyPlanForm studyPlanForm = (StudyPlanForm) session.getAttribute(FORM);
    
    	String preferredLanguage = OpusMethods.getPreferredLanguage(request);
    	
    	String reportPath =  request.getSession().getServletContext().getRealPath("/WEB-INF/reports/jasper/person/AdmissionLetter.jasper");
    	String fileSeparator = System.getProperty("file.separator" , "/");
    	String outputFile = System.getProperty("java.io.tmpdir", ".") + fileSeparator + "AdmissionLetter.pdf";
    	
    	List<ReportProperty> properties = reportManager.findPropertiesForReport("admissionletter");
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	String whereClause = " AND studyPlan.id= " + studyPlanId;
    	
    	params.put("whereClause", whereClause);
    	params.put("lang", preferredLanguage);
    	
    	params.putAll(ReportUtils.toPropertiesMap(properties));
    
    	//generate and export report to temporary folder
    	ReportUtils.exportReportToPdfFile(reportPath
    			, outputFile
    			, params
    			, dataSource.getConnection());


    	//attach and email file
    	  OpusMailSender mailSender = new OpusMailSender();
		
    	  //Get Sudent email address
    	  
    	  //Address with code = 2 is a formal communication address student
    	  Address studentAddress = addressManager.findAddressByPersonId("2", studyPlanForm.getStudent().getPersonId()); 
    	  
    	  if((studentAddress != null) && (!StringUtil.isNullOrEmpty(studentAddress.getEmailAddress(), true))) {
    		  
    		  opusMethods.sendOpusMail(mailSender, "approved_admission", new String[]{studentAddress.getEmailAddress()}
    		  , preferredLanguage, null, new String[]{outputFile});
    		  
    		  String successMsg = messageSource.getMessage("jsp.mailsentsucces" ,null, RequestContextUtils.getLocale(request));
    	
    		  studyPlanForm.setTxtMsg(successMsg);
    	
    	  } else {
    		  
    		  String errorMsg = messageSource.getMessage("jsp.error.studenthasnoemailaddress" ,null, RequestContextUtils.getLocale(request));
    		  
    		  studyPlanForm.setTxtErr(errorMsg);
    	  
    	  }
    	
    	model.addAttribute("tab", studyPlanForm.getNavigationSettings().getTab());
    	model.addAttribute("panel", studyPlanForm.getNavigationSettings().getPanel());
    	model.addAttribute(FORM, studyPlanForm);        
    	
    	return formView;
    }
    */

    @PreAuthorize("hasRole('DELETE_STUDY_PLANS')")
    @RequestMapping(method=RequestMethod.GET, params = "delete")
    public String deleteStudyPlanCardinalTimeUnit(
            @RequestParam("studyPlanCardinalTimeUnitId") int studyPlanCardinalTimeUnitId,
            StudyPlanForm studyPlanForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // StudyplanCardinalTimeUnit cannot be deleted if subject results or examination results are present
        // either within a subjectblock subject or within a loose subject
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);

        collegeServiceExtensions.isDeleteAllowed(studyPlanCardinalTimeUnit, result);
        if (result.hasErrors()) {
            return formView;
        }

        List<StudyPlanDetail> studyPlanDetails = null;
        //studyPlanDetails = studyPlan.getStudyPlanDetails();
        studyPlanDetails = 
                studentManager.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
        List < SubjectResult > subjectResultsForStudyPlanDetail = null;
        List<ExaminationResult> examinationResultListForStudyPlanDetail = null;
        Map<String, Object> resultListMap = new HashMap<>();

        List<Integer> subjectIds = new ArrayList<>();

        for (StudyPlanDetail studyPlanDetail : studyPlanDetails) {
            int subjectId = studyPlanDetail.getSubjectId();
            //                 if (studyPlanDetails.get(i).getSubjectId() != 0) {
            if (subjectId != 0) {
                subjectIds.add(subjectId);
            } else {
                if (studyPlanDetail.getSubjectBlockId() != 0) {
                    // SUBJECT via SUBJECTBLOCK
                    List<Subject> subjectInSubjectBlockList = subjectBlockMapper
                            .findSubjectsForSubjectBlockInStudyPlainDetail(studyPlanDetail.getSubjectBlockId());
                    for (Subject subject : subjectInSubjectBlockList) {
                        subjectIds.add(subject.getId());
/*                        resultListMap.put("studyPlanDetailId", studyPlanDetail.getId());
                        resultListMap.put("subjectId",subjectInSubjectBlockList.get(x).getId());
                        subjectResultsForStudyPlanDetail = 
                                resultManager.findSubjectResultsByParams(resultListMap);
                        if (subjectResultsForStudyPlanDetail.size() != 0) {
                            // show error for linked results
                            showStudyPlanError = messageSource.getMessage(
                                    "jsp.error.general.delete.linked.subjectresult"
                                    , null, currentLoc);
                        } else {
                            // examination cannot be deleted if examination results are present
                            examinationResultListForStudyPlanDetail = 
                                    resultManager.findExaminationResultsForStudyPlanDetail(
                                            resultListMap);
                            if (examinationResultListForStudyPlanDetail.size() != 0) {
                                // show error for linked results
                                showStudyPlanError = 
                                        messageSource.getMessage(
                                                "jsp.error.general.delete.linked.examinationresult"
                                                , null, currentLoc);
                            }
                        }*/
                    }
                }
            }
        }
        
        // Check for results

        List<Integer> errSubjectIds = new ArrayList<>();
        List<Integer> errExamSubjectIds = new ArrayList<>();

        for (int subjectId : subjectIds) {
            resultListMap.put("studyPlanCardinalTimeUnitId", studyPlanCardinalTimeUnitId);
            resultListMap.put("subjectId", subjectId);
            subjectResultsForStudyPlanDetail = resultManager.findSubjectResultsByParams(resultListMap);
            if (subjectResultsForStudyPlanDetail != null && subjectResultsForStudyPlanDetail.size() != 0) {
                errSubjectIds.add(subjectId);
            } else {
                // examination cannot be deleted if examination results are present
                examinationResultListForStudyPlanDetail = resultManager.findExaminationResultsForStudyPlanDetail(resultListMap);
                if (examinationResultListForStudyPlanDetail.size() != 0) {
                    errExamSubjectIds.add(subjectId);
                }
            }
        }
        if (!errSubjectIds.isEmpty()) {
            result.reject("jsp.error.studyplancardinaltimeunit.delete");
            List<Subject> subjects = subjectManager.findSubjects(errSubjectIds);
            String codes = StringUtil.commaSeparatedList(DomainUtil.getStringProperties(subjects, "subjectCode"));
            result.reject("jsp.error.general.delete.linked.subjectresult", new Object[] {codes}, null);
        }
        if (!errExamSubjectIds.isEmpty()) {
            result.reject("jsp.error.studyplancardinaltimeunit.delete");
            List<Subject> subjects = subjectManager.findSubjects(errExamSubjectIds);
            String codes = StringUtil.commaSeparatedList(DomainUtil.getStringProperties(subjects, "subjectCode"));
            result.reject("jsp.error.general.delete.linked.examinationresult.codes", new Object[] {codes}, null);
        }
        if (result.hasErrors()) {
            return formView;
        }

        if (log.isDebugEnabled()) {
            log.debug("StudyPlanCTUDeleteController: before actual delete");
        }

        // first delete all studyplandetails, then the studyplancardinaltimeunit
        for (StudyPlanDetail sdp : studyPlanDetails) {
            studentManager.deleteStudyPlanDetail(sdp.getId(), request);
        }

        // remove ctuResult if exists
        String writeWho = opusMethods.getWriteWho(request);
        CardinalTimeUnitResult cardinalTimeUnitResult = studyPlanCardinalTimeUnit.getCardinalTimeUnitResult();
        if (cardinalTimeUnitResult != null) {
            resultManager.deleteCardinalTimeUnitResult(cardinalTimeUnitResult.getId(), writeWho);
        }
        studentManager.deleteStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId, writeWho);

        NavigationSettings navigationSettings = studyPlanForm.getNavigationSettings();
        return "redirect:/college/studyplan.view?newForm=true&tab=1" 
                     + "&panel=0"
                     + "&studyPlanId=" + studyPlanCardinalTimeUnit.getStudyPlanId()
                     + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();

    }
    
    @RequestMapping(params="deleteStudyPlanDetail=true")
    public String deleteStudyPlanDetail(HttpServletRequest request, @ModelAttribute(FORM) StudyPlanForm studyPlanForm, BindingResult errors, 
            @RequestParam("studyPlanDetailId") int studyPlanDetailId) {
        
        StudyPlanDetail studyPlanDetail = studentManager.findStudyPlanDetail(studyPlanDetailId);
        studyPlanDetailDeleteValidator.validate(studyPlanDetail, errors);
        
        if (errors.hasErrors()) {
            return formView;
        }

        studentManager.deleteStudyPlanDetail(studyPlanDetailId, request);

        NavigationSettings navigationSettings = studyPlanForm.getNavigationSettings();
        return "redirect:/college/studyplan.view?newForm=true&tab=1" 
                + "&panel=0"
                + "&studyPlanId=" + studyPlanForm.getStudyPlan().getId()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }
    
}
