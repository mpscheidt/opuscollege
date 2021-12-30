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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unza.dbconversion;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;

/**
 * @author william
 * 
 */
public class UnzaCurriculumMigrator {

	private static Logger log = Logger.getLogger(UnzaCurriculumMigrator.class);
	private DataSource opusDataSource;
	private DataSource srsDataSource;
	@Autowired
	private StudyManagerInterface studyManager;
	@Autowired
	private LookupManagerInterface lookUpManager;
	@Autowired
	private OrganizationalUnitManagerInterface unitManager;
	@Autowired
	private AcademicYearManagerInterface academicYearManager;
	@Autowired
	private SubjectManagerInterface subjectManager;

	public DataSource getSrsDataSource() {
		return srsDataSource;
	}

	public void setSrsDataSource(DataSource srsDataSource) {
		this.srsDataSource = srsDataSource;
	}

	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

	public void convertCurriculum() throws SQLException {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.study";
		opusJdbcTemplate.execute(query);
		JdbcTemplate jdbcTemplate = new JdbcTemplate(srsDataSource);

		String sql = "select m.code as major_code,m.title as major_title,qta.code as quota_code,"
				+ " qta.duration,qta.schcode,qta.title, sch.uname as descr from major m,quota qta, school sch where m.qtacode=qta.code AND sch.code=qta.schcode";

		List<Map<String, Object>> studyList = jdbcTemplate.queryForList(sql);
		createAcademicYears();
		for (Map<String, Object> srsStudy : studyList) {
			log.info(srsStudy);

			int studyCode = (Integer) srsStudy.get("major_code");
			String studyTypeCode = ((Integer) srsStudy.get("quota_code"))
					.toString();
			String studyDescr = (String) srsStudy.get("major_title");
			// Integer studyDuration = (short)srsStudy.get("duration");
			String schCode = ((Short) srsStudy.get("schcode")).toString();
			String descr = (String) srsStudy.get("descr");

			// convet to semesters

			// studyDuration=2*studyDuration;

			// add study {major in srs}

			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("organizationalUnitDescription", descr);
			map.put("organizationalUnitCode", schCode);
			OrganizationalUnit unit;
			unit = unitManager.findOrganizationalUnitByNameAndCode(map);

			HashMap<String, Object> map2 = new HashMap<String, Object>();
			map2.put("studyDescription", studyDescr);
			map2.put("organizationalUnitId", unit.getId());
			map2.put("academicFieldCode", unit.getAcademicFieldCode());
			// ensure that Study doesn't already exist
			Study study = studyManager.findStudyByNameUnit(map2);
			if (study == null) {
				study = new Study();
				study.setId(studyCode);
				study.setOrganizationalUnitId(unit.getId());
				study.setAcademicFieldCode("0");
				study.setStudyDescription(studyDescr);
				study.setActive("Y");

				studyManager.addStudy(study);
			}

			// add study form from srs

			// add study time from srs

			// add more ....

			// add studygradetype {quota in srs}

			List<AcademicYear> lstAcadyears = academicYearManager
					.findAllAcademicYears();
			for (AcademicYear ay : lstAcadyears) {
				log.info(ay);
				// lookUpManager.findLookupTableByName("gradetype").;
				StudyGradeType stdyGradeType = new StudyGradeType();
				stdyGradeType.setActive("Y");
				stdyGradeType.setCardinalTimeUnitCode("2");
				stdyGradeType.setCurrentAcademicYearId(ay.getId());
				stdyGradeType.setGradeTypeCode("0");
				stdyGradeType.setStudyId(study.getId());
				stdyGradeType.setGradeTypeDescription("0");
				stdyGradeType.setMaxNumberOfCardinalTimeUnits(14);
				stdyGradeType.setMaxNumberOfSubjectsPerCardinalTimeUnit(6);
				stdyGradeType.setNumberOfCardinalTimeUnits(0);
				stdyGradeType.setNumberOfSubjectsPerCardinalTimeUnit(6);
				// stdyGradeType.setStudyDescription(studyDescription);
				// stdyGradeType.setStudyFormCode(studyFormCode);
				studyManager.addStudyGradeType(stdyGradeType);

			}

		}

	}

	private List<Map<String, Object>> obtainQuotaInfo() {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(srsDataSource);
		String query = "select * from srsystem.quota";// +"AND schcode="+schcode;
		List<Map<String, Object>> studentQuotaList = jdbcTemplate
				.queryForList(query);
		for (Map<String, Object> srsStudentQuota : studentQuotaList) {
			log.info(srsStudentQuota);
		}
		return studentQuotaList;
	}

	public void migrateQuota() throws IllegalArgumentException,
			IllegalAccessException {
		//
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.gradetype";
		opusJdbcTemplate.execute(query);
		List<Map<String, Object>> quotaInfo = obtainQuotaInfo();

		for (Map<String, Object> srsStudentQuota : quotaInfo) {
			log.info(srsStudentQuota);
			Lookup9 lookup = new Lookup9();

			lookup.setActive("Y");
			// JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
			// String query = "delete from opuscollege.gradetype";
			opusJdbcTemplate.execute(query);
			lookup.setTitle((String) srsStudentQuota.get("abbrev"));
			lookup.setLang("en");
			lookup.setDescription((String) srsStudentQuota.get("title"));
			lookup.setCode(((Integer) srsStudentQuota.get("code")).toString());

			lookUpManager.addLookup(lookup, "gradetype");

		}

	}

	public void createAcademicYears() {
		JdbcTemplate opusJdbcTemplate = new JdbcTemplate(opusDataSource);
		//String query = "delete from opuscollege.academicyear";
		//opusJdbcTemplate.execute(query);

		int nextAcademicYearId = 0;
		for (int i = 2012; i >= 1963; i--) {
			AcademicYear ayear = new AcademicYear();
			ayear.setDescription(((Integer) i).toString());
			if (nextAcademicYearId != 0) {
				ayear.setNextAcademicYearId(nextAcademicYearId);
			}
			academicYearManager.addAcademicYear(ayear);
			nextAcademicYearId = ayear.getId();

		}
	}

	public void migrateSubjects() {
		JdbcTemplate subjJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.subject";
		subjJdbcTemplate.execute(query);

		JdbcTemplate srsJdbcTemplate = new JdbcTemplate(srsDataSource);
		// String coursesQuery =
		// "select * from credit crdt, course crse where crdt.course = crse.code";
		String coursesQuery = "select * from course";
		List<Map<String, Object>> srsCourses = srsJdbcTemplate
				.queryForList(coursesQuery);
		List<AcademicYear> lstAcadyears = academicYearManager
				.findAllAcademicYears();

		// Return a list of subjects
		for (Map<String, Object> course : srsCourses) {
			// log.info(course);
			// String studentId = (String) course.get("studid");
			// String ayear = (String) course.get("ayear");
			String code = (String) course.get("code");
			String description = (String) course.get("description");
			// String sch = (String) course.get("schcode");
			Short firstoffered = (Short) course.get("firstofferred");
			Short lastoffered = (Short) course.get("lastofferred");

			for (AcademicYear ay : lstAcadyears) {
				String descr = ay.getDescription();
				int currentYr = Integer.parseInt(descr);
				int lstOffered = lastoffered/10;
				int academicyear = firstoffered/10;
				
				//log.info(firstoffered/10);
				if (academicyear <= currentYr && lstOffered >= currentYr ) {//&& lstOffered >= currentYr
					

					Subject newSubject = new Subject();
					newSubject.setActive("Y");
					newSubject.setCurrentAcademicYearId(ay.getId());
					// studyManager.findStudy(mjrcode);
					// newSubject.setPrimaryStudyId(studyManager.findStudy(mjrcode));
					newSubject.setPrimaryStudyId(0);
					// newSubject.setStudyTimeCode(studyTimeCode);
					newSubject.setSubjectCode(code);
					newSubject.setSubjectDescription(description);
					try{
					subjectManager.addSubject(newSubject);
					}catch(Exception e){
						log.warn(e.getMessage());
						log.warn(course);
						
					}

				}

				// int academicyear =
				// Integer.parseInt(Short.toString(firstoffered).substring(0,
				// 3));
				// String currentYear = ay.getDescription();
				// int currentAyear = Integer.parseInt(currentYear);
				// if(academicyear <= currentAyear) {

			}

		}

	}
	public void migrateStudentCredit() {
		JdbcTemplate crdtJdbcTemplate = new JdbcTemplate(opusDataSource);
		String query = "delete from opuscollege.subjectresult";
		crdtJdbcTemplate.execute(query);

		JdbcTemplate srsJdbcTemplate = new JdbcTemplate(srsDataSource);
		String crdtQuery = "select * from credit";
		List<Map<String, Object>> studentCreditList = srsJdbcTemplate
				.queryForList(crdtQuery);
		List<AcademicYear> lstAcadyears = academicYearManager
		.findAllAcademicYears();
		
		for(Map<String,Object> stdCredit:studentCreditList) {
			log.info(stdCredit);
			for(AcademicYear A:lstAcadyears) {
				//check if credit record is in current AcademicYear
				
			}
			
		}
		//Create subject Result
		SubjectResult newSubjectResult = new SubjectResult();
	}
}
