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

<c:set var="screentitlekey">jsp.menu.resultssubjects</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

	<!-- authorizations -->
	<c:set var="showEditSubjectResults" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_SUBJECTS_RESULTS', 'UPDATE_SUBJECTS_RESULTS', 'READ_SUBJECTS_RESULTS', 'CREATE_RESULTS_ASSIGNED_SUBJECT', 'READ_RESULTS_ASSIGNED_SUBJECTS', 'UPDATE_RESULTS_ASSIGNED_SUBJECTS')">
    	<c:set var="showEditSubjectResults" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">
		<fieldset>
		<legend>
		<fmt:message key="jsp.menu.resultssubjects" />
		&nbsp;&nbsp;&nbsp;
        <c:if test="${accessContextHelp}">
             <a class="white" href="<c:url value='/help/RegistrationResults.pdf'/>" target="_blank">
                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
             </a>&nbsp;
        </c:if>
		</legend>

        <%@ include file="../../includes/institutionBranchOrganizationalUnitStudySelect.jsp"%>

        <form name="studies" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <%-- for hidden param from include --%>
            <input type="hidden" name="searchValue" value="${searchValue}" />
            
            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.study" /></td>
                    <td>
                    <select id="studyId" name="studyId" onchange="
                                            document.studygradetypes.studyGradeTypeId.value='0';
                                            document.studygradetypes.studyGradeTypeIdSelect.value='0';
                                            this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneStudy" items="${allStudies}">
                            <c:choose>
	                            <c:when test="${(studyId == oneStudy.id)  }"> 
    	                            <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                </c:when>
                                <c:otherwise>
         	                       <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                                </c:otherwise>
                            </c:choose>        
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
        </form>

        <form name="studygradetypes" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="studyId" value="${studyId}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <input type="hidden" name="studyGradeTypeIdSelect" value="${studyGradeTypeId}" />
            <input type="hidden" name="searchValue" value="${searchValue}" />

            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td>
                    <select name="studyGradeTypeId" id="studyGradeTypeId" onchange="document.studygradetypes.studyGradeTypeIdSelect.value=this.value;document.studygradetypes.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneStudyGradeType" items="${allStudyGradeTypes}">
                            <c:choose>
	                            <c:when test="${(studyGradeTypeId == oneStudyGradeType.id)}"> 
    	                            <option value="${oneStudyGradeType.id}" selected="selected">
                                    <c:set var="selectedStudyGradeType" value="${oneStudyGradeType}"/>
                                </c:when>
                                <c:otherwise>
         	                       <option value="${oneStudyGradeType.id}">
                                </c:otherwise>
                            </c:choose>    
                             
                            <c:forEach var="oneStudy" items="${allStudies}">
                                <c:choose>
    	                            <c:when test="${(oneStudyGradeType.studyId == oneStudy.id)  }">
    	                            	<c:out value="${oneStudy.studyDescription}"/>
                                    </c:when>
                                </c:choose> 
                            </c:forEach>
                            <c:forEach var="oneGradeType" items="${allGradeTypes}">
                                <c:choose>
    	                            <c:when test="${(oneStudyGradeType.gradeTypeCode == oneGradeType.code)  }">
    	                            	<c:out value="${oneGradeType.description}"/>
                                    </c:when>
                                </c:choose>          
                        	</c:forEach>
                        	<c:forEach var="oneStudyTime" items="${allStudyTimes}">
                                <c:choose>
    	                            <c:when test="${(oneStudyGradeType.studyTimeCode == oneStudyTime.code)  }">
    	                            	- <c:out value="${oneStudyTime.description}"/>
                                    </c:when>
                                </c:choose>          
                        	</c:forEach>
                        	<c:forEach var="oneAcademicYear" items="${allAcademicYears}">
                                <c:choose>
    	                            <c:when test="${(oneStudyGradeType.currentAcademicYearId == oneAcademicYear.id)  }">
    	                            	<c:out value="(${oneAcademicYear.description})"/>
                                    </c:when>
                                </c:choose>          
                        	</c:forEach>
                        	
                            </option>   
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
        </form>
        
        <form name="cardinalTimeUnitNumberForm" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="studyId" value="${studyId}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <input type="hidden" name="studyGradeTypeIdSelect" value="${studyGradeTypeId}" />
            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
            <input type="hidden" name="searchValue" value="${searchValue}" />

            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                    <td>
                    <select name="cardinalTimeUnitNumber" id="cardinalTimeUnitNumber" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="ctusgt" items="${allCardinalTimeUnitStudyGradeTypes}">
                            <c:choose>
                                <c:when test="${(cardinalTimeUnitNumber == ctusgt.cardinalTimeUnitNumber)}"> 
                                    <option value="${ctusgt.cardinalTimeUnitNumber}" selected="selected">
                                </c:when>
                                <c:otherwise>
                                   <option value="${ctusgt.cardinalTimeUnitNumber}">
                                </c:otherwise>
                            </c:choose>
                            <c:out value="${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]} ${ctusgt.cardinalTimeUnitNumber}"/>
                            </option>   
                        </c:forEach>
                    </select>
                    </td>
                    <td></td>
               </tr>
            </table>

        </form>

        <form name="searchValueForm" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="studyId" value="${studyId}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <input type="hidden" name="studyGradeTypeIdSelect" value="${studyGradeTypeId}" />
            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
            <input type="hidden" name="cardinalTimeUnitNumber" value="${cardinalTimeUnitNumber}" />

            <table>
                <tr>
                    <td width="200"></td>
                    <td>
                        <input type="text" name="searchValue" id="searchValue"  value="<c:out value="${searchValue}"/>" />&nbsp;
                        <img src="<c:url value='/images/search.gif' />" onclick="this.form.submit()" alt="<fmt:message key='jsp.general.search'/>"/>
                    </td>
                </tr>
            </table>
        </form>
        
	    </fieldset>
		<c:set var="redirView" value="subjectsresults" scope="page" />

        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${subjectCount}" scope="page" />
        <%@ include file="../../includes/pagingHeaderInterface.jsp"%>           

        <table class="tabledata" id="TblData">
          <tr> 
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.subject.assigned" /></th>
            <th><fmt:message key="jsp.general.examinations" /> / <fmt:message key="jsp.general.tests" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th></th>
          </tr>
            <c:forEach var="oneSubject" items="${allSubjects}">

                <%-- TODO get rid of studyGradeTypeIdForSubject - doesn't make sense: there can be more than one per subject.
                        Deal with this on a per student basis in subjectResults, examinationResults and testResults (every student may follow a different study!) --%>
                <c:forEach var="oneSubjectStudyGradeType" items="${oneSubject.subjectStudyGradeTypes}">
                    <c:forEach var="oneStudyGradeType" items="${allStudyGradeTypes}">
                        <c:if test="${oneSubjectStudyGradeType.studyGradeTypeId == oneStudyGradeType.id}">
                            <c:set var="studyGradeTypeIdForSubject" value="${oneStudyGradeType.id}" scope="page" />
                        </c:if>
                    </c:forEach>
                </c:forEach>

                <tr>
                    <td><c:out value="${oneSubject.subjectCode}"/></td>
                    <td width="150">
                        <c:choose>
                            <c:when test="${(showEditSubjectResults)}">
                                <a href="<c:url value='/college/subjectresults.view'/>?<c:out value='newForm=true&studyId=${studyId}&studyGradeTypeId=${studyGradeTypeIdForSubject}&subjectId=${oneSubject.id}&currentPageNumber=${currentPageNumber}&tab=0&panel=0'/>">
                                    <c:out value="${oneSubject.subjectDescription}"/>
                                </a>
                         	</c:when>
                         	<c:otherwise>
                                <c:out value="${oneSubject.subjectDescription}"/>
                         	</c:otherwise>
                        </c:choose>
                        <c:forEach var="academicYear" items="${allAcademicYears}">
                                <c:choose>
                                    <c:when test="${academicYear.id == oneSubject.currentAcademicYearId}">
                                        <c:out value="(${academicYear.description})"/>
                                    </c:when>
                                </c:choose>
                        </c:forEach>
                    </td>
                    <td width="150">
                        <c:forEach var="study" items="${allStudies}">
                            <c:choose>
                                <c:when test="${study.id == oneSubject.primaryStudyId}">
                                    <c:out value="${study.studyDescription}"/>
                                </c:when>
                            </c:choose>
                         </c:forEach>
                    </td>
                    <td width="50">
                        <c:choose>
                            <c:when test="${(not empty oneSubject.subjectStudyGradeTypes) || (not empty oneSubject.subjectSubjectBlocks)}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                        </c:choose>
                   </td>
                <td width="300">
                    <c:choose>
                        <c:when test="${(
                        	oneSubject.examinations != null &&
                   				showEditSubjectResults
                   			) }">
                        	<c:forEach var="examination" items="${oneSubject.examinations}">
                                <a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&tab=0&panel=0&studyGradeTypeId=${studyGradeTypeIdForSubject}&subjectId=${oneSubject.id}&examinationId=${examination.id}&chosenAcademicYearId=${oneSubject.currentAcademicYearId}&chosenCardinalTimeUnitNumber=${cardinalTimeUnitNumber}&currentPageNumber=${currentPageNumber}'/>">
                            		<c:out value="${examination.examinationDescription}"/>
                        		</a>
                                <c:forEach var="test" items="${examination.tests}">
                                    <br />&nbsp;&nbsp;&nbsp;>&nbsp;
                                    <a href="<c:url value='/college/testresults.view'/>?<c:out value='newForm=true&tab=0&panel=0&studyGradeTypeId=${studyGradeTypeIdForSubject}&subjectId=${oneSubject.id}&examinationId=${examination.id}&testId=${test.id}&chosenAcademicYearId=${oneSubject.currentAcademicYearId}&chosenCardinalTimeUnitNumber=${cardinalTimeUnitNumber}&currentPageNumber=${currentPageNumber}'/>">
                                        <c:out value="${test.testDescription}"/>
                                    </a>
                        		</c:forEach>
                        		<br/>
                   			</c:forEach>
               			</c:when>
               		</c:choose>
                   </td >
                    <td width="50">${oneSubject.active}</td>
                    <td class="buttonsCell">
                        <c:if test="${showEditSubjectResults}">
                            <a href="<c:url value='/college/subjectresults.view'/>?<c:out value='newForm=true&studyId=${studyId}&studyGradeTypeId=${studyGradeTypeId}&subjectId=${oneSubject.id}&studyGradeTypeId=${studyGradeTypeIdForSubject}&currentPageNumber=${currentPageNumber}&tab=0&panel=0'/>"><img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                        </c:if>
                    </td>
                </tr>
                <c:set var="studyGradeTypeIdForSubject" value="0" scope="page" />
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>
		
		<c:set var="params" value="${pagingParams}" scope="page" />
       <%@ include file="../../includes/pagingFooter.jsp"%>
		
        <br /><br />
    </div>
    
</div>

<%@ include file="../../footer.jsp"%>
