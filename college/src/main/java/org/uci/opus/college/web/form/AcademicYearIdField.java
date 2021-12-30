package org.uci.opus.college.web.form;

/**
 * Indicate that a form is to be initialized by setting the academicYearId to the current year if possible.
 * 
 * <p>
 * NB: Might be nice to convert to one  annotations to be placed on top of the academicYearId field.
 * 
 * @author markus
 *
 */
public interface AcademicYearIdField {
    
    public int getAcademicYearId();
    public void setAcademicYearId(int academicYearId);

//    public List<AcademicYear> getAllAcademicYears();
//    public void setAllAcademicYears(List<AcademicYear> allAcademicYears);

}
