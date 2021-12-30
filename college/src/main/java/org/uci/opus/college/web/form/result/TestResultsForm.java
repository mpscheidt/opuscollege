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

import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.Test;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.result.TestResultComment;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.util.exam.TestResultLine;
import org.uci.opus.college.web.util.exam.TestResultLines;
import org.uci.opus.util.CodeToLookupMap;

public class TestResultsForm extends ResultsForm<TestResult, TestResultLine, TestResultLines> {

    private Test test;
    private Examination examination;
    private IdToStaffMemberMap idToTestTeacherMap;
    private Map<String, AuthorizationSubExTest> testResultAuthorizationMap;
    private AssessmentStructurePrivilege assessmentStructurePrivilege;

    private CodeToLookupMap codeToExaminationTypeMap;
    private List<TestResultComment> testResultComments;

    public TestResultsForm() {
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    public Map<String, AuthorizationSubExTest> getTestResultAuthorizationMap() {
        return testResultAuthorizationMap;
    }

    public void setTestResultAuthorizationMap(Map<String, AuthorizationSubExTest> testResultAuthorizationMap) {
        this.testResultAuthorizationMap = testResultAuthorizationMap;
    }

    public CodeToLookupMap getCodeToExaminationTypeMap() {
        return codeToExaminationTypeMap;
    }

    public void setCodeToExaminationTypeMap(CodeToLookupMap codeToExaminationTypeMap) {
        this.codeToExaminationTypeMap = codeToExaminationTypeMap;
    }

    public List<TestResultComment> getTestResultComments() {
        return testResultComments;
    }

    public void setTestResultComments(List<TestResultComment> testResultComments) {
        this.testResultComments = testResultComments;
    }

    public IdToStaffMemberMap getIdToTestTeacherMap() {
        return idToTestTeacherMap;
    }

    public void setIdToTestTeacherMap(IdToStaffMemberMap idToTestTeacherMap) {
        this.idToTestTeacherMap = idToTestTeacherMap;
    }

    public AssessmentStructurePrivilege getAssessmentStructurePrivilege() {
        return assessmentStructurePrivilege;
    }

    public void setAssessmentStructurePrivilege(AssessmentStructurePrivilege assessmentStructurePrivilege) {
        this.assessmentStructurePrivilege = assessmentStructurePrivilege;
    }

}
