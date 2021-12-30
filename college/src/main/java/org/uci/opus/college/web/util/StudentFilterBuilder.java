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

package org.uci.opus.college.web.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

/**
 * @author mp
 * Reusable builder element to be used by controllers which display student lists.
 * Loads combo box entries for combo boxes typically used to show student lists.
 * One should be able to use a subset of the total possible combo boxes.
 */
public class StudentFilterBuilder {

    private Logger log = LoggerFactory.getLogger(StudentFilterBuilder.class);

    private OpusMethods opusMethods;
    private LookupCacher lookupCacher;
    private StudyManagerInterface studyManager;
    private StudentManagerInterface studentManager;
    private SubjectBlockMapper subjectBlockMapper;
    
	private HttpSession session;
	private HttpServletRequest request;
	private String preferredLanguage;
	private int institutionId = 0;
	private int branchId = 0;
    
	private int organizationalUnitId = 0;
	private int primaryStudyId = 0;
	private int academicYearId = 0;
	private int studyGradeTypeId = 0;
//	private int subjectBlockStudyGradeTypeId = 0;
	private int subjectBlockId = 0;
	private Integer cardinalTimeUnitNumber = 0;
	
    private String studentStatusCode = "";
	private String institutionTypeCode = "";
	private String searchValue = "";
	OpusUserRole opusUserRole;
	
	public StudentFilterBuilder(HttpServletRequest request,
            OpusMethods opusMethods,
            LookupCacher lookupCacher,
            StudyManagerInterface studyManager,
            StudentManagerInterface studentManager) {
		super();
		this.request = request;
		this.opusMethods = opusMethods;
		this.lookupCacher = lookupCacher;
		this.studyManager = studyManager;
		this.studentManager = studentManager;
		session = request.getSession(false);

        preferredLanguage = OpusMethods.getPreferredLanguage(request);
        institutionTypeCode = ServletUtil.getStringValue(session, request, "institutionTypeCode", 
                OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
	}
	
	public void setSubjectBlockMapper(SubjectBlockMapper subjectBlockMapper) {
	       this.subjectBlockMapper = subjectBlockMapper;
	}

    /**
     * Take the values from the given organization and update
     * the filter builder's values accordingly.
     * @param organization
     */
    public void updateFilterBuilder(Organization organization) {

        institutionId = organization.getInstitutionId();
    	branchId = organization.getBranchId();
    	organizationalUnitId = organization.getOrganizationalUnitId();
    }

    /**
     * Update the given organization object with the current values
     * of the filter builder.
     * @param organization
     */
    public void updateOrganization(Organization organization) {

        organization.setInstitutionId(institutionId);
        organization.setBranchId(branchId);
        organization.setOrganizationalUnitId(organizationalUnitId);
    }

    /**
     * Take the values from the given study settings and update
     * the filter builder's values accordingly.
     * @param studySettings
     */
    public void updateFilterBuilder(StudySettings studySettings) {

    	primaryStudyId = studySettings.getStudyId();
        academicYearId = studySettings.getAcademicYearId();
        studyGradeTypeId = studySettings.getStudyGradeTypeId();
        cardinalTimeUnitNumber = studySettings.getCardinalTimeUnitNumber();
    }

    /**
     * Update the given studySettings object with the current values
     * of the filter builder.
     * @param studySettings
     */
    public void updateStudySettings(StudySettings studySettings) {

        studySettings.setStudyId(primaryStudyId);
        studySettings.setAcademicYearId(academicYearId);
        studySettings.setStudyGradeTypeId(studyGradeTypeId);
        studySettings.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
    }
    
    /**
     * This is the old-style initialization of values, without filter form.
     * See initOrganization(), initStudySettings(), ...
     */
	public void initChosenValues() {
	    initChosenValues(false);
	}

	public void initChosenValues(boolean useAcademicYear) {
	    // get the searchValue and put it on the session
        searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");
        if (searchValue != null) {
            searchValue = searchValue.trim();
        }

	    /* fetch chosen institutionId and branchId, otherwise take values from logged on user */
        institutionId = OpusMethods.getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);
        
        branchId = OpusMethods.getBranchId(session, request);
        session.setAttribute("branchId", branchId);
        
        organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);
        
        // remember if study is chosen
        if (request.getParameter("primaryStudyId") != null) {
            primaryStudyId = ServletUtil.getParamSetAttrAsInt(request, "primaryStudyId", 0);
            
        } else if (session.getAttribute("primaryStudyId") != null) {
            primaryStudyId = (Integer) session.getAttribute("primaryStudyId");
        }
        session.setAttribute("primaryStudyId", primaryStudyId);
        
        if (useAcademicYear) {
            academicYearId = ServletUtil.getIntValue(session, request, "academicYearId", 0);
            session.setAttribute("academicYearId", academicYearId);
        }

        if (request.getParameter("studyGradeTypeId") != null) {
        	studyGradeTypeId = ServletUtil.getParamSetAttrAsInt(request, "studyGradeTypeId", 0);
            
        } else if (session.getAttribute("studyGradeTypeId") != null) {
        	studyGradeTypeId = (Integer) session.getAttribute("studyGradeTypeId");
        }
        session.setAttribute("studyGradeTypeId", studyGradeTypeId);        

        subjectBlockId = ServletUtil.getIntValue(session, request, "subjectBlockId", 0);
        session.setAttribute("subjectBlockId", subjectBlockId);
        
        if (request.getParameter("cardinalTimeUnitNumber") != null) {
        	cardinalTimeUnitNumber = ServletUtil.getParamSetAttrAsInt(request, "cardinalTimeUnitNumber", 0);
            
        } else if (session.getAttribute("cardinalTimeUnitNumber") != null) {
        	cardinalTimeUnitNumber = (Integer) session.getAttribute("cardinalTimeUnitNumber");
        }
        session.setAttribute("cardinalTimeUnitNumber", cardinalTimeUnitNumber);        
        
        if (request.getParameter("studentStatusCode") != null) {
            studentStatusCode = ServletUtil.getParamSetAttrAsString(request, "studentStatusCode", "");
            
        } else if (session.getAttribute("studentStatusCode") != null) {
            studentStatusCode = (String) session.getAttribute("studentStatusCode");
        }
        session.setAttribute("studentStatusCode", studentStatusCode);        
        

        institutionTypeCode = ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode", 
        		OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        
        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 1);
        ServletUtil.getParamSetAttrAsInt(request, "classgroupId", 0);
        
	}
	
	
	public void loadInstitutionBranchOrgUnit() {
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, institutionTypeCode, institutionId
                                    , branchId, organizationalUnitId);
	}

	
	public void doLookups() {
        /* fill lookup-tables with right values */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
	}


	public void loadStudies() {
		loadStudies(null);
	}
	
	public void loadStudies(Map<String, Object> additionalfindParams) {
        // LIST OF STUDIES
        // used to show the name of the primary study of each subject in the overview
        List < ? extends Study > allStudies = null;
        Map<String, Object> findStudiesMap = new HashMap<>();
        if (additionalfindParams != null) {
        	findStudiesMap.putAll(additionalfindParams);
        }

    	findStudiesMap.put("institutionId", institutionId);
    	findStudiesMap.put("branchId", branchId);
    	findStudiesMap.put("organizationalUnitId", organizationalUnitId);
    	findStudiesMap.put("institutionTypeCode", institutionTypeCode);
    	allStudies = studyManager.findStudies(findStudiesMap);
        request.setAttribute("allStudies", allStudies);
        
        // LIST OF STUDIES TO SHOW IN DROP DOWN LIST
        // this cannot be the same list as allStudies, because this
        // list needs to be empty if the organizational unit is not chosen
        List < ? extends Study > dropDownListStudies = null;
        if (organizationalUnitId != 0) {
            dropDownListStudies = allStudies;
        }
        request.setAttribute("dropDownListStudies", dropDownListStudies);
        
        // assert that studyId is in list of available studies, otherwise reset studyId
        // this can happen, if still an 'old' studyId lingers around, while the orgUnitId has been changed in another screen
        if (DomainUtil.getDomainObjectById(dropDownListStudies, primaryStudyId) == null) {
            primaryStudyId = 0;
        }
	}

	public void loadAcademicYears() {
	    List <AcademicYear> allAcademicYears = null;
	    if (primaryStudyId != 0) {
            
            Map<String, Object> map = new HashMap<>();
            map.put("studyId", primaryStudyId);
            
            allAcademicYears = studyManager.findAllAcademicYears(map);
        }
        request.setAttribute("allAcademicYears", allAcademicYears);
        
        // assert that academicYearId is in list of available studies, otherwise reset academicYearId
        // this can happen, if still an 'old' academicYearId lingers around, while the studyId has been changed in another screen
        if (DomainUtil.getDomainObjectById(allAcademicYears, academicYearId) == null) {
            academicYearId = 0;
        }
	}
	
	@SuppressWarnings("unchecked")
    public List <AcademicYear> getAllAcademicYears() {
	    return (List <AcademicYear>) request.getAttribute("allAcademicYears");
	}
	
	public void loadStudyGradeTypes() {
		loadStudyGradeTypes(null);
	}
    public void loadStudyGradeTypes(boolean requireAcademicYear) {
        loadStudyGradeTypes(null, requireAcademicYear);
    }
    public void loadStudyGradeTypes(Map<String, Object> additionalfindParams) {
        loadStudyGradeTypes(additionalfindParams, false);
    }
    public void loadStudyGradeTypes(Map<String, Object> additionalfindParams,
            boolean requireAcademicYear) {
        // LIST OF STUDYGRADEYPES
        List < ? extends StudyGradeType > allStudyGradeTypes = null;
        if (primaryStudyId != 0 &&
                !(requireAcademicYear && academicYearId == 0)) {
            Map<String, Object> findStudyGradeTypesMap = new HashMap<>();
            if (additionalfindParams != null) {
            	findStudyGradeTypesMap.putAll(additionalfindParams);
            }
            findStudyGradeTypesMap.put("studyId", primaryStudyId);
            findStudyGradeTypesMap.put("currentAcademicYearId", academicYearId);
            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
            allStudyGradeTypes = studyManager.findAllStudyGradeTypesForStudy(findStudyGradeTypesMap);
        }
        request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);

        // assert that studyGradeTypeId is in list of available studyGradeTypes, otherwise reset studyGradeTypeId
        // this can happen, if still an 'old' studyGradeTypeId lingers around, while the academicYearId has been changed in another screen
        if (DomainUtil.getDomainObjectById(allStudyGradeTypes, studyGradeTypeId) == null) {
            studyGradeTypeId = 0;
            cardinalTimeUnitNumber = null;
        }
	}

    @SuppressWarnings("unchecked")
    public List <StudyGradeType> getAllStudyGradeTypes() {
        return (List <StudyGradeType>) request.getAttribute("allStudyGradeTypes");
    }

    public void loadSubjectBlocks() {
        loadSubjectBlocks(null);
    }
    public void loadSubjectBlocks(Map<String, Object> additionalfindParams) {
        List < ? extends SubjectBlock > allSubjectBlocks = null;
        if (studyGradeTypeId != 0) {
            allSubjectBlocks = subjectBlockMapper.findAllSubjectBlocksForStudyGradeType(studyGradeTypeId);
        }
        request.setAttribute("allSubjectBlocks", allSubjectBlocks);
    }

	public void loadMaxCardinalTimeUnitNumber() {
        int maxNumberOfCardinalTimeUnits = 0;
        if (studyGradeTypeId != 0) {
        	maxNumberOfCardinalTimeUnits = 
        		studyManager.findNumberOfCardinalTimeUnitsForStudyGradeType(
        				studyGradeTypeId);
        } else {
        	maxNumberOfCardinalTimeUnits = 
        		Integer.parseInt((String) session.getAttribute("iMaxCardinalTimeUnits"));
        }
        request.setAttribute("maxNumberOfCardinalTimeUnits", maxNumberOfCardinalTimeUnits);
	}
	
	public List < ? extends Student > loadStudents(AppConfigManagerInterface appConfigManager, OpusInit opusInit) {
        /* retrieve student domain lookups */
        List < ? extends Student > allStudents = null;
        //allStudents = opusMethods.getAllStudents(session, request);
        Map<String, Object> findStudentsMap = new HashMap<>();
        findStudentsMap.put("institutionId", institutionId);
        if ("finance".equals(opusUserRole.getRole())
        		|| "audit".equals(opusUserRole.getRole())
        			|| "library".equals(opusUserRole.getRole())
        				|| "dos".equals(opusUserRole.getRole())) {
        	findStudentsMap.put("branchId", 0);
        	findStudentsMap.put("organizationalUnitId", 0);
        } else {
        	findStudentsMap.put("branchId", branchId);
        	findStudentsMap.put("organizationalUnitId", organizationalUnitId);
        }
        findStudentsMap.put("institutionTypeCode", institutionTypeCode);
        findStudentsMap.put("studyId", primaryStudyId);
        findStudentsMap.put("studyGradeTypeId", studyGradeTypeId);
        if (cardinalTimeUnitNumber != null && cardinalTimeUnitNumber != 0) {
            findStudentsMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        }
        findStudentsMap.put("studentStatusCode", studentStatusCode);
        findStudentsMap.put("searchValue", searchValue);
        
        int lowestGradeOfSecondarySchoolSubjects  = appConfigManager.getSecondarySchoolSubjectsLowestGrade();
        int highestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsHighestGrade();

    	findStudentsMap.put("defaultMaximumGradePoint", highestGradeOfSecondarySchoolSubjects);
    	findStudentsMap.put("defaultMinimumGradePoint", lowestGradeOfSecondarySchoolSubjects);
        
        // get the total count that apply to the filter criteria
        int studentCount = studentManager.findStudentCount(findStudentsMap);
        request.setAttribute("studentCount", studentCount);

        int currentPageNumber = ServletUtil.getIntParam(request, "currentPageNumber", 1);
        request.setAttribute("currentPageNumber", currentPageNumber);
        int iPaging = opusInit.getPaging();
        findStudentsMap.put("offset", (currentPageNumber - 1) * iPaging);
        findStudentsMap.put("limit", iPaging);

        allStudents = studentManager.findStudents(findStudentsMap);
        request.setAttribute("allStudents", allStudents);
        return allStudents;
	}
	
	public HttpServletRequest getRequest() {
		return request;
	}

	public int getInstitutionId() {
		return institutionId;
	}


	public int getBranchId() {
		return branchId;
	}


	public int getOrganizationalUnitId() {
		return organizationalUnitId;
	}


	public int getPrimaryStudyId() {
		return primaryStudyId;
	}


	public int getStudyGradeTypeId() {
		return studyGradeTypeId;
	}


	public String getInstitutionTypeCode() {
		return institutionTypeCode;
	}


	public Integer getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}


	public String getStudentStatusCode() {
		return studentStatusCode;
	}

    public int getAcademicYearId() {
        return academicYearId;
    }

    public int getSubjectBlockId() {
        return subjectBlockId;
    }

}
