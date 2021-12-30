package org.uci.opus.college.domain.result;

import java.io.Serializable;

/**
 * @author Maxwell Rayce
 * @author Aniza Faquira
 */
public class ExaminationAttemptType implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private int id; 
    private int sort; 
    private String commentkey;
    private int defaultattemptnumber;
    private boolean active;
    private String examinationtypecode;
        
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getSort() {
		return sort;
	}
	public void setSort(int sort) {
		this.sort = sort;
	}
	public String getCommentkey() {
		return commentkey;
	}
	public void setCommentkey(String commentkey) {
		this.commentkey = commentkey;
	}
	public int getDefaultattemptnumber() {
		return defaultattemptnumber;
	}
	public void setDefaultattemptnumber(int defaultattemptnumber) {
		this.defaultattemptnumber = defaultattemptnumber;
	}
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
	public String getExaminationtypecode() {
		return examinationtypecode;
	}
	public void setExaminationtypecode(String examinationtypecode) {
		this.examinationtypecode = examinationtypecode;
	}
    
    

}
