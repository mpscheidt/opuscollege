package org.uci.opus.unza.dbconversion;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Examination;
import org.uci.opus.college.domain.ExaminationTeacher;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.ExaminationManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.unza.util.UnzaUtils;
import org.uci.opus.util.StringUtil;

public class UnzaStageCurriculumMigrator {
	private static Logger log = Logger.getLogger(UnzaStageCurriculumMigrator.class);
	private DataSource opusDataSource;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private LookupManagerInterface lookUpManager;
	@Autowired private OrganizationalUnitManagerInterface unitManager;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private SubjectManagerInterface subjectManager;
	@Autowired private ExaminationManagerInterface examinationManager;
	@Autowired private StaffMemberManagerInterface staffMemberManager;
	@Autowired private UnzaUtils unzaUtils;
	
	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}
	
	public void convertCurriculum() throws SQLException {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		
		//String query = "delete from opuscollege.study";
		//opusJdbcTemplate.execute(query);
		
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);

		/*String sql = "SELECT distinct m.majorcode as major_code,m.title as major_title,qta.quotacode as quota_code,"
			+ " qta.duration,qta.schoolcode,qta.title, sch.uname as descr "
			+" FROM srsdatastage.major m,srsdatastage.quota qta, srsdatastage.school sch "
			+" WHERE m.quotacode=qta.quotacode AND sch.code=qta.schoolcode";*/
		
		String sql = "SELECT m.majorcode as major_code,m.title as major_title,qta.quotacode as quota_code,qta.duration,qta.schoolcode,qta.title,qta.abbrev, sch.uname as descr " 
		           +" FROM srsdatastage.major m "
		           +" INNER JOIN srsdatastage.quota qta ON m.quotacode = qta.quotacode" 
		           +" INNER JOIN srsdatastage.school sch ON qta.schoolcode = sch.code";

		List<Map<String, Object>> studyList = jdbcTemplate.queryForList(sql);
		
		
		//String query1 = "delete from opuscollege.academicyear";
		//opusJdbcTemplate.execute(query1);
		
		
		//createAcademicYears();
		
		for (Map<String, Object> srsStudy : studyList) {
			log.info(srsStudy);

			String studyCode = (String) srsStudy.get("major_code");
			String studyTypeCode = ((String) srsStudy.get("quota_code")).toString();
			String studyDescr = (String) srsStudy.get("major_title");
			String studyDuration ="0" ;
			if (srsStudy.get("duration")!=null || srsStudy.get("duration")!="")
				studyDuration = (String)srsStudy.get("duration");
			
			String schCode = ((String) srsStudy.get("schoolcode")).toString();
			String descr = (String) srsStudy.get("descr");			

			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("organizationalUnitDescription", descr.trim());
			map.put("organizationalUnitCode", schCode);
			log.info("The org unit: "+map);
			OrganizationalUnit unit;
			unit = unitManager.findOrganizationalUnitByNameAndCode(map);

			HashMap<String, Object> map2 = new HashMap<String, Object>();
			
			map2.put("studyDescription", studyDescr.trim());			
			map2.put("organizationalUnitId", unit.getId());
			map2.put("academicFieldCode","0");
			// ensure that Study doesn't already exist
			Study study = studyManager.findStudyByNameUnit(map2);
			log.info("The Study is:"+map2);
			
			//log.info(study.getId());
			
			if (study == null) {				
				
				study = new Study();
				study.setId(Integer.parseInt(studyCode));
				study.setOrganizationalUnitId(unit.getId());
				study.setAcademicFieldCode("0");
				study.setStudyDescription(studyDescr.trim());
				study.setActive("Y");

				studyManager.addStudy(study);
			}

			
			List<AcademicYear> lstAcadyears = academicYearManager.findAllAcademicYears();
			log.info("The number of Years is: "+lstAcadyears.size()	);
			Map<String,Object> sgt = new HashMap<String,Object>();
			for (AcademicYear ay : lstAcadyears) {
				log.info(ay);
				List<String> studyTimeList = new ArrayList<String>();
				List<String> studyIntensityList = new ArrayList<String>();
				
				Map<String,String> studyIntensity = new HashMap<String,String>();
				studyTimeList.add("D");
				studyTimeList.add("E");
				studyIntensityList.add("F");
				studyIntensityList.add("P");
				StudyGradeType stdyGradeType = new StudyGradeType();
				
				//regular,distance,parallel
				/*for (int studyFormCode = 1; studyFormCode< 5;studyFormCode++){
					//day-time,evening (D,E)
					for (String studyTimeCode:studyTimeList){
						//full-time,part-time (F,P)
						for (String studyIntensityCode:studyIntensityList){
							//create a studyGradeType for each of these combinations
							StudyGradeType stdyGradeType = new StudyGradeType();
							//set active only the current year
							if (ay.getDescription().equals("2011")){
								stdyGradeType.setActive("Y");
							}else{
								stdyGradeType.setActive("N");
							}
							
							stdyGradeType.setCardinalTimeUnitCode("2");
							stdyGradeType.setCurrentAcademicYearId(ay.getId());
							stdyGradeType.setGradeTypeCode(studyTypeCode);
							stdyGradeType.setStudyId(study.getId());
							stdyGradeType.setGradeTypeDescription(srsStudy.get("title").toString());
							stdyGradeType.setMaxNumberOfCardinalTimeUnits(14);
							stdyGradeType.setMaxNumberOfSubjectsPerCardinalTimeUnit(6);
							stdyGradeType.setNumberOfCardinalTimeUnits(Integer.parseInt(studyDuration)*2);
							stdyGradeType.setNumberOfSubjectsPerCardinalTimeUnit(6);
							stdyGradeType.setStudyFormCode(new Integer(studyFormCode).toString());
							stdyGradeType.setStudyTimeCode(studyTimeCode);
							stdyGradeType.setStudyIntensityCode(studyIntensityCode);
							
							
							log.info("The duration of this programme is " + stdyGradeType.getNumberOfCardinalTimeUnits()+"SRS duration"+srsStudy.get("duration"));
							studyManager.addStudyGradeType(stdyGradeType);
						}
					}
					
					
				}*/
				stdyGradeType.setActive("Y");
				if(unzaUtils.isMedicineProgramme(studyTypeCode)){//medicine programme
					stdyGradeType.setCardinalTimeUnitCode("1");
				}else{
					stdyGradeType.setCardinalTimeUnitCode("2");
				}
				
				stdyGradeType.setCurrentAcademicYearId(ay.getId());
				stdyGradeType.setGradeTypeCode(studyTypeCode);
				stdyGradeType.setStudyId(study.getId());
				stdyGradeType.setGradeTypeDescription(srsStudy.get("abbrev").toString());
				stdyGradeType.setMaxNumberOfCardinalTimeUnits(14);
				stdyGradeType.setMaxNumberOfSubjectsPerCardinalTimeUnit(6);
				stdyGradeType.setNumberOfCardinalTimeUnits(Integer.parseInt(studyDuration)*2);
				stdyGradeType.setNumberOfSubjectsPerCardinalTimeUnit(6);
				stdyGradeType.setStudyFormCode("1");
				stdyGradeType.setStudyTimeCode("D");
				stdyGradeType.setStudyIntensityCode("F");
				
				log.info("The duration of this programme is " + stdyGradeType.getNumberOfCardinalTimeUnits()+"SRS duration"+srsStudy.get("duration"));
				//check that sgt does not exist
				sgt.put("preferredLanguage", "en");
				sgt.put("studyId", stdyGradeType.getStudyId());
				sgt.put("gradeTypeCode", stdyGradeType.getGradeTypeCode());
				sgt.put("currentAcademicYearId", stdyGradeType.getCurrentAcademicYearId());
				sgt.put("studyTimeCode", stdyGradeType.getStudyTimeCode());
				sgt.put("studyFormCode", stdyGradeType.getStudyFormCode());
				sgt.put("studyIntensityCode", stdyGradeType.getStudyIntensityCode());
				StudyGradeType stgt = studyManager.findStudyGradeTypeByParams(sgt);
				if (stgt == null){
					studyManager.addStudyGradeType(stdyGradeType);
				}else{
					log.info("The StudyGradeTypeExists");
				}	
				
				
				
				

			}

		}

	}
	
	
	public void createDefaultPrimaryStudyGradeType() throws NullPointerException {
		
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		
		String sql = "SELECT m.majorcode as major_code,m.title as major_title,qta.quotacode as quota_code,"
			+ " qta.duration,qta.schoolcode,qta.title, sch.uname as descr "
			+" FROM srsdatastage.major m,srsdatastage.quota qta, srsdatastage.school sch "
			+" WHERE m.quotacode=qta.quotacode AND sch.code=qta.schoolcode";

		List<Map<String, Object>> studyList = jdbcTemplate.queryForList(sql);
		
		//createAcademicYears();
		
		
		for (Map<String, Object> srsStudy : studyList) {
			//log.info(srsStudy);

			String studyCode = (String) srsStudy.get("major_code");
			String studyTypeCode = ((String) srsStudy.get("quota_code")).toString();
			String studyDescr = (String) srsStudy.get("major_title");
			String schCode = ((String) srsStudy.get("schoolcode")).toString();
			String descr = (String) srsStudy.get("descr");			

			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("organizationalUnitDescription", descr.trim());
			map.put("organizationalUnitCode", schCode);
			//log.info(map);
			
			OrganizationalUnit unit;
			
			unit = unitManager.findOrganizationalUnitByNameAndCode(map);

			HashMap<String, Object> map2 = new HashMap<String, Object>();
			
			map2.put("studyDescription", "Dps-"+ descr.trim());
			map2.put("organizationalUnitId", unit.getId());
			map2.put("academicFieldCode","0");
			
			
			Study study = studyManager.findStudyByNameUnit(map2);
			
			
			
			if (study != null) {
				
				
				
				List<AcademicYear> lstAcadyears = academicYearManager.findAllAcademicYears();
				
				for (AcademicYear ay : lstAcadyears) {
					HashMap<String, Object> studyGradeTypeMap = new HashMap<String, Object>();
					
					
					log.info(study.getStudyDescription() + "|" + ay.getDescription());
					//log.info(ay);
					StudyGradeType stdyGradeType = new StudyGradeType();
					stdyGradeType.setActive("Y");
					stdyGradeType.setCardinalTimeUnitCode("2");
					stdyGradeType.setCurrentAcademicYearId(ay.getId());
					stdyGradeType.setGradeTypeCode(studyTypeCode);
					stdyGradeType.setStudyId(study.getId());
					stdyGradeType.setGradeTypeDescription("0");
					stdyGradeType.setMaxNumberOfCardinalTimeUnits(14);
					stdyGradeType.setMaxNumberOfSubjectsPerCardinalTimeUnit(6);
					stdyGradeType.setNumberOfCardinalTimeUnits(0);
					stdyGradeType.setNumberOfSubjectsPerCardinalTimeUnit(6);
					stdyGradeType.setStudyFormCode("1");
					stdyGradeType.setStudyIntensityCode("F");
					stdyGradeType.setStudyTimeCode("1");
					
					
					studyGradeTypeMap.put("studyId", study.getId());
					studyGradeTypeMap.put("gradeTypeCode", studyTypeCode);
					studyGradeTypeMap.put("currentAcademicYearId", ay.getId());
					studyGradeTypeMap.put("studyFormCode", stdyGradeType.getStudyFormCode());
					studyGradeTypeMap.put("studyTimeCode", stdyGradeType.getStudyTimeCode());
					studyGradeTypeMap.put("studyIntensityCode", stdyGradeType.getStudyIntensityCode());
					
					StudyGradeType studyGradeType = studyManager.findStudyGradeTypeByStudyAndGradeType(studyGradeTypeMap);
					if (studyGradeType == null){
						studyManager.addStudyGradeType(stdyGradeType);
					}
					

				}
				
			}
			

		}
	}
	
	public void createDefaultPrimaryStudy() throws NullPointerException {
		
		JdbcTemplate stageTemplate = new JdbcTemplate(opusDataSource);		
		String sql="Select * from srsdatastage.school";	
		//sString cleanSGT="delete from opuscollege.studygradetype";
		//stageTemplate.execute(cleanSGT);
		
		List<Map<String, Object>> schoolList = stageTemplate.queryForList(sql);
		
		for (Map<String, Object> school : schoolList) {			
			String schCode=(String)school.get("code");
			String descr=(String)school.get("uname");
			String abbrev=(String)school.get("usch");					
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("organizationalUnitDescription", descr.trim());
			map.put("organizationalUnitCode", schCode.trim());
			
			OrganizationalUnit unit;
			unit = unitManager.findOrganizationalUnitByNameAndCode(map);
			
			descr="Dps-"+descr.trim();
			
			descr=descr.replace("'","");			
			log.info("Org_Map: "+map);
			if (unit != null ) {				
				//delete if school exists
				sql="delete from opuscollege.study where studydescription='" + descr + "'";				
				stageTemplate.execute(sql);				
				Study study = new Study();
				study.setOrganizationalUnitId(unit.getId());
				study.setAcademicFieldCode("0");
				study.setStudyDescription(descr);
				study.setActive("Y");				
				log.info("################Study################");
				log.info(school);				
				studyManager.addStudy(study);
			}	
			
		}		
	}
	
	private List<Map<String, Object>> obtainQuotaInfo() {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from srsdatastage.quota";
		List<Map<String, Object>> studentQuotaList = jdbcTemplate.queryForList(query);
		for (Map<String, Object> srsStudentQuota : studentQuotaList) {
			log.info(srsStudentQuota);
		}
		return studentQuotaList;
	}

	
	public void migrateQuota() throws IllegalArgumentException,
	IllegalAccessException {

		List<Map<String, Object>> quotaInfo = obtainQuotaInfo();
		
		for (Map<String, Object> srsStudentQuota : quotaInfo) {
			log.info(srsStudentQuota);
			
			if(srsStudentQuota.get("quotacode")!=null){
				
				Lookup9 lookup = new Lookup9();
		
				lookup.setActive("Y");
				lookup.setTitle((String) srsStudentQuota.get("abbrev"));
				lookup.setLang("en");
				lookup.setDescription(((String) srsStudentQuota.get("title")).trim().toLowerCase(Locale.ENGLISH));
				lookup.setCode(((String) srsStudentQuota.get("quotacode")).trim());
		
				lookUpManager.addLookup(lookup, "gradetype");
			}
			
		
		}

	}

	public void createAcademicYears() {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		int nextAcademicYearId = 0;
		
		for (int i = 2002; i >= 1964; i--) {
			
			AcademicYear ayear = new AcademicYear();
			ayear.setDescription(((Integer) i).toString());
			
			String year = ((Integer) i).toString();
			ayear.setEndDate(java.sql.Date.valueOf(year+ "-12-31"));
			ayear.setStartDate(java.sql.Date.valueOf(year + "-01-01"));
			if (nextAcademicYearId != 0) {
				ayear.setNextAcademicYearId(nextAcademicYearId);
			}	
			log.info("Current Year :"+ayear.getDescription());
			log.info("Next Academic Year:"+ayear.getNextAcademicYearId());
			academicYearManager.addAcademicYear(ayear);
			nextAcademicYearId = ayear.getId();

		}
	}
	
	public void createSubjectStudyGradeType(){
		
		JdbcTemplate subjJdbcTemplate = new JdbcTemplate(opusDataSource);		
		String sql="delete from opuscollege.subjectstudygradetype";		
		subjJdbcTemplate.execute(sql);		
		
		String coursesQuery="";
		coursesQuery="SELECT crs.coursecode,crs.coursedescription,crs.firstoffered,crs.lastoffered,sch.uname,crs.schoolcode  ";
		coursesQuery+="FROM srsdatastage.course crs,srsdatastage.school sch WHERE ";
		coursesQuery+="sch.code=crs.schoolcode ";	
		
		List<Map<String, Object>> srsCourses = subjJdbcTemplate.queryForList(coursesQuery);
		
		for (Map<String, Object> course : srsCourses) {
			
				
			String code = (String) course.get("coursecode");
			String description = (String) course.get("coursedescription");
			String firstoffered = (String) course.get("firstoffered");
			String lastoffered = (String) course.get("lastoffered");			
			String schcode = (String)course.get("schoolcode");
			String orgDescr = (String)course.get("uname");			
			
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("organizationalUnitDescription", orgDescr.trim());
			map.put("organizationalUnitCode", schcode.trim());
			
			OrganizationalUnit unit;
			
			unit = unitManager.findOrganizationalUnitByNameAndCode(map);
			
			Study study1;
			
			String studyDescr="Dps-"+ orgDescr.trim();
			
			HashMap<String, Object> map2 = new HashMap<String, Object>();
			
			map2.put("studyDescription", studyDescr);
			map2.put("organizationalUnitId",unit.getId());
			map2.put("academicFieldCode","0");
			
			study1=studyManager.findStudyByNameUnit(map2);		
			
				if (study1 != null){
					
					List<Map<String, Object>> years = academicYearInfo();
					
					for (Map<String, Object> ay : years ) {
					
					HashMap<String, Object> map4 = new HashMap<String, Object>();
					
					map4.put("studyId",study1.getId());	
					map4.put("preferredLanguage","en");	
					map4.put("currentAcademicYearId",(Integer)ay.get("id"));
					
					List <StudyGradeType> sgts=(List<StudyGradeType>) studyManager.findDistinctStudyGradeTypesForStudy(map4);
					
					
					if (sgts != null){
						log.info("###########################################");
						
						for (StudyGradeType sgt : sgts){ //retrieve gradetypecode
							
							HashMap<String, Object> map5 = new HashMap<String, Object>();
							map5.put("preferredLanguage","en");
							map5.put("studyId",study1.getId());	
							map5.put("gradeTypeCode",sgt.getGradeTypeCode());		
							map5.put("currentAcademicYearId",(Integer)ay.get("id"));
							
							String gradetypecode=sgt.getGradeTypeCode();
							
							List <StudyGradeType> sgts2=(List<StudyGradeType>) studyManager.findAllStudyGradeTypesForStudy(map5);
							
							
							if (sgts2 != null){
							
							log.info("Year " + ay.get("description")+ " sgts size : " + sgts.size() + " study Dec: " + study1.getStudyDescription() + "course: " + description);
							
							Subject subj;										
							
							HashMap<String, Object> map3 = new HashMap<String, Object>();							
							map3.put("subjectDescription",description.trim());
							map3.put("primaryStudyId",study1.getId());
							map3.put("subjectCode",code.trim());
							map3.put("academicYearId",(Integer)ay.get("id"));
							
							//subj=subjectManager.findSubjectByDescriptionStudy(map3);
							subj=subjectManager.findSubjectByDescriptionStudyCode(map3);
							
							
							if(subj!=null){					
								
								for (StudyGradeType sgt2 : sgts2){ //retrieve gradetypecode		
									
									//log.info("######################"+ sgt2.getId() +"###############");
									
									SubjectStudyGradeType ssgt= new SubjectStudyGradeType();
									
									ssgt.setActive("Y");
									ssgt.setStudyId(study1.getId());
									ssgt.setSubjectId(subj.getId());
									ssgt.setStudyDescription(study1.getStudyDescription());
									ssgt.setStudyGradeTypeId(sgt2.getId());
									
									//check if subjectgradetype exists
									
									HashMap<String, Object> map6 = new HashMap<String, Object>();							
									map6.put("subjectId",subj.getId());
									map6.put("studyGradeTypeId",sgt2.getId());																
									
									int count=subjectManager.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(map6);
									//int count2=subjectManager
									
									log.info("###################### count " + count + " ###############");
									
									if(count==0){	
										
										subjectManager.addSubjectStudyGradeType(ssgt);
										log.info("###################### Added Subject Study Grade Type ###############");
									}
									
									
								}								
							}							
						}
						}
					}				
				}					
					
			}
		}
	}
	
	
	private List<Map<String, Object>> obtainStudyGradeTypeInfo() {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select * from opus.quota";
		List<Map<String, Object>> studentQuotaList = jdbcTemplate.queryForList(query);
		for (Map<String, Object> srsStudentQuota : studentQuotaList) {
			log.info(srsStudentQuota);
		}
		return studentQuotaList;
	}
	
	public List<Map<String, Object>> academicYearInfo() {
		
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		//String query = "select * from opuscollege.academicyear where id<2429";
		String query = "select * from opuscollege.academicyear";
		List<Map<String, Object>> academicYearList = jdbcTemplate.queryForList(query);
		
		
		return academicYearList;
	}
		
	public void moveCourses() {			
		
		JdbcTemplate subjJdbcTemplate = new JdbcTemplate(opusDataSource);		
		String sql="delete from opuscollege.subject where subjectdescription not in ('M101','M102','M103','M104','M105','M106','M107','M108') ";		
		subjJdbcTemplate.execute(sql);		
		
		String coursesQuery="";
		coursesQuery="SELECT crs.coursecode,crs.coursedescription,crs.firstoffered,crs.lastoffered,sch.uname,crs.schoolcode  ";
		coursesQuery+="FROM srsdatastage.course crs,srsdatastage.school sch WHERE ";
		coursesQuery+="sch.code=crs.schoolcode ";		
		
		List<Map<String, Object>> srsCourses = subjJdbcTemplate.queryForList(coursesQuery);
		
		//List<AcademicYear> lstAcadyears = academicYearManager.findAllAcademicYears();	
		
		List<Map<String, Object>> years = academicYearInfo();	
				
		
		for (Map<String, Object> course : srsCourses) {
			
				//log.info("################Course################");
				//log.info(course);			
				String code = (String) course.get("coursecode");
				String description = (String) course.get("coursedescription");
				String firstoffered = (String) course.get("firstoffered");
				String lastoffered = (String) course.get("lastoffered");			
				String schcode = (String)course.get("schoolcode");
				String orgDescr = (String)course.get("uname");
				
				
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("organizationalUnitDescription", orgDescr.trim());
				map.put("organizationalUnitCode", schcode.trim());
				
				OrganizationalUnit unit;
				
				unit = unitManager.findOrganizationalUnitByNameAndCode(map);
				
				Study study1;
				
				String studyDescr="Dps-"+ orgDescr.trim();
				//log.info(map);
				
				HashMap<String, Object> map2 = new HashMap<String, Object>();
				map2.put("studyDescription", studyDescr);
				map2.put("organizationalUnitId",unit.getId());
				map2.put("academicFieldCode","0");
				
				study1=studyManager.findStudyByNameUnit(map2);
				//log.info(map2);
				//log.info("The study is: "+study1.getStudyDescription());
				//log.info("Number of year processing: " + years.size());
				
				if (study1 != null){		
					
					//log.info(study1);
					
						for (Map<String, Object> ay : years) {	
							
							//log.info("Number of year processing: " + years.size() + " Study : " + study1.getStudyDescription() + " Year : " + ay.get("description"));
							//log.info("The number of records in academicyear is"+years.size());
							
								String descr = (String)ay.get("description");
								
								int currentYr = Integer.parseInt(descr);
								int lstOffered = Integer.parseInt(lastoffered)/ 10;
								int fstOffered = Integer.parseInt(firstoffered)/10;
								int academicyear = Integer.parseInt(firstoffered)/10;
								
								/*log.info("currentYr "+currentYr);
								log.info("lstOffered "+lstOffered);
								log.info("fstOffered " + fstOffered);
								log.info("academicyear "+academicyear);
								*/
								
								if (academicyear <= currentYr && lstOffered >= currentYr) {// &&									
									Subject newSubject = new Subject();									
									newSubject.setActive("Y");
									newSubject.setCurrentAcademicYearId((Integer)ay.get("id"));
									newSubject.setPrimaryStudyId(study1.getId());
									newSubject.setSubjectCode(code.trim());
									newSubject.setSubjectDescription(description.trim());
									newSubject.setStudyTimeCode("1");
									newSubject.setFreeChoiceOption("N");
									newSubject.setHoursToInvest(40);
									newSubject.setResultType("");
									
									
									
									//try {
										
										Subject subject=new Subject();
										
										HashMap<String, Object> map5 = new HashMap<String, Object>();
										map5.put("subjectCode", code.trim());
										map5.put("subjectDescription",description.trim());
										map5.put("academicYearId",(Integer)ay.get("id"));
										
										subject=subjectManager.findSubjectByCode(map5);	
										
										if(subject==null){
											
											
											
											
											
											
											
										//log.info("Number of year processing: " + years.size() + " Study : " + study1.getStudyDescription() + " Year : " + ay.get("description"));
											subjectManager.addSubject(newSubject);
											//log.info("####################### Added Subject ##################");
											
											//reload the subject
											
											map5 = new HashMap<String, Object>();
											map5.put("subjectCode", newSubject.getSubjectCode());
											map5.put("subjectDescription",newSubject.getSubjectDescription());
											map5.put("academicYearId",newSubject.getCurrentAcademicYearId());
											
											subject=subjectManager.findSubjectByCode(map5);	
											
											log.info("+++Subject Description ++++"+ subject.getSubjectDescription());
											
											
											if(subject!=null){
												//Create subject teacher
												
												
												StaffMember sm = staffMemberManager.findStaffMemberByCode("en", "dsm");
												
												if(sm != null){
													SubjectTeacher subjectTeacher = new SubjectTeacher();
													subjectTeacher.setActive("Y");
													subjectTeacher.setStaffMemberId(sm.getStaffMemberId());
													subjectTeacher.setSubjectId(subject.getId());
													
													subjectManager.addSubjectTeacher(subjectTeacher);
													log.info("####################### Subject Teacher Added ##################");
													
													Examination e = new Examination();
													e.setActive("Y");
													String ecode=StringUtil.createUniqueCode("E", "" + subject.getId());
													e.setExaminationCode(ecode);
													e.setNumberOfAttempts(1);
													e.setExaminationDescription("Final Exam");
													e.setExaminationTypeCode("2");
													e.setSubjectId(subject.getId());
													e.setWeighingFactor(100);
													
													examinationManager.addExamination(e);
													
													HashMap findExaminationMap = new HashMap();
										            findExaminationMap.put("examinationCode", e.getExaminationCode());
										            findExaminationMap.put("examinationDescription", e.getExaminationDescription());
										            findExaminationMap.put("subjectId", e.getSubjectId());
										            findExaminationMap.put("examinationTypeCode", e.getExaminationTypeCode());
										            
													//load the created exam
										            e = examinationManager.findExaminationByParams(findExaminationMap);
										            
										            //create an exam teacher
										            if(e != null){
										            	ExaminationTeacher examinationTeacher = new ExaminationTeacher();
											            examinationTeacher.setStaffMemberId(sm.getStaffMemberId());
											            examinationTeacher.setExaminationId(e.getId());
											        	examinationTeacher.setActive("Y");
											        	
											        	examinationManager.addExaminationTeacher(examinationTeacher);
										            	
										            }
												}
									            
											}
											
										}
										
										
										
										
								//	} catch (Exception e) {
										//log.warn("An Exception has occurred"+ e.getMessage());
										//log.warn(course);			
									//}								
				
								}
								
								
						}
				
	
			}
		}

	}
	
	
	

}