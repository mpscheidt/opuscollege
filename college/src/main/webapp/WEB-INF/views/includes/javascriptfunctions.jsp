<%--
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
--%>

        <script type="text/javascript">
            
            //<![CDATA[
            
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

            function checkAll2(checks,checker){
                var check;

                if(checker.checked){
                    checks.checked = true;  // in case of a single checkbox (rather than an array of checkboxes)
                    for(index = 0; index < checks.length; index++){
            
                        check = checks[index];
                        check.checked = true;       
                    }
            
                } else {
                    checks.checked = false; // in case of a single checkbox (rather than an array of checkboxes)
                    for(index = 0; index < checks.length; index++){
            
                        check = checks[index];
                        check.checked = false;      
                    }
                }
            }

            function enableDisableById(elementId, disabled) {
                document.getElementById(elementId).disabled = disabled;
            }

            function enableDisableBySelector(selector, disabled) {
                //alert(jQuery(selector).length);
                jQuery(selector).attr('disabled', disabled);
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
                var format = window.document.getElementById("reportFormat").value;
                var doc = window.document.getElementById("reportName").value;
                            
                
                
                /**
                    Builds a query string with the desired document (reportName) and format
                **/
                queryString = queryString +  "&" + "reportFormat=" +  format + "&" + "reportName=" + doc; 
                reportWindow = window.open(queryString);                
                reportWindow.focus();
                        
                        
                        
                
            }   

/****************************************************************************************************************/          
            
        
                    
            /**
              *     Function for setting the format of the report when a format is selected
              *     author Stelio Macumbe 18 of June 2008
            **/
            
            
            function setFormat(format){
            
                 window.document.getElementById("reportFormat").value = format;             
                
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
        
        
                  
            /**
              *Function for displaying a message after comparing two values 
              * author Stelio Macumbe 30 of July 2008
            **/
            
            
            function alertError(value1 , value2 , message){
            
                 if(value1 == value){
                 
                 alert(message);
                 }               
                
            }   

/****************************************************************************************************************/          
                
        
  //jsp.students.massassignment.remove.arg=Are you sure you want to remove students from \\"{0}\\" ?
//jsp.students.massassignment.assign.arg=Are you sure you want to assign students to \\"{0}\\" ?
    function confirmAction(){
        var operation = document.getElementById('operation').value;
    
         if(operation == "assignstudents"){
        }
        
        if(operation == "removestudents"){
        }
    
    }
                   
/*************************************************************************************************************************/

/**
    Validates a form with the common filter values
    Checks if any of the values has not been selected
**/

    function validateFiltersForm(){
      
      var institution = document.getElementById('institutionId');
      var branch = document.getElementById('branchId');
      var organizationalUnit = document.getElementById('organizationalUnitId');
      var study = document.getElementById('studyId');
      var primaryStudy = document.getElementById('primaryStudyId');
      var studyGradeType = document.getElementById('studyGradeTypeId');
      //var studyYear = document.getElementById('studyYearId');
      var academicYear = document.getElementById('academicYear');
      var academicYear2 = document.getElementById('academicYearId');
      
      var instituionId;
      var branchId;
      var organizationalUnitId;
      var studyId;
      var studyGradeTypeId;
      //var studyYearId;
      var academicYearId;
      
      //-1 means that the field could not be found in the page
      //in this case do not bother looking for it
      if(institution != null){
        institutionId = parseInt(institution.value);
      } else {
        institutionId = -1;
      }
            
      if(branch != null){
        branchId = parseInt(branch.value);
      } else {
        branchId = -1;
      }
      
      if(organizationalUnit != null){
        organizationalUnitId = parseInt(organizationalUnit.value);
      } else {
        organizationalUnitId = -1;
      }
      
      
      //some pages have the study dropdown id set to studyId
      //and others set to primaryStudyId
      if(study != null){
        studyId = parseInt(study.value);
      } else if(primaryStudy != null){
        studyId = parseInt(primaryStudy.value);
      } else {
        studyId = -1;
      }
            
      if(studyGradeType != null){
        studyGradeTypeId = parseInt(studyGradeType.value);
      } else {
        studyGradeTypeId = -1;
      } 
      
      //if(studyYear != null){
      //  studyYearId = parseInt(studyYear.value);
      //} else {
      //  studyYearId = -1;
      //}
      
      //some pages have the academic year dropdown id set to academicYear
      //and others set to academicYearId 
      if(academicYear != null){
        academicYearId = academicYear.value;
      } else if(academicYear2 != null){
        academicYearId = academicYear2.value;
      } else {
        academicYearId = '-1';
      }
      
      
      if(organizationalUnitId == 0){
            alert('<fmt:message key="invalid.organizationalUnitId.format" />');
            return false;
        }
      
        if(branchId == 0){
            alert('<fmt:message key="invalid.branchId.format" />');
            return false;
        }
      
        if(studyId == 0){
            alert('<fmt:message key="invalid.study.format" />');
            return false;
        }
        
        if(studyGradeTypeId == 0){
            alert('<fmt:message key="invalid.studygradetype.format" />');
            return false;
        }
        
        //if(studyYearId == 0){
        //    alert('<fmt:message key="invalid.studyyear.format" />');
        //    return false;
        //}
      
        if(academicYearId == '0'){
            alert('<fmt:message key="invalid.academicyear.format" />');
            return false;
        }
        
        
        return true;    
    }     
        
                    
            
            
        //]]>
        </script>