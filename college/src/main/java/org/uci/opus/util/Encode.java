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

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author U595131
 * 
 * The MD5 encoder generates a Message Digest 5 Hashsum.
 */
public class Encode {
        
    private static Logger log = LoggerFactory.getLogger(Encode.class);    
    
    /**
     * Add characters to front of string until length is reached.
     * @param s string.
     * @param length string length that should be achieved
     * @param pad character to add in front
     * @return string with right length
     */
    private static String pad(final String s, final int length, final char pad) {
        
        StringBuffer buffer = new StringBuffer(s);  
        
        while (buffer.length() < length) { 
            buffer.insert(0, pad);  
        } 
        return buffer.toString();        
    }    
    
    /**
     * @param message is to be encoded
     * @return encoded message 
     */
    public static final String encodeMd5(final String message) {

        
        /**
         * Although it is possible that a particular JVM / application installation may
         * encounter NoSuchAlgorithmException when attempting to get a jce MD5 message
         * digest generator, the likelyhood is very small for almost all JDK/JRE 1.1
         * and later  JVM implementations, as the Sun java.security package has come,
         * by default, with a jce MD5 message digest generator since JDK 1.1 was
         * released. 
         */

        /**
         * The MD5 message digest generator.
         */
        try {

            MessageDigest md5 = MessageDigest.getInstance("MD5");
            md5.update(StandardCharsets.UTF_8.encode(message));
            
            // NB: important to use format so that leading zeros aren't truncated
            //     Thanks to Simone Mura for pointing out the leading zero issue
            return String.format("%032x", new BigInteger(1, md5.digest()));

        } catch (NoSuchAlgorithmException nsae) {
            log.error(" MD5 not available when we try to encode in Encode.java." + nsae);
            return "";
        }        
    }
}
