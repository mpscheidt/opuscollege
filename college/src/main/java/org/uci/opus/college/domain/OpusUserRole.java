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

import org.apache.commons.lang3.StringUtils;

/**
 * @author nist
 */
public class OpusUserRole implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String role;
    private String userName;
    private Date validFrom;
    private Date validThrough;
    private int institutionId;
    private int branchId;
    private int organizationalUnitId;

    public OpusUserRole() {
    }

    public OpusUserRole(String userName, String role, int organizationalUnitId) {
        this.userName = userName;
        this.role = role;
        this.organizationalUnitId = organizationalUnitId;
    }

    @Override
    public String toString() {
        return "OpusUserRole [id=" + id + ", role=" + role + ", userName=" + userName + ", validFrom=" + validFrom + ", validThrough=" + validThrough
                + ", institutionId=" + institutionId + ", branchId=" + branchId + ", organizationalUnitId=" + organizationalUnitId + "]";
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String newUserName) {
        userName = StringUtils.trim(newUserName);
    }

    public int getId() {
        return id;
    }

    public void setId(int newId) {
        id = newId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String newRole) {
        role = newRole;
    }

    public int getOrganizationalUnitId() {
        return organizationalUnitId;
    }

    public void setOrganizationalUnitId(int organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validThrough) {
        this.validFrom = validThrough;
    }

    public Date getValidThrough() {
        return validThrough;
    }

    public void setValidThrough(Date validThrough) {
        this.validThrough = validThrough;
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
}
