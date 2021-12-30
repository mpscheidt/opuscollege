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

import java.util.List;

/**
 * @author move
 *
 */
public class ScholarshipStudentData {

    private int scholarshipStudentId; //redundant but useful
    private int bankId;
    private String account;
    private boolean accountActivated;
    private List < ScholarshipApplication > scholarships;
    private List < Subsidy > subsidies;
    private List < Complaint > complaints;

    /**
     * data of a student who has appplied for one or more scholarships
     */
    public ScholarshipStudentData() {
        super();
    }

    public List<ScholarshipApplication> getScholarships() {
        return scholarships;
    }

    public void setScholarships(final List<ScholarshipApplication> scholarships) {
        this.scholarships = scholarships;
    }

    public List < Subsidy > getSubsidies() {
        return subsidies;
    }
    public void setSubsidies(final List < Subsidy > subsidies) {
        this.subsidies = subsidies;
    }
    public boolean getAccountActivated() {
        return accountActivated;
    }
    public void setAccountActivated(final boolean accountActivated) {
        this.accountActivated = accountActivated;
    }

    public int getScholarshipStudentId() {
        return scholarshipStudentId;
    }

    public void setScholarshipStudentId(final int scholarshipStudentId) {
        this.scholarshipStudentId = scholarshipStudentId;
    }

    public int getBankId() {
        return bankId;
    }

    public void setBankId(int bankId) {
        this.bankId = bankId;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(final String account) {
        this.account = account;
    }

    public List<Complaint> getComplaints() {
        return complaints;
    }

    public void setComplaints(final List<Complaint> complaints) {
        this.complaints = complaints;
    }

}
