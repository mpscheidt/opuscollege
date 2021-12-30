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

package org.uci.opus.college.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.persistence.GeneralMapper;

/**
 * @author Stelio Macumbe Mar 14 , 2009
 */

public class GeneralManager implements GeneralManagerInterface {

    private static Logger log = LoggerFactory.getLogger(GeneralManager.class);

    private GeneralMapper generalMapper;
    
    @Autowired
    public GeneralManager(GeneralMapper generalMapper) {
        this.generalMapper = generalMapper;
    }

    @Override
    public <V, V2> void updateField(String tableName, String criteriaField, V2 criteriaValue, String field, V newValue) {

        generalMapper.updateField(tableName, criteriaField, criteriaValue, field, newValue);
    }

    @Override
    public <V> void updateField(String tableName, String criteriaField, V criteriaValue, Map<String, Object> fields) {

        for (Iterator<Map.Entry<String, Object>> it = fields.entrySet().iterator(); it.hasNext();) {
            Map.Entry<String, Object> entry = it.next();

            generalMapper.updateField(tableName, criteriaField, criteriaValue, (String) entry.getKey(), entry.getValue());

        }

    }

    @Override
    public String findMailConfigProperty(String msgType, String propertyName, String preferredLanguage) {

        Map<String, Object> params = new HashMap<>();

        params.put("msgType", msgType);
        params.put("propertyName", propertyName);
        params.put("preferredLanguage", preferredLanguage);

        return generalMapper.findMailConfigProperty(params);
    }

    @Override
    public void logMailError(String[] recipients, String subject, String from, String errorMsg) {

        Map<String, Object> params = new HashMap<>();

        String strRecipients = "";
        for (int i = 0; i < recipients.length; i++) {
            strRecipients = strRecipients + recipients[i];
        }
        params.put("recipients", strRecipients);
        params.put("msgSubject", subject);
        params.put("msgSender", from);
        params.put("errorMsg", errorMsg);

        generalMapper.logMailError(params);

    }

    @Override
    public void logRequestError(String ipAddress, String requestString, String errorMsg) {

        Map<String, Object> params = new HashMap<>();

        params.put("ipAddress", ipAddress);
        params.put("requestString", requestString);
        params.put("errorMsg", errorMsg);

        generalMapper.logRequestError(params);

    }

}
