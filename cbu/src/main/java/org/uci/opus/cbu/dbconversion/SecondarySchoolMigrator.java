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
package org.uci.opus.cbu.dbconversion;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.data.SecondarySchoolDao;
import org.uci.opus.cbu.domain.SecondarySchool;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.service.InstitutionManagerInterface;

public class SecondarySchoolMigrator {

    private static Logger log = LoggerFactory.getLogger(SecondarySchoolMigrator.class);
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private SecondarySchoolDao secondarySchoolDao;
    @Autowired private DataSource dataSource;
    
    public void convertSecondarySchools() throws SQLException {
 
    	List<SecondarySchool> secondarySchools=secondarySchoolDao.getSecondarySchools();
    	
        //iterate through a collection of a List object
        for (SecondarySchool secondarySchool: secondarySchools) {
        	
        	if(log.isInfoEnabled())
        		log.info(secondarySchool.toString());
           
            //create an instance for OrganizationUnit to store department Date
            Institution highSchool=new Institution();
            highSchool.setInstitutionCode(secondarySchool.getCode());
            highSchool.setInstitutionDescription(secondarySchool.getName());
            highSchool.setActive("Y");
            //set default values for the unitAreaCode
            highSchool.setInstitutionTypeCode("1");
            //set default values for the unitTypeCode
            highSchool.setRector("");
            highSchool.setProvinceCode("05");
            
            //add institution if not found, otherwise update it
            if(getInstitutionID(secondarySchool.getCode().trim())==0){
        	   institutionManager.addInstitution(highSchool);
            }else{
            	highSchool.setId(getInstitutionID(secondarySchool.getCode().trim()));
            	institutionManager.updateInstitution(highSchool);
            }
        }
    }
    
    private int getInstitutionID(String code){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		
		List<Map<String,Object>> branch =opusTemplate.queryForList("SELECT id FROM opuscollege.institution WHERE institutioncode='"+code+"'");
		if(!branch.toString().equals("[]"))
			return Integer.valueOf(branch.get(0).get("id").toString());
		return 0;
    }
}
