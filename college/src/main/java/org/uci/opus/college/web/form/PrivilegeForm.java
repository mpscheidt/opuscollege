package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusRolePrivilege;

public class PrivilegeForm {

	/**
	 * The privilege being edited
	 */
	private OpusPrivilege privilege;
	
	/**
	 * Roles which have this privilege assigned to them
	 */
	private List<OpusRolePrivilege> roles;

	public OpusPrivilege getPrivilege() {
		return privilege;
	}

	public void setPrivilege(OpusPrivilege privilege) {
		this.privilege = privilege;
	}

	public List<OpusRolePrivilege> getRoles() {
		return roles;
	}

	public void setRoles(List<OpusRolePrivilege> roles) {
		this.roles = roles;
	}
	
	
}
