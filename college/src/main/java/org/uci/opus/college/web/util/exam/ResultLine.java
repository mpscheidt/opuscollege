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

package org.uci.opus.college.web.util.exam;

import java.util.List;

import org.uci.opus.college.domain.result.IResult;

public class ResultLine<T extends IResult> {

    protected String studyPlanDescription;
    private String studyPlanStatusCode;
    protected List<T> results;
    protected List<T> resultsInDB; // a copy of results, which keep the unchanged values
    protected boolean subResultsFound;
    protected String subResultsString;
    protected String surnameFull;
    protected String firstnamesFull;
    protected int studentId;
    private String studentCode;
    private boolean exempted;

    public String getStudyPlanDescription() {
        return studyPlanDescription;
    }

    public void setStudyPlanDescription(String studyPlanDescription) {
        this.studyPlanDescription = studyPlanDescription;
    }

    public List<T> getResults() {
        return results;
    }

    public void setResults(List<T> results) {
        this.results = results;
    }

    public int getNrOfResults() {
        return results == null ? 0 : results.size();
    }

    public boolean isResultsFound() {
        return getNrOfResults() > 0;
    }

    public boolean isSubResultsFound() {
        return subResultsFound;
    }

    public void setSubResultsFound(boolean subResultsFound) {
        this.subResultsFound = subResultsFound;
    }

    public String getSubResultsString() {
        return subResultsString;
    }

    public void setSubResultsString(String subResultsString) {
        this.subResultsString = subResultsString;
    }

    public String getSurnameFull() {
        return surnameFull;
    }

    public void setSurnameFull(String surnameFull) {
        this.surnameFull = surnameFull;
    }

    public String getFirstnamesFull() {
        return firstnamesFull;
    }

    public void setFirstnamesFull(String firstnamesFull) {
        this.firstnamesFull = firstnamesFull;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public List<T> getResultsInDB() {
        return resultsInDB;
    }

    public void setResultsInDB(List<T> resultsInDB) {
        this.resultsInDB = resultsInDB;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public boolean isExempted() {
        return exempted;
    }

    public void setExempted(boolean exempted) {
        this.exempted = exempted;
    }

    public String getStudyPlanStatusCode() {
        return studyPlanStatusCode;
    }

    public void setStudyPlanStatusCode(String studyPlanStatusCode) {
        this.studyPlanStatusCode = studyPlanStatusCode;
    }

}
