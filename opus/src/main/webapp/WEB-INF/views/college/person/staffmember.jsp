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
<%@ include file="../../includes/standardincludes.jsp"%>

<c:if test="${not empty staffMemberForm.staffMember.surnameFull}" >
    <c:set var="staffMemberName"><c:out value="${staffMemberForm.staffMember.surnameFull}, ${staffMemberForm.staffMember.firstnamesFull}"/></c:set>
    <c:set var="screentitledetails">${fn:substring(staffMemberName,0,initParam.iTitleLength)}</c:set>
</c:if>

<c:set var="screentitlekey">${staffMemberForm.staffMember.id == 0 ? 'general.add.staffmember' : 'jsp.general.staffmember'}</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="organization" value="${staffMemberForm.organization}" scope="page" />
    <c:set var="navigationSettings" value="${staffMemberForm.navigationSettings}" scope="page" />

    <%--  page vars --%>
    <c:set var="commandId" value="${staffMemberForm.staffMember.id}" scope="page" />
    <c:set var="personId" value="${staffMemberForm.staffMember.personId}" scope="page" />
    <c:set var="commandStaffMemberid" value="${staffMemberForm.staffMember.staffMemberId}" scope="page" />
    
    <%--  authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_STAFFMEMBERS','UPDATE_STAFFMEMBERS')">
        <c:set var="editPersonalData" value="${true}"/>
    </sec:authorize>

    <c:if test="${not editPersonalData}">
        <sec:authorize access="hasRole('READ_STAFFMEMBERS') or ${personId == opusUser.personId}">
            <c:set var="showPersonalData" value="${true}"/>
        </sec:authorize>
    </c:if>

    <sec:authorize access="!hasAnyRole('UPDATE_OPUSUSER')">
        <sec:authorize access="hasRole('READ_OPUSUSER') or ${personId == opusUser.personId}">
            <c:set var="showOpusUserData" value="${true}"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_OPUSUSER')">
        <c:set var="editOpusUserData" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('READ_STAFFMEMBER_CONTRACTS')">
        <c:set var="showContracts" value="${true}"/>
    </sec:authorize>         

    <sec:authorize access="hasRole('CREATE_STAFFMEMBER_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToCreateAddress" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STAFFMEMBER_ADDRESSES')">
        <sec:authorize access="hasRole('READ_STAFFMEMBER_ADDRESSES')">
            <c:set var="showAddresses" value="${true}"/>
         </sec:authorize>
    </sec:authorize>
    
    <sec:authorize access="hasRole('UPDATE_STAFFMEMBER_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="editAddresses" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_STAFFMEMBER_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToEditAddress" value="${true}"/>
    </sec:authorize>
    
    <sec:authorize access="hasRole('DELETE_STAFFMEMBER_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToDeleteAddress" value="${true}"/>
    </sec:authorize>
 
    <sec:authorize access="hasRole('READ_SUBJECT_TEACHERS') or ${personId == opusUser.personId}">
        <c:set var="showSubjects" value="${true}"/>
    </sec:authorize>
    
    <sec:authorize access="hasRole('READ_EXAMINATION_SUPERVISORS') or ${personId == opusUser.personId}">
        <c:set var="showExaminations" value="${true}"/>
    </sec:authorize>
 
    <sec:authorize access="hasRole('READ_TEST_SUPERVISORS') or ${personId == opusUser.personId}">
         <c:set var="showTests" value="${true}"/>
    </sec:authorize>
    
    
    <div id="tabcontent">
        <fieldset><legend>
            <a href="<c:url value='/college/staffmembers.view'/>?<c:out value='currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
            ${screentitle}
        </legend>
        
        <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
        <form:errors path="staffMemberForm.*" cssClass="errorwide" element="p"/>

        </fieldset>

<%--<form name="formdata" method="post" onsubmit="document.getElementById('navigationSettings.tab').value=tp1.getCurrentTabIndex();document.getElementById('navigationSettings.panel').value=window['Accordion'+tp1.getCurrentTabIndex()].getCurrentPanelIndex(); "> --%>
<form:form modelAttribute="staffMemberForm" method="post" enctype="multipart/form-data">
    <%--  input type="hidden" name="from" value="staffmember" /
    <input type="hidden" name="tab_personaldata" value="0" /> 
    <input type="hidden" name="panel_personaldata" value="0" />
    <input type="hidden" name="submitFormObject_personaldata" id="submitFormObject_personaldata" value="" />--%> 

    <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value="<c:out value="${staffMemberForm.navigationSettings.tab}" />" />
    <input type="hidden" id="navigationSettings.panel" name="navigationSettings.panel" value="<c:out value="${staffMemberForm.navigationSettings.panel}" />" />

        <c:set var="accordion" value="0"/>
        
        <div id="tp1" class="TabbedPanel" onclick="document.getElementById('navigationSettings.tab').value=tp1.getCurrentTabIndex();document.getElementById('navigationSettings.panel').value=window['Accordion'+tp1.getCurrentTabIndex()].getCurrentPanelIndex(); ">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.personaldata" /></li>      
                    <spring:bind path="staffMember.staffMemberId">
	                    <c:if test="${(showOpusUserData || editOpusUserData) && '' != status.value && 0 != status.value}"> 
	                        <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.opususerdata" /></li>
	                    </c:if>
	                     <c:if test="${showContracts && '' != status.value && 0 != status.value}"> 
	                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.contracts" /></li>       
	                     </c:if>
	                    <c:if test="${(showAddresses || editAddresses) && '' != status.value && 0 != status.value}"> 
	                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.addresses" /></li>
	                    </c:if>
	                    <c:if test="${(showSubjects) && '' != status.value && 0 != status.value}">
	                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.subjects" /></li>
	                    </c:if>
	                    <c:if test="${(showExaminations) && '' != status.value && 0 != status.value}">
	                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.examinations" /></li>
	                    </c:if>
	                    <c:if test="${(showTests) && '' != status.value && 0 != status.value}">
	                        <li class="TabbedPanelsTab" ><fmt:message key="jsp.general.tests" /></li>
	                    </c:if>
	                </spring:bind>
            </ul>

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion${accordion}" tabindex="0">

                                        <%@ include file="../../includes/personDataStaffMember.jsp" %>
                    <!-- end of accordion 1 -->
                    </div>
                    
                    <script type="text/javascript">
                            var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                             {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });

                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                         
<!------------------------------- OpusUserData ------------------------------------------------- -->
                <c:choose>
                    <c:when test="${showOpusUserData || editOpusUserData && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                            <c:set var="accordion" value="${accordion + 1}"/>
                            <div class="TabbedPanelsContent">
                                <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                    <%@ include file="../../includes/opusUserDataStaffMember.jsp" %>
                                </div>
                       
                                <script type="text/javascript">
                                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                          {defaultPanel: 0,
                                          useFixedPanelHeights: false,
                                          nextPanelKeyCode: 78 /* n key */,
                                          previousPanelKeyCode: 80 /* p key */
                                         });
                                </script>

                            <!--  end tabbedpanelscontent -->
                            </div>
                    </c:when>
                </c:choose>

<!------------------------------- Appointment ------------------------------------------------- -->
                <c:choose>
                    <c:when test="${showContracts && (showOpusUserData || editOpusUserData)  && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                        <c:set var="accordion" value="${accordion + 1}"/>
                        <div class="TabbedPanelsContent">
	                       <div class="Accordion" id="Accordion${accordion}" tabindex="0">
	                   
	                    <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.appointment" /></div>
                            <div class="AccordionPanelContent">

                                    <table>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.dateofappointment" /></td>
                                            <spring:bind path="staffMember.dateOfAppointment">
                                                <td>
                                                <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                    <table>
                                                        <tr>
                                                            <td><fmt:message key="jsp.general.day" /></td>
                                                            <td><fmt:message key="jsp.general.month" /></td>
                                                            <td><fmt:message key="jsp.general.year" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td><input type="text" id="doa_day" name="doa_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('staffMember.dateOfAppointment','day',document.getElementById('doa_day').value);" /></td>
                                                            <td><input type="text" id="doa_month" name="doa_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('staffMember.dateOfAppointment','month',document.getElementById('doa_month').value);" /></td>
                                                            <td><input type="text" id="doa_year" name="doa_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('staffMember.dateOfAppointment','year',document.getElementById('doa_year').value);" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td><fmt:message key="jsp.general.message.dateformat" />
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                </td>
                                            </spring:bind>
                                        </tr>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.appointmenttype" /></td>
                                            <spring:bind path="staffMember.appointmentTypeCode">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="appointmentType" items="${staffMemberForm.allAppointmentTypes}">
                                                           <c:choose>
                                                            <c:when test="${appointmentType.code == status.value}">
                                                                <option value="${appointmentType.code}" selected="selected"><c:out value="${appointmentType.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${appointmentType.code}"><c:out value="${appointmentType.description}"/></option>
                                                            </c:otherwise>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td> 
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.stafftype" /></td>
                                            <spring:bind path="staffMember.staffTypeCode">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="staffType" items="${staffMemberForm.allStaffTypes}">
                                                           <c:choose>
                                                            <c:when test="${staffType.code == status.value}">
                                                                <option value="${staffType.code}" selected="selected"><c:out value="${staffType.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${staffType.code}"><c:out value="${staffType.description}"/></option>
                                                            </c:otherwise>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
<%-- the primary unit of appointment is the same as the organizational unit combo in the personal data tab -> REMOVE
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.primaryunitofappointment" /></td>
                                            <spring:bind path="staffMember.primaryUnitOfAppointmentId">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="organizationalUnit" items="${staffMemberForm.organization.allOrganizationalUnits}">
                                                           <c:choose>
                                                            <c:when test="${organizationalUnit.id == status.value}">
                                                                <option value="${organizationalUnit.id}" selected="selected">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${organizationalUnit.id}">
                                                            </c:otherwise>
                                                           </c:choose>
                                                           ${organizationalUnit.organizationalUnitDescription} (<fmt:message key="jsp.organizationalunit.level" /> ${organizationalUnit.unitLevel})</option>
                                                        </c:forEach>
                                                    </select>
                                                </td> 
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
 --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.workday.start" /></td>
                                            <spring:bind path="staffMember.startWorkDay">
                                                <td>
                                                    <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                    <table>
                                                        <tr>
                                                            <td><fmt:message key="jsp.general.hour" /></td>
                                                            <td><fmt:message key="jsp.general.minute" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td><input type="text" id="swd_hour" name="swd_hour" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,0,2)}" />" onchange="updateTime('staffMember.startWorkDay','hour',document.getElementById('swd_hour').value);" /></td>
                                                            <td><input type="text" id="swd_minute" name="swd_minute" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,3,5)}" />" onchange="updateTime('staffMember.startWorkDay','minute',document.getElementById('swd_minute').value);" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <fmt:message key="jsp.general.message.timeformat" />
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                </td>
                                            </spring:bind>
                                        </tr>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.workday.end" /></td>
                                            <spring:bind path="staffMember.endWorkDay">
                                                <td>
                                                    <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                    <table>
                                                        <tr>
                                                            <td><fmt:message key="jsp.general.hour" /></td>
                                                            <td><fmt:message key="jsp.general.minute" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td><input type="text" id="ewd_hour" name="ewd_hour" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,0,2)}" />" onchange="updateTime('staffMember.endWorkDay','hour',document.getElementById('ewd_hour').value);" /></td>
                                                            <td><input type="text" id="ewd_minute" name="ewd_minute" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,3,5)}" />" onchange="updateTime('staffMember.endWorkDay','minute',document.getElementById('ewd_minute').value);" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <fmt:message key="jsp.general.message.timeformat" />
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                </td>
                                            </spring:bind>
                                        </tr>

                                        <tr>
                                            <td class="label"><fmt:message key="jsp.teaching.daypart" /></td>
                                            <spring:bind path="staffMember.teachingDayPartCode">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="teachingDayPart" items="${staffMemberForm.allDayParts}">
                                                           <c:choose>
                                                            <c:when test="${teachingDayPart.code == status.value}">
                                                                <option value="${teachingDayPart.code}" selected="selected"><c:out value="${teachingDayPart.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${teachingDayPart.code}"><c:out value="${teachingDayPart.description}"/></option>
                                                            </c:otherwise>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td> 
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.supervising.daypart" /></td>
                                            <spring:bind path="staffMember.supervisingDayPartCode">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="supervisingDayPart" items="${staffMemberForm.allDayParts}">
                                                           <c:choose>
                                                            <c:when test="${supervisingDayPart.code == status.value}">
                                                                <option value="${supervisingDayPart.code}" selected="selected"><c:out value="${supervisingDayPart.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${supervisingDayPart.code}"><c:out value="${supervisingDayPart.description}"/></option>
                                                            </c:otherwise>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td> 
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.educationtype.highest" /></td>
                                            <spring:bind path="staffMember.educationTypeCode">
                                                <td>
                                                    <select name="${status.expression}">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="educationType" items="${staffMemberForm.allEducationTypes}">
                                                           <c:choose>
                                                            <c:when test="${educationType.code == status.value}">
                                                                <option value="${educationType.code}" selected="selected"><c:out value="${educationType.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${educationType.code}"><c:out value="${educationType.description}"/></option>
                                                            </c:otherwise>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td> 
                                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <tr><td colspan="3">&nbsp;</td></tr>
                                        <spring:bind path="staffMember.functions"> 
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.functions" /></td>
                                            <td colspan="2" align="right">
                                                        <a class="button" href="<c:url value='/college/function.view'/>?<c:out value='tab=${accordion}&panel=0&staffMemberId=${commandStaffMemberid}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                            <fmt:message key="jsp.href.add" />
                                                        </a>
                                                  
                                            </td>
                                        </tr>
                                        <tr>
                                            <td >&nbsp;</td>
                                            <td>
                                                <table>
                                                <c:forEach var="staffMemberFunction" items="${status.value}">
                                                <tr>
                                                    <td class="label">
                                                        <c:forEach var="function" items="${staffMemberForm.allFunctions}">
                                                           <c:choose>
                                                            <c:when test="${function.code == staffMemberFunction.functionCode}">
                                                                <b><c:out value="${function.description}"/></b>
                                                            </c:when>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <c:forEach var="functionLevel" items="${staffMemberForm.allFunctionLevels}">
                                                           <c:choose>
                                                            <c:when test="${functionLevel.code == staffMemberFunction.functionLevelCode}">
                                                                <c:out value="${functionLevel.description}"/>
                                                            </c:when>
                                                           </c:choose>
                                                        </c:forEach>                                                        
                                                    </td> 
                                                    <td align="right">
                                                           <a href="<c:url value='/college/staffmember/deletefunction/'/><c:out value='${staffMemberFunction.functionCode}'/>"
                                                              onclick="return confirm('<fmt:message key="jsp.functions.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                     </td>
                                                </tr>
                                                </c:forEach> 
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                        </spring:bind> 
                                        <tr>
                                            <td colspan="3" align="right">
                                                <input type="submit" name="submitappointmentdata" value="<fmt:message key="jsp.button.submit" />" />
                                            </td>
                                        </tr>
                                        
                                    </table>
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.contracts" /></div>
                            <div class="AccordionPanelContent">

                                    <table>
                                        <spring:bind path="staffMember.contracts">
                                        <sec:authorize access="hasRole('CREATE_STAFFMEMBER_CONTRACTS')">
                                            <tr>
                                                <td colspan="2" align="right">
                                                    <a class="button" href="<c:url value='/college/contract.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid }&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
                                            </tr>
                                        </sec:authorize>
                                        <c:choose>
                                            <c:when test="${(not empty showContractError)}">             
                                                <tr>
                                                    <td colspan="2" class="error">
                                                        <c:out value="${showContractError }"/>
                                                    </td>
                                                </tr>
                                           </c:when>
                                        </c:choose>
                                        
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                <c:forEach var="contract" items="${status.value}">
                                                <tr>
                                                    <td class="label"><b><fmt:message key="jsp.general.contract.code" /></b></td>
                                                    <c:choose>
                                                        <c:when test="${showOpusUserData || editOpusUserData}">
                                                            <td><c:out value="${contract.contractCode}"/></td>
                                                            <td align="right">
                                                                <sec:authorize access="hasRole('UPDATE_STAFFMEMBER_CONTRACTS')">
                                                                    <a class="imageLink" href="<c:url value='/college/contract.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid}&contractId=${contract.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                </sec:authorize>
                                                                <sec:authorize access="hasRole('DELETE_STAFFMEMBER_CONTRACTS')">
                                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/contract_delete.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid}&contractId=${contract.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.contracts.delete.confirm" />')">
                                                                        <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" /> "/>
                                                                    </a>
                                                                </sec:authorize>
                                                            </td>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <td><a class="imageLink" href="<c:url value='/college/contract.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid}&contractId=${contract.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">${contract.contractCode}</a></td>
                                                            <td align="right"><a href="<c:url value='/college/contract.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid}&contractId=${contract.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                            <a class="imageLinkPaddingLeft" href="<c:url value='/college/contract_delete.view'/>?<c:out value='tab=${accordion}&panel=1&staffMemberId=${commandStaffMemberid}&contractId=${contract.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.contracts.delete.confirm" />')">
                                                                <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" /> "/>
                                                            </a>
                                                            </td>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.contract.type" /></td>
                                                    <td>
                                                        <c:forEach var="contractType" items="${staffMemberForm.allContractTypes}">
                                                           <c:choose>
                                                            <c:when test="${contractType.code == contract.contractTypeCode}">
                                                                <c:out value="${contractType.description}"/>
                                                            </c:when>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </td> 
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.contract.duration" /></td>
                                                    <td>
                                                        <c:forEach var="contractDuration" items="${staffMemberForm.allContractDurations}">
                                                           <c:choose>
                                                            <c:when test="${contractDuration.code == contract.contractDurationCode}">
                                                                <c:out value="${contractDuration.description}"/>
                                                            </c:when>
                                                           </c:choose>
                                                        </c:forEach>
                                                    </td> 
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                                                    <td>
                                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${contract.contractStartDate}" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.enddate" /></td>
                                                    <td>
                                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${contract.contractEndDate}" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.contacthours" /></td>
                                                    <td><c:out value="${contract.contactHours}"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.fteappointment.overall" /></td>
                                                    <td><c:out value="${contract.fteAppointmentOverall}"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.fteappointment.research" /></td>
                                                    <td><c:out value="${contract.fteResearch}"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.fteappointment.education" /></td>
                                                    <td><c:out value="${contract.fteEducation}"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.fteappointment.administrative" /></td>
                                                    <td><c:out value="${contract.fteAdministrativeTasks}"/></td>
                                                </tr>
                                                <tr><td>&nbsp;</td></tr>
                                                </c:forEach> 
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                        </spring:bind> 
                                        
                                    </table>

                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                        
                    <!-- end of accordion 2 -->
                    </div>
                 	     <script type="text/javascript">
	                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
	                              {defaultPanel: 0,
	                              useFixedPanelHeights: false,
	                              nextPanelKeyCode: 78 /* n key */,
	                              previousPanelKeyCode: 80 /* p key */
	                             });
	                    </script>
                    </div> <!--  end tabbedpanelscontent -->
                    </c:when>
                </c:choose>

<!------------------------------- Addresses ------------------------------------------------- -->
                <c:choose>
                    <c:when test="${authorizedToCreateAddress || showAddresses || editAddresses && (showOpusUserData || editOpusUserData)
                            && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                		<c:set var="accordion" value="${accordion + 1}"/>
                        
                		<div class="TabbedPanelsContent">
                        
                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                       
	                        <div class="AccordionPanel">
	                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.addresses" /></div>
	                            <div class="AccordionPanelContent">

                                     <c:set var="countAddressTypes" value="0" scope="page" />
                                     <c:set var="countUsedAddressTypes" value="0" scope="page" />

                                     <spring:bind path="staffMember.addresses">
                                        <c:forEach var="addressType" items="${staffMemberForm.allAddressTypes}">
                                            <c:set var="countAddressTypes" value="${countAddressTypes + 1}" scope="page" />
                                            <c:forEach var="address" items="${status.value}">
                                                <c:choose>
                                                    <c:when test="${addressType.code == address.addressTypeCode }">
                                                        <c:set var="countUsedAddressTypes" value="${countUsedAddressTypes + 1}" scope="page" />
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                        </c:forEach>
                                    </spring:bind>

                                    <c:url var="addressNewString" value="/college/address.view">
                                        <c:param name="newForm" value="${true}"/>
                                        <c:param name="tab" value="${accordion}" />
                                        <c:param name="panel" value="0" />
                                        <c:param name="from" value="staffmember" />
                                        <c:param name="personId" value="${commandId}" />
                                        <c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
                                    </c:url>

                                    <table>
                                         <c:if test="${authorizedToCreateAddress}">
                                            <c:choose> 
                                                <c:when test="${countAddressTypes != countUsedAddressTypes}">
                                                    <tr>
                                                        <td colspan="3" align="right">
                                                            <a class="button" href="<c:out value='${addressNewString}'/>">
                                                                <fmt:message key="jsp.href.add" />
                                                            </a>
                                                        </td>
                                                     </tr>
                                                </c:when>
                                             </c:choose>
                                         </c:if>

                                        <%-- lists needed by addressData.jsp --%>
                                        <c:set var="allCountries" value="${staffMemberForm.allCountries}" />
                                        <c:set var="allProvinces" value="${staffMemberForm.allProvinces}" />
                                        <c:set var="allDistricts" value="${staffMemberForm.allDistricts}" />
                                        <c:set var="allAdministrativePosts" value="${staffMemberForm.allAdministrativePosts}" />

                                        <spring:bind path="staffMember.addresses">
                                            <c:forEach var="address" items="${status.value}">

                                                <c:url var="addressViewString" value="/college/address.view">
                                                    <c:param name="newForm" value="${true}"/>
                                                    <c:param name="addressId" value="${address.id}"/>
                                                    <c:param name="tab" value="${accordion}" />
                                                    <c:param name="panel" value="0" />
                                                    <c:param name="from" value="staffmember" />
                                                    <c:param name="personId" value="${commandId}" />
                                                    <c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
                                                </c:url>
                                                <c:url var="addressDeleteString" value="/college/address_delete.view">
                                                    <c:param name="newForm" value="${true}"/>
                                                    <c:param name="addressId" value="${address.id}"/>
                                                    <c:param name="tab" value="${accordion}" />
                                                    <c:param name="panel" value="0" />
                                                    <c:param name="from" value="staffmember" />
                                                    <c:param name="personId" value="${commandId}" />
                                                    <c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
                                                </c:url>

                                                <tr>
                                                   <td colspan="2">
                                                   <a href="<c:out value='${addressViewString}'/>">
                                                        <c:forEach var="addressType" items="${staffMemberForm.allAddressTypes}">
                                                            <c:choose>
                                                                <c:when test="${ addressType.code == address.addressTypeCode }">
                                                                    <c:out value="${addressType.description}"/>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>
                                                   </a></td>
                                                   <td>
                                                        <c:if test="${editAddresses}">
                                                            <a href="<c:out value='${addressViewString}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                        </c:if>
                                                        <c:if test="${authorizedToDeleteAddress}">
                                                            &nbsp;&nbsp;
                                                            <a href="<c:out value='${addressDeleteString}'/>" onclick="return confirm('<fmt:message key="jsp.addresses.delete.confirm" />')">
                                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                            </a>
                                                        </c:if>
                                                   </td>
                                                </tr>

                                                <%@ include file="../../includes/addressData.jsp" %>
        
                                            </c:forEach>
                                        </spring:bind>
                                    </table>

		                        </div> <!-- AccordionPanelContent -->
		                    </div> <!-- AccordionPanel -->
	                        
	                    </div> <!-- end of accordion 3 or 2 -->
			            <script type="text/javascript">
			                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
	                    </script>
		                </div>     <!-- TabbedPanelsContent -->
		            
	                    </c:when>
	                </c:choose>
            	<!--  end tabbed panelscontentgroup -->    

<!------------------------------- Subjects ------------------------------------------------- -->
                <c:choose>
                    <c:when test="${showSubjects 
                         && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                        <c:set var="accordion" value="${accordion + 1}"/>
                	
                	   <div class="TabbedPanelsContent">
                	       <div class="Accordion" id="Accordion${accordion}" tabindex="0">
							
						
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjects.taught" /></div>
                            <div class="AccordionPanelContent">
                                <table class="tabledata2" id="TblData2_subjects">
                                    <tr>
                                        <%-- th tag, otherwise it is included by the alternate script --%>
                                        <th colspan="6">&nbsp;</th>
                                        <th class="buttonsCell">
                                            <sec:authorize access="hasRole('CREATE_SUBJECT_TEACHERS')">
    								            <a class="button" href="<c:url value='/college/teacherssubject.view'/>?<c:out value='newForm=true&tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid }&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </sec:authorize>
                                        </th>
                                    </tr>

                                    <c:choose>
                                        <c:when test="${(not empty showSubjectTeacherError)}">             
                                            <tr>
                                                <td class="error">
                                                    <c:out value="${showSubjectTeacherError }"/>
                                                </td>
                                                <th colspan="3">&nbsp;</th>
                                            </tr>
                                       </c:when>
                                    </c:choose>
                                    <tr>
                                        <th><fmt:message key="jsp.general.code" /></th>
                                        <th><fmt:message key="jsp.general.description" /></th>
                                        <th><fmt:message key="jsp.subject.credit" /></th>
                                        <th><fmt:message key="jsp.general.studytime" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th>
                                        <th><fmt:message key="general.classgroup" /></th>

                                        <th class="buttonsCell">&nbsp;</th>
                                    </tr>

                                    <spring:bind path="staffMember.subjectsTaught">

                                    <c:forEach var="subjectTeacher" items="${status.value}">
                                        <c:set var="subject" value="${staffMemberForm.idToSubjectMap[subjectTeacher.subjectId]}" />
                                        <tr>
                                            <td>
                                                <c:out value="${subject.subjectCode}"/>
                                            </td>
                                            <td>
                                                <c:set var="subjectDesc">
                                                    <c:out value="${subject.subjectDescription}"/>
                                                    <c:choose>
                                                        <c:when test="${not empty staffMemberForm.idToAcademicYearMap[subject.currentAcademicYearId]}">
                                                            <c:out value="(${staffMemberForm.idToAcademicYearMap[subject.currentAcademicYearId].description})"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                        (?)
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:set>
                                                <a href="<c:url value='/college/subject.view'/>?<c:out value='newForm=true&subjectId=${subject.id}&tab=0&panel=0&currentPageNumber=0'/>">
                                                    <c:out value="${subjectDesc}"/>
                                                </a>
                                            </td>
                                            <td>
                                                <c:out value="${subject.creditAmount}"/>
                                            </td>
                                            <td>
                                                <c:out value="${staffMemberForm.codeToStudyTimeMap[subject.studyTimeCode].description}"/>
                                            </td>
                                            <td>
                                                <c:out value="${subject.active}"/>
                                            </td>
                                            <td>
                                                <c:out value="${subjectTeacher.classgroup.description}"/>
                                            </td>

                                            <td class="buttonsCell">
                                                <sec:authorize access="hasRole('DELETE_SUBJECT_TEACHERS')">
  									            <a href="<c:url value='/college/teachersubject_delete.view'/>?<c:out value='tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid}&subjectTeacherId=${subjectTeacher.id}&subjectId=${subjectTeacher.subjectId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.subjects.taught.delete.confirm" />')">
  		                                            <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
  		                                        </a>
    		                                    </sec:authorize>
                                           </td>
                                        </tr>
                                    </c:forEach>
                                    </spring:bind>
                                </table>
                                <script type="text/javascript">alternate('TblData2_subjects',true)</script>
                            </div> <!-- AccordionPanelContent -->
                        </div> <!-- AccordionPanel -->
                        
                    </div><!-- end of accordion 4 or 3-->
             		<script type="text/javascript">
                      		var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                            		{defaultPanel: 0,
                            		useFixedPanelHeights: false,
                            		nextPanelKeyCode: 78 /* n key */,
                            		previousPanelKeyCode: 80 /* p key */
                           	});
                    </script>
                </div> <!-- TabbedPanelsContent -->
                    
                    </c:when>
                </c:choose>
            <!--  end tabbed panelscontentgroup -->    

<!------------------------------- Examinations ------------------------------------------------- -->
                <c:choose>
                    <c:when test="${showExaminations
                         && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                        <c:set var="accordion" value="${accordion + 1}"/>
		                
		                <div class="TabbedPanelsContent">
		                  <div class="Accordion" id="Accordion${accordion}" tabindex="0">
								
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.examinations.taught" /></div>
                            <div class="AccordionPanelContent">

                                <table class="tabledata2" id="TblData2_examinations">
                                     <tr>
                                        <th colspan="4">&nbsp;</th>
                                        <th class="buttonsCell">
                                            <sec:authorize access="hasRole('CREATE_EXAMINATION_SUPERVISORS')">
                                                <a class="button" href="<c:url value='/college/examinationteacher.view'/>?<c:out value='newForm=true&tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </sec:authorize>
                                        </th>
                                     </tr>
                                     <c:choose>        
                                        <c:when test="${ not empty showExaminationTeacherError }">       
                                            <tr>
                                                <td align="left" colspan="3">
                                                    <p class="error">
                                                        <fmt:message key="jsp.error.examinationteacher.delete" />
                                                        <c:out value="${showExaminationTeacherError}"/>
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>

                                    <tr>
                                        <th><fmt:message key="jsp.general.subject" /></th>
                                        <th><fmt:message key="jsp.general.code" /></th>
                                        <th><fmt:message key="jsp.general.description" /></th>
                                        <th><fmt:message key="general.classgroup" /></th>
                                        <th class="buttonsCell">&nbsp;</th>
                                    </tr>
                                    <c:forEach var="examinationTeacher" items="${staffMemberForm.staffMember.examinationsTaught}">
                                        <c:set var="examination" value="${staffMemberForm.idToExaminationMap[examinationTeacher.examinationId]}" />
                                        <tr>
                                            <td>
                                                <c:out value="${examination.subject.subjectCode}"/> <c:out value="${examination.subject.subjectDescription}"/>
                                            </td>                                          
                                            <td>
                                                <c:out value="${examination.examinationCode}"/>
                                            </td>                                          
                                            <td >
                                                <a href="<c:url value='/college/examination.view'/>?<c:out value='newForm=true&examinationId=${examination.id}&tab=${accordion}&panel=0&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                    <c:out value="${examination.examinationDescription}"/>
                                                    <c:out value="(${staffMemberForm.idToAcademicYearMap[examination.subject.currentAcademicYearId].description})"/>
                                                </a>
                                            </td>
                                            <td>
                                                <c:out value="${examinationTeacher.classgroup.description}"/>
                                            </td>
                                            <td class="buttonsCell">
                                                <sec:authorize access="hasRole('DELETE_EXAMINATION_SUPERVISORS')">
                                                        
                                                   <a href="<c:url value='/college/examinationteacher_delete.view'/>?<c:out value='tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid}&examinationTeacherId=${examinationTeacher.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.examinations.taught.delete.confirm" />')">
                                                    <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                   </a>
                                                </sec:authorize>       
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                                <script type="text/javascript">alternate('TblData2_examinations',true)</script>
                            </div> <!-- AccordionPanelContent -->
                        </div> <!-- AccordionPanel -->
                        
                    </div> <!-- end of accordion 5 -->
                    <script type="text/javascript">
                       var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                           {defaultPanel: 0,
                           useFixedPanelHeights: false,
                           nextPanelKeyCode: 78 /* n key */,
                           previousPanelKeyCode: 80 /* p key */
                       });
                   </script>
                    </div>     <!-- TabbedPanelsContent -->
                    </c:when>
                </c:choose>
            <!--  end tabbed panelscontentgroup -->    

<!------------------------------- Tests ------------------------------------------------- -->
            <c:choose>
                <c:when test="${showTests && '' != commandStaffMemberid && 0 != commandStaffMemberid}">
                    <c:set var="accordion" value="${accordion + 1}"/>
                    
                        <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                   
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.tests.supervised" /></div>
                            <div class="AccordionPanelContent">
                            
                                <table class="tabledata2" id="TblData2_tests">
                                    <tr>
                                        <th colspan="5">&nbsp;</th>
                                        <th class="buttonsCell">
                                            <sec:authorize access="hasRole('CREATE_TEST_SUPERVISORS')">
                                                <a class="button" href="<c:url value='/college/testteacher.view'/>?<c:out value='newForm=true&tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </sec:authorize>
                                        </th>
                                    </tr>
                                    <c:choose>        
                                        <c:when test="${ not empty showTestTeacherError }">       
                                            <tr>
                                                <td align="left" colspan="3">
                                                    <p class="error">
                                                        <c:out value="${showTestTeacherError}"/>
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>
                                    <tr>
                                        <th><fmt:message key="jsp.general.subject" /></th>
                                        <th><fmt:message key="jsp.general.examination" /></th>
                                        <th><fmt:message key="jsp.general.code" /></th>
                                        <th><fmt:message key="jsp.general.description" /></th>
                                        <th><fmt:message key="general.classgroup" /></th>
                                        <th class="buttonsCell">&nbsp;</th>
                                    </tr>
                                    
                                    <spring:bind path="staffMember.testsSupervised">
                                    <c:forEach var="testTeacher" items="${status.value}">
                                        <c:set var="test" value="${staffMemberForm.idToTestMap[testTeacher.testId]}" />
                                            <tr>
                                                <td>
                                                    <c:out value="${test.examination.subject.subjectCode}"/> <c:out value="${test.examination.subject.subjectDescription}"/>
                                                </td>                                          
                                                <td>
                                                    <c:out value="${test.examination.examinationCode}"/> <c:out value="${test.examination.examinationDescription}"/>
                                                </td>                                          
                                                <td>
                                                    <c:out value="${test.testCode}"/>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/college/test.view'/>?<c:out value='newForm=true&testId=${test.id}&examinationId=${test.examinationId}&tab=0&panel=0&currentPageNumber=1'/>">
                                                        <c:out value="${test.testDescription}"/>
                                                        <c:out value="(${staffMemberForm.idToAcademicYearMap[test.examination.subject.currentAcademicYearId].description})"/>
                                                    </a>
                                                </td>
	                                            <td>
                                                <c:out value="${testTeacher.classgroup.description}"/>
	                                            </td>
                                                <td class="buttonsCell">
                                                    <sec:authorize access="hasRole('DELETE_TEST_SUPERVISORS')">
                                                     <a href="<c:url value='/college/testteacher_delete.view'/>?<c:out value='tab=${accordion}&panel=0&from=staffmember&staffMemberId=${commandStaffMemberid}&testTeacherId=${testTeacher.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.tests.supervised.delete.confirm" />')">
                                                         <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                     </a>
                                                    </sec:authorize>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </spring:bind>
                                </table>
                                <script type="text/javascript">alternate('TblData2_tests',true)</script>
                            </div> <!-- AccordionPanelContent -->
                        </div> <!-- AccordionPanel -->
                    </div> <!-- end of accordion 5 or 6 -->
                    
                    <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                            {defaultPanel: 0,
                            useFixedPanelHeights: false,
                            nextPanelKeyCode: 78 /* n key */,
                            previousPanelKeyCode: 80 /* p key */
                        });
                    </script>
                    </div>     <!-- TabbedPanelsContent -->

                    </c:when>
                </c:choose>
            
             </div> <!-- tabbedPanelsContentGroup -->
        </div>  <!-- end tabbedPanel -->
</form:form>
    </div>   <!-- tabcontent --> 
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(${param.tab});
        tp1.showPanel(${navigationSettings.tab});
        Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
        Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>
<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

