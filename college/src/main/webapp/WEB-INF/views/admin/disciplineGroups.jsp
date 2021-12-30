<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are disciplineGroup to the Mozilla Public License Version
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


<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.disciplinegroups.header</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
	<spring:bind path="disciplineGroupsForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="disciplineGroupsForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  
    	
    <div id="tabcontent">
 
		<fieldset>
		<legend><fmt:message key="jsp.disciplinegroups.header" /></legend>
        <p align="left">
			<form name="organizationandnavigation" method="post" action="${navigationSettings.action}">
				<%@ include file="../includes/searchValue.jsp"%>
	        </form>   
        </p>  
		
		</fieldset>

	<%--messages --%>
    <c:if test="${ not empty disciplineGroupsForm.txtMsg }">       
        <p align="right" class="msg">
            <c:out value="${disciplineGroupsForm.txtMsg}"/>
        </p>
    </c:if>

	<%--error messages --%>
	<c:if test="${ not empty disciplineGroupsForm.errorMessages }">
      		<table>       
       	       <c:forEach items="${disciplineGroupsForm.errorMessages}" var="errorMessage" varStatus="row">
   					<c:if test="${((row.index + 1)% 3) == 1}">
   						<tr>
   					</c:if>
       	       		<td align="left" style="margin:2px; ">
       	           		<span class="error">
       	           		   ${row.index + 1}.${errorMessage}
       	           		</span>
       	       		</td>
       	       		<c:if test="${((row.index + 1)% 3) == 0}">
   						</tr>
   					</c:if>
       	       </c:forEach>
       	       </table>
      	</c:if>

		<c:set var="allEntities" value="${disciplineGroupsForm.disciplineGroups}" scope="page" />
		<c:set var="redirView" value="disciplinegroups" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../includes/pagingHeaderNew.jsp"%>

        <table class="tabledata" id="TblData">
            <tr>
            	<th><fmt:message key="jsp.general.code"/></th>
                <th><fmt:message key="jsp.general.description" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th>&nbsp;</th>
            </tr>
            <c:forEach var="disciplineGroup" items="${disciplineGroupsForm.disciplineGroups}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
		                <tr>
		    				<td style="width:15%;">
		    					<c:out value="${disciplineGroup.code}"/>
		    				</td>
		                    <td>
 		                    	<a href="<c:url value='/college/disciplinegroup.view'/>?<c:out value='newForm=true&groupId=${disciplineGroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
			                    	<c:out value="${disciplineGroup.description}"/>
			                    </a>
		                   </td>
		                   <td style="width:7%;text-align:center">
							<c:choose>	
								<c:when test="${disciplineGroup.active == 'Y'}">
									<fmt:message key="jsp.general.yes"/>
								</c:when>
								<c:when test="${disciplineGroup.active == 'N'}">
									<fmt:message key="jsp.general.no"/>
								</c:when>
							</c:choose>
		                   </td>
		                    <td class="buttonsCell" style="width:7%;text-align:center">
		                        <a class="imageLink" href="<c:url value='/college/disciplinegroup.view'/>?<c:out value='newForm=true&groupId=${disciplineGroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>

		                        <sec:authorize access="hasRole('DELETE_STUDIES')">
                        			<a class="imageLinkPaddingLeft" href="<c:url value='/college/disciplinegroup_delete.view'/>?<c:out value='newForm=true&groupId=${disciplineGroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                        			onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                </sec:authorize>
		                    </td>
		                </tr>
	                </c:when>
	            </c:choose>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooterNew.jsp"%>

        <br /><br />
    </div>
    
</div>

<%@ include file="../footer.jsp"%>
