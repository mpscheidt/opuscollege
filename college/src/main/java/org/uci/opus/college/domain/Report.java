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

package org.uci.opus.college.domain;

import java.io.Serializable;

/**
 * @author smacumbe
 *
 */
public class Report implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * A unique number that identifies this report
     */
    private int id;
    /**
     * The report name is the same as the file name e.g. StudentProfile(.jasper) , AdmissionLetter(.jasper)
     */
    private String name;
    /**
     * The group the report belongs to , e.g. Student , study plan , statistics
     */
    private String group;
    private String active;
    /**
     * An explanation of what the report does
     */
    private String description;
    /**
     * List of customizable properties
     */
    private ReportProperty[] properties;

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name
     *            the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the group
     */
    public String getGroup() {
        return group;
    }

    /**
     * @param group
     *            the group to set
     */
    public void setGroup(String group) {
        this.group = group;
    }

    /**
     * @return the active
     */
    public String getActive() {
        return active;
    }

    /**
     * @param active
     *            the active to set
     */
    public void setActive(String active) {
        this.active = active;
    }

    /**
     * @return the properties
     */
    public ReportProperty[] getProperties() {
        return properties;
    }

    /**
     * @param properties
     *            the properties to set
     */
    public void setProperties(ReportProperty[] properties) {
        this.properties = properties;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description
     *            the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Gets a property of a report given its name.
     * 
     * @param name
     * @return
     */
    public ReportProperty getProperty(String name) {

        ReportProperty property = null;

        for (int i = 0; i < properties.length; i++) {
            property = properties[i];

            if (property.getName().equals(name)) {
                break;
            }

        }

        return property;
    }

    /**
     * Verifies if a report has a property.
     * 
     * @param name
     * @return
     */
    public boolean hasProperty(String name) {

        ReportProperty property = null;

        for (int i = 0; i < properties.length; i++) {
            property = properties[i];

            if (property.getName().equals(name)) {
                return true;
            }

        }

        return false;
    }

    /**
     * Gets a property given its id.
     * 
     * @param id
     * @return
     */
    public ReportProperty getPropertyById(int id) {

        ReportProperty property = null;

        for (int i = 0; i < properties.length; i++) {
            property = properties[i];

            if (property.getId() == id) {
                break;
            }
        }

        return property;
    }
}
