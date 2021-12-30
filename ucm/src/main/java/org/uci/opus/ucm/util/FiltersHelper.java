package org.uci.opus.ucm.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

public class FiltersHelper {

    private AcademicYearManagerInterface academicYearManager;
    private SubjectManagerInterface subjectManager;
    private StudyManagerInterface studyManager;
    
    private int institutionId;
    private int branchId;
    private int organizationalUnitId;
    private int primaryStudyId;
    private int studyGradeTypeId;
    private int academicYearId;
    private int subjectBlockId;
    
    
	  public FiltersHelper(AcademicYearManagerInterface academicYearManager,
			SubjectManagerInterface subjectManager
			, StudyManagerInterface studyManager) {
		super();
		this.academicYearManager = academicYearManager;
		this.subjectManager = subjectManager;
		this.studyManager = studyManager;
	}

	/**
     * Builds a parameter map with usual required parameters , institutionId , branchId , primaryStudyId , etc. 
     * Ignores parameters which value is zero
     * @return map with parameters
     */
    public static HashMap<String, Object> makeParameterMap(int institutionId , int branchId , int organizationalUnitId ,
            int primaryStudyId , int studyGradeTypeId ,
            int academicYearId , int subjectBlockId) {

        HashMap<String, Object> parameterMap = new HashMap<>(); 
        if (institutionId != 0) {
            parameterMap.put("institutionId" , institutionId);
        }
        if (branchId != 0) {
            parameterMap.put("branchId" , branchId);
        }
        if (organizationalUnitId != 0) {
            parameterMap.put("organizationalUnitId" , organizationalUnitId);
        }
        if (primaryStudyId != 0) {
            parameterMap.put("studyId" , primaryStudyId);
        }
        if (studyGradeTypeId != 0) {
            parameterMap.put("studyGradeTypeId" , studyGradeTypeId);
        }
        if (academicYearId != 0) {
            parameterMap.put("academicYearId", academicYearId);
        }
        if (subjectBlockId != 0) {
            parameterMap.put("subjectBlockId", subjectBlockId);
        }

        return parameterMap;
    }

    public HashMap<String, Object> loadAndMakeParameterMap(StudentFilterBuilder fb , 
            HttpServletRequest request , 
            HttpSession session ,
            Map<String, Object> additionalFindParams) {
        HashMap<String, Object> parameterMap;

        fb.initChosenValues(true);      // this remembers all filter selections in the session
        fb.doLookups();
        fb.loadStudies(additionalFindParams);        
        fb.loadStudyGradeTypes(additionalFindParams, true);
        fb.loadSubjectBlocks(additionalFindParams);
        
        
        institutionId = fb.getInstitutionId();
        branchId = fb.getBranchId();
        organizationalUnitId = fb.getOrganizationalUnitId();
        primaryStudyId = fb.getPrimaryStudyId();
        academicYearId = fb.getAcademicYearId();
        studyGradeTypeId = fb.getStudyGradeTypeId();
        subjectBlockId = fb.getSubjectBlockId();
//        studyYearId = fb.getStudyYearId();
//        academicYear = ServletUtil.getParamSetAttrAsString(request,
//                "academicYear", "0");
//        int academicYearId = ServletUtil.getParamSetAttrAsInt(request,
//                "academicYearId", 0);
//        registrationYear = ServletUtil.getParamSetAttrAsInt(request,
//                "registrationYear", 0);

        fb.loadInstitutionBranchOrgUnit();        
        
        String gradeTypeCode = ServletUtil.getStringValue(session, request, "gradeTypeCode");
        String progressStatusCode = ServletUtil.getStringValue(session, request, "progressStatusCode");
        String studyPlanStatusCode = ServletUtil.getStringValue(session, request, "studyPlanStatusCode");
        String genderCode = ServletUtil.getStringValue(session, request, "genderCode");
        
        int cardinalTimeUnitNumber = ServletUtil.getIntValueSetOnSession(session, request,"cardinalTimeUnitNumber" ,0);
        
        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());
        
        academicYearId = ServletUtil.getParamSetAttrAsInt(request, "academicYearId", 0);

        parameterMap = makeParameterMap(institutionId, branchId, organizationalUnitId, primaryStudyId, studyGradeTypeId, academicYearId, subjectBlockId);
        //registration years and academic years are loaded according the values of institution , branch ...

        //some queries use language and some use preferredLanguage
        parameterMap.put("lang", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("preferredLanguage", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("institutionTypeCode", OpusMethods.getInstitutionTypeCode(request));

        List<CardinalTimeUnitStudyGradeType> allCardinalTimeUnitStudyGradeTypes = null;
        if (studyGradeTypeId != 0) {
            allCardinalTimeUnitStudyGradeTypes = studyManager.findCardinalTimeUnitStudyGradeTypes(studyGradeTypeId);
        }
        request.setAttribute("allCardinalTimeUnitStudyGradeTypes", allCardinalTimeUnitStudyGradeTypes);
        
        if(cardinalTimeUnitNumber != 0)
        	parameterMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        
        if (!StringUtil.isNullOrEmpty(gradeTypeCode, true) && !"0".equals(gradeTypeCode)) {
            parameterMap.put("gradeTypeCode", gradeTypeCode);
            request.setAttribute("gradeTypeCode", gradeTypeCode);
            session.setAttribute("gradeTypeCode", gradeTypeCode);
        }
        
        if (!StringUtil.isNullOrEmpty(progressStatusCode, true) && !"0".equals(progressStatusCode)) {
            parameterMap.put("progressStatusCode", progressStatusCode);
            request.setAttribute("progressStatusCode", progressStatusCode);            
        }
        
        if (!StringUtil.isNullOrEmpty(studyPlanStatusCode, true) && !"0".equals(studyPlanStatusCode)) {
            parameterMap.put("studyPlanStatusCode", studyPlanStatusCode);
            request.setAttribute("studyPlanStatusCode", studyPlanStatusCode);            
        }
        
        if (!StringUtil.isNullOrEmpty(genderCode, true) && !"0".equals(genderCode)) {
            parameterMap.put("genderCode", genderCode);
            request.setAttribute("genderCode", genderCode);            
        }

        if ((additionalFindParams != null) && (!additionalFindParams.isEmpty())) {
            parameterMap.putAll(additionalFindParams);
        }

        return parameterMap;
    }

	public AcademicYearManagerInterface getAcademicYearManager() {
		return academicYearManager;
	}

	public void setAcademicYearManager(
			AcademicYearManagerInterface academicYearManager) {
		this.academicYearManager = academicYearManager;
	}

	public SubjectManagerInterface getSubjectManager() {
		return subjectManager;
	}

	public void setSubjectManager(SubjectManagerInterface subjectManager) {
		this.subjectManager = subjectManager;
	}

	public StudyManagerInterface getStudyManager() {
		return studyManager;
	}

	public void setStudyManager(StudyManagerInterface studyManager) {
		this.studyManager = studyManager;
	}

}
