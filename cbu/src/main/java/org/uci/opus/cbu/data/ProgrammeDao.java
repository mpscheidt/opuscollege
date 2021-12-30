package org.uci.opus.cbu.data;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.domain.Programme;

public class ProgrammeDao {
	private DataSource dataSource;
	@Autowired private DepartmentDao departmentDao;
	private String[][] gradeTypes={
			{"BSC","Bachelor of Science","in","B.Sc."},
			{"BEng","Bachelor of Engineering","in","B.Eng."},
			{"BA","Bachelor of Arts","in","B.A."},
			{"B","Bachelor","of","B."},
			{"MSC","Masters of Science","in","M.Sc."},
			{"MEngSc","Masters of Engineering","in","M.Eng."},
			{"MA","Masters of Arts", "in","M.A."},
			{"MPHIL","Masters of Philosophy","in","MPhil."},
			{"M","Masters","of","M."},
			{"ADVTECH","Advanced Technician Certificate","in","Adv.Tech.Cert."},
			{"ADVCERT","Advanced Certificate","in","Adv.Cert."},
			{"DA","Diploma","in","Dpl.A"}};
		
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Programme getProgramme(String programmeCode){
		String sql= "SELECT * FROM CBUSchoolProgrammes WHERE ProgrammeCode='"+programmeCode+"'";
		List<Programme> lstProgramme=getProgrammeList(sql);
		if(lstProgramme.size()>0)
			return lstProgramme.get(0);
		else
			return null;
	}
	
	public Programme getProgramme(String programmeCode, int academicYear){
		String sql= "SELECT * FROM CBUSchoolProgrammes WHERE ProgrammeCode='"+programmeCode+"'";
		List<Programme> lstProgramme=getProgrammeList(sql);
		Programme programme=null;
		
		if(lstProgramme.size()>0){
			programme=lstProgramme.get(0);
			if(programmeCode.equals("22") && academicYear<2012){
				programme.setName("Bachelor of Science in Building");
				programme.setYearStopped(2011);
			}else if(programmeCode.equals("22") && academicYear<2012){
				programme.setName("Bachelor of Science in Quantity Surveying");
				programme.setYearStopped(2011);
			}else if(programmeCode.equals("24") && academicYear<=2006){
				programme.setName("Bachelor of Science in Land Economy");
				programme.setYearStopped(2006);
			}
		}
		
		return programme;
	}
	
	public List<Programme> getProgrammes(){
		String sql= "SELECT * FROM CBUSchoolProgrammes WHERE ProgrammeLevel IS NOT NULL AND SchoolCode IS NOT NULL AND DepartmentCode IS NOT NULL ORDER BY ProgrammeName";
		//String sql= "SELECT TOP(10)* FROM CBUSchoolProgrammes WHERE ProgrammeCode IN ('91','92') AND ProgrammeLevel IS NOT NULL AND SchoolCode IS NOT NULL AND DepartmentCode IS NOT NULL ORDER BY ProgrammeName DESC";
		Programme programme=getProgramme("24");
		programme.setName("Bachelor of Science in Land Economy");
		programme.setYearStopped(2006);
		
		Programme programme2=getProgramme("22");
		programme2.setName("Bachelor of Science in Building");
		programme2.setYearStopped(2011);
		
		Programme programme3=getProgramme("23");
		programme3.setName("Bachelor of Science in Quantity Surveying");
		programme3.setYearStopped(2011);
		
		List<Programme> programmes=getProgrammeList(sql);
		programmes.add(programme);
		programmes.add(programme2);
		programmes.add(programme3);
		
		return programmes;
	}
	
	public List<Programme> getProgrammes(String departmentCode){
		String sql= "SELECT * FROM CBUSchoolProgrammes WHERE DepartmentCode='"+departmentCode+"' AND ProgrammeLevel IS NOT NULL AND SchoolCode IS NOT NULL ORDER BY ProgrammeName";
		return getProgrammeList(sql);
	}
	
	public List<Programme> getProgrammesBySchool(String schoolCode){
		String sql= "SELECT * FROM CBUSchoolProgrammes WHERE SchoolCode='"+schoolCode+"' AND ProgrammeLevel IS NOT NULL AND DepartmentCode IS NOT NULL ORDER BY ProgrammeName";
		return getProgrammeList(sql);
	}
	
	private List<Programme> getProgrammeList(String sql){
		List<Programme> lstProgrammes=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcProgrammes=jdbc.queryForList(sql);
		if(!jdbcProgrammes.toString().equals("[]")){
			lstProgrammes=new ArrayList<Programme>();
			
			for(Map<String, Object> map: jdbcProgrammes){
				fillList(lstProgrammes, map);
			}
		}
		return lstProgrammes;
	}
	
	public Date getProgrammeStartDate(String programmeCode,String studyDescription){
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		Date dateStarted=null;
		
		try{
			
			Integer yearStarted;
			if(studyDescription.indexOf("Construction Management")!=-1 && programmeCode.equals("22"))
				yearStarted=2012;
			else if(studyDescription.indexOf("Building Economics")!=-1 && programmeCode.equals("23"))
				yearStarted=2012;
			else if(studyDescription.indexOf("Real Estate")!=-1 && programmeCode.equals("24"))
				yearStarted=2007;
			else
				yearStarted=jdbc.queryForObject("SELECT MIN(YearOfEntry) FROM Student_Details WHERE ProgrammeCode='"+programmeCode+"'",Integer.class);
						
			if(yearStarted!=null){
				dateStarted=makeDate(1, 1, yearStarted);
			}else{
				dateStarted=makeDate(1, 1, 2012);
			}
		}catch(Exception ex){
			dateStarted=makeDate(1, 1, 2012);
		}
		
		return dateStarted;
	}
	
	private void fillList(List<Programme> lstProgrammes,Map<String,Object> map){
		Programme programme=new Programme();
		String programmeName=map.get("ProgrammeName").toString().trim().equalsIgnoreCase("Quantity Surveying")?"Bachelor of Science in Quantity Surveying":map.get("ProgrammeName").toString().trim();
		String programmeCode=map.get("ProgrammeCode").toString().trim();
		if(programmeCode.equals("22") && programmeName.toLowerCase().indexOf("quantity surveying")!=-1) programmeCode="23";
		
		programme.setCode(programmeCode);
		programme.setName(programmeName);
		programme.setProgrammeLevel(map.get("ProgrammeLevel").toString().trim());
		programme.setProgrammeDuration(map.get("CourseDuration")==null?0:Integer.valueOf(map.get("CourseDuration").toString().trim()));
		programme.setCutOffPointFemale(map.get("CutOffPointFemale")==null?0:Integer.valueOf(map.get("CutOffPointFemale").toString().trim()));
		programme.setCutOffPointMale(map.get("CutOffPointMale")==null?0:Integer.valueOf(map.get("CutOffPointMale").toString().trim()));
		programme.setDepartment(departmentDao.getDepartment(map.get("SchoolCode").toString().trim(),map.get("DepartmentCode").toString().trim()));
		lstProgrammes.add(programme);
	}
	
	public String getStudyDescription(String programmeName){
		String[] tokens=programmeName.trim().split(" ");
		String studyDescription="";
		
		int start=getGradeTypeDescription(programmeName).split(" ").length;
		for(int i=start; i<tokens.length;i++){
			tokens[i]=tokens[i].trim();
			
			if(tokens[i].toLowerCase().indexOf("-distance")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("-distance"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("by distance")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("by distance"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("distance")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("distance"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("-evening")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("-evening"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("(evening)")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("(evening)"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("evening")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("evening"))+" ";
				break;
			}else if(tokens[i].toLowerCase().indexOf("full time")!=-1){
				studyDescription+=tokens[i].substring(0,tokens[i].toLowerCase().indexOf("full time"))+" ";
				break;
			}else{
				studyDescription+=tokens[i]+" ";
			}
		}
		
		if(studyDescription.toLowerCase().indexOf("in")==0 || studyDescription.toLowerCase().indexOf("of")==0)
			studyDescription=studyDescription.substring(3);
		if(studyDescription.lastIndexOf("by",studyDescription.length()-4)!=-1)
			studyDescription=studyDescription.substring(0,studyDescription.lastIndexOf("by",studyDescription.length()-4));
		
		return studyDescription.trim();
	}
	
	public String getGradeTypeCode(String programmeName){
		String gradeTypeCode="";
		
		for(int i=0; i<gradeTypes.length;i++){
			if(programmeName.toLowerCase().trim().indexOf(gradeTypes[i][1].toLowerCase())!=-1){
				gradeTypeCode=gradeTypes[i][0];
				break;
			}
		}

		return gradeTypeCode;
	}
	
	public String getGradeTypeDescription(String programmeName){
		String gradeTypeDescription="";
		
		for(int i=0; i<gradeTypes.length;i++){
			if(programmeName.toLowerCase().trim().indexOf(gradeTypes[i][1].toLowerCase())!=-1){
				gradeTypeDescription=gradeTypes[i][1];
				break;
			}
		}

		return gradeTypeDescription;
	}
	
	public String getGradeTypeTitle(String gradeTypeDescription){
		String gradeTypeTitle="";
		
		for(int i=0; i<gradeTypes.length;i++){
			if(gradeTypes[i][1].toLowerCase().equals(gradeTypeDescription.toLowerCase())){
				gradeTypeTitle=gradeTypes[i][3];
				break;
			}
		}

		return gradeTypeTitle;
	}
	public String getStudyFormDescription(String programmeName){
		String studyFormDescription="regular programme";
		if(programmeName.trim().toLowerCase().indexOf("distance")!=-1) studyFormDescription="distant learning";
		return studyFormDescription;
	}
	
	public String getStudyTimeDescription(String programmeName){
		String studyTimeDescription="Day";
		if(programmeName.trim().toLowerCase().indexOf("evening")!=-1) studyTimeDescription="Evening";
		return studyTimeDescription;
	}
	
	private Date makeDate(int day, int month, int year) {
		Calendar calendar = new GregorianCalendar();
		calendar.getTime();
		calendar.set(Calendar.DAY_OF_MONTH, day);
		calendar.set(Calendar.MONTH, month);
		calendar.set(Calendar.YEAR, year);
		return calendar.getTime();
	}
}
