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


<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.roles.header</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../menu.jsp"%>

    <div id="tabcontent">
        <fieldset>
            <legend>
                <fmt:message key="jsp.roles.header" />
            </legend>
        
            <form name="searchform" id="searchform" method="get">
                <table>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.search" /></td>
                            <td width="700" align="left">
                                <img src="<c:url value='/images/trans.gif' />" width="10"/>            
                                <input type="text" name="searchValue" value="${searchValue}"/>&nbsp;
                                <img src="<c:url value='/images/search.gif'/>" alt="<fmt:message key='jsp.general.search'/>" title="<fmt:message key='jsp.general.search'/>"
                                    style="cursor:pointer; cursor:hand;" onclick="document.searchform.submit()"/>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </form>

       		<c:if test="${ not empty roleHasUsersError }">       
                <p align="left" class="error">
                     <fmt:message key="jsp.error.thereareusersinrole" />
                </p>
         	</c:if>
         	<c:if test="${ not empty notAuthorizedToDeleteRole}">       
                <p align="left" class="error">
                     <fmt:message key="jsp.error.notauthorizedtodeleterole" />
                </p>
         	</c:if>

        </fieldset>

	    <a class="button" href="<c:url value='/college/role.view'/>">
            <fmt:message key="jsp.href.add" />
        </a>
        <%@ include file="../includes/pagingHeader.jsp"%>
         
        <table class="tabledata" id="TblData">
                      
             <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.description" /></th>
            <th><fmt:message key="jsp.general.level" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th>&nbsp;</th>
            
            <c:forEach var="role" items="${roles}">
                        <tr>
                            <td>
                       			<%--admin role cannot be edited or deleted --%>
                               <c:choose>
                               	<c:when test="${role.role != 'admin'}">
                               		<a href="<c:url value='/college/role.view'/>?<c:out value='roleName=${role.role}&currentPageNumber=${currentPageNumber}'/>">
                                		<c:out value="${role.role}"/>
                               		</a>
                               	</c:when>
                               	<c:otherwise>
                               		<c:out value="${role.role}"/>
                               	</c:otherwise>
                               </c:choose>
                            </td>
                            <td>
                                <c:out value="${role.roleDescription}"/>
                            </td>
                            <td style="width:5%;text-align: center">
                                <c:out value="${role.level}"/>
                            </td>
                            <td style="width:5%;text-align: center">
                                <c:choose>
                                    <c:when test="${role.active == 'Y'}">
                                        <fmt:message key="jsp.general.yes" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.no" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="width:10%;text-align: center">
                               	<%--admin role cannot be edited or deleted --%>
                               	&nbsp;
                               	<c:if test="${role.role != 'admin'}">
    	                           	<sec:authorize access="hasRole('UPDATE_ROLES')">
        		                       	<a href="<c:url value='/college/role.view'/>?<c:out value='roleName=${role.role}&currentPageNumber=${currentPageNumber}'/>">
                		               		<img src="<c:url value='/images/edit.gif' />" 
                        		       			 alt="<fmt:message key="jsp.href.edit" />" 
                               					 title="<fmt:message key="jsp.href.edit" />" /></a>
                               		</sec:authorize>
                               			&nbsp;&nbsp;
    <%-- don't allow to delete a role if users are assigned -> give an error message. For now delete button is disabled
         plus a bug: the opusrole_privilege entries are apparently not deleted in the DB when deleting a role--%>
                               		<sec:authorize access="hasRole('DELETE_ROLES')">
    			                 		<a href="<c:url value='/college/role_delete.view'/>?<c:out value='role=${role.role}&currentPageNumber=${currentPageNumber}'/>"
    			                    		onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
    			                     		<img src="<c:url value='/images/delete.gif' />" 
    			                     	   		alt="<fmt:message key="jsp.href.delete" />" 
    			                     	   		title="<fmt:message key="jsp.href.delete" />" 
    			                     		/>
    			                    	</a>
    			                    </sec:authorize>
    			                </c:if>
                            </td>
                        </tr>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

                <fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.roles" />: ${fn:length(roles)}&nbsp;

        <br /><br />
    </div>
    
</div>

<%@ include file="../footer.jsp"%>