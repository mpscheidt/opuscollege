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
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.ExaminationResultComment;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.util.exam.ExaminationResultLine;
import org.uci.opus.college.web.util.exam.ExaminationResultLines;
import org.uci.opus.util.CodeToLookupMap;

public class ExaminationResultsForm extends ResultsForm<ExaminationResult, ExaminationResultLine, ExaminationResultLines> {

    private Examination examination;
    private IdToStaffMemberMap idToExaminationTeacherMap;
    private Map<String, AuthorizationSubExTest> examinationResultAuthorizationMap;
    private AssessmentStructurePrivilege assessmentStructurePrivilege;

    private List<Lookup10> allExaminationTypes;
    private CodeToLookupMap codeToExaminationTypeMap;
    private List<ExaminationResultComment> examinationResultComments;

    public ExaminationResultsForm() {
        super();
    }
    
    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    public IdToStaffMemberMap getIdToExaminationTeacherMap() {
        return idToExaminationTeacherMap;
    }

    public void setIdToExaminationTeacherMap(IdToStaffMemberMap idToExaminationTeacherMap) {
        this.idToExaminationTeacherMap = idToExaminationTeacherMap;
    }

    public List<Lookup10> getAllExaminationTypes() {
        return allExaminationTypes;
    }

    public void setAllExaminationTypes(List<Lookup10> allExaminationTypes) {
        this.allExaminationTypes = allExaminationTypes;
    }

    public CodeToLookupMap getCodeToExaminationTypeMap() {
        if (codeToExaminationTypeMap == null) {
            codeToExaminationTypeMap = new CodeToLookupMap(allExaminationTypes);
        }
        return codeToExaminationTypeMap;
    }

    public void setCodeToExaminationTypeMap(CodeToLookupMap codeToExaminationTypeMap) {
        this.codeToExaminationTypeMap = codeToExaminationTypeMap;
    }

    public Map<String, AuthorizationSubExTest> getExaminationResultAuthorizationMap() {
        return examinationResultAuthorizationMap;
    }

    public void setExaminationResultAuthorizationMap(Map<String, AuthorizationSubExTest> examinationResultAuthorizationMap) {
        this.examinationResultAuthorizationMap = examinationResultAuthorizationMap;
    }

    public List<ExaminationResultComment> getExaminationResultComments() {
        return examinationResultComments;
    }

    public void setExaminationResultComments(List<ExaminationResultComment> examinationResultComments) {
        this.examinationResultComments = examinationResultComments;
    }

    public AssessmentStructurePrivilege getAssessmentStructurePrivilege() {
        return assessmentStructurePrivilege;
    }

    public void setAssessmentStructurePrivilege(AssessmentStructurePrivilege assessmentStructurePrivilege) {
        this.assessmentStructurePrivilege = assessmentStructurePrivilege;
    }

}
