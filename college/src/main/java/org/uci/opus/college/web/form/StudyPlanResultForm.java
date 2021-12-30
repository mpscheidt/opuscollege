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
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.web.extpoint.CtuResultFormatter;
import org.uci.opus.college.web.extpoint.StudyPlanResultFormatter;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.extpoint.ThesisResultFormatter;
import org.uci.opus.util.CodeToLookupMap;

public class StudyPlanResultForm {

	private NavigationSettings navigationSettings;

	private String txtMsg;

	private StudyPlanResult studyPlanResultInDb;
	private StudyPlan studyPlan;
	private Student student;
	private Study study;

	private String brsPassing;
	private String endGradesPerGradeType;
	private String minimumGradeStudyPlan = "";
    private String maximumGradeStudyPlan = "";
    private String minimumGradeThesis = "";
    private String maximumGradeThesis = "";
    private String minimumMarkValueStudyPlan = "";
    private String maximumMarkValueStudyPlan = "";
    private String minimumMarkValueThesis = "";
    private String maximumMarkValueThesis = "";

//    private Map<Integer, Boolean> resultsVisibleToStudentsMap = new HashMap<Integer, Boolean>();
    private boolean resultsVisibleToStudentsForStudyPlan;

    private List < ? extends StudyPlanCardinalTimeUnit > allStudyPlanCardinalTimeUnits = null;
    private List < CardinalTimeUnitResult > allCardinalTimeUnitResults;
//    private List < ? extends SubjectResult > allSubjectResultsForStudyPlan = null;
	private List < ? extends AcademicYear> allAcademicYears;
 	private List < ? extends StudyPlan > allStudyPlansForStudent = null;
	private List < ? extends StudyPlanDetail > allStudyPlanDetails = null;
	private List < ? extends Study > allStudies;
    private List < ? extends StudyGradeType > allStudyGradeTypes; 
	private List < ? extends Subject > allSubjects = null;
    private List < ? extends SubjectBlock > allSubjectBlocks = null;
    private List < ? extends SubjectStudyGradeType > allSubjectStudyGradeTypes = null;
    private List < ? extends SubjectBlockStudyGradeType > allSubjectBlockStudyGradeTypes = null;
    private List < ? extends SubjectSubjectBlock > allSubjectSubjectBlocks = null;
    private List < ? extends EndGrade > allEndGradesStudyPlan = null;
    private List < ? extends EndGrade > allEndGradesThesis = null;

    private StudyPlanResultFormatter studyPlanResultFormatter;
    private ThesisResultFormatter thesisResultFormatter;
    private CtuResultFormatter ctuResultFormatter;
    private SubjectResultFormatter subjectResultFormatter;

    private List<EndGrade> fullEndGradeCommentsForGradeType = null;
    private List<EndGrade> fullFailGradeCommentsForGradeType = null;

    private Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap;  // map "spdId-subjectId" to Authorization object
    private Map<Integer, Authorization> cardinalTimeUnitResultAuthorizationMap; // map spctuId to Authorization object

    private List<Lookup9> allGradeTypes;
    private CodeToLookupMap codeToGradeTypeMap;
    private List<Lookup> allStudyPlanStatuses;
    private CodeToLookupMap codeToStudyPlanStatusMap;
    private List<Lookup> allCardinalTimeUnitStatuses;
    private CodeToLookupMap codeToCardinalTimeUnitStatusMap;
    private List<Lookup7> allProgressStatuses;
    private CodeToLookupMap codeToProgressStatusMap;
    private List<Lookup8> allCardinalTimeUnits;
    private CodeToLookupMap codeToCardinalTimeUnitMap;
    private List<Lookup> allRigidityTypes;
    private CodeToLookupMap codeToRigidityTypeMap;
    private List<Lookup> allImportanceTypes;
    private CodeToLookupMap codeToImportanceTypeMap;

    private boolean userIsStudent;
    private int acadmicYearIdOfLastCTU; // the id of the last time unit of the study plan

    /* extra - attachment results */
    private List < EndGrade > fullAREndGradeCommentsForGradeType = null;


	public StudyPlanResultForm() {
		txtMsg = "";
		endGradesPerGradeType = "N";
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
	 * @return the minimumGradeStudyPlan
	 */
	public String getMinimumGradeStudyPlan() {
		return minimumGradeStudyPlan;
	}

	/**
	 * @param minimumGradeStudyPlan the minimumGradeStudyPlan to set
	 */
	public void setMinimumGradeStudyPlan(final String minimumGradeStudyPlan) {
		this.minimumGradeStudyPlan = minimumGradeStudyPlan;
	}

	/**
	 * @return the maximumGradeStudyPlan
	 */
	public String getMaximumGradeStudyPlan() {
		return maximumGradeStudyPlan;
	}

	/**
	 * @param maximumGradeStudyPlan the maximumGradeStudyPlan to set
	 */
	public void setMaximumGradeStudyPlan(final String maximumGradeStudyPlan) {
		this.maximumGradeStudyPlan = maximumGradeStudyPlan;
	}

	/**
	 * @return the minimumGradeThesis
	 */
	public String getMinimumGradeThesis() {
		return minimumGradeThesis;
	}

	/**
	 * @param minimumGradeThesis the minimumGradeThesis to set
	 */
	public void setMinimumGradeThesis(final String minimumGradeThesis) {
		this.minimumGradeThesis = minimumGradeThesis;
	}

	/**
	 * @return the maximumGradeThesis
	 */
	public String getMaximumGradeThesis() {
		return maximumGradeThesis;
	}

	/**
	 * @param maximumGradeThesis the maximumGradeThesis to set
	 */
	public void setMaximumGradeThesis(final String maximumGradeThesis) {
		this.maximumGradeThesis = maximumGradeThesis;
	}

	/**
	 * @return the minimumMarkValueStudyPlan
	 */
	public String getMinimumMarkValueStudyPlan() {
		return minimumMarkValueStudyPlan;
	}

	/**
	 * @param minimumMarkValueStudyPlan the minimumMarkValueStudyPlan to set
	 */
	public void setMinimumMarkValueStudyPlan(final String minimumMarkValueStudyPlan) {
		this.minimumMarkValueStudyPlan = minimumMarkValueStudyPlan;
	}

	/**
	 * @return the maximumMarkValueStudyPlan
	 */
	public String getMaximumMarkValueStudyPlan() {
		return maximumMarkValueStudyPlan;
	}

	/**
	 * @param maximumMarkValueStudyPlan the maximumMarkValueStudyPlan to set
	 */
	public void setMaximumMarkValueStudyPlan(final String maximumMarkValueStudyPlan) {
		this.maximumMarkValueStudyPlan = maximumMarkValueStudyPlan;
	}

	/**
	 * @return the minimumMarkValueThesis
	 */
	public String getMinimumMarkValueThesis() {
		return minimumMarkValueThesis;
	}

	/**
	 * @param minimumMarkValueThesis the minimumMarkValueThesis to set
	 */
	public void setMinimumMarkValueThesis(final String minimumMarkValueThesis) {
		this.minimumMarkValueThesis = minimumMarkValueThesis;
	}

	/**
	 * @return the maximumMarkValueThesis
	 */
	public String getMaximumMarkValueThesis() {
		return maximumMarkValueThesis;
	}

	/**
	 * @param maximumMarkValueThesis the maximumMarkValueThesis to set
	 */
	public void setMaximumMarkValueThesis(final String maximumMarkValueThesis) {
		this.maximumMarkValueThesis = maximumMarkValueThesis;
	}

	/**
	 * @return the allStudyPlanCardinalTimeUnits
	 */
	public List<? extends StudyPlanCardinalTimeUnit> getAllStudyPlanCardinalTimeUnits() {
		return allStudyPlanCardinalTimeUnits;
	}
	/**
	 * @param allStudyPlanCardinalTimeUnits the allStudyPlanCardinalTimeUnits to set
	 */
	public void setAllStudyPlanCardinalTimeUnits(
			final List<? extends StudyPlanCardinalTimeUnit> allStudyPlanCardinalTimeUnits) {
		this.allStudyPlanCardinalTimeUnits = allStudyPlanCardinalTimeUnits;
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
	 * @return the allSubjectResultsForStudyPlan
	 */
//	public List<? extends SubjectResult> getAllSubjectResultsForStudyPlan() {
//		return allSubjectResultsForStudyPlan;
//	}

	/**
	 * @param allSubjectResultsForStudyPlan the allSubjectResultsForStudyPlan to set
	 */
//	@Deprecated
//	public void setAllSubjectResultsForStudyPlan(
//			final List<? extends SubjectResult> allSubjectResultsForStudyPlan) {
//		this.allSubjectResultsForStudyPlan = allSubjectResultsForStudyPlan;
//	}

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
	 * @return the allStudyPlansForStudent
	 */
	public List<? extends StudyPlan> getAllStudyPlansForStudent() {
		return allStudyPlansForStudent;
	}

	/**
	 * @param allStudyPlansForStudent the allStudyPlansForStudent to set
	 */
	public void setAllStudyPlansForStudent(
			final List<? extends StudyPlan> allStudyPlansForStudent) {
		this.allStudyPlansForStudent = allStudyPlansForStudent;
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
	 * @return the allEndGradesThesis
	 */
	public List<? extends EndGrade> getAllEndGradesThesis() {
		return allEndGradesThesis;
	}

	/**
	 * @param allEndGradesThesis the allEndGradesThesis to set
	 */
	public void setAllEndGradesThesis(final List<? extends EndGrade> allEndGradesThesis) {
		this.allEndGradesThesis = allEndGradesThesis;
	}

	/**
	 * @return the studyPlanResultFormatter
	 */
	public StudyPlanResultFormatter getStudyPlanResultFormatter() {
		return studyPlanResultFormatter;
	}

	/**
	 * @param studyPlanResultFormatter the studyPlanResultFormatter to set
	 */
	public void setStudyPlanResultFormatter(
			final StudyPlanResultFormatter studyPlanResultFormatter) {
		this.studyPlanResultFormatter = studyPlanResultFormatter;
	}

	
	/**
	 * @return the thesisResultFormatter
	 */
	public ThesisResultFormatter getThesisResultFormatter() {
		return thesisResultFormatter;
	}

	/**
	 * @param thesisResultFormatter the thesisResultFormatter to set
	 */
	public void setThesisResultFormatter(final ThesisResultFormatter thesisResultFormatter) {
		this.thesisResultFormatter = thesisResultFormatter;
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

//    public Map<Integer, Boolean> getResultsVisibleToStudentsMap() {
//        return resultsVisibleToStudentsMap;
//    }
//
//    public void setResultsVisibleToStudentsMap(Map<Integer, Boolean> resultsVisibleToStudentsMap) {
//        this.resultsVisibleToStudentsMap = resultsVisibleToStudentsMap;
//    }
//
//    public boolean getResultsVisibleToStudents(int studyPlanCardinalTimeUnitId) {
//        return resultsVisibleToStudentsMap.get(studyPlanCardinalTimeUnitId);
//    }
//    
//    public void setResultsVisibleToStudents(int studyPlanCardinalTimeUnitId, boolean resultsVisibleToStudents) {
//        resultsVisibleToStudentsMap.put(studyPlanCardinalTimeUnitId, resultsVisibleToStudents);
//    }

    public boolean isResultsVisibleToStudentsForStudyPlan() {
        return resultsVisibleToStudentsForStudyPlan;
    }

    public void setResultsVisibleToStudentsForStudyPlan(boolean resultsVisibleToStudentsForStudyPlan) {
        this.resultsVisibleToStudentsForStudyPlan = resultsVisibleToStudentsForStudyPlan;
    }

    public Map<String, AuthorizationSubExTest> getSubjectResultAuthorizationMap() {
        return subjectResultAuthorizationMap;
    }

    public void setSubjectResultAuthorizationMap(Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap) {
        this.subjectResultAuthorizationMap = subjectResultAuthorizationMap;
    }

    public Map<Integer, Authorization> getCardinalTimeUnitResultAuthorizationMap() {
        return cardinalTimeUnitResultAuthorizationMap;
    }

    public void setCardinalTimeUnitResultAuthorizationMap(Map<Integer, Authorization> cardinalTimeUnitResultAuthorizationMap) {
        this.cardinalTimeUnitResultAuthorizationMap = cardinalTimeUnitResultAuthorizationMap;
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

    public List<Lookup> getAllStudyPlanStatuses() {
        return allStudyPlanStatuses;
    }

    public void setAllStudyPlanStatuses(List<Lookup> allStudyPlanStatuses) {
        this.allStudyPlanStatuses = allStudyPlanStatuses;
    }

    public CodeToLookupMap getCodeToStudyPlanStatusMap() {
        if (codeToStudyPlanStatusMap == null) {
            codeToStudyPlanStatusMap = new CodeToLookupMap(allStudyPlanStatuses);
        }
        return codeToStudyPlanStatusMap;
    }

    public void setCodeToStudyPlanStatusMap(CodeToLookupMap codeToStudyPlanStatusMap) {
        this.codeToStudyPlanStatusMap = codeToStudyPlanStatusMap;
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

    public List<Lookup> getAllRigidityTypes() {
        return allRigidityTypes;
    }

    public void setAllRigidityTypes(List<Lookup> allRigidityTypes) {
        this.allRigidityTypes = allRigidityTypes;
    }

    public CodeToLookupMap getCodeToRigidityTypeMap() {
        if (codeToRigidityTypeMap == null) {
            codeToRigidityTypeMap = new CodeToLookupMap(allRigidityTypes);
        }
        return codeToRigidityTypeMap;
    }

    public void setCodeToRigidityTypeMap(CodeToLookupMap codeToRigidityTypeMap) {
        this.codeToRigidityTypeMap = codeToRigidityTypeMap;
    }

    public List<Lookup> getAllImportanceTypes() {
        return allImportanceTypes;
    }

    public void setAllImportanceTypes(List<Lookup> allImportanceTypes) {
        this.allImportanceTypes = allImportanceTypes;
    }

    public CodeToLookupMap getCodeToImportanceTypeMap() {
        if (codeToImportanceTypeMap == null) {
            codeToImportanceTypeMap = new CodeToLookupMap(allImportanceTypes);
        }
        return codeToImportanceTypeMap;
    }

    public void setCodeToImportanceTypeMap(CodeToLookupMap codeToImportanceTypeMap) {
        this.codeToImportanceTypeMap = codeToImportanceTypeMap;
    }

    public boolean isUserIsStudent() {
        return userIsStudent;
    }

    public void setUserIsStudent(boolean userIsStudent) {
        this.userIsStudent = userIsStudent;
    }

    public int getAcadmicYearIdOfLastCTU() {
        return acadmicYearIdOfLastCTU;
    }

    public void setAcadmicYearIdOfLastCTU(int acadmicYearIdOfLastCTU) {
        this.acadmicYearIdOfLastCTU = acadmicYearIdOfLastCTU;
    }

    public StudyPlanResult getStudyPlanResultInDb() {
        return studyPlanResultInDb;
    }

    public void setStudyPlanResultInDb(StudyPlanResult studyPlanResultInDb) {
        this.studyPlanResultInDb = studyPlanResultInDb;
    }

}
