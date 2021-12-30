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

import org.uci.opus.config.OpusConstants;

public class AdmissionRegistrationConfig implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int organizationalUnitId;
    private int academicYearId;
    private Date startOfRegistration;
    private Date endOfRegistration;
    private Date startOfAdmission;
    private Date endOfAdmission;
    private Date startOfRefundPeriod;
    private Date endOfRefundPeriod;
    private String active;
    private String writeWho;
    private Date writeWhen;
    
    public AdmissionRegistrationConfig() {
    }

    public AdmissionRegistrationConfig(int organizationalUnitId, int academicYearId) {
        this.organizationalUnitId = organizationalUnitId;
        this.academicYearId = academicYearId;
        this.active = OpusConstants.ACTIVE;
    }

    public void setId(int id) {
        this.id = id;
    }
    public int getId() {
        return id;
    }
    public int getOrganizationalUnitId() {
        return organizationalUnitId;
    }
    public void setOrganizationalUnitId(int organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }
    public int getAcademicYearId() {
        return academicYearId;
    }
    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }
    public Date getStartOfRegistration() {
        return startOfRegistration;
    }
    public void setStartOfRegistration(Date startOfRegistration) {
        this.startOfRegistration = startOfRegistration;
    }
    public Date getEndOfRegistration() {
        return endOfRegistration;
    }
    public void setEndOfRegistration(Date endOfRegistration) {
        this.endOfRegistration = endOfRegistration;
    }
    /**
	 * @return the startOfAdmission
	 */
	public Date getStartOfAdmission() {
		return startOfAdmission;
	}
	/**
	 * @param startOfAdmission the startOfAdmission to set
	 */
	public void setStartOfAdmission(Date startOfAdmission) {
		this.startOfAdmission = startOfAdmission;
	}
	/**
	 * @return the endOfAdmission
	 */
	public Date getEndOfAdmission() {
		return endOfAdmission;
	}
	/**
	 * @param endOfAdmission the endOfAdmission to set
	 */
	public void setEndOfAdmission(Date endOfAdmission) {
		this.endOfAdmission = endOfAdmission;
	}
	
	
	/**
	 * @return the startOfRefundPeriod
	 */
	public Date getStartOfRefundPeriod() {
		return startOfRefundPeriod;
	}
	/**
	 * @param startOfRefundPeriod the startOfRefundPeriod to set
	 */
	public void setStartOfRefundPeriod(Date startOfRefundPeriod) {
		this.startOfRefundPeriod = startOfRefundPeriod;
	}
	/**
	 * @return the endOfRefundPeriod
	 */
	public Date getEndOfRefundPeriod() {
		return endOfRefundPeriod;
	}
	
	/**
	 * @param endOfRefundPeriod the endOfRefundPeriod to set
	 */
	public void setEndOfRefundPeriod(Date endOfRefundPeriod) {
		this.endOfRefundPeriod = endOfRefundPeriod;
	}
	public String getActive() {
        return active;
    }
    public void setActive(String active) {
        this.active = active;
    }
    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }
    public String getWriteWho() {
        return writeWho;
    }
    public void setWriteWhen(Date writeWhen) {
        this.writeWhen = writeWhen;
    }
    public Date getWriteWhen() {
        return writeWhen;
    }
    
}
