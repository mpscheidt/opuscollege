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

package org.uci.opus.college.web.form;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.flow.person.StudentPerformanceFilter;
import org.uci.opus.college.web.flow.person.TimeUnitAndAcademicYear;
import org.uci.opus.util.AcademicYearUtil;
import org.uci.opus.util.CodeToLookupMap;

public class TransferStudentsForm {

    private Organization organization;
    private StudySettings studySettings;
    private List<Student> allStudents;
    private List<Integer> selectedStudyPlanCTUIds;
    private boolean checker;
    private int ctuSuccessOptionKey;
    private Map<Integer, StudentPerformanceFilter> ctuSuccessOptions;
    private Map<String, TimeUnitAndAcademicYear> progressStatusToTimeUnitMap;
    
    private StudyGradeType studyGradeType;

    // maps with key=studyPlanCTUid, i.e. the row id in the table
    private Map<Integer, String> progressStatusCodes = new HashMap<>();
    private Map<Integer, Integer> targetAcademicYearIds = new HashMap<>();
    private Map<Integer, Integer> targetStudyGradeTypeIds = new HashMap<>();
    private Map<Integer, StudyGradeType> firstChoiceStudyGradeTypes = new HashMap<>();
    private Map<Integer, StudyGradeType> secondChoiceStudyGradeTypes = new HashMap<>();
    private Map<Integer, StudyGradeType> thirdChoiceStudyGradeTypes = new HashMap<>();

    //    The following doesn't work yet due to a bug in Spring 3.0.5
//    (fixed in Spring 3.1.M2, see:
//     https://jira.springsource.org/browse/SPR-7839?page=com.atlassian.jira.plugin.system.issuetabpanels%3Aall-tabpanel)
//    Therefore need to use maps for individual properties (progressStatusCodes)
//    instead of entire studyPlanCardinalTimeUnits with nested objects
//    private Map<Integer, StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = new HashMap<Integer, StudyPlanCardinalTimeUnit>();

    // lists
    private List < ? extends AcademicYear > allAcademicYears;
    private List < ? extends AcademicYear > allTargetAcademicYears;
    private List < ? extends Lookup7 > allProgressStatuses;
    private List < ? extends StudyGradeType > allStudyGradeTypes;

    // utility
    private IdToAcademicYearMap idToAcademicYearMap;
    private IdToOrganizationalUnitMap idToOrganizationalUnitMap;
    private CodeToLookupMap codeToProgressStatusMap;
    private CtuResultFormatter ctuResultFormatter;
    private IdToStudyGradeTypeMap idToStudyGradeTypeMap;
    private IdToStudyMap idToStudyMap;
    private CodeToLookupMap codeToStudyTimeMap;
    private CodeToLookupMap codeToStudyFormMap;

    List < EndGrade > fullEndGradeCommentsForGradeType = null;

    public TransferStudentsForm() {
    }

    public void setSelectedStudyPlanCTUIds(List<Integer> selectedStudyPlanCTUIds) {
        if (selectedStudyPlanCTUIds == null) return;
        this.selectedStudyPlanCTUIds = selectedStudyPlanCTUIds;
    }

    public List<Integer> getSelectedStudyPlanCTUIds() {
        return selectedStudyPlanCTUIds;
    }

    public void setChecker(boolean checker) {
        this.checker = checker;
    }

    public boolean isChecker() {
        return checker;
    }

    public void setProgressStatusCodes(Map<Integer, String> progressStatusCodes) {
        this.progressStatusCodes = progressStatusCodes;
    }

    public Map<Integer, String> getProgressStatusCodes() {
        return progressStatusCodes;
    }

    public void setCtuSuccessOptions(Map<Integer, StudentPerformanceFilter> ctuSuccessOptions) {
        this.ctuSuccessOptions = ctuSuccessOptions;
    }

    public Map<Integer, StudentPerformanceFilter> getCtuSuccessOptions() {
        return ctuSuccessOptions;
    }

    public void setCtuSuccessOptionKey(int ctuSuccessOptionKey) {
        this.ctuSuccessOptionKey = ctuSuccessOptionKey;
    }

    public int getCtuSuccessOptionKey() {
        return ctuSuccessOptionKey;
    }

    public void setProgressStatusToTimeUnitMap(
            Map<String, TimeUnitAndAcademicYear> progressStatusToTimeUnitMap) {
        this.progressStatusToTimeUnitMap = progressStatusToTimeUnitMap;
    }

    public Map<String, TimeUnitAndAcademicYear> getProgressStatusToTimeUnitMap() {
        return progressStatusToTimeUnitMap;
    }

    public void setAllAcademicYears(List < ? extends AcademicYear > allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }  

    public List < ? extends AcademicYear > getAllAcademicYears() {
        return allAcademicYears;
    }
    
    public List <AcademicYear > getNextAcademicYears() {
        
    	List<AcademicYear> nextAcademicYears = null;
    	AcademicYear academicYear = null;
    	if (studySettings.getAcademicYearId() != 0) {
    		academicYear = AcademicYearUtil.getAcademicYearById(allAcademicYears, studySettings.getAcademicYearId());
    	}
    	if (academicYear != null) {
    		nextAcademicYears = AcademicYearUtil.getNextAcademicYears(allAcademicYears, academicYear);
    	}
    	return nextAcademicYears;
    }

    public void setAllProgressStatuses(List < ? extends Lookup7 > allProgressStatuses) {
        this.allProgressStatuses = allProgressStatuses;
    }

    public List < ? extends Lookup7 > getAllProgressStatuses() {
        return allProgressStatuses;
    }

    public void setCodeToProgressStatusMap(CodeToLookupMap codeToProgressStatusMap) {
        this.codeToProgressStatusMap = codeToProgressStatusMap;
    }

    public CodeToLookupMap getCodeToProgressStatusMap() {
        return codeToProgressStatusMap;
    }

    public void setAllStudents(List<Student> allStudents) {
        this.allStudents = allStudents;
    }

    public List<Student> getAllStudents() {
        return allStudents;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public StudySettings getStudySettings() {
        return studySettings;
    }

    public void setStudySettings(StudySettings studySettings) {
        this.studySettings = studySettings;
    }

	public Map<Integer, Integer> getTargetAcademicYearIds() {
		return targetAcademicYearIds;
	}

	public void setTargetAcademicYearIds(Map<Integer, Integer> targetAcademicYearIds) {
		this.targetAcademicYearIds = targetAcademicYearIds;
	}

	public IdToAcademicYearMap getIdToAcademicYearMap() {
		return idToAcademicYearMap;
	}

	public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
		this.idToAcademicYearMap = idToAcademicYearMap;
	}

    public CtuResultFormatter getCtuResultFormatter() {
        return ctuResultFormatter;
    }

    public void setCtuResultFormatter(CtuResultFormatter ctuResultFormatter) {
        this.ctuResultFormatter = ctuResultFormatter;
    }

    public Map<Integer, Integer> getTargetStudyGradeTypeIds() {
        return targetStudyGradeTypeIds;
    }

    public void setTargetStudyGradeTypeIds(Map<Integer, Integer> targetStudyGradeTypeIds) {
        this.targetStudyGradeTypeIds = targetStudyGradeTypeIds;
    }

    public Map<Integer, StudyGradeType> getFirstChoiceStudyGradeTypes() {
        return firstChoiceStudyGradeTypes;
    }

    public void setFirstChoiceStudyGradeTypes(
            Map<Integer, StudyGradeType> firstChoiceStudyGradeTypes) {
        this.firstChoiceStudyGradeTypes = firstChoiceStudyGradeTypes;
    }

	public Map<Integer, StudyGradeType> getSecondChoiceStudyGradeTypes() {
        return secondChoiceStudyGradeTypes;
    }

    public void setSecondChoiceStudyGradeTypes(
            Map<Integer, StudyGradeType> secondChoiceStudyGradeTypes) {
        this.secondChoiceStudyGradeTypes = secondChoiceStudyGradeTypes;
    }

    public Map<Integer, StudyGradeType> getThirdChoiceStudyGradeTypes() {
        return thirdChoiceStudyGradeTypes;
    }

    public void setThirdChoiceStudyGradeTypes(
            Map<Integer, StudyGradeType> thirdChoiceStudyGradeTypes) {
        this.thirdChoiceStudyGradeTypes = thirdChoiceStudyGradeTypes;
    }

    public List<? extends StudyGradeType> getAllStudyGradeTypes() {
        return allStudyGradeTypes;
    }

    public void setAllStudyGradeTypes(
            List<? extends StudyGradeType> allStudyGradeTypes) {
        this.allStudyGradeTypes = allStudyGradeTypes;
    }

    public IdToStudyGradeTypeMap getIdToStudyGradeTypeMap() {
        return idToStudyGradeTypeMap;
    }

    public void setIdToStudyGradeTypeMap(IdToStudyGradeTypeMap idToStudyGradeTypeMap) {
        this.idToStudyGradeTypeMap = idToStudyGradeTypeMap;
    }

	/**
	 * @return the fullEndGradeCommentsForGradeType
	 */
	public List<EndGrade> getFullEndGradeCommentsForGradeType() {
		return fullEndGradeCommentsForGradeType;
	}

	/**
	 * @param fullEndGradeCommentsForGradeType the fullEndGradeCommentsForGradeType to set
	 */
	public void setFullEndGradeCommentsForGradeType(
			final List<EndGrade> fullEndGradeCommentsForGradeType) {
		this.fullEndGradeCommentsForGradeType = fullEndGradeCommentsForGradeType;
	}

    public List < ? extends AcademicYear > getAllTargetAcademicYears() {
        return allTargetAcademicYears;
    }

    public void setAllTargetAcademicYears(List < ? extends AcademicYear > allTargetAcademicYears) {
        this.allTargetAcademicYears = allTargetAcademicYears;
    }

    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }

    public void setStudyGradeType(StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }

	public IdToOrganizationalUnitMap getIdToOrganizationalUnitMap() {
		return idToOrganizationalUnitMap;
	}

	public void setIdToOrganizationalUnitMap(
			IdToOrganizationalUnitMap idToOrganizationalUnitMap) {
		this.idToOrganizationalUnitMap = idToOrganizationalUnitMap;
	}

	public IdToStudyMap getIdToStudyMap() {
		return idToStudyMap;
	}

	public void setIdToStudyMap(IdToStudyMap idToStudyMap) {
		this.idToStudyMap = idToStudyMap;
	}

	public CodeToLookupMap getCodeToStudyTimeMap() {
		return codeToStudyTimeMap;
	}

	public void setCodeToStudyTimeMap(CodeToLookupMap codeToStudyTimeMap) {
		this.codeToStudyTimeMap = codeToStudyTimeMap;
	}

	public CodeToLookupMap getCodeToStudyFormMap() {
		return codeToStudyFormMap;
	}

	public void setCodeToStudyFormMap(CodeToLookupMap codeToStudyFormMap) {
		this.codeToStudyFormMap = codeToStudyFormMap;
	}
	
	



}
