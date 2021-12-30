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

import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;

public class OpusUserRoleForm {

    private Organization organization;

    /**
     * Currently logged in user
     */
    private OpusUserRole opusUserRole;

    /**
     * User being edited
     */
    private OpusUser editingUser;

    /**
     * Roles possessed by this user
     */
    private List<OpusUserRole> userRoles;
    /**
     * Student being edit
     */
    private Student student;
    /**
     * Staff member being edited
     */
    private StaffMember staffMember;
    /**
     * Tells if user being edited is a student or staff member
     */
    private String userType;
    /**
     * id of user or staffmember "stId" stands for both
     */
    private int stId;

    private List<Role> allRoles;

    private boolean isPreferredOrganizationalUnit;

    public void syncOrganizationWithOpusUserRole() {
        opusUserRole.setInstitutionId(organization.getInstitutionId());
        opusUserRole.setBranchId(organization.getBranchId());
        opusUserRole.setOrganizationalUnitId(organization.getOrganizationalUnitId());
    }

    public OpusUserRole getOpusUserRole() {
        return opusUserRole;
    }

    public void setOpusUserRole(OpusUserRole opusUserRole) {
        this.opusUserRole = opusUserRole;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public StaffMember getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(StaffMember staffMember) {
        this.staffMember = staffMember;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public int getStId() {
        return stId;
    }

    public void setStId(int stId) {
        this.stId = stId;
    }

    public OpusUser getEditingUser() {
        return editingUser;
    }

    public void setEditingUser(OpusUser editingUser) {
        this.editingUser = editingUser;
    }

    public List<Role> getAllRoles() {
        return allRoles;
    }

    public void setAllRoles(List<Role> allRoles) {
        this.allRoles = allRoles;
    }

    public boolean getIsPreferredOrganizationalUnit() {
        return isPreferredOrganizationalUnit;
    }

    public void setIsPreferredOrganizationalUnit(boolean isPreferredOrganizationalUnit) {
        this.isPreferredOrganizationalUnit = isPreferredOrganizationalUnit;
    }

    public List<OpusUserRole> getUserRoles() {
        return userRoles;
    }

    public void setUserRoles(List<OpusUserRole> userRoles) {
        this.userRoles = userRoles;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

}
