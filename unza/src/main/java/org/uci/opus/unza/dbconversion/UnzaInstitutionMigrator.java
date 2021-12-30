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

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.domain.Institution;

/**
 * @author Katuta Gilchrist Kaunda
 *
 */
public class UnzaInstitutionMigrator {

    private static Logger log = Logger.getLogger(UnzaInstitutionMigrator.class);
    private DataSource opusDataSource;
    private DataSource srsDataSource;
    @Autowired private InstitutionManagerInterface institutionManager;
    
    
    public DataSource getSrsDataSource() {
        return srsDataSource;
    }

    public void setSrsDataSource(DataSource srsDataSource) {
        this.srsDataSource = srsDataSource;
    }
    public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

    public void convertInstitutions() throws SQLException {
    	JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.institution where institutioncode='UNZA02'";
		opusJdbcTemplate.execute(query);
        
        Institution institution = new Institution();
        institution.setInstitutionCode("UNZA02");
        institution.setActive("Y");
        institution.setInstitutionTypeCode("3");
        institution.setInstitutionDescription("University of Zambia-PHASE1");
        institution.setProvinceCode("05");
        institution.setRector("DVC");
        institutionManager.addInstitution(institution);
        log.info("Migrating Institutions ...");
        
        
    }

}
