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

package org.uci.opus.admin.web.flow;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * @author: Stelio Macumbe
 */
@Controller
@RequestMapping(value="/college/lookups")
public class LookupsController {
    
    private static Logger log = LoggerFactory.getLogger(LookupsController.class);
    private String viewName;
    
    @Autowired private SecurityChecker securityChecker;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private OpusMethods opusMethods;
 
	public LookupsController() {
		super();
		
		viewName = "admin/lookups";
	}

	@RequestMapping(method=RequestMethod.GET)
    protected final ModelAndView handleRequestInternal(HttpServletRequest request, 
            final HttpServletResponse response) {

    	HttpSession session = request.getSession(false);
    	
		int institutionId = 0;
		int branchId = 0;
		int organizationalUnitId = 0;
		int currentPageNumber = 0;
		String searchValue = "";
		
		/* perform session-check. If wrong, this throws an Exception towards ErrorController */
		securityChecker.checkSessionValid(session);

		/* set menu to studies */
		session.setAttribute("menuChoice", "admin");

		session.setAttribute("searchValue", null);
		// if an error occurred while adding , editing or deleting a lookup display it
        request.setAttribute("showError", request.getParameter("showError"));
        request.setAttribute("dependenttable", request.getParameter("dependenttable"));
        request.setAttribute("description", request.getParameter("description"));

		if (request.getParameter("currentPageNumber") != null) {
			currentPageNumber = Integer.parseInt(request
					.getParameter("currentPageNumber"));
		}
		request.setAttribute("currentPageNumber", currentPageNumber);

		/* get preferred Language from request or else session and save it in the request */
		String preferredLanguage = OpusMethods.getPreferredLanguage(request);
		
		List<String> appLanguages = appConfigManager.getAppLanguages();
		List<String> availableLanguages = new ArrayList<>();

		//ignore language variants
		for(int i = 0; i < appLanguages.size() ; i++){
			
			String lang = appLanguages.get(i);
			
			if(lang.indexOf("_") == - 1)
				availableLanguages.add(lang);
			
		}
		
		session.setAttribute("availableLanguages", availableLanguages);
		
		
		
		String selectedLanguages = ServletUtil.getStringValueSetOnSession(session, request, "selectedLanguages");
		
		if(StringUtil.isNullOrEmpty(selectedLanguages, true)){
			selectedLanguages = preferredLanguage;
			session.setAttribute("selectedLanguages", preferredLanguage);
		}

		
		String primaryLanguage =  null;
		String secondaryLanguage =  null;
		
		
		//gets the name of the lookup that should be listed , the name should be the same as
		//the table name in the database
		String lookupTable = ServletUtil.getParamSetAttrAsString(request, "lookupTable", "");
		
		//sets the lookupType in the request , the lookupType allows
		//the jsp to know what fields to display as lookups have different fields
		String lookupType = lookupManager.getLookupType(lookupTable);
		request.setAttribute("lookupType", lookupType);
		
		//checks how many languages have been specified
		//on the jsp file two languages are separated by a "-" sign
		//e.g. ENGLISH-PORTUGUESE
		//see languageSelect.jsp
		if(selectedLanguages.indexOf("-") != -1){
			
			primaryLanguage = selectedLanguages.split("-")[0].trim();
			secondaryLanguage = selectedLanguages.split("-")[1].trim();
			
		} else {
			
			primaryLanguage = selectedLanguages.trim();
			secondaryLanguage = selectedLanguages.trim();
			
		}		
		
		request.setAttribute("primaryLanguage" , primaryLanguage);
		request.setAttribute("secondaryLanguage" , secondaryLanguage);

		 if(lookupType.equals("Lookup2")){
	        	request.setAttribute("allProvinces" , lookupManager.findAllRows(preferredLanguage, "province"));
	        } else if(lookupType.equals("Lookup4")){
	        	request.setAttribute("allDistricts" , lookupManager.findAllRows(preferredLanguage, "district"));	        	
	        } else if(lookupType.equals("Lookup5")){
	        	request.setAttribute("allCountries" , lookupManager.findAllRows(preferredLanguage, "country"));
	        }
		
		// get the searchValue and put it on the session
		searchValue = ServletUtil.getStringValueSetOnSession(session, request,
				"searchValue");

		//* fetch chosen institutionId and branchId, otherwise take values from logged on user */
		institutionId = OpusMethods.getInstitutionId(session, request);
		session.setAttribute("institutionId", institutionId);

		branchId = OpusMethods.getBranchId(session, request);
		session.setAttribute("branchId", branchId);

		organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session,
				request);
		session.setAttribute("organizationalUnitId", organizationalUnitId);

		String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);
		request.setAttribute("institutionTypeCode", institutionTypeCode);
		
	//	ServletUtil.getParamSetAttrAsString(request, "lookupType", "Lookup1");

		/*
		 *  find a LIST OF INSTITUTIONS of the correct educationtype
		 *  
		 *  the institutionTypeCode is used (set in code above)
		 *  for now studies are only registered
		 *  for universities; if in the future this should change, it will
		 *  be easier to alter the code
		 */

		// retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
		opusMethods.getInstitutionBranchOrganizationalUnitSelect(session,
				request, institutionTypeCode, institutionId, branchId,
				organizationalUnitId);

		
		//retrieve for lookups in the primary language
		List < Lookup > primaryLookups = null;
        
		
		//retrieve for lookups in the second language
		List < Lookup > secondaryLookups = null;

		
		//if there is a search value then load rows which description matches the search value
		if(!StringUtil.isNullOrEmpty(searchValue, true)){
			
            primaryLookups = lookupManager.findRowsByDescription(primaryLanguage, lookupTable, searchValue);
			
            secondaryLookups = lookupManager.findRowsByDescription(secondaryLanguage, lookupTable, searchValue);
			
		} else {
			//if there is no search value then load every row
			primaryLookups = lookupManager.findAllRows(primaryLanguage , lookupTable);
			
			secondaryLookups = lookupManager.findAllRows(secondaryLanguage , lookupTable);
			
		}
		
		createLanguagePairs(primaryLookups, secondaryLookups, request);
		
        return new ModelAndView(viewName); 
    }
   
   
    /**
     * This method takes two lists of lookups and ensures that both of lists have correspondent values.
     * For instance if list A as lookup that does not exists in list B then B will be filled with a null value
     * and vice - versa
     * 
     * The two lists will be built in such a way that they will end up with the same number of elements,
     * no element will be removed from any of the lists.
     * 
     * Lets have two lists A and B
     * A = {1 ,2 ,3 , 4 , 5}
     * B = {2 , 6 , 5,7}
     * 
     * After the method is executed the lists will look like
     * A	B
     * 1	null	
     * 2	2
     * 3	null
     * 4	null
     * 5	5
     * null 6
     * null	7
     * 
     * @param <L>
     * @param primaryLookups
     * @param secondaryLookups
     * @param request
     */
    private <L extends Lookup> void createLanguagePairs(List<L> primaryLookups , List<L> secondaryLookups , HttpServletRequest request){
    	
    	//This two list will be filled with all the values.
    	List <L> primaryLookups1 = new ArrayList<>();
    	List <L> secondaryLookups1 = new ArrayList<>();
    	
    	
    	//search for lookups in primaryLookups list that do not exist in first secondaryLookup
    	//if any is found then a null values is added to the secondaryList
    	for(Iterator<L> primaryIterator = primaryLookups.iterator(); primaryIterator.hasNext();){
    		L lookup = primaryIterator.next();
    		String code1 = "";
        	String code2 = "";
    		 
    			if(lookup != null){
    				
    			code1 = lookup.getCode();
    			
    			}
    			for(Iterator<L> secondaryIterator = secondaryLookups.iterator(); secondaryIterator.hasNext();){
    				L lookup2 = secondaryIterator.next();
    			code2 = "";
    			if(lookup2 != null){
    			code2 = lookup2.getCode();
    			
    			} 
    			//means that list2 has this lookup of list1
    			if(code1.equalsIgnoreCase(code2)){
    				primaryLookups1.add(lookup);
    				secondaryLookups1.add(lookup2);
    				secondaryIterator.remove();
    				break;
    			} 
    		}
    		
    		//means that list2 does not contains the Lookup of list one
    		if(!(code1.equalsIgnoreCase(code2))){
    			primaryLookups1.add(lookup);
				secondaryLookups1.add(null);
    		}
    	}
    	
    	
    	
    	//if secondaryLookups contains values that primaryLookups does not
    	if(secondaryLookups.size() > 0){
    		
    		
    		//search for lookups in secondaryLookups  that do not exist in first primaryLookup
        	//if any is found then a null values is added to the primarylookup
    	for(Iterator<L> secondaryIterator = secondaryLookups.iterator(); secondaryIterator.hasNext();){
			L lookup2 = secondaryIterator.next();
		
    		String code1 = "";
        	String code2 = "";
    		 
    			if(lookup2 != null){
    			code2 = lookup2.getCode();
    			}
    			
    			for(Iterator<L> primaryIterator = primaryLookups1.iterator(); primaryIterator.hasNext();){
    	    		L lookup = (L) primaryIterator.next();
    	    		code1 = "";
    			if(lookup != null){
    			code1 = lookup.getCode();
    			}
    			//means that list1 has this lookup of list2
    			if(code1.equalsIgnoreCase(code2)){
    				break;
    			}
    			
    		}
    		
    		//means that list1 does not contains the Lookup of list2
    		if(!(code1.equalsIgnoreCase(code2))){
    			primaryLookups1.add(null);
				secondaryLookups1.add(lookup2);
				
    		}
    	}
    	
    	
    	}
    	
    	request.setAttribute("secondaryLookups", secondaryLookups1);
		request.setAttribute("primaryLookups", primaryLookups1);
    }

    /**
     * @param viewName is set by Spring on application init.
     */
    public void setViewName(final String viewName) {
        this.viewName = viewName;
    }

    
}
