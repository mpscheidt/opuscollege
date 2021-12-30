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
public class Address implements Serializable {

    private static final long serialVersionUID = 1L;

	private int id;
	private String addressTypeCode;
	private int organizationalUnitId;
	private int personId;
	private int studyId;
	private String street;
	private int number;
	private String numberExtension;
	private String zipCode;
	private String POBox;
	private String city;
	private String administrativePostCode;
	private String districtCode;
	private String provinceCode;
	private String countryCode;
	private String telephone;
	private String faxNumber;
	private String mobilePhone;
	private String emailAddress;

	public String getCity() {
		return city;
	}

	public void setCity(String newCity) {
		city = StringUtils.trim(newCity);
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String newEmailAddress) {
		emailAddress = StringUtils.trim(newEmailAddress);
	}

	public String getFaxNumber() {
		return faxNumber;
	}

	public void setFaxNumber(String newFaxNumber) {
		faxNumber = StringUtils.trim(newFaxNumber);
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String newMobilePhone) {
		mobilePhone = StringUtils.trim(newMobilePhone);
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int newNumber) {
		number = newNumber;
	}

	public String getNumberExtension() {
		return numberExtension;
	}

	public void setNumberExtension(String newNumberExtension) {
		numberExtension = StringUtils.trim(newNumberExtension);
	}

	public int getPersonId() {
		return personId;
	}

	public void setPersonId(int newPersonId) {
		personId = newPersonId;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String newStreet) {
		street = StringUtils.trim(newStreet);
	}

	public int getStudyId() {
		return studyId;
	}

	public void setStudyId(int newStudyId) {
		studyId = newStudyId;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String newTelephone) {
		telephone = StringUtils.trim(newTelephone);
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String newZipCode) {
		zipCode = StringUtils.trim(newZipCode);
	}

	public String getPOBox() {
		return POBox;
	}

	public void setPOBox(String box) {
		POBox = StringUtils.trim(box);
	}

	public String getAddressTypeCode() {
		return addressTypeCode;
	}

	public void setAddressTypeCode(String newAddressTypeCode) {
		addressTypeCode = newAddressTypeCode;
	}

	public String getAdministrativePostCode() {
		return administrativePostCode;
	}

	public void setAdministrativePostCode(
			String newAdministrativePostCode) {
		administrativePostCode = newAdministrativePostCode;
	}

	public String getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(String newCountryCode) {
		countryCode = newCountryCode;
	}

	public String getDistrictCode() {
		return districtCode;
	}

	public void setDistrictCode(String newDistrictCode) {
		districtCode = newDistrictCode;
	}

	public String getProvinceCode() {
		return provinceCode;
	}

	public void setProvinceCode(String newProvinceCode) {
		provinceCode = newProvinceCode;
	}

	/**
	 * @return Returns the organizationalUnitId.
	 */
	public int getOrganizationalUnitId() {
		return organizationalUnitId;
	}

	/**
	 * @param newOrganizationalUnitId
	 *            The organizationalUnitId to set.
	 */
	public void setOrganizationalUnitId(int newOrganizationalUnitId) {
		this.organizationalUnitId = newOrganizationalUnitId;
	}

	public int getId() {
		return id;
	}

	public void setId(int newId) {
		id = newId;
	}
    
    public String toString() {
        return
        "\n Address is: "
        + "\n id = " + id
        + "\n addressTypeCode = " + addressTypeCode
        + "\n organizationalUnitId = " + organizationalUnitId
        + "\n personId = " + personId
        + "\n studyId = " + studyId
        + "\n street = " + street
        + "\n number = " + number
        + "\n numberExtension = " + numberExtension
        + "\n zipCode = " + zipCode
        + "\n POBox = " + POBox
        + "\n city = " + city
        + "\n administrativePostCode = " + administrativePostCode
        + "\n districtCode = " + districtCode
        + "\n provinceCode = " + provinceCode
        + "\n countryCode = " + countryCode
        + "\n telephone = " + telephone
        + "\n faxNumber = " + faxNumber
        + "\n mobilePhone = " + mobilePhone
        + "\n emailAddress = " + emailAddress;
    }

}
