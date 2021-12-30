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
 * The Original Code is Opus-College fee module code.
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
package org.uci.opus.fee.service;

import java.util.List;
import java.util.Map;

import org.uci.opus.fee.domain.Payment;

/**
 * @author move
 *
 */
public interface PaymentManagerInterface {

    /**
     * Returns a list of payments from one student.
     * @param studentId id of the payments to find
     * @return List of payment-objects or null
     */    
    List<Payment> findPaymentsForStudent(final int studentId);

    /**
     * Returns payment by its id.
     * @param paymentId id of the Payment to find
     * @return Payment-object or null
     */    
    Payment findPayment(final int paymentId);

    /**
     * Returns payment by a number of parameters.
     * @param map with studentId, payDate and subject, subjectblock
     *     of the Payment to find
     * @return Payment-object or null
     */    
    Payment findPaymentByParams(final Map<String, Object> map);

    /**
     * Find payments.
     * @param map
     * @return
     */
    List<Payment> findPaymentsByParams(final Map<String, Object> map);
    
    /**
     * Returns nothing.
     * @param payment the payment to add
     * @param writeWho TODO
     * @return
     */    
    void addPayment(final Payment payment, String writeWho);

    /**
     * Returns nothing.
     * @param writeWho TODO
     * @param fee the payment to update
     * @return
     */    
    void updatePayment(final Payment payment, String writeWho);

    /**
     * Returns nothing.
     * @param paymentId of the payment to delete and who wrote it
     * @param writeWho TODO
     * @return
     */    
    void deletePayment(final int paymentId, String writeWho);

    /**
     * Delete all payments related to the given student balance.
     * @param studentBalanceId
     * @param writeWho TODO
     */
    void deletePaymentsForStudentBalance(int studentBalanceId, String writeWho);
    
}
