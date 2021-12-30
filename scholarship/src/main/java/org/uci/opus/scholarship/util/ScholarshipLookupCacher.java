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
package org.uci.opus.scholarship.util;

/**
 * @author MoVe
 *
 */


import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup6;
import org.uci.opus.college.service.LookupManagerInterface;

public class ScholarshipLookupCacher {
    
    private static Logger log = LoggerFactory.getLogger(ScholarshipLookupCacher.class);
    private LookupManagerInterface lookupManager;
    
    /* scholarships */
    private List<Lookup> allScholarshipTypes;
    private List<Lookup> allDecisionCriteria;
    private List<Lookup> allComplaintStatuses;
    private List<Lookup> allSubsidyTypes;
    private List<Lookup6> allSponsorTypes;

    public HttpServletRequest getScholarshipLookups(String preferredLanguage, HttpServletRequest request) {
        
        allScholarshipTypes = (List < Lookup>) request.getAttribute("allScholarshipTypes");
        if (allScholarshipTypes == null) {
            allScholarshipTypes = (List <Lookup >
                            ) lookupManager.findAllRows(preferredLanguage, "sch_scholarshipType");
        } else {
            if (allScholarshipTypes.size() == 0 || (allScholarshipTypes.size() != 0 
                        && !preferredLanguage.equals(allScholarshipTypes.get(0).getLang()))) {
                allScholarshipTypes = (List <Lookup>) 
                    lookupManager.findAllRows(preferredLanguage,"sch_scholarshipType");
            }
        }
        request.setAttribute("allScholarshipTypes", allScholarshipTypes);
 
        allDecisionCriteria = (List < Lookup>) request.getAttribute("allDecisionCriteria");
        if (allDecisionCriteria == null) {
            allDecisionCriteria = (List <Lookup >
                            ) lookupManager.findAllRows(preferredLanguage, "sch_decisionCriteria");
        } else {
            if (allDecisionCriteria.size() == 0 || (allDecisionCriteria.size() != 0 
                        && !preferredLanguage.equals(allDecisionCriteria.get(0).getLang()))) {
                allDecisionCriteria = (List <Lookup>) 
                    lookupManager.findAllRows(preferredLanguage,"sch_decisionCriteria");
            }
        }
        request.setAttribute("allDecisionCriteria", allDecisionCriteria);

        allComplaintStatuses = (List < Lookup>) request.getAttribute("allComplaintStatuses");
        if (allComplaintStatuses == null) {
            allComplaintStatuses = (List < Lookup >
                            ) lookupManager.findAllRows(preferredLanguage, "sch_complaintStatus");
        } else {
            if (allComplaintStatuses.size() == 0 || (allComplaintStatuses.size() != 0 
                        && !preferredLanguage.equals(allComplaintStatuses.get(0).getLang()))) {
                allComplaintStatuses = (List <Lookup>) 
                    lookupManager.findAllRows(preferredLanguage,"sch_complaintStatus");
            }
        }
        request.setAttribute("allComplaintStatuses", allComplaintStatuses);

        allSubsidyTypes = (List < Lookup>) request.getAttribute("allSubsidyTypes");
        if (allSubsidyTypes == null) {
            allSubsidyTypes = (List <Lookup >
                            ) lookupManager.findAllRows(preferredLanguage, "sch_subsidyType");
        } else {
            if (allSubsidyTypes.size() == 0 || (allSubsidyTypes.size() != 0 
                        && !preferredLanguage.equals(allSubsidyTypes.get(0).getLang()))) {
                allSubsidyTypes = (List <Lookup>) 
                    lookupManager.findAllRows(preferredLanguage,"sch_subsidyType");
            }
        }
        request.setAttribute("allSubsidyTypes", allSubsidyTypes);

        allSponsorTypes = (List < Lookup6>) request.getAttribute("allSponsorTypes");
        if (allSponsorTypes == null) {
            allSponsorTypes = lookupManager.findAllRows(preferredLanguage, "sch_sponsorType");
        } else {
            if (allSponsorTypes.size() == 0 || (allSponsorTypes.size() != 0 
                        && !preferredLanguage.equals(allSponsorTypes.get(0).getLang()))) {
                allSponsorTypes = lookupManager.findAllRows(preferredLanguage,"sch_sponsorType");
            }
        }
        request.setAttribute("allSponsorTypes", allSponsorTypes);

        return request;
    }

    /**
     * @param newLookupManager
     */
    public void setLookupManager(LookupManagerInterface newLookupManager) {
        lookupManager = newLookupManager;
    }

    public List<Lookup> getAllScholarshipTypes() {
        return allScholarshipTypes;
    }

    public void setAllScholarshipTypes(List<Lookup> allScholarshipTypes) {
        this.allScholarshipTypes = allScholarshipTypes;
    }

    public List<Lookup> getAllDecisionCriteria() {
        return allDecisionCriteria;
    }

    public void setAllDecisionCriteria(List<Lookup> allDecisionCriteria) {
        this.allDecisionCriteria = allDecisionCriteria;
    }

    public List<Lookup> getAllComplaintStatuses() {
        return allComplaintStatuses;
    }

    public void setAllComplaintStatuses(List<Lookup> allComplaintStatuses) {
        this.allComplaintStatuses = allComplaintStatuses;
    }

    public List<Lookup> getAllSubsidyTypes() {
        return allSubsidyTypes;
    }

    public void setAllSubsidyTypes(List<Lookup> allSubsidyTypes) {
        this.allSubsidyTypes = allSubsidyTypes;
    }

    public List<Lookup6> getAllSponsorTypes() {
        return allSponsorTypes;
    }

    public void setAllSponsorTypes(List<Lookup6> allSponsorTypes) {
        this.allSponsorTypes = allSponsorTypes;
    }

}
