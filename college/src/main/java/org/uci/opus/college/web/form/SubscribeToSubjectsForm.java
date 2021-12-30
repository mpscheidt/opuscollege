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

package org.uci.opus.college.web.form;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SubscribeToSubjectsForm {

    private List<Integer> subjectBlockIds;
    private List<Integer> subjectIds;
    private List<Integer> selectedStudyPlanCTUIds;
    private String cardinalTimeUnitStatusCode;
    private String originalCardinalTimeUnitStatusCode;
    private String rfcText;
    private Map<Integer, String> rfcComments = new HashMap<Integer, String>();
    private Map<Integer, String> rfcTexts = new HashMap<Integer, String>();
    private boolean editSubscription;
    
    
    public List<Integer> getSubjectBlockIds() {
        if (subjectBlockIds == null) {
            subjectBlockIds = new ArrayList<Integer>();   // form needs non-null collection
        }
        return subjectBlockIds;
    }
    public void setSubjectBlockIds(List<Integer> subjectBlockIds) {
        this.subjectBlockIds = subjectBlockIds;
    }
    public List<Integer> getSubjectIds() {
        if (subjectIds == null) {
            subjectIds = new ArrayList<Integer>();    // form needs non-null collection
        }
        return subjectIds;
    }
    public void setSubjectIds(List<Integer> subjectIds) {
        this.subjectIds = subjectIds;
    }
    public List<Integer> getSelectedStudyPlanCTUIds() {
        if (selectedStudyPlanCTUIds == null) {
            selectedStudyPlanCTUIds = new ArrayList<Integer>();    // form needs non-null collection
        }
        return selectedStudyPlanCTUIds;
    }
    public void setSelectedStudyPlanCTUIds(
            List<Integer> selectedStudyPlanCTUIds) {
        this.selectedStudyPlanCTUIds = selectedStudyPlanCTUIds;
    }
    public void setCardinalTimeUnitStatusCode(String cardinalTimeUnitStatusCode) {
        this.cardinalTimeUnitStatusCode = cardinalTimeUnitStatusCode;
    }
    public String getCardinalTimeUnitStatusCode() {
        return cardinalTimeUnitStatusCode;
    }
    public void setRfcText(String rfcText) {
        this.rfcText = rfcText;
    }
    public String getRfcText() {
        return rfcText;
    }
    public void setOriginalCardinalTimeUnitStatusCode(
            String originalCardinalTimeUnitStatusCode) {
        this.originalCardinalTimeUnitStatusCode = originalCardinalTimeUnitStatusCode;
    }
    public String getOriginalCardinalTimeUnitStatusCode() {
        return originalCardinalTimeUnitStatusCode;
    }
    public void setRfcComments(Map<Integer, String> rfcComments) {
        this.rfcComments = rfcComments;
    }
    public Map<Integer, String> getRfcComments() {
        return rfcComments;
    }
    public void setRfcTexts(Map<Integer, String> rfcTexts) {
        this.rfcTexts = rfcTexts;
    }
    public Map<Integer, String> getRfcTexts() {
        return rfcTexts;
    }
    public boolean isEditSubscription() {
        return editSubscription;
    }
    public void setEditSubscription(boolean editSubscription) {
        this.editSubscription = editSubscription;
    }
}
