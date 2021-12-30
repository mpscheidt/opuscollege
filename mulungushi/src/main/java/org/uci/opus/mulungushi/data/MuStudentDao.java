package org.uci.opus.mulungushi.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.uci.opus.mulungushi.domain.MuStudent;

public class MuStudentDao {

	private DataSource dataSource;
	private JdbcTemplate jdbc;
	
	private static SimpleDateFormat df = (SimpleDateFormat) DateFormat.getDateInstance();
	
	static {
		df.applyPattern("yyyy-MM-dd");
	}


	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
		jdbc = new JdbcTemplate(dataSource);
	}

	public List<MuStudent> getStudents() {
		return getStudentList("select"
				+ "  StudentNo"
				+ ", substring_index(studentname,' ',1) as surname"
				+ ", substring_index(substring_index(trim(studentname),' ',-2),' ',-1) as firstnames"
				+ ", sex"
				+ ", NRC_PassportNo"
				+ ", CASE WHEN dateOfBirth = '0000-00-00' THEN '1900-01-01' ELSE dateOfBirth END AS dateOfBirth"
				+ ", placeOfBirth"
				+ ", nationality"
				+ ", maritalStatus"
				+ ", residentialAddress"
				+ ", businessPhone"
				+ ", postalAddress"
				+ ", mobileNo"
				+ ", email"
				+ ", nameOfNextOfKin"
				+ ", nextOfKinResAddress"
				+ ", nextOfKinPostalAddress"
				+ ", nextOfKinMobileNo"
				+ ", nextOfKinPhoneNo"
				+ ", relationToNextOfKin"
				+ ", remark"
				+ ", CASE WHEN graduation = '0000-00-00' THEN NULL ELSE graduation END AS graduation"
				+ " from students");
	}

	private String getProgramNo(Integer studentNo) {
	    if (studentNo == null) {
	        return null;
	    }

	    String sql = "SELECT trim(grades.programNo) FROM grades WHERE grades.studentNo = ? AND trim(grades.programNo) <> '' LIMIT 1";
	    List<String> programNos = jdbc.query(sql, new RowMapper<String>() {
	        @Override
	        public String mapRow(ResultSet rs, int rowNum) throws SQLException {
	            return rs.getString(1);
	        }
	    }, studentNo);
	    
	    if (programNos.isEmpty()) {
	        return null;
	    } else {
	        return programNos.get(0);
	    }
	}
	
	private List<MuStudent> getStudentList(String sql) {
		List<MuStudent> lstStudents = null;

		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> jdbcStudents = jdbc.queryForList(sql);
		if (!jdbcStudents.toString().equals("[]")) {
			lstStudents = new ArrayList<>();

			for (Map<String, Object> map : jdbcStudents) {
				fillList(lstStudents, map);
			}
		}
		return lstStudents;
	}

	private void fillList(List<MuStudent> lstStudents, Map<String, Object> map){

		try {
			MuStudent student = new MuStudent();

			Integer studentNo = (Integer)map.get("studentNo");
            student.setStudentNo(studentNo);
			student.setFirstnames(((String)map.get("firstnames")).trim());
			student.setSurname(((String)map.get("surname")).trim());
			student.setSex(((String)map.get("sex")).trim());
			student.setNrcOrPassport(((String)map.get("NRC_PassportNo")).trim());
			student.setDateOfBirth(df.parse((String)map.get("dateOfBirth")));
			student.setPlaceOfBirth(((String)map.get("placeOfBirth")).trim());
			student.setNationality(((String)map.get("nationality")).trim());
			student.setProgramNo(getProgramNo(studentNo));
			student.setMaritalStatus(((String)map.get("maritalStatus")).trim());
			student.setResidentialAddress(((String)map.get("residentialAddress")).trim());
			student.setBusinessPhone(((String)map.get("businessPhone")).trim());
			student.setPostalAddress(((String)map.get("postalAddress")).trim());
			student.setMobileNo(((String)map.get("mobileNo")).trim());
			student.setEmail(((String)map.get("email")).trim());
			student.setNameOfNextOfKin(((String)map.get("nameOfNextOfKin")).trim());
			student.setNextOfKinResAddress(((String)map.get("nextOfKinResAddress")).trim());
			student.setNextOfKinPostalAddress(((String)map.get("nextOfKinPostalAddress")).trim());
			student.setNextOfKinMobileNo(((String)map.get("nextOfKinMobileNo")).trim());
			student.setNextOfKinPhoneNo(((String)map.get("nextOfKinPhoneNo")).trim());
			student.setRelationToNextOfKin(((String)map.get("relationToNextOfKin")).trim());
			student.setRemark(((String)map.get("remark")).trim());
			student.setGraduation(((Date)map.get("graduation")));
	//		
	//		List<String> programNos = getPrograms(course.getCourseNo());
	//		course.setPrograms(programNos);
			
			
	
			lstStudents.add(student);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

//	private List<String> getPrograms(String courseNo) {
//		List<String> programNos = new ArrayList<String>();
//		
//		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
//		List<Map<String, Object>> jdbcProgCourses = jdbc.queryForList("select programNo from progcourses where courseNo = ?", courseNo);
//		if (!jdbcProgCourses.toString().equals("[]")) {
//
//			for (Map<String, Object> map : jdbcProgCourses) {
//				programNos.add(((String)map.get("programNo")).trim());
//			}
//		}
//		
//		
//		return programNos;
//	}

}
