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

package org.uci.opus.college.security;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

public class AuthenticationWrapper implements Authentication {
	private Authentication original;
	private List<GrantedAuthority> privileges;
	private String name;
	private Object credentials;
	private Object details;
	private Object principal;
	private boolean isAuthenticated;

	public AuthenticationWrapper(Authentication original,
			List<GrantedAuthority> privileges) {
		this.original = original;
		this.privileges = privileges;
		this.name = original.getName();
		this.credentials = original.getCredentials();
		this.details = original.getDetails();
		this.principal = original.getPrincipal();
		this.isAuthenticated = original.isAuthenticated();
	}

	public List<GrantedAuthority> getAuthorities() {
		// Collection<GrantedAuthority> originalPrivileges =
		// original.getAuthorities();

		// privileges.addAll(originalPrivileges);

		return privileges;

	}

	/*
	 * public String getName() { return original.getName(); } public Object
	 * getCredentials() { return original.getCredentials(); } public Object
	 * getDetails() { return original.getDetails(); } public Object
	 * getPrincipal() { return original.getPrincipal(); } public boolean
	 * isAuthenticated() { return original.isAuthenticated(); } public void
	 * setAuthenticated( boolean isAuthenticated ) throws
	 * IllegalArgumentException { original.setAuthenticated( isAuthenticated );
	 * }
	 */

	public Authentication getOriginal() {
		return original;
	}

	public void setOriginal(Authentication original) {
		this.original = original;
	}

	public List<GrantedAuthority> getPrivileges() {
		return privileges;
	}

	public void setPrivileges(List<GrantedAuthority> privileges) {
		this.privileges = privileges;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Object getCredentials() {
		return credentials;
	}

	public void setCredentials(Object credentials) {
		this.credentials = credentials;
	}

	public Object getDetails() {
		return details;
	}

	public void setDetails(Object details) {
		this.details = details;
	}

	public Object getPrincipal() {
		return principal;
	}

	public void setPrincipal(Object principal) {
		this.principal = principal;
	}

	public boolean isAuthenticated() {
		return isAuthenticated;
	}

	public void setAuthenticated(boolean isAuthenticated) {
		this.isAuthenticated = isAuthenticated;
	}

}
