package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.School;

public class SchoolDao {
	private DataSource dataSource;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public School getSchool(String schoolCode){
		String sql= "SELECT * FROM CBUSchools WHERE SchoolCode='"+schoolCode+"'";
		List<School> lstSchool=getSchoolList(sql);
		if(lstSchool.size()>0)
			return lstSchool.get(0);
		else
			return null;
	}
	
	public List<School> getSchools(){
		String sql= "SELECT * FROM CBUSchools";
		return getSchoolList(sql);
	}
	
	private List<School> getSchoolList(String sql){
		List<School> lstSchools=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcSchools=jdbc.queryForList(sql);
		if(!jdbcSchools.toString().equals("[]")){
			lstSchools=new ArrayList<School>();
			
			for(Map<String, Object> map: jdbcSchools){
				fillList(lstSchools, map);
			}
		}
		return lstSchools;
	}
	
	private void fillList(List<School> lstSchools,Map<String,Object> map){
		School school=new School();
		school.setCode(map.get("SchoolCode").toString().trim());
		school.setName(map.get("CBUSchool").toString().trim());
		
		lstSchools.add(school);
	}
}
