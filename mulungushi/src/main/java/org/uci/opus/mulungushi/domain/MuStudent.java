package org.uci.opus.mulungushi.domain;

import java.util.Date;

public class MuStudent {

	private int studentNo;
	private String firstnames;
	private String surname;
	private String sex;
	private String nrcOrPassport;
	private Date   dateOfBirth;
	private String placeOfBirth;
	private String nationality;
	private String programNo;
	private String maritalStatus;
	private String residentialAddress;
	private String businessPhone;
	private String postalAddress;
	private String mobileNo;
	private String email;
	private String nameOfNextOfKin;
	private String nextOfKinResAddress;
	private String nextOfKinPostalAddress;
	private String nextOfKinMobileNo;
	private String nextOfKinPhoneNo;
	private String relationToNextOfKin;
	private String remark; // "Student"->active student, "EXCLUDE"->excluded or "Credit"->graduated
	private Date   graduation;
	
	@Override
	public String toString() {
		return studentNo + ": " + firstnames + " " + surname;
	}

	public int getStudentNo() {
		return studentNo;
	}

	public void setStudentNo(int studentNo) {
		this.studentNo = studentNo;
	}

	public String getFirstnames() {
		return firstnames;
	}

	public void setFirstnames(String firstnames) {
		this.firstnames = firstnames;
	}

	public String getSurname() {
		return surname;
	}

	public void setSurname(String surname) {
		this.surname = surname;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getNrcOrPassport() {
		return nrcOrPassport;
	}

	public void setNrcOrPassport(String nrcOrPassport) {
		this.nrcOrPassport = nrcOrPassport;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getPlaceOfBirth() {
		return placeOfBirth;
	}

	public void setPlaceOfBirth(String placeOfBirth) {
		this.placeOfBirth = placeOfBirth;
	}

	public String getNationality() {
		return nationality;
	}

	public void setNationality(String nationality) {
		this.nationality = nationality;
	}

	public String getProgramNo() {
		return programNo;
	}

	public void setProgramNo(String programNo) {
		this.programNo = programNo;
	}

	public String getMaritalStatus() {
		return maritalStatus;
	}

	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}

	public String getResidentialAddress() {
		return residentialAddress;
	}

	public void setResidentialAddress(String residentialAddress) {
		this.residentialAddress = residentialAddress;
	}

	public String getBusinessPhone() {
		return businessPhone;
	}

	public void setBusinessPhone(String businessPhone) {
		this.businessPhone = businessPhone;
	}

	public String getPostalAddress() {
		return postalAddress;
	}

	public void setPostalAddress(String postalAddress) {
		this.postalAddress = postalAddress;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getNameOfNextOfKin() {
		return nameOfNextOfKin;
	}

	public void setNameOfNextOfKin(String nameOfNextOfKin) {
		this.nameOfNextOfKin = nameOfNextOfKin;
	}

	public String getNextOfKinResAddress() {
		return nextOfKinResAddress;
	}

	public void setNextOfKinResAddress(String nextOfKinResAddress) {
		this.nextOfKinResAddress = nextOfKinResAddress;
	}

	public String getNextOfKinPostalAddress() {
		return nextOfKinPostalAddress;
	}

	public void setNextOfKinPostalAddress(String nextOfKinPostalAddress) {
		this.nextOfKinPostalAddress = nextOfKinPostalAddress;
	}

	public String getNextOfKinPhoneNo() {
		return nextOfKinPhoneNo;
	}

	public void setNextOfKinPhoneNo(String nextOfKinPhoneNo) {
		this.nextOfKinPhoneNo = nextOfKinPhoneNo;
	}

	public String getRelationToNextOfKin() {
		return relationToNextOfKin;
	}

	public void setRelationToNextOfKin(String relationToNextOfKin) {
		this.relationToNextOfKin = relationToNextOfKin;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getGraduation() {
		return graduation;
	}

	public void setGraduation(Date graduation) {
		this.graduation = graduation;
	}

	public String getNextOfKinMobileNo() {
		return nextOfKinMobileNo;
	}

	public void setNextOfKinMobileNo(String nextOfKinMobileNo) {
		this.nextOfKinMobileNo = nextOfKinMobileNo;
	}

}
