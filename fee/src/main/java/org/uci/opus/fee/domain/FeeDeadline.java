package org.uci.opus.fee.domain;

import java.io.Serializable;
import java.util.Date;

public class FeeDeadline implements Serializable {
	
	private int id;
	private int feeId;
	private Date deadline;
	private String cardinalTimeUnitCode;
	private int cardinalTimeUnitNumber;
	private String writeWho;
	private String active;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Date getDeadline() {
		return deadline;
	}
	public void setDeadline(Date deadline) {
		this.deadline = deadline;
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
	public int getFeeId() {
		return feeId;
	}
	public void setFeeId(int feeId) {
		this.feeId = feeId;
	}
	public String getCardinalTimeUnitCode() {
		return cardinalTimeUnitCode;
	}
	public void setCardinalTimeUnitCode(String cardinalTimeUnitCode) {
		this.cardinalTimeUnitCode = cardinalTimeUnitCode;
	}
	public int getCardinalTimeUnitNumber() {
		return cardinalTimeUnitNumber;
	}
	public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
		this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
	}
	
}
