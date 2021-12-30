package org.uci.opus.unza.dbconversion;

import org.apache.commons.logging.Log;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**Responsible for Creating the Institution Structural Elements*/
public class PhaseOneMigration {
	private static Logger log = Logger.getLogger(PhaseOneMigration.class);
	@Autowired
	UnzaInstitutionMigrator unzaInstitutionMigrator;
	@Autowired
	UnzaBranchMigrator unzaBranchMigrator;
	@Autowired
	UnzaOrganizationalUnitMigrator unzaOrganizationalUnitMigrator;
	@Autowired
	UnzaPostgradOrgUnitMigrator unzaPostgradOrgUnitMigrator;
	@Autowired
	UnzaStageStaffMigrator unzaStageStaffMigrator;
	public void beginPhaseOneMigration() throws Exception{
		
		/**Create the Institutional Structure*/
		log.info("***PHASE ONE MIGRATION***");
		//unzaInstitutionMigrator.convertInstitutions();
		//unzaBranchMigrator.convertSchools();
		//unzaOrganizationalUnitMigrator.convertOrganizationalUnit();
		//unzaPostgradOrgUnitMigrator.convertOrganizationalUnit();
		unzaStageStaffMigrator.convertStaff();
		
		
	}
	
}
