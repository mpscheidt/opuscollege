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
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.report.domain;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * @author stelio2
 *Jan 13, 2010
 *An object for creating response for AJax requests , it contains a toJSON method
 *that converts this object to a JSON format. 
 */

public class ReportJSON {

    private List items;
    private Map<String , Object> parameters;
    private Gson gson;

    public ReportJSON(List items, Map<String, Object> parameters, Gson gson) {
        super();
        this.items = items;
        this.parameters = parameters;
        this.gson = gson;
    }
    /**
     * @return the items
     */
    public List getItems() {
        return items;
    }
    /**
     * @param items the items to set
     */
    public void setItems(List items) {
        this.items = items;
    }
    /**
     * @return the parameters
     */
    public Map<String, Object> getParameters() {
        return parameters;
    }
    /**
     * @param parameters the parameters to set
     */
    public void setParameters(Map<String, Object> parameters) {
        this.parameters = parameters;
    }
    /**
     * @return the gson
     */
    public Gson getGson() {
        return gson;
    }
    /**
     * @param gson the gson to set
     */
    public void setGson(Gson gson) {
        this.gson = gson;
    }

    public String toJSON() {
        StringBuffer json = new StringBuffer();
        StringBuffer itemsBuffer = new StringBuffer("([");
        StringBuffer parametersBuffer = new StringBuffer();

        if (gson == null) {
            gson = new Gson();
        }

        //converts items to JSON
        if (items != null) {
            for (Iterator it = items.iterator(); it.hasNext();) {
                String json2 = gson.toJson(it.next());
                itemsBuffer.append(json2);
                if (it.hasNext()) {
                    itemsBuffer.append(",");
                }
            }
        }

        itemsBuffer.append("])");

        //converts parameters to JSON
        parametersBuffer.append("{");
        if (parameters != null) {
            for (Iterator<Map.Entry<String, Object>> it = parameters.entrySet()
                    .iterator(); it.hasNext();) {
                Map.Entry<String, Object> entry = (Map.Entry<String, Object>) it
                .next();

                parametersBuffer.append("\"" + entry.getKey() + "\"" + " : "
                        + "\"" + gson.toJson(entry.getValue()) + "\"");

                if (it.hasNext()) {
                    parametersBuffer.append(",");
                }
            }
        }
        parametersBuffer.append("}");

        json.append("({");
        json.append("items: " + itemsBuffer.toString());
        json.append(",");
        json.append("params: " + parametersBuffer.toString());
        json.append("})");

        return json.toString();
    }
}
