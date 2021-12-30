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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class DbConversion {
    
    Logger log = LoggerFactory.getLogger(DbConversion.class);
    @Autowired SecondarySchoolMigrator secondarySchoolMigrator;
    @Autowired SchoolMigrator schoolMigrator;
    @Autowired DepartmentMigrator departmentMigrator;
    @Autowired ProgrammeMigrator programmeMigrator;
    @Autowired CourseMigrator courseMigrator;
    @Autowired StaffMigrator staffMigrator;
    @Autowired StudentMigrator studentMigrator;
    @Autowired SecondarySchoolSubjectMigrator secondarySchoolSubjectMigrator;
    @Autowired EndGradeMigrator endGradeMigrator;
    @Autowired AccommodationDataMigrator accommodationDataMigrator;
    
    public void doMigration() throws Exception {
        
    	//Migrate Secondary Schools
    	//log.error("Starting converting Secondary Schools");
    	//secondarySchoolMigrator.convertSecondarySchools();
    	
        //Migrate Schools
    	//log.error("Starting converting Schools");
    	//schoolMigrator.convertSchools();
        
    	//Migrate School Departments
    	//log.error("Starting converting Departments");
    	//departmentMigrator.convertDepartments();
    	
    	//Migrate Programmes
    	//log.error("Starting converting Programmes");
    	//programmeMigrator.convertProgrammes();
    	
    	//Migrate Courses
    	//log.error("Starting converting Courses");
        //courseMigrator.convertCourses();
        
    	//Migrate Staff Members
        //log.error("Starting converting Staff Members");
    	//staffMigrator.convertStaff();
    	
    	//Migrate SecondarySchoolSubjectGroup
    	//log.error("Starting Secondary School Subject Group");
    	//secondarySchoolSubjectMigrator.convertSecondarySchoolSubjects();
    	
    	// then move the students and their results
    	//log.error("Starting converting Students");
        //studentMigrator.convertStudents();
            	
    	//fix endgrades for newly added acadmicyears
    	//endGradeMigrator.convertEndGrades();
    	
    	//Migrate Accommodation Data
    	//accommodationDataMigrator.convertData();
     }
}
