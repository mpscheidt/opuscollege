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
 * @author J. Nooitgedagt Highest level of organization
 *
 */
public class Institution implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String institutionCode;
    private String institutionDescription;
    private String institutionTypeCode;
    private String countryCode;
    private String provinceCode;
    private String rector;
    private String active = "Y";

    public Institution() {
    }

    public Institution(String code, String description, String institutionTypeCode) {
        this.institutionCode = code;
        this.institutionDescription = description;
        this.institutionTypeCode = institutionTypeCode;
        this.active = "Y";
        this.provinceCode = "";
    }

    /**
     * @return Returns whether or not the institution is active.
     */
    public String getActive() {
        return active;
    }

    /**
     * @param active
     *            is set by Spring on application init.
     */
    public void setActive(String active) {
        this.active = active;
    }

    public String getInstitutionTypeCode() {
        return institutionTypeCode;
    }

    public void setInstitutionTypeCode(String institutionTypeCode) {
        this.institutionTypeCode = institutionTypeCode;
    }

    public String getProvinceCode() {
        return provinceCode;
    }

    public void setProvinceCode(String newProvinceCode) {
        provinceCode = newProvinceCode;
    }

    /**
     * @return Returns the institutionDescription.
     */
    public String getInstitutionDescription() {
        return institutionDescription;
    }

    /**
     * @param institutionDescription
     *            The institutionDescription to set.
     */
    public void setInstitutionDescription(String institutionDescription) {
        this.institutionDescription = StringUtils.trim(institutionDescription);
    }

    /**
     * @return Returns the institutionCode.
     */
    public String getInstitutionCode() {
        return institutionCode;
    }

    /**
     * @param institutionCode
     *            The unique institutionCode to set.
     */
    public void setInstitutionCode(String institutionCode) {
        this.institutionCode = StringUtils.trim(institutionCode);
    }

    /**
     * @return Returns the rector.
     */
    public String getRector() {
        return rector;
    }

    /**
     * @param rector
     *            The rector to set.
     */
    public void setRector(String rector) {
        this.rector = StringUtils.trim(rector);
    }

    public int getId() {
        return id;
    }

    public void setId(int newId) {
        id = newId;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

}
