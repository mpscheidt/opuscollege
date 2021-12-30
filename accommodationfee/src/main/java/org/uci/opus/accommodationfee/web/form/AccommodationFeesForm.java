/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 
 * 1.1 (the "License"), you may not use this file except in compliance with 
 * the License. You may obtain a copy of the License at 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College accommodationfee module code.
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

package org.uci.opus.accommodationfee.web.form;

import java.util.List;

import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;

public class AccommodationFeesForm {

    private NavigationSettings navigationSettings;
    private List<Lookup> allHostelTypes;
    private List<Lookup> allRoomTypes;
    private List<AcademicYear> allAcademicYears;
    private List<AccommodationFee> allAccommodationFees;

    // filter values
    private String hostelTypeCode;
    private String roomTypeCode;
    private int academicYearId;

    // utility
    private CodeToLookupMap codeToHostelTypeMap;
    private CodeToLookupMap codeToRoomTypeMap;
    private IdToAcademicYearMap idToAcademicYearMap;
    private CodeToLookupMap codeToFeeUnitMap;


    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setAllHostelTypes(List<Lookup> allHostelTypes) {
        this.allHostelTypes = allHostelTypes;
    }

    public List<Lookup> getAllHostelTypes() {
        return allHostelTypes;
    }

    public void setAllRoomTypes(List<Lookup> allRoomTypes) {
        this.allRoomTypes = allRoomTypes;
    }

    public List<Lookup> getAllRoomTypes() {
        return allRoomTypes;
    }

    public void setAllAcademicYears(List<AcademicYear> allAcademicYears) {
        this.allAcademicYears = allAcademicYears;
    }

    public List<AcademicYear> getAllAcademicYears() {
        return allAcademicYears;
    }

    public void setAllAccommodationFees(List<AccommodationFee> allAccommodationFees) {
        this.allAccommodationFees = allAccommodationFees;
    }

    public List<AccommodationFee> getAllAccommodationFees() {
        return allAccommodationFees;
    }

    public String getHostelTypeCode() {
        return hostelTypeCode;
    }

    public void setHostelTypeCode(String hostelTypeCode) {
        this.hostelTypeCode = hostelTypeCode;
    }

    public String getRoomTypeCode() {
        return roomTypeCode;
    }

    public void setRoomTypeCode(String roomTypeCode) {
        this.roomTypeCode = roomTypeCode;
    }

    public int getAcademicYearId() {
        return academicYearId;
    }

    public void setAcademicYearId(int academicYearId) {
        this.academicYearId = academicYearId;
    }

    public CodeToLookupMap getCodeToHostelTypeMap() {
        return codeToHostelTypeMap;
    }

    public void setCodeToHostelTypeMap(CodeToLookupMap codeToHostelTypeMap) {
        this.codeToHostelTypeMap = codeToHostelTypeMap;
    }

    public CodeToLookupMap getCodeToRoomTypeMap() {
        return codeToRoomTypeMap;
    }

    public void setCodeToRoomTypeMap(CodeToLookupMap codeToRoomTypeMap) {
        this.codeToRoomTypeMap = codeToRoomTypeMap;
    }

    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }

    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }

    public CodeToLookupMap getCodeToFeeUnitMap() {
        return codeToFeeUnitMap;
    }

    public void setCodeToFeeUnitMap(CodeToLookupMap codeToFeeUnitMap) {
        this.codeToFeeUnitMap = codeToFeeUnitMap;
    }

}
