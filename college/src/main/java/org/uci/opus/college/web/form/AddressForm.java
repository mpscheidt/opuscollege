/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
*/

package org.uci.opus.college.web.form;

import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.util.ExtendedArrayList;

public class AddressForm {

	Address address;
	Organization organization;
	NavigationSettings navigationSettings;
	
	String txtErr;
	String txtMsg;
	
	String from;
	
	OrganizationalUnit organizationalUnit;
	StaffMember staffMember;
	Student student;
	Study study;
	
	ExtendedArrayList allAddressTypesForEntity;
	
	
	public AddressForm() {
		txtErr = "";
		txtMsg = "";
	}
	
	/**
	 * @return the address
	 */
	public Address getAddress() {
		return address;
	}
	/**
	 * @param address the address to set
	 */
	public void setAddress(final Address address) {
		this.address = address;
	}

	/**
	 * @return the organization
	 */
	public Organization getOrganization() {
		return organization;
	}
	/**
	 * @param organization the organization to set
	 */
	public void setOrganization(final Organization organization) {
		this.organization = organization;
	}
	
	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	/**
	 * @param navigationSettings the navigationSettings to set
	 */
	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}
	/**
	 * @param txtErr the txtErr to set
	 */
	public void setTxtErr(final String txtErr) {
		this.txtErr = txtErr;
	}
	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}

	/**
	 * @return the from
	 */
	public String getFrom() {
		return from;
	}
	/**
	 * @param from the from to set
	 */
	public void setFrom(final String from) {
		this.from = from;
	}

	/**
	 * @return the organizationalUnit
	 */
	public OrganizationalUnit getOrganizationalUnit() {
		return organizationalUnit;
	}
	/**
	 * @param organizationalUnit the organizationalUnit to set
	 */
	public void setOrganizationalUnit(final OrganizationalUnit organizationalUnit) {
		this.organizationalUnit = organizationalUnit;
	}

	/**
	 * @return the staffMember
	 */
	public StaffMember getStaffMember() {
		return staffMember;
	}
	/**
	 * @param staffMember the staffMember to set
	 */
	public void setStaffMember(final StaffMember staffMember) {
		this.staffMember = staffMember;
	}

	/**
	 * @return the student
	 */
	public Student getStudent() {
		return student;
	}
	/**
	 * @param student the student to set
	 */
	public void setStudent(final Student student) {
		this.student = student;
	}

	/**
	 * @return the study
	 */
	public Study getStudy() {
		return study;
	}
	/**
	 * @param study the study to set
	 */
	public void setStudy(final Study study) {
		this.study = study;
	}

	/**
	 * @return the allAddressTypesForEntity
	 */
	public ExtendedArrayList getAllAddressTypesForEntity() {
		return allAddressTypesForEntity;
	}

	/**
	 * @param allAddressTypesForEntity the allAddressTypesForEntity to set
	 */
	public void setAllAddressTypesForEntity(
			final ExtendedArrayList allAddressTypesForEntity) {
		this.allAddressTypesForEntity = allAddressTypesForEntity;
	}

	
	
}
