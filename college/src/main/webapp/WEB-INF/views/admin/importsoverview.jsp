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

<%--
 * Copyright (c) 2008 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
 author Stelio Macumbe
--%>

<%@ include file="../header.jsp"%>

<body>


    <style type="text/css">
         select {
            width: 100px;
          }
    
         h3 {
        color:rgb(68 , 70 , 111);
        }
     
       .subtitle{
          font-weight:bolder;
          color:rgb(106 , 97 , 152);
          font-weight: bolder;
       }
       .btn{
        cursor:pointer ;
       }
       th{
        text-align:left;
       }
    </style>

    <div id="tabwrapper">
        <%@ include file="../menu.jsp"%>

        <div id="tabcontent">
       
            <fieldset>
                   <legend>
                     <fmt:message key="jsp.importations.header" />
                  </legend>
                
             
             <!-- Students reports fieldset -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.general.students" />
                </legend>
                
                <table>
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.general.importation"/></th>
                            <th width="500"><fmt:message key="jsp.general.description"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="200"><a href="<c:url value='/college/studentsimports.view'/>"><fmt:message key="jsp.general.students" /></a>
                            <td width="500"><span class="description"><fmt:message key="jsp.studentsreports.description.lists"/></span></td>
                        </tr>
                        <tr width="150">
                            <td width="200"><a href="<c:url value='/report/reportpersubject.view'/>"><fmt:message key="jsp.general.exams" /></a>
                            <td width="500"><span class="description"><fmt:message key="jsp.studentsreports.description.studentsbysubjectlists"/></span></td>
                        </tr>
                    </tbody>
                </table>
                
                
                
                
             </fieldset>
            <!-- Individual reports fieldset -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.general.institutions" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.general.importation"/></th>
                            <th width="500"><fmt:message key="jsp.general.description"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="200"><a href="<c:url value='/report/individualstudentreport.view?reportName=StudentCard'/>"><fmt:message key="jsp.general.institutions" /></a>
                            <td width="500"><span class="description"><fmt:message key="jsp.studentsreports.description.studentcard"/></span></td>
                        </tr>
                       
                    </tbody>
                </table>
             </fieldset>
          
             
            </fieldset>
        </div><!-- tabcontent -->
    </div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>