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

import org.apache.commons.lang3.StringUtils;

/**
 * @author move
 *
 */
public class Lookup implements ILookup, Serializable, Cloneable {

    private static final long serialVersionUID = 1L;

    private String lang;
    private String active;
    private int id;
    private String code;
    private String description;

    public Lookup() {
    }

    public Lookup(String lang, String code, String description) {
        this.lang = lang;
        this.code = code;
        this.description = description;
        this.active = "Y";
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public String getCode() {
        return code;
    }

    @Override
    public void setCode(String newCode) {
        code = StringUtils.trim(newCode);
    }

    @Override
    public void setDescription(String newDescription) {
        description = StringUtils.trim(newDescription);
    }

    @Override
    public int getId() {
        return id;
    }

    @Override
    public void setId(int newId) {
        id = newId;
    }

    @Override
    public String getLang() {
        return lang;
    }

    @Override
    public void setLang(String newLang) {
        lang = newLang;
    }

    @Override
    public String getActive() {
        return active;
    }

    @Override
    public void setActive(String newactive) {
        active = newactive;
    }

    @Override
    public Object clone() {
        try {
            return super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return "id = " + id + ", code = " + code + ", description = " + description + ", lang = " + lang + ", active = " + active;
    }

    @Override
    public int hashCode() {
        int hashCode = code == null ? 0 : code.hashCode();
        return hashCode;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Lookup))
            return false;
        Lookup other = (Lookup) obj;

        // pattern for comparison: ((a == b) || ((a != null) && a.equals(b)))
        boolean q = code == other.getCode() || (code != null && code.equals(other.getCode()));
        return q;
    }

}
