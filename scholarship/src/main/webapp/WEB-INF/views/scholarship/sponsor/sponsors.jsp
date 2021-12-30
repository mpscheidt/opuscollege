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

The Original Code is Opus-College scholarship module code.

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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

   <spring:bind path="sponsorsForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  
 
    <div id="tabcontent">

<form name="organizationandnavigation" id="organizationandnavigation" method="POST" >
	   <input type="hidden" name="navigationSettings.currentPageNumber" id="navigationSettings.currentPageNumber" value="${navigationSettings.currentPageNumber}" />
</form>

<fieldset>
    <legend>
        <fmt:message key="jsp.sponsors.header" />
    </legend>
    <form name="searchform" id="searchform" method="get">
        <table>
            <tr>
            <td class="label"><fmt:message key="jsp.general.search" /></td>
                <td width="700" align="left">
                   <img src="<c:url value='/images/trans.gif' />" width="10"/>            
                    <input type="text" name="searchValue" id="searchValue"  value="<c:out value="${searchValue}" />"/>&nbsp;
                    <!-- input type="submit" name="search" value="search" /-->
                   <img src="<c:url value='/images/search.gif'/>" 
                   alt="<fmt:message key='jsp.general.search'/>"
                   title="<fmt:message key='jsp.general.search'/>"
                   style="cursor:pointer; cursor:hand;"
                    onclick="document.searchform.submit()"/>
                </td>
            <td>
            
            </td>
            </tr>
        </table>
    </form>
        
    <sec:authorize access="hasRole('CREATE_SPONSORS')">
        <a class="button" href="<c:url value='/scholarship/sponsor.view?newForm=true'/>">
            <fmt:message key="jsp.href.add" />
        </a>
    </sec:authorize>
 </fieldset>
        
        
        <c:if test="${ not empty sponsorsForm.txtErr }">       
       	       <p align="left" class="error">
       	            ${sponsorsForm.txtErr}
       	       </p>
      	</c:if>
      	
      	<%--Writer 3 error messages per row --%>
      	<c:if test="${ not empty sponsorsForm.errorMessages }">
      		<table>       
       	       <c:forEach items="${sponsorsForm.errorMessages}" var="errorMessage" varStatus="row">
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
      	
        
		<c:set var="allEntities" value="${sponsorsForm.sponsors}" scope="page" />
		<c:set var="redirView" value="sponsors" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeaderNew.jsp"%>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.academicyear" /></th>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.title" /></th>
            <th><fmt:message key="jsp.general.type" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th>&nbsp;</th>
            
            <c:forEach var="sponsor" items="${sponsorsForm.sponsors}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
		                <tr>
                            <td>
                                ${sponsorsForm.idToAcademicYearMap[sponsor.academicYearId].description}
                            </td>
    		                <td style="width:15%;">
    		                	${sponsor.code}
    		                </td>
		                    <td>
                            <sec:authorize access="hasRole('UPDATE_SPONSORS')">
		                    	<a href="<c:url value='/scholarship/sponsor.view?newForm=true&tab=0&panel=0&from=sponsors&sponsorId=${sponsor.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
		                    		${sponsor.name}
		                    	</a>
                            </sec:authorize>
                            <sec:authorize access="! hasRole('UPDATE_SPONSORS')">
		                    		${sponsor.name}
                            </sec:authorize>
		                    </td>
                            <td>
                                ${sponsor.title}
                            </td>
                        	<td>
		                		${sponsor.sponsorType}
		                	</td>    
                            <td style="width:7%;text-align: center">
                                <fmt:message key="${stringToYesNoMap[sponsor.active]}"/>
                            </td>
                            
		                    <td class="buttonsCell" style="width:7%;text-align: center">
                                <sec:authorize access="hasRole('UPDATE_SPONSORS')">
                                    <a href="<c:url value='/scholarship/sponsor.view?newForm=true&tab=0&panel=0&from=sponsors&sponsorId=${sponsor.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                </sec:authorize>
                                <sec:authorize access="hasRole('DELETE_SPONSORS')">
                                    &nbsp;&nbsp;<a href="<c:url value='/scholarship/sponsor_delete.view?sponsorId=${sponsor.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                                   	    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
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
