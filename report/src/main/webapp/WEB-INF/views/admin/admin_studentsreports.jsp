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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:set var="screentitlekey">jsp.studentsreports.admin.header</c:set>
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
                     <fmt:message key="jsp.studentsreports.admin.header" />
                  </legend>
                
             
  <!-- Students reports per study grade type / cardinal time unit -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.report.studentreports4studygradetypecardinaltimeunit" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                            <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <%-- studyGradeTypeCardinalTimeUnitReports configured in application context  --%>
                        <c:forEach var="report" items="${reportWebExtensions.studentReports4studyGradeTypeCardinalTimeUnit}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
             </fieldset>

             <!-- Students reports per study grade type -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.report.studentreports4studygradetype" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                            <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${reportWebExtensions.studentReports4studyGradeType}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
             </fieldset>

             <!-- Students reports per subject -->
             <fieldset>
                <legend>
                    <fmt:message key="jsp.report.studentreports4subject" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                            <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                         </tr>
                    </thead>
                    <tbody>

                        <c:forEach var="report" items="${reportWebExtensions.studentReports4Subject}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
             </fieldset>

            <!-- Students results reports -->
            <fieldset>
                <legend>
                    <fmt:message key="jsp.general.examinationresults" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                            <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                         </tr>
                    </thead>
                    <tbody>

                        <c:forEach var="report" items="${reportWebExtensions.studentReport4SubjectResults}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
            </fieldset>

            <!-- Individual reports -->
            <fieldset>
                <legend>
                    <fmt:message key="jsp.general.individualreports" />
                </legend>
                
                <table class="reportTable">
                    <thead>
                        <tr>
                            <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                            <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                         </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${reportWebExtensions.studentReports4IndividualStudent}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </fieldset>
             
            <!-- Study plan based reports -->             
            <fieldset>
               <legend>
                   <fmt:message key="jsp.general.studyplanreports" />
               </legend>
              
               <table class="reportTable">
                   <thead>
                       <tr>
                           <th width="200"><fmt:message key="jsp.studentsreports.reportname"/></th>
                           <th width="500"><fmt:message key="jsp.studentsreports.reportdescription"/></th>
                        </tr>
                   </thead>
                   <tbody>
                        <c:forEach var="report" items="${reportWebExtensions.studentReports4StudyPlan}">
                            <tr width="150">
                                <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=${report.reportName}&titleKey=${report.titleKey}'/>"><fmt:message key="${report.titleKey}" /></a>
                                <td width="500"><span class="description"><fmt:message key="${report.descriptionKey}"/></span></td>
                            </tr>
                        </c:forEach>

                       <tr>
                           <td width="200"><a href="<c:url value='/college/report/reportproperties.view?reportName=StudentCertificate&titleKey=jsp.report.studentcertificate'/>"><fmt:message key="jsp.general.studentcertificate" /></a>
                           <td width="500"><span class="description"><fmt:message key="jsp.studentsreports.description.studentcertificate"/></span></td>
                       </tr> 
                       
                   </tbody>
               </table>
            </fieldset>
             
            </fieldset>
        </div><!-- tabcontent -->
    </div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>
