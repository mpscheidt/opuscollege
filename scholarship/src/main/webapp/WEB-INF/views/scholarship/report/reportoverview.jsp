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
--%>
<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>

    <div id="tabwrapper">
        
        <%@ include file="../../menu.jsp"%>

        <div id="tabcontent">

        <fieldset>
        <legend><fmt:message key="jsp.general.reports" /></legend>
        </fieldset>

        <form name="orgUnits"  method="POST" target="_self">
        <input type="hidden" name="reportName" value="${reportName}" />
        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
        <table>
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.organizationalunit" /></b></td>
            <td width="200">
            <!-- spring:bind path="command.organizationalUnitId"-->
            <select name="organizationalUnitId" onchange="document.orgUnits.submit();">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
                   <c:choose>
                        <c:when test="${ oneOrganizationalUnit.id == organizationalUnitId }"> 
                            <option value="${oneOrganizationalUnit.id}" selected="selected">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${oneOrganizationalUnit.id}">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                        </c:otherwise>
                    </c:choose>
                    ${oneOrganizationalUnit.organizationalUnitDescription} (<fmt:message key="jsp.organizationalunit.level" /> ${oneOrganizationalUnit.unitLevel})</option>
                </c:forEach>
            </select>
            </td>
        </tr>
        </table>
        </form>

        <form name="academicYears"  method="POST" target="_self">
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="reportName" value="${reportName}" />
        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
        <table>
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.academicyear" /></b></td>
            <td width="200" >
            <select name="academicYearId" onchange="document.academicYears.submit();">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>                            
                <!--c:choose-->
                    <!--c:when test="${(organizationalUnitId != null) && (organizationalUnitId != 0)}"-->
                        <c:forEach var="year" items="${allAcademicYears}">                          
                            <c:choose>
                                <c:when test="${year.id == academicYearId}">
                                    <option value="${year.id}" selected="selected">${year.description}</option>
                                 </c:when>
                                <c:otherwise>
                                    <option value="${year.id}">${year.description}</option>                            
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    <!--/c:when-->
                <!--/c:choose-->
            </select>
            </td> 
        </tr>
        </table>
        </form>

        <form name="reportNameForm" method="POST" target="_self">
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="academicYearId" value="${academicYearId}"/>
        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
        <table>
        <tr>
			<td class="label"><b><fmt:message key="jsp.general.report" /></b></td>
            <td width="200">
			<select  name="reportName" onchange="document.reportNameForm.submit();">
<!-- 				<option value="0"><fmt:message key="jsp.selectbox.choose"/></option> -->							
				<option value="schp_applyedFor"
	            <c:choose><c:when test="${reportName == 'schp_applyedFor'}">
	            selected
	            </c:when></c:choose>
				><fmt:message key="jsp.general.scholarshipreporttitle"/></option>
			</select>
            </td> 
            <td></td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
        </tr>
        </table>
        </form>

        <form name="reportFormatForm" method="POST" target="_self">
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="academicYearId" value="${academicYearId}"/>
        <input type="hidden" name="reportName" value="${reportName}" />
        <table><tr>
		<td class="label"><fmt:message key="jsp.reports.OutPutReport" /></td>
        <%@ include file="../../includes/ReportFormatsScreenPdfExcel.jsp"%>
        </tr></table>
        </form>

        <form name="showReport" action="<c:url value='/college/reports.view'/>" method="POST" target="_blank">
        <input type="hidden" name="reportName" value="${reportName}" />
        <input type="hidden" name="reportFormat" value="${reportFormat}"/>
        <input type="hidden" name="whereNot0.organizationalunit.id" value="${organizationalUnitId}" />
        <input type="hidden" name="whereNot0.academicyear.id" value="${academicYearId}" />
        <table>
        <tr>
            <td>
            <input type="button" name="submitShowReport" value="<fmt:message key="jsp.general.create.report" />" onclick="document.showReport.submit();" />
            </td>
        </tr>
        </table>
        </form>
        
        <!--br>

        <h3><fmt:message key="jsp.general.scholarshipreporttitle" /></h3> 

        <form name="showReportScholarship" action="<c:url value='/scholarship/scholarshipreports.view'/>" method="POST" target="_self">
        <input type="hidden" name="reportName" value="schp_applyFor" />
        <input type="hidden" name="whereNot0.organizationalunit.id" value="${organizationalUnitId}" />
        <input type="hidden" name="whereNot0.academicyear.id" value="${academicYearId}" />
        <table>
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.outputformat" /></b></td>
            <td width="120"><input name="reportFormat2" value="pdf" type="radio" checked="checked"><fmt:message key="jsp.general.pdf" /></td>
            <td width="120"><input name="reportFormat2" value="html" type="radio"><fmt:message key="jsp.general.screen" /></td>
            <td width="120"><input name="reportFormat2" value="xls" type="radio"><fmt:message key="jsp.general.excel" /></td>
        </tr>

        <tr>
            <td>
            <input type="button" name="submitShowReport" value="<fmt:message key="jsp.button.submit" />" onclick="document.showReportScholarship.submit();" />
            </td>
        </tr>
        </table>
        </form-->
    </div>

</div>

<%@ include file="../../footer.jsp"%>
