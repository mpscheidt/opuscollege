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
 * The Original Code is Opus-College unza module code.
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
/*
 package org.uci.opus.unza.dbconversion;

 import org.apache.log4j.Logger;

 import java.sql.SQLException;
 import java.util.Date;
 import java.util.HashMap;
 import java.util.List;
 import java.util.Map;

 import javax.sql.DataSource;

 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.jdbc.core.JdbcTemplate;
 import org.uci.opus.college.service.BranchManager;
 import org.uci.opus.college.service.InstitutionManagerInterface;
 import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
 import org.uci.opus.college.domain.OrganizationalUnit;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.jdbc.core.JdbcTemplate;

 *//**
 * @author Katuta Gilchrist Kaunda
 * 
 */
/*
 public class UnzaOrganizationalUnitMigrator {
 private static Logger log = Logger
 .getLogger(UnzaOrganizationalUnitMigrator.class);
 private DataSource srsDataSource;
 private DataSource opusDataSource;
 @Autowired
 private OrganizationalUnitManagerInterface orgUnitManager;
 @Autowired
 private BranchManager branchManager;
 @Autowired
 private InstitutionManagerInterface iManager;

 public DataSource getOpusDataSource() {
 return opusDataSource;
 }

 public void setOpusDataSource(DataSource opusDataSource) {
 this.opusDataSource = opusDataSource;
 }

 public DataSource getSrsDataSource() {
 return srsDataSource;
 }

 public void setSrsDataSource(DataSource srsDataSource) {
 this.srsDataSource = srsDataSource;
 }

 public void convertOrganizationalUnit() throws SQLException {
 log.info("Migrating Organizational units ...");
 JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
 String query = "delete from opuscollege.organizationalunit  "
 + "where organizationalunitcode"
 + " in (select cost_center_id from srsdatastage.cost_centers)";
 String eliminateSpaces ="UPDATE srsdatastage.cost_centers  " +
 "SET cost_center_id = trim(both from cost_center_id)";
 opusJdbcTemplate.execute(query);
 opusJdbcTemplate.execute(eliminateSpaces);
 //		String query2 = "delete from opuscollege.organizationalunit  "
 //				+ "where organizationalunitcode"
 //				+ " in (select code from srsdatastage.school)";
 //		opusJdbcTemplate.execute(query2);
 JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
 // This data is coming from the HR system
 List<Map<String, Object>> orgUnitList = jdbcTemplate
 .queryForList("select * from srsdatastage.school");


 * Move Parent Units from School Table. This section creates an org unit
 * with the same name as the school. This is the default to which all
 * staff should be tied.

 for (Map<String, Object> oUnit : orgUnitList) {
 log.info("%%%%%%%%%%%%%Parent Units%%%%%%%%%%%");
 log.info("Parent: " + oUnit);
 Extract data from the map objects 
 int code = Integer.parseInt(oUnit.get("code").toString());
 String uname = (String) oUnit.get("uname");
 String usch = (String) oUnit.get("usch");

 // check for nulls
 if (uname == null)
 uname = "0";
 if (usch == null)
 usch = "0";

 OrganizationalUnit orgUnit = new OrganizationalUnit();
 OrganizationalUnit existingUnit = null;
 // These values will be coming from the database on which HR is
 // running
 orgUnit.setAcademicFieldCode("");
 orgUnit.setActive("Y");
 // orgUnit.setAddresses("Test");
 // orgUnit.setBranchId(242);
 Load Institution 
 HashMap<String, Object> imap = new HashMap<String, Object>();
 imap.put("institutionCode", "UNZA02");
 imap.put("institutionTypeCode", "3");
 imap.put("institutionDescription", "University of Zambia-PHASE1");
 imap.put("provinceCode", "05");

 Load the Branch 
 HashMap<String, Object> bmap = new HashMap<String, Object>();
 bmap.put("institutionId", iManager.findInstitutionByParams(imap)
 .getId());
 bmap.put("branchCode", (oUnit.get("code")).toString());
 bmap.put("branchDescription", (String) oUnit.get("uname"));
 log.info("Branch Map " + bmap);

 if (bmap.get("branchCode") != null
 && bmap.get("branchDescription") != null)
 orgUnit.setBranchId(branchManager.findBranchByParams(bmap)
 .getId());// very important must be set to existing
 // branch use lookup

 orgUnit.setDirectorId(1);
 // orgUnit.setId(1);
 orgUnit.setOrganizationalUnitCode(Integer.toString(code).trim());
 orgUnit.setOrganizationalUnitDescription(uname.trim());
 orgUnit.setParentOrganizationalUnitId(code);
 orgUnit.setRegistrationDate(new Date());
 orgUnit.setUnitAreaCode("0");// Verify this
 orgUnit.setUnitLevel(1);
 orgUnit.setUnitTypeCode("2");// revist this after populating
 // unittype lookup table

 // persist the unit
 log.info("Org_unit_code:"+orgUnit.getOrganizationalUnitCode() + " "
 + "Org_unit_descr"+orgUnit.getOrganizationalUnitDescription());
 // check if unit already exists
 HashMap<String, Object> omap = new HashMap<String, Object>();
 omap.put("organizationalUnitDescription", orgUnit
 .getOrganizationalUnitDescription().trim());
 omap.put("organizationalUnitCode", orgUnit
 .getOrganizationalUnitCode().trim());
 existingUnit = orgUnitManager
 .findOrganizationalUnitByNameAndCode(omap);
 if (existingUnit == null) {
 //move to next Unit in the list 
 //continue;
 log.info("Is the org object empty ?" + existingUnit == null);
 log.info("Organization code ==>"
 + existingUnit.getOrganizationalUnitCode()
 + " Organization description ==>"
 + existingUnit.getOrganizationalUnitDescription());
 orgUnitManager.addOrganizationalUnit(orgUnit);
 }
 // new Boolean(existingUnit== null)


 log.info(orgUnit);
 log.info(oUnit);
 }

 Move Child units from the cost_centers table 
 List<Map<String, Object>> orgChildUnitList = jdbcTemplate
 .queryForList("select * from srsdatastage.cost_centers cc,srsdatastage.school sc where sc.code = cc.srs_schcode");
 for (Map<String, Object> cUnit : orgChildUnitList) {
 log.info("%%%%%%%%%%%%%Child Units%%%%%%%%%%%");
 log.info("Child Unit: " + cUnit);

 Extract data from the map objects 
 int code = Integer.parseInt(cUnit.get("code").toString());
 String uname = (String) cUnit.get("uname");
 String usch = (String) cUnit.get("usch");
 String costCenterCode = (String) cUnit.get("cost_center_id");
 String cname = (String) cUnit.get("name");
 log.info("Cost Ceneter:" + costCenterCode);
 // check for nulls
 if (uname == null)
 uname = "0";
 if (usch == null)
 usch = "0";

 OrganizationalUnit orgUnit = new OrganizationalUnit();
 // These values will be coming from the database on which HR is
 // running
 orgUnit.setAcademicFieldCode("0");
 orgUnit.setActive("Y");
 // orgUnit.setAddresses("Test");
 Load Institution 
 HashMap<String, Object> imap = new HashMap<String, Object>();
 imap.put("institutionCode", "UNZA02");
 imap.put("institutionTypeCode", "3");
 imap.put("institutionDescription", "University of Zambia-PHASE1");
 imap.put("provinceCode", "05");

 Load the Branch 
 HashMap<String, Object> bmap = new HashMap<String, Object>();
 bmap.put("institutionId", iManager.findInstitutionByParams(imap)
 .getId());
 bmap.put("branchCode", (cUnit.get("code")).toString());
 bmap.put("branchDescription", (String) cUnit.get("uname"));

 orgUnit.setBranchId(branchManager.findBranchByParams(bmap).getId());// very
 // important
 // must
 // be
 // set
 // to
 // existing
 // branch
 // use
 // lookup
 orgUnit.setDirectorId(1);
 // orgUnit.setId(1);
 orgUnit.setOrganizationalUnitCode(costCenterCode.trim());
 orgUnit.setOrganizationalUnitDescription(cname.trim());
 orgUnit.setParentOrganizationalUnitId(code);
 orgUnit.setRegistrationDate(new Date());
 orgUnit.setUnitAreaCode("");// Verify this
 orgUnit.setUnitLevel(1);
 orgUnit.setUnitTypeCode("2");// revist this after populating
 // unittype lookup table

 // persist the unit
 log.info(orgUnit.getOrganizationalUnitCode() + " "
 + orgUnit.getOrganizationalUnitDescription());
 orgUnitManager.addOrganizationalUnit(orgUnit);
 // log.info(orgUnit);

 }

 }

 }
 */
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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unza.dbconversion;

import org.apache.log4j.Logger;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.service.BranchManager;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * @author Katuta Gilchrist Kaunda
 * 
 */
public class UnzaOrganizationalUnitMigrator {
	private static Logger log = Logger
			.getLogger(UnzaOrganizationalUnitMigrator.class);
	private DataSource srsDataSource;
	private DataSource opusDataSource;
	// @Autowired private StudentManagerInterface studentManager;
	@Autowired
	private OrganizationalUnitManagerInterface orgUnitManager;
	@Autowired
	private BranchManagerInterface branchManager;
	@Autowired
	private InstitutionManagerInterface iManager;

	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

	public DataSource getSrsDataSource() {
		return srsDataSource;
	}

	public void setSrsDataSource(DataSource srsDataSource) {
		this.srsDataSource = srsDataSource;
	}

	public void convertOrganizationalUnit() throws SQLException {
		
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.OrganizationalUnit where id > 134";
		opusJdbcTemplate.execute(query);
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		// This data is coming from the HR system
		List<Map<String, Object>> orgUnitList = jdbcTemplate
				.queryForList("select distinct * from srsdatastage.school");

		/*
		 * Move Parent Units from School Table. This section creates an org unit
		 * with the same name as the school. This is the default to which all
		 * staff should be tied.
		 */
		
		for (Map<String, Object> oUnit : orgUnitList) {
			log.info("%%%%%%%%%%%%%Parent Units%%%%%%%%%%%");
			log.info("SRS Org Map"+oUnit);
			/* Extract data from the map objects */
			int code = Integer.parseInt(oUnit.get("code").toString());
			String uname = (String) oUnit.get("uname");
			String usch = (String) oUnit.get("usch");

			// check for nulls
			if (uname == null)
				uname = "0";
			if (usch == null)
				usch = "0";

			OrganizationalUnit orgUnit = new OrganizationalUnit();
			// These values will be coming from the database on which HR is
			// running
			orgUnit.setAcademicFieldCode("");
			orgUnit.setActive("Y");
			// orgUnit.setAddresses("Test");
			// orgUnit.setBranchId(242);
			/* Load Institution */
			HashMap<String, Object> imap = new HashMap<String, Object>();
			imap.put("institutionCode", "UNZA02");
			imap.put("institutionTypeCode", "3");
			imap.put("institutionDescription", "University of Zambia-PHASE1");
			imap.put("provinceCode", "05");
			log.info("Institution Map: "+imap);
			
			
			/* Load the Branch */
			Institution i = iManager.findInstitutionByParams(imap);
			String isInstitutionNull = new Boolean(i != null).toString();
			log.info("The institution is not null: "+ isInstitutionNull);
			if (i != null) {
				HashMap<String, Object> bmap = new HashMap<String, Object>();
				bmap.put("institutionId", iManager
						.findInstitutionByParams(imap).getId());
				bmap.put("branchCode", (oUnit.get("code")).toString());
				bmap.put("branchDescription", (String) oUnit.get("uname"));
				
				
				
				if (bmap.get("branchCode") != null
						&& bmap.get("branchDescription") != null)
					log.info("Branch Map"+bmap);
					orgUnit.setBranchId(branchManager.findBranchByParams(bmap)
							.getId());// very important must be set to existing
										// branch use lookup

				orgUnit.setDirectorId(1);
				// orgUnit.setId(1);
				orgUnit.setOrganizationalUnitCode(Integer.toString(code).trim());
				orgUnit.setOrganizationalUnitDescription(uname.trim());
				orgUnit.setParentOrganizationalUnitId(code);
				orgUnit.setRegistrationDate(new Date());
				orgUnit.setUnitAreaCode("0");// Verify this
				orgUnit.setUnitLevel(1);
				orgUnit.setUnitTypeCode("2");// revist this after populating
												// unittype lookup table
				HashMap<String, Object> OrgMap = new HashMap<String, Object>();
				OrgMap.put("organizationalUnitDescription", orgUnit.getOrganizationalUnitDescription());
				OrgMap.put("organizationalUnitCode", orgUnit.getOrganizationalUnitCode());
				log.info("Org Query Map"+OrgMap);
				
				// persist the unit
				if(orgUnitManager.findOrganizationalUnitByNameAndCode(OrgMap) == null){
					orgUnitManager.addOrganizationalUnit(orgUnit);
					log.info("Default School Unit"+orgUnit);
					log.info("SRS Org Map"+ oUnit);
				}
				

			}
		}

		/* Move Child units from the cost_centers table */
		List<Map<String, Object>> orgChildUnitList = jdbcTemplate
				.queryForList("select distinct * from srsdatastage.cost_centers cc,srsdatastage.school sc where sc.code = cc.srs_schcode");
		for (Map<String, Object> cUnit : orgChildUnitList) {
			log.info("%%%%%%%%%%%%%Child Units%%%%%%%%%%%");
			log.info(cUnit);

			 //Extract data from the map objects 
			int code = Integer.parseInt(cUnit.get("code").toString());
			String uname = (String) cUnit.get("uname");
			String usch = (String) cUnit.get("usch");
			String costCenterCode = (String) cUnit.get("cost_center_id");
			String cname = (String) cUnit.get("name");
			log.info("Cost Ceneter:" + costCenterCode);
			// check for nulls
			if (uname == null)
				uname = "0";
			if (usch == null)
				usch = "0";

			OrganizationalUnit orgUnit = new OrganizationalUnit();
			// These values will be coming from the database on which HR is
			// running
			orgUnit.setAcademicFieldCode("0");
			orgUnit.setActive("Y");
			// orgUnit.setAddresses("Test");
			// Load Institution 
			HashMap<String, Object> imap = new HashMap<String, Object>();
			imap.put("institutionCode", "UNZA02");
			imap.put("institutionTypeCode", "3");
			imap.put("institutionDescription", "University of Zambia-PHASE1");
			imap.put("provinceCode", "05");

			// Load the Branch 
			HashMap<String, Object> bmap = new HashMap<String, Object>();
			Institution i = iManager.findInstitutionByParams(imap);
			if (i != null) {
				bmap.put("institutionId", iManager
						.findInstitutionByParams(imap).getId());
				bmap.put("branchCode", (cUnit.get("code")).toString());
				bmap.put("branchDescription", (String) cUnit.get("uname"));

				orgUnit.setBranchId(branchManager.findBranchByParams(bmap)
						.getId());// very
									// important
									// must
									// be
									// set
									// to
									// existing
									// branch
									// use
									// lookup
				orgUnit.setDirectorId(1);
				// orgUnit.setId(1);
				orgUnit.setOrganizationalUnitCode(costCenterCode.trim());
				orgUnit.setOrganizationalUnitDescription(cname.trim());
				orgUnit.setParentOrganizationalUnitId(code);
				orgUnit.setRegistrationDate(new Date());
				orgUnit.setUnitAreaCode("");// Verify this
				orgUnit.setUnitLevel(1);
				orgUnit.setUnitTypeCode("2");// revist this after populating
												// unittype lookup table

				// persist the unit
				HashMap<String, Object> OrgMap = new HashMap<String, Object>();
				OrgMap.put("organizationalUnitDescription", orgUnit.getOrganizationalUnitDescription());
				OrgMap.put("organizationalUnitCode", orgUnit.getOrganizationalUnitCode());
				log.info("Org Query Map"+OrgMap);
				
				// persist the unit
				if(orgUnitManager.findOrganizationalUnitByNameAndCode(OrgMap) == null){
					orgUnitManager.addOrganizationalUnit(orgUnit);
					log.info("Default School Unit"+orgUnit);
					
				}
			}

		}

	}

}
