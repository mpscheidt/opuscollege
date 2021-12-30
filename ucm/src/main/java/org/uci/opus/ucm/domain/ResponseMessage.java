package org.uci.opus.ucm.domain;

import java.io.Serializable;

public class ResponseMessage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3502452486912466255L;
	private String status;
	private String data;
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	public ResponseMessage(String status, String data) {
		super();
		this.status = status;
		this.data = data;
	}
	
	
	
}
