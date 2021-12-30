package org.uci.opus.mulungushi.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.mulungushi.domain.MuGrade;

public class MuGradesDao {

	private DataSource dataSource;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public List<MuGrade> getGrades() {
		return getStudentList("select"
				+ "  StudentNo"
				+ ", academicYear"
				+ ", semester"
				+ ", programNo"
				+ ", courseNo"
                + ", caMarks"
                + ", examMarks"
				+ ", totalMarks"
				+ ", grade"
				+ ", points"
				+ " from grades");
	}
	
	private List<MuGrade> getStudentList(String sql) {
		List<MuGrade> lstGrades = null;

		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> jdbcStudents = jdbc.queryForList(sql);
		if (!jdbcStudents.toString().equals("[]")) {
			lstGrades = new ArrayList<>();

			for (Map<String, Object> map : jdbcStudents) {
				fillList(lstGrades, map);
			}
		}
		return lstGrades;
	}

	private void fillList(List<MuGrade> lstGrades, Map<String, Object> map){

		MuGrade muGrade = new MuGrade();

		muGrade.setStudentNo(((Integer)map.get("studentNo")));
		muGrade.setAcademicYear(((String)map.get("academicYear")).trim());
		muGrade.setSemester(((String)map.get("semester")).trim());
		muGrade.setProgramNo(((String)map.get("programNo")).trim());
		muGrade.setCourseNo(((String)map.get("courseNo")).trim());
        muGrade.setCaMarks((Double)map.get("caMarks"));
        muGrade.setExamMarks((Double)map.get("examMarks"));
		muGrade.setTotalMarks((Double)map.get("totalMarks"));
		muGrade.setGrade(((String)map.get("grade")).trim());
		muGrade.setPoints(((Double)map.get("points")));

		lstGrades.add(muGrade);
	}

}
