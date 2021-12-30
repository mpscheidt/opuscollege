/**
 * 
 */
package org.uci.opus.unza.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
//import org.uci.opus.unza.dbconversion.UnzaStageStudentMigrator;

/**
 * @author Katuta G.C Kaunda
 *
 */
public class UnzaUtils {
	private static Logger log = Logger.getLogger(UnzaUtils.class);
	 @Autowired private OrganizationalUnitManagerInterface unitManager;
	 @Autowired private StudyManagerInterface studyManager;
	 @Autowired private SubjectManagerInterface subjectManager;
	 @Autowired private StudentManagerInterface studentManager;
	// @Autowired private UnzaDao unzaDao;
	 
	private DataSource opusDataSource;
	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}
	
	public Integer getStudyId(String studentId,String ayear){
    	//Integer primaryStudyId=1311; //use id:1311 Dps-NATURAL SCIENCES for testing
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select distinct a.majorcode,schoolcode,uname,m.title as mtitle from srsdatastage.acadyr a " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.school s on s.code = a.schoolcode " +
    			"where a.studentid = ? AND a.ayear = ?";
    	
    	List<Map<String,Object> > majors =  jdbcTemplate.queryForList(sql,studentId,ayear);
    	
    	
    	String mjrcode =(String)majors.get(0).get("majorcode");
    	String title =(String)majors.get(0).get("mtitle");
    	String schoolcode =(String)majors.get(0).get("schoolcode");
    	String descr =(String)majors.get(0).get("uname");
    	
    	HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("organizationalUnitDescription", descr.trim());
		map.put("organizationalUnitCode", schoolcode);
		log.info("The org unit: "+map);
		OrganizationalUnit unit;
		unit = unitManager.findOrganizationalUnitByNameAndCode(map);

		HashMap<String, Object> map2 = new HashMap<String, Object>();
		
		map2.put("studyDescription", title.trim());			
		map2.put("organizationalUnitId", unit.getId());
		map2.put("academicFieldCode","0");
		log.info("Study Map"+map2);
		// ensure that Study doesn't already exist
		Study study = studyManager.findStudyByNameUnit(map2);
		
			
		if (study != null){
			return study.getId();
		}else{
			return null;
		}
    	
    	//return ;
    	
    	
    }
	public String getGradeTypeCode(String studentId, String ayear){
    	//String gradeTypeCode="25"; //Use a GradeTypeCode of:25 BACHELOR OF SCIENCE: NON QUOTA STUDIES 
    	
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select distinct a.quotacode,yearofprogram,a.ayear,schoolcode,uname,m.title as mtitle from srsdatastage.acadyr a  " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.school s on s.code = a.schoolcode " +
    			"where a.studentid = ? AND a.ayear = ? order by yearofprogram,a.ayear";
    	//String gt=null;
    	
    	List<Map<String,Object> > quota =  jdbcTemplate.queryForList(sql,studentId,ayear);
    	
    		return (String)quota.get(0).get("quotacode");
    }
	public List<Map<String,Object> > getGradeTypeCode2(String studentId, String ayear){
    	//String gradeTypeCode="25"; //Use a GradeTypeCode of:25 BACHELOR OF SCIENCE: NON QUOTA STUDIES 
    	
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select a.quotacode,schoolcode,uname,m.title as mtitle from srsdatastage.acadyr a " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.school s on s.code = a.schoolcode where a.studentid = ? AND a.ayear = ?";
    	//String gt=null;
    	
    	List<Map<String,Object> > quota =  jdbcTemplate.queryForList(sql,studentId,ayear);
    	
    		return quota;
    }
	public String getStudyPlanDescription(String studentId, String ayear){
    	//String gradeTypeCode="25"; //Use a GradeTypeCode of:25 BACHELOR OF SCIENCE: NON QUOTA STUDIES 
    	
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select a.quotacode,q.title as qtitle from srsdatastage.acadyr a " +
    			"inner join srsdatastage.quota q on a.quotacode=q.quotacode " +
    			"where a.studentid = ? AND a.ayear = ?";
    	//String gt=null;
    	
    	List<Map<String,Object> > quota =  jdbcTemplate.queryForList(sql,studentId,ayear);
    	
    		return (String)quota.get(0).get("qtitle");
    }
	public Integer getCurrentAcademicYearId(String ayear){
		Integer academicYear = new Integer(ayear);
		Integer param = academicYear/10;
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "select id from opuscollege.academicyear where description = ?";
		List<Map<String, Object>> academicYearList = jdbcTemplate.queryForList(query,param.toString());
		
		for (Map<String,Object> a:academicYearList ){
			log.info("The AcademicYearId:"+a);
			return (Integer)a.get("id");
		}
		log.info(null);
		return null;
	}
	public Integer getStudyGradeTypeId(String studyId,String gradeTypeCode,String ayear, String category){
		StudyGradeType sgt;
		String studyFormCode="1";
		String studyIntensityCode="F";
		String studyTimeCode="1";
		HashMap studyFormCodeMap = new HashMap();
		studyFormCodeMap.put("D","3" );
		studyFormCodeMap.put("F", "1");
		studyFormCodeMap.put("R", "2");
		
		HashMap studyIntensityCodeMap = new HashMap();
		studyIntensityCodeMap.put("P", "P");
		studyIntensityCodeMap.put("F", "F");
		
		HashMap studyTimeCodeMap = new HashMap();
		studyTimeCodeMap.put("E", "2");
		
		
		if(studyFormCodeMap.get(category) != null)
			studyFormCode= (String) studyFormCodeMap.get(category);
		
		if(studyIntensityCodeMap.get(category) != null)
			studyIntensityCode= (String) studyIntensityCodeMap.get(category);
        if(studyTimeCodeMap.get(category)!= null)
        	studyTimeCode= (String) studyTimeCodeMap.get(category);
        
		HashMap<String, Object> map5 = new HashMap<String, Object>();
		map5.put("studyId",Integer.parseInt(studyId));
		map5.put("gradeTypeCode",gradeTypeCode);//use quota code		
		map5.put("currentAcademicYearId",getCurrentAcademicYearId(ayear));//TODO:private method that accepts ayear and returns currentAcademicYearId
		//map5.put("studyFormCode","1");
		map5.put("studyFormCode", studyFormCode);
		map5.put("studyTimeCode",studyTimeCode);
		map5.put("studyIntensityCode",studyIntensityCode);
		
		log.info("^^^^^^^StudyGradeType Parameters^^^^^^^^");
		log.info("Map5:"+map5);
		log.info("Academic Year"+ ayear);
		log.info("");
		sgt = studyManager.findStudyGradeTypeByStudyAndGradeType(map5);
		if (sgt == null)
			return null;
		return sgt.getId();
	}
	public Integer getSubjectId(String subjectCode, String ayear,String subjectDescription){
		
		Subject subj;
		HashMap<String, Object> map3 = new HashMap<String, Object>();							
		map3.put("subjectDescription",subjectDescription.trim());
		/*For the study Id use the default Study for the school to which student belongs*/
		//map3.put("primaryStudyId",studyId);
		map3.put("subjectCode",subjectCode.trim());
		map3.put("academicYearId",getCurrentAcademicYearId(ayear));
		
		log.info("^^^^^^^Subject Parameters^^^^^^^^");
		log.info("Map3:"+map3);
		subj = subjectManager.findSubjectByDescriptionStudyCode2(map3);
		//TODO:Solve problem of course changing its description i.e NS 214
		if (subj != null)
			return subj.getId();
		else 
			return 0;
		//return subj.getId();
		
	}
	public Integer getStudentId(String studentCode){
		//log.info("The Student code is "+studentCode);
		Student student = studentManager.findStudentByCode(studentCode);
		if(student != null)
			return student.getStudentId();
		else{
			return null;
		}
	}
	public Integer getPrimaryStudy(String descr) {
		String query="select id from opuscollege.study where studyDescription =?";
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		return new Integer(jdbcTemplate.queryForInt(query,descr));
	}

	public boolean isMedicineProgramme(String gradeTypeCode) {
		// TODO Based on the gradeTypeCode determines whether programme is medicine programme
		String sql="select schoolcode from srsdatastage.quota where quotacode = ? AND schoolcode = '5'";
		JdbcTemplate template = new JdbcTemplate(opusDataSource);
		List<Map<String,Object>> result = template.queryForList(sql,gradeTypeCode);
		
		return !result.isEmpty();
	}

}
