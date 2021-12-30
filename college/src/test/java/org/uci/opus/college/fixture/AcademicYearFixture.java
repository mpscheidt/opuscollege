package org.uci.opus.college.fixture;

import java.util.Date;
import java.util.GregorianCalendar;

import org.uci.opus.college.domain.AcademicYear;

/**
 * Test fixture.
 * 
 * @author markus
 *
 */
public class AcademicYearFixture {

    public static final String YEAR2014_DESCRIPTION = "2014";
    public static final Date YEAR_2014_STARTDATE = new GregorianCalendar(2014, 1, 1).getTime();
    public static final Date YEAR_2014_ENDDATE = new GregorianCalendar(2014, 12, 31).getTime();

    public static final String YEAR2015_DESCRIPTION = "2015";
    public static final Date YEAR_2015_STARTDATE = new GregorianCalendar(2015, 1, 1).getTime();
    public static final Date YEAR_2015_ENDDATE = new GregorianCalendar(2015, 12, 31).getTime();

	public static final AcademicYear academicYear2014() {
		AcademicYear year = new AcademicYear(YEAR2014_DESCRIPTION, YEAR_2014_STARTDATE, YEAR_2014_ENDDATE);
		return year;
	}

	public static final AcademicYear academicYear2015() {
		AcademicYear year = new AcademicYear(YEAR2015_DESCRIPTION, YEAR_2015_STARTDATE, YEAR_2015_ENDDATE);
		return year;
	}

}
