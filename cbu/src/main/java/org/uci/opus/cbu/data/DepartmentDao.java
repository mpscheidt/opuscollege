package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.SchoolDepartment;

public class DepartmentDao {
	private DataSource dataSource;
	@Autowired private SchoolDao schoolDao;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public SchoolDepartment getDepartment(String schoolCode,String departmentCode){
		String sql= "SELECT * FROM SchoolDepartments WHERE SchoolCode='"+schoolCode+"' AND DeptID='"+departmentCode+"'";
		List<SchoolDepartment> lstDepartment=getDepartmentList(sql);
		if(lstDepartment!=null && lstDepartment.size()>0)
			return lstDepartment.get(0);
		else
			return null;
	}
	
	public SchoolDepartment getDepartment(String departmentCode){
		String sql= "SELECT * FROM SchoolDepartments WHERE DeptID='"+departmentCode+"'";
		List<SchoolDepartment> lstDepartment=getDepartmentList(sql);
		if(lstDepartment!=null && lstDepartment.size()>0)
			return lstDepartment.get(0);
		else
			return null;
	}
	public List<SchoolDepartment> getSchoolDepartments(){
		String sql= "SELECT * FROM SchoolDepartments";
		return getDepartmentList(sql);
	}
	
	public List<SchoolDepartment> getDepartments(String schoolCode){
		String sql= "SELECT * FROM SchoolDepartments WHERE SchoolCode='"+schoolCode+"'";
		return getDepartmentList(sql);
	}
	
	
	private List<SchoolDepartment> getDepartmentList(String sql){
		List<SchoolDepartment> lstDepartments=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcDepartments=jdbc.queryForList(sql);
		if(!jdbcDepartments.toString().equals("[]")){
			lstDepartments=new ArrayList<SchoolDepartment>();
			
			for(Map<String, Object> map: jdbcDepartments){
				fillList(lstDepartments, map);
			}
		}
		return lstDepartments;
	}
	
	private void fillList(List<SchoolDepartment> lstDepartments,Map<String,Object> map){
		SchoolDepartment department=new SchoolDepartment();
		department.setCode(map.get("DeptID").toString().trim());
		department.setName(map.get("DeptName").toString().trim());
		department.setSchool(schoolDao.getSchool(map.get("SchoolCode").toString().trim()));
		lstDepartments.add(department);
	}
	
}
