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

package org.uci.opus.college.web.util.exam;

import java.util.ArrayList;
import java.util.List;

import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.result.SubjectResultGenerator;

public class SubjectResultLine extends ResultLine<SubjectResult> {
    
    private String endGradeComment;
    private SubjectResultGenerator resultGenerator;

	public boolean isSubjectResultFound() {
		return isResultsFound();
	}
//	public void setSubjectResultFound(boolean subjectResultFound) {
//		this.subjectResultFound = subjectResultFound;
//	}
	public SubjectResult getSubjectResult() {
		// there is only one result in the case of subjects, so return the first in list.
		SubjectResult sr = null;
		if (results != null && !results.isEmpty()) {
			sr = (SubjectResult) results.get(0);
		}
		return sr;
	}

    public SubjectResult getSubjectResultInDB() {
        // there is only one result in the case of subjects, so return the first in list.
        SubjectResult sr = null;
        if (resultsInDB != null && !resultsInDB.isEmpty()) {
            sr = (SubjectResult) resultsInDB.get(0);
        }
        return sr;
    }

	public void setSubjectResult(SubjectResult subjectResult) {
        List<SubjectResult> subjectResults = getResults();
	    if (subjectResults == null) {
	        subjectResults = new ArrayList<>(1);
	        setResults(subjectResults);
	    } else {
	        subjectResults.clear();
	    }
	    subjectResults.add(subjectResult);
	}

	public boolean getExaminationResultsFound() {
		return subResultsFound;
	}
//	public void setExaminationResultsFound(boolean examinationResultsFound) {
//		this.examinationResultsFound = examinationResultsFound;
//	}
//	public List<StaffMember> getTeachersForSubject() {
//		return teachers;
//	}
//	public void setTeachersForSubject(List<StaffMember> teachersForSubject) {
//		this.teachersForSubject = teachersForSubject;
//	}
//	public int getStudentId() {
//		return studentId;
//	}
//	public void setStudentId(int studentId) {
//		this.studentId = studentId;
//	}
	public String getExaminationResultsString() {
		return subResultsString;
	}
//	public void setExaminationResultsString(String examinationResultsString) {
//		this.examinationResultsString = examinationResultsString;
//	}
//	public int getStudyPlanDetailId() {
//		return studyPlanDetailId;
//	}
//	public void setStudyPlanDetailId(int studyPlanDetailId) {
//		this.studyPlanDetailId = studyPlanDetailId;
//	}
    public String getEndGradeComment() {
        return endGradeComment;
    }
    public void setEndGradeComment(String endGradeComment) {
        this.endGradeComment = endGradeComment;
    }
    public SubjectResultGenerator getResultGenerator() {
        return resultGenerator;
    }
    public void setResultGenerator(SubjectResultGenerator resultGenerator) {
        this.resultGenerator = resultGenerator;
    }
}
