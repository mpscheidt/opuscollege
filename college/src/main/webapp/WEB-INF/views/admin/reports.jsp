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

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
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
 author Stelio Macumbe
--%>

<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.reportsadmin.header</c:set>
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
       
                
             <!-- Students reports fieldset -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.general.studentslists" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.report.name"/></th>
                            <th width="500"><fmt:message key="jsp.report.description"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <tr width="150">
                            <td width="200">
                            	<a href="<c:url value='/college/report/reportproperties.view?reportName=AdmissionLetter&reportPath=person/'/>"><fmt:message key="jsp.report.admissionletter"/></a>
                            <td width="500"><span class="description"><fmt:message key="jsp.report.admissionletter.reportdescription"/></span></td>
                        </tr>
                        <tr width="150">
                            <td width="200">
                            	<a href="<c:url value='/college/report/reportproperties.view?reportName=AdmissionSummary&reportPath=person/'/>"><fmt:message key="jsp.report.admissionsummary"/></a>
                            <td width="500"><span class="description"><fmt:message key="jsp.report.admissionsummary.reportdescription"/></span></td>
                        </tr>
                    </tbody>
                </table>               
             
            
        </div><!-- tabcontent -->
    </div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>