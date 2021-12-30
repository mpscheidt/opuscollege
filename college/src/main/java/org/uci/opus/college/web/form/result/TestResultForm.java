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
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.TestResultHistory;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.form.NavigationSettings;

public class TestResultForm {

    private NavigationSettings navigationSettings;
    private TestResult testResult;

    private int studyPlanDetailId;
    private Test test;
    private Examination examination;
    private Subject subject;
    private StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit;
    private StudyPlan studyPlan;
    private Student student;
    private IdToStaffMemberMap idToTestTeacherMap;
    private String brsPassing;
    private String minimumMarkValue;
    private String maximumMarkValue;
    private List<TestResultHistory> testResultHistories;
    
    private int examinationResultId;

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public TestResult getTestResult() {
        return testResult;
    }

    public void setTestResult(TestResult testResult) {
        this.testResult = testResult;
    }

    public int getStudyPlanDetailId() {
        return studyPlanDetailId;
    }

    public void setStudyPlanDetailId(int studyPlanDetailId) {
        this.studyPlanDetailId = studyPlanDetailId;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public IdToStaffMemberMap getIdToTestTeacherMap() {
        return idToTestTeacherMap;
    }

    public void setIdToTestTeacherMap(IdToStaffMemberMap idToTestTeacherMap) {
        this.idToTestTeacherMap = idToTestTeacherMap;
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

    public StudyPlan getStudyPlan() {
        return studyPlan;
    }

    public void setStudyPlan(StudyPlan studyPlan) {
        this.studyPlan = studyPlan;
    }

    public StudyPlanCardinalTimeUnit getStudyPlanCardinalTimeUnit() {
        return studyPlanCardinalTimeUnit;
    }

    public void setStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
        this.studyPlanCardinalTimeUnit = studyPlanCardinalTimeUnit;
    }

    public int getExaminationResultId() {
        return examinationResultId;
    }

    public void setExaminationResultId(int examinationResultId) {
        this.examinationResultId = examinationResultId;
    }

	public List<TestResultHistory> getTestResultHistories() {
		return testResultHistories;
	}

	public void setTestResultHistories(List<TestResultHistory> testResultHistories) {
		this.testResultHistories = testResultHistories;
	}
    
}
