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
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.uci.opus.config.OpusConstants;

/**
 * @author J.Nooitgedagt
 * An organizational unit is everything from a university to a faculty or department
 *
 */
public class OrganizationalUnit implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String organizationalUnitCode;
    private String organizationalUnitDescription;
    private int branchId;
    private int unitLevel;
    private int parentOrganizationalUnitId;
    private String unitAreaCode;
    private String unitTypeCode;
    private String academicFieldCode;
    private int directorId;
    private String active;
    private Date registrationDate;
    private List <Address> addresses;
    private List <AdmissionRegistrationConfig> admissionRegistrationConfigs;
    
    public OrganizationalUnit() {
    }

    public OrganizationalUnit(String code, String description, int branchId) {
        this.organizationalUnitCode = code;
        this.organizationalUnitDescription = description;
        this.branchId = branchId;
        this.unitLevel = 1;
        this.parentOrganizationalUnitId = 0;
        this.unitAreaCode = "";
        this.unitTypeCode = "";
        this.academicFieldCode = "";
        this.directorId = 0;
        this.active = OpusConstants.ACTIVE;
    }
    
    /**
     * @return Returns the director.
     */
    public int getDirectorId() {
        return directorId;
    }
    /**
     * @param directorId This is the personId of the director.
     */
    public void setDirectorId(int directorId) {
        this.directorId = directorId;
    }
   
    /**
     * @return Returns the organizationalUnitDescription.
     */
    public String getOrganizationalUnitDescription() {
        return organizationalUnitDescription;
    }
    /**
     * @param organizationalUnitDescription The organizationalUnitDescription to set.
     */
    public void setOrganizationalUnitDescription(
            String organizationalUnitDescription) {
        this.organizationalUnitDescription = StringUtils.trim(organizationalUnitDescription);
    }
    /**
     * @return Returns the organizationalUnitCode.
     */
    public String getOrganizationalUnitCode() {
        return organizationalUnitCode;
    }
    /**
     * @param organizationalUnitCode The organizationalUnitCode to set.
     */
    public void setOrganizationalUnitCode(String organizationalUnitCode) {
        this.organizationalUnitCode = StringUtils.trim(organizationalUnitCode);
    }
    /**
     * @return Returns the registrationDate.
     */
    public Date getRegistrationDate() {
        return registrationDate;
    }
    /**
     * @param registrationDate The registrationDate to set.
     */
    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }
    /**
     * @return Returns the unitLevel.
     */
    public int getUnitLevel() {
        return unitLevel;
    }
    /**
     * @param unitLevel The unitLevel to set.
     */
    public void setUnitLevel(int unitLevel) {
        this.unitLevel = unitLevel;
    }
    
    public int getParentOrganizationalUnitId() {
		return parentOrganizationalUnitId;
	}
	public void setParentOrganizationalUnitId(int parentOrganizationalUnitId) {
		this.parentOrganizationalUnitId = parentOrganizationalUnitId;
	}
	public String getAcademicFieldCode() {
        return academicFieldCode;
    }
    public void setAcademicFieldCode(String newAcademicFieldCode) {
        academicFieldCode = newAcademicFieldCode;
    }
    public String getUnitAreaCode() {
        return unitAreaCode;
    }
    public void setUnitAreaCode(String newUnitAreaCode) {
        unitAreaCode = newUnitAreaCode;
    }
    public String getUnitTypeCode() {
        return unitTypeCode;
    }
    public void setUnitTypeCode(String newUnitTypeCode) {
        unitTypeCode = newUnitTypeCode;
    }
    /**
     * @return Returns the addresses.
     */
    public List  <Address> getAddresses() {
        return addresses;
    }
    /**
     * @param addresses The addresses to set.
     */
    public void setAddresses(List <Address> addresses) {
        this.addresses = addresses;
    }
    /**
     * @return Returns the branchId.
     */
    public int getBranchId() {
        return branchId;
    }
    /**
     * @param branchId The branchId to set.
     */
    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }
    public int getId() {
        return id;
    }
    public void setId(int newId) {
        id = newId;
    }
    /**
     * @return Returns whether or not the organizationalUnit is active.
     */
    public String getActive() {
        return active;
    }
    /**
     * @param active is set by Spring on application init.
     */
    public void setActive(String active) {
        this.active = active;
    }

    public void setAdmissionRegistrationConfigs(List<AdmissionRegistrationConfig> admissionRegistrationConfigs) {
        this.admissionRegistrationConfigs = admissionRegistrationConfigs;
    }

    public List <AdmissionRegistrationConfig> getAdmissionRegistrationConfigs() {
        return admissionRegistrationConfigs;
    }       
}

