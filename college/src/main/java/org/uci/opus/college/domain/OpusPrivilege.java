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

import java.io.Serializable;

/**
 * @author Stelio Macumbe - Oct 7, 2010
 * @author Markus Pscheidt
 */
public class OpusPrivilege implements Serializable {

    private static final long serialVersionUID = 1L;

    public static String ADMINISTER_SYSTEM = "ADMINISTER_SYSTEM";
    public static String CREATE_CARDINALTIMEUNIT_RESULTS = "CREATE_CARDINALTIMEUNIT_RESULTS";
    public static String CREATE_INSTITUTIONS = "CREATE_INSTITUTIONS";
    public static String CREATE_RESULTS_ASSIGNED_SUBJECTS = "CREATE_RESULTS_ASSIGNED_SUBJECTS";
    public static String CREATE_SUBJECTS_RESULTS = "CREATE_SUBJECTS_RESULTS";
    public static String DELETE_CARDINALTIMEUNIT_RESULTS = "DELETE_CARDINALTIMEUNIT_RESULTS";
    public static String DELETE_RESULTS_ASSIGNED_SUBJECTS = "DELETE_RESULTS_ASSIGNED_SUBJECTS";
    public static String DELETE_SUBJECTS_RESULTS = "DELETE_SUBJECTS_RESULTS";

    /**
     * This privilege means that results can be edited in time units with a non-empty progress status.
     * 
     * <p>
     * This should be done in exceptional cases only, since setting a progress status indicates that the time unit has been finalized.
     */
    public static String EDIT_HISTORIC_RESULTS = "EDIT_HISTORIC_RESULTS";

    public static String GENERATE_STUDENT_REPORTS = "GENERATE_STUDENT_REPORTS";
    public static String READ_CARDINALTIMEUNIT_RESULTS = "READ_CARDINALTIMEUNIT_RESULTS";
    public static String READ_OWN_EXAMINATION_RESULTS = "READ_OWN_EXAMINATION_RESULTS";
    public static String READ_STUDENTS = "READ_STUDENTS";
    public static String READ_OWN_SUBJECT_RESULTS = "READ_OWN_SUBJECT_RESULTS";
    public static String READ_OWN_TEST_RESULTS = "READ_OWN_TEST_RESULTS";
    public static String READ_RESULTS_ASSIGNED_SUBJECTS = "READ_RESULTS_ASSIGNED_SUBJECTS";
    public static String READ_SUBJECTS_RESULTS = "READ_SUBJECTS_RESULTS";
    public static String UPDATE_CARDINALTIMEUNIT_RESULTS = "UPDATE_CARDINALTIMEUNIT_RESULTS";
    public static String UPDATE_RESULTS_ASSIGNED_SUBJECTS = "UPDATE_RESULTS_ASSIGNED_SUBJECTS";
    public static String UPDATE_SUBJECTS_RESULTS = "UPDATE_SUBJECTS_RESULTS";

    public static final String READ_INSTITUTIONS = "READ_INSTITUTIONS";
    public static final String READ_BRANCHES = "READ_BRANCHES";
    public static final String READ_ORG_UNITS = "READ_ORG_UNITS";

    public static final String UPDATE_INSTITUTIONS = "UPDATE_INSTITUTIONS";
    public static final String UPDATE_BRANCHES = "UPDATE_BRANCHES";
    public static final String UPDATE_ORG_UNITS = "UPDATE_ORG_UNITS";

    private int id;
    private String code;
    private String lang;
    private String active;
    private String description;
    private String writeWho;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getWriteWho() {
        return writeWho;
    }

    public void setWriteWho(String writeWho) {
        this.writeWho = writeWho;
    }

}
