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
import org.uci.opus.cbu.data.SchoolDao;
import org.uci.opus.cbu.domain.School;
import org.uci.opus.cbu.util.StringUtil;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.service.BranchManagerInterface;

public class SchoolMigrator {

    private static Logger log = LoggerFactory.getLogger(SchoolMigrator.class);
    @Autowired private DataSource dataSource;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private SchoolDao schoolDao;
    
        
    public void convertSchools() throws SQLException {
        //clear existing information about school before transfering school data  
    	//deleteSchoolInformation();
    	
    	List<School> schools =schoolDao.getSchools();
    
    	for (School school: schools) {
            //check if information of a school already exist
    		//if not add school details
    		//if (!schoolCodeExist(school.getCode())) {
				Branch branch=new Branch();
				branch.setBranchCode(school.getCode().trim());
				branch.setBranchDescription(StringUtil.prettyFormat(school.getName()));
				branch.setActive("Y");
	            branch.setInstitutionId(getInstitutionID("CBU Kitwe"));
				//branchManager.addBranch(branch);
            //}
    		
    		int branchId=getBranchID(school.getName().trim());
    		
    		if(branchId!=0){
    			branch.setId(branchId);
    			branchManager.updateBranch(branch);
    		}else{
    			branchManager.addBranch(branch);
    		}
    		
    		if(log.isInfoEnabled())
    			log.info(school.toString());
        }
    }
    
    private boolean schoolCodeExist(String schoolCode){
    	JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		List<Map<String,Object>> school =opusTemplate.queryForList("SELECT id FROM opuscollege.branch WHERE branchcode='"+schoolCode+"'");
		if(school.toString().equals("[]"))
			return false;
		
		return true;
    }
    
    private int getBranchID(String schoolName){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		int branchId=0;
		
		List<Map<String,Object>> branch =opusTemplate.queryForList("SELECT id FROM opuscollege.branch WHERE lower(trim(branchdescription))='"+schoolName.toLowerCase()+"'");
		if(!branch.toString().equals("[]"))
			branchId = Integer.valueOf(branch.get(0).get("id").toString());
		
		if(branchId==0){
			if(schoolName.equalsIgnoreCase("school of the built environment"))
				branchId=getBranchID("School of Built Environment");
			else if(schoolName.equalsIgnoreCase("Directorate of Distance Education & Open Learning"))
				branchId=getBranchID("Directorate of Distance Education and Open Learning");
			else if(schoolName.equalsIgnoreCase("School of Mathematics and Natural Sciences"))
				branchId=getBranchID("School of Maths and Natural Sciences");
			else if(schoolName.equalsIgnoreCase("School of Graduate Studies"))
				branchId=getBranchID("Graduate Studies");
		}
			
		return branchId;
    }
      
    private int getInstitutionID(String institutionName){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		
		List<Map<String,Object>> branch =opusTemplate.queryForList("SELECT id FROM opuscollege.institution WHERE institutiondescription='"+institutionName+"'");
		if(!branch.toString().equals("[]"))
			return Integer.valueOf(branch.get(0).get("id").toString());
		return 0;
    }
    /**
     * This method is used to delete all existing information about the schools in the branch table
     */
    private void deleteSchoolInformation(){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		opusTemplate.execute("DELETE FROM opuscollege.branch WHERE branchdescription LIKE 'School of %' OR branchdescription LIKE 'Directorate of%'");
	}
}
