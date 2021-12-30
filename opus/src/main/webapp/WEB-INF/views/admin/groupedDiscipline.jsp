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

<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper"><%@ include file="../menu.jsp"%>

    <spring:bind path="groupedDisciplineForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  

<div id="tabcontent">

<fieldset>
    <legend>
        <a href="<c:url value='/college/disciplinegroups.view'/>?<c:out value='newForm=true&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
        <a href="<c:url value='/college/disciplinegroup.view'/>?<c:out value='newForm=true&groupId=${groupedDisciplineForm.disciplineGroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}&tab=1'/>">
            <c:out value="${groupedDisciplineForm.disciplineGroup.description}"/>
        </a>
        &nbsp; > &nbsp;
        <fmt:message key="general.disciplines"/>
    </legend>

<!-- <p><strong><fmt:message key="jsp.disciplinetables.newtimeunit"/></strong></p>-->
<form method="post" >
	<input type="hidden" name="groupId" value="${groupedDisciplineForm.disciplineGroup.id}"/>        

  <input type="submit" value="<fmt:message key='jsp.button.addselected'/>" id="addDisciplinesButton" disabled="true" />
    
</fieldset>

		<c:set var="allEntities" value="${groupedDisciplineForm.disciplinesNotInGroup}" scope="page" />
        <c:set var="redirView" value="disciplines" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

		<table  id="TblData">
    		<th style="width:5%">
                <input type="checkbox" name="checker" 
                        id="checker" onclick="javascript:toggleGroup('disciplinesCodes',this.checked);"
                        onchange="jQuery('#addDisciplinesButton').attr('disabled', !this.checked || !anySelected('disciplinesCodes',null));"
                        />
            </th>
            <th><fmt:message key="general.description" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            
			<c:forEach items="${groupedDisciplineForm.disciplinesNotInGroup}" var="discipline">
				<tr>
					<td style="width:7%">
                            <input type="checkbox" id="disciplineCodeCheckBox${discipline.id}" 
                                   name="disciplinesCodes" value='<c:out value="${discipline.code}"/>'
                                   onchange="jQuery('#addDisciplinesButton').attr('disabled', !anySelected('disciplinesCodes',null));"
                                   />
                        </td>
					<td>
    					<a href="<c:url value='/college/discipline.view'/>?<c:out value='disciplineCode=${discipline.code}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
    						<c:out value="${discipline.description}"/>
    					</a>
					</td>			
					<td style="width:7%;text-align: center">
                        <c:choose>
                        	<c:when test="${discipline.active == 'Y'}">
                        		<fmt:message key="jsp.general.yes"/>
                        	</c:when>
                        	<c:otherwise>
                        		<fmt:message key="jsp.general.no"/>
                        	</c:otherwise>
                        </c:choose>
                    </td>
				</tr>
			</c:forEach>
        
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>
		
		<%@ include file="../includes/footerWithNoPaging.jsp"%>
</form>

</div><%--tabContent --%>
</div><%--tabWrapper --%>

<%@ include file="../footer.jsp"%>