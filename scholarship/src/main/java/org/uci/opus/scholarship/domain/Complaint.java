/*******************************************************************************
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
 * The Original Code is Opus-College scholarship module code.
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
 ******************************************************************************/
package org.uci.opus.scholarship.domain;

import java.io.Serializable;
import java.util.Date;

public class Complaint implements Serializable {


    private int id;
    private Date complaintDate;
    private String reason;
    private String result;
    private String complaintStatusCode;
    private int scholarshipApplicationId;
    private String active;


    /**
     * @return the active
     */
    public String getActive() {
        return active;
    }


    /**
     * @param active the active to set
     */
    public void setActive(final String active) {
        this.active = active;
    }


    public int getId() {
        return id;
    }


    public void setId(final int id) {
        this.id = id;
    }


    public Date getComplaintDate() {
        return complaintDate;
    }


    public void setComplaintDate(final Date complaintDate) {
        this.complaintDate = complaintDate;
    }


    public String getReason() {
        return reason;
    }


    public void setReason(final String reason) {
        this.reason = reason;
    }


    public String getResult() {
        return result;
    }


    public void setResult(final String result) {
        this.result = result;
    }


    public String getComplaintStatusCode() {
        return complaintStatusCode;
    }


    public void setComplaintStatusCode(final String complaintStatusCode) {
        this.complaintStatusCode = complaintStatusCode;
    }


    public int getScholarshipApplicationId() {
        return scholarshipApplicationId;
    }


    public void setScholarshipApplicationId(final int scholarshipApplicationId) {
        this.scholarshipApplicationId = scholarshipApplicationId;
    }




}
