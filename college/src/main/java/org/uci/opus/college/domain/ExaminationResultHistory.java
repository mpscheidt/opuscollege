package org.uci.opus.college.domain;

import java.util.Date;

public class ExaminationResultHistory {

	private String operation;
	private String writewho;
	private Date writewhen;
	private String mark;
	private String passed;
	private Integer examinationResultCommentId;
	private String surnameFull;
	private String firstnamesFull;
	
	public String getOperation() {
		return operation;
	}
	public void setOperation(String operation) {
		this.operation = operation;
	}
	public String getWritewho() {
		return writewho;
	}
	public void setWritewho(String writewho) {
		this.writewho = writewho;
	}
	public Date getWritewhen() {
		return writewhen;
	}
	public void setWritewhen(Date writewhen) {
		this.writewhen = writewhen;
	}
	public String getMark() {
		return mark;
	}
	public void setMark(String mark) {
		this.mark = mark;
	}
	public String getPassed() {
		return passed;
	}
	public void setPassed(String passed) {
		this.passed = passed;
	}
	public String getSurnameFull() {
		return surnameFull;
	}
	public void setSurnameFull(String surnameFull) {
		this.surnameFull = surnameFull;
	}
	public String getFirstnamesFull() {
		return firstnamesFull;
	}
	public void setFirstnamesFull(String firstnamesFull) {
		this.firstnamesFull = firstnamesFull;
	}
	public Integer getExaminationResultCommentId() {
		return examinationResultCommentId;
	}
	public void setExaminationResultCommentId(Integer examinationResultCommentId) {
		this.examinationResultCommentId = examinationResultCommentId;
	}
	
}
