/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
 ******************************************************************************/
package org.uci.opus.accommodation.web.form;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.StudentAccommodationSelectionCriteria;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;

public class AccommodationStudentsForm {

	private Organization organization;
	private NavigationSettings navigationSettings;
	private OrganizationalUnit organizationalUnit;
	private Study study;
	private Hostel hostel;
	private Lookup hostelType;
	private Student student;
	private StudentAccommodationSelectionCriteria studentAccommodationSelectionCriteria;
	private AcademicYear academicYear;
	private String reasonForApplyingForAccommodation;
	
	String txtErr;
	String txtMsg;
	
	public AccommodationStudentsForm() {
		txtErr = "";
		txtMsg = "";
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
	 * 
	 * @return the OrganizationalUnit
	 */
	public OrganizationalUnit getOrganizationalUnit() {
		return organizationalUnit;
	}
	/**
	 * 
	 * @param organizationalUnit the organizationalUnit to set
	 */
	public void setOrganizationalUnit(OrganizationalUnit organizationalUnit) {
		this.organizationalUnit = organizationalUnit;
	}

	/**
	 * 
	 * @return Study
	 */
	public Study getStudy() {
		return study;
	}

	/**
	 * @param study The Study to set
	 */
	public void setStudy(Study study) {
		this.study = study;
	}
	
	/**
	 * @return Hostel
	 */
	public Hostel getHostel() {
		return hostel;
	}
	
	/**
	 * @param hostel the Hostel to set
	 */
	public void setHostel(Hostel hostel) {
		this.hostel = hostel;
	}
	/**
	 * @return HostelType
	 */
	public Lookup getHostelType() {
		return hostelType;
	}
	
	/**
	 * @param hostelType
	 */
	public void setHostelType(Lookup hostelType) {
		this.hostelType = hostelType;
	}
	
	/**
	 * @return Student
	 */
	public Student getStudent() {
		return student;
	}
	/**
	 * @param student the Student to set
	 */
	public void setStudent(Student student) {
		this.student = student;
	}

	/**
	 * @return StudentAccommodationSelectionCriteria
	 */
	public StudentAccommodationSelectionCriteria getStudentAccommodationSelectionCriteria() {
		return studentAccommodationSelectionCriteria;
	}

	/**
	 * @param studentAccommodationSelectionCriteria
	 */
	public void setStudentAccommodationSelectionCriteria(
			StudentAccommodationSelectionCriteria studentAccommodationSelectionCriteria) {
		this.studentAccommodationSelectionCriteria = studentAccommodationSelectionCriteria;
	}
	/**
	 * @return AcademicYear
	 */
	public AcademicYear getAcademicYear() {
		return academicYear;
	}
	/**
	 * @param academicYear
	 */
	public void setAcademicYear(AcademicYear academicYear) {
		this.academicYear = academicYear;
	}

	public String getReasonForApplyingForAccommodation() {
		return reasonForApplyingForAccommodation;
	}

	public void setReasonForApplyingForAccommodation(
			String reasonForApplyingForAccommodation) {
		this.reasonForApplyingForAccommodation = reasonForApplyingForAccommodation;
	}
	
	
}