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

import java.util.ArrayList;
import java.util.List;

public class ActiveStudentsPerStudy {

    private String organizationalUnitDescription;
    private String academicYear;
    private String study;
    private String city;
    private String gradeType;
    private int male;
    private int female;
    private int unknown;


    public ActiveStudentsPerStudy() {

    }


    public String getOrganizationalUnitDescription() {
        return organizationalUnitDescription;
    }
    public void setOrganizationalUnitDescription(
            String organizationalUnitDescription) {
        this.organizationalUnitDescription = organizationalUnitDescription;
    }
    public String getAcademicYear() {
        return academicYear;
    }


    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }


    public String getStudy() {
        return study;
    }
    public void setStudy(String study) {
        this.study = study;
    }
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getGradeType() {
        return gradeType;
    }
    public void setGradeType(String gradeType) {
        this.gradeType = gradeType;
    }
    public int getMale() {
        return male;
    }
    public void setMale(int male) {
        this.male = male;
    }
    public int getFemale() {
        return female;
    }
    public void setFemale(int female) {
        this.female = female;
    }
    public int getUnknown() {
        return unknown;
    }
    public void setUnknown(int unknown) {
        this.unknown = unknown;
    }

    public static List<ActiveStudentsPerStudy> createBeanCollection() {

        List<ActiveStudentsPerStudy> list = new ArrayList<ActiveStudentsPerStudy>();

        ActiveStudentsPerStudy item = new ActiveStudentsPerStudy();
        item.setOrganizationalUnitDescription("Moz Uni");
        item.setAcademicYear("2008");
        item.setStudy("Theology");
        item.setCity("Pemba");
        item.setGradeType("bachelor");
        item.setMale(2);
        item.setFemale(3);
        item.setUnknown(4);
        list.add(item);

        return list;
    }
}
