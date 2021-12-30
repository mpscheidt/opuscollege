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
<%@ include file="../../includes/javascriptfunctions.jsp"%>

<script type="text/javascript">
    
    function validateOperationForm(){
        newStatus = document.getElementById("newStatusCode").value;
        if(newStatus == "0"){
        
            alert('<fmt:message key="invalid.status.format"/>');
            return false;
        }
        
                
        return anySelected('studentId' , '<fmt:message key="jsp.alert.nostudentselected"/>'); 

    }
</script>


<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.students.header.studentsselection" />
        </legend>
        
        
                 <form action="<c:url value='${action}'/>" method="post"> 
                     <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                   <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> --> 
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="loadStudents" value="true" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                                     
              <br />
            <span class="maintext"> <fmt:message key="jsp.general.surname" />
            <input name="searchValue" size="20" maxlength="20" type="text" value="<c:out value="${searchValue}" />">
            &nbsp;
            <input value="<fmt:message key='jsp.general.search' />" type="submit"></span> <br>
            </form>
            <p>&nbsp;</p>
            
                        <%@ include file="../../includes/studentsStatusesFiltersTable.jsp"%>
                        <p>&nbsp;</p>
                        <form name="showStudentsForm" id="showStudentsForm" action="<c:url value='${action}'/>" method="post" target="_self">
                            <input type="hidden" name="institutionId" value="${institutionId}" />
                            <input type="hidden" name="branchId" value="${branchId}" />
                            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                           <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> -->
                            <input type="hidden" name="academicYearId" value="${academicYearId}" />
                            <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                            <input type="hidden" name="orderBy" value="${orderBy}" />
                            <input type="hidden" name="loadStudents" value="true" />
                            <input type="hidden" name="searchValue" value="${searchValue}" />&nbsp;
                            <input type="submit" value="<fmt:message key="jsp.button.showstudents" />" />
                        </form>              
        </fieldset>
        
        <br />       
                <b><fmt:message key="jsp.students.assignstatuses" />:</b><br><br>
                       
        
               
        
        <c:set var="allEntities" value="${allStudents}" scope="page" />

        <form name="operationForm" id="operationForm" action="<c:url value='${action}'/>" method="post" target="_self" onsubmit="return validateOperationForm()">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                    <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" />  -->
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />
                    <input type="hidden" name="operation" value="assignstatuses" />
                    
                    <fmt:message key="jsp.general.statuscode" />: 
                                   
                        <select name="newStatusCode" id="newStatusCode">
                              <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="oneStatus" items="${allStudentStatuses}">
                                           <c:choose>
                                            <c:when test="${oneStatus.code != studentStatusCode}">
                                                            <option value="${oneStatus.code}">${oneStatus.description}</option>
                                               </c:when>
                                               </c:choose>
                                      </c:forEach>
                       </select>
                       
                        <br />&nbsp;
                        <br />
                        <br />&nbsp;
                    <input type="submit" value="<fmt:message key="jsp.button.submit"/>" />
                        
                        <br />&nbsp;
                        <br />&nbsp;
                        <br />&nbsp;
                        
        
         <a href="#bottom" id="top"><fmt:message key="jsp.href.gotobottom" /></a>
        
        <div id="abc">&nbsp;</div>
        
        <table class="tabledata" id="TblData">
           
            <th>
               <label for="checker"><fmt:message key="jsp.general.selectall" /></label>
                <input  
                       id="checker" 
                       checked="checked" 
                       onclick="javascript:checkAll('studentId');" 
                       type="checkbox">
            </th>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.studyplans.broken" /></th>
            <th><fmt:message key="jsp.general.status" /></th>

            <c:forEach var="student" items="${allStudents}">
                    <tr>
                        <td>
                            <input  type="checkbox" name="studentId" checked="checked" value="${student.studentId}" />
                        </td>
                        <td>${student.studentCode}</td>
                        <td>${student.firstnamesFull}</td>
                        <td>
                            <c:choose>
                                <c:when test="${opusUser.personId == student.personId
                                 || (opusUserRole.role != 'student' 
                                 && opusUserRole.role != 'guest'
                                 && opusUserRole.role != 'staff')
                                }">
                                    <a href="<c:url value='/college/student/subscription.view?tab=0&panel=0&from=students&studentId=${student.studentId}'/>">
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
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

        <br />
        <fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.students" />: ${fn:length(allStudents)}&nbsp;
    <br />
    <a href="#top" id="bottom"><fmt:message key="jsp.href.gototop"/></a>
                  
             </form>
             <br />
             
             
    </div>

</div>

<%@ include file="../../footer.jsp"%>
