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

package org.uci.opus.college.domain;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

/**
 * @author move
 * 
 */
public class StaffMember extends Person {

    private static final long serialVersionUID = 1L;

    private int personId;
    private int staffMemberId;
    private String staffMemberCode;
    private Date dateOfAppointment;
    private String appointmentTypeCode;
    private String staffTypeCode;
    private int primaryUnitOfAppointmentId;
    private String educationTypeCode;
    private String startWorkDay;
    private String endWorkDay;
    private String teachingDayPartCode;
    private String supervisingDayPartCode;

    private List<? extends StaffMemberFunction> functions;
    private List<? extends Contract> contracts;
    private List<? extends Address> addresses;
    private List<? extends SubjectTeacher> subjectsTaught;
    private List<? extends ExaminationTeacher> examinationsTaught;
    private List<? extends TestTeacher> testsSupervised;

    public StaffMember() {
        super();
    }

    public StaffMember(String personCode, String surnameFull, String firstnamesFull, Date birthdate, String staffMemberCode, int primaryUnitOfAppointmentId) {
        super(personCode, surnameFull, firstnamesFull, birthdate);
        this.staffMemberCode = staffMemberCode;
        this.primaryUnitOfAppointmentId = primaryUnitOfAppointmentId;
    }
    
    public List<? extends ExaminationTeacher> getExaminationsTaught() {
        return examinationsTaught;
    }

    public void setExaminationsTaught(List<? extends ExaminationTeacher> examinationsTaught) {
        this.examinationsTaught = examinationsTaught;
    }

    public List<? extends SubjectTeacher> getSubjectsTaught() {
        return subjectsTaught;
    }

    public void setSubjectsTaught(List<? extends SubjectTeacher> subjectsTaught) {
        this.subjectsTaught = subjectsTaught;
    }

    public List<? extends StaffMemberFunction> getFunctions() {
        return functions;
    }

    public void setFunctions(List<? extends StaffMemberFunction> newFunctions) {
        functions = newFunctions;
    }

    public List<? extends Address> getAddresses() {
        return addresses;
    }

    public void setAddresses(List<? extends Address> newAddresses) {
        addresses = newAddresses;
    }

    public List<? extends Contract> getContracts() {
        return contracts;
    }

    public void setContracts(List<? extends Contract> newContracts) {
        contracts = newContracts;
    }

    public Date getDateOfAppointment() {
        return dateOfAppointment;
    }

    public void setDateOfAppointment(Date newDateOfAppointment) {
        dateOfAppointment = newDateOfAppointment;
    }

    public int getPrimaryUnitOfAppointmentId() {
        return primaryUnitOfAppointmentId;
    }

    public void setPrimaryUnitOfAppointmentId(int newPrimaryUnitOfAppointmentId) {
        primaryUnitOfAppointmentId = newPrimaryUnitOfAppointmentId;
    }

    public String getStaffMemberCode() {
        return staffMemberCode;
    }

    public void setStaffMemberCode(String newStaffMemberCode) {
        staffMemberCode = StringUtils.trim(newStaffMemberCode);
    }

    public int getStaffMemberId() {
        return staffMemberId;
    }

    public void setStaffMemberId(int newStaffMemberId) {
        staffMemberId = newStaffMemberId;
    }

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int newPersonId) {
        personId = newPersonId;
    }

    public String getAppointmentTypeCode() {
        return appointmentTypeCode;
    }

    public void setAppointmentTypeCode(String newAppointmentTypeCode) {
        appointmentTypeCode = newAppointmentTypeCode;
    }

    public String getEducationTypeCode() {
        return educationTypeCode;
    }

    public void setEducationTypeCode(String newEducationTypeCode) {
        educationTypeCode = newEducationTypeCode;
    }

    public String getStaffTypeCode() {
        return staffTypeCode;
    }

    public void setStaffTypeCode(String newStaffTypeCode) {
        staffTypeCode = newStaffTypeCode;
    }

    public String getStartWorkDay() {
        return startWorkDay;
    }

    public void setStartWorkDay(String startWorkDay) {
        this.startWorkDay = startWorkDay;
    }

    public String getEndWorkDay() {
        return endWorkDay;
    }

    public void setEndWorkDay(String endWorkDay) {
        this.endWorkDay = endWorkDay;
    }

    public String getTeachingDayPartCode() {
        return teachingDayPartCode;
    }

    public void setTeachingDayPartCode(String teachingDayPartCode) {
        this.teachingDayPartCode = teachingDayPartCode;
    }

    public String getSupervisingDayPartCode() {
        return supervisingDayPartCode;
    }

    public void setSupervisingDayPartCode(String supervisingDayPartCode) {
        this.supervisingDayPartCode = supervisingDayPartCode;
    }

    public List<? extends TestTeacher> getTestsSupervised() {
        return testsSupervised;
    }

    public void setTestsSupervised(List<? extends TestTeacher> testsSupervised) {
        this.testsSupervised = testsSupervised;
    }

}
