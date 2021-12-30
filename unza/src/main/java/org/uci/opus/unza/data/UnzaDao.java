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
package org.uci.opus.unza.data;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.unza.domain.FinancialRequest;

/**
 * @author Markus Pscheidt
 */
public class UnzaDao extends SqlMapClientDaoSupport implements UnzaDaoInterface {

    private static Logger log = Logger.getLogger(UnzaDao.class);

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findHighestStudentCodeRunningNumber(String)
     */
    public String findHighestStudentCodeRunningNumber(String year) {
        String currentHighestCode = null;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("year", year);

        try {
            currentHighestCode = (String) getSqlMapClient().queryForObject("Unza.findHighestStudentCodeRunningNumber", map);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return currentHighestCode;
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findFinancialRequest(String)
     */
    public FinancialRequest findFinancialRequest(final String financialRequestId) {
        FinancialRequest financialRequest = null;

        try {
            financialRequest = (FinancialRequest) getSqlMapClient().queryForObject("Unza.findFinancialRequest", financialRequestId);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return financialRequest;
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findHighestFinancialVersion(String)
     */
    public int findHighestFinancialRequestVersion(final String financialRequestId) {
        // int requestVersion = 0;
        Integer requestVersion = 0;
        try {
            requestVersion = (Integer) getSqlMapClient().queryForObject("Unza.findHighestFinancialRequestVersion", financialRequestId);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        requestVersion = requestVersion == null ? 0 : requestVersion;
        return requestVersion;
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#addFinancialRequest(FinancialRequest)
     */
    public final void addFinancialRequest(final FinancialRequest financialRequest) {
        int financialRequestId = (Integer) getSqlMapClientTemplate().insert("Unza.addFinancialRequest", financialRequest);

        financialRequest.setId(financialRequestId);

        getSqlMapClientTemplate().insert("Unza.addFinancialRequestHistory", financialRequest);
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#updateFinancialRequest(FinancialRequest)
     */
    public final void updateFinancialRequest(final FinancialRequest financialRequest) {
        getSqlMapClientTemplate().update("Unza.updateFinancialRequest", financialRequest);

        getSqlMapClientTemplate().insert("Unza.updateFinancialRequestHistory", financialRequest);
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findHighestFinancialRequest(String)
     */
    public FinancialRequest findHighestFinancialRequest(final String financialRequestId) {
        // int requestVersion = 0;
        FinancialRequest request = null;
        try {
            request = (FinancialRequest) getSqlMapClient().queryForObject("Unza.findHighestFinancialRequest", financialRequestId);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return request;
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findFinancialRequests()
     */
    public List<FinancialRequest> findFinancialRequests() {
        List<FinancialRequest> financialRequests = null;

        try {
            financialRequests = (List<FinancialRequest>) getSqlMapClient().queryForList("Unza.findFinancialRequests");

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return financialRequests;
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.uci.opus.unza.data.UnzaDaoInterface#findFinancialRequestsByStatusCode()
     */
    public List<FinancialRequest> findFinancialRequestsBySelection(Map selection) {
        List<FinancialRequest> financialRequests = null;

        try {
            financialRequests = (List<FinancialRequest>) getSqlMapClient().queryForList("Unza.findFinancialRequestsBySelection", selection);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return financialRequests;
    }

    public StudyPlan findStudyPlanByParams(HashMap map) {
        StudyPlan studyPlan = null;

        studyPlan = (StudyPlan) getSqlMapClientTemplate().queryForObject("Student.findStudyPlanByParamsUnza", map);

        return studyPlan;
    }

    @Override
    public String findHighestSponsorInvoiceNumber(String prefix) {
        String sponsorInvoiceNumber = (String) getSqlMapClientTemplate().queryForObject("Unza.findHighestSponsorInvoiceNumber", prefix);
        return sponsorInvoiceNumber;
    }

    @Override
    public String findHighestSponsorReceiptNumber(String prefix) {
        String sponsorReceiptNumber = (String) getSqlMapClientTemplate().queryForObject("Unza.findHighestSponsorReceiptNumber", prefix);
        return sponsorReceiptNumber;
    }
}
