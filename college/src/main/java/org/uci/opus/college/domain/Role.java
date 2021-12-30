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
import java.util.List;

import org.uci.opus.config.OpusConstants;

/**
 * @author nist
 *
 */
public class Role implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String lang;
    private String active;
    private String role;
    private String roleDescription;
    private int level;
    private List<? extends OpusPrivilege> privileges;

    public Role() {
        this.active = OpusConstants.ACTIVE;
    }

    public Role(String lang, String role, String roleDescription, int level) {
        this();
        this.lang = lang;
        this.role = role;
        this.roleDescription = roleDescription;
        this.level = level;
    }

    public Role(int id, String lang, String active, String role, String roleDescription, int level) {
        super();
        this.id = id;
        this.lang = lang;
        this.active = active;
        this.role = role;
        this.roleDescription = roleDescription;
        this.level = level;
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

    public void setLang(String newLang) {
        lang = newLang;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String newRole) {
        role = newRole;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public String getRoleDescription() {
        return roleDescription;
    }

    public void setRoleDescription(String newRoleDescription) {
        roleDescription = newRoleDescription;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public List<? extends OpusPrivilege> getPrivileges() {
        return privileges;
    }

    public void setPrivileges(List<? extends OpusPrivilege> privileges) {
        this.privileges = privileges;
    }

}
