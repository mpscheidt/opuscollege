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

import java.io.Serializable;
import java.util.Date;

/**
 * @author move
 *
 */
public class Contract implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String contractCode;
    private int staffMemberId;
    private String contractTypeCode;
    private String contractDurationCode;
    private Date contractStartDate;
    private Date contractEndDate;
    private double contactHours;
    private double fteAppointmentOverall;
    private double fteResearch;
    private double fteEducation;
    private double fteAdministrativeTasks;

    public double getContactHours() {
        return contactHours;
    }

    public void setContactHours(double newContactHours) {
        contactHours = newContactHours;
    }

    public Date getContractEndDate() {
        return contractEndDate;
    }

    public void setContractEndDate(Date newContractEndDate) {
        contractEndDate = newContractEndDate;
    }

    public String getContractCode() {
        return contractCode;
    }

    public Date getContractStartDate() {
        return contractStartDate;
    }

    public void setContractStartDate(Date newContractStartDate) {
        contractStartDate = newContractStartDate;
    }

    public String getContractDurationCode() {
        return contractDurationCode;
    }

    public void setContractDurationCode(String newContractDurationCode) {
        contractDurationCode = newContractDurationCode;
    }

    public String getContractTypeCode() {
        return contractTypeCode;
    }

    public void setContractTypeCode(String newContractTypeCode) {
        contractTypeCode = newContractTypeCode;
    }

    public double getFteAdministrativeTasks() {
        return fteAdministrativeTasks;
    }

    public void setFteAdministrativeTasks(double newFteAdministrativeTasks) {
        fteAdministrativeTasks = newFteAdministrativeTasks;
    }

    public double getFteAppointmentOverall() {
        return fteAppointmentOverall;
    }

    public void setFteAppointmentOverall(double newFteAppointmentOverall) {
        fteAppointmentOverall = newFteAppointmentOverall;
    }

    public double getFteEducation() {
        return fteEducation;
    }

    public void setFteEducation(double newFteEducation) {
        fteEducation = newFteEducation;
    }

    public double getFteResearch() {
        return fteResearch;
    }

    public void setFteResearch(double newFteResearch) {
        fteResearch = newFteResearch;
    }

    public int getStaffMemberId() {
        return staffMemberId;
    }

    public void setStaffMemberId(int newStaffMemberId) {
        staffMemberId = newStaffMemberId;
    }

    public int getId() {
        return id;
    }

    public void setContractCode(String newContractCode) {
        contractCode = newContractCode;
    }

    public void setId(int newId) {
        id = newId;
    }
}
