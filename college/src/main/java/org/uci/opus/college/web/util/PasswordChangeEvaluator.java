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

package org.uci.opus.college.web.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.util.Encode;
import org.uci.opus.util.StringUtil;

public class PasswordChangeEvaluator {

    private HttpServletRequest request;
    private String currentPassword;
    private String newPassword;
    private String confirmPassword;
    private OpusUser opusUser;
    private String dbPw;
    
    /**
     * Flag is set to true if password has been successfully changed.
     */
    private boolean pwdChanged = false;
    
    public PasswordChangeEvaluator(HttpServletRequest request, OpusUser opusUser,
            String dbPw, String currentPassword, String newPassword, String confirmPassword) {
        this.request = request;
        this.opusUser = opusUser;
        this.dbPw = dbPw;
        this.currentPassword = currentPassword;
        this.newPassword = newPassword;
        this.confirmPassword = confirmPassword;
    }
    
    public void checkAndSetPassword(BindingResult result) {
        String currentPasswordField = "currentPassword";
        String newPasswordField = "newPassword";
        String confirmPasswordField = "confirmPassword";
        
        boolean resetPasswordPrivilege = request.isUserInRole("RESET_PASSWORD");
        
        // TODO #793: Don't allow resetting the admin's password by non-admin, ie. by someone with level > 1
        //      probably best to only allow resetting passwords for users with level >= logged-in user's level
        if (!resetPasswordPrivilege) {
            if (StringUtil.isNullOrEmpty(currentPassword)) {
                result.rejectValue(currentPasswordField, "invalid.empty.format");
            } else {
                // check if user's current password has been entered correctly to gain privilege to alter password
                String currentPwEncrypted = Encode.encodeMd5(currentPassword);
                if (!currentPwEncrypted.equals(dbPw)) {
                    result.rejectValue(currentPasswordField, "jsp.error.password.currentpasswordincorrect");
                }
            }
        }
        if (StringUtil.isNullOrEmpty(newPassword)) {
            result.rejectValue(newPasswordField, "invalid.empty.format");
        }
        if (StringUtil.isNullOrEmpty(confirmPassword)) {
            result.rejectValue(confirmPasswordField, "invalid.empty.format");
        }

        if (result.hasErrors()) {
            return;
        }

        // has to have at least 8 characters
        if (newPassword.length() < 8) {
            result.rejectValue(newPasswordField, "jsp.error.password.tooshort");
        }
        
        // We don't want white spaces in the password
        if (StringUtils.containsWhitespace(newPassword)) {
            result.rejectValue(newPasswordField, "jsp.error.password.whitespace");
        }
        
        // check password strength: one or more non-letters
        if (org.apache.commons.lang3.StringUtils.isAlpha(newPassword)) {
            result.rejectValue(newPasswordField, "jsp.error.password.specialchar");
        }
        
        if (!newPassword.equals(confirmPassword)) {
            result.rejectValue(confirmPasswordField, "jsp.error.password.notequal");
        }

        if (result.hasErrors()) {
            return;
        }

        opusUser.setPw(Encode.encodeMd5(newPassword));
        pwdChanged = true;
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

    public boolean isPwdChanged() {
        return pwdChanged;
    }

}
