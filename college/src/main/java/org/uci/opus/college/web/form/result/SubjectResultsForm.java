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

import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.result.AssessmentStructurePrivilege;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.SubjectResultComment;
import org.uci.opus.college.domain.util.IdToObjectMap;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.util.exam.SubjectResultLine;
import org.uci.opus.college.web.util.exam.SubjectResultLines;

public class SubjectResultsForm extends ResultsForm<SubjectResult, SubjectResultLine, SubjectResultLines> {

    private IdToStaffMemberMap idToSubjectTeacherMap;
    private boolean endGradesPerGradeType;
    private Map<String, List<EndGrade>> endGradeTypeCodeToFailGradesMap;
    private String dateNow;
    private SubjectResultFormatter subjectResultFormatter;
    private Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap;
    private AssessmentStructurePrivilege assessmentStructurePrivilege;
    private IdToObjectMap<SubjectResultComment> idToSubjectResultCommentMap;

    // View elements
    private String adjustmentMark = "0.0";

    public IdToStaffMemberMap getIdToSubjectTeacherMap() {
        return idToSubjectTeacherMap;
    }

    public void setIdToSubjectTeacherMap(IdToStaffMemberMap idToStaffMemberMap) {
        this.idToSubjectTeacherMap = idToStaffMemberMap;
    }

    public boolean isEndGradesPerGradeType() {
        return endGradesPerGradeType;
    }

    public void setEndGradesPerGradeType(boolean endGradesPerGradeType) {
        this.endGradesPerGradeType = endGradesPerGradeType;
    }

    public String getDateNow() {
        return dateNow;
    }

    public void setDateNow(String dateNow) {
        this.dateNow = dateNow;
    }

    public SubjectResultFormatter getSubjectResultFormatter() {
        return subjectResultFormatter;
    }

    public void setSubjectResultFormatter(SubjectResultFormatter subjectResultFormatter) {
        this.subjectResultFormatter = subjectResultFormatter;
    }

    public String getAdjustmentMark() {
        return adjustmentMark;
    }

    public void setAdjustmentMark(String adjustmentMark) {
        this.adjustmentMark = adjustmentMark;
    }

    public Map<String, AuthorizationSubExTest> getSubjectResultAuthorizationMap() {
        return subjectResultAuthorizationMap;
    }

    public void setSubjectResultAuthorizationMap(Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap) {
        this.subjectResultAuthorizationMap = subjectResultAuthorizationMap;
    }

    public Map<String, List<EndGrade>> getEndGradeTypeCodeToFailGradesMap() {
        return endGradeTypeCodeToFailGradesMap;
    }

    public void setEndGradeTypeCodeToFailGradesMap(Map<String, List<EndGrade>> endGradeTypeCodeToFailGradesMap) {
        this.endGradeTypeCodeToFailGradesMap = endGradeTypeCodeToFailGradesMap;
    }

    public AssessmentStructurePrivilege getAssessmentStructurePrivilege() {
        return assessmentStructurePrivilege;
    }

    public void setAssessmentStructurePrivilege(AssessmentStructurePrivilege assessmentStructurePrivilege) {
        this.assessmentStructurePrivilege = assessmentStructurePrivilege;
    }

	public IdToObjectMap<SubjectResultComment> getIdToSubjectResultCommentMap() {
		return idToSubjectResultCommentMap;
	}

	public void setIdToSubjectResultCommentMap(IdToObjectMap<SubjectResultComment> idToSubjectResultCommentMap) {
		this.idToSubjectResultCommentMap = idToSubjectResultCommentMap;
	}

}