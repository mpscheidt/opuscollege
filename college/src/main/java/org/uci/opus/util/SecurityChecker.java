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

package org.uci.opus.util;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.web.user.OpusSecurityException;

/**
 * @author gena
 * Check usersession specific security.
 *
 */
public class SecurityChecker {

    private static Logger log = LoggerFactory.getLogger(SecurityChecker.class);
    private static Logger securityLog = LoggerFactory.getLogger("SECURITY." + SecurityChecker.class.getName());

    /**
     * Check if there is a user session with a OpusUser object.
     * @param usersession   given session, filled or null
     */
    public void checkSessionValid(final HttpSession usersession) {

        if (usersession != null) {

//            OpusUser opusUser = (OpusUser) usersession.getAttribute("opusUser");
            OpusUser opusUser = (OpusUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            
            if (opusUser == null) {
                String err = "opusUser object is null";
                securityLog.warn(err);
                throw new OpusSecurityException(err);
            }
        } else {
            String err = "session object is null";
            securityLog.warn(err);
            throw new OpusSecurityException(err);
        }
    }

    /**
     * Compare user submitted personId with session personId to see if
     * the user is not trying to mess with other people's data.
     * 
     * @param usersession   given session
     * @param personId user submitted personId.
     */
    public void checkPersonIdValid(final HttpSession usersession, final String personId) {

        if (usersession != null) {
            
//            OpusUser opusUser = (OpusUser) usersession.getAttribute("opusUser");
            OpusUser opusUser = (OpusUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            if (opusUser != null) {
                
                int sessionPersonId = opusUser.getPersonId();                
                
                if (personId != null && personId.equals(sessionPersonId)) {
                    // continue
                } else {
                    String err = "Someone trying to get illegal access for personId: '" + personId 
                           + "' using personId: '" + sessionPersonId + "'";
                    securityLog.warn(err);
                    throw new OpusSecurityException(err);
                }
            } else {
                throw new OpusSecurityException("opusUser object is null");
            }
        } else {
            throw new OpusSecurityException("user session is null");
        }
    }
    
    /**
     * Compare user submitted userId with session userId to see if
     * the user is not trying to mess with other people's data.
     *  
     * @param usersession   given session
     * @param userId user submitted userId.
     * @return if userId is valid.
     */
    public boolean isValidUserId(final HttpSession usersession, final String userId) {

        if (usersession != null) {
            
//            OpusUser opusUser = (OpusUser) usersession.getAttribute("opusUser");
            OpusUser opusUser = (OpusUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            if (opusUser != null) {
                
                int sessionPersonId = opusUser.getPersonId();                
                
                if (userId != null && userId.equals(sessionPersonId)) {
                    return true;
                } else {
                    securityLog.warn(" Someone trying to get illegal access for userId: '" + userId 
                           + "' using userId: '" + sessionPersonId + "'");
                }
            }
        }
        return false;
    }  
    
    
}
