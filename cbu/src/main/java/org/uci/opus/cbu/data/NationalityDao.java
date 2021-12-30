package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.Nationality;


public class NationalityDao {

	private DataSource dataSource;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Nationality getNationality(String nationalityCode){
		String sql= "SELECT * FROM Nationality WHERE NationalityCode='"+nationalityCode+"'";
		List<Nationality> lstNationalities=getNationalityList(sql);
		
		if(lstNationalities==null)
			return getNationality("42");
					
		if(lstNationalities.size()>0)
			return lstNationalities.get(0);
		else
			return null;
	}
	
	public List<Nationality> getNationalities(){
		String sql= "SELECT * FROM Nationality";
		return getNationalityList(sql);
	}
	
	private List<Nationality> getNationalityList(String sql){
		List<Nationality> lstNationalities=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcNationalities=jdbc.queryForList(sql);
		if(!jdbcNationalities.toString().equals("[]")){
			lstNationalities=new ArrayList<Nationality>();
			
			for(Map<String, Object> map: jdbcNationalities){
				fillList(lstNationalities, map);
			}
		}
		return lstNationalities;
	}
	
	private void fillList(List<Nationality> lstNationalities,Map<String,Object> map){
		Nationality Nationality=new Nationality();
		Nationality.setCode(map.get("NationalityCode").toString().trim());
		Nationality.setName(map.get("NationalityDescription").toString().trim());
		
		lstNationalities.add(Nationality);
	}

}
