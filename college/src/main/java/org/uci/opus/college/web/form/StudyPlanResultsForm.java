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

package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.web.extpoint.StudyPlanResultFormatter;

public class StudyPlanResultsForm {

	Organization organization;
	NavigationSettings navigationSettings;
	StudySettings studySettings;
	
	String txtErr;
	String txtMsg;

	String studentStatusCode;

	List < ? extends Study > allStudies;
    List<? extends Study> dropDownListStudies;
    List < ? extends StudyGradeType > allStudyGradeTypes;
    List < ? extends Student > allStudents;
    List < ? extends AcademicYear > allAcademicYears;

    private StudyPlanResultFormatter studyPlanResultFormatter;

    private int studentCount;


    public StudyPlanResultsForm() {
		txtErr = "";
		txtMsg = "";
		studentStatusCode = "";
	}

	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}
	/**
	 * @param organization the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}
	
	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	/**
	 * @param navigationSettings the navigationSettings to set
	 */
	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}
	
	/**
	 * @return the studySettings
	 */
	public StudySettings getStudySettings() {
		return studySettings;
	}
	/**
	 * @param studyDetails the studySettings to set
	 */
	public void setStudySettings(final StudySettings studySettings) {
		this.studySettings = studySettings;
	}

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}
	/**
	 * @param studyError the txtErr to set
	 */
	public void setTxtErr(final String txtErr) {
		this.txtErr = txtErr;
	}
	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}

	/**
	 * @return the studentStatusCode
	 */
	public String getStudentStatusCode() {
		return studentStatusCode;
	}
	/**
	 * @param studentStatusCode the studentStatusCode to set
	 */
	public void setStudentStatusCode(final String studentStatusCode) {
		this.studentStatusCode = studentStatusCode;
	}

	/**
	 * @return the allStudies
	 */
	public List<? extends Study> getAllStudies() {
		return allStudies;
	}

	/**
	 * @param allStudies the allStudies to set
	 */
	public void setAllStudies(final List<? extends Study> allStudies) {
		this.allStudies = allStudies;
	}

	/**
	 * @return the dropDownListStudies
	 */
	public List<? extends Study> getDropDownListStudies() {
		return dropDownListStudies;
	}

	/**
	 * @param dropDownListStudies the dropDownListStudies to set
	 */
	public void setDropDownListStudies(
			final List<? extends Study> dropDownListStudies) {
		this.dropDownListStudies = dropDownListStudies;
	}

	/**
	 * @return the allStudyGradeTypes
	 */
	public List<? extends StudyGradeType> getAllStudyGradeTypes() {
		return allStudyGradeTypes;
	}

	/**
	 * @param allStudyGradeTypes the allStudyGradeTypes to set
	 */
	public void setAllStudyGradeTypes(
			final List<? extends StudyGradeType> allStudyGradeTypes) {
		this.allStudyGradeTypes = allStudyGradeTypes;
	}
	
	/**
	 * @return the allStudents
	 */
	public List<? extends Student> getAllStudents() {
		return allStudents;
	}
	/**
	 * @param allStudents the allStudents to set
	 */
	public void setAllStudents(final List<? extends Student> allStudents) {
		this.allStudents = allStudents;
	}

	/**
	 * @return the allAcademicYears
	 */
	public List<? extends AcademicYear> getAllAcademicYears() {
		return allAcademicYears;
	}
	/**
	 * @param allAcademicYears the allAcademicYears to set
	 */
	public void setAllAcademicYears(
			final List<? extends AcademicYear> allAcademicYears) {
		this.allAcademicYears = allAcademicYears;
	}

	/**
	 * @return the studyPlanResultFormatter
	 */
	public StudyPlanResultFormatter getStudyPlanResultFormatter() {
		return studyPlanResultFormatter;
	}

	/**
	 * @param studyPlanResultFormatter the studyPlanResultFormatter to set
	 */
	public void setStudyPlanResultFormatter(
			final StudyPlanResultFormatter studyPlanResultFormatter) {
		this.studyPlanResultFormatter = studyPlanResultFormatter;
	}

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }
}
