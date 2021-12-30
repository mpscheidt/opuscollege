package org.uci.opus.mulungushi.data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.mulungushi.domain.Programme;

public class ProgrammeDao {

	private DataSource dataSource;

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public List<Programme> getProgrammes() {
		List<Programme> programmes = getProgrammeList("select programNo, programName, school, yearOfStudy, modeOfStudy from programmes where lower(yearofstudy) = 'general'    and school != 'Institute for Distance Education (IDE)'");
		List<Programme> distanceProgrammes = getProgrammeList("select programNo, programName, school, yearOfStudy, modeOfStudy from programmes where lower(yearofstudy) = 'First Year' and school =  'Institute for Distance Education (IDE)'");
		for (Programme p : distanceProgrammes) {
		    p.setProgrammeNumber(p.getProgrammeNumber().substring(0, p.getProgrammeNumber().length() - 2) + "D");
		}
        programmes.addAll(distanceProgrammes);
        return programmes;
	}
	
	private List<Programme> getProgrammeList(String sql) {
		List<Programme> lstProgrammes = null;

		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> jdbcProgrammes = jdbc.queryForList(sql);
		if (!jdbcProgrammes.toString().equals("[]")) {
			lstProgrammes = new ArrayList<Programme>();

			for (Map<String, Object> map : jdbcProgrammes) {
				fillList(lstProgrammes, map);
			}
		}
		return lstProgrammes;
	}

	private void fillList(List<Programme> lstProgrammes, Map<String, Object> map){

		Programme programme = new Programme();
//		String programmeName=map.get("ProgrammeName").toString().trim().equalsIgnoreCase("Quantity Surveying")?"Bachelor of Science in Quantity Surveying":map.get("ProgrammeName").toString().trim();
//		String programmeCode=map.get("ProgrammeCode").toString().trim();
//		if(programmeCode.equals("22") && programmeName.toLowerCase().indexOf("quantity surveying")!=-1) programmeCode="23";

		programme.setProgrammeNumber(((String)map.get("programNo")).trim());
		programme.setProgrammeName(((String)map.get("programName")).trim());
		programme.setSchool(((String)map.get("school")).trim());
		programme.setYearOfStudy(((String)map.get("yearOfStudy")).trim());
		programme.setModeOfStudy(((String)map.get("modeOfStudy")).trim());

//		programme.setCode(programmeCode);
//		programme.setName(programmeName);
//		programme.setProgrammeLevel(map.get("ProgrammeLevel").toString().trim());
//		programme.setProgrammeDuration(map.get("CourseDuration")==null?0:Integer.valueOf(map.get("CourseDuration").toString().trim()));
//		programme.setCutOffPointFemale(map.get("CutOffPointFemale")==null?0:Integer.valueOf(map.get("CutOffPointFemale").toString().trim()));
//		programme.setCutOffPointMale(map.get("CutOffPointMale")==null?0:Integer.valueOf(map.get("CutOffPointMale").toString().trim()));
//		programme.setDepartment(departmentDao.getDepartment(map.get("SchoolCode").toString().trim(),map.get("DepartmentCode").toString().trim()));
		lstProgrammes.add(programme);
	}

}
