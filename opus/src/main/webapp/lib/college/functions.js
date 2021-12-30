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

// JavaScript Document
 function alternate(id,rollover){ 
	if(document.getElementsByTagName){  
		var table = document.getElementById(id);   
		var rows = table.getElementsByTagName("tr");
		
		for(i = 0; i < rows.length; i++){           
		//manipulate only rows with no <th>
			var headers = rows[i].getElementsByTagName("th");
			if(headers.length == 0)
			{
				if(i % 2 == 0)
				{ 
					rows[i].className = "even";
					if (rollover)
					{
						rows[i].style.cursor ='pointer';
						rows[i].onmouseover=function(){this.className='ruled';return false}
						rows[i].onmouseout=function(){this.className='even';return false}
					}
				}
				else
				{ 
					rows[i].className = "oneven"; 
					if (rollover)
					{
						rows[i].style.cursor ='pointer';
						rows[i].onmouseover=function(){this.className='ruled';return false}
						rows[i].onmouseout=function(){this.className='oneven';return false}
					}
				}
			}
		}
	}
}

function stripCharacters(str) {
        // see: http://www.asciitable.com/
        // see: http://www.tizag.com/javascriptT/javascript-string-replace.php
        str = str.replace(/\"/g, '&#34;');
        str = str.replace(/&/g, '&#38;');
        str = str.replace(/\'/g, '&#39;');
        str = str.replace(/\\/g, '&#92;');
        // replace tags, but make exception for <i> and </i>:
        str = str.replace(/<i>/g, 'italic-start');
        str = str.replace(/<\/i>/g, 'italic-stop');
        str = str.replace(/</g, '&#60;');
        str = str.replace(/>/g, '&#62;');
        str = str.replace(/italic-start/g,'<i>');
        str = str.replace(/italic-stop/g,'</i>');
        return str;
} 
   
function stripQuotes(value) {
        value = value.replace("'","");
        return value;
}

function stripBolds(value) {
        value = value.replace(/<b>/g,"");
        value = value.replace(/<\/b>/g,"");
        return value;
}

function stripLayoutFeeds(str) {
        // see: http://www.asciitable.com/
        // see: http://www.tizag.com/javascriptT/javascript-string-replace.php
        str = str.replace(/\n/g, '<br />');
        str = str.replace(/\t/g, '&nbsp;&nbsp;&nbsp;&nbsp;');
        return str;
} 

function updateFullDate(fieldName,datePart,fieldValue) {
	var oldDate = '';
	var oldDatePart1 = '';
	var oldDatePart2 = '';
	var newDate = '';
	var newDatePartValue = '';
	
	//alert('fieldname = ' + fieldName + ',datePart = ' + datePart + ',changed value=' + fieldValue);   

	oldDate = document.getElementById(fieldName).value;
	newDatePartValue = fieldValue;
	
	if ((datePart == 'day' || datePart == 'month') && newDatePartValue.length == 0) {
		newDatePartValue = '';
	}
	if ((datePart == 'day' || datePart == 'month') && newDatePartValue.length == 1) {
		newDatePartValue = '0' + newDatePartValue;
	}
	if (datePart == 'year' && newDatePartValue.length == 2) {
		newDatePartValue = '20' + newDatePartValue;
	}

	if (datePart == 'day') {
		if (oldDate.length != 0) {
			oldDatePart1 = oldDate.substring(0,8);
		} else {
			oldDatePart1 = '2000-01-';
		}
		if (newDatePartValue != '') {
			newDate = oldDatePart1 + newDatePartValue;
		} else {
			newDate = '';
		}
	}
	if (datePart == 'month') {
		if (oldDate.length != 0) {
			oldDatePart1 = oldDate.substring(0,5);
			oldDatePart2 = oldDate.substring(7,10);
		} else {
			oldDatePart1 = '2000-';
			oldDatePart2 = '-01';
		}
		if (newDatePartValue != '') {
			newDate = oldDatePart1 + newDatePartValue + oldDatePart2;
		} else {
			newDate = '';
		}
	}
	if (datePart == 'year') {
		if (oldDate.length != 0) {
			oldDatePart1 = oldDate.substring(4,10);
			//alert('oldDatePart1 = ' + oldDatePart1 + ',newDatePartValue=' + newDatePartValue);
		} else {
			oldDatePart1 = '-01-01';
		}
		if (newDatePartValue != '') {
			newDate = newDatePartValue + oldDatePart1;
		} else {
			newDate = '';
		}
	}

	document.getElementById(fieldName).value = newDate;
	//alert('new value fieldname = ' + document.getElementById(fieldName).value); 
}
function updateMonthDate(fieldName,datePart,fieldValue) {
	var oldDate = '';
	var oldDatePart1 = '';
	var oldDatePart2 = '';
	var newDate = '';
	var newDatePartValue = '';
	
	//alert('fieldname = ' + fieldName + ',datePart = ' + datePart + ',changed value=' + fieldValue);   

	oldDate = document.getElementById(fieldName).value;
	newDatePartValue = fieldValue;
	
	if (datePart == 'month' && newDatePartValue.length == 0) {
		newDatePartValue = '';
	}
	if (datePart == 'month' && newDatePartValue.length == 1) {
		newDatePartValue = '0' + newDatePartValue;
	}
	if (datePart == 'year' && newDatePartValue.length == 2) {
		newDatePartValue = '20' + newDatePartValue;
	}

	if (datePart == 'month') {
		if (oldDate.length != 0) {
			oldDatePart1 = oldDate.substring(0,5);
		} else {
			oldDatePart1 = '2000-';
		}
		oldDatePart2 = '-01';
		if (newDatePartValue != '') {
			newDate = oldDatePart1 + newDatePartValue + oldDatePart2;
		} else {
			newDate = '';
		}
		
	}
	if (datePart == 'year') {
		if (oldDate.length != 0) {
			oldDatePart1 = oldDate.substring(4,7);
			//alert('oldDatePart1 = ' + oldDatePart1);
		} else {
			oldDatePart1 = '-01';
		}
		oldDatePart2 = '-01';
		if (newDatePartValue != '') {
			newDate = newDatePartValue + oldDatePart1 + oldDatePart2;
		} else {
			newDate = '';
		}
	}

	//alert('newDate = ' + newDate);
	document.getElementById(fieldName).value = newDate;
	//alert('new value fieldname = ' + document.getElementById(fieldName).value); 
}

function updateTime(fieldName,datePart,fieldValue) {
    var oldDate = '';
    var oldDatePart1 = '';
    var oldDatePart2 = '';
    var newDate = '';
    var newDatePartValue = '';
    
    oldDate = document.getElementById(fieldName).value;
    newDatePartValue = fieldValue;
    if (newDatePartValue.length == 0) {
        newDatePartValue = '';
    }
    if (newDatePartValue.length == 1) {
        newDatePartValue = '0' + newDatePartValue;
    }

    if (datePart == 'hour') {
        if (oldDate.length != 0) {
            oldDatePart1 = oldDate.substring(2);
        } else {
            oldDatePart1 = ':00';
        }
        
        if (newDatePartValue != '') {
            newDate = newDatePartValue + oldDatePart1;
        } else {
            newDate = '00' + oldDatePart1;
        }
    }
    
    if (datePart == 'minute') {
        if (oldDate.length != 0) {
            oldDatePart1 = oldDate.substring(0,3);
        } else {
            oldDatePart1 = '00:';
        }
        if (newDatePartValue != '') {
            newDate = oldDatePart1 + newDatePartValue;
        } else {
            newDate = oldDatePart1 + ':00';
        }
    }
    
    if (newDate == "00:00") {
        newDate = '';
    } 
    
    document.getElementById(fieldName).value = newDate; 
}

function updateStudyId() {
	document.getElementById('studyId').value = document.getElementById('studyIdSelect').value;
	//alert('new value studyId='+document.getElementById('studyId').value);
}

function updateStudyIdSelect() {
    document.getElementById('studyIdSelect').value = document.getElementById('primaryStudyId').value;
    //alert('new value studyIdSelect='+document.getElementById('studyIdSelect').value);
}

function updateGradeTypeCode() {
	document.getElementById('gradeTypeCode').value = document.getElementById('gradeTypeCodeSelect').value;
	//alert('new value gradeTypeCode='+document.getElementById('gradeTypeCode').value);
}

function updateEmptyNumber(fieldName, number) {
	if(document.getElementById(fieldName).value=='') {
		document.getElementById(fieldName).value=number;
	};
}

function alterPrevInstFields() {
	if (document.getElementById('student.previousInstitutionId') != null && 
			document.getElementById('student.previousInstitutionId').value != 0) {
		document.getElementById('student.previousInstitutionName').value = '';
		document.getElementById('student.previousInstitutionName').disabled = true;
		document.getElementById('student.previousInstitutionCountryCode').value = '0';
		document.getElementById('student.previousInstitutionCountryCode').disabled = true;
		document.getElementById('student.previousInstitutionProvinceCode').value = '0';
		document.getElementById('student.previousInstitutionProvinceCode').disabled = true;
		document.getElementById('student.previousInstitutionDistrictCode').value = '0';
		document.getElementById('student.previousInstitutionDistrictCode').disabled = true;
		document.getElementById('student.previousInstitutionTypeCode').value = '0';
		document.getElementById('student.previousInstitutionTypeCode').disabled = true;
	} else {
	    if (document.getElementById('student.previousInstitutionName') != null) {
    		document.getElementById('student.previousInstitutionName').disabled = false;
    		document.getElementById('student.previousInstitutionCountryCode').disabled = false;
    		document.getElementById('student.previousInstitutionProvinceCode').disabled = false;
    		document.getElementById('student.previousInstitutionDistrictCode').disabled = false;
    		document.getElementById('student.previousInstitutionTypeCode').disabled = false;
	    }
	}
}
function alterPofessionFields() {
	if (document.getElementById('professionCode').value != ''
			&& document.getElementById('professionCode').value != '0') {
		document.getElementById('professionDescription').value = '';
		document.getElementById('professionDescription').disabled = true;
	} else {
		document.getElementById('professionDescription').disabled = false;
	}
}
function alterFatherPofessionFields() {
	if (document.getElementById('fatherProfessionCode').value != ''
			&& document.getElementById('fatherProfessionCode').value != '0') {
		document.getElementById('fatherProfessionDescription').value = '';
		document.getElementById('fatherProfessionDescription').disabled = true;
	} else {
		document.getElementById('fatherProfessionDescription').disabled = false;
	}
}
function alterMotherPofessionFields() {
	if (document.getElementById('motherProfessionCode').value != ''
			&& document.getElementById('motherProfessionCode').value != '0') {
		document.getElementById('motherProfessionDescription').value = '';
		document.getElementById('motherProfessionDescription').disabled = true;
	} else {
		document.getElementById('motherProfessionDescription').disabled = false;
	}
}

function openPopupWindow(strTxt) {

   if (BrowserDetect.browser == 'Firefox') {
        if (BrowserDetect.version == '3' || BrowserDetect.version > '3') {
            window.showModalDialog(popupLink,stripLayoutFeeds(strTxt),
            "dialogHeight: 200px; dialogWidth:600px; dialogTop: px; dialogLeft: px; center: Yes; help: No; resizable: No; status: No; edge: Raised;");
        } else {
            alert(stripBolds(strTxt));
        }
    } else {
       if (BrowserDetect.browser == 'Explorer' &&
            (BrowserDetect.version == '7' || BrowserDetect.version > '7')) {
                window.showModalDialog(popupLink,stripLayoutFeeds(strTxt),
                "dialogHeight: 150px; dialogWidth:600px; dialogTop: px; dialogLeft: px; center: Yes; help: No; resizable: No; status: No; edge: Raised;");
       } else {
                alert(stripBolds(strTxt));
       }
    }
}

var popupWin;

function openObservationWindow(strLink) {

    if (popupWin==null || popupWin.closed) {
    	popupWin=window.open(strLink,'','width=400,height=400,directories=no,location=no,menubar=no,scrollbars=yes,status=no,toolbar=no,resizable=yes')
    } else {
    	popupWin.location.href=strLink;
    }
    popupWin.focus();
}

function isNumeric(strString)
   //  check for valid numeric strings  
   {
   var strValidChars = "0123456789.-";
   var strChar;
   var blnResult = true;

   if (strString.length == 0) return false;

   //  test strString consists of valid characters listed above
   for (i = 0; i < strString.length && blnResult == true; i++)
      {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         }
      }
   return blnResult;
   }


/*function checkMarkValidity(minimumMark, maximumMark, givenMark, 
        strMinimumMark, strMaximumMark, strHigherThanGivenMark, strLowerThanGivenMark, strConflictingScales) {
    var allMarkEvaluations = 'ZYXWVUTSRQPONMLKJIHGFEDCBA';

    if (isNumeric(minimumMark) && isNumeric(maximumMark) && isNumeric(givenMark)) {
        // The unary plus converts its operand to a number;
        if (minimumMark > givenMark) {
        	alert(strMinimumMark + ' (' + minimumMark + ') '+ strHigherThanGivenMark + ' (' + givenMark + ')');
        }
        if (givenMark > maximumMark) {
            alert(strMaximumMark + ' (' + maximumMark + ') '+ strLowerThanGivenMark + ' (' + givenMark + ')');
        }
    } else {
        if (!isNumeric(minimumMark) && !isNumeric(maximumMark) && !isNumeric(givenMark)) {
            //alert('marks are all NOT numeric');
            if (allMarkEvaluations.lastIndexOf(minimumMark) > allMarkEvaluations.lastIndexOf(givenMark)) {
                alert(strMinimumMark + ' (' + minimumMark + ') '+ strHigherThanGivenMark + ' (' + givenMark + ')');
            }
            if (allMarkEvaluations.lastIndexOf(givenMark) > allMarkEvaluations.lastIndexOf(maximumMark)) {
                alert(strMaximumMark + ' (' + maximumMark + ') '+ strLowerThanGivenMark + ' (' + givenMark + ')');
            }
        } else {
        	alert(strMinimumMark + ' , '+ strMaximumMark + ' ' + strConflictingScales);
        }
    }
}*/

/*function checkEndGradeValidity(minimumGrade, maximumGrade, givenGrade, 
        strMinimumGrade, strMaximumGrade, strHigherThanGivenGrade, strLowerThanGivenGrade, 
        strConflictingScales) {
	var allGradeEvaluations = 'ZYXWVUTSRQPONMLKJIHGFEDCBA';
    //alert('checkEndGradeValidity with: minimumGrade=' + minimumGrade 
    //		+ ', maximumGrade=' + maximumGrade + ', givenGrade=' + givenGrade);

    if (isNumeric(minimumGrade) && isNumeric(maximumGrade) && isNumeric(givenGrade)) {
        //alert('grades are numeric');
    	var minimumGradeDbl = parseFloat(minimumGrade) ;
    	var maximumGradeDbl = parseFloat(maximumGrade);
    	var givenGradeDbl = parseFloat(givenGrade);
    	// The unary plus converts its operand to a number;
        if (minimumGradeDbl > givenGradeDbl) {
        	//alert('grade higher than min');
        	alert(strMinimumGrade + ' (' + minimumGrade + ') '+ strHigherThanGivenGrade + ' (' + givenGrade + ')');
        //} else {
        //	alert('grade NOT higher than min');
        }
        if (givenGradeDbl > maximumGradeDbl) {
        	//alert('grade higher than max');
            alert(strMaximumGrade + ' (' + maximumGrade + ') '+ strLowerThanGivenGrade + ' (' + givenGrade + ')');
        //} else {
        //	alert('grade NOT higher than max');
        }
        
    } else {
        //alert('grades are NOT numeric');
        if (!isNumeric(minimumGrade) && !isNumeric(maximumGrade) && !isNumeric(givenGrade)) {
            if (allGradeEvaluations.lastIndexOf(minimumGrade) > allGradeEvaluations.lastIndexOf(givenGrade)) {
                alert(strMinimumGrade + ' (' + minimumGrade + ') '+ strHigherThanGivenGrade + ' (' + givenGrade + ')');
            }
            if (allGradeEvaluations.lastIndexOf(givenGrade) > allGradeEvaluations.lastIndexOf(maximumGrade)) {
                alert(strMaximumGrade + ' (' + maximumGrade + ') '+ strLowerThanGivenGrade + ' (' + givenGrade + ')');
            }
        } else {
        	alert(strMinimumGrade + ' , '+ strMaximumGrade + ' ' + strConflictingScales);
        }
    }
}*/

// see: http://www.webtoolkit.info/javascript-url-decode-encode.html
// public method for url encoding
function specialCharactersEncode(string) {
    return escape(this._utf8_encode(string));
}

// private method for UTF-8 encoding
function _utf8_encode(string) {
    string = string.replace(/\r\n/g,"\n");
    var utftext = "";

    for (var n = 0; n < string.length; n++) {

        var c = string.charCodeAt(n);

        if (c < 128) {
            utftext += String.fromCharCode(c);
        }
        else if((c > 127) && (c < 2048)) {
            utftext += String.fromCharCode((c >> 6) | 192);
            utftext += String.fromCharCode((c & 63) | 128);
        }
        else {
            utftext += String.fromCharCode((c >> 12) | 224);
            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
            utftext += String.fromCharCode((c & 63) | 128);
        }

    }

    return utftext;
}

// see: http://www.webtoolkit.info/javascript-url-decode-encode.html
// public method for url decoding
function specialCharactersDecode(string) {
    return this._utf8_decode(unescape(string));
}

// private method for UTF-8 decoding
function _utf8_decode(utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;

    while ( i < utftext.length ) {

        c = utftext.charCodeAt(i);

        if (c < 128) {
            string += String.fromCharCode(c);
            i++;
        }
        else if((c > 191) && (c < 224)) {
            c2 = utftext.charCodeAt(i+1);
            string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
            i += 2;
        }
        else {
            c2 = utftext.charCodeAt(i+1);
            c3 = utftext.charCodeAt(i+2);
            string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            i += 3;
        }

    }

    return string;
}
    


	/**
	 *     Function for checking and unchecking all checkboxes with same name
	 **/
	function toggleGroup(checkBoxName, toggle) {
		var checks = window.document.getElementsByName(checkBoxName);
		
			for (index = 0; index < checks.length; index++) 
				checks[index].checked = toggle;
			
	}
	 

   function showHide(shID) {
     if (document.getElementById(shID)) {
         if (document.getElementById(shID).style.display != 'block') {             
             document.getElementById(shID).style.display = 'block';
         }
         else {
             document.getElementById(shID).style.display = 'none';
         }
     }
   }
   
   function showId(shID) {
       if (document.getElementById(shID)) {
	       document.getElementById(shID).style.display = 'block';
	   }
    }



function anySelected(checkBoxName , msg){
 var checks = new Array();
 var check;
 var anyChecked = false;
    checks = window.document.getElementsByName(checkBoxName);
     for(index = 0; index < checks.length; index++){
         check = checks[index];
         if(check.checked){
             anyChecked = true;
             break;                        
         }       
     }
     if(!anyChecked && (msg != null) && (msg != undefined)){
    	 alert(msg);
     }
  return anyChecked;
}

