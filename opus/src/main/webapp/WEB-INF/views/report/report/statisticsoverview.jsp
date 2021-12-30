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

<c:set var="screentitlekey">jsp.statistics.header</c:set>
<%@ include file="../../header.jsp"%>

<body>
    <div id="tabwrapper">
        <%@ include file="../../menu.jsp"%>
        <div id="tabcontent">
        <fieldset>
            <legend><fmt:message key="jsp.statistics.header" /></legend>
        
<!-- apu:start -->
        <table cellspacing="10p">
            <tr>
                <sec:authorize access="hasRole('READ_INSTITUTIONS')">
                    <td class="label"><fmt:message key="jsp.general.institution" /></td>
                    <td>  
                        <form name="universities" id="universities" action="<c:url value='${action}'/>" 
                              method="POST" 
                              target="_self">
                            <input type="hidden" name="branchId" value="0" />
                            <input type="hidden" name="organizationalUnitId" value="0" />
                            <input type="hidden" name="academicYearId" value="${academicYearId}"/>
                            <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                            <input type="hidden" name="reportName" value="${reportName}"/>
                            <%@ include file="../../includes/institutionSelect.jsp" %>
                         </form>
                    </td>
                </sec:authorize>
            </tr>
            <tr>
                <sec:authorize access="hasAnyRole('READ_BRANCHES','READ_INSTITUTIONS')">
                    <td class="label"><fmt:message key="jsp.general.branch"/></td>
                    <td>
                        <form name="branches" id="branches" action="<c:url value='${action}'/>" method="POST" target="_self">
                            <input type="hidden" name="institutionId" value="${institutionId}" />
                            <input type="hidden" name="organizationalUnitId" value="0" />
                            <input type="hidden" name="academicYearId" value="${academicYearId}"/>
                            <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                            <input type="hidden" name="reportName" value="${reportName}"/>
                            <%@ include file="../../includes/branchSelect.jsp" %>
                        </form>
                    </td>
                </sec:authorize>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.organizationalunit"/></td>
                <td>
                    <form name="organizationalunits" id="organizationalunits" action="<c:url value='${action}'/>" method="POST" target="_self">
                        <input type="hidden" name="institutionId" value="${institutionId}" />
                        <input type="hidden" name="branchId" value="${branchId}" />
                        <input type="hidden" name="academicYearId" value="${academicYearId}"/>
                        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                        <input type="hidden" name="reportName" value="${reportName}"/>
                        <%@ include file="../../includes/organizationalUnitSelect.jsp" %>
                    </form>
                </td>
            </tr>

<!-- apu:ende -->
            <tr>
                <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                <td>
                    <form name="academicYearForm" id="academicYearForm" method="POST" target="_self" action="<c:url value='${action}'/>">
                        <input type="hidden" name="institutionId" value="${institutionId}" />
                        <input type="hidden" name="branchId" value="${branchId}" />
                        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                        <input type="hidden" name="reportName" value="${reportName}"/>
                        <%@ include file="../../includes/academicYearSelect.jsp" %>
                    </form>
                </td> 
            </tr>
            <tr>
                <td><b><fmt:message key="jsp.general.statistics" /></b></td>
                <td>
                    <form name="reportNameForm" method="POST" target="_self">
                        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                        <input type="hidden" name="academicYearId" value="${academicYearId}"/>
                        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                        <select  name="reportName" onchange="document.reportNameForm.submit();">
                            
  <%--                           <option value="StatsActiveStudies"
                            <c:choose><c:when test="${reportName == 'StatsActiveStudies'}">
                            selected
                            </c:when></c:choose>
                            ><fmt:message key="jsp.statistics.activeStudies"/></option>
                            
                            <option value="StatsActiveStudents"
                            <c:choose><c:when test="${reportName == 'StatsActiveStudents'}">
                            selected
                            </c:when></c:choose>
                            ><fmt:message key="jsp.statistics.activeStudents"/>
                            </option>

                            <option value="StatsActiveStudentsWithGraph"
                            <c:choose><c:when test="${reportName == 'StatsActiveStudentsWithGraph'}">
                            selected
                            </c:when></c:choose>
                            ><fmt:message key="jsp.statistics.activeStudentsWithGraph"/>
                            </option>

                            <option value="StatsStudentsPerProvinceOfOrigin"
                            <c:choose><c:when test="${reportName == 'StatsStudentsPerProvinceOfOrigin'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.studentsPerProvinceOfOrigin"/>
                            </option>
                            
                            <option value="StatsStudentsPerProvinceOfOriginAndAge"
                            <c:choose><c:when test="${reportName == 'StatsStudentsPerProvinceOfOriginAndAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.studentsPerProvinceOfOriginAndAge"/>
                            </option> --%>
                             <option value="StatsForeignStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsForeignStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsforeignstudentswithgender"/>
                            </option>  
                            
                            <option value="StatsForeignStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsForeignStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsforeignstudentsage"/>
                            </option> 
                            
                            
                            
                            <option value="StatsEnrolledStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsEnrolledStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsenrolledstudentswithgender"/>
                            </option>  
                            
                            <option value="StatsEnrolledStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsEnrolledStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsenrolledstudentswithprovince"/>
                            </option> 
                            
                            <option value="StatsEnrolledStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsEnrolledStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsenrolledstudentsage"/>
                            </option>
                            
                            <option value="StatsNewEnrolledStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsNewEnrolledStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsnewenrolledstudentswithgender"/>
                            </option>
                            
                            <option value="StatsNewEnrolledStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsNewEnrolledStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsnewenrolledstudentswithprovince"/>
                            </option>
                            
                            <option value="StatsNewEnrolledStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsNewEnrolledStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsnewenrolledstudentsage"/>
                            </option> 
                                                        
                            <option value="StatsActivelyRegistratedStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsActivelyRegistratedStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyregistratedstudentswithgender"/>
                            </option>  
                            
                            <option value="StatsActivelyRegistratedStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsActivelyRegistratedStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyregistratedstudentswithprovince"/>
                            </option>  
                            
                            <option value="StatsActivelyRegistratedStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsActivelyRegistratedStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyregistratedstudentsage"/>
                            </option>
                            <%-- Acrescimo --%>
                            <option value="StatsRepeaterStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsRepeaterStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyrepeaterstudentswithgender"/>
                            </option>  
                            
                            <option value="StatsRepeaterStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsRepeaterStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyrepeaterstudentswithprovince"/>
                            </option>  
                            
                            <option value="StatsRepeaterStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsRepeaterStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyrepeaterstudentswithage"/>
                            </option>
                         <%--   fim de acrescimo --%>
                            
                            <option value="StatsWithdrawnStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsWithdrawnStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statswithdrawnstudentswithgender"/>
                            </option>
                            
                            <option value="StatsWithdrawnStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsWithdrawnStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statswithdrawnstudentswithprovince"/>
                            </option> 
                            
                            <option value="StatsWithdrawnStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsWithdrawnStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statswithdrawnstudentsage"/>
                            </option>
                            
                            <option value="StatsCanceledRegistrationStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsCanceledRegistrationStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statscanceledregistrationstudentswithgender"/>
                            </option>
                            
                            <option value="StatsCanceledRegistrationStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsCanceledRegistrationStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statscanceledregistrationstudentswithprovince"/>
                            </option> 
                            
                            <option value="StatsCanceledRegistrationStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsCanceledRegistrationStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statscanceledregistrationstudentsage"/>
                            </option>
                            
                            <option value="StatsTemporarilyInativeStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsTemporarilyInativeStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statstemporarilyInativestudentswithgender"/>
                            </option>
                            
                            <option value="StatsTemporarilyInativeStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsTemporarilyInativeStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statstemporarilyInativestudentswithprovince"/>
                            </option> 
                            
                            <option value="StatsTemporarilyInativeStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsTemporarilyInativeStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statstemporarilyInativestudentsage"/>
                            </option>
                            
                            <option value="StatsGraduateStudentsWithGender"
                            <c:choose><c:when test="${reportName == 'StatsGraduateStudentsWithGender'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsgraduatestudentswithgender"/>
                            </option>
                            
                            <option value="StatsGraduateStudentsWithProvince"
                            <c:choose><c:when test="${reportName == 'StatsGraduateStudentsWithProvince'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsgraduatestudentswithprovince"/>
                            </option>                                           
                            
                            <option value="StatsGraduateStudentsAge"
                            <c:choose><c:when test="${reportName == 'StatsGraduateStudentsAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsgraduatestudentsage"/>
                            </option>
                            
                            <option value="StatsActivelyRegistratedStudentsWithGenderAll"
                            <c:choose><c:when test="${reportName == 'StatsActivelyRegistratedStudentsWithGenderAll'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsactivelyregistratedstudentswithgenderall"/>
                            </option>
                            
                            <option value="StatsInativeRegistratedStudentsWithGenderAll"
                            <c:choose><c:when test="${reportName == 'StatsInativeRegistratedStudentsWithGenderAll'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statsinactiveregistratedstudentswithgenderall"/>
                            </option>
                            
                            <option value="StatisticCnac"
                            <c:choose><c:when test="${reportName == 'StatisticCnac'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.statisticcnac"/>
                            </option>
                            
                            
                                                     
                            <%-- <option value="StatsGraduatedStudents"
                            <c:choose><c:when test="${reportName == 'StatsGraduatedStudents'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.graduatedStudents"/>
                            </option> --%>
                            
                            <%-- <option value="StatsGraduatedStudentsPerProvinceOfOrigin"
                            <c:choose><c:when test="${reportName == 'StatsGraduatedStudentsPerProvinceOfOrigin'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.graduatedStudentsPerProvince"/>
                            </option>
                            
                            <option value="StatsGraduatedStudentsPerProvinceOfOriginAndAge"
                            <c:choose><c:when test="${reportName == 'StatsGraduatedStudentsPerProvinceOfOriginAndAge'}"> 
                            selected</c:when></c:choose>
                            ><fmt:message key="jsp.statistics.graduatedStudentsPerAge"/>
                            </option> --%>
                            
                            
                         

                        </select>
                    </form>
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.reports.OutPutReport" /></td>
                    <form name="reportFormatForm" method="POST" target="_self">
                        <input type="hidden" name="institutionId" value="${institutionId}" />
                        <input type="hidden" name="branchId" value="${branchId}" />
                        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                        <input type="hidden" name="academicYearId" value="${academicYearId}"/>
                        <input type="hidden" name="reportName" value="${reportName}" />
                        <%@ include file="../../includes/ReportFormatsScreenPdfExcel.jsp"%>
                    </form>
            </tr>
            <tr>
                <td>
                    <form name="showReport" action="<c:url value='/report/statisticsoverview.view'/>" method="POST" target="_blank"
<%--                     <c:choose><c:when test="${reportName == 'StatsStudentsPerProvinceOfOrigin'}"> --%>
<%--                     onsubmit="if(window.document.getElementById('academicYearId').value=='0'){alert('<fmt:message key='jsp.alert.selectatleasta' /><fmt:message key="jsp.general.academicyear" />');return false;}" --%>
<%--                     </c:when></c:choose> --%>
                    >
                        <input type="hidden" name="reportName" value="${reportName}" />
                        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                        <input type="hidden" name="whereNot0.organizationalunit.branchid" value="${branchId}" />
                        <input type="hidden" name="whereNot0.organizationalunit.id" value="${organizationalUnitId}" />
                        <input type="hidden" name="whereNot0.academicYear.id" value="'${academicYearId}'" />
                        <input type="hidden" name="operation" id="operation" value="makestatisticsreport" />
                        <input value="<fmt:message key="jsp.general.create.report" />" type="submit">
                    </form>
                </td>
            </tr>
        </table>
        </fieldset>
        </div>
    </div>
<%@ include file="../../footer.jsp"%>
