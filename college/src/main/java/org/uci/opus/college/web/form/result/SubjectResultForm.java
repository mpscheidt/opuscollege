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

package org.uci.opus.college.web.form.result;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectResultHistory;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.SubjectResultComment;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.service.result.SubjectResultGenerator;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;

public class SubjectResultForm {

	private NavigationSettings navigationSettings;
	private SubjectResult subjectResult;
	private SubjectResult subjectResultInDb;

	// Student
	private StudyPlanDetail studyPlanDetail;
	private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
	private StudyPlan studyPlan;
	private Student student;

	// Study
	private StudyGradeType studyGradeType;
	private Subject subject;
	private Study study;

	// Staff member
	private IdToStaffMemberMap idToSubjectTeacherMap;
	private StaffMember loggedInStaffMember;

	// Business logic
	private String brsPassing;
	private int percentageTotal;
	private boolean endGradesPerGradeType;
	private String minimumMarkValue;
	private String maximumMarkValue;
	private List<EndGrade> fullEndGradeCommentsForGradeType;
	private List<EndGrade> fullFailGradeCommentsForGradeType;
	private SubjectResultGenerator resultGenerator;

	// Utility
	private SubjectResultFormatter subjectResultFormatter;

	private AuthorizationSubExTest subjectResultAuthorization;
	private Map<String, AuthorizationSubExTest> examinationResultAuthorizationMap;
	private List<SubjectResultHistory> subjectResultHistories;

	private AcademicYear academicYear;
	private IdToObjectMap<SubjectResultComment> idToSubjectResultCommentMap;

	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}

	public void setNavigationSettings(NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	public SubjectResult getSubjectResult() {
		return subjectResult;
	}

	public void setSubjectResult(SubjectResult subjectResult) {
		this.subjectResult = subjectResult;
	}

	public StudyPlanDetail getStudyPlanDetail() {
		return studyPlanDetail;
	}

	public void setStudyPlanDetail(StudyPlanDetail studyPlanDetail) {
		this.studyPlanDetail = studyPlanDetail;
	}

	public StudyPlanCardinalTimeUnit getStudyPlanCardinalTimeUnit() {
		return studyPlanCardinalTimeUnit;
	}

	public void setStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
		this.studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnit;
	}

	public StudyPlan getStudyPlan() {
		return studyPlan;
	}

	public void setStudyPlan(StudyPlan studyPlan) {
		this.studyPlan = studyPlan;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}

	public void setStudyGradeType(StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	public Study getStudy() {
		return study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public String getBrsPassing() {
		return brsPassing;
	}

	public void setBrsPassing(String brsPassing) {
		this.brsPassing = brsPassing;
	}

	public int getPercentageTotal() {
		return percentageTotal;
	}

	public void setPercentageTotal(int percentageTotal) {
		this.percentageTotal = percentageTotal;
	}

	public IdToStaffMemberMap getIdToSubjectTeacherMap() {
		return idToSubjectTeacherMap;
	}

	public void setIdToSubjectTeacherMap(IdToStaffMemberMap idToSubjectTeacherMap) {
		this.idToSubjectTeacherMap = idToSubjectTeacherMap;
	}

	public boolean getEndGradesPerGradeType() {
		return endGradesPerGradeType;
	}

	public void setEndGradesPerGradeType(boolean endGradesPerGradeType) {
		this.endGradesPerGradeType = endGradesPerGradeType;
	}

	public String getMinimumMarkValue() {
		return minimumMarkValue;
	}

	public void setMinimumMarkValue(String minimumMarkValue) {
		this.minimumMarkValue = minimumMarkValue;
	}

	public String getMaximumMarkValue() {
		return maximumMarkValue;
	}

	public void setMaximumMarkValue(String maximumMarkValue) {
		this.maximumMarkValue = maximumMarkValue;
	}

	public SubjectResultFormatter getSubjectResultFormatter() {
		return subjectResultFormatter;
	}

	public void setSubjectResultFormatter(SubjectResultFormatter subjectResultFormatter) {
		this.subjectResultFormatter = subjectResultFormatter;
	}

	public List<EndGrade> getFullEndGradeCommentsForGradeType() {
		return fullEndGradeCommentsForGradeType;
	}

	public void setFullEndGradeCommentsForGradeType(List<EndGrade> fullEndGradeCommentsForGradeType) {
		this.fullEndGradeCommentsForGradeType = fullEndGradeCommentsForGradeType;
	}

	public List<EndGrade> getFullFailGradeCommentsForGradeType() {
		return fullFailGradeCommentsForGradeType;
	}

	public void setFullFailGradeCommentsForGradeType(List<EndGrade> fullFailGradeCommentsForGradeType) {
		this.fullFailGradeCommentsForGradeType = fullFailGradeCommentsForGradeType;
	}

	// public List<EndGrade> getFullAREndGradeCommentsForGradeType() {
	// return fullAREndGradeCommentsForGradeType;
	// }
	//
	// public void setFullAREndGradeCommentsForGradeType(List<EndGrade>
	// fullAREndGradeCommentsForGradeType) {
	// this.fullAREndGradeCommentsForGradeType =
	// fullAREndGradeCommentsForGradeType;
	// }
	//
	// public List<EndGrade> getFullARFailGradeCommentsForGradeType() {
	// return fullARFailGradeCommentsForGradeType;
	// }
	//
	// public void setFullARFailGradeCommentsForGradeType(List<EndGrade>
	// fullARFailGradeCommentsForGradeType) {
	// this.fullARFailGradeCommentsForGradeType =
	// fullARFailGradeCommentsForGradeType;
	// }

	public StaffMember getLoggedInStaffMember() {
		return loggedInStaffMember;
	}

	public void setLoggedInStaffMember(StaffMember loggedInStaffMember) {
		this.loggedInStaffMember = loggedInStaffMember;
	}

	public SubjectResult getSubjectResultInDb() {
		return subjectResultInDb;
	}

	public void setSubjectResultInDb(SubjectResult subjectResultInDb) {
		this.subjectResultInDb = subjectResultInDb;
	}

	public Map<String, AuthorizationSubExTest> getExaminationResultAuthorizationMap() {
		return examinationResultAuthorizationMap;
	}

	public void setExaminationResultAuthorizationMap(
			Map<String, AuthorizationSubExTest> examinationResultAuthorizationMap) {
		this.examinationResultAuthorizationMap = examinationResultAuthorizationMap;
	}

	public AuthorizationSubExTest getSubjectResultAuthorization() {
		return subjectResultAuthorization;
	}

	public void setSubjectResultAuthorization(AuthorizationSubExTest subjectResultAuthorization) {
		this.subjectResultAuthorization = subjectResultAuthorization;
	}

	public SubjectResultGenerator getResultGenerator() {
		return resultGenerator;
	}

	public void setResultGenerator(SubjectResultGenerator resultGenerator) {
		this.resultGenerator = resultGenerator;
	}

	public AcademicYear getAcademicYear() {
		return academicYear;
	}

	public List<SubjectResultHistory> getSubjectResultHistories() {
		return subjectResultHistories;
	}

	public void setSubjectResultHistories(List<SubjectResultHistory> subjectResultHistories) {
		this.subjectResultHistories = subjectResultHistories;
	}

	public void setAcademicYear(AcademicYear academicYear) {
		this.academicYear = academicYear;
	}

	public IdToObjectMap<SubjectResultComment> getIdToSubjectResultCommentMap() {
		return idToSubjectResultCommentMap;
	}

	public void setIdToSubjectResultCommentMap(IdToObjectMap<SubjectResultComment> idToSubjectResultCommentMap) {
		this.idToSubjectResultCommentMap = idToSubjectResultCommentMap;
	}

}
