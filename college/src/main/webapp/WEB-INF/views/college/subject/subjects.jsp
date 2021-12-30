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

<c:set var="screentitlekey">jsp.subjects.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <c:set var="organization" value="${subjectsForm.organization}" scope="page" />
    <c:set var="navigationSettings" value="${subjectsForm.navigationSettings}" scope="page" />

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">
    
		<fieldset>
			<legend>
			<fmt:message key="jsp.subjects.header" />
			&nbsp;&nbsp;&nbsp;
	        <c:if test="${accessContextHelp}">
	             <a class="white" href="<c:url value='/help/RegistrationSubject.pdf'/>" target="_blank">
	                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
	             </a>&nbsp;
	        </c:if>
	        
			</legend>

            <sec:authorize access="hasRole('READ_STUDIES')">

	            <%--form name="studies" action="<c:url value='${action}'/>" method="post" target="_self" onchange="document.studies.submit();"> --%>
                <!-- form name="formdata" method="post"-->
                <form:form modelAttribute="subjectsForm" method="post">
                    <table style="width:100%;">
                        <tr>
                            <td>
<%--                                 <%@ include file="../../includes/organizationAndNavigation.jsp"%> --%>
                                <%@ include file="../../includes/navigation_privileges.jsp"%>

                                <input type="hidden" name="navigationSettings.currentPageNumber" id="navigationSettings.currentPageNumber" value="${navigationSettings.currentPageNumber}" />

                                <c:if test="${showInstitutions}">
                                    <table>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.university" /></td>
                                            <td width="200" align="right">
                                                <form:select path="organization.institutionId" onchange="
                                                        document.getElementById('organization.branchId').value='0';
                                                        document.getElementById('organization.organizationalUnitId').value='0';
                                                        document.getElementById('navigationSettings.searchValue').value='';
                                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="institution" items="${organization.allInstitutions}">
                                                        <form:option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                            <td></td>
                                       </tr>
                                    </table>
                                </c:if>

                                <c:if test="${showBranches}">
                                    <table>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.branch" /></td>
                                            <td width="200" align="right">
                                                <form:select path="organization.branchId" onchange="
                                                        document.getElementById('organization.organizationalUnitId').value='0';
                                                        document.getElementById('navigationSettings.searchValue').value='';
                                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
<%--                                                     <c:choose> --%>
<%--                                                         <c:when test="${organization.institutionId != 0}">  --%>
                                                            <c:forEach var="branch" items="${organization.allBranches}">
                                                                <form:option value="${branch.id}"><c:out value="${branch.branchDescription}"/></form:option>
                                                            </c:forEach>
<%--                                                             <c:forEach var="oneBranch" items="${allBranches}"> --%>
<%--                                                                 <c:choose> --%>
<%--                                                                     <c:when test="${oneBranch.id == organization.branchId}">  --%>
<%--                                                                         <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                                                     </c:when> --%>
<%--                                                                     <c:otherwise> --%>
<%--                                                                         <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                                                     </c:otherwise> --%>
<%--                                                                 </c:choose> --%>
<%--                                                             </c:forEach> --%>
<%--                                                         </c:when> --%>
<%--                                                     </c:choose> --%>
                                                </form:select>
                                            </td>
                                            <td></td>
                                       </tr>
                                    </table>
                                </c:if>

                                <c:if test="${showOrgUnits}">
                                    <table>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.organizationalunit" /></td>
                                            <td width="200" align="right">
                                                <form:select path="organization.organizationalUnitId" onchange="
                                                        document.getElementById('navigationSettings.searchValue').value='';
                                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="organizationalUnit" items="${organization.allOrganizationalUnits}">
                                                        <form:option value="${organizationalUnit.id}">
                                                            <c:out value="${organizationalUnit.organizationalUnitDescription}"/> (<fmt:message key="jsp.organizationalunit.level" /> <c:out value="${organizationalUnit.unitLevel})"/>
                                                        </form:option>
                                                    </c:forEach>
<%--                                                     <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}"> --%>
<%--                                                         <c:choose> --%>
<%--                                                             <c:when test="${organization.institutionId != 0 && organization.branchId != 0}">  --%>
<%--                                                                 <c:set var="orgUnitText">${oneOrganizationalUnit.organizationalUnitDescription} (<fmt:message key="jsp.organizationalunit.level" /> ${oneOrganizationalUnit.unitLevel})</c:set> --%>
<%--                                                                 <c:choose> --%>
<%--                                                                       <c:when test="${ oneOrganizationalUnit.id == organization.organizationalUnitId}">  --%>
<%--                                                                           <option value="${oneOrganizationalUnit.id}" selected="selected"><c:out value="${orgUnitText}"/></option> --%>
<%--                                                                       </c:when> --%>
<%--                                                                       <c:otherwise> --%>
<%--                                                                           <option value="${oneOrganizationalUnit.id}"><c:out value="${orgUnitText}"/></option> --%>
<%--                                                                       </c:otherwise> --%>
<%--                                                                 </c:choose> --%>
<%--                                                             </c:when> --%>
<%--                                                         </c:choose> --%>
<%--                                                     </c:forEach> --%>
                                                </form:select>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                </c:if>


            	                <%--input type="text" name="institutionId" value="${institutionId}" />
            	                <input type="text" name="branchId" value="${branchId}" />
            	                <input type="text" name="organizationalUnitId" value="${organizationalUnitId}" / --%>
            	                <table>
            	                    <tr>
            	                        <td class="label" width="200"><fmt:message key="jsp.general.study" /></td>
            	                        <td>
            	                        <select id="studyId" name="studyId" onchange="
                                                                            document.getElementById('navigationSettings.currentPageNumber').value=1;
                                                                            this.form.submit();">
            	                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            	                            <c:forEach var="oneStudy" items="${subjectsForm.dropDownListStudies}">
            	                                <c:choose>
                                                    <c:when test="${(subjectsForm.studyId == oneStudy.id)  }"> 
                                                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                                    </c:when>
            	                                    <c:otherwise>
            	             	                       <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
            	                                    </c:otherwise>
            	                                </c:choose>        
            	                            </c:forEach>
            	                        </select>
            	                        </td>
                                        <td>&nbsp;</td>
            	                   </tr>
                                    <!-- start of academic year -->
                                    <tr>
                                        <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
                                        <td>
                                        <select id="academicYearId" name="academicYearId" onchange="
                                                                document.getElementById('navigationSettings.currentPageNumber').value=1;
                                                                this.form.submit();">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="year" items="${subjectsForm.allAcademicYears}">                          
                                                <c:choose>
                                                    <c:when test="${year.id == subjectsForm.academicYearId}">
                                                        <option value="${year.id}" selected="selected"><c:out value="${year.description}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${year.id}"><c:out value="${year.description}"/></option>                            
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>
                                        </td>
                                    </tr>
                                    <!-- end of academic year -->
                                    
                                    <!-- start of order by -->
                                    <tr>
                                        <td class="label" width="200"><fmt:message key="jsp.general.order" /></td>
                                        <td>
                                        <select id="orderBy" name="orderBy" onchange="
                                                                document.getElementById('navigationSettings.currentPageNumber').value=1;
                                                                this.form.submit();">
                                                         <option value="lower(subjectCode)"
                                                         	<c:if test="${subjectsForm.orderBy == 'lower(subjectCode)'}"> selected="selected"</c:if> >
                                                         	<fmt:message key="general.code"/>
                                                         </option>
            
                                                         <option value="lower(subjectDescription)"
                                                         	<c:if test="${subjectsForm.orderBy == 'lower(subjectDescription)'}"> selected="selected"</c:if>
                                                         >
                                                         	<fmt:message key="general.name"/>
                                                         </option>       
                                                                
                                       </select>      
                                       </td>
                                       </tr>
                                       <!-- end of order by -->
            	                </table>
                            </td>
                            <td>
                                <%@ include file="../../includes/searchValue.jsp"%>
                                <sec:authorize access="hasRole('CREATE_SUBJECTS')">
                                    <table style="width:100%;">
                                        <tr><td height="65">&nbsp;</td></tr>
                                        <tr>
                                            <td class="addbutton" align="right">
                                                <a style="vertical-align:bottom;" class="button" href="<c:url value='/college/subject.view?newForm=true'/>">
                                                    <fmt:message key="general.add.subject"/>
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                </sec:authorize>
                            </td>
                        </tr>
                    </table>
	            </form:form>
            </sec:authorize>
	        	
            <form:errors path="subjectsForm.*" cssClass="errorwide" element="p"/>
	        
	   </fieldset>
        

        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${subjectsForm.subjectCount}" scope="page" />
		<c:set var="redirView" value="subjects" scope="page" />
        <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" scope="page" />
<%--         <%@ include file="../../includes/pagingHeaderInterface.jsp"%>            --%>
        <%@ include file="../../includes/pagingHeader.jsp"%>

       
        <table class="tabledata" id="TblData">
            <tr>
           <!--  <th><fmt:message key="jsp.general.id" /></th> -->
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.academicyear" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.studytime" /></th>
           <!--  <th><fmt:message key="jsp.general.studyform" /></th>-->
            <th><fmt:message key="jsp.subject.assigned" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th></th>
            </tr>
            
            <c:forEach var="oneSubject" items="${subjectsForm.allSubjects}">
                <tr>
                 <!-- <td>${oneSubject.id}</td> -->
                   <td><c:out value="${oneSubject.subjectCode}"/></td>
                   <td>
                        <c:set var="authorizedToEdit" value="${false}"/>
                        <sec:authorize access="hasRole('UPDATE_SUBJECTS')">
                            <c:set var="authorizedToEdit" value="${true}"/>
                        </sec:authorize>
			                    <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectId=${oneSubject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
			                        <c:out value="${oneSubject.subjectDescription}"/>
			                    </a>
                    </td>
                    <td>
                        <c:out value="${subjectsForm.idToAcademicYearMap[oneSubject.currentAcademicYearId].description}"/>
                    </td>
                    <td>
                        <c:out value="${subjectsForm.idToStudyMap[oneSubject.primaryStudyId].studyDescription}"/>
                    </td>
                    <td>
                		<c:out value="${subjectsForm.codeToStudyTimeMap[oneSubject.studyTimeCode].description}"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${(not empty oneSubject.subjectStudyGradeTypes) || (not empty oneSubject.subjectSubjectBlocks)}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${oneSubject.active}</td>
                    <td class="buttonsCell">
                    	<c:choose>
                            <c:when test="${authorizedToEdit}">
	                        	<a class="imageLink" href="<c:url value='/college/subject.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectId=${oneSubject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
		                    </c:when>
		                </c:choose>
                        <sec:authorize access="hasRole('DELETE_SUBJECTS')">
                        	<a class="imageLinkPaddingLeft" href="<c:url value='/college/subjects.view?delete=${oneSubject.id}'/>"
                        	onclick="return confirm('<fmt:message key="jsp.subjects.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                        </sec:authorize>
                    </td>
                </tr>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>
		
        <%@ include file="../../includes/pagingFooter.jsp"%>
		
        <br /><br />
        
    </div>
  
</div>

<%@ include file="../../footer.jsp"%>
