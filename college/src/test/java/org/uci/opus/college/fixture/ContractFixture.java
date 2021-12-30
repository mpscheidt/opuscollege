package org.uci.opus.college.fixture;

import org.uci.opus.college.domain.Contract;
import org.uci.opus.util.DateUtil;

public abstract class ContractFixture {
    
    private static final DateUtil DATE_UTIL = new DateUtil();

    public static Contract full(int staffMemberId) {
        Contract c = new Contract();
        c.setContractCode("C1");
        c.setContractTypeCode("1");
        c.setContractDurationCode("2");
        c.setContractStartDate(DATE_UTIL.parseSimpleDate("2014-12-22", "yyyy-MM-dd"));
        
        c.setStaffMemberId(staffMemberId);

        return c;
    }

    public static Contract partial(int staffMemberId) {
        Contract c = new Contract();
        c.setContractCode("C2");
        c.setContractTypeCode("2");
        c.setContractDurationCode("1");
        c.setContractStartDate(DATE_UTIL.parseSimpleDate("2015-01-01", "yyyy-MM-dd"));

        // staffMemberId according to ContractManagerTest-prepData.xml
        c.setStaffMemberId(staffMemberId);

        return c;
    }

}
