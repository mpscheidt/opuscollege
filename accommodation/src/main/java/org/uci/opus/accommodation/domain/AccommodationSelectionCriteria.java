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
package org.uci.opus.accommodation.domain;

import java.util.Date;

public class AccommodationSelectionCriteria {
	private Integer id;
	private String code;
	private String description;
	private int weight;
	private String language;
	private Date writeWhen;
	private String writeWho;
	private char active='Y';
	private String lang;
	/**
	 *Gets the ID
	 * @return
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * Sets the ID
	 * @param id
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * Gets the Code
	 * @return
	 */
	public String getCode() {
		return code;
	}

	/**
	 * Sets the Code
	 * @param code
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * Gets the Description or Name
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * Sets the Description or Name
	 * @param description
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * Gets the weight to the selection criteria
	 * @return
	 */
	public int getWeight() {
		return weight;
	}

	/**
	 * Sets the weight of the selection criteria
	 * @param weight
	 */
	public void setWeight(int weight) {
		this.weight = weight;
	}

	/**
	 * Gets the Locale language
	 * @return
	 */
	public String getLanguage() {
		return language;
	}

	/**
	 * Sets the Locale language
	 * @param language
	 */
	public void setLanguage(String language) {
		this.language = language;
	}

	/**
	 * Gets the Date when the record was first written to the database
	 * @return
	 */
	public Date getWriteWhen() {
		return writeWhen;
	}

	/**
	 * Sets the Date when the record was first written to the database
	 * @param writeWhen
	 */
	public void setWriteWhen(Date writeWhen) {
		this.writeWhen = writeWhen;
	}

	/**
	 * Gets the application application or user which persisted the data to the database
	 * @return
	 */
	public String getWriteWho() {
		return writeWho;
	}

	/**
	 * Sets the application or user who will persist the data to the database
	 * @param writeWho
	 */
	public void setWriteWho(String writeWho) {
		this.writeWho = writeWho;
	}

	/**
	 * Gets the state of the selection criteria
	 * @return
	 */
	public char getActive() {
		return active;
	}

	/**
	 * Sets the state of the selection criteria. Possible values are 'Y' and 'N'
	 * Default value is 'Y'
	 * 
	 * @param active
	 */
	public void setActive(char active) {
		if (active == 'Y' || active == 'N') {
            this.active = active;
        } else {
            throw new IllegalArgumentException("Invalid Argument! The value can either be 'Y' or 'N'");
        }
	}
	/**
	 * Gets the locale - language
	 * @return
	 */
	public String getLang() {
		return lang;
	}
	/**
	 * Sets the locale - language
	 * @param lang
	 */
	public void setLang(String lang) {
		this.lang = lang;
	}
	
	
}