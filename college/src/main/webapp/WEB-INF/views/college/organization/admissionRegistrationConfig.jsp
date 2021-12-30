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

<%@ include file="../../header.jsp"%>

<body>

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="admissionRegistrationConfigForm" value="${admissionRegistrationConfigForm}" />
    <c:set var="navigationSettings" value="${form.navigationSettings}" scope="page" />
    <c:set var="tab" value="${form.navigationSettings.tab}" />
    <c:set var="panel" value="${form.navigationSettings.panel}" />
    <c:set var="currentPageNumber" value="${form.navigationSettings.currentPageNumber}" />

    <div id="tabcontent">

        <fieldset>
            <legend>
                <a href="<c:url value='/college/organizationalunits.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
                <a href="<c:url value='/college/organizationalunit.view?tab=${tab}&panel=${panel}&organizationalUnitId=${admissionRegistrationConfigForm.admissionRegistrationConfig.organizationalUnitId}&currentPageNumber=${currentPageNumber}'/>">
                    <c:out value="${fn:substring(admissionRegistrationConfigForm.organizationalUnit.organizationalUnitDescription,0,initParam.iTitleLength)}"/>
                </a>
                &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.registration.periods" /> 
            </legend>
        </fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.registration.periods" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.registration.period" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="admissionRegistrationConfigForm" method="post">
                                
                                <table>
                                    <tr>
                                        <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
                                        <td class="required">
                                            <form:select path="admissionRegistrationConfig.academicYearId" >
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="year" items="${admissionRegistrationConfigForm.allAcademicYears}">
                                                    <form:option value="${year.id}"><c:out value="${year.description}"/></form:option>
                                                </c:forEach>
                                            </form:select>
                                        </td>
                                        <td><form:errors cssClass="error" path="admissionRegistrationConfig.academicYearId"/></td>
                                    </tr>
                                    <c:if test="${modules != null && modules != ''}">
                                       <c:forEach var="module" items="${modules}">
                                            <c:if test="${fn:toLowerCase(module.module) == 'admission'}">
		                                        <tr>
		                                            <td class="label"><b><fmt:message key="jsp.general.startdate" /> <fmt:message key="jsp.general.initialadmission"/></b></td>
		                                            <spring:bind path="admissionRegistrationConfig.startOfAdmission">
		                                                <td class="required">
		    		                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
		    		                                        <table>
		    	                                                <tr>
		    	                                                    <td><fmt:message key="jsp.general.day" /></td>
		    	                                                    <td><fmt:message key="jsp.general.month" /></td>
		    	                                                    <td><fmt:message key="jsp.general.year" /></td>
		    	                                                </tr>
		    	                                                <tr>
		    	                                                    <td><input type="text" id="start_ai_day" name="start_ai_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfAdmission','day',document.getElementById('start_ai_day').value);" /></td>
		    	                                                    <td><input type="text" id="start_ai_month" name="start_ai_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfAdmission','month',document.getElementById('start_ai_month').value);" /></td>
		    	                                                    <td><input type="text" id="start_ai_year" name="start_ai_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfAdmission','year',document.getElementById('start_ai_year').value);" /></td>
		    	                                                </tr>
		    		                                        </table>
		    	                                        </td>
		    	                                        <td>
		    	                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
		    	                                        </td>
		                                            </spring:bind>
				                                </tr>
			                                    <tr>
			                                        <td class="label"><b><fmt:message key="jsp.general.enddate" /> <fmt:message key="jsp.general.initialadmission"/></b></td>
	                                                <spring:bind path="admissionRegistrationConfig.endOfAdmission">
			                                        <td class="required">
			                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
			                                        <table>
			                                                <tr>
			                                                    <td><fmt:message key="jsp.general.day" /></td>
			                                                    <td><fmt:message key="jsp.general.month" /></td>
			                                                    <td><fmt:message key="jsp.general.year" /></td>
			                                                </tr>
			                                                <tr>
			                                                    <td><input type="text" id="end_ai_day" name="end_ai_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfAdmission','day',document.getElementById('end_ai_day').value);" /></td>
			                                                    <td><input type="text" id="end_ai_month" name="end_ai_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfAdmission','month',document.getElementById('end_ai_month').value);" /></td>
			                                                    <td><input type="text" id="end_ai_year" name="end_ai_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfAdmission','year',document.getElementById('end_ai_year').value);" /></td>
			                                                </tr>
			                                        </table>
			                                        </td>
			                                        <td>
			                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
			                                        </td>
	                                                </spring:bind>
			                                    </tr>
		                                    </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.startdate" /> <fmt:message key="jsp.general.continuedregistration"/></b></td>
                                        <spring:bind path="admissionRegistrationConfig.startOfRegistration">
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="start_ti_day" name="start_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRegistration','day',document.getElementById('start_ti_day').value);" /></td>
                                                    <td><input type="text" id="start_ti_month" name="start_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRegistration','month',document.getElementById('start_ti_month').value);" /></td>
                                                    <td><input type="text" id="start_ti_year" name="start_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRegistration','year',document.getElementById('start_ti_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.enddate" /> <fmt:message key="jsp.general.continuedregistration"/></b></td>
                                        <spring:bind path="admissionRegistrationConfig.endOfRegistration">
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="end_ti_day" name="end_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRegistration','day',document.getElementById('end_ti_day').value);" /></td>
                                                    <td><input type="text" id="end_ti_month" name="end_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRegistration','month',document.getElementById('end_ti_month').value);" /></td>
                                                    <td><input type="text" id="end_ti_year" name="end_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRegistration','year',document.getElementById('end_ti_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <c:if test="${modules != null && modules != ''}">
					                   <c:forEach var="module" items="${modules}">
					                        <c:if test="${fn:toLowerCase(module.module) == 'fee'}">
			                                    <tr>
			                                        <td class="label"><b><fmt:message key="jsp.general.startdate" /> <fmt:message key="jsp.general.refundperiod"/></b></td>
			                                        <spring:bind path="admissionRegistrationConfig.startOfRefundPeriod">
                                                    <td class="required">
			                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
			                                        <table>
			                                                <tr>
			                                                    <td><fmt:message key="jsp.general.day" /></td>
			                                                    <td><fmt:message key="jsp.general.month" /></td>
			                                                    <td><fmt:message key="jsp.general.year" /></td>
			                                                </tr>
			                                                <tr>
			                                                    <td><input type="text" id="start_rp_day" name="start_rp_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRefundPeriod','day',document.getElementById('start_rp_day').value);" /></td>
			                                                    <td><input type="text" id="start_rp_month" name="start_rp_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRefundPeriod','month',document.getElementById('start_rp_month').value);" /></td>
			                                                    <td><input type="text" id="start_rp_year" name="start_rp_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.startOfRefundPeriod','year',document.getElementById('start_rp_year').value);" /></td>
			                                                </tr>
			                                        </table>
			                                        </td>
			                                        <td>
			                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
			                                        </td>
                                                    </spring:bind>
			                                    </tr>
			                                    <tr>
			                                        <td class="label"><b><fmt:message key="jsp.general.enddate" /> <fmt:message key="jsp.general.refundperiod"/></b></td>
			                                        <spring:bind path="admissionRegistrationConfig.endOfRefundPeriod">
                                                    <td class="required">
			                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
			                                        <table>
			                                                <tr>
			                                                    <td><fmt:message key="jsp.general.day" /></td>
			                                                    <td><fmt:message key="jsp.general.month" /></td>
			                                                    <td><fmt:message key="jsp.general.year" /></td>
			                                                </tr>
			                                                <tr>
			                                                    <td><input type="text" id="end_rp_day" name="end_rp_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRefundPeriod','day',document.getElementById('end_rp_day').value);" /></td>
			                                                    <td><input type="text" id="end_rp_month" name="end_rp_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRefundPeriod','month',document.getElementById('end_rp_month').value);" /></td>
			                                                    <td><input type="text" id="end_rp_year" name="end_rp_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('admissionRegistrationConfig.endOfRefundPeriod','year',document.getElementById('end_rp_year').value);" /></td>
			                                                </tr>
			                                        </table>
			                                        </td>
			                                        <td>
			                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
			                                        </td>
                                                    </spring:bind>
			                                    </tr>
			                                </c:if>
			                            </c:forEach>
					                </c:if>            
                                    <!-- ACTIVE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.active" /></td>
                                        <td>
                                            <form:select path="admissionRegistrationConfig.active" class="long">
                                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                            </form:select>
                                        </td>
                                    </tr>                                               
 
                                    <tr><td class="label">&nbsp;</td><td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>

                                </table>

                                </form:form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                            
                        </script>
                    </div>     
            </div>
        </div>



    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

