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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.SubjectResult;

@Component
@Scope(scopeName = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class SubjectResultsBuilder extends ResultLinesBuilder<SubjectResult, SubjectResultLine, SubjectResultLines> {
	
    private Subject subject = null;
    private List < SubjectResult > allSubjectResults = null;
    private List<? extends EndGrade> allEndGrades;

    public SubjectResultsBuilder() {
        super();
    }

    @Override
    protected SubjectResultLines newResultLines() {
        return new SubjectResultLines();
    }

	/**
	 * Custom functionality: create 'exam results string'.
	 */
	@Override
	protected SubjectResultLine buildLine(StudyPlanDetail sdp) {
		SubjectResultLine line = (SubjectResultLine) super.buildLine(sdp);

		List<? extends ExaminationResult> examinationResults = ExamUtil
				.extractExaminationResults(sdp.getExaminationResults(), subject.getId());
		boolean examinationResultsFound = (examinationResults != null && !examinationResults.isEmpty());
		line.setSubResultsFound(examinationResultsFound);

//		List<StaffMember> teachersForSubject = StaffMemberUtil.extractTeachersBySubjectTeachers(
//				allTeachers, subject.getSubjectTeachers());
//		line.setTeachers(teachersForSubject);

		if (examinationResultsFound) {
			line.setSubResultsString(buildExaminationResultsString(examinationResults));
		}
		
		// MP 2013-07-31: create empty subjectResult if none exists yet
		if (line.getSubjectResult() == null) {
		    SubjectResult subjectResult = new SubjectResult();
		    subjectResult.setStudyPlanDetailId(sdp.getId());
		    subjectResult.setSubjectId(subject.getId());
		    subjectResult.setSubjectResultDate(new Date());
		    line.setSubjectResult(subjectResult);
		} else {
		    // find the end grade that corresponds to this subject result:
		    // both endgradeCode (e.g. A+) and endgradeTypeCode (e.g. BSC) have to match
		    if (allEndGrades != null) {
		        SubjectResult subjectResult = line.getSubjectResult();
		        for (EndGrade endGrade : allEndGrades) {
		            if (endGrade.getCode().equals(subjectResult.getEndGradeComment())
		                    && endGrade.getEndGradeTypeCode().equals(subjectResult.getEndGradeTypeCode())) {
		                subjectResult.setEndGradeObject(endGrade);
		                break;
		            }
		        }
		    }
		}
		
		return line;
	}

	public String buildExaminationResultsString(List<? extends ExaminationResult> examinationResults) {
		StringBuilder result = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        if (examinationResults != null && examinationResults.size() > 0) {
			for (Iterator<? extends ExaminationResult> it = examinationResults.iterator(); it.hasNext(); ) {
				ExaminationResult er = it.next();
				Examination ex = ExamUtil.getExamination(subject.getExaminations(), er.getExaminationId());
				result.append("<br>");
                result.append(df.format(er.getExaminationResultDate()));
                result.append(": ");
				result.append(ex.getExaminationDescription());
				result.append(" (");
				result.append(er.getAttemptNr());
				result.append("): ");
				result.append(er.getMark());
                result.append(" (");
                result.append(er.getPassed());
                result.append(")");
			}
        }
        return result.toString();
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	@Override
	protected List<SubjectResult> findResults(int studyPlanDetailId) {
		// subjects have only one (final) result, so make list of length 1.
		List<SubjectResult> list = new ArrayList<>(1);
		SubjectResult sr = ExamUtil.extractSubjectResult(allSubjectResults, studyPlanDetailId, subject.getId());
		if (sr != null) {
		    list.add(sr);
		}
		return list;
	}

	@Override
	protected SubjectResultLine makeNewResultLine() {
		return new SubjectResultLine();
	}

	public List<SubjectResult> getAllSubjectResults() {
		return allSubjectResults;
	}


	public void setAllSubjectResults(List<SubjectResult> allSubjectResults) {
		this.allSubjectResults = allSubjectResults;
	}



    public List<? extends EndGrade> getAllEndGrades() {
        return allEndGrades;
    }



    public void setAllEndGrades(List<? extends EndGrade> allEndGrades) {
        this.allEndGrades = allEndGrades;
    }




}
