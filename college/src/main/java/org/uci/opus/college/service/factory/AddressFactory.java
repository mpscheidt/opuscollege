package org.uci.opus.college.service.factory;

import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.util.StudentUtil;

@Service
public class AddressFactory {
	
	public static final String ADDRESS_TYPE_CODE_HOME = "1";
	public static final String ADDRESS_TYPE_CODE_FORMAL_COMMUNICATION_STUDENT = "2";
	public static final String ADDRESS_TYPE_CODE_FINANCIAL_GUARDIAN = "3";
	public static final String ADDRESS_TYPE_CODE_FORMAL_COMMUNICATION_STUDY = "4";
	public static final String ADDRESS_TYPE_CODE_FORMAL_COMMUNICATION_ORGANIZATIONAL_UNIT = "5";
	public static final String ADDRESS_TYPE_CODE_FORMAL_COMMUNICATION_WORK = "6";
	public static final String ADDRESS_TYPE_CODE_PARENTS = "7";
	
	public Address newHomeAddress(int personId) {
		return newAddress(ADDRESS_TYPE_CODE_HOME, personId);
	}

	public Address newFormalCommuncationAddressStudent(int personId) {
		return newAddress(ADDRESS_TYPE_CODE_FORMAL_COMMUNICATION_STUDENT, personId);
	}

	public Address newFinancialGuardianAddress(int personId) {
		return newAddress(ADDRESS_TYPE_CODE_FINANCIAL_GUARDIAN, personId);
	}

	public Address newAddress(String addressTypeCode, int personId) {
		Address address = new Address();
		
		address.setAddressTypeCode(addressTypeCode);
		address.setPersonId(personId);
		StudentUtil.setDefaultValues(address);
		
		return address;
	}
}
