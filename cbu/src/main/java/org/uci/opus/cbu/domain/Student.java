package org.uci.opus.cbu.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Date;

public class Student {
	private String studentNo;
	private String firstName;
	private String lastName;
	private String otherNames;
	private String gender;
	private Date dateOfBirth;
	private String maritalStatus;
	private String nrcNo;
	private String passportNo;
	private String telephoneNo;
	private String faxNo;
	private String email;
	private String plotNo;
	private String boxNo;
	private String street;
	private String town;
	private String province;
	private String nameOfGuardian;
	private Nationality nationality;
	private boolean schoolLeaver;
	private Programme programme;
	private int yearOfEntry;
	private int yearGraduated;
	private int yearRegistered;
	private int yearOfStudy;
	private int durationOfStudy;
	private String studyCategory;
	private String sponsor;
	private Date dateOfEnrollment;
	private String applicationNo;

	public String getStudentNo() {
		return studentNo;
	}

	public void setStudentNo(String studentNo) {
		this.studentNo = studentNo;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getMaritalStatus() {
		return maritalStatus;
	}

	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}

	public String getNrcNo() {
		return nrcNo;
	}

	public void setNrcNo(String nrcNo) {
		this.nrcNo = nrcNo;
	}

	
	public String getOtherNames() {
		return otherNames;
	}
	
	public void setOtherNames(String otherNames) {
		this.otherNames = otherNames;
	}

	public String getPassportNo() {
		return passportNo;
	}

	public void setPassportNo(String passportNo) {
		this.passportNo = passportNo;
	}

	public String getTelephoneNo() {
		return telephoneNo;
	}

	public void setTelephoneNo(String telephoneNo) {
		this.telephoneNo = telephoneNo;
	}

	public String getFaxNo() {
		return faxNo;
	}

	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
	}

	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}

	public String getPlotNo() {
		return plotNo;
	}

	public void setPlotNo(String plotNo) {
		this.plotNo = plotNo;
	}

	public String getBoxNo() {
		return boxNo;
	}

	public void setBoxNo(String boxNo) {
		this.boxNo = boxNo;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getTown() {
		return town;
	}

	public void setTown(String town) {
		this.town = town;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getNameOfGuardian() {
		return nameOfGuardian;
	}

	public void setNameOfGuardian(String nameOfGuardian) {
		this.nameOfGuardian = nameOfGuardian;
	}

	public Nationality getNationality() {
		return nationality;
	}

	public void setNationality(Nationality nationality) {
		this.nationality = nationality;
	}

	public boolean isSchoolLeaver() {
		return schoolLeaver;
	}

	public void setSchoolLeaver(boolean schoolLeaver) {
		this.schoolLeaver = schoolLeaver;
	}

	public Programme getProgramme() {
		return programme;
	}

	public void setProgramme(Programme programme) {
		this.programme = programme;
	}

	public int getYearOfEntry() {
		return yearOfEntry;
	}

	public void setYearOfEntry(int yearOfEntry) {
		this.yearOfEntry = yearOfEntry;
	}

	public int getYearGraduated() {
		return yearGraduated;
	}

	public void setYearGraduated(int yearGraduated) {
		this.yearGraduated = yearGraduated;
	}

	public int getYearRegistered() {
		return yearRegistered;
	}

	public void setYearRegistered(int yearRegistered) {
		this.yearRegistered = yearRegistered;
	}

	public int getYearOfStudy() {
		return yearOfStudy;
	}

	public void setYearOfStudy(int yearOfStudy) {
		this.yearOfStudy = yearOfStudy;
	}

	public int getDurationOfStudy() {
		return durationOfStudy;
	}

	public void setDurationOfStudy(int durationOfStudy) {
		this.durationOfStudy = durationOfStudy;
	}

	public String getStudyCategory() {
		return studyCategory;
	}

	public void setStudyCategory(String studyCategory) {
		this.studyCategory = studyCategory;
	}

	public String getSponsor() {
		return sponsor;
	}

	public void setSponsor(String sponsor) {
		this.sponsor = sponsor;
	}
	
	public Date getDateOfEnrollment() {
		return dateOfEnrollment;
	}

	public void setDateOfEnrollment(Date dateOfEnrollment) {
		this.dateOfEnrollment = dateOfEnrollment;
	}
	
	public String getApplicationNo() {
		return applicationNo;
	}

	public void setApplicationNo(String applicationNo) {
		this.applicationNo = applicationNo;
	}

	@Override
	public String toString() {
		String values = "";
		Field[] fields = getClass().getDeclaredFields();
		Method[] methods = getClass().getDeclaredMethods();

		for (Field f : fields) {
			try {
				for (Method m : methods) {
					if (Modifier.isPublic(m.getModifiers())	&& (f.getName().length() == 1 || (m.getName().indexOf("get"+ f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1)) != -1))) {
						values += f.getName() + " = " + f.get(this) + ", ";
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		values=values.substring(0,values.lastIndexOf(","));
		return getClass().getName() + " = [" + values + "]";
	}
}
