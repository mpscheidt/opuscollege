package org.uci.opus.college.fixture;

import org.uci.opus.college.domain.Branch;

/**
 * 
 * @author markus
 *
 */
public class BranchFixture {

    public static String BRANCH_UCMFCS_CODE = "05";
    public static String BRANCH_UCMFCS_DESCRIPTION = "UCM FCS";

    public static String BRANCH_UCMFD_CODE = "06";
    public static String BRANCH_UCMFD_DESCRIPTION = "UCM FD";

    public static String BRANCH_AB_CODE = "AB";
    public static String BRANCH_AB_DESCRIPTION = "A desc";

    public static String BRANCH_CD_CODE = "CD";
    public static String BRANCH_CD_DESCRIPTION = "C and d";

    public static Branch ucmFcs(int institutionId) {
        return new Branch(institutionId, BRANCH_UCMFCS_CODE, BRANCH_UCMFCS_DESCRIPTION);
    }

    public static Branch ucmFd(int institutionId) {
        return new Branch(institutionId, BRANCH_UCMFD_CODE, BRANCH_UCMFD_DESCRIPTION);
    }

    public static Branch ab(int institutionId) {
        return new Branch(institutionId, BRANCH_AB_CODE, BRANCH_AB_DESCRIPTION);
    }

    public static Branch cd(int institutionId) {
        return new Branch(institutionId, BRANCH_CD_CODE, BRANCH_CD_DESCRIPTION);
    }

}
