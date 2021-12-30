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
		
<div id="tabcontent">

<fieldset>
	<legend>
    <a href="<c:url value='/college/branches.view'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
    <a href="<c:url value='/college/branch.view?tab=${branchAcademicYearTimeUnitForm.navigationSettings.tab}'/>"><c:out value="${branchAcademicYearTimeUnitForm.branch.branchDescription}"/></a>&nbsp;&gt;
	<c:choose>
		<c:when test="${branchAcademicYearTimeUnitForm.branchAcademicYearTimeUnit.id != null && branchAcademicYearTimeUnitForm.branchAcademicYearTimeUnit.id != 0}" >
			<c:out value="${branchAcademicYearTimeUnitForm.idToAcademicYearMap[branchAcademicYearTimeUnitForm.branchAcademicYearTimeUnit.academicYearId].description}"/>
		</c:when>
		<c:otherwise>
			<fmt:message key="jsp.href.new" />
		</c:otherwise>
	</c:choose>
	</legend>
        
        <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
        <form:errors path="branchAcademicYearTimeUnitForm.*" cssClass="errorwide" element="p"/>

</fieldset>

<form:form modelAttribute="branchAcademicYearTimeUnitForm" method="post">
    <div id="tp1" class="TabbedPanel">
        <ul class="TabbedPanelsTabGroup">
            <li class="TabbedPanelsTab"><fmt:message key="jsp.general.details" /></li>  
        </ul>
         
        <div class="TabbedPanelsContentGroup">   
            <div class="TabbedPanelsContent">
                <div class="Accordion" id="Accordion0" tabindex="0">
                    <div class="AccordionPanel">
                        <div class="AccordionPanelTab"><fmt:message key="jsp.general.general" /></div>
                        <div class="AccordionPanelContent">

                            <table>
                                <tr>
                                    <td class="label" width="200"><fmt:message key="jsp.general.branch" /></td>
                                    <td><c:out value="${branchAcademicYearTimeUnitForm.branch.branchDescription}"/></td>
                                </tr>

                                <tr>
                                    <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
                                    <td class="required">
                                        <form:select path="branchAcademicYearTimeUnit.academicYearId">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <form:options items="${branchAcademicYearTimeUnitForm.allAcademicYears}" itemLabel="description" itemValue="id" />
                                        </form:select>
                                    </td>
                                    <form:errors path="branchAcademicYearTimeUnit.academicYearId" cssClass="error" element="td" />
                                </tr>

                                <tr>
                                    <td class="label" width="200"><fmt:message key="jsp.general.timeunit" /></td>
                                    <td class="required">
                                        <form:select path="timeUnitId">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <form:options items="${branchAcademicYearTimeUnitForm.allTimeUnits}" itemLabel="description" itemValue="code" />
                                        </form:select>
                                    </td>
                                    <form:errors path="branchAcademicYearTimeUnit.cardinalTimeUnitNumber" cssClass="error" element="td" />
                                </tr>

                                <tr>
                                    <td class="label"><form:label for="birth_day" path="branchAcademicYearTimeUnit.resultsPublishDate"><fmt:message key="jsp.general.resultspublishdate"/></form:label></td>
                                    <td class="required"><form:hidden path="branchAcademicYearTimeUnit.resultsPublishDate"/>
                                        <table>
                                            <tr>
                                                <td><fmt:message key="jsp.general.day" /></td>
                                                <td><fmt:message key="jsp.general.month" /></td>
                                                <td><fmt:message key="jsp.general.year" /></td>
                                            </tr>
                                            <tr>
                                                <spring:bind path="branchAcademicYearTimeUnit.resultsPublishDate">
                                                <td><input type="text" id="birth_day"
                                                    name="birth_day" size="2" maxlength="2"
                                                    value="<c:out value="${fn:substring(status.value,8,10)}" />"
                                                    onchange="updateFullDate('branchAcademicYearTimeUnit.resultsPublishDate','day',document.getElementById('birth_day').value);" /></td>
                                                <td><input type="text" id="birth_month"
                                                    name="birth_month" size="2" maxlength="2"
                                                    value="<c:out value="${fn:substring(status.value,5,7)}" />"
                                                    onchange="updateFullDate('branchAcademicYearTimeUnit.resultsPublishDate','month',document.getElementById('birth_month').value);" /></td>
                                                <td><input type="text" id="birth_year"
                                                    name="birth_year" size="4" maxlength="4"
                                                    value="<c:out value="${fn:substring(status.value,0,4)}" />"
                                                    onchange="updateFullDate('branchAcademicYearTimeUnit.resultsPublishDate','year',document.getElementById('birth_year').value);" /></td>
                                                </spring:bind>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <fmt:message key="jsp.general.message.dateformat" />
                                        <form:errors path="branchAcademicYearTimeUnit.resultsPublishDate" cssClass="error"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.active" /></td>
                                    <td>
                                        <form:select path="branchAcademicYearTimeUnit.active">
                                            <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                            <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                        </form:select>
                                    </td>
                                    <form:errors path="branchAcademicYearTimeUnit.active" cssClass="error" element="td" />
                                </tr>                                             
                                
                                <!-- SUBMIT BUTTON -->
                        	    <tr><td/><td colspan="2"><input type="submit" name="submit" value="submit" /></td></tr>
                            </table>

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
        
        	</div>   <!-- Accordion0, is: TabbedPanelsContent -->  
            
    	</div>
	</div>
</form:form>
</div>

<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(<%//=request.getParameter("tab")%>);
    tp1.showPanel(0);
</script>

</div>

<%@ include file="../../footer.jsp"%>

