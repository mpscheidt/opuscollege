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
import org.uci.opus.cbu.data.DepartmentDao;
import org.uci.opus.cbu.domain.SchoolDepartment;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;


public class DepartmentMigrator {

    private static Logger log = LoggerFactory.getLogger(DepartmentMigrator.class);
    @Autowired private OrganizationalUnitManagerInterface ouManager;
    @Autowired private DataSource dataSource;
    @Autowired private DepartmentDao departmentDao;
    
      
    public void convertDepartments() throws SQLException {
        
        List<SchoolDepartment> departments=departmentDao.getSchoolDepartments();
        
        //iterate through a collection of a List object
        for (SchoolDepartment department: departments) {
        	if(log.isInfoEnabled())
        		log.info(department.toString());
            
            //create an instance for OrganizationUnit to store department Date
            OrganizationalUnit ou=new OrganizationalUnit();
            ou.setOrganizationalUnitCode(department.getCode());
            ou.setOrganizationalUnitDescription(department.getName());
            ou.setActive("Y");
            //set default values for the unitAreaCode to 1 [Academic]
            ou.setUnitAreaCode("1");
          //set default values for the unitTypeCode
            ou.setUnitTypeCode("2"); //2 for Department
          //set default values for the academicFieldCode
            ou.setAcademicFieldCode("");
            ou.setBranchId(getSchoolID(department.getSchool().getCode()));
            ou.setUnitLevel(1);
            ou.setParentOrganizationalUnitId(0);
            
            int departmentId=getDepartmentId(ou.getOrganizationalUnitCode());
            
            if(departmentId==0){
            	ouManager.addOrganizationalUnit(ou);
            }else{
            		ou.setId(departmentId);
            		ouManager.updateOrganizationalUnit(ou);
            }
        }
    }
    
    private int getSchoolID(String schoolCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		
		List<Map<String,Object>> school =opusTemplate.queryForList("SELECT id FROM opuscollege.branch WHERE branchcode='"+schoolCode+"'");
		if(!school.toString().equals("[]"))
			return Integer.valueOf(school.get(0).get("id").toString());
		
		return 0;
    }
    
    private int getDepartmentId(String departmentCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result =opusTemplate.queryForList("SELECT id FROM opuscollege.organizationalunit WHERE organizationalunitcode='"+departmentCode+"'");
		if(result.toString().equals("[]"))
			return 0;
		
		return Integer.parseInt(result.get(0).get("id").toString());
    }
}
