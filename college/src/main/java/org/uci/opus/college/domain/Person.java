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
import org.uci.opus.config.OpusConstants;

/**
 * @author move
 *
 */
public class Person implements Serializable {

    private static final long serialVersionUID = 1L;

    /* personal data */
    private int id;
    private Date registrationDate;
    protected String personCode;
    private String surnameFull;
    private String surnameAlias;
    private String firstnamesFull;
    private String firstnamesAlias;
    private String nationalRegistrationNumber;
    private String civilTitleCode;
    private String gradeTypeCode;
    private String genderCode;
    private Date birthdate;
    private String nationalityCode;
    private String placeOfBirth;
    private String districtOfBirthCode;
    private String provinceOfBirthCode;
    private String countryOfBirthCode;
    private String cityOfOrigin;
    private String administrativePostOfOriginCode;
    private String districtOfOriginCode;
    private String provinceOfOriginCode;
    private String countryOfOriginCode;
    private String civilStatusCode;
    private String housingOnCampus;
    private String active;
    /* identification */
    private String identificationTypeCode;
    private String identificationNumber;
    private String identificationPlaceOfIssue;
    private Date identificationDateOfIssue;
    private Date identificationDateOfExpiration;
    /* miscellaneous */
    private String professionCode;
    private String professionDescription;
    private String languageFirstCode;
    private String languageFirstMasteringLevelCode;
    private String languageSecondCode;
    private String languageSecondMasteringLevelCode;
    private String languageThirdCode;
    private String languageThirdMasteringLevelCode;
    private String contactPersonEmergenciesName;
    private String contactPersonEmergenciesTelephoneNumber;
    private String bloodTypeCode;
    private String healthIssues;
    private String motivation;
    private String publicHomepage;
    private String socialNetworks;
    private String hobbies;
    private byte[] photograph = null;
    private String photographName;
    private String photographMimeType;
    private String remarks;
    private String writeWho;

    public Person() {
        // default values to prevent database NOT-NULL-exceptions
        publicHomepage = "N";
        active = OpusConstants.ACTIVE;
    }
    
    public Person(String personCode, String surnameFull, String firstnamesFull, Date birthdate) {
        this();
        this.personCode = personCode;
        this.surnameFull = surnameFull;
        this.firstnamesFull = firstnamesFull;
        this.birthdate = birthdate;
    }

    public Date getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(Date newBirthdate) {
        birthdate = newBirthdate;
    }

    public String getCityOfOrigin() {
        return cityOfOrigin;
    }

    public void setCityOfOrigin(String newCityOfOrigin) {
        cityOfOrigin = StringUtils.trim(newCityOfOrigin);
    }

    public String getContactPersonEmergenciesName() {
        return contactPersonEmergenciesName;
    }

    public void setContactPersonEmergenciesName(String newContactPersonEmergenciesName) {
        contactPersonEmergenciesName = newContactPersonEmergenciesName;
    }

    public String getContactPersonEmergenciesTelephoneNumber() {
        return contactPersonEmergenciesTelephoneNumber;
    }

    public void setContactPersonEmergenciesTelephoneNumber(String newContactPersonEmergenciesTelephoneNumber) {
        contactPersonEmergenciesTelephoneNumber = newContactPersonEmergenciesTelephoneNumber;
    }

    public String getFirstnamesAlias() {
        return firstnamesAlias;
    }

    public void setFirstnamesAlias(String newFirstnamesAlias) {
        firstnamesAlias = StringUtils.trim(newFirstnamesAlias);
    }

    public String getFirstnamesFull() {
        return firstnamesFull;
    }

    public void setFirstnamesFull(String newFirstnamesFull) {
        firstnamesFull = StringUtils.trim(newFirstnamesFull);
    }

    public String getHealthIssues() {
        return healthIssues;
    }

    public void setHealthIssues(String newHealthIssues) {
        healthIssues = StringUtils.trim(newHealthIssues);
    }

    public String getMotivation() {
        return motivation;
    }

    public void setMotivation(String motivation) {
        this.motivation = StringUtils.trim(motivation);
    }

    public String getHousingOnCampus() {
        return housingOnCampus;
    }

    public void setHousingOnCampus(String newHousingOnCampus) {
        housingOnCampus = newHousingOnCampus;
    }

    public Date getIdentificationDateOfExpiration() {
        return identificationDateOfExpiration;
    }

    public void setIdentificationDateOfExpiration(Date newIdentificationDateOfExpiration) {
        identificationDateOfExpiration = newIdentificationDateOfExpiration;
    }

    public Date getIdentificationDateOfIssue() {
        return identificationDateOfIssue;
    }

    public void setIdentificationDateOfIssue(Date newIdentificationDateOfIssue) {
        identificationDateOfIssue = newIdentificationDateOfIssue;
    }

    public String getIdentificationNumber() {
        return identificationNumber;
    }

    public void setIdentificationNumber(String newIdentificationNumber) {
        identificationNumber = StringUtils.trim(newIdentificationNumber);
    }

    public String getIdentificationPlaceOfIssue() {
        return identificationPlaceOfIssue;
    }

    public void setIdentificationPlaceOfIssue(String newIdentificationPlaceOfIssue) {
        identificationPlaceOfIssue = StringUtils.trim(newIdentificationPlaceOfIssue);
    }

    public String getNationalRegistrationNumber() {
        return nationalRegistrationNumber;
    }

    public void setNationalRegistrationNumber(String newNationalRegistrationNumber) {
        nationalRegistrationNumber = StringUtils.trim(newNationalRegistrationNumber);
    }

    public String getPersonCode() {
        return personCode;
    }

    public void setPersonCode(String newPersonCode) {
        personCode = StringUtils.trim(newPersonCode);
    }

    public String getPlaceOfBirth() {
        return placeOfBirth;
    }

    public void setPlaceOfBirth(String newPlaceOfBirth) {
        placeOfBirth =StringUtils.trim(newPlaceOfBirth);
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date newRegistrationDate) {
        registrationDate = newRegistrationDate;
    }

    public String getSurnameAlias() {
        return surnameAlias;
    }

    public void setSurnameAlias(String newSurnameAlias) {
        surnameAlias = StringUtils.trim(newSurnameAlias);
    }

    public String getSurnameFull() {
        return surnameFull;
    }

    public void setSurnameFull(String newSurnameFull) {
        surnameFull = StringUtils.trim(newSurnameFull);
    }

    public int getId() {
        return id;
    }

    public void setId(int newId) {
        id = newId;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String newactive) {
        active = newactive;
    }

    public String getGradeTypeCode() {
        return gradeTypeCode;
    }

    public void setGradeTypeCode(String newGradeTypeCode) {
        gradeTypeCode = newGradeTypeCode;
    }

    public String getAdministrativePostOfOriginCode() {
        return administrativePostOfOriginCode;
    }

    public void setAdministrativePostOfOriginCode(String newAdministrativePostOfOriginCode) {
        administrativePostOfOriginCode = newAdministrativePostOfOriginCode;
    }

    public String getBloodTypeCode() {
        return bloodTypeCode;
    }

    public void setBloodTypeCode(String newBloodTypeCode) {
        bloodTypeCode = newBloodTypeCode;
    }

    public String getPublicHomepage() {
        return publicHomepage;
    }

    public void setPublicHomepage(String publicHomepage) {
        this.publicHomepage = publicHomepage;
    }

    public String getSocialNetworks() {
        return socialNetworks;
    }

    public void setSocialNetworks(String socialNetworks) {
        this.socialNetworks = StringUtils.trim(socialNetworks);
    }

    public String getHobbies() {
        return hobbies;
    }

    public void setHobbies(String hobbies) {
        this.hobbies = StringUtils.trim(hobbies);
    }

    public String getCivilStatusCode() {
        return civilStatusCode;
    }

    public void setCivilStatusCode(String newCivilStatusCode) {
        civilStatusCode = newCivilStatusCode;
    }

    public String getCivilTitleCode() {
        return civilTitleCode;
    }

    public void setCivilTitleCode(String newCivilTitleCode) {
        civilTitleCode = newCivilTitleCode;
    }

    public String getCountryOfBirthCode() {
        return countryOfBirthCode;
    }

    public void setCountryOfBirthCode(String newCountryOfBirthCode) {
        countryOfBirthCode = newCountryOfBirthCode;
    }

    public String getCountryOfOriginCode() {
        return countryOfOriginCode;
    }

    public void setCountryOfOriginCode(String newCountryOfOriginCode) {
        countryOfOriginCode = newCountryOfOriginCode;
    }

    public String getDistrictOfBirthCode() {
        return districtOfBirthCode;
    }

    public void setDistrictOfBirthCode(String newDistrictOfBirthCode) {
        districtOfBirthCode = newDistrictOfBirthCode;
    }

    public String getDistrictOfOriginCode() {
        return districtOfOriginCode;
    }

    public void setDistrictOfOriginCode(String newDistrictOfOriginCode) {
        districtOfOriginCode = newDistrictOfOriginCode;
    }

    public String getGenderCode() {
        return genderCode;
    }

    public void setGenderCode(String newGenderCode) {
        genderCode = newGenderCode;
    }

    public String getIdentificationTypeCode() {
        return identificationTypeCode;
    }

    public void setIdentificationTypeCode(String newIdentificationTypeCode) {
        identificationTypeCode = newIdentificationTypeCode;
    }

    public String getLanguageFirstCode() {
        return languageFirstCode;
    }

    public void setLanguageFirstCode(String languageFirstCode) {
        this.languageFirstCode = languageFirstCode;
    }

    public String getLanguageFirstMasteringLevelCode() {
        return languageFirstMasteringLevelCode;
    }

    public void setLanguageFirstMasteringLevelCode(String languageFirstMasteringLevelCode) {
        this.languageFirstMasteringLevelCode = languageFirstMasteringLevelCode;
    }

    public String getLanguageSecondCode() {
        return languageSecondCode;
    }

    public void setLanguageSecondCode(String newLanguageSecondCode) {
        languageSecondCode = newLanguageSecondCode;
    }

    public String getLanguageSecondMasteringLevelCode() {
        return languageSecondMasteringLevelCode;
    }

    public void setLanguageSecondMasteringLevelCode(String newLanguageSecondMasteringLevelCode) {
        languageSecondMasteringLevelCode = newLanguageSecondMasteringLevelCode;
    }

    public String getLanguageThirdCode() {
        return languageThirdCode;
    }

    public void setLanguageThirdCode(String newLanguageThirdCode) {
        languageThirdCode = newLanguageThirdCode;
    }

    public String getLanguageThirdMasteringLevelCode() {
        return languageThirdMasteringLevelCode;
    }

    public void setLanguageThirdMasteringLevelCode(String newLanguageThirdMasteringLevelCode) {
        languageThirdMasteringLevelCode = newLanguageThirdMasteringLevelCode;
    }

    public String getNationalityCode() {
        return nationalityCode;
    }

    public void setNationalityCode(String newNationalityCode) {
        nationalityCode = newNationalityCode;
    }

    public String getProfessionCode() {
        return professionCode;
    }

    public void setProfessionCode(String newProfessionCode) {
        professionCode = newProfessionCode;
    }

    public String getProvinceOfBirthCode() {
        return provinceOfBirthCode;
    }

    public void setProvinceOfBirthCode(String newProvinceOfBirthCode) {
        provinceOfBirthCode = newProvinceOfBirthCode;
    }

    public String getProvinceOfOriginCode() {
        return provinceOfOriginCode;
    }

    public void setProvinceOfOriginCode(String newProvinceOfOriginCode) {
        provinceOfOriginCode = newProvinceOfOriginCode;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = StringUtils.trim(remarks);
    }

    public String getProfessionDescription() {
        return professionDescription;
    }

    public void setProfessionDescription(String professionDescription) {
        this.professionDescription = StringUtils.trim(professionDescription);
    }

    public byte[] getPhotograph() {
        return photograph;
    }

    public void setPhotograph(byte[] photograph) {
        this.photograph = photograph;
    }

    /**
     * Returns the current state of the boolean photograph.
     * 
     * @return boolean yes or no
     */
    public boolean getHasPhoto() {

        if (this.photograph != null) {
            return true;
        } else {
            return false;
        }
    }

    public String getPhotographName() {
        return photographName;
    }

    public void setPhotographName(String photographName) {
        this.photographName = photographName;
    }

    public String getPhotographMimeType() {
        return photographMimeType;
    }

    public void setPhotographMimeType(String photographMimeType) {
        this.photographMimeType = photographMimeType;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

}
