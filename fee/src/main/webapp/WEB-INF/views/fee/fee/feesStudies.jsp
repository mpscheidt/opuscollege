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

The Original Code is Opus-College fee module code.

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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <%@ include file="../../menu.jsp"%>

	
    <div id="tabcontent">
 
		<fieldset>
		<legend>
		<fmt:message key="jsp.fees.header.studies" />
		&nbsp;&nbsp;&nbsp;
        <c:if test="${accessContextHelp}">
             <a class="white" href="<c:url value='/help/FeesDefinition.pdf'/>" target="_blank">
                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
             </a>&nbsp;
        </c:if>
		</legend>
        <p align="left">
            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>
        </p>      
		
        	<c:choose>        
       			<c:when test="${ not empty showFeesStudiesError }">       
         	       <p align="left" class="error">
         	            <fmt:message key="jsp.error.study.delete" /> ${showFeesStudiesError }
         	       </p>
        	 	</c:when>
      		</c:choose>
		</fieldset>

		<c:set var="allEntities" value="${allStudies}" scope="page" />
		<c:set var="redirView" value="feesstudies" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.organizationalunit" /></th>
            <th><fmt:message key="jsp.general.id" /></th>
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th></th>
            <c:forEach var="study" items="${allStudies}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
		                <tr>
		                    <td>
		                    <c:forEach var="allOrganizationalUnits" items="${organizationalUnitsForStudies}">
		                       <c:choose>
		                            <c:when test="${allOrganizationalUnits.id == study.organizationalUnitId }">
		                                ${allOrganizationalUnits.organizationalUnitDescription}
		                            </c:when>
		                       </c:choose>
		                   </c:forEach>
		                   </td>
		                   <td>${study.id}</td>
		                   <td>
	                        <c:choose>
	                            <c:when test="${opusUser.personId == student.personId
	                             || (opusUserRole.role != 'student' 
	                             && opusUserRole.role != 'guest')
	                            }">
		                    	<a href="<c:url value='/fee/feesstudy.view?tab=0&panel=0&from=fees_studies&studyId=${study.id}&currentPageNumber=${currentPageNumber}'/>">
		                    		${study.studyDescription}
		                    	</a>
	                            </c:when>
	                            <c:otherwise>
		                    		${study.studyDescription}
	                            </c:otherwise>
	                        </c:choose>
		                    </td>
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
			                    	<c:when test="${(
			                    		opusUserRole.role != 'teacher'
		                            	&& opusUserRole.role != 'student' 
	                   					&& opusUserRole.role != 'guest'
	           							)}">
			                        <a href="<c:url value='/fee/feesstudy.view?tab=0&panel=0&from=fees_studies&studyId=${study.id}&currentPageNumber=${currentPageNumber}'/>">
			                        	<img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
			                        </a>
			                    	</c:when>
		                    	</c:choose>       
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
