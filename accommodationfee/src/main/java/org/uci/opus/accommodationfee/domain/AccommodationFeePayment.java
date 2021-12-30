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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2011
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
package org.uci.opus.accommodationfee.domain;

import java.math.BigDecimal;
import java.util.Date;

public class AccommodationFeePayment {
	private int id;
	private int studentAccommodationId;
	private int accommodationId;
	private BigDecimal amountPaid;
	private Date datePaid;
	private int paidTo;
	private Date writeWhen;
	private String writeWho;

	/**
	 * Gets the ID
	 * @return
	 */
	public int getId() {
		return id;
	}

	/**
	 * Sets the ID
	 * @param id
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * Gets StudentAccommodationID
	 * @return
	 */
	public int getStudentAccommodationId() {
		return studentAccommodationId;
	}

	/**
	 * Sets the StudentAccommodationID
	 * @param studentAccommationId
	 */
	public void setStudentAccommodationId(int studentAccommodationId) {
		this.studentAccommodationId = studentAccommodationId;
	}

	/**
	 * Gets the AccommodationID
	 * @return
	 */
	public int getAccommodationId() {
		return accommodationId;
	}

	/**
	 * Sets the AccommodationID
	 * @param accommodationId
	 */
	public void setAccommodationId(int accommodationId) {
		this.accommodationId = accommodationId;
	}

	/**
	 * Get the AmountPaid for the accommodation
	 * @return
	 */
	public BigDecimal getAmountPaid() {
		return amountPaid;
	}

	/**
	 * Sets the AmountPaid for the accommodation
	 * @param amountPaid
	 */
	public void setAmountPaid(BigDecimal amountPaid) {
		this.amountPaid = amountPaid;
	}

	/**
	 * Gets the Date when the fee was paid
	 * @return
	 */
	public Date getDatePaid() {
		return datePaid;
	}

	/**
	 * Sets the Date when the fee was paid
	 * @param datePaid
	 */
	public void setDatePaid(Date datePaid) {
		this.datePaid = datePaid;
	}

	/**
	 * Gets the ID of the Person to whom the fees where paid to
	 * @return
	 */
	public int getPaidTo() {
		return paidTo;
	}

	/**
	 * Sets the ID of the Person to whom the fees where paid to
	 * @param paidTo
	 */
	public void setPaidTo(int paidTo) {
		this.paidTo = paidTo;
	}

	/**
	 * Gets the Date when the data was persisted to the Database
	 * @return
	 */
	public Date getWriteWhen() {
		return writeWhen;
	}

	/**
	 * Sets the Date when the data was persisted to the Database
	 * @param writeWhen
	 */
	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}

	/**
	 * Sets the user or application which persisted the data to the Database
	 * @return
	 */
	public String getWriteWho() {
		return writeWho;
	}
	/**
	 * Sets the user or application which persisted the data to the Database
	 * @param writeWho
	 */
	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}
}