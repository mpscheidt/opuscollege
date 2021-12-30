package org.uci.opus.mulungushi.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.mulungushi.domain.Course;
import org.uci.opus.mulungushi.domain.ProgCourse;

public class CourseDao {

    private Logger log = LoggerFactory.getLogger(getClass());

	private DataSource dataSource;

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public List<Course> getCourses() {
		return getCourseList("select courseNo, courseName, school from courses");
	}
	
	private List<Course> getCourseList(String sql) {
		List<Course> lstCourses = null;

		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> jdbcCourses = jdbc.queryForList(sql);
		if (!jdbcCourses.toString().equals("[]")) {
			lstCourses = new ArrayList<Course>();

			for (Map<String, Object> map : jdbcCourses) {
				fillList(lstCourses, map);
			}
		}
		return lstCourses;
	}

	private void fillList(List<Course> lstCourses, Map<String, Object> map){

		Course course = new Course();

		course.setCourseNo(((String)map.get("courseNo")).trim());
		course.setCourseName(((String)map.get("courseName")).trim());
		course.setSchool(((String)map.get("school")).trim());

		List<ProgCourse> programCourses = getPrograms(course.getCourseNo());
		course.setProgCourses(programCourses);

		lstCourses.add(course);
	}

	private List<ProgCourse> getPrograms(String courseNo) {
		List<ProgCourse> programCourses = new ArrayList<>();

		String courseNoLike = "%" + courseNo + "%";
		
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> jdbcProgCourses = jdbc.queryForList("select programNo, elective from progcourses where courseNo like ?", courseNoLike);
		if (!jdbcProgCourses.toString().equals("[]")) {

			for (Map<String, Object> map : jdbcProgCourses) {
			    ProgCourse progCourse = new ProgCourse();
			    progCourse.setCourseNo(courseNo);
			    progCourse.setProgramNo(((String)map.get("programNo")).trim());
			    boolean elective = map.get("elective") != null && "TRUE".equalsIgnoreCase(((String)map.get("elective")).trim());
			    if (elective) {
			        log.info("elective course " + courseNo + " for program " + progCourse.getProgramNo());
			    }
                progCourse.setElective(elective);
				programCourses.add(progCourse);
			}
		}

		return programCourses;
	}

}
