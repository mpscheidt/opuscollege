package org.uci.opus.cbu.dbconversion;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.uci.opus.cbu.data.ProgrammeDao;
import org.uci.opus.cbu.domain.Hostel;
import org.uci.opus.cbu.domain.Programme;
import org.uci.opus.cbu.domain.Room;
import org.uci.opus.college.service.StudentManagerInterface;

public class AccommodationDataMigrator {
	@Autowired DataSource accommodationDataSource;
	@Autowired DataSource dataSource;
	@Autowired private StudentManagerInterface studentManager;
	@Autowired private ProgrammeDao programmeDao;
	
	public void convertData(){
		//addHostelTypes();
		//addHostels();
		//addRooms();
		//addAssets();
		//addAccommodationFees();
		migrateStudentsAccommodationData();
	}
	
	private void migrateStudentsAccommodationData(){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Programme> programmes=programmeDao.getProgrammes();
		for(Programme programme:programmes){
			for(int yearOfStudy=1;yearOfStudy<=programme.getProgrammeDuration();yearOfStudy++){
				for(int academicYear=2011;academicYear<=2012;academicYear++){
					
					int academicYearId=getAcademicYearId(academicYear);
					List<Map<String,Object>> rows=getAccommodationData(academicYear);
					if(rows!=null){
						for(Map<String,Object> row:rows){
							String studentNo=row.get("Code").toString().trim();
							System.out.println("code=>"+row.get("Code")+", roomNo=>"+ row.get("RoomNumber")+", hostel=>"+row.get("Hostel"));
							//System.out.println("SELECT id FROM opuscollege.acc_room WHERE description='"+row.get("RoomNumber")+"' AND hostelid=(SELECT id FROM opuscollege.acc_hostel WHERE description='"+row.get("Hostel")+"')");
							org.uci.opus.college.domain.Student student=studentManager.findStudentByCode(studentNo);
							//Exception will occur when a room is not found
							try{
								int roomId=jdbc.queryForObject("SELECT id FROM opuscollege.acc_room WHERE description='"+row.get("RoomNumber")+"' AND hostelid=(SELECT id FROM opuscollege.acc_hostel WHERE description='"+row.get("Hostel")+"')", Integer.class);
								
								if(student!=null){
									List<Map<String,Object>> studentAccommodation=jdbc.queryForList("SELECT * FROM opuscollege.acc_studentaccommodation WHERE studentid='"+student.getStudentId()+"' AND academicyearid='"+academicYearId+"'");
									if(studentAccommodation.toString().equals("[]")){
										jdbc.execute("INSERT INTO opuscollege.acc_studentaccommodation(studentid,roomid,allocated,dateapplied,dateapproved,accepted,academicyearid) VALUES" +
											"('"+student.getStudentId()+"','"+roomId+"','Y','01/01/"+academicYear+"','01/01/"+academicYear+"','Y','"+academicYearId+"')");
									}
								}
							}catch(Exception ex){
								
							}
						}
					}
				}
			}
		}
	}
	
	private void addHostelTypes(){
		List<String> hostelTypes=getHostelTypes();
		if(hostelTypes!=null){
			for(String hostelType:hostelTypes){
				addHostelType(hostelType);
			}
		}
	}
	
	private void addHostels(){
		List<Hostel> hostels=getHostels();
		if(hostels!=null){
			for(Hostel hostel:hostels){
				addHostel(hostel);
			}
		}
	}
	
	private void addRooms(){
		List<Room> rooms=getRooms();
		if(rooms!=null){
			for(Room room:rooms){
				addRoom(room);
			}
		}
	}
	
	private void addAssets(){
		List<String> assets=getAssets();
		if(assets!=null){
			for(String asset:assets){
				addAsset(asset);
			}
		}
	}
	
	private void addAccommodationFees(){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Hostel> hostels=getHostels();
		for(Hostel hostel:hostels){
			List<String> roomTypes=getRoomTypes(hostel.getName());
			if(roomTypes!=null){
				for(String roomType:roomTypes){
					for(int year=2008; year<=2012;year++){
						double accommodationFee=getAccommodationFee(roomType, hostel.getHostelType(),year);
						int academicYearId=getAcademicYearId(year);
						int hostelId=jdbc.queryForObject("SELECT id FROM opuscollege.acc_hostel WHERE description='"+hostel.getName()+"'", Integer.class);
						
						List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM opuscollege.acc_accommodationfee WHERE hostelid='"+hostelId+"' AND academicyearid='"+academicYearId+"'");
						if(result.toString().equals("[]")){
							jdbc.execute("INSERT INTO opuscollege.acc_accommodationfee (description,amountdue,numberofinstallments,hostelid,active) VALUES('Accommodation Fee','"+accommodationFee+"','1','"+hostelId+"','Y')");
						}
					}
				}
			}
		}
	}
	
	private void addHostelType(String hostelType){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM opuscollege.acc_hosteltype WHERE code='"+hostelType+"'");
		if(result.toString().equals("[]")){
			jdbc.execute("INSERT INTO opuscollege.acc_hosteltype (code,description,lang,active) VALUES('"+hostelType+"','"+hostelType+"','en','Y')");
		}
	}
	
	private void addHostel(Hostel hostel){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM opuscollege.acc_hostel WHERE code='"+hostel.getName()+"' AND hosteltypecode='"+hostel.getHostelType()+"'");
		if(result.toString().equals("[]")){
			jdbc.execute("INSERT INTO opuscollege.acc_hostel (code,description,hosteltypecode,active) VALUES('"+hostel.getName()+"','"+hostel.getName()+"','"+hostel.getHostelType()+"','Y')");
		}
	}
	
	private void addRoom(Room room){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM opuscollege.acc_room WHERE code='"+room.getRoomNo()+"' AND description='"+room.getRoomNo()+"'");
		if(result.toString().equals("[]")){
			int hostelId=jdbc.queryForObject("SELECT id FROM opuscollege.acc_hostel where description='"+room.getHostelName()+"'", Integer.class);
			jdbc.execute("INSERT INTO opuscollege.acc_room (code,description,hostelid,floornumber,numberofbedspaces,active) VALUES('"+room.getRoomNo()+"','"+room.getRoomNo()+"','"+hostelId+"','0','"+room.getNumberOfBedSpace()+"','Y')");
		}
	}
	
	private void addAsset(String asset){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM opuscollege.acc_asset WHERE code='"+asset+"'");
		if(result.toString().equals("[]")){
			jdbc.execute("INSERT INTO opuscollege.acc_asset (code,description,active) VALUES('"+asset+"','"+asset+"','Y')");
		}
	}
	
	private int getAcademicYearId(int year){
		JdbcTemplate jdbc=new JdbcTemplate(dataSource);
		return jdbc.queryForObject("SELECT id FROM opuscollege.academicyear WHERE description='"+year+"'", Integer.class);
	}
	
	private List<Map<String,Object>> getAccommodationData(int academicYear){
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM tbl_AccomAllocation WHERE YearAccommodated='"+academicYear+"'");
		return result.toString().equals("[]")?null:result;
	}
	
	private double getAccommodationFee(String roomType,String hostelType,int year){
		Object obj=null;
		try{
			JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
			obj= jdbc.queryForObject("SELECT Amount FROM tbl_prices WHERE [Type]='"+roomType+"' AND HostelType='"+hostelType+"' AND [Year]='"+year+"'",Object.class);
		}catch(Exception ex){
			
		}
		return obj==null?0:(Double)obj;
	}
	
	private Map<String,Object> getAllocatedItems(String studentNo,int yearOfStudy){
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM tbl_ItemAllocations WHERE StudentId='"+studentNo+"' AND [Year]='"+yearOfStudy+"'");
		return result.toString().equals("[]")?null:result.get(0);
	}
	
	private List<Room> getRooms(){
		List<Room> rooms=null;
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM tbl_Rooms ORDER BY HostelName");
		
		if(!result.toString().equals("[]")){
			rooms=new ArrayList<Room>();
			for(Map<String,Object> row:result){
				Room room=new Room();
				room.setHostelName(row.get("HostelName").toString());
				room.setRoomNo(row.get("RoomNumber").toString());
				room.setRoomType(row.get("Type").toString());
				rooms.add(room);
			}
		}
		return rooms;
	}
	
	private List<Hostel> getHostels(){
		List<Hostel> hostels=null;
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM tbl_Hostel ORDER BY HostelName");
		
		if(!result.toString().equals("[]")){
			hostels=new ArrayList<Hostel>();
			for(Map<String,Object> row:result){
				Hostel hostel=new Hostel();
				hostel.setName(row.get("HostelName").toString());
				hostel.setHostelType(row.get("Type").toString());
				hostels.add(hostel);
			}
		}
		return hostels;
	}
	
	private List<String> getHostelTypes(){
		List<String> hostelTypes=null;
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT DISTINCT [Type] FROM tbl_Hostel");
		
		if(!result.toString().equals("[]")){
			hostelTypes=new ArrayList<String>();
			for(Map<String,Object> row:result){
				String hostelType=row.get("Type").toString();
				hostelTypes.add(hostelType);
			}
		}
		return hostelTypes;
	}
	
	private List<String> getRoomTypes(String hostelName){
		List<String> roomTypes=null;
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT DISTINCT [Type] FROM tbl_Rooms WHERE HostelName='"+hostelName+"'");
		
		if(!result.toString().equals("[]")){
			roomTypes=new ArrayList<String>();
			for(Map<String,Object> row:result){
				String roomType=row.get("Type").toString();
				roomTypes.add(roomType);
			}
		}
		return roomTypes;
	}
	
	private List<String> getAssets(){
		List<String> assets=null;
		JdbcTemplate jdbc=new JdbcTemplate(accommodationDataSource);
		List<Map<String,Object>> result=jdbc.queryForList("SELECT * FROM tbl_Assets");
		
		if(!result.toString().equals("[]")){
			assets=new ArrayList<String>();
			for(Map<String,Object> row:result){
				String asset=row.get("Item").toString();
				assets.add(asset);
			}
		}
		return assets;
	}
}
