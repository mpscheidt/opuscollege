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

import org.uci.opus.college.domain.Lookup;

public class DisciplinesForm {

	/**
	 * Stores common values for disciplines
	 */
	private Lookup modelDiscipline;
	private NavigationSettings navigationSettings;
	
	
	List<? extends Lookup> disciplines;
	List<String> errorMessages;
	

	public List<? extends Lookup> createNewDisciplines(List<String> languages) {
		
		List<Lookup> newDisciplines = new ArrayList<Lookup>();
		
		for(String lang: languages) {
			
			Lookup discipline = new Lookup();
			
			discipline.setActive("Y");
			discipline.setLang(lang);
			
			newDisciplines.add(discipline);
		}
		
		return newDisciplines;
	}
	
	public Lookup getModelDiscipline() {
		return modelDiscipline;
	}

	public void setModelDiscipline(Lookup modelDiscipline) {
		this.modelDiscipline = modelDiscipline;
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

	public List<? extends Lookup> getDisciplines() {
		return disciplines;
	}

	public void setDisciplines(List<? extends Lookup> disciplines) {
		this.disciplines = disciplines;
	}

	public List<String> getErrorMessages() {
		return errorMessages;
	}

	public void setErrorMessages(List<String> errorMessages) {
		this.errorMessages = errorMessages;
	}
	
}
