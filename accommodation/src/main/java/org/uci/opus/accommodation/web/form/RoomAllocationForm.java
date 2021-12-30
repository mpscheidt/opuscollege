/*******************************************************************************
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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
 ******************************************************************************/
package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.domain.util.IdToStudyGradeTypeMap;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.util.CodeToLookupMap;

public class RoomAllocationForm {

	private Organization organization;
	private NavigationSettings navigationSettings;
	private OrganizationalUnit organizationalUnit;
	private Institution institution;
	private Branch branch;
	private int cardinalTimeUnitNumber;
	private Study study;
	private StudyGradeType studyGradeType;
	private String approved;
	
	private StudentAccommodation studentAccommodation;
	
	private List<AcademicYear> academicYears;
	private List<Hostel> hostels;
	private List<HostelBlock> blocks;
	private List<Room> rooms;
	private List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits;
	private IdToStudyGradeTypeMap idToStudyGradeTypeMap;
	private IdToAcademicYearMap idToAcademicYearMap;
	private CodeToLookupMap codeToStudyIntensityMap;
    private CodeToLookupMap codeToCardinalTimeUnitMap;

	boolean useHostelBlocks;
	
	String txtErr;
	String txtMsg;

	public RoomAllocationForm() {
		txtErr = "";
		txtMsg = "";
		institution = new Institution();
	}
	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}

	/**
	 * @param organization
	 *            the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;

	}

	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}

	/**
	 * @param navigationSettings
	 *            the navigationSettings to set
	 */
	public void setNavigationSettings(
			final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}

	/**
	 * @param studyError
	 *            the txtErr to set
	 */
	public void setTxtErr(final String txtErr) {
		this.txtErr = txtErr;
	}

	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}

	/**
	 * @param txtMsg
	 *            the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}

	/**
	 * 
	 * @return the OrganizationalUnit
	 */
	public OrganizationalUnit getOrganizationalUnit() {
		return organizationalUnit;
	}

	/**
	 * 
	 * @param organizationalUnit
	 *            the organizationalUnit to set
	 */
	public void setOrganizationalUnit(OrganizationalUnit organizationalUnit) {
		this.organizationalUnit = organizationalUnit;
	}

	public Institution getInstitution() {
		return institution;
	}

	public void setInstitution(Institution institution) {
		this.institution = institution;
	}

	public Branch getBranch() {
		return branch;
	}

	public void setBranch(Branch branch) {
		this.branch = branch;
	}

	public int getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}

	public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
		this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
	}

	public Study getStudy() {
		return study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public StudyGradeType getStudyGradeType() {
		return studyGradeType;
	}

	public void setStudyGradeType(StudyGradeType studyGradeType) {
		this.studyGradeType = studyGradeType;
	}

	public String getApproved() {
		return approved;
	}

	public void setApproved(String approved) {
		this.approved = approved;
	}

	public StudentAccommodation getStudentAccommodation() {
		return studentAccommodation;
	}

	public void setStudentAccommodation(StudentAccommodation studentAccommodation) {
		this.studentAccommodation = studentAccommodation;
	}

	public List<AcademicYear> getAcademicYears() {
		return academicYears;
	}

	public void setAcademicYears(List<AcademicYear> academicYears) {
		this.academicYears = academicYears;
	}

	public List<Hostel> getHostels() {
		return hostels;
	}

	public void setHostels(List<Hostel> hostels) {
		this.hostels = hostels;
	}

	public List<HostelBlock> getBlocks() {
		return blocks;
	}

	public void setBlocks(List<HostelBlock> blocks) {
		this.blocks = blocks;
	}

	public List<Room> getRooms() {
		return rooms;
	}

	public void setRooms(List<Room> rooms) {
		this.rooms = rooms;
	}
	public boolean getUseHostelBlocks() {
		return useHostelBlocks;
	}
	public void setUseHostelBlocks(boolean useHostelBlocks) {
		this.useHostelBlocks = useHostelBlocks;
	}
    public List<StudyPlanCardinalTimeUnit> getStudyPlanCardinalTimeUnits() {
        return studyPlanCardinalTimeUnits;
    }
    public void setStudyPlanCardinalTimeUnits(
            List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits) {
        this.studyPlanCardinalTimeUnits = studyPlanCardinalTimeUnits;
    }
    public IdToStudyGradeTypeMap getIdToStudyGradeTypeMap() {
        return idToStudyGradeTypeMap;
    }
    public void setIdToStudyGradeTypeMap(IdToStudyGradeTypeMap idToStudyGradeTypeMap) {
        this.idToStudyGradeTypeMap = idToStudyGradeTypeMap;
    }
    public IdToAcademicYearMap getIdToAcademicYearMap() {
        return idToAcademicYearMap;
    }
    public void setIdToAcademicYearMap(IdToAcademicYearMap idToAcademicYearMap) {
        this.idToAcademicYearMap = idToAcademicYearMap;
    }
    public CodeToLookupMap getCodeToStudyIntensityMap() {
        return codeToStudyIntensityMap;
    }
    public void setCodeToStudyIntensityMap(CodeToLookupMap codeToStudyIntensityMap) {
        this.codeToStudyIntensityMap = codeToStudyIntensityMap;
    }
    public CodeToLookupMap getCodeToCardinalTimeUnitMap() {
        return codeToCardinalTimeUnitMap;
    }
    public void setCodeToCardinalTimeUnitMap(CodeToLookupMap codeToCardinalTimeUnitMap) {
        this.codeToCardinalTimeUnitMap = codeToCardinalTimeUnitMap;
    }
	
}