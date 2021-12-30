package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.SecondarySchool;

public class SecondarySchoolDao {
	private DataSource dataSource;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public SecondarySchool getSecondarySchool(String schoolCode){
		String sql= "SELECT Scode,School FROM High_Schools WHERE SCode='"+schoolCode+"'";
		List<SecondarySchool> lstSchool=getSecondarySchoolList(sql);
		if(lstSchool.size()>0)
			return lstSchool.get(0);
		else
			return null;
	}
	
	public List<SecondarySchool> getSecondarySchools(){
		String sql= "SELECT Scode,School FROM High_Schools";
		return getSecondarySchoolList(sql);
	}
	
	private List<SecondarySchool> getSecondarySchoolList(String sql){
		List<SecondarySchool> lstSchools=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcSchools=jdbc.queryForList(sql);
		if(!jdbcSchools.toString().equals("[]")){
			lstSchools=new ArrayList<SecondarySchool>();
			
			for(Map<String, Object> map: jdbcSchools){
				fillList(lstSchools, map);
			}
		}
		return lstSchools;
	}
	
	private void fillList(List<SecondarySchool> lstSchools,Map<String,Object> map){
		SecondarySchool school=new SecondarySchool();
		school.setCode(map.get("SCode").toString().trim());
		school.setName(map.get("School").toString().trim());
		
		lstSchools.add(school);
	}
}
