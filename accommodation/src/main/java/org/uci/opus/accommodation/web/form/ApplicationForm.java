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
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;

public class ApplicationForm {

	private Organization organization;
	private NavigationSettings navigationSettings;
	private OrganizationalUnit organizationalUnit;
	private Institution institution;
	private Branch branch;
	private Hostel hostel;
	private Lookup hostelType;
	private AcademicYear academicYear;
	private HostelBlock block;
	private Room room;
	private Student student;
	private String status;
	private Branch firstLevelUnit;
	private OrganizationalUnit secondLevelUnit;
	private int cardinalTimeUnitNumber;
	private Study study;
	private StudyGradeType studyGradeType;
	private String approved;
	
	String txtErr;
	String txtMsg;
	
	public ApplicationForm() {
		txtErr = "";
		txtMsg = "";
		academicYear=new AcademicYear();
		firstLevelUnit=new Branch();
		secondLevelUnit=new OrganizationalUnit();
		student=new Student();
		institution=new Institution();
		room=new Room();
		block=new HostelBlock();
		hostel=new Hostel();
	}
	
	/**
	 * The block for the hostel
	 * @return
	 */
	public HostelBlock getBlock() {
		return block;
	}

	/**
	 * Set the block
	 * @param block
	 */
	public void setBlock(HostelBlock block) {
		this.block = block;
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
	 * Get the room
	 * @return
	 */
	public Room getRoom() {
		return room;
	}

	/**
	 * Set the room
	 */
	public void setRoom(Room room) {
		this.room = room;
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
	 *  @return AccommodationFee
	 */
//	public AccommodationFee getAccommodationFee() {
//		return accommodationFee;
//	}
	/**
	 * @param accommodationFee
	 */
//	public void setAccommodationFee(AccommodationFee accommodationFee) {
//		this.accommodationFee = accommodationFee;
//	}
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

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public Institution getInstitution() {
		return institution;
	}

	public void setInstitution(Institution institution) {
		this.institution = institution;
	}

	public Branch getBranch() {
		return branch;
	}

	public void setBranch(Branch branch) {
		this.branch = branch;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Branch getFirstLevelUnit() {
		return firstLevelUnit;
	}

	public void setFirstLevelUnit(Branch firstLevelUnit) {
		this.firstLevelUnit = firstLevelUnit;
	}

	public OrganizationalUnit getSecondLevelUnit() {
		return secondLevelUnit;
	}

	public void setSecondLevelUnit(OrganizationalUnit secondLevelUnit) {
		this.secondLevelUnit = secondLevelUnit;
	}

	public int getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}

	public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
		this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
	}

	public Study getStudy() {
		return study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}

	public void setStudyGradeType(StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	public String getApproved() {
		return approved;
	}

	public void setApproved(String approved) {
		this.approved = approved;
	}
}