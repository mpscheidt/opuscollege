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
<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
 @author Stelio Macumbe - 1 of June  2008
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>
<div id="tabwrapper">

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('CREATE_SCHOLARSHIPS')">
        <c:set var="addScholarships" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('UPDATE_SCHOLARSHIPS')">
        <c:set var="editScholarships" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('DELETE_SCHOLARSHIPS')">
        <c:set var="deleteScholarships" value="${true}"/>
    </sec:authorize>

    <%@ include file="../../menu.jsp"%>
    
    <div id="tabcontent">
	
	<fieldset>
        <legend>
        <fmt:message key="jsp.general.scholarships" />
        &nbsp;&nbsp;&nbsp;
        <c:if test="${accessContextHelp}">
                 <a class="white" href="<c:url value='/help/DefiningScholarships.pdf'/>" target="_blank">
                    <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                 </a>&nbsp;
            </c:if>
        </legend>
        
        <p align="left">
        <table>
        <tr>
        <td>
            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>
        </td>
        <td>
		<table id="scholarshipFilters">
             <form name="academicyears" method="POST" action="<c:url value='${action}'/>">
                <input type="hidden" name="tab" value="0" /> 
                <input type="hidden" name="panel" value="0" />
               <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" id="organizationalunitId" name="organizationalunitId" value="${organizationalunitId }" />  
                <input type="hidden" name="sponsorId" value="${sponsorId}" />
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

                <tr>
                <td><fmt:message key="jsp.general.academicyear" /></td>
                <td>
                
                    <select name="selectedAcademicYearId" id="selectedAcademicYearId" onchange="document.academicyears.submit();">
                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneAcademicYear" items="${allAcademicYears}">
                             <c:choose>
                                 <c:when test="${selectedAcademicYearId == oneAcademicYear.id}">
                                     <option value="${oneAcademicYear.id}" selected="selected">${oneAcademicYear.description}</option> 
                                 </c:when>
                                 <c:otherwise>
                                     <option value="${oneAcademicYear.id}">${oneAcademicYear.description}</option> 
                                 </c:otherwise>
                             </c:choose>
                        </c:forEach>
                    </select>
                </td>
                </tr>
            </form>
            <form name="sponsors" method="POST" action="<c:url value='${action}'/>">    
                <input type="hidden" name="institutionId" value="${institutionId}" />
	            <input type="hidden" name="branchId" value="${branchId}" />
	            <input type="hidden" id="organizationalunitId" name="organizationalunitId" value="${organizationalunitId }" />
	            <input type="hidden" name="selectedAcademicYearId" value="${selectedAcademicYearId}" />    
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <tr>
	            <td><fmt:message key="scholarship.sponsor" />
                </td>      
				<td>				
				    
				    <select id="sponsorId" name="sponsorId" onchange="document.sponsors.submit()">
				        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
				        <c:forEach var="oneSponsor" items="${allSponsors}">
				            <c:choose>
				                <c:when test="${ sponsorId == oneSponsor.id }"> 
                                    <option value="${oneSponsor.id}" selected="selected">${oneSponsor.name}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneSponsor.id}">${oneSponsor.name}</option>
                                </c:otherwise>
                            </c:choose>
				        </c:forEach>
			       	</select>
		    	</td>
		     </tr>
		     </form>
		     <!-- tr>
		     <td>
                  <label for="sch.academicYear">
                      <fmt:message key="jsp.general.academicyear" />
                  </label>
                   <select id="sch.academicYear" name="academicYear">
                       <option><fmt:message key="scholarship.select.all"/>
                        <option>2007/2008
                        <option>2008/2009
                        <option>2009/2010
                    </select>
                 </td>
                 </tr >
		      <tr>
		      <td><fmt:message key="jsp.general.orderby" />
                </td> 
		        <td>
		          
		             <select id="orderBy" name="orderBy">
		                <option value=""><fmt:message key="scholarship.scholarshiptype" />
		                <option value=""><fmt:message key="scholarship.sponsor" />
		                <option value=""><fmt:message key="jsp.general.academicyear" />
		                <option value=""><fmt:message key="jsp.general.amount" />
		                <option value=""><fmt:message key="jsp.general.housing" />
		             </select>
		        </td>
		      </tr -->
		                                 
		    </table>
</td></tr></table>		    
		    </p>
            <c:choose>
                <c:when test="${(not empty showError)}">             
                <p align="left" class="error">
                    <fmt:message key="jsp.error.scholarship.delete" />
               </c:when>
            </c:choose>
                            
    </fieldset>

        <c:set var="allEntities" value="${allScholarships}" scope="page" />
        <c:set var="redirView" value="scholarships" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
                        
                        <%@ include file="../../includes/pagingHeader.jsp"%>

                        <table  class="tabledata" id="TblData" cellspacing="5">
                        <tr>
                                <th><fmt:message key="jsp.general.description" /></th> 
                                <th><fmt:message key="scholarship.scholarshiptype" /></th> 
                                <th><fmt:message key="scholarship.sponsor" /></th>
                                <th><fmt:message key="jsp.general.academicyear" /></th>
                                <th><fmt:message key="jsp.general.active" /></th>
                                <th><fmt:message key="scholarship.applied" /> / <fmt:message key="scholarship.granted" /></th>
                                <c:if test="${addScholarships }" >
                                <th>
                                    <a class="button" href="<c:url value='/scholarship/scholarship.view?newForm=true&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>  
                                </th>
                                </c:if>
                            </tr>
            <c:forEach var="scholarshipMap" items="${allScholarships}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <!-- --------------- -->
                    <tr>
                    <td>
                        <c:choose>
                            <c:when test="${editScholarships }" >
                                <c:set var="urlParams" value="scholarshipId=${scholarshipMap.scholarship.id}" />
                                <a href="<c:url value='/scholarship/scholarship.view?newForm=true&${urlParams }'/>">
                                    ${scholarshipMap.scholarship.description}
                                </a>
                            </c:when>
                            <c:otherwise >
                                ${scholarshipMap.scholarship.description}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                    	${scholarshipMap.scholarship.scholarshipType.description }
                    </td>
                    <td>
                    ${scholarshipMap.scholarship.sponsor.name }
                    </td>
                    <td>
                    ${idToAcademicYearMap[scholarshipMap.scholarship.sponsor.academicYearId].description }
                    </td>
                    <td>${scholarshipMap.scholarship.active}</td>
                    <td>${scholarshipMap.countApplied } / ${scholarshipMap.countGranted }
                    &nbsp;&nbsp;&nbsp;<a href="<c:url value='/scholarship/scholarshipapplications.view?${urlParams }'/>"><img src="<c:url value='/images/group.gif' />" alt="<fmt:message key='jsp.scholarshipapplication.gotooverview' />" title="<fmt:message key='jsp.scholarshipapplication.gotooverview' />" /></a>
                    <%--c:forEach var="grantedScholarship" items="${allGrantedScholarships}">
                        <c:choose>
                            <c:when test="${grantedScholarship.id == scholarship.id }">
                                <td>${grantedScholarship.counted }</td>
                                </c:when>
                                </c:choose>
                                </c:forEach --%>
                                </td>
                    <td class="buttonsCell">
                    	<c:if test="${editScholarships }" >
	                    <a href="<c:url value='/scholarship/scholarship.view?newForm=true&${urlParams }'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
	                    &nbsp;&nbsp;
	                    </c:if>
	                    <c:if test="${deleteScholarships }" >
	                    <a href="<c:url value='/scholarship/scholarship_delete.view?${urlParams }'/>"
	                    onclick="return confirm('<fmt:message key="scholarship.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
	                    </c:if>
                    </td>
                    </tr>
                    <!-- ---------------------- -->
                    </c:when>
                </c:choose>
            </c:forEach>
           </table>
            <script type="text/javascript">alternate('TblData',true)</script>

            <%@ include file="../../includes/pagingFooter.jsp"%>
         
    
                        
    
        <br /><br />
       
        </div><!-- End of tabcontent-->        
    </div><!-- tabwrapper -->
<%@ include file="../../footer.jsp"%>
