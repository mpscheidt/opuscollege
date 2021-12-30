package org.uci.opus.unza.dbconversion;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.service.BranchManager;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;

/**
 * @author Katuta Gilchrist Kaunda
 * 
 */
public class UnzaPostgradOrgUnitMigrator {
	private static Logger log = Logger
			.getLogger(UnzaOrganizationalUnitMigrator.class);
	//private DataSource srsDataSource;
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

	/*public DataSource getSrsDataSource() {
		return srsDataSource;
	}

	public void setSrsDataSource(DataSource srsDataSource) {
		this.srsDataSource = srsDataSource;
	}*/

	public void convertOrganizationalUnit() throws SQLException {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.OrganizationalUnit "
				+ " where organizationalunitcode in (select code from postgrad.dept)";
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
			log.info(oUnit);
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

			/* Load the Branch */
			HashMap<String, Object> bmap = new HashMap<String, Object>();
			log.info(imap);
			bmap.put("institutionId", iManager.findInstitutionByParams(imap)
					.getId());
			bmap.put("branchCode", (oUnit.get("code")).toString());
			bmap.put("branchDescription", (String) oUnit.get("uname"));

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
			log.info(orgUnit);
			log.info(oUnit);
		}

		/* Move Child units from the cost_centers table */
		List<Map<String, Object>> orgChildUnitList = jdbcTemplate
				.queryForList("select distinct sc.code as code,uname,d.name as name, usch,d.code as d_code from postgrad.dept d,srsdatastage.school sc where sc.code = d.schcode");
		for (Map<String, Object> cUnit : orgChildUnitList) {
			log.info("%%%%%%%%%%%%%Child Units%%%%%%%%%%%");
			log.info("Child unit map: "+cUnit);

			/* Extract data from the map objects */
			int code = Integer.parseInt(cUnit.get("code").toString());
			String uname = (String) cUnit.get("uname");
			String usch = (String) cUnit.get("usch");
			String costCenterCode = (String) cUnit.get("d_code");
			String cname = (String) cUnit.get("name");
			log.info("Department:" + costCenterCode);
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
			/* Load Institution */
			HashMap<String, Object> imap = new HashMap<String, Object>();
			imap.put("institutionCode", "UNZA02");
			imap.put("institutionTypeCode", "3");
			imap.put("institutionDescription", "University of Zambia-PHASE1");
			imap.put("provinceCode", "05");

			/* Load the Branch */
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
			//log.info(cUnit);
			// persist the unit
			HashMap<String, Object> OrgMap = new HashMap<String, Object>();
			OrgMap.put("organizationalUnitDescription", orgUnit.getOrganizationalUnitDescription());
			OrgMap.put("organizationalUnitCode", orgUnit.getOrganizationalUnitCode());
			log.info("Org Query Map"+OrgMap);
			
			// persist the unit
			OrganizationalUnit unitExists = orgUnitManager.findOrganizationalUnitByNameAndCode(OrgMap);
			if( unitExists == null){
				//log.info("Description: "+unitExists.getOrganizationalUnitDescription()+" Code: "+unitExists.getOrganizationalUnitCode());
				try{
					orgUnitManager.addOrganizationalUnit(orgUnit);
				}catch(Exception sqle){
					log.info("An SQL exception has ocuured. The Postgraduate dept_code is the Same as an existing code " +
							"in the SRS system"+sqle.getMessage());
				}
				
				log.info("Default School Unit: "+orgUnit);
			
			}

		}

	}

}
