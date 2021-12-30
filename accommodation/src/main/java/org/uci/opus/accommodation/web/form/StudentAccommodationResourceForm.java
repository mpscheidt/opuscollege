package org.uci.opus.accommodation.web.form;

import java.util.Date;

public class StudentAccommodationResourceForm {
	private int id;
	private int studentAccommodationId;
	private int accommodationResourceId;
	private Date dateCollected;
	private Date dateReturned;
	private String commentWhenCollecting;
	private String commentWhenReturning;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getStudentAccommodationId() {
		return studentAccommodationId;
	}

	public void setStudentAccommodationId(int studentAccommodationId) {
		this.studentAccommodationId = studentAccommodationId;
	}

	public int getAccommodationResourceId() {
		return accommodationResourceId;
	}

	public void setAccommodationResourceId(int accommodationResourceId) {
		this.accommodationResourceId = accommodationResourceId;
	}

	public Date getDateCollected() {
		return dateCollected;
	}

	public void setDateCollected(Date dateCollected) {
		this.dateCollected = dateCollected;
	}

	public Date getDateReturned() {
		return dateReturned;
	}

	public void setDateReturned(Date dateReturned) {
		this.dateReturned = dateReturned;
	}

	public String getCommentWhenCollecting() {
		return commentWhenCollecting;
	}

	public void setCommentWhenCollecting(String commentWhenCollecting) {
		this.commentWhenCollecting = commentWhenCollecting;
	}

	public String getCommentWhenReturning() {
		return commentWhenReturning;
	}

	public void setCommentWhenReturning(String commentWhenReturning) {
		this.commentWhenReturning = commentWhenReturning;
	}
}
