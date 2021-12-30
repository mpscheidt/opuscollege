package org.uci.opus.unza.dbconversion;

import org.springframework.beans.factory.annotation.Autowired;

public class PhaseThreeMigration {
	@Autowired
	UnzaStudentResultsMigrator unzaStudentResultMigrator;
	@Autowired
	UnzaStageAccommodationMigrator unzaStageAccommodationMigrator;
	@Autowired
	UnzaStageStudentMigrator unzaStageStudentMigrator;
	
	public void beginPhaseThreeMigration() throws Exception {
		// =>step#12: [Create student records]
		unzaStageStudentMigrator.migrateStudents();// status:done

		// =>step#14: [Create student studyPlans similar to acad year records]
		//unzaStudentResultMigrator.createStudentStudyPlan();// status:in progress
		
		// unzaStudentResultMigrator.createStudyPlanDetail("97276723");//testing
		// duplicate studyplandetails
		//unzaStudentResultMigrator.createStudentAcademicInfo();

		// log.info("The CTU # for 20122 year of pgm 3 is"+CTUComputer.computeCTU2(3,
		// 20121));
		// =>step#15:[Create Hostels & Rooms]
		//unzaStageAccommodationMigrator.moveHostels();// status:in progress

		// =>step#16: [Create Student Accommodation Data]
		//unzaStageAccommodationMigrator.moveStudentAccommodation();// status:in
																	// progress

		// step#17: [Create student Address Data]
		//unzaStageAccommodationMigrator.moveStudentAddresses();// status:in
																// progress

	}

}
