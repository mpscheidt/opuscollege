package org.uci.opus.unza.dbconversion;

import org.springframework.beans.factory.annotation.Autowired;

public class PhaseTwoMigration {
	@Autowired
	UnzaStageCurriculumMigrator unzaStageCurriculumMigrator;
	@Autowired
	UnzaStudentResultsMigrator unzaStudentResultMigrator;
	
	
	public void beginPhaseTwoMigration() throws Exception{
		/**Create the Curriculum*/
		//unzaStageCurriculumMigrator.createAcademicYears();
		//unzaStageCurriculumMigrator.migrateQuota();
		//unzaStageCurriculumMigrator.createDefaultPrimaryStudy();
		//unzaStageCurriculumMigrator.createDefaultPrimaryStudyGradeType();//very necessary
		//unzaStageCurriculumMigrator.moveCourses();//status:done
		//unzaStageCurriculumMigrator.convertCurriculum();//status:done
		//unzaStudentResultMigrator.createSubjectStudyGradeTypes();//status:cancelled
		unzaStudentResultMigrator.createSsgt();//Creates subjectstudygradetypes status:done
	}

}
