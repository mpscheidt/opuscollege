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
import java.util.Collection;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 * @author nist
 * @author markus
 *
 */
public class OpusUser implements Serializable, UserDetails {

    private static final long serialVersionUID = 1L;

    private int id;
    private int personId;
    private String userName;
    private String pw;
    private String lang;
    private int preferredOrganizationalUnitId;
    private int failedLoginAttempts;
    private String writeWho;

    private StaffMember staffMember;
    private Student student;

    private boolean accountNonLocked = true;

    /**
     * Roles for this user
     */
    private List<GrantedAuthority> authorities;

    public OpusUser() {
    }

    public OpusUser(String userName, String lang, int preferredOrganizationalUnitId) {
        this.userName = userName;
        this.lang = lang;
        this.preferredOrganizationalUnitId = preferredOrganizationalUnitId;
    }

    public OpusUser(String userName, String lang, int preferredOrganizationalUnitId, int personId) {
        this(userName, lang, preferredOrganizationalUnitId);
        this.personId = personId;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String newPw) {
        pw = newPw;
    }

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int newPersonId) {
        personId = newPersonId;
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

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public int getPreferredOrganizationalUnitId() {
        return preferredOrganizationalUnitId;
    }

    public void setPreferredOrganizationalUnitId(int preferredOrganizationalUnitId) {
        this.preferredOrganizationalUnitId = preferredOrganizationalUnitId;
    }

    /**
     * in case the lang has locale variation (e.g. 'en_ZM'), then return the language part only (in this case 'en').
     * 
     * @return
     */
    public String getLang2LetterCode() {
        if (lang == null)
            return null;
        return lang.substring(0, 2);
    }

    public void setAuthorities(List<GrantedAuthority> authorities) {
        this.authorities = authorities;

    }

    @Override
    public Collection<GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    @Override
    public String getPassword() {
        return getPw();
    }

    @Override
    public String getUsername() {
        return userName;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    public void setAccountNonLocked(boolean accountNonLocked) {
        this.accountNonLocked = accountNonLocked;
    }

    @Override
    public boolean isAccountNonLocked() {
        return accountNonLocked;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public int getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(int failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }

    @Override
    public int hashCode() {
        int hashCode = userName == null ? 0 : userName.hashCode();
        return hashCode;
    }

    /**
     * The equals() and hashCode() methods are required to work correctly since Spring Security needs them for map operations to manage
     * multiple logins.
     */
    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof OpusUser))
            return false;

        OpusUser other = (OpusUser) obj;

        // pattern for comparison: ((a == b) || ((a != null) && a.equals(b)))
        boolean q = userName == other.getUsername() || (userName != null && userName.equals(other.getUsername()));
        return q;
    }

    public StaffMember getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(StaffMember staffMember) {
        this.staffMember = staffMember;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    /**
     * Indicate if this is a staffmember.
     * 
     * Note that it would be illegal to call this method isStaffMember() according to the JavaBeans spec, because there would be a name
     * clash with the staffMember property and its {@link #getStaffMember()} and {@link #setStaffMember(StaffMember)} accessor methods.
     * 
     * @return
     */
    public boolean getIsStaffMember() {
        return staffMember != null;
    }

    /**
     * Indicate if this is a staffmember.
     * 
     * Note that it would be illegal to call this method isStudent() according to the JavaBeans spec, because there would be a name clash
     * with the student property and its {@link #getStudent()} and {@link #setStudent(Student)} accessor methods.
     * 
     * @return
     */
    public boolean getIsStudent() {
        return student != null;
    }

}
