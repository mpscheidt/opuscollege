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

// http://www.quirksmode.org/js/detect.html
var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari"
		},
		{
			prop: window.opera,
			identity: "Opera"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};
BrowserDetect.init();
// met dit object kun je het volgende uitvragen:
//Browser name: BrowserDetect.browser 
//Browser version: BrowserDetect.version 
//OS name: BrowserDetect.OS 

function chooseStyle() {
   /* if (BrowserDetect.OS == 'Mac') {
		//alert("You are using Mac")
		if (BrowserDetect.browser == 'Explorer') {
			//alert("You are using Explorer")
   			document.write('<link rel="stylesheet" type="text/css" href="styles/mac_ie.css">');
		} else {
			if (BrowserDetect.browser == 'Opera') {
				//alert("You are using Opera")
   				document.write('<link rel="stylesheet" type="text/css" href="styles/mac_opera.css">');
			} else {
				//alert("You are using IE or other than Firefox or Safari")
       			document.write('<link rel="stylesheet" type="text/css" href="styles/mac_firefox.css">');
			}
		}
	} */
    /*if (BrowserDetect.OS == 'Linux') {
		//alert("You are using Linux")
		if (BrowserDetect.browser == 'Opera') {
		     document.write('<link rel="stylesheet" type="text/css" href="styles/linux_opera.css">');
		} else {
			//alert("You are using Firefox or other than Opera")
	     	document.write('<link rel="stylesheet" type="text/css" href="styles/linux_firefox.css">');
		}
	}*/
    /*if (BrowserDetect.OS == 'Windows') {
		//alert("You are using Windows")
		if (BrowserDetect.browser == 'Explorer') {
			if (BrowserDetect.version == '6') {
			 document.write('<link rel="STYLESHEET" href="styles/main_windows_ie6.css" type="text/css">');
             //alert("You are using IE6");
			}
    	} else {
			if (BrowserDetect.browser == 'Opera') {
				//alert("You are using Opera")
      			document.write('<link rel="STYLESHEET" href="styles/main_windows_opera.css" type="text/css">');		
			}
			if (BrowserDetect.browser == 'Firefox') {
				alert("You are using Firefox")
	      		document.write('<link rel="STYLESHEET" href="styles/main_windows_firefox.css" type="text/css">');		
			} 
		}
     }*/
}	 
