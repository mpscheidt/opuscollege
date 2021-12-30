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

package org.uci.opus.college.domain;

import org.apache.commons.lang3.StringUtils;

/**
 * Country.
 * 
 * @author move
 *
 */
public class Lookup3 extends Lookup implements GeonameLookup {

    private static final long serialVersionUID = 1L;

    private String short2;
    private String short3;
    private Integer geonameId;
    
    public Lookup3() {
        super();
    }

    public Lookup3(String lang, String code, String description) {
        super(lang, code, description);
    }

    public Lookup3(String lang, String code, String description, String short2, Integer geonameId) {
        super(lang, code, description);
        this.short2 = short2;
        this.geonameId = geonameId;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("Lookup3 [getId()=");
        builder.append(getId());
        builder.append(", getLang()=");
        builder.append(getLang());
        builder.append(", getCode()=");
        builder.append(getCode());
        builder.append(", getDescription()=");
        builder.append(getDescription());
        builder.append(", getActive()=");
        builder.append(getActive());
        builder.append(", short2=");
        builder.append(short2);
        builder.append(", short3=");
        builder.append(short3);
        builder.append(", geonameId=");
        builder.append(geonameId);
        builder.append("]");
        return builder.toString();
    }

    public String getShort2() {
        return short2;
    }

    public void setShort2(String newShort2) {
        short2 = StringUtils.trim(newShort2);
    }

    public String getShort3() {
        return short3;
    }

    public void setShort3(String newShort3) {
        short3 = StringUtils.trim(newShort3);
    }

    @Override
    public Integer getGeonameId() {
        return geonameId;
    }

    @Override
    public void setGeonameId(Integer geonameId) {
        this.geonameId = geonameId;
    }

}
