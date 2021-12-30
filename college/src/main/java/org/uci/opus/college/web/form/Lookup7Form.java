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
import java.util.List;

import org.uci.opus.college.domain.Lookup7;

public class Lookup7Form {

	private NavigationSettings navigationSettings;
	
	private String txtErr;
	private String txtMsg;
	
	/**
	 * Lookups tied by code
	 */
	private List<Lookup7> lookups;
	
	private String lookupTable;
	private String lookupCode;
	private String lookupActive;	
	private String lookupContinuing;
	private String lookupIncrement;
	private String lookupGraduating;
	private String lookupCarrying;
    private List<String> appLanguagesShort = new ArrayList<>();

	public Lookup7Form() {
		txtErr = "";
		txtMsg = "";
	}

	
	/**
	 * @return the navigationSettings
	 */
	public NavigationSettings getNavigationSettings() {
		return navigationSettings;
	}
	/**
	 * @param navigationSettings the navigationSettings to set
	 */
	public void setNavigationSettings(final NavigationSettings navigationSettings) {
		this.navigationSettings = navigationSettings;
	}

	/**
	 * @return the txtErr
	 */
	public String getTxtErr() {
		return txtErr;
	}
	/**
	 * @param studyError the txtErr to set
	 */
	public void setTxtErr(final String txtErr) {
		this.txtErr = txtErr;
	}
	/**
	 * @return the txtMsg
	 */
	public String getTxtMsg() {
		return txtMsg;
	}
	/**
	 * @param txtMsg the txtMsg to set
	 */
	public void setTxtMsg(final String txtMsg) {
		this.txtMsg = txtMsg;
	}


	public List<Lookup7> getLookups() {
		return lookups;
	}


	public void setLookups(List<Lookup7> lookups) {
		this.lookups = lookups;
	}


	/**
	 * Creates a new set of languages with the specified languages
	 * @param languages
	 * @return this lookups
	 */
	public List<Lookup7> createNewLookups(List<String> languages){
		
		List<Lookup7> newLookups = new ArrayList<Lookup7>(languages.size());
		
		//TODO code should be created differently
		
		//String code = new Date().getTime() + "";
		
		for(String lang : languages) {
			
			Lookup7 l = new Lookup7();
		
		//	l.setCode(code);
			l.setActive("Y");
			l.setLang(lang.trim());	
			
			newLookups.add(l);
			
		}
		
		return newLookups;
	}


	public String getLookupTable() {
		return lookupTable;
	}


	public void setLookupTable(String lookupTable) {
		this.lookupTable = lookupTable;
	}


	public String getLookupCode() {
		return lookupCode;
	}


	public void setLookupCode(String lookupCode) {
		this.lookupCode = lookupCode;
	}


	public String getLookupActive() {
		return lookupActive;
	}


	public void setLookupActive(String lookupActive) {
		this.lookupActive = lookupActive;
	}


	public String getLookupContinuing() {
		return lookupContinuing;
	}


	public void setLookupContinuing(String lookupContinuing) {
		this.lookupContinuing = lookupContinuing;
	}


	public String getLookupIncrement() {
		return lookupIncrement;
	}


	public void setLookupIncrement(String lookupIncrement) {
		this.lookupIncrement = lookupIncrement;
	}


	public String getLookupGraduating() {
		return lookupGraduating;
	}


	public void setLookupGraduating(String lookupGraduating) {
		this.lookupGraduating = lookupGraduating;
	}


	public String getLookupCarrying() {
		return lookupCarrying;
	}


	public void setLookupCarrying(String lookupCarrying) {
		this.lookupCarrying = lookupCarrying;
	}


    public List<String> getAppLanguagesShort() {
        return appLanguagesShort;
    }


    public void setAppLanguagesShort(List<String> appLanguagesShort) {
        this.appLanguagesShort = appLanguagesShort;
    }
	
}
