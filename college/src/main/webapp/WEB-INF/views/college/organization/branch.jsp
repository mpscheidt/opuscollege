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

<c:set var="screentitlekey">jsp.general.branch</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>
		
<sec:authorize access="hasAnyRole('UPDATE_BRANCHES')">
    <c:set var="edit" value="${true}"/>
</sec:authorize>

<c:set var="navigationSettings" value="${branchForm.navigationSettings}" scope="page" />

<div id="tabcontent">

	<fieldset>
		<legend>
        <a href="<c:url value='/college/branches.view'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;&nbsp;
		<c:choose>
			<c:when test="${branchForm.branch.branchDescription != null && branchForm.branch.branchDescription != ''}" >
				<c:out value="${fn:substring(branchForm.branch.branchDescription,0,initParam.iTitleLength)}"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="jsp.href.new" />
			</c:otherwise>
		</c:choose>
		</legend>
	</fieldset>

    <form name="branchdata" method="post">
        <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value="<c:out value="${navigationSettings.tab}" />" />
        <input type="hidden" id="navigationSettings.panel" name="navigationSettings.panel" value="<c:out value="${navigationSettings.panel}" />" />
    
        <div id="tp1" class="TabbedPanel" onclick="document.getElementById('navigationSettings.tab').value=tp1.getCurrentTabIndex();document.getElementById('navigationSettings.panel').value=window['Accordion'+tp1.getCurrentTabIndex()].getCurrentPanelIndex(); ">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.details" /></li>  
                <c:choose>
                    <c:when test="${branchId != 0}">
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.resultspublishdates" /></li>
                    </c:when>
                </c:choose>    
            </ul>
             
            <div class="TabbedPanelsContentGroup">   
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.general" /></div>
                            <div class="AccordionPanelContent">

                                <table>
                                    <!-- INSTITUTION -->
                                    <sec:authorize access="hasRole('UPDATE_INSTITUTIONS')">
                                        <tr>
                                            <td class="label" width="200"><fmt:message key="jsp.general.university" /></td>
                                            <spring:bind path="branchForm.branch.institutionId">
                                            <td class="required">
                                                <select name="${status.expression}">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="institution" items="${branchForm.allInstitutions}">
                                                       <c:choose>
                                                       <c:when test="${status.value == institution.id}"> 
                                                            <option value="${institution.id}" selected="selected"><c:out value="${institution.institutionDescription}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></option>
                                                        </c:otherwise>
                                                       </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td> 
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                    </sec:authorize>
                        
                                    <!-- BRANCH CODE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.branch" />&nbsp;<fmt:message key="jsp.general.code" /></td>
                                        <spring:bind path="branchForm.branch.branchCode">
                                        <td>
                                            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                        </td>
                                        <td><fmt:message key="jsp.general.message.codegenerated" /></td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- DESCRIPTION -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.name" /></td>
                                        <spring:bind path="branchForm.branch.branchDescription">
                                        <td class="required">
                                            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                        </td>
                                        <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    
                                    <!-- ACTIVE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.active" /></td>
                                        <spring:bind path="branchForm.branch.active">
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
                                    <c:if test="${edit}">
                                	    <tr><td class="label">&nbsp;</td><td colspan="2"><input type="submit" name="submit" value="submit" /></td></tr>
                                    </c:if>
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
                
                <c:choose>
                    <c:when test="${branchId != 0}">
                    
                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion1" tabindex="0">
                                <div class="AccordionPanel">
                                    <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.resultspublishdates" /></div>
                                    <div class="AccordionPanelContent">

                                    <sec:authorize access="hasAnyRole('CREATE_RESULT_VISIBILITY')">
                                        <a class="button" href="<c:url value='/college/branchAcademicYearTimeUnit.view'/>?newForm=true&amp;branchId=${branchForm.branch.id}&amp;tab=1">
                                            <fmt:message key="jsp.href.add" />
                                        </a>
                                    </sec:authorize>  

                                    <table class="tabledata2" id="resultsVisibilityTable">

                                    <tr>
                                        <th><fmt:message key="jsp.general.academicyear" /> - <fmt:message key="jsp.general.timeunit" /></th>
                                        <th><fmt:message key="jsp.general.resultspublishdates" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th>
                                        <th/>
                                    </tr>
                                    <c:forEach var="branchAcademicYearTimeUnit" items="${branchForm.allBranchAcademicYearTimeUnits}">
                                        <tr>
                                            <td><c:out value="${branchForm.idToAcademicYearMap[branchAcademicYearTimeUnit.academicYearId].description}"/>
                                                - <c:out value="${branchForm.codeToTimeUnitMap[branchAcademicYearTimeUnit.timeUnitCode] }"/>
                                            </td>
                                            <td><fmt:formatDate value="${branchAcademicYearTimeUnit.resultsPublishDate}" type="date"/></td>
                                            <td>${branchAcademicYearTimeUnit.active}</td>
                                            <td class="buttonsCell">
                                                <sec:authorize access="hasAnyRole('UPDATE_RESULT_VISIBILITY')">
                                                    <a class="imageLink" href="<c:url value='/college/branchAcademicYearTimeUnit.view?newForm=true&amp;branchAcademicYearTimeUnitId=${branchAcademicYearTimeUnit.id}&amp;tab=1'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                </sec:authorize>
                                                <sec:authorize access="hasRole('DELETE_BRANCHES')">
                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/branch.view?delete=branchAcademicYearTimeUnit&amp;branchAcademicYearTimeUnitId=${branchAcademicYearTimeUnit.id}'/>"
                                                    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                </sec:authorize>
                                            </td>   
                                        </tr>
                                    </c:forEach>
                                    
                                    </table>
                                    <script type="text/javascript">alternate('resultsVisibilityTable',true)</script>
        
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
    
                    <%-- show additional tab(s) only if branch exists --%>
                    </c:when>
                </c:choose>
    
                
        	</div>
    	</div>
    </form>
</div>

<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(<%//=request.getParameter("tab")%>);
    tp1.showPanel(${navigationSettings.tab});
</script>

</div>

<%@ include file="../../footer.jsp"%>

