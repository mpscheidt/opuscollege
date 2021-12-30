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
 * Center for Information Services, Radboud University Nijmegen
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

package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.Subject;

public class ExaminationTeacherForm {

	private Organization organization;
	private NavigationSettings navigationSettings;
	private int studyId;
	private int subjectId;
	private ExaminationTeacher examinationTeacher;
	private Examination examination;
	private String from;
	private Subject subject;
	private StaffMember staffMember;
	private String formView;

	private List<StaffMember> allTeachers;
	private List<Examination> allExaminations;
	private List<Classgroup> allClassgroups;

	private List<Study> allStudies = null;
	private List<Subject> allSubjects = null;
	private List<AcademicYear> allAcademicYears = null;

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}

	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}

	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	public int getStudyId() {
		return studyId;
	}

	public void setStudyId(final int studyId) {
		this.studyId = studyId;
	}

	public ExaminationTeacher getExaminationTeacher() {
		return examinationTeacher;
	}

	public void setExaminationTeacher(final ExaminationTeacher examinationTeacher) {
		this.examinationTeacher = examinationTeacher;
	}

	public Examination getExamination() {
		return examination;
	}

	public void setExamination(final Examination examination) {
		this.examination = examination;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(final String from) {
		this.from = from;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(final Subject subject) {
		this.subject = subject;
	}

	public StaffMember getStaffMember() {
		return staffMember;
	}

	public void setStaffMember(final StaffMember staffMember) {
		this.staffMember = staffMember;
	}

	public String getFormView() {
		return formView;
	}

	public void setFormView(final String formView) {
		this.formView = formView;
	}

	public List<Study> getAllStudies() {
		return allStudies;
	}

	public void setAllStudies(final List<Study> allStudies) {
		this.allStudies = allStudies;
	}

	public List<Subject> getAllSubjects() {
		return allSubjects;
	}

	public void setAllSubjects(final List<Subject> allSubjects) {
		this.allSubjects = allSubjects;
	}

	public List<AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}

	public void setAllAcademicYears(final List<AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	public List<Examination> getAllExaminations() {
		return allExaminations;
	}

	public void setAllExaminations(List<Examination> allExaminations) {
		this.allExaminations = allExaminations;
	}

	public List<Classgroup> getAllClassgroups() {
		return allClassgroups;
	}

	public void setAllClassgroups(List<Classgroup> allClassgroups) {
		this.allClassgroups = allClassgroups;
	}

	public int getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(int subjectId) {
		this.subjectId = subjectId;
	}

	public List<StaffMember> getAllTeachers() {
		return allTeachers;
	}

	public void setAllTeachers(List<StaffMember> allTeachers) {
		this.allTeachers = allTeachers;
	}
}
