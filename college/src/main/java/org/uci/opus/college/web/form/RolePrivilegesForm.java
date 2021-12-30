package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.Role;

public class RolePrivilegesForm {

    private Role role;
    private boolean copyPrivileges;
    private String sourceRole;
    private String[] privilegesCodes;

    private List<OpusPrivilege> privilegesNotInRole;
    private List<Role> availableRoles;

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isCopyPrivileges() {
        return copyPrivileges;
    }

    public void setCopyPrivileges(boolean copyPrivileges) {
        this.copyPrivileges = copyPrivileges;
    }

    public String getSourceRole() {
        return sourceRole;
    }

    public void setSourceRole(String sourceRole) {
        this.sourceRole = sourceRole;
    }

    public String[] getPrivilegesCodes() {
        return privilegesCodes;
    }

    public void setPrivilegesCodes(String[] privilegesCodes) {
        this.privilegesCodes = privilegesCodes;
    }

    public List<Role> getAvailableRoles() {
        return availableRoles;
    }

    public void setAvailableRoles(List<Role> availableRoles) {
        this.availableRoles = availableRoles;
    }

    public List<OpusPrivilege> getPrivilegesNotInRole() {
        return privilegesNotInRole;
    }

    public void setPrivilegesNotInRole(List<OpusPrivilege> privilegesNotInRole) {
        this.privilegesNotInRole = privilegesNotInRole;
    }
}
