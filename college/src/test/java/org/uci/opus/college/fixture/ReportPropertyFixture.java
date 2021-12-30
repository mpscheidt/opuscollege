package org.uci.opus.college.fixture;

import org.uci.opus.college.domain.ReportProperty;

public abstract class ReportPropertyFixture {

    public static final String STUDENTSBYSUBJECT_REPORTNAME = "StudentsBySubject";

    public static final String STUDENTSBYSUBJECT_TITLE_PROPERTYNAME = "title";
    public static final String STUDENTSBYSUBJECT_TITLE_TEXT = "Students by subject";

    public static final String STUDENTSBYSUBJECT_LOGO_PROPERTYNAME = "logo";
    public static final String STUDENTSBYSUBJECT_LOGO_TYPE = "image/svg+xml";
    public static final byte[] STUDENTSBYSUBJECT_LOGO_FILE = javax.xml.bind.DatatypeConverter.parseHexBinary("e04fd020ea3a6910a2d808002b30309d");

    public static ReportProperty studentsBySubjectTitle() {
    	return new ReportProperty(STUDENTSBYSUBJECT_REPORTNAME, STUDENTSBYSUBJECT_TITLE_PROPERTYNAME, STUDENTSBYSUBJECT_TITLE_TEXT);
    }

    public static ReportProperty studentsBySubjectLogo() {
    	return new ReportProperty(STUDENTSBYSUBJECT_REPORTNAME, STUDENTSBYSUBJECT_LOGO_PROPERTYNAME, STUDENTSBYSUBJECT_LOGO_TYPE, STUDENTSBYSUBJECT_LOGO_FILE);
    }

}
