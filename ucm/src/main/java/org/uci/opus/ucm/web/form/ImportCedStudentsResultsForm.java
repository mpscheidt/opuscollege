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

package org.uci.opus.ucm.web.form;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.IdToStaffMemberMap;
import org.uci.opus.college.web.extpoint.SubjectResultFormatter;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.util.exam.ResultLine;
import org.uci.opus.ucm.domain.StudentResult;
import org.uci.opus.ucm.web.service.FileModelEnum;

public class ImportCedStudentsResultsForm {

    private NavigationSettings navigationSettings;
    private Subject subject;
    private Examination subjectExamination;
    private StaffMember staffMember;

    /**
     * Contains finalgrade and resit
     */
    private List<Examination> defaultExaminations ;
    private List<StaffMember> teachers;
    private IdToStaffMemberMap idToSubjectTeacherMap;
    private String brsPassing;
    private boolean endGradesPerGradeType;
//    private String minimumGrade;
//    private String maximumGrade;
    private String minimumMarkValue;
    private String maximumMarkValue;
//    private CodeToEndGradeMap codeToFullEndGradeCommentForGradeType;
//    private List<EndGrade> fullFailGradeCommentsForGradeType;
    private Map<String, List<EndGrade>> endGradeTypeCodeToFailGradesMap;
//    private CodeToEndGradeMap codeToFullAREndGradeCommentForGradeType;
//    private List<EndGrade> fullARFailGradeCommentsForGradeType;
    private String dateNow;
    private SubjectResultFormatter subjectResultFormatter;
    private List<ResultLine> allLines;
    private List<Map<String, Object>> students;
    private List<Map<String, Object>> missingStudents;
    private byte[] studentsResultsFile;
    private Map<String, AuthorizationSubExTest> subjectResultAuthorizationMap;
    private String formStatus = "SetUp";
    private List<StudentResult> studentsResults;
    private List<StudentResult> studentsList;
    private List<SubjectResult> subjectResults;
    private int teacherId;
    /**
     * Specifies how the file contents are formatted
     */
    private FileModelEnum  fileModel;
    
    /**
     * Final grade, resit,exam, subject
     * 
     */
    private String resultType; 
    private FileModelEnum[] fileModels;

    // View elements
    private String adjustmentMark = "0.0";

    
    public ImportCedStudentsResultsForm(){
    	
    	defaultExaminations = new ArrayList<Examination>();
    	
    	Examination finalGrade = new Examination();
    	finalGrade.setId(-1);
    	finalGrade.setExaminationDescription("Nota final");
    	finalGrade.setExaminationCode("-1");
    	
    	defaultExaminations.add(finalGrade);
    	
    	Examination resit = new Examination();
    	resit.setId(-2);
    	resit.setExaminationDescription("Recorrencia");
    	resit.setExaminationCode("-2");
    	
    	defaultExaminations.add(resit);
    	    	
    	fileModels = FileModelEnum.values();
    }
    
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public StaffMember getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(StaffMember staffMember) {
        this.staffMember = staffMember;
    }

    public List<StaffMember> getTeachers() {
        return teachers;
    }

    public void setTeachers(List<StaffMember> teachers) {
        this.teachers = teachers;
    }

    public IdToStaffMemberMap getIdToSubjectTeacherMap() {
        return idToSubjectTeacherMap;
    }

    public void setIdToSubjectTeacherMap(IdToStaffMemberMap idToStaffMemberMap) {
        this.idToSubjectTeacherMap = idToStaffMemberMap;
    }

    public String getBrsPassing() {
        return brsPassing;
    }

    public void setBrsPassing(String brsPassing) {
        this.brsPassing = brsPassing;
    }

    public boolean isEndGradesPerGradeType() {
        return endGradesPerGradeType;
    }

    public void setEndGradesPerGradeType(boolean endGradesPerGradeType) {
        this.endGradesPerGradeType = endGradesPerGradeType;
    }

//    public String getMinimumGrade() {
//        return minimumGrade;
//    }
//
//    public void setMinimumGrade(String minimumGrade) {
//        this.minimumGrade = minimumGrade;
//    }
//
//    public String getMaximumGrade() {
//        return maximumGrade;
//    }
//
//    public void setMaximumGrade(String maximumGrade) {
//        this.maximumGrade = maximumGrade;
//    }

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

    public List<ResultLine> getAllLines() {
        return allLines;
    }

    public void setAllLines(List<ResultLine> allLines) {
        this.allLines = allLines;
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

	public byte[] getStudentsResultsFile() {
		return studentsResultsFile;
	}

	public void setStudentsResultsFile(byte[] studentsResultsFile) {
		this.studentsResultsFile = studentsResultsFile;
	}

	public Examination getSubjectExamination() {
		return subjectExamination;
	}

	public void setSubjectExamination(Examination subjectExamination) {
		this.subjectExamination = subjectExamination;
	}

	public String getFormStatus() {
		return formStatus;
	}

	public void setFormStatus(String formStatus) {
		this.formStatus = formStatus;
	}

	public String getResultType() {
		return resultType;
	}

	public void setResultType(String resultType) {
		this.resultType = resultType;
	}

	public List<Map<String, Object>> getStudents() {
		return students;
	}

	public void setStudents(List<Map<String, Object>> students) {
		this.students = students;
	}

	public List<Examination> getDefaultExaminations() {
		return defaultExaminations;
	}

	public void setDefaultExaminations(List<Examination> defaultExaminations) {
		this.defaultExaminations = defaultExaminations;
	}

	public Examination getDefaultExamination(int id){
		
		for(int i = 0; i < defaultExaminations.size(); i++){
			if(defaultExaminations.get(i).getId() == id){
				return defaultExaminations.get(i);
			}
		}
		
		return null;
	}

	public List<Map<String, Object>> getMissingStudents() {
		return missingStudents;
	}

	public void setMissingStudents(List<Map<String, Object>> missingStudents) {
		this.missingStudents = missingStudents;
	}

	public FileModelEnum getFileModel() {
		return fileModel;
	}

	public void setFileModel(FileModelEnum fileModel) {
		this.fileModel = fileModel;
	}

	public FileModelEnum[] getFileModels() {
		return fileModels;
	}

	public void setFileModels(FileModelEnum[] fileModels) {
		this.fileModels = fileModels;
	}

	public List<StudentResult> getStudentsResults() {
		return studentsResults;
	}

	public void setStudentsResults(List<StudentResult> results) {
		this.studentsResults = results;
	}

	public List<SubjectResult> getSubjectResults() {
		return subjectResults;
	}

	public void setSubjectResults(List<SubjectResult> subjectResults) {
		this.subjectResults = subjectResults;
	}

	public int getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(int teacherId) {
		this.teacherId = teacherId;
	}

	public List<StudentResult> getStudentsList() {
		return studentsList;
	}

	public void setStudentsList(List<StudentResult> studentsList) {
		this.studentsList = studentsList;
	}
	
	
	
}
