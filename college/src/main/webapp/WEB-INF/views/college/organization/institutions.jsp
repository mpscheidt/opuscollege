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

<c:set var="screentitlekey">jsp.institutions.header</c:set>
<c:if test="${institutionTypeCode == 1}"><c:set var="screentitlekey">jsp.general.secondaryschools</c:set></c:if>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasRole('UPDATE_INSTITUTIONS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>
                            
    <%--@ include file="../sidebar_organizations.jsp" --%>
		
    <div id="tabcontent">
        <fieldset>
			<legend><fmt:message key="jsp.institutions.header" /> - 
	        <c:choose>
	            <c:when test="${institutionTypeCode == INSTITUTION_TYPE_HIGHER_EDUCATION}">
	                <fmt:message key="jsp.general.highereducation" />
	            </c:when>
	            <c:when test="${institutionTypeCode == INSTITUTION_TYPE_SECONDARY_SCHOOL}">
	                <fmt:message key="jsp.general.secondaryschools" />
	            </c:when>
	            <c:otherwise>
	                <c:forEach var="oneInstitutionType" items="${allInstitutionTypes}">
	                    <c:choose>
	                        <c:when test="${oneInstitutionType.code == institutionTypeCode }">
	                           <c:out value="${oneInstitutionType.description}"/>
	                        </c:when>
	                    </c:choose>
	                </c:forEach>
	            </c:otherwise>
	        </c:choose>
	        </legend>
	        
	        <c:choose>
	            <c:when test="${(not empty showError)}">             
	            <p align="left" class="error">
	                <fmt:message key="jsp.error.institution.delete" />
	                <fmt:message key="jsp.error.general.delete.linked.${ showError }" />
	            </p>
	           </c:when>
	        </c:choose>
            <c:choose>
                <c:when test="${(not empty showInstitutionError)}">             
                <p align="left" class="error">
                    ${showInstitutionError}
                </p>
               </c:when>
            </c:choose>
	        
		</fieldset>
		
		<c:set var="allEntities" value="${allInstitutions}" scope="page" />
		<c:set var="redirView" value="institutions" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>
       
        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="jsp.general.id" /></th>
                <th><fmt:message key="jsp.general.name" /></th>
                <th><fmt:message key="jsp.institution.institutiontype" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th></th>
            </tr>
            
            <c:forEach var="institution" items="${allInstitutions}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
	                <tr>
	                    <td>${institution.id}</td>
	                    <td>
                            <c:choose>
                                <c:when test="${authorizedToEdit}">
            	                    <a href="<c:url value='/college/institution.view?institutionId=${institution.id}&institutionTypeCode=${institutionTypeCode }&currentPageNumber=${currentPageNumber}'/>">
            	                        <c:out value="${institution.institutionDescription}"/>
            	                    </a>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${institution.institutionDescription}"/>
                                </c:otherwise>
                            </c:choose>
	                    </td>
	                    <td>
	                    <c:forEach var="institutionType" items="${allInstitutionTypes}">
	                        <c:choose>
	                            <c:when test="${institutionType.code == institution.institutionTypeCode }">
	                                <c:out value="${institutionType.description}"/>
	                            </c:when>
	                        </c:choose>
	                    </c:forEach>
	                    </td>
	                    <td>${institution.active}</td>
	                    <td class="buttonsCell">
                            <c:choose>
                                <c:when test="${authorizedToEdit}">
                                    <a class="imageLink" href="<c:url value='/college/institution.view?institutionId=${institution.id}&institutionTypeCode=${institutionTypeCode }&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                </c:when>
                            </c:choose>
                            <sec:authorize access="hasRole('DELETE_INSTITUTIONS')">
                                <c:choose>
                                    <c:when test="${institution.institutionTypeCode == INSTITUTION_TYPE_SECONDARY_SCHOOL}">
		                        		<a class="imageLinkPaddingLeft" href="<c:url value='/college/institution_delete.view?institutionId=${institution.id}&institutionTypeCode=${institutionTypeCode }&currentPageNumber=${currentPageNumber}'/>"
		                        		    onclick="return confirm('<fmt:message key="jsp.institutions.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
		                        	</c:when>
		                        	<c:otherwise>
		                        	    <a class="imageLinkPaddingLeft" href="<c:url value='/college/institution_delete.view?institutionId=${institution.id}&institutionTypeCode=${institutionTypeCode }&currentPageNumber=${currentPageNumber}'/>"
                                            onclick="return confirm('<fmt:message key="jsp.institutions.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
		                        	</c:otherwise>
		                          </c:choose>
                            </sec:authorize>
	                    </td>
                    </tr>
	                </c:when>
	            </c:choose>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooter.jsp"%>

        <br /><br />
    </div>
</div>

<%@ include file="../../footer.jsp"%>
