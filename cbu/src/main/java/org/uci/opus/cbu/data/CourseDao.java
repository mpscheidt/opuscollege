package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.Course;

public class CourseDao {
	private DataSource dataSource;
	@Autowired private ProgrammeDao programmeDao;
	@Autowired private LecturerDao lecturerDao;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Course getCourse(String programmeCode,String courseCode){
		String sql= "SELECT * FROM CBUProgrammeCourses WHERE CourseCode='"+courseCode+"' AND ProgrammeCode='"+programmeCode+"'";
		List<Course> lstCourses=getCourseList(sql);
		if(lstCourses!=null && lstCourses.size()>0)
			return lstCourses.get(0);
		else
			return null;
	}
	
	public List<Course> getCourses(){
		String sql= "SELECT * FROM CBUProgrammeCourses WHERE ProgrammeCode IS NOT NULL AND CourseCode IS NOT NULL AND CourseName IS NOT NULL";
		return getCourseList(sql);
	}
	
	public List<Course> getCourses(String programmeCode){
		String sql= "SELECT * FROM CBUProgrammeCourses WHERE ProgrammeCode='"+programmeCode+"' AND CourseCode IS NOT NULL AND CourseName IS NOT NULL";
		return getCourseList(sql);
	}
	
	public List<Course> getLecturerCourses(String lecturerId){
		String sql= "SELECT * FROM CBUProgrammeCourses WHERE LecturerID='"+lecturerId+"' AND CourseCode IS NOT NULL AND CourseName IS NOT NULL";
		return getCourseList(sql);
	}
	
	public List<Course> getCourses(String programmeCode,int yearOfStudy){
		String sql= "SELECT * FROM CBUProgrammeCourses WHERE ProgrammeCode='"+programmeCode+"' AND YearOfStudy='"+yearOfStudy+"' AND CourseCode IS NOT NULL AND CourseName IS NOT NULL";
		return getCourseList(sql);
	}
	
	private List<Course> getCourseList(String sql){
		List<Course> lstCourses=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcCourses=jdbc.queryForList(sql);
		if(!jdbcCourses.toString().equals("[]")){
			lstCourses=new ArrayList<Course>();
			
			for(Map<String, Object> map: jdbcCourses){
				fillList(lstCourses, map);
			}
		}
		return lstCourses;
	}
	
	private void fillList(List<Course> lstCourses,Map<String,Object> map){
		Course course=new Course();
		course.setCode(map.get("CourseCode").toString().trim());
		course.setName(prettyFormat(map.get("CourseName").toString().trim()));
		course.setProgramme(programmeDao.getProgramme(map.get("ProgrammeCode").toString().trim()));
		course.setYearOfStudy(Integer.valueOf(map.get("YearOfStudy").toString()));
		if(map.get("LecturerID")!=null) course.setLecturer(lecturerDao.getLecturer(map.get("LecturerID").toString()));
		course.setYearOfStudy(Integer.parseInt(map.get("YearOfStudy").toString()));
		course.setActive(map.get("Obsolete")!=null?!Boolean.parseBoolean(map.get("Obsolete").toString()):true);
		lstCourses.add(course);
	}
	
	private String prettyFormat(String words){
		String value=null;
		if(words!=null){
			value="";
			String[] word=words.split(" ");
			for(int i=0;i<word.length;i++){
				if(word[i].equalsIgnoreCase("i") || word[i].equalsIgnoreCase("ii") || word[i].equalsIgnoreCase("iii"))
					word[i]=word[i].toUpperCase().trim();
				else if(word[i].equalsIgnoreCase("and") || word[i].equalsIgnoreCase("of") || word[i].equalsIgnoreCase("in"))
					word[i]=word[i].toLowerCase().trim();
				else if(word[i].length()>1)
					word[i]=word[i].substring(0,1).toUpperCase()+word[i].substring(1).toLowerCase().trim();
				
				value+=word[i]+" ";
			}
		}
		return value.trim();
	}
}
