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

// JavaScript Document for specific JQuery functions
// Author: Monique in het Veld (2009)

// test if this script-library is found
//alert('JQuery functions-lib found');

// 0. prevent conflicts with other libraries using $
//jQuery.noConflict();

// 1. open all external links in a new window
//jQuery(function() {
//    jQuery("a[href^='http://']").attr("target", "_blank");
//});


// 2. disable all once pressed submit-buttons with class pressonce to prevent multiple pressing
jQuery(function() {
    //alert("Found " + jQuery("form pressonce").submit.length + " pressonce classed submits.");
    jQuery("form pressonce").submit(function() {
        jQuery(this).attr("disabled", "disabled");
    });
});
// 3. only show -choose- if more than one value to show in dom element select 
// when class="compressoneoption"
jQuery(function() {
    //alert("Found " + jQuery(".compressoneoption").length + " compressoneoption classed selects.");
    jQuery(".compressoneoption").each(function(i) {
    	var select = jQuery(this);
       	//alert("select: " + jQuery(this).html());
        var counter = 0;
	    select.find("option").each(function(j) {
	        counter = counter + 1;
	    });
	    if (counter == 2 || counter < 2) {
	        select.find("option").each(function(k) {
	        	
                //alert("select option: " +  jQuery(this).val()+ ", value = "+ jQuery(this).html());
            // hide the first of the option of this select ("0" OR "")
                if (jQuery(this).val() == 0 || jQuery(this).val() == "")  {
                   jQuery(this).hide();
                }
            // auto-select the other option
	            if (jQuery(this).val() != 0 && jQuery(this).val() != "")  {
	               jQuery(this).attr("selected","selected");
	            }
	        });
	    }
    });
});

// 4. adjust size of dom element select to length of longest option when class="adjustoptionlength"
// variabele: charwidth
jQuery(function() {
    //alert("Found " + jQuery(".adjustselectlength").length + " adjustselectlength classed selects.");
    // variabele charwidth: afhankelijk van lettertype en font-size:
    var charwidth = 6;
    var maxoptioncharlength = 0;

    jQuery(".adjustselectlength").each(function(i) {
        var selectinput1 = jQuery(this);
        var optioncharlength = 0;
        var optionstring = "";
        selectinput1.find("option").each(function(j) {
            optionstring = jQuery(this).html().toString();
            optioncharlength = optionstring.length;
            //alert("lengte option in chars="+ optioncharlength );
            if (maxoptioncharlength < optioncharlength) {
                maxoptioncharlength = optioncharlength;
            }
        });
     });

    jQuery(".adjustselectlength").each(function(k) {
        var selectinput2 = jQuery(this);
        var selectwidth = maxoptioncharlength * charwidth;
        styleattrib = "width:"+ selectwidth + "px;";
        //alert('styleattrib='+styleattrib);
        selectinput2.attr("style",styleattrib);
   });
});

// 5. Stelio Macumbe
//.numberTextField will only accept numbers
jQuery(function(){
	jQuery(".numericField").keypress(function(event) {
		//some browsers use "which" and some use "keycode"
		//to find what key has been pressed
		var charCode = (event.which) ? event.which : event.keyCode;
                         
		//codes below
		//digits start at code 48
		//codes up to 31 are control characters (shift , tab , enter ,etc)
		if((charCode < 32) || ((charCode > 47) && (charCode < 58))) 
          return  true;
   
      return false;
   });//numberTextField keypress event
});

// 6. Form validators
//set default values for every form validator
/*jQuery.validator.setDefaults({
   submitHandler: function(form) {
   //	alert(jQuery(form).html());
   jQuery(form).submit();
   }

})
*/

//Find form validators
/*
jQuery(function(){
	jQuery("form.defaultFormValidator").each(
		function() {
				jQuery(this).validate();
		}
	);
	//
});
*/

// 7. Stelio Macumbe
//find jquery widgets

jQuery(function(){
	jQuery.datepicker.setDefaults({dateFormat: 'dd/mm/yy'});

		jQuery('.datePicker').datepicker({
			inline: true
		});
});
