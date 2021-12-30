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
 * The Original Code is Opus-College unza module code.
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
package org.uci.opus.unza.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.unza.data.UnzaDaoInterface;
import org.uci.opus.unza.domain.FinancialRequest;

/**
 * @author Markus Pscheidt
 */
public class UnzaManager implements UnzaManagerInterface {

    private static Logger log = Logger.getLogger(UnzaManager.class);
    @Autowired
    private UnzaDaoInterface unzaDao;

    public UnzaManager() {
    }

    /**
     * @param year
     * @return Highest student code running number
     */
    public String findHighestStudentCodeRunningNumber(String year) {
        return unzaDao.findHighestStudentCodeRunningNumber(year);
    }

    /**
     * @param financialRequestId
     * @return FinancialRequest record
     */
    public FinancialRequest findFinancialRequest(String financialRequestId) {
        return unzaDao.findFinancialRequest(financialRequestId);
    }

    /**
     * @param FinancialRequestId
     * @return highest FinancialRequest version
     */
    public int findHighestFinancialRequestVersion(String financialRequestId) {
        return unzaDao.findHighestFinancialRequestVersion(financialRequestId);
    }

    /**
     * @param FinancialRequest record
     * @return
     */
    public void addFinancialRequest(FinancialRequest financialRequest) {
        unzaDao.addFinancialRequest(financialRequest);
    }

    /**
     * @param FinancialRequest
     *            record
     * @return
     */
    public void updateFinancialRequest(FinancialRequest financialRequest) {
        unzaDao.updateFinancialRequest(financialRequest);
    }

    /**
     * @param financialRequestId
     * @return FinancialRequest record
     */
    public FinancialRequest findHighestFinancialRequest(String financialRequestId) {
        return unzaDao.findHighestFinancialRequest(financialRequestId);
    }

    /**
     * @param
     * @return List<FinancialRequest>
     */
    public List<FinancialRequest> findFinancialRequests() {
        return unzaDao.findFinancialRequests();
    }

    /**
     * @param
     * @return List<FinancialRequest>
     */
    public List<FinancialRequest> findFinancialRequestsBySelection(Map selection) {
        return unzaDao.findFinancialRequestsBySelection(selection);
    }

    @Override
    public String findHighestSponsorInvoiceNumber(String prefix) {
        return unzaDao.findHighestSponsorInvoiceNumber(prefix);
    }

    @Override
    public String findHighestSponsorReceiptNumber(String prefix) {
        return unzaDao.findHighestSponsorReceiptNumber(prefix);
    }
}
