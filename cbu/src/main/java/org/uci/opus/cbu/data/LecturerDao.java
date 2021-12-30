package org.uci.opus.cbu.data;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.Lecturer;


public class LecturerDao {
	private DataSource dataSource;
	@Autowired private DepartmentDao departmentDao;
		
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Lecturer getLecturer(String lecturerId){
		String sql= "SELECT * FROM LecturerDetails WHERE LecturerID='"+lecturerId+"'";
		List<Lecturer> lstLecturers=getLecturerList(sql);
		
		if(lstLecturers!=null && lstLecturers.size()>0)
			return lstLecturers.get(0);
		else
			return null;
	}
	
	public List<Lecturer> getLecturers(){
		String sql= "SELECT * FROM LecturerDetails WHERE DepartmentCode IS NOT NULL AND Name IS NOT NULL AND Surname IS NOT NULL AND Username IS NOT NULL";
		return getLecturerList(sql);
	}
	
	public List<Lecturer> getLecturers(String departmentCode){
		String sql= "SELECT * FROM LecturerDetails WHERE DepartmentCode='"+departmentCode+"'";
		return getLecturerList(sql);
	}
	
	private List<Lecturer> getLecturerList(String sql){
		List<Lecturer> lstLecturers=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcLecturers=jdbc.queryForList(sql);
		if(!jdbcLecturers.toString().equals("[]")){
			lstLecturers=new ArrayList<Lecturer>();
			
			for(Map<String, Object> map: jdbcLecturers){
				Lecturer lecturer=new Lecturer();
				fillList(lecturer, map);
				lstLecturers.add(lecturer);
			}
		}
		return lstLecturers;
	}
	
	private void fillList(Lecturer lecturer,Map<String,Object> map){
		lecturer.setId(map.get("LecturerID").toString().trim());
		if(map.get("Name")!=null) lecturer.setFirstName(map.get("Name").toString().trim());
		if(map.get("Surname")!=null) lecturer.setLastName(map.get("Surname").toString().trim());
		if(map.get("Title")!=null) lecturer.setTitle(map.get("Title").toString().trim());
		if(map.get("SchoolCode")!=null && map.get("DepartmentCode")!=null) lecturer.setDepartment(departmentDao.getDepartment(map.get("DepartmentCode").toString().trim()));
		if(map.get("Username")!=null) lecturer.setUsername(map.get("Username").toString().trim());
		if(map.get("Password")!=null) lecturer.setPassword(map.get("Password").toString().trim());
	}

	@Override
	public String toString() {
		String values = "";
		Field[] fields = getClass().getDeclaredFields();
		Method[] methods = getClass().getDeclaredMethods();

		for (Field f : fields) {
			try {
				for (Method m : methods) {
					if (Modifier.isPublic(m.getModifiers())	&& (f.getName().length() == 1 || (m.getName().indexOf("get"+ f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1)) != -1))) {
						values += f.getName() + " = " + f.get(this) + ", ";
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			values=values.substring(0,values.lastIndexOf(","));
		}
		return getClass().getName() + " = [" + values + "]";
	}
}
