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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.service.OpusUserManagerInterface;

/**
 * This listener is called on failed login.
 * The failedLoginAttempts counter is increased in the opusUser table.
 * A comment is written to the security log.
 * @author markus
 *
 */

public class LoginFailureEventListener implements ApplicationListener<AuthenticationFailureBadCredentialsEvent> {

    private static Logger securityLog = LoggerFactory.getLogger("SECURITY." + LoginFailureEventListener.class);

    @Autowired private OpusUserManagerInterface opusUserManager;

    @Override
	public void onApplicationEvent(AuthenticationFailureBadCredentialsEvent loginFailureEvent) {
		String userName = (String) loginFailureEvent.getAuthentication().getPrincipal();
		OpusUser opusUser = null;
		if (userName != null && !userName.trim().isEmpty()) {
			opusUser = opusUserManager.findOpusUserByUserName(userName);
		}
				

		if (opusUser != null) {
	        securityLog.info("User '" + userName + "' failed to log in");

			// update the failed login count
			int failedLoginAttempts = opusUser.getFailedLoginAttempts();
			opusUser.setFailedLoginAttempts(++failedLoginAttempts);
			// update user
			opusUserManager.updateOpusUser(opusUser, opusUser.getPw());

	        securityLog.info("User '" + userName + "': failed login attempts = " + failedLoginAttempts);
		}
	}

}
