/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College cbu module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/
package org.uci.opus.cbu.dbconversion;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.data.CourseDao;
import org.uci.opus.cbu.data.LecturerDao;
import org.uci.opus.cbu.domain.Course;
import org.uci.opus.cbu.domain.Lecturer;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.SubjectTeacher;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;


public class StaffMigrator {

    private static Logger log = LoggerFactory.getLogger(StaffMigrator.class);
 
    @Autowired private DataSource dataSource;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private LecturerDao lecturerDao;
    @Autowired private CourseDao courseDao;
    @Autowired DBUtil dbUtil;
    
    public void convertStaff() throws SQLException {
        //dbUtil.truncateTable("staffmember");
    	//dbUtil.truncateTable("subjectteacher");
    	
    	//Retrieve the data for lecturers
    	List<Lecturer> lecturers=lecturerDao.getLecturers();
        int count=0;
       
        //iterate through a collection of a List object
        for (Lecturer lecturer: lecturers) {
        	if(log.isInfoEnabled())
        		log.info(lecturer.toString());
            
            StaffMember staffMember=new StaffMember();
            staffMember.setFirstnamesFull(lecturer.getFirstName());
            staffMember.setSurnameFull(lecturer.getLastName());
            staffMember.setStaffMemberCode(lecturer.getId());
            staffMember.setStaffTypeCode("1"); //1 for Academic Staff, 2 for Non Academic Staff
            staffMember.setPersonCode(lecturer.getId());
            staffMember.setActive("Y");
            
            if(lecturer.getGender()!=null) staffMember.setGenderCode(getGenderCode(lecturer.getGender()));
            if(lecturer.getTitle()!=null) staffMember.setCivilTitleCode(getCiviltitleCode(lecturer.getTitle()));
            
            //since date of birth is not stored for lecturers, set default value to 01-01-1900
            staffMember.setBirthdate(Date.valueOf("1900-01-01"));
            staffMember.setPrimaryUnitOfAppointmentId(getOrganisationUnitID(lecturer.getDepartment().getCode()));
            String opusUserLanguage = "en_ZM";
            String preferredLanguage = "en";
            
            if(log.isInfoEnabled())
            	log.info(staffMember.toString());
            
            OpusUserRole opusUserRole = new OpusUserRole();
            OpusUser opusUser = new OpusUser();
            opusUser.setUserName(lecturer.getUsername()!=null?lecturer.getUsername():"CBUUser"+(count++));
            opusUser.setLang(opusUserLanguage);
            Locale currentLocale=new Locale("en");
            opusUserRole.setUserName(opusUser.getUserName());
            opusUser.setPreferredOrganizationalUnitId(getOrganisationUnitID(lecturer.getDepartment().getCode()));
           
            StaffMember staffMember2=staffMemberManager.findStaffMemberByCode(preferredLanguage, staffMember.getStaffMemberCode());
            //add a staffmember if only the staffmember does not exist
            if(staffMember2==null){
            	staffMemberManager.addStaffMember(staffMember, opusUserRole, opusUser);
            }else{
            	staffMember.setStaffMemberId(staffMember2.getStaffMemberId());
            	staffMemberManager.updateStaffMemberAndOpusUser(staffMember, opusUser, null);
            }
            assignSubject(staffMember.getStaffMemberCode());
            
            if(log.isInfoEnabled())
            	log.info(lecturer.toString());
        }
    }
    
    private String getCiviltitleCode(String title) {
		
    	JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstCivilTitle = jdbc.queryForList("SELECT code FROM opuscollege.civiltitle WHERE description = '"+title.toLowerCase().trim()+"'");
		if(lstCivilTitle.toString().equals("[]"))
			return null;else return lstCivilTitle.get(0).get("Code").toString();
	}
   
    private String getGenderCode(String gender) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstCivilTitle = jdbc.queryForList("SELECT code FROM opuscollege.gender WHERE description = '"+gender.toLowerCase().trim()+"'");
		if(lstCivilTitle.toString().equals("[]"))
			return null;else return lstCivilTitle.get(0).get("Code").toString();
	}
   private int getSubjectID(String coursecode,String courseName,int academicyear) {
		
    	JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstSubject = jdbc.queryForList("SELECT id FROM opuscollege.subject WHERE subjectcode = '"+coursecode+"' AND subjectdescription='"+courseName+"' AND currentacademicyearid=(SELECT id FROM opuscollege.academicyear WHERE description='"+academicyear+"')");
		if(lstSubject.toString().equals("[]"))
			
		return 0;else return (Integer) (lstSubject.get(0).get("id"));
	}

   private boolean checkIfExistSubjectID(int subjectId,int staffMemberId) {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		List<Map<String, Object>> lstSubject = jdbc.queryForList("SELECT id FROM opuscollege.subjectteacher WHERE subjectid = '"+subjectId+"' AND staffmemberid='"+staffMemberId+"'");
		return lstSubject.toString().equals("[]")?false:true;
	}
    
     private void assignSubject(String lecturerId){
    	
    	 List<Course> courses=courseDao.getLecturerCourses(lecturerId);
    	  
    	 if (courses!=null && courses.size()>0){
        	for(Course course:courses){
        		
        		for(int academicYear=2010;academicYear<=2012; academicYear++){
	        		int subjectId=getSubjectID(course.getCode(),course.getName(),academicYear);
	        		int staffMemberId=getStaffID(lecturerId);
	        		
	        		SubjectTeacher subjectTeacher=new SubjectTeacher();
	        		subjectTeacher.setStaffMemberId(staffMemberId);
	        		subjectTeacher.setSubjectId(subjectId);
	        		subjectTeacher.setActive("Y");
	        		if(subjectId!=0) {
	        			//assign a course to the lecturer if only the course is not assigned to him/her
	        		    if(!checkIfExistSubjectID(subjectId, staffMemberId)) {
	        		        subjectManager.addSubjectTeacher(subjectTeacher);
	        		    }else{
	        		    	subjectManager.updateSubjectTeacher(subjectTeacher);
	        		    }
	        		}
        		}
        	}
        }
    }
    
    private int getOrganisationUnitID(String departmentCode){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		
		List<Map<String,Object>> ouList =opusTemplate.queryForList("SELECT id FROM opuscollege.organizationalunit WHERE organizationalunitcode='"+departmentCode+"'");
		if(!ouList.toString().equals("[]"))
			return Integer.valueOf(ouList.get(0).get("id").toString());
		
		return 0;
    }
    
    private int getStaffID(String lecturerid){
		JdbcTemplate opusTemplate=new JdbcTemplate(dataSource);
		
		List<Map<String,Object>> staffmemberlist =opusTemplate.queryForList("SELECT staffmemberid FROM opuscollege.staffmember WHERE staffmembercode='"+lecturerid+"'");
		if(!staffmemberlist.toString().equals("[]"))
			return Integer.valueOf(staffmemberlist.get(0).get("staffmemberid").toString());
		
		return 0;
    }
 }
