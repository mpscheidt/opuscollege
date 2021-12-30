package org.uci.opus.unza.dbconversion;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
//import org.uci.opus.accommodation.service.AccommodationManager;
//import org.uci.opus.accommodation.service.HostelManager;
//import org.uci.opus.accommodation.domain.*;



public class UnzaStageAccommodationMigrator {
	private static Logger log = Logger.getLogger(UnzaStageAccommodationMigrator.class);
	//@Autowired private HostelManager hostelManager;
	//@Autowired private AccommodationManager accommodationManager;
	private DataSource opusDataSource;
	
	public DataSource getOpusDataSource() {
		return opusDataSource;
	}

	public void setOpusDataSource(DataSource opusDataSource) {
		this.opusDataSource = opusDataSource;
	}

	public void moveHostels(){
		
		//Obtain hostel info from stagging area
		JdbcTemplate jdbcTemplate = new JdbcTemplate(opusDataSource);
		
		List<Map<String,Object>> hostelList = jdbcTemplate.queryForList("select * from srsdatastage.hostel");
		
		for(Map<String,Object> hostel:hostelList){
			log.info(hostel);
			String code = (String)hostel.get("code");
			String description = (String)hostel.get("fullname");
			
			//Create a new Hostel object
			/*Hostel h = new Hostel();
			h.setActive("Y");
			h.setCode(code);
			h.setDescription(description);
			h.setHostelTypeId(0);
			h.setNumberOfFloors(0);
			
			//hostelManager.addHostel(h);
			
			//Accommodation
			StudentAccommodation studentAccommodation = new StudentAccommodation();
			studentAccommodation.setAcademicYearId(0);
			studentAccommodation.setAccepted(true);
			studentAccommodation.setActive("Y");
			accommodationManager.addStudentAccommodation(studentAccommodation);*/
			
		}
		
		
		//loop through the JdbcTemplate Map objects in the list
		
		//then pass populated object to the respective manger 
		
	}
}
