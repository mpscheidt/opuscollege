package org.uci.opus.cbu.dbconversion;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.service.StudyManagerInterface;

public class SecondarySchoolSubjectMigrator {
	private static Logger log = LoggerFactory.getLogger(SecondarySchoolSubjectMigrator.class);
	@Autowired private StudyManagerInterface studyManager;
	@Autowired private DBUtil dbUtil;
	@Autowired private DataSource dataSource;
		
	private String[][] sbSubjectGroup={
			{"001","101"},
			{"102","424","321","304","311","308","202","201","211"},
			{"205","207","204","420","307","301","002","320","418"},
			{"312","421","314"}
		};
	private int[][] sbMinMax={{2,2},{1,2},{1,2},{0,1}};
	
	private String[][] sbeSubjectGroup={
			{"001","101"},
			{"211","203","202","201"},
			{"102","207","002","314","315","423","418","311","320","421"},
			{"424","304"}
		};
	private int[][] sbeMinMax={{2,2},{1,2},{1,2},{0,1}};
	
	private String[][] snrSubjectGroup={
			{"001","101"},
			{"201","202","203","311"},
			{"314","421","102","308","304","321","320","418","002","423"},
			{"425","205"},
			{"207","205"}
		};
	private int[][] snrMinMax={{2,2},{1,2},{1,2},{0,1},{0,1}};
	
	private String[][] seSubjectGroup={
			{"001","101"},
			{"211","203","202","201"},
			{"102","311","308","002","423","420","304","321","418","205"},
			{"314","421"}
		};
	private int[][] seMinMax={{2,2},{1,2},{1,2},{0,1}};
	
	private String[][] smnsSubjectGroup={
			{"001","101"},
			{"207","202"},
			{"102","311","308","002","423","420","304","321","320","418","205"},
			{"201","211","203"},
			{"314","421"}
		};
	private int[][] smnsMinMax={{2,2},{1,2},{1,2},{0,1},{0,1}};
	
	public void convertSecondarySchoolSubjects(){
		dbUtil.truncateTable("secondaryschoolsubjectgroup");
		dbUtil.truncateTable("groupedsecondaryschoolsubject");
		dbUtil.truncateTable("gradedsecondaryschoolsubject");
		
		addSecondarySchoolSubjectGroup();
		addGroupedSecondarySchoolSubjects(sbSubjectGroup,sbMinMax,"SB");
		addGroupedSecondarySchoolSubjects(sbeSubjectGroup,sbeMinMax,"SBE");
		addGroupedSecondarySchoolSubjects(seSubjectGroup,seMinMax,"SE");
		addGroupedSecondarySchoolSubjects(seSubjectGroup,seMinMax,"SM");
		addGroupedSecondarySchoolSubjects(snrSubjectGroup,snrMinMax,"SNR");
		addGroupedSecondarySchoolSubjects(smnsSubjectGroup,smnsMinMax,"SMNS");
		addGroupedSecondarySchoolSubjects(smnsSubjectGroup,smnsMinMax,"SOM");
		addGroupedSecondarySchoolSubjects(smnsSubjectGroup,smnsMinMax,"DDEOL");
	}
	
	
	private void addSecondarySchoolSubjectGroup() {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		List<? extends StudyGradeType> studyGradeTypes=studyManager.findAllStudyGradeTypes();
		Integer[][] minMax={{2,2},{1,2},{1,2},{0,1},{0,1}};
		for(StudyGradeType studyGradeType:studyGradeTypes){
			for(int i=0; i<minMax.length;i++){
				List<Map<String, Object>> result = temp
						.queryForList("SELECT id FROM opuscollege.secondaryschoolsubjectgroup WHERE studygradetypeid='"+studyGradeType.getId()+"' AND minimumnumbertograde='"+minMax[i][0]+"' AND maximumnumbertograde='"+minMax[i][1]+"' and groupnumber='"+(i+1)+"'");
				if(result.toString().equals("[]")){
					String sql="INSERT INTO opuscollege.secondaryschoolsubjectgroup (groupnumber,minimumnumbertograde,maximumnumbertograde,studygradetypeid,active)" +
						"VALUES('"+(i+1)+"','"+minMax[i][0]+"','"+minMax[i][1]+"','"+studyGradeType.getId()+"','Y')";
					temp.execute(sql);
				}
			}
		}
	}
	
	private void addGroupedSecondarySchoolSubjects(String[][] subjectGroup,int[][] minMax, String schoolCode) {
		JdbcTemplate temp = new JdbcTemplate(dataSource);
		for(int x=0; x<minMax.length;x++){
			List<Map<String, Object>> result = temp.queryForList("SELECT id FROM opuscollege.secondaryschoolsubjectgroup WHERE studygradetypeid in (select id from opuscollege.studygradetype where studyid in (select id from opuscollege.study where organizationalunitid in (select id from opuscollege.organizationalunit where branchid=(select id from opuscollege.branch where branchcode='"+schoolCode+"' LIMIT 1)))) AND minimumnumbertograde='"+minMax[x][0]+"' AND maximumnumbertograde='"+minMax[x][1]+"' AND groupnumber='"+(x+1)+"'");
			
			if(!result.toString().equals("[]")){
				for(Map<String, Object> map: result){
					String secondarySchoolSubjectGroupId=String.valueOf(map.get("id"));
					for(int y=0;y<subjectGroup[x].length;y++){
						String subjectCode=subjectGroup[x][y];
						List<Map<String, Object>> result2 = temp.queryForList("SELECT id FROM opuscollege.groupedsecondaryschoolsubject WHERE secondaryschoolsubjectgroupid='"+secondarySchoolSubjectGroupId+"' AND secondaryschoolsubjectid=(SELECT id FROM opuscollege.secondaryschoolsubject WHERE code='"+subjectCode+"' LIMIT 1)");
						if(result2.toString().equals("[]")){
							List<Map<String, Object>> result3 = temp.queryForList("SELECT id FROM opuscollege.secondaryschoolsubject WHERE code='"+subjectCode+"'");
							if(!result3.toString().equals("[]")){
								String secondarySchoolSubjectId=String.valueOf(result3.get(0).get("id"));
							
								String sql="INSERT INTO opuscollege.groupedsecondaryschoolsubject (secondaryschoolsubjectid,secondaryschoolsubjectgroupid,minimumgradepoint,maximumgradepoint,active)" +
								"VALUES('"+secondarySchoolSubjectId+"','"+secondarySchoolSubjectGroupId+"','1','6','Y')";
								temp.execute(sql);
								if(log.isInfoEnabled())
									log.info(sql);
							}
						}
					}
				}
			}
		}
	}
}
