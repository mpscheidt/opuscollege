package org.uci.opus.college.domain;

import java.io.Serializable;

public class SubjectClassgroup implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
	private int subjectId;
	private int classgroupId;
	
	private Subject subject;

	public SubjectClassgroup() {
	    super();
    }

    public SubjectClassgroup(int subjectId, int classgroupId) {
        super();
        this.subjectId = subjectId;
        this.classgroupId = classgroupId;
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(int subjectId) {
		this.subjectId = subjectId;
	}

	public int getClassgroupId() {
		return classgroupId;
	}

	public void setClassgroupId(int classgroupId) {
		this.classgroupId = classgroupId;
	}

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }
}
