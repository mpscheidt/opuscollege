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

package org.uci.opus.college.web.form.person;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;

public class StudentOpusUserForm implements IStudentForm {

    private StudentFormShared studentFormShared;
    
    private OpusUser opusUser;
    private OpusUserRole personOpusUserRole;
    private List<Map<String,Object>> userRoles;

    private String currentPassword;
    private String newPassword;
    private String confirmPassword;


    /**
     * @return the personOpusUser
     */
    public OpusUser getOpusUser() {
        return opusUser;
    }

    /**
     * @param personOpusUser the personOpusUser to set
     */
    public void setOpusUser(final OpusUser opusUser) {
        this.opusUser = opusUser;
    }

    /**
     * @return the personOpusUserRole
     */
    public OpusUserRole getPersonOpusUserRole() {
        return personOpusUserRole;
    }

    /**
     * @param personOpusUserRole the personOpusUserRole to set
     */
    public void setPersonOpusUserRole(final OpusUserRole personOpusUserRole) {
        this.personOpusUserRole = personOpusUserRole;
    }

    /**
     * @return the userRoles
     */
    public List<Map<String, Object>> getUserRoles() {
        return userRoles;
    }

    /**
     * @param userRoles the userRoles to set
     */
    public void setUserRoles(final List<Map<String, Object>> userRoles) {
        this.userRoles = userRoles;
    }

    public String getCurrentPassword() {
        return currentPassword;
    }

    public void setCurrentPassword(String currentPassword) {
        this.currentPassword = currentPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    public StudentFormShared getStudentFormShared() {
        return studentFormShared;
    }
    
    public void setStudentFormShared(StudentFormShared studentFormShared) {
        this.studentFormShared = studentFormShared;
    }
    
}
