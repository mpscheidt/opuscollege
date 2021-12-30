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
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Collection;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.service.AddressManager;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.StudentAbsence;
import org.uci.opus.college.domain.StudentStudentStatus;
import org.uci.opus.college.domain.result.CardinalTimeUnitResult;
import org.uci.opus.college.domain.result.ExaminationResult;
import org.uci.opus.college.domain.result.StudyPlanResult;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.result.TestResult;
import org.uci.opus.college.domain.util.StudentUtil;
import org.uci.opus.college.service.StudentManagerInterface;

public class UnzaStudentMigrator {

    private static Logger log = Logger.getLogger(UnzaStudentMigrator.class);
    private DataSource srsDataSource;
    private DataSource opusDataSource;
    private DataSource dataSource;
    public DataSource getDataSource(){
    	return dataSource;
    }
    public void setDataSource(DataSource dataSource){
    	this.dataSource = dataSource;
    	
    }
   
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

    
    /* This method moves student Basic Data */

    public void convertStudents() throws SQLException {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
        JdbcTemplate jdbcTemplateDataStage = new JdbcTemplate(opusDataSource);

        List<Map<String, Object>> studentList = jdbcTemplate
                .queryForList("select * from srsystem.student");
        
        /*Preliminary Clean of the data before staging*/
        for (Map<String, Object> srsStudent : studentList) {

        }

        student: for (Map<String, Object> srsStudent : studentList) {
            log.info(srsStudent);
            
            String sql = "INSERT INTO srsdatastage.student VALUES (?,?,?,?,?,?,?,?,?,?,?)";

            String studentid = (String) srsStudent.get("id");
            if (studentid == null || studentid.equals(""))
                continue;// skip the record if it has no student id

            String studentname = (String) srsStudent.get("name");
            if (studentname == null || studentid.equals(""))
                studentname = "0";
            String address1 = (String) srsStudent.get("addr1");
            if (address1 == null || address1.equals(""))
                address1 = "0";
            String address2 = (String) srsStudent.get("addr2");
            if (address2 == null || address2.equals(""))
                address2 = "0";
            String address3 = (String) srsStudent.get("addr3");
            if (address3 == null || address3.equals(""))
                address3 = "0";
            String maritalcode = (String) srsStudent.get("mtlcode");
            if (maritalcode == null || maritalcode.equals(""))
                maritalcode = "0";

            String nationalitycode;
            if (srsStudent.get("natcode") == null
                    || srsStudent.get("natcode").equals("null")
                    || srsStudent.get("natcode").equals(""))
                nationalitycode = "0";
            else
                nationalitycode = ((Integer) srsStudent.get("natcode"))
                        .toString();

            String nationalregistrationcard = (String) srsStudent.get("nrc");
            if (nationalregistrationcard == null
                    || nationalregistrationcard.equals(""))
                nationalregistrationcard = "0";
            String secondaryschoolcode;

            if (srsStudent.get("seccode") == null
                    || srsStudent.get("seccode").equals(""))
                secondaryschoolcode = "0";
            else
                secondaryschoolcode = ((Integer) srsStudent.get("seccode"))
                        .toString();

            String sex = (String) srsStudent.get("sex");
            if (sex == null || sex.equals(""))
                sex = "0";

            String yearofbirth;
            if (srsStudent.get("yob") == null
                    || srsStudent.get("yob").equals("null")
                    || srsStudent.get("yob").equals(""))
                yearofbirth = "0";
            else
                yearofbirth = ((Short) srsStudent.get("yob")).toString();

            /* Write the record to the staging database 
            jdbcTemplateDataStage.update(sql, new Object[] { studentid,
                    studentname, address1, address2, address3, maritalcode,
                    nationalitycode, nationalregistrationcard,
                    secondaryschoolcode, sex, yearofbirth });*/
        }

    }
    public void convertNationality() throws SQLException {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
        JdbcTemplate jdbcTemplateDataStage = new JdbcTemplate(opusDataSource);
        
        /*Load all nationality*/
        List<Map<String, Object>> nationalityList = jdbcTemplate
                .queryForList("select * from srsystem.nation");
        
        for (Map<String, Object> nation : nationalityList) {
            log.info(nation);
            
            String code="0";
            if(nation.get("code") != null || nation.get("code") !="")
            	code = (String)nation.get("code");
            
            String nationality="0";
            if(nation.get("nationality") != null || nation.get("nationality") !="")
            	code = ((Integer)nation.get("code")).toString();
            
            String sql = "INSERT INTO srsdatastage.nation VALUES (?,?)";
            /* Write the record to the staging database */
            jdbcTemplateDataStage.update(sql, new Object[] { code,nationality});
        }
        
    }
}
