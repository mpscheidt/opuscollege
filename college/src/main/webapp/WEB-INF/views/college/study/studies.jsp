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

<c:set var="screentitlekey">jsp.studies.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
	<spring:bind path="studiesForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studiesForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  
    	
    <div id="tabcontent">
 
		<fieldset>
		<legend><fmt:message key="jsp.studies.header" /></legend>
		<form name="organizationandnavigation" method="post" action="${navigationSettings.action}">
            <table style="width:100%;">
                <tr>
                    <td>
            			<%@ include file="../../includes/organizationAndNavigation.jsp"%>
                    </td>
                    <td>
                        <%@ include file="../../includes/searchValue.jsp"%>
                        <sec:authorize access="hasRole('CREATE_STUDIES')">
                            <table style="width:100%;">
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                    <td class="addbutton" align="right">
                                        <a style="vertical-align:bottom;" class="button" href="<c:url value='/college/study.view?newForm=true'/>">
                                            <fmt:message key="general.add.study"/>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </sec:authorize>
                    </td>
                </tr>
            </table>
        </form>
		
      	<c:choose>        
     		<c:when test="${ not empty studiesForm.txtErr }">       
       	       <p align="left" class="error">
       	            <fmt:message key="jsp.error.study.delete" /> <c:out value="${studiesForm.txtErr}"/>
       	       </p>
      	 	</c:when>
    	</c:choose>
    	<c:choose>        
     		<c:when test="${ not empty studiesForm.txtMsg }">       
       	       <p align="right" class="msg">
       	            <c:out value="${studiesForm.txtMsg}"/>
       	       </p>
      	 	</c:when>
    	</c:choose>

		</fieldset>

		<c:set var="allEntities" value="${studiesForm.allStudies}" scope="page" />
		<c:set var="redirView" value="studies" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeaderNew.jsp"%>

        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="general.study.name" /></th>
                <th><fmt:message key="jsp.general.organizationalunit" /></th>
                <c:if test="${showBranches}">
                    <th><fmt:message key="jsp.general.branch" /></th>
                </c:if>
                <th><fmt:message key="jsp.general.active" /></th>
            </tr>
            <c:forEach var="study" items="${studiesForm.allStudies}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
		                <tr>
		                    <td>
                                <c:set var="authorizedToEdit" value="${false}"/>
                                <sec:authorize access="hasRole('UPDATE_STUDIES')">
                                    <c:set var="authorizedToEdit" value="${true}"/>
                                </sec:authorize>
                                <c:choose>
                                    <c:when test="${authorizedToEdit}">
        		                    	<a href="<c:url value='/college/study.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studyId=${study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        		                    		<c:out value="${study.studyDescription}"/>
        		                    	</a>
    	                            </c:when>
    	                            <c:otherwise>
    		                    		<c:out value="${study.studyDescription}"/>
    	                            </c:otherwise>
    	                        </c:choose>
		                    </td>
                            <c:set var="organizationalUnit" value="${studiesForm.idToOrganizationalUnitMap[study.organizationalUnitId]}" />
                            <td>
                                <c:out value="${organizationalUnit.organizationalUnitDescription }" />
                            </td>
                            <c:if test="${showBranches}">
                                <td>
                                    <c:out value="${studiesForm.idToBranchMap[organizationalUnit.branchId].branchDescription}" />
                                </td>
                            </c:if>
		                    <td>
		                        <c:choose>
		                            <c:when test="${study.active == 'Y'}">
		                                <fmt:message key="jsp.general.yes" />
		                            </c:when>
		                            <c:otherwise>
		                                <fmt:message key="jsp.general.no" />
		                            </c:otherwise>
		                        </c:choose>
		                    </td>
		                    <td class="buttonsCell">
                                <c:choose>
                                    <c:when test="${authorizedToEdit}">
    			                        <a class="imageLink" href="<c:url value='/college/study.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studyId=${study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    </c:when>
                                </c:choose>
                                <sec:authorize access="hasRole('DELETE_STUDIES')">
                        			<a class="imageLinkPaddingLeft" href="<c:url value='/college/study_delete.view?newForm=true&amp;studyId=${study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                        			onclick="return confirm('<fmt:message key="jsp.studies.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                </sec:authorize>
		                    </td>
		                </tr>
	                </c:when>
	            </c:choose>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooterNew.jsp"%>

        <br /><br />
    </div>
    
</div>

<%@ include file="../../footer.jsp"%>
