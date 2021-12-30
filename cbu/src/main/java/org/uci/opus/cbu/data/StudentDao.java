package org.uci.opus.cbu.data;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.dbconversion.StudentMigrator;
import org.uci.opus.cbu.domain.Course;
import org.uci.opus.cbu.domain.Nationality;
import org.uci.opus.cbu.domain.Results;
import org.uci.opus.cbu.domain.SecondarySchoolSubjectResult;
import org.uci.opus.cbu.domain.Student;

public class StudentDao {
	private DataSource dataSource;
	@Autowired private NationalityDao nationalityDao;
	@Autowired private ProgrammeDao programmeDao;
	@Autowired private CourseDao courseDao;
	
	private static Logger log = LoggerFactory.getLogger(StudentMigrator.class);
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public List<Student> getStudents(String programmeCode){
		String sql= "SELECT * FROM Student_Details WHERE ProgrammeCode='"+programmeCode+"' AND StudentNumber IS NOT NULL AND YearOfEntry IS NOT NULL";
		return getStudentList(sql);
	}
	
	public List<Student> getStudents(String programmeCode,int yearOfStudy){
		String sql= "SELECT * FROM Student_Details WHERE ProgrammeCode='"+programmeCode+"' AND YearOfStudy='"+ yearOfStudy +"' AND StudentNumber IS NOT NULL AND YearOfEntry IS NOT NULL";
		return getStudentList(sql);
	}
	
	public List<Student> getStudents(String programmeCode,int yearOfStudy, int yearRegistered){
		String sql= "SELECT * FROM Student_Details WHERE ProgrammeCode='"+programmeCode+"' AND YearOfStudy='"+ yearOfStudy +"' AND YearRegistered='"+yearRegistered+"' AND StudentNumber IS NOT NULL AND YearOfEntry IS NOT NULL";
		return getStudentList(sql);
	}
	
	public int getYearOfStudy(String studentNo,int academicYear){
		String sql= "SELECT YearOfStudy FROM StudentProgramme WHERE StudentNumber='"+studentNo+"' AND YearRegistered='"+ academicYear +"' AND YearRegistered='"+academicYear+"'";
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcStudents=jdbc.queryForList(sql);
		if(!jdbcStudents.toString().equals("[]"))
			return Integer.parseInt(jdbcStudents.get(0).get("YearOfStudy").toString());
		return 0;
	}
	
	public List<SecondarySchoolSubjectResult> getSecondarySchoolResults(String studentNo){
		String sql= "SELECT * FROM FirstYear_Details WHERE StudentNumber='"+studentNo+"'";
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> results=jdbc.queryForList(sql);
		List<SecondarySchoolSubjectResult> secondarySchoolResult=null;
		if(!results.toString().equals("[]")){
			secondarySchoolResult=new ArrayList<SecondarySchoolSubjectResult>();
			for(int i=1;i<=12;i++){
				String subjectName=(String)results.get(0).get("Subject"+i);
				if(subjectName!=null && results.get(0).get("Grade"+i)!=null){
					SecondarySchoolSubjectResult result=new SecondarySchoolSubjectResult();
					result.setGrade(results.get(0).get("Grade"+i).toString());
					result.setSubjectName(subjectName);
					secondarySchoolResult.add(result);
				}
			}
			
			if(secondarySchoolResult.size()==0)secondarySchoolResult=null;
		}
		
		return secondarySchoolResult;
	}
	
	private List<Student> getStudentList(String sql){
		List<Student> lstStudents=null;
		
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> jdbcStudents=jdbc.queryForList(sql);
		if(!jdbcStudents.toString().equals("[]")){
			lstStudents=new ArrayList<Student>();
			
			for(Map<String, Object> map: jdbcStudents){
				fillList(lstStudents, map);
			}
		}
		return lstStudents;
	}
	
	public List<Results> getResults(String studentNo, int academicYear){
		List<Results> lstResults=null;
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		if(academicYear>=2010){
			List<Map<String,Object>> rows=jdbc.queryForList("SELECT rd.StudentNumber,sp.ProgrammeCode,sp.YearRegistered,sp.StudyCategory,sp.YearOfStudy,rd.CourseCode,rd.SenateMark,rd.SenateGrade,sp.SenateComment FROM Results_Details  AS rd INNER JOIN StudentProgramme AS sp ON sp.StudentNumber=rd.StudentNumber AND sp.YearRegistered=rd.[Year] AND sp.StudentNumber='"+studentNo+"' AND sp.YearRegistered='"+academicYear+"' AND sp.ProgrammeCode IS NOT NULL");
			if(!rows.toString().equals("[]")){
				lstResults=new ArrayList<Results>();
				for(Map<String,Object>row:rows){
					if(row.get("CourseCode")!=null){
						String courseCode=row.get("CourseCode")==null?null:row.get("CourseCode").toString().trim();
						String programmeCode=row.get("ProgrammeCode").toString().trim();
						String studyCategory=(String)row.get("StudyCategory");
						String programmeCode2=getProgrammeCode(programmeCode, courseCode);
						//TODO Uncomment the code below to normalise the courses. There is a problem with a number of courses
						//which were wrong coded. Do not uncomment if the data has to be taken as it is
						/* 
						////For Courses with ESQ Change the programmeCode from 22 to 23
						if(courseCode.indexOf("ESQ")!=-1)
							programmeCode2="23";
						
						//For Quantity Surveying students, change the codes from ESB to ESQ
						if(courseCode.indexOf("ESB")!=-1 && programmeCode2.equals("23"))
							courseCode=courseCode.replace("ESB", "ESQ");
						
						//For Diploma HRM, change the codes from HRM to DHRM
						if(courseCode.indexOf("HRM")==0 && programmeCode2.equals("17"))
							courseCode=courseCode.replace("HRM", "DHRM");
						
						//For BBA Distance, change the some codes with BS to BBA
						if(courseCode.indexOf("BS")==0 && programmeCode2.equals("77"))
							courseCode=courseCode.replace("BS", "BBA");
						
						if(courseCode.indexOf("ESA 500")==0)
							courseCode=courseCode.replace("ESA", "ES");
						
						if(courseCode.indexOf("ES 220")==0 && programmeCode2.equals("20"))
							courseCode=courseCode.replace("ES", "ESA");
						
						if(courseCode.indexOf("ES 262")==0 && programmeCode2.equals("20"))
							courseCode=courseCode.replace("ESA", "ES");
						
						//For Courses which start with BBA, change programmeCode to 77
						if(courseCode.indexOf("BBA")==0)
							programmeCode2="77";
						*/
						
						Course course=courseDao.getCourse(programmeCode2,courseCode);
						
						//If course is null then create a new course
						if(course==null){ 
							course=new Course();
							course.setName(courseCode);
							org.uci.opus.cbu.data.Logger.log("\""+programmeCode2+"\",\""+courseCode+"\"\n");
						}
						//String courseName=courseDao.getCourse(programmeCode2,courseCode).getName();
						String mark=(row.get("SenateMark")!=null && !row.get("SenateMark").toString().trim().equals(""))?row.get("SenateMark").toString():null;
						String grade=row.get("SenateGrade")==null?null:row.get("SenateGrade").toString().trim();
						String comment=row.get("SenateComment")==null?null:row.get("SenateComment").toString().trim();
												
						Results results=new Results();
						results.setMark(mark==null?"":mark);
						results.setGrade(grade);
						
						
						course.setCode(courseCode.trim());
						//course.setName(courseName);
													
						course.setProgramme(programmeDao.getProgramme(programmeCode2));
						results.setCourse(course);
						results.setYear(Integer.valueOf(row.get("YearRegistered").toString()));
						results.setComment(comment);
						results.setStudyCategoryCode(getStudyCategoryCode(studyCategory, false));
						lstResults.add(results);
					}
				}
			}
		}
		return lstResults;
	}
	
	public List<Results> getResults(String studentNo,String programmeCode, int yearOfStudy){
		List<Results> lstResults=null;
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		String[] fieldPrefix = { "FIRST", "SECOND", "THIRD", "FOURTH", "FIFTH","SIXTH", "SEVENTH", "EIGHTH" };
		for(int i=1;i<=2;i++){
			boolean partTimeTable=(i%2==0?true:false);
			String tableName=getTableName(yearOfStudy, partTimeTable);
			List<Map<String,Object>> rows=jdbc.queryForList("SELECT TOP(1)* FROM " + tableName + " WHERE StudentNumber='"+ studentNo+"'");
			if(!rows.toString().equals("[]")){
				lstResults=new ArrayList<Results>();
				for(Map<String,Object>row:rows){
					for(String key:row.keySet()){
						String field = fieldPrefix[ yearOfStudy - 1];
						if (key.indexOf(field) != -1 && key.indexOf("Code") != -1) {
							String courseCode=row.get(getCourseCodeField(field, key))==null?null:row.get(getCourseCodeField(field, key)).toString().trim();
							String courseName=prettyFormat(row.get(getCourseNameField(field, key))==null?null:row.get(getCourseNameField(field, key)).toString().trim());
							String mark=row.get(getMarkField(field, key))==null?null:row.get(getMarkField(field, key)).toString();
							String grade=row.get(getGradeField(field, key))==null?null:row.get(getGradeField(field, key)).toString().trim();
							String comment=row.get(getCommentField(field,key))==null?null:row.get(getCommentField(field,key)).toString().trim();
							String studyCategory=(String)row.get("StudyCategory");
							
							if(courseCode!=null && !courseCode.trim().equals("") && row.get("YearRegistered")!=null){
								
								Results results=new Results();
								results.setMark(mark==null?"":mark);
								results.setGrade(grade);
								Course course=new Course();
								course.setCode(courseCode);
								course.setName(courseName);
								course.setProgramme(programmeDao.getProgramme(getProgrammeCode(programmeCode, courseCode),Integer.valueOf(row.get("YearRegistered").toString())));
								results.setCourse(course);
								results.setComment(comment);
								
								results.setStudyCategoryCode(getStudyCategoryCode(studyCategory, partTimeTable));
								results.setYear(Integer.valueOf(row.get("YearRegistered").toString()));
								lstResults.add(results);
							}
						}
					}
				}
			}
		}
		return lstResults;
	}
	
	private String getStudyCategoryCode(String studyCategory,boolean partTimeTable){
		String studyCategoryCode="F";
		
		if((studyCategory==null && partTimeTable) || (studyCategory!=null && studyCategory.indexOf("PART")!=-1) || (studyCategory!=null && studyCategory.indexOf("EVENING")!=-1))
			studyCategoryCode="P";
		else if(studyCategory!=null && studyCategory.indexOf("DISTANCE")!=-1)
			studyCategoryCode="D";
		
		return studyCategoryCode;
	}
	
	private String getProgrammeCode(String programmeCode,String courseCode){
		if(courseCode.length()>3){
			
			try{
				int firstDigit=Integer.parseInt(courseCode.trim().substring(courseCode.trim().length()-3,courseCode.trim().length()-2));
				if((firstDigit==1 || firstDigit==2) && (programmeCode.trim().equals("11") || programmeCode.trim().equals("13") || programmeCode.trim().equals("15")))
					programmeCode="10";
				else if(firstDigit>=1 && firstDigit<=4 && programmeCode.trim().equals("23"))
					programmeCode="22";
				else if((firstDigit==1 || firstDigit==2) && (programmeCode.trim().equals("52") || programmeCode.trim().equals("49") || programmeCode.trim().equals("47")))
					programmeCode="45";
			}catch(Exception ex){
				log.error(ex.getMessage());
			}
		}
		return programmeCode.trim();
	}
	
	private String getTableName(int yearOfStudy, boolean partTime){
		String[] prefix={"FIRST","SECOND","THIRD","FOURTH","FIFTH","SIXTH","SEVENTH","EIGHTH"};
		String suffix=(partTime && yearOfStudy<=5)?"YearPT":"Year";
		
		return prefix[yearOfStudy-1] + suffix +"_Details";
	}
	
	private String getMarkField(String prefix,String fieldName){
		String number = fieldName.substring(fieldName.indexOf("Code") + 4);
		String markField = prefix + fieldName.substring(prefix.length(),fieldName.indexOf("Code")) + "Mark" + number;
		return markField;
	}
	
	private String getCommentField(String prefix,String fieldName){
		String commentField = prefix + fieldName.substring(prefix.length(),fieldName.indexOf("Code")) + "Comment";
		if(fieldName.toLowerCase().indexOf("rept")>0)
			commentField = prefix + fieldName.substring(prefix.length(),fieldName.indexOf("Rept")) + "Comment";
		
		return commentField;
	}
	
	private String getCourseCodeField(String prefix,String fieldName){
		String courseField = fieldName;
		return courseField;
	}
	
	private String getGradeField(String prefix,String fieldName){
		String number = fieldName.substring(fieldName.indexOf("Code") + 4);
		String gradeField = prefix + fieldName.substring(prefix.length(),fieldName.indexOf("Code")) + "Grade" + number;
	
		if (prefix.indexOf("FIRST")!=-1)
			gradeField += "A";
		return gradeField;
	}
	
	private String getCourseNameField(String prefix,String fieldName){
		String number = fieldName.substring(fieldName.indexOf("Code") + 4);
		String courseNameField = prefix	+ fieldName.substring(prefix.length(),fieldName.indexOf("Code")) + "Course"	+ number;
		return courseNameField;
	}
	
	
	private void fillList(List<Student> lstStudent,Map<String,Object> map){
		Student student=new Student();
		String firstName=map.get("First_Name")==null?"":map.get("First_Name").toString().trim().length()>2?map.get("First_Name").toString().trim().substring(0, 1)+""+map.get("First_Name").toString().trim().substring(1).toLowerCase():"";
		String lastName =map.get("Family_Name")==null?"":map.get("Family_Name").toString().trim().length()>2?map.get("Family_Name").toString().trim().substring(0, 1)+""+map.get("Family_Name").toString().trim().substring(1).toLowerCase():"";
		String otherNames =map.get("OtherNames")==null?"":map.get("OtherNames").toString().trim().length()>2?map.get("OtherNames").toString().trim().substring(0, 1)+""+map.get("OtherNames").toString().trim().substring(1).toLowerCase():"";
		
		Date dateOfBirth=map.get("Date_of_Birth")==null? makeDate("01/01/1900"):makeDate(map.get("Date_of_Birth").toString());
		student.setStudentNo(map.get("Studentnumber").toString().trim());
		student.setFirstName(firstName);
		student.setLastName(lastName);
		student.setOtherNames(otherNames);
		student.setGender(map.get("Sex")==null?"":map.get("Sex").toString().trim());
		student.setMaritalStatus(map.get("Marital_Status")==null?"":map.get("Marital_status").toString().trim());
		student.setDateOfBirth(dateOfBirth);
		student.setNrcNo(map.get("NRC_No")==null?"":map.get("NRC_No").toString().trim());
		student.setPassportNo(map.get("Passport_No")==null?"":map.get("Passport_No").toString().trim());
		student.setTelephoneNo(map.get("Telephone_No")==null?"":map.get("Telephone_No").toString().trim());
		student.setFaxNo(map.get("Fax_No")==null?"":map.get("Fax_No").toString().trim());
		student.setEmail(map.get("Email_Address")==null?"":map.get("Email_Address").toString().trim());
		student.setPlotNo(map.get("PlotNoStu")==null?"":map.get("PlotNoStu").toString().trim());
		student.setBoxNo(map.get("BoxStu")==null?"":map.get("BoxStu").toString().trim());
		student.setStreet(map.get("StreeStu")==null?"":map.get("StreetStu").toString().trim());
		student.setTown(map.get("CityTownStu")==null?"":map.get("CityTownStu").toString().trim());
		student.setBoxNo(map.get("Province")==null?"":map.get("Province").toString().trim());
		student.setNameOfGuardian(map.get("Name_of_guardian")==null?"":map.get("Name_of_guardian").toString().trim());
		student.setNationality(map.get("Nationality_Code")==null?new Nationality():nationalityDao.getNationality(map.get("Nationality_Code").toString().trim()));
		student.setSchoolLeaver(map.get("School_leaver")==null?false:map.get("BoxStu").toString().trim().toUpperCase().equals("YES")?true:false);
		student.setYearOfEntry(map.get("YearOfEntry")==null?1900:Integer.parseInt(map.get("YearOfEntry").toString().trim()));
		student.setYearRegistered(map.get("YearRegistered")==null?0:Integer.parseInt(map.get("YearRegistered").toString().trim()));
		student.setYearGraduated(map.get("YearGraduated")==null?1900:Integer.parseInt(map.get("YearGraduated").toString().trim()));
		student.setYearOfStudy(map.get("YearOfStudy")==null?0:Integer.parseInt(map.get("YearOfStudy").toString().trim()));
		student.setDurationOfStudy(map.get("DurationOfStudy")==null?0:Integer.parseInt(map.get("DurationOfStudy").toString().trim()));
		student.setStudyCategory(map.get("StudyCategory")==null?null:map.get("StudyCategory").toString().trim());
		student.setSponsor(map.get("Sponsor")==null?null:map.get("Sponsor").toString().trim());
		student.setApplicationNo(map.get("Application_No")==null?null:map.get("Application_No").toString().trim());
		int academicYear=student.getYearRegistered()>student.getYearOfEntry()?student.getYearRegistered():student.getYearOfEntry();
		
		//String programmeName=map.get("ProgrammeName").toString().trim().equalsIgnoreCase("Quantity Surveying")?"Bachelor of Science in Quantity Surveying":map.get("ProgrammeName").toString().trim();
		String programmeCode=map.get("ProgrammeCode").toString().trim();
		//if(programmeCode.equals("22") && programmeName.toLowerCase().indexOf("quantity surveying")!=-1) programmeCode="23";
		student.setDateOfEnrollment(makeDate("01/01/"+student.getYearOfEntry()));
		student.setProgramme(map.get("ProgrammeCode")==null?null:programmeDao.getProgramme(programmeCode,academicYear));
		lstStudent.add(student);
	}
	
	
	private Date makeDate(String date) {
		Calendar calendar = new GregorianCalendar();
		calendar.getTime();
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		calendar.set(Calendar.MONTH, 0);
		calendar.set(Calendar.YEAR, 1900);
		Date birthDate = calendar.getTime();

		if (date == null || date.isEmpty()) {
			return birthDate;
		}

		String[] dateParts = date.trim().indexOf("/") != -1 ? date
				.trim().split("/") : date.trim().split("-");
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		try{
			if (dateParts[2].length() == 4 || Integer.valueOf(dateParts[2]) > 31)
				birthDate = df.parse(dateParts[0] + "-" + dateParts[1] + "-"
						+ dateParts[2]);
			else if (dateParts[0].length() == 4
					|| Integer.valueOf(dateParts[0]) > 31)
				birthDate = df.parse(dateParts[2] + "-" + dateParts[1] + "-"
						+ dateParts[0]);
			else if(dateParts[2].length()==2)
				if(Integer.valueOf(dateParts[2])>11)
					birthDate = df.parse("19"+dateParts[2] + "-" + dateParts[1] + "-"+ dateParts[0]);
				else
					birthDate = df.parse("20"+dateParts[2] + "-" + dateParts[1] + "-"+ dateParts[0]);
			else
				birthDate = df.parse(date.trim());
		}catch (Exception e) {
			// TODO: handle exception
		}
		return birthDate;
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
		return value==null?null:value.trim();
	}
}
