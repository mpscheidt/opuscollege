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

package org.uci.opus.college.web.form.person;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;

public class StudentClassgroupForm {

	private NavigationSettings navigationSettings;

	private int studentId;
	private int personId;
	private int studyId;
	private int academicYearId;
	private int studyGradeTypeId;
	private int classgroupId;
	private Student student;
	
	// used to show the name of the primary study of each subject in the
	// overview
	private List<Study> allStudies;
	private List<Classgroup> allClassgroups;
	private List<AcademicYear> allAcademicYears;
	private List<StudyGradeType> allStudyGradeTypes;
    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToLookupMap codeToGradeTypeMap;
    
	public int getStudyId() {
		return studyId;
	}

	public void setStudyId(int studyId) {
		this.studyId = studyId;
	}

	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}

	public void setNavigationSettings(NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	public List<Study> getAllStudies() {
		return allStudies;
	}

	public void setAllStudies(List<Study> allStudies) {
		this.allStudies = allStudies;
	}

	public int getAcademicYearId() {
		return academicYearId;
	}

	public void setAcademicYearId(int academicYearId) {
		this.academicYearId = academicYearId;
	}

	public List<AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}

	public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	public List<Classgroup> getAllClassgroups() {
		return allClassgroups;
	}

	public void setAllClassgroups(List<Classgroup> allClassgroups) {
		this.allClassgroups = allClassgroups;
	}

	public List<StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	public void setAllStudyGradeTypes(List<StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}

	public IdToAcademicYearMap getIdToAcademicYearMap() {
		return idToAcademicYearMap;
	}

	public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
		this.idToAcademicYearMap = idToAcademicYearMap;
	}

	public CodeToLookupMap getCodeToGradeTypeMap() {
		return codeToGradeTypeMap;
	}

	public void setCodeToGradeTypeMap(CodeToLookupMap codeToGradeTypeMap) {
		this.codeToGradeTypeMap = codeToGradeTypeMap;
	}

	public int getStudyGradeTypeId() {
		return studyGradeTypeId;
	}

	public void setStudyGradeTypeId(int studyGradeTypeId) {
		this.studyGradeTypeId = studyGradeTypeId;
	}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public int getPersonId() {
		return personId;
	}

	public void setPersonId(int personId) {
		this.personId = personId;
	}

	public int getClassgroupId() {
		return classgroupId;
	}

	public void setClassgroupId(int classgroupId) {
		this.classgroupId = classgroupId;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}
}
