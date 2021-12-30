package org.uci.opus.college.domain;

/**
 * Object that defines limitations on institution, branch and organizationUnit level (for the logged in user).
 * 
 * <p>
 * If unset (e.g. organizationUnitId is null) means no limitations on that level, if set (e.g. organizationalUnitId = 18, only the given
 * organizationalUnit is accessible.
 * 
 * <p>
 * NB: This class might eventually be extended to lower levels: study, studyplan.
 * 
 * @author Markus Pscheidt
 *
 */
public class OrganizationAuthorization {

    private Integer institutionId;
    private Integer branchId;
    private Integer organizationalUnitId;

    public Integer getInstitutionId() {
        return institutionId;
    }

    public Integer getBranchId() {
        return branchId;
    }

    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }

    public Integer getOrganizationalUnitId() {
        return organizationalUnitId;
    }

    public void setOrganizationalUnitId(Integer organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }

    public void setInstitutionId(Integer institutionId) {
        this.institutionId = institutionId;
    }

}
