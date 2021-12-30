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
 * author : Markus Pscheidt
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:set var="screentitlekey">jsp.historyreport.header</c:set>
<%@ include file="../../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />  <%-- date picker --%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

        
    <div id="tabcontent">
    
        <fieldset>
            <legend><fmt:message key="jsp.historyreport.header"/></legend>
<!--             <p align="left"> -->
            <form:form modelAttribute="historyReportForm" method="post" name="historyReportForm" target="_blank">
            <table>
            <tr>
                <td class="label"><fmt:message key="jsp.historyreport.table" /></td>
                <td>
                    <form:select path="tableName" >
                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                        
                        <c:if test="${not empty modulesMap['accommodationModule']}">
                        	<form:option value="acc_block"><fmt:message key="jsp.historyreport.table.acc_block" /></form:option>
                        	<form:option value="acc_hostel"><fmt:message key="jsp.historyreport.table.acc_hostel" /></form:option>
                        	<form:option value="acc_room"><fmt:message key="jsp.historyreport.table.acc_room" /></form:option>
                        	<form:option value="acc_studentaccommodation"><fmt:message key="jsp.historyreport.table.acc_studentaccommodation" /></form:option>
                        </c:if>
                        
                        <c:if test="${not empty modulesMap['feeModule']}">
                        	<form:option value="fee_fee"><fmt:message key="jsp.historyreport.table.fee_fee" /></form:option>
                        	<form:option value="fee_payment"><fmt:message key="jsp.historyreport.table.fee_payment" /></form:option>
                        </c:if>
                        
                        <form:option value="cardinaltimeunitresult"><fmt:message key="jsp.historyreport.table.cardinaltimeunitresult" /></form:option>                        
                        <form:option value="examinationresult"><fmt:message key="jsp.historyreport.table.examinationresult" /></form:option>
                        <form:option value="financialtransaction"><fmt:message key="jsp.historyreport.table.financialtransaction" /></form:option>
                        <form:option value="staffmember"><fmt:message key="jsp.historyreport.table.staffmember" /></form:option>
                        <form:option value="student"><fmt:message key="jsp.historyreport.table.student" /></form:option>
                        <form:option value="studentabsence"><fmt:message key="jsp.historyreport.table.studentabsence" /></form:option>
                        <form:option value="studentexpulsion"><fmt:message key="jsp.historyreport.table.studentexpulsion" /></form:option>
                        <form:option value="studyplanresult"><fmt:message key="jsp.historyreport.table.studyplanresult" /></form:option>
                        <form:option value="subjectresult"><fmt:message key="jsp.historyreport.table.subjectresult" /></form:option>
                        <form:option value="testresult"><fmt:message key="jsp.historyreport.table.testresult" /></form:option>
                        <form:option value="thesisresult"><fmt:message key="jsp.historyreport.table.thesisresult" /></form:option>                    
                    </form:select>
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                <td>
                    <form:input path="startDate" cssClass="datePicker" />
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.enddate" /></td>
                <td>
                    <form:input path="endDate" cssClass="datePicker" />
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.historyreport.operation" /></td>
                <td>
                    <form:checkbox path="insert" id="insertCheckBox"/>
                    <label for="insertCheckBox"><fmt:message key="jsp.historyreport.operation.insert" /></label>
                    
                    <form:checkbox path="update" id="updateCheckBox"/>
                    <label for="updateCheckBox"><fmt:message key="jsp.historyreport.operation.update" /></label>
                    
                    <form:checkbox path="delete" id="deleteCheckBox"/>
                    <label for="deleteCheckBox"><fmt:message key="jsp.historyreport.operation.delete" /></label>
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.historyreport.writewho" /></td>
                <td>
                    <form:input path="writeWho"/>
                </td>
            </tr>

            </table>

            <table width="100%">
                <tr>
                    <td align="center">
                        <input type="submit" id="submit_button" name="submitButton" value="<fmt:message key='jsp.general.create.report'/>"
<%--                        <c:if test="${empty historyReportForm.tableName}">
                            disabled
                        </c:if>--%>
                        />
                    </td>
                </tr>
            </table>
            </form:form>
                
        </fieldset>

    </div>

</div>

<%@ include file="../../footer.jsp"%>
