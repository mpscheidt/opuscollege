package org.uci.opus.accommodation.domain;

import java.util.Date;

public class HostelBlock {
	private Integer id;
	private String code;
	private String description;
	private int numberOfFloors;
	private Hostel hostel;
	private Date writeWhen;
	private String writeWho;
	private String active = "Y";

	public HostelBlock() {
        hostel=new Hostel();
	}
	

	public Integer getId() {
		return id;
	}


	public void setId(Integer id) {
		this.id = id;
	}


	public String getCode() {
		return code;
	}


	public void setCode(String code) {
		this.code = code;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public int getNumberOfFloors() {
		return numberOfFloors;
	}


	public void setNumberOfFloors(int numberOfFloors) {
		this.numberOfFloors = numberOfFloors;
	}


	public Hostel getHostel() {
		return hostel;
	}


	public void setHostel(Hostel hostel) {
		this.hostel = hostel;
	}


	public Date getWriteWhen() {
		return writeWhen;
	}


	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}


	public String getWriteWho() {
		return writeWho;
	}


	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}


	public String getActive() {
		return active;
	}


	public void setActive(String active) {
		this.active = active;
	}

}