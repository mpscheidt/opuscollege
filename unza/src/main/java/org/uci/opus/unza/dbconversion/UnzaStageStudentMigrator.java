package org.uci.opus.unza.dbconversion;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.uci.opus.college.data.SubjectDaoInterface;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.StudentUtil;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.unza.util.CTUComputer;
import org.uci.opus.unza.util.UnzaUtils;

public class UnzaStageStudentMigrator {
    private static Logger log = Logger.getLogger(UnzaStageStudentMigrator.class);
    private DataSource opusDataSource;
    
   
    @Autowired private StudentManagerInterface opusStudentManager; 
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OrganizationalUnitManagerInterface unitManager;
    @Autowired private UnzaUtils unzaUtils;
    @Autowired private StudentManagerInterface studentManager;
   // @Autowired private CTUComputer ctuComputer;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired 
	private SubjectDaoInterface subjectDao;
    
   
    
    public DataSource getOpusDataSource() {
        return opusDataSource;
    }

    public void setOpusDataSource(DataSource opusDataSource) {
        this.opusDataSource = opusDataSource;
    }
    
    public void migrateStudents(){
        /*Create Student Transfer object*/
        //Student opusStudent = new Student();
    	Student opusStudent = StudentUtil.newStudentWithStudyPlanAndAddress();
        log.info("Heap Size:"+java.lang.Runtime.getRuntime().maxMemory());
        /*Move the clean data from the Staging area*/
        JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
       // String sql="Select * from srsdatastage.student";
        String sql="Select distinct * from srsdatastage.student where studentid='25059726'";
        List<Map<String,Object>> studentList = jdbcTemplate.queryForList(sql);
        
        /*Iterate through each Student Record*/
        int count = 0;
        student:for(Map<String,Object> student: studentList){
        	count++;
        	//log.info("Total Students =>"+studentList.size());
        	//log.info("Record number =>"+count);
            //log.info(student);
            
            /*Transform each record by eliminating nulls*/
            String studentid = (String) student.get("studentid");
            log.info("The Studentid is: "+studentid);
            
            if (studentid == null || studentid.equals(""))
                continue student;// skip the record if it has no student id

            String studentname = (String) student.get("studentname");
            if (studentname == null || studentid.equals(""))
                studentname = "0";
            String address1 = (String) student.get("address1");
            if (address1 == null || address1.equals(""))
                address1 = "0";
            String address2 = (String) student.get("address2");
            if (address2 == null || address2.equals(""))
                address2 = "0";
            String address3 = (String) student.get("address3");
            if (address3 == null || address3.equals(""))
                address3 = "0";
            String maritalcode = (String) student.get("maritalcode");
            if (maritalcode == null || maritalcode.equals(""))
                maritalcode = "0";

            String nationalitycode="0";
            if (student.get("nationalitycode") == null
                    || student.get("nationalitycode").equals("null")
                    || student.get("nationalitycode").equals(""))
                nationalitycode = "1";
            else
                nationalitycode = (String) student.get("nationalitycode");
                        

            String nationalregistrationcard = (String) student.get("nationalregistrationcard");
            if (nationalregistrationcard == null
                    || nationalregistrationcard.equals(""))
                nationalregistrationcard = "0";
            
            String secondaryschoolcode= "0";

            if (student.get("secondaryschoolcode") == null
                    || student.get("secondaryschoolcode").equals(""))
                secondaryschoolcode = "0";
            else
                secondaryschoolcode =(String) student.get("secondaryschoolcode");

            String sex = (String) student.get("sex");
            if (sex == null || sex.equals(""))
                sex = "0";

            String yearofbirth = "1900";
            if (student.get("yearofbirth") == null
                    || student.get("yearofbirth").equals("null")
                    || student.get("yearofbirth").equals(""))
                yearofbirth = "1900";
            else
                yearofbirth = (String)student.get("yearofbirth");
            log.info("The year is: "+yearofbirth + "Map yearofbirth"+student.get("yearofbirth"));
            /*Construct an opus student object based on this data*/
            StudentUtil.setDefaultValues(opusStudent);
            opusStudent.addStudentStudentStatus(new Date(), "1");
            opusStudent.setStudentCode(studentid);
			opusStudent.setPersonCode(studentid);
            opusStudent.setActive("Y");
            opusStudent.setScholarship("Y");
            //Date stdDate =new Date();
            //stdDate.setYear(Integer.parseInt(yearofbirth));
            //stdDate.setMonth(1);//use default month
            java.sql.Date stdDate = null;
            if (yearofbirth.equals("0"))
            	stdDate = java.sql.Date.valueOf("1900-01-01");
            else if (yearofbirth.length() < 4)
            	stdDate = java.sql.Date.valueOf("00"+yearofbirth + "-01-01");
            else
            	stdDate = java.sql.Date.valueOf(yearofbirth + "-01-01");
            log.info("The stdDate " + stdDate);
            
            opusStudent.setBirthdate(stdDate);//use current date for testing
            opusStudent.setContactPersonEmergenciesName("0");
            opusStudent.setContactPersonEmergenciesTelephoneNumber("0");
            opusStudent.setDateOfEnrolment(new Date());
            log.info("Student name" + studentname +"Map Name is :"+student.get("studentname"));
            log.info("First name" + studentname.substring(studentname.indexOf(" ")+1));
            log.info("last name" + studentname.substring(0, studentname.indexOf(" ")));
            opusStudent.setFirstnamesFull(studentname.substring(studentname.indexOf(" ")+1));
            opusStudent.setForeignStudent("0");
            opusStudent.setHousingOnCampus("0");
            opusStudent.setNationalRegistrationNumber("");
            opusStudent.setSurnameFull(studentname.substring(0, studentname.indexOf(" "))); 
            opusStudent.setSubscriptionRequirementsFulfilled("Y");
            opusStudent.setRelativeOfStaffMember("N");
            opusStudent.setEmployeeNumberOfRelative(null);
            
            /*use the LookupManager to load the correct marital status code*/
            Map<String,Object> maritalStatus = new HashMap<String,Object>(); 
            maritalStatus.put("U", new String("2"));
            maritalStatus.put("M", new String("1"));
            maritalStatus.put("S", new String("2"));
            maritalStatus.put("D", new String("4"));
            maritalStatus.put("W", new String("3"));
            if(maritalStatus.get(maritalcode) != null )
            	opusStudent.setCivilStatusCode((String)maritalStatus.get(maritalcode));
            
            /*use the LookupManager to load the correct nationality code */
            opusStudent.setCountryOfBirthCode("0");
            
            /*use the LookupManager to load the correct nationality code */
            opusStudent.setCountryOfOriginCode("0");
            
            /*Use the lookupManager to get the Gender code*/
            Map<String,Object> gender = new HashMap<String,Object>();
            gender.put("M", new String("1"));
            gender.put("F", new String("2"));
            opusStudent.setGenderCode((String)gender.get(sex));
            
            /*Use the LookupManager to get the correct first Language code*/
            opusStudent.setLanguageFirstCode("");
            
            /*Use the LookupManager to get the GradeTypeCode*/
            //getGradeTypeCode(StudentId);
            //What is the student's quota??
            opusStudent.setGradeTypeCode(getGradeTypeCode(studentid)); 
            
            /*use the utility to load the correct nationality code */
            String nationality=getNationality(nationalitycode);
            if(nationality == null || nationality == "0")
            	opusStudent.setNationalityCode("1");//use default
            
            /*use the majorcode to determine the correct PrimaryStudyId*/
            log.info("The Study ID#"+getPrimaryStudyId(studentid));
            opusStudent.setPrimaryStudyId(getPrimaryStudyId(studentid));
            //opusStudent.setPrimaryStudyId(7126);
            
            /*Set the Language*/
            String preferredLanguage = "en_ZM";
            
            /*Set the opusUserRole*/
            OpusUserRole opusUserRole = new OpusUserRole();
            opusUserRole.setUserName(studentid);
            opusUserRole.setRole("student");
            
            /*Set the opusUser*/
			OpusUser opusUser = new OpusUser();
			opusUser.setLang(preferredLanguage);
            
            
            /*Set the current Locale*/
			Locale currentLoc = new Locale("en");
			
			log.info("Total Students =>"+studentList.size());
        	log.info("Record number =>"+count);
            log.info(student);
            log.info("The gradeTypeCode is: "+opusStudent.getGradeTypeCode());
            log.info("The PrimaryStudyId is: "+ opusStudent.getPrimaryStudyId());
            log.info("Student Name:"+opusStudent.getFirstnamesFull());
            /*Commit the student to the opuscollege schema*/
            opusStudentManager.addStudent(opusStudent, opusUserRole, opusUser);
            
            //TODO: Step 2 - Build this Student's 1st Studyplan 
            int studyPlanId = addStudyPlanToStudent(opusStudent);
            //TODO: Step 3 - Build subsequent studyplans
            
            
        }
        
    }
    
    private int addStudyPlanToStudent(Student opusStudent) {
    	//Set up Studyplan for a student
    	String writeWho="Data Migration";
    	MockHttpServletRequest request = new MockHttpServletRequest();
    	MockHttpSession session = new MockHttpSession();
		request.setSession(session);
		RequestAttributes attrs = new ServletRequestAttributes(request);
	    attrs.setAttribute("writeWho", "Data Migration", RequestAttributes.SCOPE_REQUEST);
	    int pid=0;
	    List<Integer > subjectStudyGradeTypeIds;
	    String preferredLanguage = "en_ZM";
	    RequestContextHolder.setRequestAttributes(attrs);
    	
    	//If student has more than one studygradetype create a plan for each
    	String academicHistory = "select distinct a.studentid,c.coursedescription,c.coursecode,qta.duration,qta.abbrev,a.majorcode,a.ayear,a.yearofprogram,qta.schoolcode as schoolcode,uname,category,m.title as mtitle,a.commentcode " +
    			"from srsdatastage.acadyr a " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.quota qta ON m.quotacode = qta.quotacode "+
    			"inner join srsdatastage.credit cr on a.studentid = cr.studentid " +
    			"inner join srsdatastage.course c on cr.course = c.coursecode "+
    			"inner join srsdatastage.school s on s.code = a.schoolcode where a.studentid = ? " +
    			"and cr.ayear = a.ayear " +
    			"order by yearofprogram,a.ayear";
    	JdbcTemplate studentHistory = new JdbcTemplate(opusDataSource);
    	
    	List<Map<String,Object>> acadrecords = studentHistory.queryForList(academicHistory,"25059726");
  
    	StudyPlan studyPlan = new StudyPlan();
    	StudyGradeType previousStudyGradeType = null;
    	//Process the records for one student
    	for(Map<String,Object> record: acadrecords){
    		
    		String major = (String)record.get("majorcode");
    		String studentId = (String)record.get("studentid");
    		String ayear = (String)record.get("ayear");
    		String yearofprogram = (String)record.get("yearofprogram");
    		String subjectcode = (String)record.get("coursecode");
    		String subjectDescription =(String)record.get("coursedescription");
    		String category = (String)record.get("category");
    		String mtitle = (String)record.get("mtitle");
    		String commentCode = (String)record.get("commentcode");
    		String duration = (String)record.get("duration");
    		String abbrev = (String)record.get("abbrev");
    		
    		Integer studyId = unzaUtils.getStudyId(studentId, ayear);
    		String gradeTypeCode = unzaUtils.getGradeTypeCode(studentId, ayear);
    		String studyPlanDescription = unzaUtils.getStudyPlanDescription(studentId, ayear);
    		log.info("test");
    		Integer studyGradeTypeId = unzaUtils.getStudyGradeTypeId(studyId.toString(), gradeTypeCode, ayear, category);
    		//If StudyGradeTypeId is null create it
    		if(studyGradeTypeId == null){
    			createMissingStudyGradeType(studyId, gradeTypeCode, ayear,category,abbrev,duration);
    			studyGradeTypeId = unzaUtils.getStudyGradeTypeId(studyId.toString(), gradeTypeCode, ayear, category);
        		
    		}
    		//Cater for Changes in the Major and Quota
        	int studentNumber = unzaUtils.getStudentId(studentId);
        	StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        	
        	if (studyGradeType != null){
        		studyPlanDescription = studyGradeType.getStudyDescription() 
        				+ " - " + studyGradeType.getGradeTypeDescription();
        		studyPlan.setActive("Y");
                studyPlan.setStudentId(studentNumber);
                studyPlan.setStudyId(studyGradeType.getStudyId());
                studyPlan.setGradeTypeCode(studyGradeType.getGradeTypeCode());
                studyPlan.setStudyPlanDescription(studyPlanDescription);
                studyPlan.setStudyPlanStatusCode("1");
                studyPlan.setApplicationNumber(0);
                //add study plan to the database , so it will be assigned an id
                HashMap map = new HashMap();
                map.put("studentId", studyPlan.getStudentId());
                map.put("studyId", studyPlan.getStudyId());
                map.put("gradeTypeCode", studyPlan.getGradeTypeCode());
                map.put("studyPlanDescription", studyPlan.getStudyPlanDescription());
                //map.put("studyGradeTypeId",studyGradeType.getId() );
               
                String studyIntensityCode="F";
                HashMap studyIntensityCodeMap = new HashMap();
        		studyIntensityCodeMap.put("P", "P");
        		studyIntensityCodeMap.put("F", "F");
        		
        		if(studyIntensityCodeMap.get(category) == null)
        			studyIntensityCode="F";
        		else
        			studyIntensityCode= (String) studyIntensityCodeMap.get(category);
        		
                HashMap categoryMap = new HashMap();
                categoryMap.put("D","" );
                categoryMap.put("F", OpusConstants.STUDY_INTENSITY_FULLTIME);
                
                if( studentManager.findStudyPlanByParams(map) == null){//Study plan does not exist
                	pid = studentManager.addStudyPlanToStudent(studyPlan, writeWho);
                    
                    //load the Just created StudyPlan
                    studyPlan = studentManager.findStudyPlan(pid);
                    
                 // set up an initial studyPlanCTU
                    StudyPlanCardinalTimeUnit studyPlanCTU = new StudyPlanCardinalTimeUnit();
                    studyPlanCTU.setActive("Y");
                    studyPlanCTU.setTuitionWaiver("N");
                    log.info("check category");
                    if ("D".equals(category) || unzaUtils.isMedicineProgramme(gradeTypeCode) || studyGradeType.getCardinalTimeUnitCode().equals("1")){//Distance and Medicine
                    	
                    	studyPlanCTU.setCardinalTimeUnitNumber(Integer.parseInt(yearofprogram));
                    }else{
                    	studyPlanCTU.setCardinalTimeUnitNumber(CTUComputer.computeCTU2(Integer.parseInt(yearofprogram), Integer.parseInt(ayear)));
                    }
                    studyPlanCTU.setStudyGradeTypeId(studyGradeTypeId);
                    studyPlanCTU.setStudyPlanId(studyPlan.getId());
                    studyPlanCTU.setCardinalTimeUnitStatusCode("5");
                    studyPlanCTU.setStudyIntensityCode(studyIntensityCode);//category
                    studentManager.addStudyPlanCardinalTimeUnit(studyPlanCTU, null, request);
                    
                    //load the Unit
                    studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnitByParams(
                            studyPlanCTU.getStudyPlanId(),
                            studyPlanCTU.getStudyGradeTypeId(),
                            studyPlanCTU.getCardinalTimeUnitNumber());
                    
                    //Attach the relevant subjects by loading the ssgt first
                    Map<String, Object> ssmap = new HashMap<String, Object>();
                    ssmap.put("preferredLanguage", "en");
                    ssmap.put("studyGradeTypeId", studyPlanCTU.getStudyGradeTypeId());
                    ssmap.put("cardinalTimeUnitNumber", studyPlanCTU.getCardinalTimeUnitNumber());
                    ssmap.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
                    //verify that ssgt exixts for subject under iteration if not create it
                    
                    createssgt(preferredLanguage, studyGradeTypeId, studyPlanCTU.getCardinalTimeUnitNumber(), OpusConstants.RIGIDITY_ELECTIVE, subjectcode, subjectDescription, ayear, studyId);
                    subjectStudyGradeTypeIds = getssgtids(ssmap);//DomainUtil.getIds(subjectManager.findSubjectStudyGradeTypes(ssmap));//;//
                    if(!subjectStudyGradeTypeIds.isEmpty()){
                    	for (int ssgtId: subjectStudyGradeTypeIds) {
                            StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
                            studyPlanDetail.setActive("Y");
                            studyPlanDetail.setStudyPlanId(studyPlan.getId());
                            SubjectStudyGradeType sbsgt = subjectManager.findSubjectStudyGradeType("en", ssgtId);
                            
                            //TODO: if SubjectStudyGradeType is null create the subject study grade type

                            // the subject may already be included in one of the above added subject blocks, so filter out
                            if (studentManager.existStudyPlanDetail(studyPlan.getId(), sbsgt.getSubjectId())) {
                                log.info("Subject with id = " + sbsgt.getSubjectId() + " ignored, because it is included in one of the assigned subject blocks in the same study plan with id = " + studyPlan.getId());
                            } else {
                                studyPlanDetail.setSubjectId(sbsgt.getSubjectId());
                                studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
                                studyPlanDetail.setStudyGradeTypeId(studyPlanCTU.getStudyGradeTypeId());
                                studentManager.addStudyPlanDetail(studyPlanDetail, request);

                                
                            }
                        }
                    	
                    }else{
                    	//create the subjectstudygradetypes
                    	createssgt(preferredLanguage,studyPlanCTU.getStudyGradeTypeId(),studyPlanCTU.getCardinalTimeUnitNumber(),
                    			OpusConstants.RIGIDITY_ELECTIVE,subjectcode,subjectDescription,ayear,studyId);
                    }
                    
                    //store the studygradetype
                    previousStudyGradeType = studyGradeType;
                    
                }else{
                	//studyplan exists so just update details
                	//Assumption is that the studygradetype will be for the previously processed semester
                	StudyPlan studyplan = studentManager.findStudyPlanByParams(map);
                	
                	StudyPlanCardinalTimeUnit studyPlanCTU = new StudyPlanCardinalTimeUnit();
                    studyPlanCTU.setActive("Y");
                    studyPlanCTU.setTuitionWaiver("N");
                    if ("D".equals(category) || unzaUtils.isMedicineProgramme(gradeTypeCode) || previousStudyGradeType.getCardinalTimeUnitCode().equals("1")){//Distance and Medicine or programme is yearly
                    	studyPlanCTU.setCardinalTimeUnitNumber(Integer.parseInt(yearofprogram));
                    }else{
                    	studyPlanCTU.setCardinalTimeUnitNumber(CTUComputer.computeCTU2(Integer.parseInt(yearofprogram), Integer.parseInt(ayear)));
                    }
                    studyPlanCTU.setStudyGradeTypeId(studyGradeTypeId);
                    studyPlanCTU.setStudyPlanId(studyPlan.getId());
                    studyPlanCTU.setCardinalTimeUnitStatusCode("5");
                    studyPlanCTU.setStudyIntensityCode(studyIntensityCode);//category
                    studentManager.addStudyPlanCardinalTimeUnit(studyPlanCTU, null, request);
                    
                  //load the Unit
                    studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnitByParams(
                            studyPlanCTU.getStudyPlanId(),
                            studyPlanCTU.getStudyGradeTypeId(),
                            studyPlanCTU.getCardinalTimeUnitNumber());
                    
                    //Attach the relevant subjects by loading the ssgt first
                    Map<String, Object> ssmap = new HashMap<String, Object>();
                    ssmap.put("preferredLanguage", "en");
                    ssmap.put("studyGradeTypeId", studyPlanCTU.getStudyGradeTypeId());
                    ssmap.put("cardinalTimeUnitNumber", studyPlanCTU.getCardinalTimeUnitNumber());
                    ssmap.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
                    
                    createssgt(preferredLanguage, studyPlanCTU.getStudyGradeTypeId(), studyPlanCTU.getCardinalTimeUnitNumber(), OpusConstants.RIGIDITY_ELECTIVE, subjectcode, subjectDescription, ayear, studyId);
                    subjectStudyGradeTypeIds =DomainUtil.getIds(subjectManager.findSubjectStudyGradeTypes(ssmap));// getssgtids(ssmap);//
                    if(!subjectStudyGradeTypeIds.isEmpty()){
                    	for (int ssgtId: subjectStudyGradeTypeIds) {
                            StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
                            studyPlanDetail.setActive("Y");
                            studyPlanDetail.setStudyPlanId(studyPlan.getId());
                            SubjectStudyGradeType sbsgt = subjectManager.findSubjectStudyGradeType("en", ssgtId);
                            
                            //TODO: if SubjectStudyGradeType is null create the subject study grade type

                            // the subject may already be included in one of the above added subject blocks, so filter out
                            if (studentManager.existStudyPlanDetail(studyPlan.getId(), sbsgt.getSubjectId())) {
                                log.info("Subject with id = " + sbsgt.getSubjectId() + " ignored, because it is included in one of the assigned subject blocks in the same study plan with id = " + studyPlan.getId());
                            } else {
                                studyPlanDetail.setSubjectId(sbsgt.getSubjectId());
                                studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
                                studyPlanDetail.setStudyGradeTypeId(studyPlanCTU.getStudyGradeTypeId());
                                studentManager.addStudyPlanDetail(studyPlanDetail, request);

                                
                            }
                        }
                    }else{
                    	//create the subjectstudygradetypes
                    	createssgt(preferredLanguage,studyPlanCTU.getStudyGradeTypeId(),studyPlanCTU.getCardinalTimeUnitNumber(),
                    			OpusConstants.RIGIDITY_ELECTIVE,subjectcode,subjectDescription,ayear,studyId);
                    	subjectStudyGradeTypeIds =getssgtids(ssmap);// DomainUtil.getIds(subjectManager.findSubjectStudyGradeTypes(ssmap));//
                    	for (int ssgtId: subjectStudyGradeTypeIds) {
                            StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
                            studyPlanDetail.setActive("Y");
                            studyPlanDetail.setStudyPlanId(studyPlan.getId());
                            SubjectStudyGradeType sbsgt = subjectManager.findSubjectStudyGradeType(preferredLanguage, ssgtId);
                            
                            //TODO: if SubjectStudyGradeType is null create the subject study grade type

                            // the subject may already be included in one of the above added subject blocks, so filter out
                            if (studentManager.existStudyPlanDetail(studyPlan.getId(), sbsgt.getSubjectId())) {
                                log.info("Subject with id = " + sbsgt.getSubjectId() + " ignored, because it is included in one of the assigned subject blocks in the same study plan with id = " + studyPlan.getId());
                            } else {
                                studyPlanDetail.setSubjectId(sbsgt.getSubjectId());
                                studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
                                studyPlanDetail.setStudyGradeTypeId(studyPlanCTU.getStudyGradeTypeId());
                                studentManager.addStudyPlanDetail(studyPlanDetail, request);

                                
                            }
                        }
                    }
                    
                    
                	studentManager.updateStudyPlan(studyPlan, writeWho);//verify that this does what is expected
                }
                
                
        	}else{
        		//Create this studygradetype using the studyid, gradetypecode,ayear and category
        		//unzaUtils.getStudyGradeTypeId(studyId.toString(), gradeTypeCode, ayear, category);
        	}
    	}
    	
    	
		return pid;
	}

	private List<Integer> getssgtids(Map<String, Object> ssmap) {
		
		
        String ssgtsql ="select distinct id from opuscollege.subjectstudygradetype " +
        		"where studygradetypeid=? " +
        		"and cardinaltimeunitnumber=? " +
        		"and rigiditytypecode=?";
        JdbcTemplate ssgtTemplate = new JdbcTemplate(opusDataSource);
        List<Map<String,Object>> ssgt=ssgtTemplate.queryForList(ssgtsql,(Integer)ssmap.get("studyGradeTypeId"),
        		(Integer)ssmap.get("cardinalTimeUnitNumber"),(String)ssmap.get("rigidityTypeCode"));
        //List<Map<String,Object>> ssgt=ssgtTemplate.queryForList(ssgtsql,(Integer)ssmap.get("studyGradeTypeId"));
        if(ssgt.isEmpty()){
        	ssgt=ssgtTemplate.queryForList(ssgtsql,(Integer)ssmap.get("studyGradeTypeId"),
            		new Integer("0"),(String)ssmap.get("rigidityTypeCode"));
        }
        List<Integer> ssgtList = new ArrayList<Integer>();
        for(Map<String,Object> m: ssgt){
        	ssgtList.add((Integer)m.get("id"));
        	
        }
		return ssgtList;
	}

	//Helper method to create missing ssgt
    private void createssgt(String preferredLanguage, int studyGradeTypeId,
			int cardinalTimeUnitNumber, String rigidityElective, String subjectcode,
			String subjectDescription,String ayear,int studyId) {
    	String unamesql ="select distinct uname from srsdatastage.school s " +
    			"inner join srsdatastage.course c on  s.code = c.schoolcode where c.coursecode = ?";
    	JdbcTemplate unameTemplate = new JdbcTemplate(opusDataSource);
    	List<Map<String,Object>> unameList = unameTemplate.queryForList(unamesql,subjectcode);
    	String uname = (String)unameList.get(0).get("uname");
    	
    	Subject subj = new Subject();
    	HashMap<String, Object> subjectMap = new HashMap<String, Object>();							
    	subjectMap.put("subjectCode",subjectcode.trim());
		
    	subjectMap.put("primaryStudyId",unzaUtils.getPrimaryStudy("Dps-"+uname.trim()));
    	subjectMap.put("subjectDescription",subjectDescription.trim());
    	subjectMap.put("academicYearId",unzaUtils.getCurrentAcademicYearId(ayear));
    	subj = subjectManager.findSubjectByDescriptionStudyCode(subjectMap);
    	
    	if(subj != null){
    		Study study = studyManager.findStudy(studyId);
    		SubjectStudyGradeType subjectStudyGradeType = new SubjectStudyGradeType();
    		//create the ssgt
    		subjectStudyGradeType.setSubjectId(subj.getId());
			subjectStudyGradeType.setActive("Y");
		 	
			subjectStudyGradeType.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);//Any
		 	subjectStudyGradeType.setStudyDescription(study.getStudyDescription());//use the mjrcode
		 	subjectStudyGradeType.setStudyGradeTypeId(studyGradeTypeId);
		 	subjectStudyGradeType.setRigidityTypeCode(rigidityElective);
		 	subjectStudyGradeType.setImportanceTypeCode("1");
		 	//check that it doesnt exist
		 	HashMap hMap = new HashMap();
		 	hMap.put("subjectId", subjectStudyGradeType.getSubjectId());
		 	hMap.put("studyGradeTypeId", studyGradeTypeId);
		 	hMap.put("subjectCode", subj.getSubjectCode());
		 	hMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
		 	hMap.put("rigidityTypeCode", rigidityElective);
		 	hMap.put("importanceTypeCode", "1");
		 	
//		 	String findSsgt ="select id from subjectstudygradetype " +
//		 			"where subjectid=? " +
//		 			"and studygradetypeid=? " +
//		 			"and subjectcode ? " +
//		 			"and cardinaltimeunitnumber= ? " +
//		 			"rigiditytypecode = ?";
		 	int existsSsgt = 0;
		 	//existsSsgt= subjectDao.findSubjectStudyGradeTypeByParams(hMap).getId();
		 	existsSsgt= subjectDao.findSubjectStudyGradeTypeIdBySubjectAndStudyGradeType(hMap);
		 	
		 	if (existsSsgt == 0)
		 		subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
		 	
    		
    	}else{
    		//create the subject and make a recursive call.
    		Subject subject = new Subject();
    		subject.setCurrentAcademicYearId((Integer)subjectMap.get("academicYearId"));
    		subject.setActive("Y");
    		subject.setPrimaryStudyId((Integer)subjectMap.get("primaryStudyId"));
			subject.setSubjectCode(subjectMap.get("subjectCode").toString().trim());
			subject.setSubjectDescription(subjectMap.get("subjectDescription").toString().trim());
			subject.setStudyTimeCode("1");
			subject.setFreeChoiceOption("N");
			subject.setHoursToInvest(40);
			subject.setResultType("");
			subjectManager.addSubject(subject);
			createssgt(preferredLanguage, studyGradeTypeId,
					cardinalTimeUnitNumber, rigidityElective, subjectcode,
					subjectDescription,ayear,studyId);
    	}
	}

	//Helper method to create missing StudyGradeType
	private void createMissingStudyGradeType(Integer studyId,
			String gradeTypeCode, String ayear, String category, String abbrev, String duration) {
		
		//For Acurate results use these maps to process studyIntensityCode, studyTimeCode,StudyFormCode
		//TODO:Refactor this into a Reuseable module
		String studyIntensityCode="F";//Full-time
		String studyFormCode="1";//Regular
		String studyTimeCode="1";//Daytime
        HashMap studyIntensityCodeMap = new HashMap();
		studyIntensityCodeMap.put("P", "P");//Part-time
		studyIntensityCodeMap.put("F", "F");//Full-time
		
		
        HashMap studyFormCodeMap = new HashMap();
        studyFormCodeMap.put("F", "1");//Regular
        studyFormCodeMap.put("R", "2");//Parallel
        studyFormCodeMap.put("D", "3");//Distance
        
        HashMap studyTimeCodeMap = new HashMap();
        studyTimeCodeMap.put("E", "2");//Evening
       
		
		if(studyIntensityCodeMap.get(category) != null)
			studyIntensityCode=(String)studyIntensityCodeMap.get(category);
		
		
		if(studyFormCodeMap.get(category) != null)
			studyFormCode = (String)studyFormCodeMap.get(category);
		
		if(studyTimeCodeMap.get(category) != null)
			studyTimeCode = (String)studyTimeCodeMap.get(category);
		

		StudyGradeType stdyGradeType = new StudyGradeType();
		stdyGradeType.setActive("Y");
		//Check if Distance Programme or Medicine Programme
		if ("D".equals(category) || unzaUtils.isMedicineProgramme(gradeTypeCode)){
			stdyGradeType.setCardinalTimeUnitCode("1");
		}else{
			stdyGradeType.setCardinalTimeUnitCode("2");
		}
		
		stdyGradeType.setCurrentAcademicYearId(unzaUtils.getCurrentAcademicYearId(ayear));
		stdyGradeType.setGradeTypeCode(gradeTypeCode);
		stdyGradeType.setStudyId(studyId);
		stdyGradeType.setGradeTypeDescription(abbrev);
		stdyGradeType.setMaxNumberOfCardinalTimeUnits(14);
		stdyGradeType.setMaxNumberOfSubjectsPerCardinalTimeUnit(8);
		stdyGradeType.setMaxNumberOfFailedSubjectsPerCardinalTimeUnit(2);
		if(duration == null)
			duration = "10";//set to a default
		//check also if programme is distance or medicine
		stdyGradeType.setNumberOfCardinalTimeUnits(Integer.parseInt(duration)*Integer.parseInt(stdyGradeType.getCardinalTimeUnitCode()));
		stdyGradeType.setNumberOfSubjectsPerCardinalTimeUnit(6);
		stdyGradeType.setStudyFormCode(studyFormCode);
		stdyGradeType.setStudyTimeCode(studyTimeCode);
		stdyGradeType.setStudyIntensityCode(studyIntensityCode);
		
		studyManager.addStudyGradeType(stdyGradeType);
		
	}

	

	private Integer getPrimaryStudyId(String studentId){
    	//Integer primaryStudyId=1563; //use id:1563 Dps-NATURAL SCIENCES for testing
		Integer primaryStudyId;
		JdbcTemplate defaultTemplate = new JdbcTemplate(opusDataSource);
		String defaultStudy = "select id from opuscollege.study where studydescription ='Dps-NATURAL SCIENCES'";
		primaryStudyId = defaultTemplate.queryForInt(defaultStudy);
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select distinct a.majorcode,a.ayear,a.yearofprogram,schoolcode,uname,category,m.title as mtitle,a.commentcode " +
    			"from srsdatastage.acadyr a " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.school s on s.code = a.schoolcode where a.studentid = ? " +
    			"order by yearofprogram,a.ayear";
    	
    	List<Map<String,Object> > majors =  jdbcTemplate.queryForList(sql,studentId);
    	if (majors.isEmpty())
    		return primaryStudyId;
    	
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
		// ensure that Study already exist
		Study study = studyManager.findStudyByNameUnit(map2);
		if (study == null)
			return primaryStudyId;
			
		
    	return study.getId();
    	//return ;
    	
    	
    }
    
    private String getGradeTypeCode(String studentId){
    	String gradeTypeCode="25"; //Use a GradeTypeCode of:25 BACHELOR OF SCIENCE: NON QUOTA STUDIES 
    	
    	//Use the student id to pick the student's first major i.e NSNQS
    	JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
    	String sql ="select a.quotacode,schoolcode,uname,m.title as mtitle from srsdatastage.acadyr a " +
    			"inner join srsdatastage.major m on a.majorcode=m.majorcode " +
    			"inner join srsdatastage.school s on s.code = a.schoolcode where a.studentid = ?";
    	//String gt=null;
    	
    	List<Map<String,Object> > quota =  jdbcTemplate.queryForList(sql,studentId);
    	if (quota.isEmpty())
    		return gradeTypeCode;
    	else
    		return (String)quota.get(0).get("quotacode");
    }
    
    private String getNationality(String code){
    	/*Move the clean data from the Staging area*/
        JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
        JdbcTemplate countryJdbcTemplate = new JdbcTemplate(opusDataSource);
        
        
        String nationsql="select * from srsdatastage.nation where code = ?";
        log.info("The nationality code passsed is: "+ code);
        List<Map<String,Object>> nation= jdbcTemplate.queryForList(nationsql,code);
        String nationality="0";
        if(nation.get(0) != null)
        	nationality = (String)nation.get(0).get("nationality");
        
        String sql="select * from opuscollege.country where description like ?";
        String country ="American"; 
        //country.toUpperCase();
      
        if(!nationality.equals("0"))
        	country=nationality.toUpperCase();
        	
        log.info("The country is: "+country);
        log.info("The nationality is: "+nationality.length());
        log.info("The length of the country is:"+ country.length());
        List<Map<String,Object>> nationList = countryJdbcTemplate.queryForList(sql,"%"+country.substring(0, 6)+"%");
        //List<Map<String,Object>> nationList = countryJdbcTemplate.queryForList(sql,"%ZAMBIA%");
        
        log.info(nationList.size());
        
        for(Map<String,Object> nationObject: nationList){
        	log.info("running ...");
        	log.info(nationObject);
        	//log.info(nationList.get(0));
        	//return (String)nationList.get(0).get("code");
        	return (String)nationObject.get("code");
        }
        return null;
        
    }
    	
    	
    

}
