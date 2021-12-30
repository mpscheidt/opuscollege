package org.uci.opus.cbu.dbconversion;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.EndGradeManagerInterface;

public class EndGradeMigrator {
	@Autowired DataSource dataSource;
	@Autowired AcademicYearManagerInterface academicYearManager;
	@Autowired EndGradeManagerInterface endGradeManager;
	
	public void convertEndGrades(){
		JdbcTemplate jdbcTemplate=new JdbcTemplate(dataSource);
				
		List<AcademicYear> academicYears=academicYearManager.findAllAcademicYears();
		for(AcademicYear academicYear:academicYears){
			List<String> endGradeTypeCodes=getEndGradeTypeCodes();
			for(String endGradeTypeCode:endGradeTypeCodes){
				List<Map<String,Object>> result=jdbcTemplate.queryForList("SELECT * FROM opuscollege.endgrade where endgradetypecode='"+endGradeTypeCode+"' and academicyearid='"+academicYear.getId()+"'");
				if(result.toString().equals("[]")){
					String sql="INSERT INTO opuscollege.endgrade(endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid)" +
							" select '"+endGradeTypeCode+"' AS endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,'"+academicYear.getId()+"' from opuscollege.endgrade where endgradetypecode='"+endGradeTypeCode+"' AND academicyearid='10'";
					//System.out.println(sql);
					jdbcTemplate.execute(sql);
				}
			}
		}
	}
	
	private List<String> getEndGradeTypeCodes(){
		List<String> values=new ArrayList<String>();
		JdbcTemplate jdbcTemplate=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result=jdbcTemplate.queryForList("SELECT * FROM opuscollege.endgradetype");
		if(!result.toString().equals("[]")){
			for(Map<String,Object> obj:result){
				values.add((String)obj.get("code"));
			}
		}
		return values;
	}
}
