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
package org.uci.opus.scholarship.persistence;

import java.util.List;

import org.uci.opus.scholarship.domain.Bank;

public interface BankMapper {

    /**
     * Add a complete list of present banks.
     * @param
     * @return List of Bank objects or null;
     */    
    List<Bank> findBanks();

    /**
     * find a specific Bank
     * @param bankId
     * @return Bank object or null;
     */    
    Bank findBank(int bankId);

    /**
     * add a bank
     * @param bank to add
     * @return return id of the bank
     */
    void addBank(Bank bank);

    /**
     * update a bank
     * @param bank to be updated
     * @return
     */
    void updateBank(Bank bank);

    /**
     * delete a bank
     * @param bankId id of the bank to be deleted
     * @return
     */
    void deleteBank(int bankId);

}
