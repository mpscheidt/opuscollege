package org.uci.opus.report.web.form;

import java.util.Date;

public class HistoryReportForm {

    private String tableName;
    private Date startDate;
    private Date endDate;
    private boolean insert = true;
    private boolean update = true;
    private boolean delete = true;
    private String writeWho;


    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public boolean isInsert() {
        return insert;
    }

    public void setInsert(boolean insert) {
        this.insert = insert;
    }

    public boolean isUpdate() {
        return update;
    }

    public void setUpdate(boolean update) {
        this.update = update;
    }

    public boolean isDelete() {
        return delete;
    }

    public void setDelete(boolean delete) {
        this.delete = delete;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }
    
}
