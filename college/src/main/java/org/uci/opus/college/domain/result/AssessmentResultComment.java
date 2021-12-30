package org.uci.opus.college.domain.result;

public class AssessmentResultComment {

	private int id;
	private int sort;
	private String commentKey;
	private boolean active;

	public AssessmentResultComment() {
		super();
	}

	public int getId() {
	    return id;
	}

	public void setId(int id) {
	    this.id = id;
	}

	public String getCommentKey() {
	    return commentKey;
	}

	public void setCommentKey(String commentKey) {
	    this.commentKey = commentKey;
	}

	public boolean isActive() {
	    return active;
	}

	public void setActive(boolean active) {
	    this.active = active;
	}

	public int getSort() {
	    return sort;
	}

	public void setSort(int sort) {
	    this.sort = sort;
	}

}