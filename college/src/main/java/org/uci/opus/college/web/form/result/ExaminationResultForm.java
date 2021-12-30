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

import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationResultHistory;
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
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.form.NavigationSettings;

public class ExaminationResultForm {

    private NavigationSettings navigationSettings;
    private ExaminationResult examinationResult;
    
    private Examination examination;
    private Subject subject;
    private Study study;
    private StudyPlanDetail studyPlanDetail;
    private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
    private StudyPlan studyPlan;
    private Student student;
    private StudyGradeType studyGradeType;
    private IdToStaffMemberMap idToExaminationTeacherMap;
    private String brsPassing;
    private int percentageTotal;
    private String minimumMarkValue;
    private String maximumMarkValue;
    private List<ExaminationResultHistory> examinationResultHistories;
    private IdToObjectMap<ExaminationResultComment> idToExaminationResultCommentMap;
    
    private int subjectResultId;

    private StaffMember loggedInStaffMember;

    private AuthorizationSubExTest examinationResultAuthorization;

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public ExaminationResult getExaminationResult() {
        return examinationResult;
    }

    public void setExaminationResult(ExaminationResult examinationResult) {
        this.examinationResult = examinationResult;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
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

    public StudyGradeType getStudyGradeType() {
        return studyGradeType;
    }

    public void setStudyGradeType(StudyGradeType studyGradeType) {
        this.studyGradeType = studyGradeType;
    }

    public IdToStaffMemberMap getIdToExaminationTeacherMap() {
        return idToExaminationTeacherMap;
    }

    public void setIdToExaminationTeacherMap(IdToStaffMemberMap idToExaminationTeacherMap) {
        this.idToExaminationTeacherMap = idToExaminationTeacherMap;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public String getBrsPassing() {
        return brsPassing;
    }

    public void setBrsPassing(String brsPassing) {
        this.brsPassing = brsPassing;
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

    public StaffMember getLoggedInStaffMember() {
        return loggedInStaffMember;
    }

    public void setLoggedInStaffMember(StaffMember loggedInStaffMember) {
        this.loggedInStaffMember = loggedInStaffMember;
    }

    public int getSubjectResultId() {
        return subjectResultId;
    }

    public void setSubjectResultId(int subjectResultId) {
        this.subjectResultId = subjectResultId;
    }

    public int getPercentageTotal() {
        return percentageTotal;
    }

    public void setPercentageTotal(int percentageTotal) {
        this.percentageTotal = percentageTotal;
    }

    public AuthorizationSubExTest getExaminationResultAuthorization() {
        return examinationResultAuthorization;
    }

    public void setExaminationResultAuthorization(AuthorizationSubExTest examinationResultAuthorization) {
        this.examinationResultAuthorization = examinationResultAuthorization;
    }

	public List<ExaminationResultHistory> getExaminationResultHistories() {
		return examinationResultHistories;
	}

	public void setExaminationResultHistories(
			List<ExaminationResultHistory> examinationResultHistories) {
		this.examinationResultHistories = examinationResultHistories;
	}

	public IdToObjectMap<ExaminationResultComment> getIdToExaminationResultCommentMap() {
		return idToExaminationResultCommentMap;
	}

	public void setIdToExaminationResultCommentMap(
			IdToObjectMap<ExaminationResultComment> idToExaminationResultCommentMap) {
		this.idToExaminationResultCommentMap = idToExaminationResultCommentMap;
	}
	
}
