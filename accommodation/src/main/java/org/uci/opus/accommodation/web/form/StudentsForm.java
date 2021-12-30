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

public class StudentsForm {

	private int organizationId;
	private int institutionId;
	private int branchId;
	private int hostelId;
	private int hostelTypeId;
	private int accommodationFeeId;
	private int academicYearId;
	private int blockId;
	private int roomId;
	private int studentId;
	private String status;
	private int firstLevelUnitId;
	private int secondLevelUnitId;
	private int cardinalTimeUnitNumber;
	private int studyId;
	private int studyGradeTypeId;
	private String gradeTypeCode;
	private String txtErr;
	private String txtMsg;
	private String progressStatus;
	
	public int getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(int organizationId) {
		this.organizationId = organizationId;
	}

	public int getInstitutionId() {
		return institutionId;
	}

	public void setInstitutionId(int institutionId) {
		this.institutionId = institutionId;
	}

	public int getBranchId() {
		return branchId;
	}

	public void setBranchId(int branchId) {
		this.branchId = branchId;
	}

	public int getHostelId() {
		return hostelId;
	}

	public void setHostelId(int hostelId) {
		this.hostelId = hostelId;
	}

	public int getHostelTypeId() {
		return hostelTypeId;
	}

	public void setHostelTypeId(int hostelTypeId) {
		this.hostelTypeId = hostelTypeId;
	}

	public int getAccommodationFeeId() {
		return accommodationFeeId;
	}

	public void setAccommodationFeeId(int accommodationFeeId) {
		this.accommodationFeeId = accommodationFeeId;
	}

	public int getAcademicYearId() {
		return academicYearId;
	}

	public void setAcademicYearId(int academicYearId) {
		this.academicYearId = academicYearId;
	}

	public int getBlockId() {
		return blockId;
	}

	public void setBlockId(int blockId) {
		this.blockId = blockId;
	}

	public int getRoomId() {
		return roomId;
	}

	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getFirstLevelUnitId() {
		return firstLevelUnitId;
	}

	public void setFirstLevelUnitId(int firstLevelUnitId) {
		this.firstLevelUnitId = firstLevelUnitId;
	}

	public int getSecondLevelUnitId() {
		return secondLevelUnitId;
	}

	public void setSecondLevelUnitId(int secondLevelUnitId) {
		this.secondLevelUnitId = secondLevelUnitId;
	}

	public int getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}

	public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
		this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
	}

	public int getStudyId() {
		return studyId;
	}

	public void setStudyId(int studyId) {
		this.studyId = studyId;
	}

	public int getStudyGradeTypeId() {
		return studyGradeTypeId;
	}

	public void setStudyGradeTypeId(int studyGradeTypeId) {
		this.studyGradeTypeId = studyGradeTypeId;
	}
	
	public String getGradeTypeCode() {
		return gradeTypeCode;
	}

	public void setGradeTypeCode(String gradeTypeCode) {
		this.gradeTypeCode = gradeTypeCode;
	}

	public String getTxtErr() {
		return txtErr;
	}

	public void setTxtErr(String txtErr) {
		this.txtErr = txtErr;
	}

	public String getTxtMsg() {
		return txtMsg;
	}

	public void setTxtMsg(String txtMsg) {
		this.txtMsg = txtMsg;
	}

	public String getProgressStatus() {
		return progressStatus;
	}

	public void setProgressStatus(String progressStatus) {
		this.progressStatus = progressStatus;
	}
}