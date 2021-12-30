package org.uci.opus.mulungushi.dbconversion;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.EndGradeManagerInterface;

public class EndGradeMigrator {
	@Autowired DataSource dataSource;
	@Autowired AcademicYearManagerInterface academicYearManager;
	@Autowired EndGradeManagerInterface endGradeManager;
	
	public void convertEndGrades(){
    	// ...
	}
}
