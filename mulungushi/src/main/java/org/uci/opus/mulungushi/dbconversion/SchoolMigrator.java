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
 * The Original Code is Opus-College cbu module code.
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
 ******************************************************************************/
package org.uci.opus.mulungushi.dbconversion;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;

public class SchoolMigrator {

    private static final String RO_DESCRIPTION = "Registrar's Office";
	private static final String RO_CODE = "RO";
	private static final String CR_DESCRIPTION = "Central Registry";
	private static final String CR_CODE = "CR";

	private static Logger log = LoggerFactory.getLogger(SchoolMigrator.class);
    @Autowired private DataSource dataSource;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface orgUnitManager;
	@Autowired private DBUtil dbUtil;

    public static final int INSTITUTION_ID = 130;
    
    private OrganizationalUnit registrarsOffice;
    
    private List<OrganizationalUnit> teachingDepartments = new ArrayList<>();

    /**
     * Delete current branch and org. unit data. Then insert new data by calling {@link #findOrInsertSchoolsAndOrgUnits()}.
     * 
     * @throws SQLException
     */
    public void convertSchoolsAndOrgUnits() throws SQLException {

    	log.info("Starting conversion of Schools and departments");
    	log.info("Going to delete existing Schools and departments");

    	dbUtil.truncateTable("organizationalunit");
		dbUtil.truncateTable("branch");

		findOrInsertSchoolsAndOrgUnits();
    }

    /**
     * Find or insert branches and org. units.
     */
    private void findOrInsertSchoolsAndOrgUnits() {
    	
    	log.info("Going to find or insert of Schools and departments");

    	Branch branch = findOrInsert("SBS", "School of Business Studies");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));
    	
    	branch = findOrInsert("SSS", "School of Social Sciences");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));

    	branch = findOrInsert("CICTE", "Centre for Information Communication Technology (ICT) Education");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));

    	branch = findOrInsert("SANR", "School of Agriculture and Natural Resources");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));

    	branch = findOrInsert("IDE", "Institute for Distance Education (IDE)");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));
    	
    	branch = findOrInsert("DPRS", "Directorate for Postgraduate and Research Studies");
    	teachingDepartments.add(findOrAddDepartment(branch, null, null));
    
    	branch = findOrInsert(CR_CODE, CR_DESCRIPTION);
    	registrarsOffice = findOrAddDepartment(branch, RO_CODE, RO_DESCRIPTION);
    
    }

    private Branch findOrInsert(String code, String description) {

    	Map<String, Object> map = new HashMap<>();
    	map.put("institutionId", INSTITUTION_ID);
    	map.put("branchCode", code);
    	map.put("branchDescription", description);
    	Branch branch = branchManager.findBranchByParams(map);
    	
    	if (branch == null) {
	    	branch = new Branch();
	    	branch.setBranchDescription(description);
	    	branch.setBranchCode(code);
	    	branch.setInstitutionId(INSTITUTION_ID);
	    	branch.setActive("Y");
	    	branchManager.addBranch(branch);
	    	branch = branchManager.findBranchByParams(map);
    	}

    	return branch;

    }

    private OrganizationalUnit findOrAddDepartment(Branch branch, String deartmentCode, String departmentDescription) {
    	
    	String teachingDepartmentCode = deartmentCode == null ? branch.getBranchCode() + "_TD" : deartmentCode;
    	String teachingDepartmentDescription = departmentDescription == null ? "Teaching Department" : departmentDescription;

    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("organizationalUnitCode", teachingDepartmentCode);
    	map.put("organizationalUnitDescription", teachingDepartmentDescription);
    	OrganizationalUnit unit = null; //orgUnitManager.findOrganizationalUnitByNameAndCode(map);
//    	
//    	if (unit == null) {
//	    	unit = new OrganizationalUnit();
//	    	unit.setActive("Y");
//	    	unit.setOrganizationalUnitCode(teachingDepartmentCode);
//			unit.setOrganizationalUnitDescription(teachingDepartmentDescription);
//	    	unit.setBranchId(branch.getId());
//	    	unit.setUnitLevel(1);
//	    	unit.setUnitAreaCode("0");
//	    	unit.setUnitTypeCode("0");
//	    	unit.setDirectorId(0);
//	    	unit.setParentOrganizationalUnitId(0);
//	    	unit.setAcademicFieldCode("0");
//	    	unit.setRegistrationDate(new Date());
//	    	orgUnitManager.addOrganizationalUnit(unit);
//	    	unit = orgUnitManager.findOrganizationalUnitByNameAndCode(map);
//    	}
    	
    	return unit;
    }

	public List<OrganizationalUnit> getTeachingDepartments() {
		if (teachingDepartments.isEmpty()) {
			findOrInsertSchoolsAndOrgUnits();
		}
		return teachingDepartments;
	}

	public OrganizationalUnit getRegistrarsOffice() {
		if (registrarsOffice == null) {
			findOrInsertSchoolsAndOrgUnits();
		}
		return registrarsOffice;
	}

}
