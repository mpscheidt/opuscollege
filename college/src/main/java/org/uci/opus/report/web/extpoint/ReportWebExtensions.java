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

package org.uci.opus.report.web.extpoint;
import java.lang.reflect.Field;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;

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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

public class ReportWebExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(ReportWebExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private List<StudentReport4StudyGradeTypeCardinalTimeUnit> studentReports4studyGradeTypeCardinalTimeUnit;
    private List<StudentReport4StudyGradeType> studentReports4studyGradeType;
    private List<StudentReport4Subject> studentReports4Subject;
    private List<StudentReport4SubjectResults> studentReport4SubjectResults;
    private List<StudentReport4IndividualStudent> studentReports4IndividualStudent;
    private List<StudentReport4StudyPlan> studentReports4StudyPlan;
    private List<StudentReport4StudyPlanCardinalTimeUnit> studentReports4StudyPlanCardinalTimeUnit;

    public List<StudentReport4StudyGradeTypeCardinalTimeUnit> getStudentReports4studyGradeTypeCardinalTimeUnit() {
        return studentReports4studyGradeTypeCardinalTimeUnit;
    }

    @Autowired(required=false)
    public void setStudentReports4studyGradeTypeCardinalTimeUnit(List<StudentReport4StudyGradeTypeCardinalTimeUnit> studyGradeTypeCardinalTimeUnitReports) {
        this.studentReports4studyGradeTypeCardinalTimeUnit = studyGradeTypeCardinalTimeUnitReports;
//        logReportExtensions(studyGradeTypeCardinalTimeUnitReports);
        extensionPointUtil.logExtensions(log, StudentReport4StudyGradeTypeCardinalTimeUnit.class, studyGradeTypeCardinalTimeUnitReports);
    }
    
//    private void logReportExtensions(List<? extends Report> reports) {
//        if (reports == null || reports.isEmpty()) return;
//        int nExtensions = reports.size();
//        log.info(nExtensions + " " + reports.get(0).getClass().getName() + " extensions: " + reports);
//    }

    public List<StudentReport4StudyGradeType> getStudentReports4studyGradeType() {
        return studentReports4studyGradeType;
    }

    @Autowired(required=false)
    public void setStudentReports4studyGradeType(
            List<StudentReport4StudyGradeType> studentReports4studyGradeType) {
        this.studentReports4studyGradeType = studentReports4studyGradeType;
//        logReportExtensions(studentReports4studyGradeType);
        extensionPointUtil.logExtensions(log, StudentReport4StudyGradeType.class, studentReports4studyGradeType);
    }

    public List<StudentReport4Subject> getStudentReports4Subject() {
        return studentReports4Subject;
    }

    @Autowired(required=false)
    public void setStudentReports4Subject(List<StudentReport4Subject> subjectReports) {
        this.studentReports4Subject = subjectReports;
//        logReportExtensions(subjectReports);
        extensionPointUtil.logExtensions(log, StudentReport4Subject.class, subjectReports);
    }

    public List<StudentReport4IndividualStudent> getStudentReports4IndividualStudent() {
        return studentReports4IndividualStudent;
    }

    @Autowired(required=false)
    public void setStudentReports4IndividualStudent(
            List<StudentReport4IndividualStudent> individualStudentReports) {
        this.studentReports4IndividualStudent = individualStudentReports;
//        logReportExtensions(individualStudentReports);
        extensionPointUtil.logExtensions(log, StudentReport4IndividualStudent.class, individualStudentReports);
    }

    public List<StudentReport4StudyPlan> getStudentReports4StudyPlan() {
        return studentReports4StudyPlan;
    }

    @Autowired(required=false)
    public void setStudentReports4StudyPlan(
            List<StudentReport4StudyPlan> studentReports4StudyPlan) {
        this.studentReports4StudyPlan = studentReports4StudyPlan;
//        logReportExtensions(studentReports4StudyPlan);
        extensionPointUtil.logExtensions(log, StudentReport4StudyPlan.class, studentReports4StudyPlan);
    }

	public List<StudentReport4StudyPlanCardinalTimeUnit> getStudentReports4StudyPlanCardinalTimeUnit() {
		return studentReports4StudyPlanCardinalTimeUnit;
	}

	@Autowired(required=false)
	public void setStudentReports4StudyPlanCardinalTimeUnit(
			List<StudentReport4StudyPlanCardinalTimeUnit> studentReports4StudyPlanCardinalTimeUnit) {
		this.studentReports4StudyPlanCardinalTimeUnit = studentReports4StudyPlanCardinalTimeUnit;
//		logReportExtensions(studentReports4StudyPlanCardinalTimeUnit);
        extensionPointUtil.logExtensions(log, StudentReport4StudyPlanCardinalTimeUnit.class, studentReports4StudyPlanCardinalTimeUnit);
	}

	
    public List<StudentReport4SubjectResults> getStudentReport4SubjectResults() {
		return studentReport4SubjectResults;
	}

    @Autowired(required=false)
    public void setStudentReport4SubjectResults(List<StudentReport4SubjectResults> studentReport4SubjectResults) {
        this.studentReport4SubjectResults = studentReport4SubjectResults;
        extensionPointUtil.logExtensions(log, StudentReport4SubjectResults.class, studentReport4SubjectResults);
	}

	@Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

}
