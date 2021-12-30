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

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="navigationSettings" value="${contractForm.navigationSettings}" />
    <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
    <c:set var="tab" value="${navigationSettings.tab}" />
    <c:set var="panel" value="${navigationSettings.panel}" />

    <c:set var="staffMember" value="${contractForm.staffMember}" />

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/staffmembers.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
				<a href="<c:url value='/college/staffmember.view?newForm=true&tab=2&panel=1&staffMemberId=${staffMember.staffMemberId}&currentPageNumber=${currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${staffMember.surnameFull != null && staffMember.surnameFull != ''}" >
    					<c:set var="staffMemberName" value="${staffMember.surnameFull}, ${staffMember.firstnamesFull}" scope="page" />
    					<c:out value="${fn:substring(staffMemberName,0,initParam.iTitleLength)}"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.contract" /> 
			</legend>
		</fieldset>


        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.contracts" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion0" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.contract" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="contractForm.contract" method="post">
                                <input type="hidden" name="tab_contract" value="2" /> 
                                <input type="hidden" name="panel_contract" value="1" />
                                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
                                
                                    <table>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.contract.code" /></b></td>
                                        <spring:bind path="contractCode">
                                        <td>
                                        <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.contract.type" /></td>
                                        <spring:bind path="contractTypeCode">
                                        <td class="required">
                                        <select name="${status.expression}">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="contractType" items="${contractForm.allContractTypes}">
                                               <c:choose>
                                                <c:when test="${contractType.code == status.value}">
                                                    <option value="${contractType.code}" selected="selected"><c:out value="${contractType.description}"/></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${contractType.code}"><c:out value="${contractType.description}"/></option>
                                                </c:otherwise>
                                               </c:choose>
                                            </c:forEach>
                                        </select>
                                        </td> 
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.contract.duration" /></td>
                                        <spring:bind path="contractDurationCode">
                                        <td>
                                        <select name="${status.expression}">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="contractDuration" items="${contractForm.allContractDurations}">
                                               <c:choose>
                                                <c:when test="${contractDuration.code == status.value}">
                                                    <option value="${contractDuration.code}" selected="selected"><c:out value="${contractDuration.description}"/></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${contractDuration.code}"><c:out value="${contractDuration.description}"/></option>
                                                </c:otherwise>
                                               </c:choose>
                                            </c:forEach>
                                        </select>
                                        </td> 
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>

                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                                        <spring:bind path="contractStartDate">
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                        	            <table>
                                            	<tr>
                                            		<td><fmt:message key="jsp.general.day" /></td>
                                            		<td><fmt:message key="jsp.general.month" /></td>
                                            		<td><fmt:message key="jsp.general.year" /></td>
                                            	</tr>
                                                <tr>
                                            		<td><input type="text" id="contract_start_day" name="contract_start_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('contract.contractStartDate','day',document.getElementById('contract_start_day').value);" /></td>
                                            		<td><input type="text" id="contract_start_month" name="contract_start_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('contract.contractStartDate','month',document.getElementById('contract_start_month').value);" /></td>
                                            		<td><input type="text" id="contract_start_year" name="contract_start_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('contract.contractStartDate','year',document.getElementById('contract_start_year').value);" /></td>
                                            	</tr>
                                        </table>
                             			</td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.enddate" /></td>
                                        <spring:bind path="contractEndDate">
                                        <td>
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                        	            <table>
                                            	<tr>
                                            		<td><fmt:message key="jsp.general.day" /></td>
                                            		<td><fmt:message key="jsp.general.month" /></td>
                                            		<td><fmt:message key="jsp.general.year" /></td>
                                            	</tr>
                                                <tr>
                                            		<td><input type="text" id="contract_end_day" name="contract_end_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('contract.contractEndDate','day',document.getElementById('contract_end_day').value);" /></td>
                                            		<td><input type="text" id="contract_end_month" name="contract_end_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('contract.contractEndDate','month',document.getElementById('contract_end_month').value);" /></td>
                                            		<td><input type="text" id="contract_end_year" name="contract_end_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('contract.contractEndDate','year',document.getElementById('contract_end_year').value);" /></td>
                                            	</tr>
                                        </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.contacthours" /></td>
                                        <spring:bind path="contactHours"><td>
                                        <input type="text" name="${status.expression}" size="10" value="<c:out value="${status.value}" />"  /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td></spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.fteappointment.overall" /></td>
                                        <spring:bind path="fteAppointmentOverall"><td>
                                        <input type="text" name="${status.expression}" size="3" value="<c:out value="${status.value}" />"  /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td></spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.fteappointment.research" /></td>
                                        <spring:bind path="fteResearch"><td>
                                        <input type="text" name="${status.expression}" size="3" value="<c:out value="${status.value}" />"  /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td></spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.fteappointment.education" /></td>
                                        <spring:bind path="fteEducation"><td>
                                        <input type="text" name="${status.expression}" size="3" value="<c:out value="${status.value}" />"  /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td></spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.fteappointment.administrative" /></td>
                                        <spring:bind path="fteAdministrativeTasks"><td>
                                        <input type="text" name="${status.expression}" size="3" value="<c:out value="${status.value}" />"  /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td></spring:bind>
                                    </tr>

                                    <tr><td class="label">&nbsp;</td><td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>

                                </table>

                                </form:form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var Accordion0 = new Spry.Widget.Accordion("Accordion0",
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
        //tp1.showPanel(<%=request.getParameter("tab")%>);
        tp1.showPanel(0);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

