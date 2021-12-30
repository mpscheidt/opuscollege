package org.uci.opus.fee.web.form;

import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.web.form.NavigationSettings;

public class CancelStudentFeeForm {
    
    private Student student;
    private String writeWho;
    private String txtError;
    private String txtMsg;
    StudentBalance studentBalance;

    private NavigationSettings navigationSettings;
    
    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

    public StudentBalance getStudentBalance() {
        return studentBalance;
    }

    public void setStudentBalance(StudentBalance studentBalance) {
        this.studentBalance = studentBalance;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public String getTxtError() {
        return txtError;
    }

    public void setTxtError(String txtError) {
        this.txtError = txtError;
    }

    public String getTxtMsg() {
        return txtMsg;
    }

    public void setTxtMsg(String txtMsg) {
        this.txtMsg = txtMsg;
    }
    
}
