package org.uci.opus.ucm.web.form.person;

import org.uci.opus.college.web.form.person.IStudentForm;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.ucm.domain.Primavera;

/**
 * Container for all data in the Primavera student screen.
 * 
 * @author Markus Pscheidt
 *
 */
public class StudentPrimaveraForm implements IStudentForm {
    
	private StudentFormShared studentFormShared;
    
    private Primavera primavera;

    public StudentFormShared getStudentFormShared() {
        return studentFormShared;
    }

    public void setStudentFormShared(StudentFormShared studentFormShared) {
        this.studentFormShared = studentFormShared;
    }

	public Primavera getPrimavera() {
		return primavera;
	}

	public void setPrimavera(Primavera primavera) {
		this.primavera = primavera;
	}

	
}
