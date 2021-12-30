package org.uci.opus.mulungushi.dbconversion;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.service.StudyManagerInterface;

public class SecondarySchoolSubjectMigrator {
	private static Logger log = LoggerFactory.getLogger(SecondarySchoolSubjectMigrator.class);
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private DataSource dataSource;
	
	public void convertSecondarySchoolSubjects(){
//		dbUtil.truncateTable("secondaryschoolsubjectgroup");
//		dbUtil.truncateTable("groupedsecondaryschoolsubject");
//		dbUtil.truncateTable("gradedsecondaryschoolsubject");
		
    	// ...
	}
}
