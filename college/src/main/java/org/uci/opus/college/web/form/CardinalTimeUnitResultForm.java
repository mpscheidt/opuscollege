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

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Authorization;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.domain.Lookup9;
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
import org.uci.opus.college.domain.SubjectSubjectBlock;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.IdToSubjectMap;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.util.CodeToLookupMap;

public class CardinalTimeUnitResultForm {
	
    private Organization organization;
    private NavigationSettings navigationSettings;
	
    private String txtMsg;
	
    private Student student;
    private Study study;
    private StudyGradeType studyGradeType;
    private StudyPlan studyPlan;
    private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
    private CardinalTimeUnitResult cardinalTimeUnitResultInDb;

    private String brsPassing;
    private String endGradesPerGradeType;
    private String minimumGrade = "";
    private String maximumGrade = "";
    private String minimumMarkValue = "";
    private String maximumMarkValue = "";
    
    private List < CardinalTimeUnitResult > allCardinalTimeUnitResults;
    private List < SubjectResult > allSubjectResultsForStudyPlanCardinalTimeUnit = null;
    private List < ? extends AcademicYear> allAcademicYears;
    private List < ? extends StudyPlanDetail > allStudyPlanDetails = null;
    private List < ? extends Study > allStudies;
    private List < ? extends StudyGradeType > allStudyGradeTypes; 
    private List < ? extends Subject > allSubjects = null;
    private List < ? extends SubjectBlock > allSubjectBlocks = null;
    private List < ? extends SubjectStudyGradeType > allSubjectStudyGradeTypes = null;
    private List < ? extends SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes = null;
    private List < ? extends SubjectSubjectBlock > allSubjectSubjectBlocks = null;
    private List < ? extends EndGrade > allEndGradesStudyPlan = null;

    private IdToSubjectMap idToSubjectMap;

    private List < EndGrade > fullEndGradeCommentsForGradeType = null;
    private List < EndGrade > fullFailGradeCommentsForGradeType = null;
    
    /* extra - attachment results */
    private List < ? extends EndGrade > allAREndGradesStudyPlan = null;
    private List < EndGrade > fullAREndGradeCommentsForGradeType = null;

    private CtuResultFormatter ctuResultFormatter;
    private SubjectResultFormatter subjectResultFormatter;
    
    private List<Lookup9> allGradeTypes;
    private CodeToLookupMap codeToGradeTypeMap;
    private List<Lookup8> allCardinalTimeUnits;
    private CodeToLookupMap codeToCardinalTimeUnitMap;
    private List<Lookup> allCardinalTimeUnitStatuses;
    private CodeToLookupMap codeToCardinalTimeUnitStatusMap;
    private List<Lookup7> allProgressStatuses;
    private CodeToLookupMap codeToProgressStatusMap;

    private Authorization cardinalTimeUnitResultAuthorization;
    private Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap;   // map "spdId-subjectId" to Authorization object


	public CardinalTimeUnitResultForm() {
		txtMsg = "";
		endGradesPerGradeType = "N";
	}

	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}

	/**
	 * @param organization the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}
	
	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	/**
	 * @param navigationSettings the navigationSettings to set
	 */
	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}
	
	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}


	/**
	 * @return the student
	 */
	public Student getStudent() {
		return student;
	}

	/**
	 * @param student the student to set
	 */
	public void setStudent(final Student student) {
		this.student = student;
	}
	
	/**
	 * @return the study
	 */
	public Study getStudy() {
		return study;
	}
	/**
	 * @param study the study to set
	 */
	public void setStudy(final Study study) {
		this.study = study;
	}
	
	/**
	 * @return the studyGradeType
	 */
	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}

	/**
	 * @param studyGradeType the studyGradeType to set
	 */
	public void setStudyGradeType(final StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	/**
	 * @return the studyPlan
	 */
	public StudyPlan getStudyPlan() {
		return studyPlan;
	}

	/**
	 * @param studyPlan the studyPlan to set
	 */
	public void setStudyPlan(final StudyPlan studyPlan) {
		this.studyPlan = studyPlan;
	}

	/**
	 * @return the studyPlanCardinalTimeUnit
	 */
	public StudyPlanCardinalTimeUnit getStudyPlanCardinalTimeUnit() {
		return studyPlanCardinalTimeUnit;
	}

	/**
	 * @param studyPlanCardinalTimeUnit the studyPlanCardinalTimeUnit to set
	 */
	public void setStudyPlanCardinalTimeUnit(
			final StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
		this.studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnit;
	}

	/**
	 * @return the brsPassing
	 */
	public String getBrsPassing() {
		return brsPassing;
	}
	/**
	 * @param brsPassing the brsPassing to set
	 */
	public void setBrsPassing(final String brsPassing) {
		this.brsPassing = brsPassing;
	}

	/**
     * @return the endGradesPerGradeType
     */
    public String getEndGradesPerGradeType() {
        return endGradesPerGradeType;
    }

    /**
     * @param endGradesPerGradeType the endGradesPerGradeType to set
     */
    public void setEndGradesPerGradeType(final String endGradesPerGradeType) {
        this.endGradesPerGradeType = endGradesPerGradeType;
    }

	/**
	 * @return the minimumGrade
	 */
	public String getMinimumGrade() {
		return minimumGrade;
	}

	/**
	 * @param minimumGrade the minimumGrade to set
	 */
	public void setMinimumGrade(final String minimumGrade) {
		this.minimumGrade = minimumGrade;
	}

	/**
	 * @return the maximumGrade
	 */
	public String getMaximumGrade() {
		return maximumGrade;
	}

	/**
	 * @param maximumGrade the maximumGrade to set
	 */
	public void setMaximumGrade(final String maximumGrade) {
		this.maximumGrade = maximumGrade;
	}

	/**
	 * @return the minimumMarkValue
	 */
	public String getMinimumMarkValue() {
		return minimumMarkValue;
	}

	/**
	 * @param minimumMarkValue the minimumMarkValue to set
	 */
	public void setMinimumMarkValue(final String minimumMarkValue) {
		this.minimumMarkValue = minimumMarkValue;
	}

	/**
	 * @return the maximumMarkValue
	 */
	public String getMaximumMarkValue() {
		return maximumMarkValue;
	}

	/**
	 * @param maximumMarkValue the maximumMarkValue to set
	 */
	public void setMaximumMarkValue(final String maximumMarkValue) {
		this.maximumMarkValue = maximumMarkValue;
	}

	/**
	 * @return the allCardinalTimeUnitResults
	 */
	public List<CardinalTimeUnitResult> getAllCardinalTimeUnitResults() {
		return allCardinalTimeUnitResults;
	}

	/**
	 * @param allCardinalTimeUnitResults the allCardinalTimeUnitResults to set
	 */
	public void setAllCardinalTimeUnitResults(
			final List<CardinalTimeUnitResult> allCardinalTimeUnitResults) {
		this.allCardinalTimeUnitResults = allCardinalTimeUnitResults;
	}

	/**
	 * @return the allSubjectResultsForStudyPlanCardinalTimeUnit
	 */
	public List<SubjectResult> getAllSubjectResultsForStudyPlanCardinalTimeUnit() {
		return allSubjectResultsForStudyPlanCardinalTimeUnit;
	}

	/**
	 * @param allSubjectResultsForStudyPlanCardinalTimeUnit the allSubjectResultsForStudyPlanCardinalTimeUnit to set
	 */
	public void setAllSubjectResultsForStudyPlanCardinalTimeUnit(
			final List<SubjectResult> allSubjectResultsForStudyPlanCardinalTimeUnit) {
		this.allSubjectResultsForStudyPlanCardinalTimeUnit = allSubjectResultsForStudyPlanCardinalTimeUnit;
	}

	/**
	 * @return the allAcademicYears
	 */
	public List<? extends AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}

	/**
	 * @param allAcademicYears the allAcademicYears to set
	 */
	public void setAllAcademicYears(
			final List<? extends AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	/**
	 * @return the allStudyPlanDetails
	 */
	public List<? extends StudyPlanDetail> getAllStudyPlanDetails() {
		return allStudyPlanDetails;
	}

	/**
	 * @param allStudyPlanDetails the allStudyPlanDetails to set
	 */
	public void setAllStudyPlanDetails(
			final List<? extends StudyPlanDetail> allStudyPlanDetails) {
		this.allStudyPlanDetails = allStudyPlanDetails;
	}

	/**
	 * @return the allStudies
	 */
	public List<? extends Study> getAllStudies() {
		return allStudies;
	}

	/**
	 * @param allStudies the allStudies to set
	 */
	public void setAllStudies(final List<? extends Study> allStudies) {
		this.allStudies = allStudies;
	}

	/**
	 * @return the allStudyGradeTypes
	 */
	public List<? extends StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	/**
	 * @param allStudyGradeTypes the allStudyGradeTypes to set
	 */
	public void setAllStudyGradeTypes(
			final List<? extends StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}

	/**
	 * @return the allSubjects
	 */
	public List<? extends Subject> getAllSubjects() {
		return allSubjects;
	}

	/**
	 * @param allSubjects the allSubjects to set
	 */
	public void setAllSubjects(final List<? extends Subject> allSubjects) {
		this.allSubjects = allSubjects;
	}

	/**
	 * @return the allSubjectBlocks
	 */
	public List<? extends SubjectBlock> getAllSubjectBlocks() {
		return allSubjectBlocks;
	}

	/**
	 * @param allSubjectBlocks the allSubjectBlocks to set
	 */
	public void setAllSubjectBlocks(
			final List<? extends SubjectBlock> allSubjectBlocks) {
		this.allSubjectBlocks = allSubjectBlocks;
	}

	/**
	 * @return the allSubjectStudyGradeTypes
	 */
	public List<? extends SubjectStudyGradeType> getAllSubjectStudyGradeTypes() {
		return allSubjectStudyGradeTypes;
	}

	/**
	 * @param allSubjectStudyGradeTypes the allSubjectStudyGradeTypes to set
	 */
	public void setAllSubjectStudyGradeTypes(
			final List<? extends SubjectStudyGradeType> allSubjectStudyGradeTypes) {
		this.allSubjectStudyGradeTypes = allSubjectStudyGradeTypes;
	}

	/**
	 * @return the allSubjectBlockStudyGradeTypes
	 */
	public List<? extends SubjectBlockStudyGradeType> getAllSubjectBlockStudyGradeTypes() {
		return allSubjectBlockStudyGradeTypes;
	}

	/**
	 * @param allSubjectBlockStudyGradeTypes the allSubjectBlockStudyGradeTypes to set
	 */
	public void setAllSubjectBlockStudyGradeTypes(
			final List<? extends SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes) {
		this.allSubjectBlockStudyGradeTypes = allSubjectBlockStudyGradeTypes;
	}

	/**
	 * @return the allSubjectSubjectBlocks
	 */
	public List<? extends SubjectSubjectBlock> getAllSubjectSubjectBlocks() {
		return allSubjectSubjectBlocks;
	}

	/**
	 * @param allSubjectSubjectBlocks the allSubjectSubjectBlocks to set
	 */
	public void setAllSubjectSubjectBlocks(
			final List<? extends SubjectSubjectBlock> allSubjectSubjectBlocks) {
		this.allSubjectSubjectBlocks = allSubjectSubjectBlocks;
	}

	/**
	 * @return the allEndGradesStudyPlan
	 */
	public List<? extends EndGrade> getAllEndGradesStudyPlan() {
		return allEndGradesStudyPlan;
	}

	/**
	 * @param allEndGradesStudyPlan the allEndGradesStudyPlan to set
	 */
	public void setAllEndGradesStudyPlan(
			final List<? extends EndGrade> allEndGradesStudyPlan) {
		this.allEndGradesStudyPlan = allEndGradesStudyPlan;
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

	/**
	 * @return the fullFailGradeCommentsForGradeType
	 */
	public List<EndGrade> getFullFailGradeCommentsForGradeType() {
		return fullFailGradeCommentsForGradeType;
	}

	/**
	 * @param fullFailGradeCommentsForGradeType the fullFailGradeCommentsForGradeType to set
	 */
	public void setFullFailGradeCommentsForGradeType(
			final List<EndGrade> fullFailGradeCommentsForGradeType) {
		this.fullFailGradeCommentsForGradeType = fullFailGradeCommentsForGradeType;
	}

	/**
	 * @return the allAREndGradesStudyPlan
	 */
	public List<? extends EndGrade> getAllAREndGradesStudyPlan() {
		return allAREndGradesStudyPlan;
	}

	/**
	 * @param allAREndGradesStudyPlan the allAREndGradesStudyPlan to set
	 */
	public void setAllAREndGradesStudyPlan(
			List<? extends EndGrade> allAREndGradesStudyPlan) {
		this.allAREndGradesStudyPlan = allAREndGradesStudyPlan;
	}

	/**
	 * @return the fullAREndGradeCommentsForGradeType
	 */
	public List<EndGrade> getFullAREndGradeCommentsForGradeType() {
		return fullAREndGradeCommentsForGradeType;
	}

	/**
	 * @param fullAREndGradeCommentsForGradeType the fullAREndGradeCommentsForGradeType to set
	 */
	public void setFullAREndGradeCommentsForGradeType(
			List<EndGrade> fullAREndGradeCommentsForGradeType) {
		this.fullAREndGradeCommentsForGradeType = fullAREndGradeCommentsForGradeType;
	}

	/**
	 * @return the ctuResultFormatter
	 */
	public CtuResultFormatter getCtuResultFormatter() {
		return ctuResultFormatter;
	}

	/**
	 * @param ctuResultFormatter the ctuResultFormatter to set
	 */
	public void setCtuResultFormatter(final CtuResultFormatter ctuResultFormatter) {
		this.ctuResultFormatter = ctuResultFormatter;
	}

	/**
	 * @return the subjectResultFormatter
	 */
	public  SubjectResultFormatter getSubjectResultFormatter() {
		return subjectResultFormatter;
	}

	/**
	 * @param subjectResultFormatter the subjectResultFormatter to set
	 */
	public  void setSubjectResultFormatter(
			final SubjectResultFormatter subjectResultFormatter) {
		this.subjectResultFormatter = subjectResultFormatter;
	}

    public CardinalTimeUnitResult getCardinalTimeUnitResultInDb() {
        return cardinalTimeUnitResultInDb;
    }

    public void setCardinalTimeUnitResultInDb(CardinalTimeUnitResult cardinalTimeUnitResultInDb) {
        this.cardinalTimeUnitResultInDb = cardinalTimeUnitResultInDb;
    }

    public List<Lookup9> getAllGradeTypes() {
        return allGradeTypes;
    }

    public void setAllGradeTypes(List<Lookup9> allGradeTypes) {
        this.allGradeTypes = allGradeTypes;
    }

    public CodeToLookupMap getCodeToGradeTypeMap() {
        if (codeToGradeTypeMap == null) {
            codeToGradeTypeMap = new CodeToLookupMap(allGradeTypes);
        }
        return codeToGradeTypeMap;
    }

    public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
        this.codeToGradeTypeMap = codeToGradeTypeMap;
    }

    public List<Lookup8> getAllCardinalTimeUnits() {
        return allCardinalTimeUnits;
    }

    public void setAllCardinalTimeUnits(List<Lookup8> allCardinalTimeUnits) {
        this.allCardinalTimeUnits = allCardinalTimeUnits;
    }

    public CodeToLookupMap getCodeToCardinalTimeUnitMap() {
        if (codeToCardinalTimeUnitMap == null) {
            codeToCardinalTimeUnitMap = new CodeToLookupMap(allCardinalTimeUnits);
        }
        return codeToCardinalTimeUnitMap;
    }

    public void setCodeToCardinalTimeUnitMap(CodeToLookupMap codeToCardinalTimeUnitMap) {
        this.codeToCardinalTimeUnitMap = codeToCardinalTimeUnitMap;
    }

    public List<Lookup> getAllCardinalTimeUnitStatuses() {
        return allCardinalTimeUnitStatuses;
    }

    public void setAllCardinalTimeUnitStatuses(List<Lookup> allCardinalTimeUnitStatuses) {
        this.allCardinalTimeUnitStatuses = allCardinalTimeUnitStatuses;
    }

    public CodeToLookupMap getCodeToCardinalTimeUnitStatusMap() {
        if (codeToCardinalTimeUnitStatusMap == null) {
            codeToCardinalTimeUnitStatusMap = new CodeToLookupMap(allCardinalTimeUnitStatuses);
        }
        return codeToCardinalTimeUnitStatusMap;
    }

    public void setCodeToCardinalTimeUnitStatusMap(CodeToLookupMap codeToCardinalTimeUnitStatusMap) {
        this.codeToCardinalTimeUnitStatusMap = codeToCardinalTimeUnitStatusMap;
    }

    public List<Lookup7> getAllProgressStatuses() {
        return allProgressStatuses;
    }

    public void setAllProgressStatuses(List<Lookup7> allProgressStatuses) {
        this.allProgressStatuses = allProgressStatuses;
    }

    public CodeToLookupMap getCodeToProgressStatusMap() {
        if (codeToProgressStatusMap == null) {
            codeToProgressStatusMap = new CodeToLookupMap(allProgressStatuses);
        }
        return codeToProgressStatusMap;
    }

    public void setCodeToProgressStatusMap(CodeToLookupMap codeToProgressStatusMap) {
        this.codeToProgressStatusMap = codeToProgressStatusMap;
    }

    public IdToSubjectMap getIdToSubjectMap() {
        if (idToSubjectMap == null) {
            idToSubjectMap = new IdToSubjectMap(allSubjects);
        }
        return idToSubjectMap;
    }

    public void setIdToSubjectMap(IdToSubjectMap idToSubjectMap) {
        this.idToSubjectMap = idToSubjectMap;
    }

    public Map<String, AuthorizationSubExTest> getSubjectResultAuthorizationMap() {
        return subjectResultAuthorizationMap;
    }

    public void setAuthorizationMap(Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap) {
        this.subjectResultAuthorizationMap = subjectResultAuthorizationMap;
    }

    public Authorization getCardinalTimeUnitResultAuthorization() {
        return cardinalTimeUnitResultAuthorization;
    }

    public void setCardinalTimeUnitResultAuthorization(Authorization cardinalTimeUnitResultAuthorization) {
        this.cardinalTimeUnitResultAuthorization = cardinalTimeUnitResultAuthorization;
    }

}
