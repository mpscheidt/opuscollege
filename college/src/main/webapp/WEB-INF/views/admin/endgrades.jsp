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

<c:set var="screentitlekey">jsp.endgrades.header</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    <div id="tabcontent">

 		<fieldset>
 			<legend>
    			<fmt:message key="jsp.endgrades.header" />
    		</legend>

            <form:form modelAttribute="endGradesForm" method="post">	
    			<p align="left">
<%-- 					<form name="organizationandnavigation" method="post" action="${navigationSettings.action}"> --%>
						<input type="hidden" name="task" value="updateFormObject"/>
						<%@ include file="../includes/endGradeFilters.jsp"%>
						<%@ include file="../includes/searchValue.jsp"%>
<%-- 	        		</form>    --%>
        		</p>
            </form:form>
	     </fieldset>
		<c:set var="allEntities" value="${endGradesForm.mapEndGrades}" scope="page" />
		<c:set var="redirView" value="endgrades" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

	        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${fn:length(endGradesForm.mapEndGrades)}" scope="page" />
        <%@ include file="../includes/pagingHeaderInterface.jsp"%>           


        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="jsp.general.academicyear" /></th>
                <th><fmt:message key="general.type" /></th>
                <th><fmt:message key="jsp.general.code" /></th>
                <th><fmt:message key="jsp.general.comment" /></th>
                <th><fmt:message key="jsp.general.gradepoint" /></th>
                <th><fmt:message key="general.percentagemin" /></th>
                <th><fmt:message key="general.percentagemax" /></th>
                <th><fmt:message key="jsp.general.passed" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th>&nbsp;</th>
            </tr>
            <c:forEach var="endGrade" items="${endGradesForm.mapEndGrades}" varStatus="rowIndex">

                <tr>
                	<td>
                        <c:out value="${endGrade.academicYear}"/>
                	</td>
                	<td>
                        <c:out value="${endGrade.type}"/>
                	</td>
                	<td style="text-align:center">
                        <c:out value="${endGrade.code}"/>
                	</td>
                	<td>
                        <c:out value="${endGrade.comment}"/>
                	</td>
                	<td style="text-align:center">
                        <c:out value="${endGrade.gradePoint}"/>
                	</td>
                	<td style="text-align:center">
                        <c:out value="${endGrade.percentageMin}"/>
                	</td>
                	<td style="text-align:center">
                        <c:out value="${endGrade.percentageMax}"/>
                	</td>
                	<td style="text-align:center">
                		<c:choose>
                			<c:when test="${endGrade.passed == 'Y'}">
                				<fmt:message key='jsp.general.yes'/>
                			</c:when>
                			<c:when test="${endGrade.passed == 'N'}">
                				<fmt:message key='jsp.general.no'/>
                			</c:when>
                		</c:choose>
                	</td>
                	<td style="text-align:center">
                		<c:choose>
                			<c:when test="${endGrade.active == 'Y'}">
                				<fmt:message key='jsp.general.yes'/>
                			</c:when>
                			<c:when test="${endGrade.active == 'N'}">
                				<fmt:message key='jsp.general.no'/>
                			</c:when>
                		</c:choose>
                	</td>
                    <td class="buttonsCell" style="width:10%;text-align: center;">

                        <c:url value="/college/endgrade.view" var="editUrl">
                        	<c:param name="endGradeCode" value="${endGrade.code}"/>
                        	<c:param name="academicYearId" value="${endGrade.academicYearId}"/>
                        	<c:param name="typeCode" value="${endGrade.endGradeTypeCode}"/>
                            <c:param name="newForm" value="true"/>
                            <c:param name="id" value="${endGrade.id}"/>
                        	<c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}"/>
                        </c:url>

                        <c:url value="/college/endgrades.view" var="deleteUrl">
                        	<c:param name="endGradeCode" value="${endGrade.code}"/>
                        	<c:param name="academicYearId" value="${endGrade.academicYearId}"/>
                        	<c:param name="typeCode" value="${endGrade.endGradeTypeCode}"/>
                            <c:param name="id" value="${endGrade.id}"/>
                        	<c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}"/>
                        	<c:param name="newForm" value="true"/>
                        	<c:param name="task" value="deleteEndGrade"/>
                        </c:url>
                        
                        <a class="imageLink" href="<c:out value="${editUrl}"/>">
                            <img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key='jsp.href.edit'/>" title="<fmt:message key='jsp.href.edit'/>"/>
                        </a>
                        <a class="imageLinkPaddingLeft" href="<c:out value="${deleteUrl}"/>" onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooterNew.jsp"%>

        <br /><br />
			
			
    </div><!-- tabcontent -->    
</div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>