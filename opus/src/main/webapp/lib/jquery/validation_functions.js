/**************************************************************************
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College college module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen.
Portions created by the Initial Developer are Copyright (C) 2008
the Initial Developer. All Rights Reserved.

Contributor(s):
  For Java files, see Javadoc @author tags.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

***** END LICENSE BLOCK *****
**************************************************************************/

// JavaScript Document with custom form validation functions
// Author:Stelio Macumbe (August 20 , 2010)


//alert('JQuery functions-lib found');

// 0. prevent conflicts with other libraries using $
//jQuery.noConflict(); 
jQuery(function(){
	//alert("asa");

});


function doDefaultValidation() {
	
	
}

function validateLookupForm(lookupType, arr_appLanguages){
        alert("Validating lookup form");
        //alert("appLanguages=" + appLanguages);
//        var arr_appLanguages = appLanguages.split(",");
        var blFalse = false;

        if(lookupType == 'Lookup1'){

            blFalse = false;
           
            for (i = 0; i < arr_appLanguages.length; i++) {
	           if ($('descriptionShort_' + arr_appLanguages[i]) != null) { 
	               if (!isValidLength(
	                     $('descriptionShort_' + arr_appLanguages[i]) 
	                     , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />' 
	                     , '<fmt:message key="jsp.alert.descriptionshort.maxcharacters" />' 
	                     , 2)
	               ) {
	                   blFalse = true;
	               }
	           } else {
	               if (isEmpty(
	                ''
	                , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
	               ) {
	                   blFalse = true;
	               }
	           }
	         
            }
            if (blFalse == true) {
                return false;
            }
    
        } else if(lookupType == 'Lookup3'){
        
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('short2_' + arr_appLanguages[i]) != null) { 
                    if (!isValidLength(
                       $('short2_' + arr_appLanguages[i]) 
                        , '<fmt:message key="jsp.lookup.alert.short2notempty" />' 
                        , '<fmt:message key="jsp.alert.short2.maxcharacters" />' 
                        , 2)
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }
	        
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('short3_' + arr_appLanguages[i]) != null) { 
                    if (!isValidLength(
                       $('short3_' + arr_appLanguages[i]) 
                        , '<fmt:message key="jsp.lookup.alert.short3notempty" />' 
                        , '<fmt:message key="jsp.alert.short3.maxcharacters" />' 
                        , 3)
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }
        
	    } else if(lookupType == 'Lookup6'){
	    
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('title_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('title_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.titlenotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }

        } else if(lookupType == 'Lookup7'){
            
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('continuing_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('continuing_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.continuingnotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }
	        
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('increment_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('increment_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.incrementnotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }

            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('graduating_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('graduating_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.graduatingnotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }

            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('carrying_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('carrying_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.carryingnotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }

        } else if(lookupType == 'Lookup8'){
    	    
            blFalse = false;

            for (i = 0; i < arr_appLanguages.length; i++) {
                if ($('nrOfUnitsPerYear_' + arr_appLanguages[i]) != null) { 
                    if (isEmpty(
                       $('title_' + arr_appLanguages[i]).value 
                        , '<fmt:message key="jsp.lookup.alert.numberofunitsperyearnotempty" />')
                    ) {
                       blFalse = true;
                    }
                } else {
                    if (isEmpty(
                       ''
                       , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                    ) {
                       blFalse = true;
                    }
                }
            }
            if (blFalse == true) {
                return false;
            }
        }

        blFalse = false;
        
        for (i = 0; i < arr_appLanguages.length; i++) {
            if ($('description_' + arr_appLanguages[i]) != null) { 
	            
	            if (isEmpty(
	                $('description_' + arr_appLanguages[i]).value , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
	             ) {
	                blFalse = true;
	             }
            } else {
                if (isEmpty(
                   ''
                   , '<fmt:message key="jsp.lookup.alert.descriptionnotempty" />')
                ) {
                   blFalse = true;
                }
            }
        }
        if (blFalse == true) {
            return false;
        }

        /*    if(isDuplicated($('description_en').value , $('description_pt').value)||
                   isDuplicated($('description_en').value , $('description_nl').value) ||
                   isDuplicated($('description_nl').value , $('description_pt').value)){
                       return confirm('<fmt:message key="jsp.lookup.add.confirm" />');
            } */
                
        for (i = 0; i < arr_appLanguages.length; i++) {
	        for (j = 0; j <arr_appLanguages.length; j++) {
	            if (arr_appLanguages[i] != arr_appLanguages[j]) {
	                if(isDuplicated($('description_' + arr_appLanguages[i]).value 
	                    , $('description_' + arr_appLanguages[j]).value)){
	                    return confirm('<fmt:message key="jsp.lookup.add.confirm" />');
	                }
	            }
	        }
        } 
        return true;
   }
