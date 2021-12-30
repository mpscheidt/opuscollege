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
import org.jfree.util.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.unza.util.CTUComputer;

/**
 * @author Katuta Gilchrist Kaunda
 * 
 */
public class UnzaDbConversion {

	@Autowired
	UnzaInstitutionMigrator unzaInstitutionMigrator;
	@Autowired
	UnzaBranchMigrator unzaBranchMigrator;
	@Autowired
	UnzaOrganizationalUnitMigrator unzaOrganizationalUnitMigrator;
	@Autowired
	UnzaPostgradOrgUnitMigrator unzaPostgraduateOrgUnitMigrator;
	@Autowired
	UnzaStageStaffMigrator unzaStageStaffMigrator;
	@Autowired
	UnzaCurriculumMigrator unzaCurriculumMigrator;
	@Autowired
	UnzaStageCurriculumMigrator unzaStageCurriculumMigrator;
	@Autowired
	UnzaStageStudentMigrator unzaStageStudentMigrator;
	@Autowired
	UnzaStageAccommodationMigrator unzaStageAccommodationMigrator;
	@Autowired
	UnzaStudentMigrator unzaStudentMigrator;
	@Autowired
	UnzaStudentResultsMigrator unzaStudentResultMigrator;
	@Autowired
	PhaseOneMigration phaseOneMigration;
	@Autowired
	PhaseTwoMigration phaseTwoMigration;
	@Autowired
	PhaseThreeMigration phaseThreeMigration;
	
	private static Logger log = Logger.getLogger(UnzaDbConversion.class);
	

	public void doMigration() throws Exception {
		// first move institutions
		
		// then move organizational units
		// unzaOrganizationalUnitMigrator.convertOrganizationalUnit();
		//unzaPostgraduateOrgUnitMigrator.convertOrganizationalUnit();
		// then move staff members
		// unzaStaffMigrator.convertStaff();
		// then move curriculum
		// unzaCurriculumMigrator.convertCurriculum();
		// unzaCurriculumMigrator.migrateQuota();
		// unzaCurriculumMigrator.migrateSubjects();
		// then move the students
		// unzaStudentMigrator.convertStudents();
		// unzaStudentMigrator.convertNationality();
		// unzaStageStudentMigrator.migrateStudents();
		// Log.info(unzaStageStudentMigrator.getNationality("4"));
		// unzaStageAccommodationMigrator.moveHostels();
		/**PART 0: Create the Organization Structure*/
		//=>step #1:[Create the Institution]
		//unzaInstitutionMigrator.convertInstitutions();
		//=>step #2:[Create the Schools]
		//unzaBranchMigrator.convertSchools();
		//=>step #3:[Create the Organizational units]
		//unzaOrganizationalUnitMigrator.convertOrganizationalUnit();
		//=>step #4:[Create the Staff Members]
		//unzaStageStaffMigrator.convertStaff();
		
		/** PART 1: Create the Curriculum*/
		//=>step #5:[Create the Academic Years to be considered]
		//unzaStageCurriculumMigrator.createAcademicYears();//status:done
		//=>step #7:[Create the Grade Type representing the quota]
		//unzaStageCurriculumMigrator.migrateQuota();
		//=>step #8:[Create Default Primary Studies to Represent the relationship between course and School]
		//unzaStageCurriculumMigrator.createDefaultPrimaryStudy();//status:done
		//unzaStageCurriculumMigrator.createDefaultPrimaryStudyGradeType();
		
		//=>step#9:[Create Subjects by using Default Primary Studies (Dps-) Representing Schools]
		//unzaStageCurriculumMigrator.moveCourses();//status:done
		
		//=>step#10:[Create Actual Studies and their corresponding StudyGradeTypes]
		//unzaStageCurriculumMigrator.convertCurriculum();//status:done
		
		//=>step#11: [Pending-Links courses to studies using student data ]:
		//unzaStudentResultMigrator.createSubjectStudyGradeTypes();//status:in progress
		
		/** PART 2:Create Student Records and the Study Plans*/
		//=>step#12: [Create student records]
		//unzaStageStudentMigrator.migrateStudents();//status:done
		
		//=>step#14: [Create student studyPlans similar to acad year records]
		//unzaStudentResultMigrator.createStudentStudyPlan();//status:in progress
		//unzaStudentResultMigrator.createStudyPlanDetail("97276723");//testing duplicate studyplandetails
		//unzaStudentResultMigrator.createStudentAcademicInfo();
		
		//log.info("The CTU # for 20122 year of pgm 3 is"+CTUComputer.computeCTU2(3, 20121));
		//=>step#15:[Create Hostels & Rooms]
		//unzaStageAccommodationMigrator.moveHostels();//status:in progress
		
		//=>step#16: [Create Student Accommodation Data]
		//unzaStageAccommodationMigrator.moveStudentAccommodation();//status:in progress
		
		//step#17: [Create student Address Data]
		//unzaStageAccommodationMigrator.moveStudentAddresses();//status:in progress
		
		
		//unzaStudentResultMigrator.getCurrentAcademicYearId("20101");
		//Testing the database connection
		//unzaStageCurriculumMigrator.testDatabaseConnection();
		//phaseOneMigration.beginPhaseOneMigration();
		//phaseTwoMigration.beginPhaseTwoMigration();
		phaseThreeMigration.beginPhaseThreeMigration();

	}

}
