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

<c:set var="screentitlekey">jsp.general.organizationalunit</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../includes/navigation_privileges.jsp"%>

    <%@ include file="../../menu.jsp" %>

    <c:set var="form" value="${organizationalUnitForm}" />
    <c:set var="navigationSettings" value="${form.navigationSettings}" />
    <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
    <c:set var="tab" value="${navigationSettings.tab}" />
    <c:set var="panel" value="${navigationSettings.panel}" />
    <c:set var="organization" value="${form.organization}" />
    <c:set var="institutionTypeCode" value="${organization.institutionTypeCode}" />

    <c:set var="organizationalUnit" value="${form.organizationalUnit}" />
    <c:set var="organizationalUnitId"  value="${organizationalUnit.id}" />
    <c:set var="parentOrgUnit" value="${form.parentOrgUnit}" />

    <div id="tabcontent">

        <fieldset>
            <legend>
            <a href="<c:url value='/college/organizationalunits.view?institutionTypeCode=${institutionTypeCode}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
            <c:choose>
                <c:when test="${parentOrgUnit.organizationalUnitDescription != null && parentOrgUnit.organizationalUnitDescription != ''}" >
                    <a href="<c:url value='/college/organizationalunit.view?tab=0&panel=0&organizationalUnitId=${parentOrgUnit.id}&institutionTypeCode=${institutionTypeCode}&currentPageNumber=${currentPageNumber}'/>"><c:out value="${parentOrgUnit.organizationalUnitDescription}"/></a>&nbsp;>&nbsp;
                </c:when>
            </c:choose>
            <c:choose>
                <c:when test="${not empty organizationalUnit.organizationalUnitDescription}" >
                    <c:out value="${fn:substring(organizationalUnit.organizationalUnitDescription,0,initParam.iTitleLength)}"/>
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose>
            </legend>

            <form:errors path="organizationalUnitForm" cssClass="errorwide"  element="p"/>

        </fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.details" /></li>  
                <c:choose>
                    <c:when test="${organizationalUnitId != 0}">
                        <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.registration.periods" /></li>
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.addresses" /></li>
                    </c:when>
                </c:choose>       
            </ul>
         
            <div class="TabbedPanelsContentGroup">   
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.general" /></div>
                            <div class="AccordionPanelContent">
                               <form:form modelAttribute="organizationalUnitForm.organizationalUnit" method="post">
                               <table>

                                    <c:if test="${showInstitutions}">
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.university" /></b></td>
                                        <td class="required">
                                            <select name="institutionId" class="long" onchange="this.form.submit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneInstitution" items="${organization.allInstitutions}">
                                                   <c:choose>
                                                   <c:when test="${ oneInstitution.id == institutionId }"> 
                                                        <option value="${oneInstitution.id}" selected="selected"><c:out value="${oneInstitution.institutionDescription}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneInstitution.id}"><c:out value="${oneInstitution.institutionDescription}"/></option>
                                                    </c:otherwise>
                                                   </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td> 
                                        <td colspan="2"></td>
                                       </tr>
                                    </c:if>                                    
                                    <!--  BRANCH -->
                                    <c:if test="${showBranches}">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.branch" /></td>
                                        <spring:bind path="branchId">
                                        <td class="required">
                                            <select name="${status.expression}" class="long" onchange="this.form.submit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneBranch" items="${organization.allBranches}">
                                                    <c:choose>
                                                        <c:when test="${(status.value != '0' && oneBranch.id == status.value)
                                                                        || status.value == '0' && oneBranch.id == branchId }">
                                                            <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    </c:if>
                                    
                                    <sec:authorize access="hasAnyRole('UPDATE_ORG_UNITS','UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
                                    <!-- ORGANIZATIONAL UNIT CODE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.organizationalunit" />&nbsp;<fmt:message key="jsp.general.code" /></td>
                                        <spring:bind path="organizationalUnitCode">
                                        <td>
                                            <input type="text" name="${status.expression}" size="56" value="<c:out value="${status.value}" />" />
                                        </td>
                                        <td colspan="2"><fmt:message key="jsp.general.message.codegenerated" />&nbsp;<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    </sec:authorize>
                                                            
                                    <!-- DESCRIPTION -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.name" /></td>
                                        <spring:bind path="organizationalUnitDescription">
                                        <td class="required">
                                            <input type="text" name="${status.expression}" size="56" value="<c:out value="${status.value}" />" />
                                        </td>
                                        <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- LEVEL -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.organizationalunit.level" /></td>
                                        <td>
                                        <spring:bind path="unitLevel">
                                           <c:out value="${status.value}"/>
                                        </spring:bind>
                                        </td> 
                                        <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                             </c:forEach>
                                        </td>
                                    </tr>
                                    
                                    <!--  PARENT ORGANIZATIONAL UNIT -->
                                    <c:choose>
                                          <c:when test="${status.value != 1}">
                                               <tr>
                                                    <td class="label"><fmt:message key="jsp.general.parentorganizationalunit" /></td>
                                                    <spring:bind path="parentOrganizationalUnitId">
                                                    <td>
                                                            <c:forEach var="parentOU" items="${form.allParentOrganizationalUnits}">
                                                                <c:choose>
                                                                    <c:when test="${parentOU.id == status.value}">
<%--                                                                         <input type="hidden" name="${status.expression}" value="${parentOU.id}" /> --%>
                                                                        <c:out value="${parentOU.organizationalUnitDescription}"/>
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                    </td>
                                                    <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    <%-- end spring bind parentOrganizationalUnitId --%>
                                                    </spring:bind>
                                                </tr>
                                        </c:when>
                                    </c:choose>
                                    <%-- end spring bind unitLevel --%>


                                    <!--  CHILD ORGANIZATIONAL UNIT(S) -->
                                    <c:choose>
                                        <c:when test="${organizationalUnitId != 0}">
                                            <tr>
                                               <td class="label"><fmt:message key="jsp.general.childorganizationalunits" /></td>
                                               <td align="right">
                                                    <sec:authorize access="hasRole('CREATE_CHILD_ORG_UNITS')">
                                                        <a class="button" href="<c:url value='/college/organizationalunit.view?tab=0&panel=0&institutionTypeCode=${institutionTypeCode}&unitLevel=${(organizationalUnit.unitLevel+1)}&parentOUId=${(organizationalUnit.id)}&currentPageNumber=${currentPageNumber}'/>">
                                                            <fmt:message key="jsp.href.add" />
                                                        </a>
                                                    </sec:authorize>
                                               </td>
                                               <td colspan="2"></td>
                                               
                                           </tr>
                                           <tr>
                                           <td></td>
                                           <td>
                                           <table class="tabledata_small" id="TblData_small_childUnits">
                                           <c:forEach var="childOU" items="${form.allChildOrganizationalUnits}">
                                               <tr>
                                                    <td>
                                                        <a href="<c:url value='/college/organizationalunit.view?tab=0&panel=0&from=organizationalunit&institutionTypeCode=${institutionTypeCode}&organizationalUnitId=${childOU.id}&parentOUId=${organizationalUnit.id}&currentPageNumber=${currentPageNumber}'/>">${childOU.organizationalUnitDescription}</a>
                                                    </td>
                                                    <td colspan="2" align="right">
                                                        <sec:authorize access="hasRole('CREATE_CHILD_ORG_UNITS')">
                                                            <a class="imageLink" href="<c:url value='/college/organizationalunit.view?tab=0&panel=0&from=organizationalunit&institutionTypeCode=${institutionTypeCode}&organizationalUnitId=${childOU.id}&parentOUId=${organizationalUnit.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                        </sec:authorize>
                                                        <sec:authorize access="hasRole('DELETE_CHILD_ORG_UNITS')">
                                                            <a class="imageLinkPaddingLeft" href="<c:url value='/college/organizationalunit_delete.view?organizationalUnitId=${childOU.id}&viewName=organization/organizationalunit&parentOUId=${organizationalUnit.id }&currentPageNumber=${currentPageNumber}'/>"
                                                            onclick="return confirm('<fmt:message key="jsp.organizationalunits.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                        </sec:authorize>
                                                        <c:choose>
                                                        <c:when test="${childOU.id == form.childOUId}">
                                                            <p align="left" class="error">
                                                                <fmt:message key="jsp.error.organizationalunit.delete" />
                                                                <fmt:message key="jsp.error.general.delete.linked.${showError}" />
                                                            </p>
                                                        </c:when>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </table>
                                            <script type="text/javascript">alternate('TblData_small_childUnits',true)</script>
                                            </td>
                                            <td colspan="2">&nbsp;</td>
                                            </tr>
                                        </c:when>
                                    </c:choose>
                                    <tr><td colspan="4">&nbsp;</td></tr>

                                    <!-- DIRECTOR -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.organizationalunit.director" /></td>
                                        <spring:bind path="directorId">
                                        <td colspan="2">
                                            <select class="long" name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="person" items="${form.allDirectors}">
                                                    <c:choose>
                                                        <c:when test="${person.id == status.value}">
                                                            <c:set var="selected" value="selected" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="selected" value="" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <option value="${person.id}" ${selected}>
                                                        <c:out value="${person.surnameFull}"/>, <c:out value="${person.firstnamesFull}"/> (<fmt:message key="jsp.organizationalunit.unit" /><fmt:message key="jsp.general.colon" />
                                                        <c:forEach var="unit" items="${organization.allOrganizationalUnits}">
                                                            <c:choose>
                                                                <c:when test="${unit.id == person.primaryUnitOfAppointmentId}">
                                                                    <c:out value="${unit.organizationalUnitDescription}"/>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>
                                                        )
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- UNIT TYPE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.organizationalunit.unittype" /></td>
                                        <spring:bind path="unitTypeCode">
                                        <td>
                                            <select name="${status.expression}" class="long">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="unitType" items="${form.allUnitTypes}">
                                                    <c:choose>
                                                        <c:when test="${unitType.code == status.value}">
                                                            <option value="${unitType.code}" selected="selected"><c:out value="${unitType.description}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${unitType.code}"><c:out value="${unitType.description}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- ACADEMIC FIELD -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.academicfield" /></td>
                                        <spring:bind path="academicFieldCode">
                                        <td colspan="2">
                                            <select class="long" name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="academicField" items="${form.allAcademicFields}">
                                                    <c:choose>
                                                        <c:when test="${academicField.code == status.value}">
                                                            <option value="${academicField.code}" selected="selected"><c:out value="${academicField.description}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${academicField.code}"><c:out value="${academicField.description}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- UNIT AREA -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.organizationalunit.unitarea" /></td>
                                        <spring:bind path="unitAreaCode">
                                        <td>
                                            <select name="${status.expression}" class="long">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="unitArea" items="${form.allUnitAreas}">
                                                    <c:choose>
                                                        <c:when test="${unitArea.code == status.value}">
                                                            <option value="${unitArea.code}" selected="selected"><c:out value="${unitArea.description}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${unitArea.code}"><c:out value="${unitArea.description}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    <!-- ACTIVE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.active" /></td>
                                        <spring:bind path="active">
                                        <td>
                                        <select name="${status.expression}" class="long">
                                            <c:choose>
                                                <c:when test="${'Y' == status.value}">
                                                    <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                    <option value="N"><fmt:message key="jsp.general.no" /></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                    <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                                </c:otherwise>
                                               </c:choose>
                                        </select>
                                        </td>
                                        <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>                                               

                                    <!-- SUBMIT BUTTON -->
                                    <tr><td class="label">&nbsp;</td><td><input type="submit" value="<fmt:message key="jsp.button.submit" />"/></td><td></td></tr>
                                </table>
                                </form:form>

                            </div> <!-- AccordionPanelContent -->
                        </div>  <!-- AccordionPanel -->
                    </div>   <!-- Accordion0 -->     

                    <script type="text/javascript">
                        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                          {defaultPanel: 0,
                           useFixedPanelHeights: false,
                           nextPanelKeyCode: 78 /* n key */,
                           previousPanelKeyCode: 80 /* p key */
                          });
                    </script>

                </div>   <!-- TabbedPanelsContent -->  
                    
                    
                <c:choose>
                    <c:when test="${organizationalUnitId != 0}">
                    
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.registration.periods" /></div>
                                <div class="AccordionPanelContent">
        
                                <c:if test="${ not empty admissionRegistrationError}">       
	                                  <p align="left" class="msg">
	                                       <c:out value="${admissionRegistrationError}"/>
	                                  </p>
                                </c:if>
                                
                                <table class="tabledata2" id="registrationPeriodsTable">
                                    <tr>
                                        <th><fmt:message key="jsp.general.academicyear"/></th>
                                        <c:if test="${modules != null && modules != ''}">
                                            <c:forEach var="module" items="${modules}">
                                                <c:if test="${fn:toLowerCase(module.module) == 'admission'}">
                                                        <th><fmt:message key="jsp.general.startdate"/> <fmt:message key="jsp.general.initialadmission"/></th>
                                                        <th><fmt:message key="jsp.general.enddate"/> <fmt:message key="jsp.general.initialadmission"/></th>
                                                </c:if>
                                           </c:forEach>
                                        </c:if>
                                        <th><fmt:message key="jsp.general.startdate"/> <fmt:message key="jsp.general.continuedregistration"/></th>
                                        <th><fmt:message key="jsp.general.enddate"/> <fmt:message key="jsp.general.continuedregistration"/></th>
                                        <c:if test="${modules != null && modules != ''}">
                                            <c:forEach var="module" items="${modules}">
                                                <c:if test="${fn:toLowerCase(module.module) == 'fee'}">
                                                    <th><fmt:message key="jsp.general.startdate"/> <fmt:message key="jsp.general.refundperiod"/></th>
                                                    <th><fmt:message key="jsp.general.enddate"/> <fmt:message key="jsp.general.refundperiod"/></th>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>         
                                        <th><fmt:message key="jsp.general.active"/></th>
                                        <th class="buttonsCell">
                                            <sec:authorize access="hasRole('UPDATE_ORG_UNITS')">
                                                <a class="button" href="<c:url value='/college/admissionregistrationconfig.view?tab=1&panel=0&organizationalUnitId=${organizationalUnit.id}&currentPageNumber=${currentPageNumber}'/>">
                                                    <fmt:message key="jsp.href.add" />
                                                </a>
                                            </sec:authorize>
                                        </th>
                                    </tr>
                                    <c:forEach var="admissionRegistrationConfig" items="${organizationalUnit.admissionRegistrationConfigs}">
                                        <tr>
                                            <td>
                                                <c:out value="${idToAcademicYearMap[admissionRegistrationConfig.academicYearId].description}"/>
                                            </td>
                                            <c:if test="${modules != null && modules != ''}">
                                                <c:forEach var="module" items="${modules}">
                                                    <c:if test="${fn:toLowerCase(module.module) == 'admission'}">
			                                            <td>
			                                                <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.startOfAdmission}"/>
			                                            </td>
			                                            <td>
			                                                <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.endOfAdmission}"/>
			                                            </td>
			                                         </c:if>
			                                   </c:forEach>
			                                </c:if>
                                            <td>
                                                <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.startOfRegistration}"/>
                                            </td>
                                            <td>
                                                <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.endOfRegistration}"/>
                                            </td>
			                                <c:if test="${modules != null && modules != ''}">
                                                <c:forEach var="module" items="${modules}">
                                                    <c:if test="${fn:toLowerCase(module.module) == 'fee'}">
                                                        <td>
                                                            <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.startOfRefundPeriod}"/>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate dateStyle="medium" type="date" value="${admissionRegistrationConfig.endOfRefundPeriod}"/>
                                                        </td>
                                                     </c:if>
                                                 </c:forEach>
                                            </c:if>
                                            <td>
                                                ${admissionRegistrationConfig.active}
                                            </td>
                                            <td class="buttonsCell">
                                                <sec:authorize access="hasRole('UPDATE_ORG_UNITS')">
                                                    <a class="imageLink" href="<c:url value='/college/admissionregistrationconfig.view?tab=1&panel=0&admissionRegistrationConfigId=${admissionRegistrationConfig.id}&currentPageNumber=${currentPageNumber}'/>">
                                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                                    </a>
                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/organizationalunit/deleteAdmissionRegistrationConfig/${admissionRegistrationConfig.id}'/>"
                                                        onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                </sec:authorize>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                                <script type="text/javascript">alternate('registrationPeriodsTable',true)</script>

                                </div> <!-- AccordionPanelContent -->
                            </div> <!-- AccordionPanel -->
                        </div>  <!--  Accordion1 -->

                        <script type="text/javascript">
                          var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                          {defaultPanel: 0,
                          useFixedPanelHeights: false,
                          nextPanelKeyCode: 78 /* n key */,
                          previousPanelKeyCode: 80 /* p key */
                          });
                        </script>
                    </div>     <!-- TabbedPanelsContent -->

                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion2" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.addresses" /></div>
                                    <div class="AccordionPanelContent">
            
                                    <table>

                                     <!-- ADDRESSES -->
                                     <c:set var="countAddressTypes" value="0" scope="page" />
                                     <c:set var="countUsedAddressTypes" value="0" scope="page" />
                                    <c:forEach var="addressType" items="${form.allAddressTypes}">
                                        <c:set var="countAddressTypes" value="${countAddressTypes + 1}" scope="page" />
                                        <c:forEach var="address" items="${organizationalUnit.addresses}">
                                            <c:choose>
                                                <c:when test="${addressType.code == address.addressTypeCode }">
                                                    <c:set var="countUsedAddressTypes" value="${countUsedAddressTypes + 1}" scope="page" />
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </c:forEach>
                                    
                                    
                                    <c:choose>
                                        <c:when test="${countAddressTypes != countUsedAddressTypes}">
                                             <c:set var="addressNewString" scope="page" value="/college/address.view?newForm=true&tab=2&panel=0&from=organizationalunit&organizationalUnitId=${organizationalUnitId}&currentPageNumber=${currentPageNumber}" />
                                             <tr>
                                                <td class="label"><fmt:message key="jsp.general.addresses" /></td>
                                                <td colspan="2" align="right">
                                                    <a class="button" href="<c:url value='${addressNewString}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
                                             </tr>
                                        </c:when>
                                    </c:choose>

                                    <%-- lists needed by addressData.jsp --%>
                                    <c:set var="allCountries" value="${form.allCountries}" />
                                    <c:set var="allProvinces" value="${form.allProvinces}" />
                                    <c:set var="allDistricts" value="${form.allDistricts}" />
                                    <c:set var="allAdministrativePosts" value="${form.allAdministrativePosts}" />

                                    <c:forEach var="address" items="${organizationalUnit.addresses}">
                                        <c:set var="addressViewString" scope="page" value="/college/address.view?newForm=true&tab=2&panel=0&from=organizationalunit&organizationalUnitId=${organizationalUnitId}&addressId=${address.id}&currentPageNumber=${currentPageNumber}" />
                                        <c:set var="addressDeleteString" scope="page" value="/college/address_delete.view?newForm=true&tab=2&panel=0&from=organizationalunit&organizationalUnitId=${organizationalUnitId}&addressId=${address.id}&currentPageNumber=${currentPageNumber}" />

                                         <tr>
                                            <td colspan=2>
                                           <a href="<c:url value='${addressViewString}'/>">
                                            <c:forEach var="addressType" items="${form.allAddressTypes}">
                                                <c:choose>
                                                    <c:when test="${ addressType.code == address.addressTypeCode }">
                                                        <c:out value="${addressType.description}"/>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                           </a></td>
                                           <td>
                                                <a href="<c:url value='${addressViewString}' />"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                &nbsp;&nbsp;
                                                <a href="<c:url value='${addressDeleteString}' />" onclick="return confirm('<fmt:message key="jsp.addresses.delete.confirm" />')">
                                                  <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                </a>
                                           </td>
                                         </tr>
                                     
                                        <%@ include file="../../includes/addressData.jsp"%>
                                    
                                    </c:forEach>
                                    </table>
    
                                    </div> <!-- AccordionPanelContent -->
                                </div> <!-- AccordionPanel -->
                            </div>  <!-- Accordion2 -->
    
                            <script type="text/javascript">
                              var Accordion2 = new Spry.Widget.Accordion("Accordion2",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                              });
                            </script>
                        </div>     <!-- TabbedPanelsContent -->

                        <%-- show registration periods and addresses tab only if organizational unit exists --%>
                        </c:when>
                    </c:choose>
                    </div>
                   
                </div>
                
            </div>
            
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>

</div>

<%@ include file="../../footer.jsp"%>

