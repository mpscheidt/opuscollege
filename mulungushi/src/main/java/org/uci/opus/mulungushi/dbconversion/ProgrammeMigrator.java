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
package org.uci.opus.mulungushi.dbconversion;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.CardinalTimeUnitStudyGradeType;
import org.uci.opus.college.domain.EndGrade;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.EndGradeManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.factory.EndGradeFactory;
import org.uci.opus.mulungushi.data.ProgrammeDao;
import org.uci.opus.mulungushi.domain.Programme;

public class ProgrammeMigrator {

	private static Logger log = LoggerFactory.getLogger(ProgrammeMigrator.class);
	@Autowired private DataSource dataSource;
	@Autowired private AcademicYearManagerInterface academicYearManager;
	@Autowired private BranchManagerInterface branchManager;
	@Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private ProgrammeDao programmeDao;
	@Autowired private LookupManagerInterface lookupManager;
	@Autowired private EndGradeManagerInterface endGradeManager;
	@Autowired private EndGradeFactory endGradeFactory;
	
	private AcademicYear year1415;
	
	private Map<String, Programme> codeToProgramMap = new HashMap<>();

	private List<AcademicYear> academicYears = new ArrayList<AcademicYear>();
	private List<Lookup9> gradeTypes = new ArrayList<>();
	
	private IdToStudyMap idToStudyMap;

	private Map<String, Study> programNoToStudyMap = new HashMap<>();
	private Map<String, Map<Integer, StudyGradeType>> programNoToAcadYearIdToSGTMap = new HashMap<>();
//	private Map<Integer, Map<Integer, StudyGradeType>> studyIdToAcademicYearIdToStudyGradeTypeMap = new HashMap<>();
	
	private List<? extends EndGrade> endgradesForOneAcademicYear;
	
	static private Map<String, Integer> nrOfSemestersMap = new HashMap<String, Integer>();

	static {
		nrOfSemestersMap.put("B", 8);
		nrOfSemestersMap.put("BSc", 8);
		nrOfSemestersMap.put("D", 6);
		nrOfSemestersMap.put("M", 4);
	}

	/**
	 * This method is used to convert Programmmes data from STURECO Database to OpusCollege Database
	 * @throws SQLException
	 */
	public void convertProgrammes() throws SQLException {

    	log.info("Starting conversion of programmes");

//		initCodeToProgramMap();

		rememberEngradesForOneAcademicYear();

    	log.info("Going to delete current program related data from database");
		dbUtil.truncateTable("gradetype");
		dbUtil.truncateTable("cardinaltimeunitstudygradetype");
		dbUtil.truncateTable("studygradetype");
		dbUtil.truncateTable("endgrade");
		dbUtil.truncateTable("academicyear");
		dbUtil.truncateTable("study");

		setupGradeTypes();
		setupAcademicYears();
		setupEndGrades();

		Map<String, OrganizationalUnit> schoolDescritionToDepartmentMap = getBranchDescriptionToOrgUnitMap();

		for (Programme program : programmeDao.getProgrammes()) {
			
			String programmeName = program.getProgrammeName();
			// Avoid duplicate with almost identical names
			if (programmeName.endsWith("Human Resources Management")) {
			    programmeName = programmeName.substring(0, programmeName.length() - "Human Resources Management".length()) +  "Human Resource Management";
			    program.setProgrammeName(programmeName);
			}

            OrganizationalUnit department = schoolDescritionToDepartmentMap.get(program.getSchool());
			if (department == null) {
				System.out.println("Warn: could not find school " + program.getSchool() + ", ignored program: " + program.getProgrammeNumber() + " - " + programmeName);
			} else {

			    String studyDescription = getProgramName(programmeName);
			    int organizationalUnitId = department.getId();
			    Study study = findOrCreateStudy(studyDescription, organizationalUnitId);

				String gradeTypeCode = getGradeTypeCode(programmeName);
				
				for (AcademicYear year : getAcademicYears()) {
	
					StudyGradeType sgt = new StudyGradeType();
					sgt.setCurrentAcademicYearId(year.getId());
					sgt.setStudyId(study.getId());
					sgt.setStudyGradeTypeCode(program.getProgrammeNumber());
					sgt.setGradeTypeCode(gradeTypeCode);
					sgt.setCardinalTimeUnitCode("2");	// 2 = Semester
					sgt.setNumberOfCardinalTimeUnits(nrOfSemestersMap.get(gradeTypeCode));
					sgt.setActive("Y");
					sgt.setContactId(0);
					sgt.setMaxNumberOfCardinalTimeUnits(0);
					sgt.setNumberOfSubjectsPerCardinalTimeUnit(5);
					sgt.setMaxNumberOfSubjectsPerCardinalTimeUnit(0);
					sgt.setStudyTimeCode("Evening".equalsIgnoreCase(program.getModeOfStudy()) ? "2" : "1");
					sgt.setStudyFormCode("Distance".equalsIgnoreCase(program.getModeOfStudy()) ? "3" : "1");
					sgt.setMaxNumberOfFailedSubjectsPerCardinalTimeUnit(0);
					sgt.setStudyIntensityCode("");
					sgt.setMaxNumberOfStudents(0);
					studyManager.addStudyGradeType(sgt);

					programNoToStudyMap.put(program.getProgrammeNumber(), study);

					// remember for courseMigrator
//					Map<Integer, StudyGradeType> yearToSGTMap = studyIdToAcademicYearIdToStudyGradeTypeMap.get(study.getId());
//					if (yearToSGTMap == null) {
//						yearToSGTMap = new HashMap<>();
//						studyIdToAcademicYearIdToStudyGradeTypeMap.put(study.getId(), yearToSGTMap);
//					}
//					yearToSGTMap.put(year.getId(), sgt);
				}
			}
		}
		
	}

    private Study findOrCreateStudy(String studyDescription, int organizationalUnitId) {


        // check if the combination of studyDescription / organizationalUnitId exists
        Map<String, Object> findStudyMap = new HashMap<String, Object>();
        findStudyMap.put("studyDescription", studyDescription);
        findStudyMap.put("organizationalUnitId", organizationalUnitId);
        Study study = studyManager.findStudyByNameUnit(findStudyMap);
        if (study == null) {
            study = new Study();
            study.setOrganizationalUnitId(organizationalUnitId);
            study.setStudyDescription(studyDescription);
            study.setActive("Y");
            study.setAcademicFieldCode("0");
            studyManager.addStudy(study);
        }
        return study;
    }
	
	private String getProgramName(String programNameWithDegree) {
		int firstSpaceIdx = programNameWithDegree.indexOf(" ");
		int secondSpaceIdx = programNameWithDegree.indexOf(" ", firstSpaceIdx + 1);
		return programNameWithDegree.substring(secondSpaceIdx + 1);
	}
	
	private String getGradeTypeCode(String programNameWithDegree) {
		return programNameWithDegree.substring(0, 1);
	}
	
	private Map<String, OrganizationalUnit> getBranchDescriptionToOrgUnitMap() {
		Map<String, OrganizationalUnit> map = new HashMap<>();

		HashMap<String, Object> findBranchMap = new HashMap<String, Object>();
		findBranchMap.put("institutionId", 0);
		findBranchMap.put("institutionTypeCode", "3");
		for (Branch branch : branchManager.findBranches(findBranchMap)) {
			OrganizationalUnit department = findOrgUnit(branch);
			map.put(branch.getBranchDescription(), department);
		}

		return map;
	}

	private OrganizationalUnit findOrgUnit(Branch branch) {
		Map<String, Object> findMap = new HashMap<String, Object>();
		findMap.put("branchId", branch.getId());
		return organizationalUnitManager.findOrganizationalUnits(findMap).get(0);
	}

	private void setupGradeTypes() {
		insertGradeType("B", "Bachelor", "B.");
		insertGradeType("BSc", "Bachelor of Science", "BSc.");
		insertGradeType("M", "Master", "M.");
		insertGradeType("D", "Diploma", "Dip.");
	}

	private void insertGradeType(String code, String desription, String title) {
		Lookup9 gradeType = new Lookup9();
		gradeType.setActive("Y");
		gradeType.setCode(code);
		gradeType.setDescription(desription);
		gradeType.setTitle(title);
		gradeType.setLang("en");
		lookupManager.addLookup(gradeType, "gradetype");
	}

	private void setupAcademicYears() {
		SimpleDateFormat df = (SimpleDateFormat) DateFormat.getDateInstance();
	    df.applyPattern("yyyy-MM-dd");

		try {
//			AcademicYear year = insertAcademicYear("2015/2016", df.parse("2015-08-16"), df.parse("2016-06-30"), null);
//			academicYears.add(year);
//			year = insertAcademicYear("2014/2015", df.parse("2014-08-16"), df.parse("2015-06-30"), year);
		    AcademicYear year = year1415 = insertAcademicYear("2014/2015", df.parse("2014-08-16"), df.parse("2015-06-30"), null);
			academicYears.add(year);
			year = insertAcademicYear("2013/2014", df.parse("2013-08-16"), df.parse("2014-06-30"), year);
			academicYears.add(year);
			year = insertAcademicYear("2012/2013", df.parse("2012-08-16"), df.parse("2013-06-30"), year);
			academicYears.add(year);
			year = insertAcademicYear("2011/2012", df.parse("2011-08-16"), df.parse("2012-06-30"), year);
			academicYears.add(year);
			year = insertAcademicYear("2010/2011", df.parse("2010-08-16"), df.parse("2011-06-30"), year);
			academicYears.add(year);
			year = insertAcademicYear("2009/2010", df.parse("2009-08-16"), df.parse("2010-06-30"), year);
			academicYears.add(year);
			year = insertAcademicYear("2008/2009", df.parse("2008-08-16"), df.parse("2009-06-30"), year);
			academicYears.add(year);
		} catch (ParseException e) {
			log.error("error", e);
		}
	}
	
	private AcademicYear insertAcademicYear(String code, Date startDate, Date endDate, AcademicYear nextAcademicYear) {
		AcademicYear year = new AcademicYear();
		year.setDescription(code);
		year.setStartDate(startDate);
		year.setEndDate(endDate);
		if (nextAcademicYear != null) {
			year.setNextAcademicYearId(nextAcademicYear.getId());
		}
		academicYearManager.addAcademicYear(year);
		return year;
	}

	public List<AcademicYear> getAcademicYears() {

		if (academicYears.isEmpty()) {
			academicYears = academicYearManager.findAllAcademicYearsSorted();
		}

		return academicYears;
	}
	
	public AcademicYear getAcademicYear(String academicYearString) {
		for (AcademicYear year : getAcademicYears()) {
			if (year.getDescription().startsWith(academicYearString)) {
				return year;
			}
		}
		return null;
	}

//	public Map<Integer, Map<Integer, StudyGradeType>> getStudyIdToStudyGradeTypeMap() {
//		return studyIdToAcademicYearIdToStudyGradeTypeMap;
//	}

	public IdToStudyMap getIdToStudyMap() {
		if (idToStudyMap == null) {
			idToStudyMap = new IdToStudyMap(studyManager.findAllStudies());
		}
		return idToStudyMap;
	}
	
	public Study getStudy(int studyId) {
		return getIdToStudyMap().get(studyId);
	}

	public Map<String, Study> getProgramNoToStudyMap() {
		
		// go through studyGradeTypes of one academic year
		if (programNoToStudyMap.isEmpty()) {
			Map<String, Object> map = new HashMap<>();
			map.put("currentAcademicYearId", getAcademicYears().get(0).getId());
			map.put("preferredLanguage", "en");
			for (StudyGradeType sgt : studyManager.findStudyGradeTypes(map)) {
				Study study = getIdToStudyMap().get(sgt.getStudyId());
				programNoToStudyMap.put(sgt.getStudyGradeTypeCode(), study);
			}
		}
		
		return programNoToStudyMap;
	}
	
	public Map<String, Map<Integer, StudyGradeType>> getProgramNoToAcadYearIdToSGTMap() {

		// go through all studyGradeTypes
		if (programNoToAcadYearIdToSGTMap.isEmpty()) {
			for (StudyGradeType sgt : studyManager.findAllStudyGradeTypes()) {
				Map<Integer, StudyGradeType> acadYearIdToSGTMap = programNoToAcadYearIdToSGTMap.get(sgt.getStudyGradeTypeCode());
				if (acadYearIdToSGTMap == null) {
					acadYearIdToSGTMap = new HashMap<>();
					programNoToAcadYearIdToSGTMap.put(sgt.getStudyGradeTypeCode(), acadYearIdToSGTMap);
				}
				acadYearIdToSGTMap.put(sgt.getCurrentAcademicYearId(), sgt);
			}
		}
		
		return programNoToAcadYearIdToSGTMap;
	}

	private void initCodeToProgramMap() {
		for (Programme program : programmeDao.getProgrammes()) {
			codeToProgramMap.put(program.getProgrammeNumber(), program);
		}
	}

	private Map<String, Programme> getCodeToProgramMap() {
		if (codeToProgramMap.isEmpty()) {
			initCodeToProgramMap();
		}
		return codeToProgramMap;
	}

	public Programme getProgram(String programNoWithSpace) {
		Programme program = null;

		String generalProgramNo = getGeneralProgramNo(programNoWithSpace);
		if (generalProgramNo != null) {
			program = getCodeToProgramMap().get(generalProgramNo);
		}

		return program;
	}

	/**
     * Example: "BABM I" -> "BABM"
	 * Example: "DBMA IID" -> "DBMA D"
	 * @param programNoWithSpace
	 * @param spaceIdx
	 * @return
	 */
    private String getGeneralProgramNo(String programNoWithSpace) {
        int spaceIdx = programNoWithSpace.indexOf(" ");
        if (spaceIdx == -1) {
            log.warn("invalid programNo (empty or no space): " + programNoWithSpace);
            return null;
        } else {
            String generalProgramNo = programNoWithSpace.substring(0, spaceIdx);
            if (programNoWithSpace.endsWith("D") || programNoWithSpace.endsWith("d")) {
                generalProgramNo += " D";
            }
            return generalProgramNo;
        }
    }

	/**
	 * convert the year number information inside the programNo to a number value.
	 * @param programNoWithSpace e.g. "BABM II"
	 * @return
	 */
	public Integer getProgramYearNumber(String programNoWithSpace) {
		Integer yearNumber = null;
		
		int spaceIdx = programNoWithSpace.indexOf(" ");
		if (spaceIdx == -1) {
			log.warn("invalid programNo (empty or no space): " + programNoWithSpace);
		} else {
			String yearString = programNoWithSpace.substring(spaceIdx + 1).trim().toUpperCase();
			int len = yearString.length();
			
			if (len >= 2 && "IV".equals(yearString.substring(0, 2))) {
				yearNumber = 4;
			} else if (len >= 3 && "III".equals(yearString.substring(0, 3))) {
				yearNumber = 3;
			} else if (len >= 2 && "II".equals(yearString.substring(0, 2))) {
				yearNumber = 2;
			} else if (len >= 1 && "I".equals(yearString.substring(0, 1))) {
				yearNumber = 1;
			}
			
			if (yearNumber == null) {
				log.warn("Cannot determine year number from programNo = " + programNoWithSpace);
			}
		}

		return yearNumber;
	}

	public Study getStudy(String programNo) {
		Study study = null;
		Programme generalProgram = getProgram(programNo);
		if (generalProgram == null) {
			log.warn("No general program for programNo = " + programNo);
		} else {
			study = getProgramNoToStudyMap().get(generalProgram.getProgrammeNumber());
		}
		return study;
	}
	
	
	public StudyGradeType getStudyGradeType(String programNo, int academiceYearId) {
		StudyGradeType sgt = null;
		Programme generalProgram = getProgram(programNo);
		if (generalProgram == null) {
			log.warn("No general program for programNo = " + programNo);
		} else {
			Map<Integer, StudyGradeType> yearIdToSGTMap = getProgramNoToAcadYearIdToSGTMap().get(generalProgram.getProgrammeNumber());
			if (yearIdToSGTMap == null) {
				log.warn("No program found in Opus for programNo = " + generalProgram.getProgrammeNumber());
			} else {
				sgt = yearIdToSGTMap.get(academiceYearId);
			}
		}
		return sgt;
	}

	/**
	 * Remember all the end grades for one academic year in order to recreate them 
	 * for the newly created academic years.
	 */
	private void rememberEngradesForOneAcademicYear() {
		AcademicYear year = academicYearManager.findAllAcademicYears().get(0);
		
		Map<String, Object> map = new HashMap<>();
		map.put("academicYearId", year.getId());
		endgradesForOneAcademicYear = endGradeManager.findEndGrades(map);
		if (endgradesForOneAcademicYear.isEmpty()) {
			log.error("No endgrades available in end grade table. Restore database that has endgrade records!"); 
		}
	}
	
	private void setupEndGrades() {
		for (AcademicYear year : academicYears) {
			List<EndGrade> endGrades = new ArrayList<>();
			
			for (EndGrade origEndGrade : endgradesForOneAcademicYear) {
				EndGrade newEndGrade = endGradeFactory.newEndGrade(origEndGrade, year.getId());
				newEndGrade.setWriteWho("migration");
				endGrades.add(newEndGrade);
			}

			endGradeManager.addEndGradeSet(endGrades);
		}
	}

	private List<Lookup9> getGradeTypes() {
		if (gradeTypes.isEmpty()) {
			gradeTypes = lookupManager.findAllRows("en", "gradetype");
		}
		return gradeTypes;
	}
	
	public Lookup9 getGradeType(String gradeTypeCode) {
		for (Lookup9 gradeType : getGradeTypes()) {
			if (gradeTypeCode.equalsIgnoreCase(gradeType.getCode())) {
				return gradeType;
			}
		}
		return null;
	}

    public AcademicYear getYear1415() {
        if (year1415 == null) {
            Map<String, Object> map = new HashMap<>();
            map.put("searchValue", "2014/2015");
            year1415 = academicYearManager.findAcademicYears(map).get(0);
        }
        return year1415;
    }

    /**
     * For all study grade types add the cardinalTimeUnitStudyGradeTypes
     */
    public void addCardinalTimeUnitStudyGradeTypes() {
        log.info("Going to delete existing cardinaltimeunitstudygradetype records");
        dbUtil.truncateTable("cardinaltimeunitstudygradetype");

        log.info("creating cardinalTimeUnitStudyGradeTypes");
        for (StudyGradeType sgt : studyManager.findAllStudyGradeTypes()) {
            List <CardinalTimeUnitStudyGradeType> cardinalTimeUnitStudyGradeTypes = new ArrayList<>();
            for (int ctunr = 1; ctunr <= sgt.getNumberOfCardinalTimeUnits(); ctunr++) {
                CardinalTimeUnitStudyGradeType ctusgt = new CardinalTimeUnitStudyGradeType();
                ctusgt.setStudyGradeTypeId(sgt.getId());
                ctusgt.setCardinalTimeUnitNumber(ctunr);
                ctusgt.setNumberOfElectiveSubjectBlocks(0);
                ctusgt.setNumberOfElectiveSubjects(0);
                cardinalTimeUnitStudyGradeTypes.add(ctusgt);
            }
            sgt.setCardinalTimeUnitStudyGradeTypes(cardinalTimeUnitStudyGradeTypes);
            studyManager.updateStudyGradeType(sgt);
        }
    }
}
