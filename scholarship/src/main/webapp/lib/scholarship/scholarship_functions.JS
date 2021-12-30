/****************************************************************************************************************          
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
  
  The Original Code is Opus-College scholarship module code.
  
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
****************************************************************************************************************/          

/****************************************************************************************************************/          
    /**
      *     Function for checking and unchecking all checkboxes
      *     author Stelio Macumbe 12 of June 2008
      **/

    function checkAll(checkBoxName){
        var checks = new Array();
        var checker;
        var check;
        
        checker = window.document.getElementById("checker");
        checks = window.document.getElementsByName(checkBoxName);


        if(checker.checked){

            for(index = 0; index < checks.length; index++){
    
                check = checks[index];
                check.checked = true;       
            }
    
        } else {
    
            
            for(index = 0; index < checks.length; index++){
    
                check = checks[index];
                check.checked = false;      
            }
    
        }
    }
            
            
/****************************************************************************************************************/          
    /**
      *     Function for adding the format of the report when a student link is clicked 
      *     author Stelio Macumbe 12 of June 2008
    **/
    
    function openReportWindow(queryString){
    
    /**
        please use window.document instead of only document
        as firefox may have troubles finding document
    
    **/
        var format = window.document.getElementById("format").value;
        var doc = window.document.getElementById("reportName").value;
                    
        
        
        /**
            Builds a query string with the desired document (reportName) and format
        **/
        queryString = queryString +  "&" + "format=" +  format + "&" + "reportName=" + doc; 
        reportWindow = window.open(queryString);                
        reportWindow.focus();
        
    }   

/****************************************************************************************************************/          
    /**
      *     Function for setting the format of the report when a format is selected
      *     author Stelio Macumbe 18 of June 2008
    **/
    
    function setFormat(format){
    
         window.document.getElementById("format").value = format;               
        
    }   

/****************************************************************************************************************/          
    /**
      * Function for setting the document of the report when a document is selected
      * The document parameter is the name of the jasper file which will reproduce the
      * report
      * author Stelio Macumbe 18 of June 2008
    **/
    
    function setDocument(reportName){
    
         window.document.getElementById("reportName").value = reportName;               
        
    }   

/****************************************************************************************************************/          
         
 function checkScholarshipAppliedFor(appliedForScholarship, delString) {
    if ('N' == appliedForScholarship) {
        confirm(delString);
    }
 } 
