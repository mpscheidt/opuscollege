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

<c:set var="screentitlekey">jsp.staffmembers.header</c:set>
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
			    <fmt:message key="jsp.staffmembers.header" />
                &nbsp;&nbsp;&nbsp;
                <c:if test="${accessContextHelp}">
                     <a class="white" href="<c:url value='/help/RegistrationDeanOfSchool.pdf'/>" target="_blank">
                        <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                     </a>&nbsp;
                </c:if>
                &nbsp;&nbsp;&nbsp;
                <c:if test="${accessContextHelp}">
                     <a class="white" href="<c:url value='/help/RegistrationHeadOfDepartment.pdf'/>" target="_blank">
                        <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                     </a>&nbsp;
                </c:if>
		        &nbsp;&nbsp;&nbsp;
		        <c:if test="${accessContextHelp}">
		             <a class="white" href="<c:url value='/help/RegistrationTeacher.pdf'/>" target="_blank">
		                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
		             </a>&nbsp;
		        </c:if>
			</legend>
            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>
            <form name="searchform">
            <table>
                <tr>
                    <td width="700" align="right">
                        <input type="text" name="searchValue" id="searchValue"  value="<c:out value="${searchValue }" />" />&nbsp;
                        <img src="<c:url value='/images/search.gif' />" onclick="document.searchform.submit()" alt="<fmt:message key='jsp.general.search'/>" />
                    </td>
                </tr>
            </table>
            </form>

	        <c:choose>        
	       		<c:when test="${ not empty showStaffMemberError }">       
	                <p align="left" class="errorwide">
	                     <fmt:message key="jsp.error.staffmember.delete" /> <c:out value="${showStaffMemberError}"/>
	                </p>
	         	</c:when>
	      	</c:choose>
              
		</fieldset>
        
        <sec:authorize access="hasRole('CREATE_STAFFMEMBERS')">
            <table style="width:100%;">
<%--                 <tr><td height="65">&nbsp;</td></tr> --%>
                <tr>
                    <td class="addbutton" align="right">
                        <a style="vertical-align:bottom;" class="button" href="<c:url value='/college/staffmember.view?newForm=true'/>">
                            <fmt:message key="general.add.staffmember"/>
                        </a>
                    </td>
                </tr>
            </table>
        </sec:authorize>
        

		<c:set var="allEntities" value="${allStaffMembers}" scope="page" />
		<c:set var="redirView" value="staffmembers" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="jsp.general.code" /></th>
            	<th><fmt:message key="jsp.general.title" /></th>
            	<th><fmt:message key="jsp.general.firstnames" /></th>
            	<th><fmt:message key="jsp.general.surname" /></th>
            	<th><fmt:message key="jsp.general.birthdate" /></th>
            	<th><fmt:message key="jsp.general.active" /></th>
                <th><fmt:message key="jsp.general.organizationalunit" /></th>
            	<th></th>
            </tr>
        
            <c:forEach var="staffMember" items="${allStaffMembers}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
	                <tr>
                        <td><c:out value="${staffMember.staffMemberCode}"/></td>
	                    <td>
	                    <c:forEach var="academicTitle" items="${allGradeTypes}">
	                        <c:choose>
	                            <c:when test="${academicTitle.code == staffMember.gradeTypeCode }">
	                                <c:out value="${academicTitle.title}"/>
	                            </c:when>
	                        </c:choose>
	                    </c:forEach>
	                    </td>
	                    <td><c:out value="${staffMember.firstnamesFull}"/></td>
	                    <td>
                            <c:set var="authorizedToEdit" value="${false}"/>
                            <sec:authorize access="hasRole('UPDATE_STAFFMEMBERS') or ${staffMember.personId == opusUser.personId}">
<%-- the following version with the url parameter doesn't work yet (Spring Security 3.1RC2): throws UnsupportedOperationException --%>
<%--                             <sec:authorize url="/college/staffmember.view?staffMemberId=${staffMember.staffMemberId}"> --%>
                                <c:set var="authorizedToEdit" value="${true}"/>
                            </sec:authorize>
                            <c:choose>
                                <c:when test="${authorizedToEdit}">
                                    <a href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=0&amp;panel=0&amp;from=staffmembers&amp;staffMemberId=${staffMember.staffMemberId}&amp;searchValue=${searchValue}&amp;currentPageNumber=${currentPageNumber}'/>">
                                        <c:out value="${staffMember.surnameFull}"/>
                                    </a>
                                </c:when>
                                <c:otherwise>
	                            	<c:out value="${staffMember.surnameFull}"/>
                                </c:otherwise>
                            </c:choose>
                        </td>
	                    <td><fmt:formatDate pattern="dd/MM/yyyy" value="${staffMember.birthdate}" /></td>
	                    <td><c:out value="${staffMember.active}"/></td>
                        <td><c:out value="${idToOrganizationalUnitMap[staffMember.primaryUnitOfAppointmentId].organizationalUnitDescription}"/>
                        </td>
	                    <td class="buttonsCell">
	                        <c:choose>
	                            <c:when test="${authorizedToEdit}">
	                    			<a class="imageLink" href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=0&amp;panel=0&amp;from=staffmembers&amp;staffMemberId=${staffMember.staffMemberId}&amp;searchValue=${searchValue}&amp;currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />"  /></a>
	                    		</c:when>
	                    	</c:choose>
                            <sec:authorize access="hasRole('DELETE_STAFFMEMBERS') and ${staffMember.personId != opusUser.personId}">
                				<a class="imageLinkPaddingLeft" href="<c:url value='/college/staffmember_delete.view?staffMemberId=${staffMember.staffMemberId}&amp;currentPageNumber=${currentPageNumber}'/>"
                    			onclick="return confirm('<fmt:message key="jsp.staffmembers.delete.confirm" />')"><img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
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
