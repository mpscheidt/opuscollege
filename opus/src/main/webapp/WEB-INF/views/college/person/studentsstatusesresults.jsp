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

<%--
 * Copyright (c) 2009 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
          <a href="<c:url value='/college/studentsstatuses.view'/>">
    <fmt:message key="jsp.students.header.studentsselection" /> </a> &nbsp; &nbsp; > &nbsp; &nbsp;  <fmt:message key="jsp.students.header.results" />
        </legend>
        </fieldset>
        
        
         <c:choose>
            <c:when test="${not empty errorStudents}">
                <%@ include file="../../includes/errorStudents.jsp"%>
            </c:when>
        </c:choose>
        
        <c:set var="allEntities" value="${students}" scope="page" />
        <c:set var="redirView" value="students" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <form name="reportForm" id="reportForm" action="<c:url value='/college/reports.view'/>" method="post" target="_self">
                    <input type="hidden" name="reportName" value="StudentsStatuses" />
                    <input type="hidden" name="reportFormat" value="pdf" />
        


        <%@ include file="../../includes/pagingHeader.jsp"%>
        
        <table class="tabledata" id="TblData">
            
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.studyplans.broken" /></th>
            <th><fmt:message key="jsp.general.status" /></th>

            <c:forEach var="student" items="${students}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <tr>
                        <td>${student.studentCode}</td>
                        <td>${student.firstnamesFull}</td>
                        <td>
                            <c:choose>
                                <c:when test="${opusUser.personId == student.personId
                                 || (opusUserRole.role != 'student' 
                                 && opusUserRole.role != 'guest'
                                 && opusUserRole.role != 'staff')
                                }">
                                    <a href="<c:url value='/college/student/subscription.view?tab=0&panel=0&from=students&studentId=${student.studentId}&searchValue=${searchValue}&currentPageNumber=${currentPageNumber}'/>">
                                    ${student.surnameFull}</a>
                                </c:when>
                                <c:otherwise>
                                    ${student.surnameFull}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty student.studyPlans}">
                                    <fmt:message key="jsp.general.no" />
                                 </c:when>
                                  <c:otherwise>
                                  
                                    <c:choose>
                                    
                                        <c:when test="${fn:length(student.studyPlans) > 1}">
                                           <select>
                                            <c:forEach items="${student.studyPlans}" var="studyPlan">
                                            
                                            <c:choose>
                                                <c:when test="${studyPlan.studyGradeTypeId == studyGradeTypeId}">
                                                    <option selected="selected">${studyPlan.studyPlanDescription}</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option>${studyPlan.studyPlanDescription}</option>
                                                </c:otherwise>
                                            </c:choose>                              
                                            </c:forEach>
                                            </select>                                        
                                        </c:when>
                                        
                                        <c:otherwise>
                                            ${student.studyPlans[0].studyPlanDescription}
                                        </c:otherwise>
                                        
                                    </c:choose>
                                    
                                 </c:otherwise>
                           </c:choose>

                       </td>
                       
                       <td>
                           <c:forEach var="oneStatus" items="${allStudentStatuses}">
                                <c:choose>
                                    <c:when test="${oneStatus.code == student.statusCode}">
                                        ${oneStatus.description}
                                     </c:when>
                               </c:choose>
                           </c:forEach>
                        &nbsp;
                        </td>
                       
                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

       <fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.students" />: ${fn:length(students)}&nbsp;
    
        <br /><br />
        <input type="submit" value="<fmt:message key='jsp.button.pdfreport' />" />
    </form>   
        
    </div>

</div>

<%@ include file="../../footer.jsp"%>
