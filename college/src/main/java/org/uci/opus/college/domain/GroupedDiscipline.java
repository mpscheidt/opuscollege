package org.uci.opus.college.domain;

import java.io.Serializable;

public class GroupedDiscipline implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String disciplineCode;
    private String active;
    private String writeWho;
    private int disciplineGroupId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDisciplineCode() {
        return disciplineCode;
    }

    public void setDisciplineCode(String disciplineCode) {
        this.disciplineCode = disciplineCode;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public int getDisciplineGroupId() {
        return disciplineGroupId;
    }

    public void setDisciplineGroupId(int disciplineGroupId) {
        this.disciplineGroupId = disciplineGroupId;
    }

}
