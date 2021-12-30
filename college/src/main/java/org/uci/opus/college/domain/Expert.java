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
 * Center for Information Services, Radboud University Nijmegen
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

import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.StringUtil;

/**
 * Used for Referee and ThesisSupervisor
 * @author J. Nooitgedagt
 *
 */
public class Expert implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int studyPlanId;
    private String name;
    private String address;
    private String telephone;
    private String email;
    private int orderBy;
    private String active;
    
    public Expert() {
        active = OpusConstants.GENERAL_YES;
    }
    
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getStudyPlanId() {
        return studyPlanId;
    }
    public void setStudyPlanId(int studyPlanId) {
        this.studyPlanId = studyPlanId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getTelephone() {
        return telephone;
    }
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public int getOrderBy() {
        return orderBy;
    }
    public void setOrderBy(int orderBy) {
        this.orderBy = orderBy;
    }
    
    public String getActive() {
        return active;
    }
    public void setActive(String active) {
        this.active = active;
    }
    public boolean isEmpty() {
        if (StringUtil.isNullOrEmpty(this.getName(), true)
            && StringUtil.isNullOrEmpty(this.getAddress(), true)
            && StringUtil.isNullOrEmpty(this.getTelephone(), true)
            && StringUtil.isNullOrEmpty(this.getEmail(), true)) {
            return true;
        } else {
            return false;
        }
    }
    
    public String toString() {
        return "id = " + id
        + ", studyPlanId = " + studyPlanId
        + ", name = " + name
        + ", address = " + address
        + ", telephone = " + telephone
        + ", email = " + email
        + ", orderBy = " + orderBy;
    }
}
