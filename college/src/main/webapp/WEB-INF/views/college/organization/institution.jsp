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

<c:set var="screentitlekey">jsp.institution.header</c:set>
<c:if test="${institutionTypeCode == 1}"><c:set var="screentitlekey">jsp.general.secondaryschool</c:set></c:if>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="form" value="${institutionForm}" />
    <c:set var="institution" value="${form.institution}" />

    <div id="tabcontent">

		<fieldset>
			<legend>
            <a href="<c:url value='/college/institutions.view?institutionTypeCode=${institution.institutionTypeCode}&currentPageNumber=${form.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
			<c:choose>
				<c:when test="${not empty institution.institutionDescription}" >
    				<c:out value="${fn:substring(institution.institutionDescription,0,initParam.iTitleLength)}"/>
				</c:when>
				<c:otherwise>
					<fmt:message key="jsp.href.new" />
				</c:otherwise>
			</c:choose>
			</legend>
		</fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.institution.header" /> -
				<c:choose>
		            <c:when test="${form.institutionTypeCode == INSTITUTION_TYPE_HIGHER_EDUCATION}">
		                <fmt:message key="jsp.general.highereducation" />
		            </c:when>
		            <c:when test="${form.institutionTypeCode == INSTITUTION_TYPE_SECONDARY_SCHOOL}">
		                <fmt:message key="jsp.general.secondaryschools" />
		            </c:when>
		            <c:otherwise>
		                <c:forEach var="oneInstitutionType" items="${form.allInstitutionTypes}">
		                    <c:choose>
		                        <c:when test="${oneInstitutionType.code == form.institutionTypeCode }">
		                           <c:out value="${oneInstitutionType.description}"/>
		                        </c:when>
		                    </c:choose>
		                </c:forEach>
		            </c:otherwise>
		        </c:choose>
                </li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.institution.header" /> - 
                            <c:choose>
					            <c:when test="${form.institutionTypeCode == INSTITUTION_TYPE_HIGHER_EDUCATION}">
					                <fmt:message key="jsp.general.highereducation" />
					            </c:when>
					            <c:when test="${form.institutionTypeCode == INSTITUTION_TYPE_SECONDARY_SCHOOL}">
					                <fmt:message key="jsp.general.secondaryschools" />
					            </c:when>
					            <c:otherwise>
					                <c:forEach var="oneInstitutionType" items="${form.allInstitutionTypes}">
					                    <c:choose>
					                        <c:when test="${oneInstitutionType.code == institutionTypeCode }">
					                            <c:out value="${oneInstitutionType.description}"/>
					                        </c:when>
					                    </c:choose>
					                </c:forEach>
					            </c:otherwise>
	        				</c:choose>
                            </div>
                            <div class="AccordionPanelContent">
                            
                                <form:form modelAttribute="institutionForm.institution" method="post">
                                    <input type="hidden" id="submitter" name="submitter" value="" />

                                    <table>
                                        <!-- INSTITUTIONCODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.institution" />&nbsp;<fmt:message key="jsp.general.code" /></td>
                                            <spring:bind path="institutionCode">
                                            <td>
                                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                <fmt:message key="jsp.general.message.codegenerated" />
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        <!-- DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.name" /></td>
                                            <spring:bind path="institutionDescription">
                                            <td class="required">
                                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        <!-- RECTOR -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.institution.rector" /></td>
                                            <spring:bind path="rector">
                                            <td>
                                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>

                                        <!-- COUNTRY -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.country" /></td>
                                            <td>
                                                <%-- NB: instead of getElementById('provinceCode') could be used this.form.provinceCode - see userrole.jsp --%>
                                                <form:select path="countryCode" onchange="document.getElementById('provinceCode').value='0';document.getElementById('submitter').value=this.id;this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <form:options items="${institutionForm.allCountries}" itemValue="code" itemLabel="description"/>
                                                </form:select>
                                            </td>
                                            <td colspan="2"><form:errors path="countryCode" cssClass="error"/></td>
                                        </tr>

                                        <!-- PROVINCE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.province" /></td>
                                            <spring:bind path="provinceCode">
                                            <td>
                                                <select name="${status.expression}" id="provinceCode">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="province" items="${form.allProvinces}">
                                                        <c:choose>
                                                            <c:when test="${province.code == status.value}">
                                                                <option value="${province.code}" selected="selected"><c:out value="${province.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${province.code}"><c:out value="${province.description}"/></option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="active">
                                            <td>
                                            <select name="${status.expression}">
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
                                    	   <tr><td class="label">&nbsp;</td><td colspan="2"><input type="submit" value="submit" /></td></tr>
                                    </table>
                                </form:form>

				                        </div> <!-- AccordionPanelContent -->
                        </div>  <!-- AccordionPanel -->
                    </div>   <!-- Accordion1 -->     

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
        //tp1.showPanel(<%//=request.getParameter("tab")%>);
        tp1.showPanel(0);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

