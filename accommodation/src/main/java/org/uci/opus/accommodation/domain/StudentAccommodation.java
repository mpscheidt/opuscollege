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
 * Computer Center, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2011
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * For Java files, see Javadoc @author tags.
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
package org.uci.opus.accommodation.domain;

import java.util.Date;

import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;

public class StudentAccommodation {

    private int id;
	private Student student;
    private int roomId;
	private Room room;
	private int bedNumber;
	private AcademicYear academicYear;
	private Date dateApplied = new Date();
	private Date dateApproved;
	private String approved = "N";
	private int approvedById;
	private StaffMember approvedBy;
	private String accepted = "N";
	private Date dateAccepted;
	private String reasonForApplyingForAccommodation;
	private String comment;
	private Date writeWhen;
	private String writeWho;
	private String allocated = "N";
	private Date dateDeallocated;

	/**
	 * Gets the ID
	 * 
	 * @return
	 */
	public int getId() {
		return id;
	}

	/**
	 * Sets the ID
	 * 
	 * @param id
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * Gets Student
	 * 
	 * @return
	 */
	public Student getStudent() {
		return student;
	}

	/**
	 * Sets Student
	 * 
	 * @param student
	 */
	public void setStudent(Student student) {
		this.student = student;
	}

	/**
	 * Gets Room where a student is accommodated
	 * 
	 * @return
	 */
	public Room getRoom() {
		return room;
	}

	/**
	 * Set the Room where a student is accommodated
	 * 
	 * @param room
	 */
	public void setRoom(Room room) {
		this.room = room;
	}

	/**
	 * Gets the bed number
	 * 
	 * @return
	 */
	public int getBedNumber() {
		return bedNumber;
	}

	/**
	 * Sets the Bed Number
	 * 
	 * @param bedNumber
	 */
	public void setBedNumber(int bedNumber) {
		this.bedNumber = bedNumber;
	}

	/**
	 * Gets the academicYear when the student was accommodated
	 * 
	 * @return
	 */
	public AcademicYear getAcademicYear() {
		return academicYear;
	}

	/**
	 * Sets the AcademicYear when the student was accommodated
	 * 
	 * @param academicYear
	 */
	public void setAcademicYear(AcademicYear academicYear) {
		this.academicYear = academicYear;
	}

	/**
	 * Gets the date when the student applied for accommodation
	 * 
	 * @return
	 */
	public Date getDateApplied() {
		return dateApplied;
	}

	/**
	 * Sets the date when the student applied for accommodation
	 * 
	 * @param dateApplied
	 */
	public void setDateApplied(Date dateApplied) {
		this.dateApplied = dateApplied;
	}

	/**
	 * Gets the date when the application accommodation was approved
	 * 
	 * @return
	 */
	public Date getDateApproved() {
		return dateApproved;
	}

	/**
	 * Sets the date when the application for accommodation was approved
	 * 
	 * @param dateApproved
	 */
	public void setDateApproved(Date dateApproved) {
		this.dateApproved = dateApproved;
	}

	/**
	 * Gets the state of the application for accommodation
	 * 
	 * @return
	 */
	public String getApproved() {
		return approved;
	}

	/**
	 * Sets the state of the application for accommodation
	 * 
	 * @param approved
	 */
	public void setApproved(String approved) {
		if (approved.equals("Y") || approved.equals("N")) {
			this.approved = approved;
		} else {
			throw new IllegalArgumentException(
					"Invalid Argument! The value can either be 'Y' or 'N'");
		}
	}

	/**
	 * Gets the StaffMember who approved the application for accommodation
	 * 
	 * @return
	 */
	public StaffMember getApprovedBy() {
		return approvedBy;
	}

	/**
	 * Sets the Staffmember who approved the application for accommodation
	 * 
	 * @param approvedBy
	 */
	public void setApprovedBy(StaffMember approvedBy) {
		this.approvedBy = approvedBy;
	}

	/**
	 * Gets the state as to whether the student has had accepted the allocated
	 * bedspace
	 * 
	 * @return
	 */
	public String getAccepted() {
		return accepted;
	}

	/**
	 * Sets the stated as to whether the student has had accepted the allocated
	 * bedspace
	 * 
	 * @param accepted
	 */
	public void setAccepted(String accepted) {
		if (accepted.equals("Y") || accepted.equals("N")) {
			this.accepted = accepted;
		} else {
			throw new IllegalArgumentException(
					"Invalid Argument! The value can either be 'Y' or 'N'");
		}
	}

	/**
	 * Gets the date when the student accepted the allocated bedspace
	 * 
	 * @return
	 */
	public Date getDateAccepted() {
		return dateAccepted;
	}

	/**
	 * Sets the Date when the student accepted the allocated bedspace
	 * 
	 * @param dateAccepted
	 */
	public void setDateAccepted(Date dateAccepted) {
		this.dateAccepted = dateAccepted;
	}

	/**
	 * Gets the Comment regarding the allocation of the bedspace
	 * 
	 * @return
	 */
	public String getComment() {
		return comment;
	}

	/**
	 * Set the Comment regarding the allocation of the bedspace
	 * 
	 * @param comment
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}

	/**
	 * Gets the Date when the record was first written to the database
	 * 
	 * @return
	 */
	public Date getWriteWhen() {
		return writeWhen;
	}

	/**
	 * Sets the Date when the record was first written to the database
	 * 
	 * @param writeWhen
	 */
	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}

	/**
	 * Gets the application application or user which persisted the data to the
	 * database
	 * 
	 * @return
	 */
	public String getWriteWho() {
		return writeWho;
	}

	/**
	 * Sets the application or user who will persist the data to the database
	 * 
	 * @param writeWho
	 */
	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}

	/**
	 * Gets the state of the StudentAccommodation
	 * 
	 * @return
	 */
	public String getAllocated() {
		return allocated;
	}

	/**
	 * Sets the state of Student Accommodation Possible values are 'Y' and 'N'
	 * Default value is 'N'
	 * 
	 * @param allocated
	 */
	public void setAllocated(String allocated) {
		if (allocated.equals("Y") || allocated.equals("N")) {
			this.allocated = allocated;
		} else {
			throw new IllegalArgumentException(
					"Invalid Argument! The value can either be 'Y' or 'N'");
		}
	}

	public String getReasonForApplyingForAccommodation() {
		return reasonForApplyingForAccommodation;
	}

	public void setReasonForApplyingForAccommodation(
			String reasonForApplyingForAccommodation) {
		this.reasonForApplyingForAccommodation = reasonForApplyingForAccommodation;
	}

	/**
	 * Gets the date when a student was removed from the room which he/she was
	 * allocated
	 * 
	 * @return
	 */
	public Date getDateDeallocated() {
		return dateDeallocated;
	}

	/**
	 * Sets the date when a student was removed from the room which he/she was
	 * allocated
	 * 
	 * @param dateDeallocated
	 */
	public void setDateDeallocated(Date dateDeallocated) {
		this.dateDeallocated = dateDeallocated;
	}

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getApprovedById() {
        return approvedById;
    }

    public void setApprovedById(int approvedById) {
        this.approvedById = approvedById;
    }
}