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

<c:choose>
    <c:when test="${operation == 'removestudents'}">
        <body
            onload="document.getElementById('operation_remove').checked = true;
                    document.getElementById('academicYearId2').disabled = 'disabled';
                    document.getElementById('primaryStudyId2').disabled = 'disabled';
                    document.getElementById('studyGradeTypeId2').disabled = 'disabled';
                    document.getElementById('studyYearId2').disabled = 'disabled';
                    document.getElementById('operationEl').value = 'removestudents';
                    document.getElementById('operation_button').value = '<fmt:message key="jsp.button.removestudents" />';
                    ">
    </c:when>
    <c:otherwise>
        <body 
            onload="document.getElementById('operation_assign').checked = true;
                    document.getElementById('academicYearId2').disabled = null;
                    document.getElementById('primaryStudyId2').disabled = null;
                    document.getElementById('studyGradeTypeId2').disabled = null;
                    document.getElementById('studyYearId2').disabled = null;
                    document.getElementById('operationEl').value = 'assignstudents';
                    document.getElementById('operation_button').value = '<fmt:message key="jsp.button.assignstudents" />';
                    ">
    </c:otherwise>
</c:choose>

<%@ include file="../../includes/javascriptfunctions.jsp"%>
<script type="text/javascript">
    
    function validateSecondaryValuesForm(){
    
        form = document.getElementById('secondaryValuesForm');
        assignOp = document.getElementById('operation_assign');
        studyId = parseInt(form.primaryStudyId2.value);
        studyGradeTypeId = parseInt(form.studyGradeTypeId2.value);
        studyYearId = parseInt(form.studyYearId2.value);
        academicYearId = form.academicYearId2.value;
        
        if(assignOp.checked){
        if(studyId == 0){
            alert('<fmt:message key="invalid.study.format" />');
            return false;
        }
        
        if(studyGradeTypeId == 0){
            alert('<fmt:message key="invalid.studygradetype.format" />');
            return false;
        }
        
        if(studyYearId == 0){
            alert('<fmt:message key="invalid.studyyear.format" />');
            return false;
        }
      
        if(academicYearId == '0'){
            alert('<fmt:message key="invalid.academicyear.format" />');
            return false;
        }
        }
        
        if(!anySelected('studentId' , '<fmt:message key="jsp.alert.nostudentselected"/>')){
            return false;
        }
        document.getElementById('operationForm').submit();
        
        return true;    
    }
    
</script>
<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.students.header.studentsselection" />
        </legend>
                        <%@ include file="../../includes/institutionBranchOrganizationalUnitStudyYearSelectDetail2.jsp"%>
                        <p>&nbsp;</p>
                        <form name="searchForm" id="searchForm" action="<c:url value='${action}'/>" method="post" target="_self">
                            <input type="hidden" name="institutionId" value="${institutionId}" />
                            <input type="hidden" name="branchId" value="${branchId}" />
                            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                            <input type="hidden" name="studyYearId" value="${studyYearId}" />
                            <input type="hidden" name="academicYearId" value="${academicYearId}" />
                            <input type="hidden" name="loadStudents" value="true" />
                            <input type="hidden" name="searchValue" value="${searchValue}" />
                            <input type="submit" value="<fmt:message key="jsp.button.showstudents" />" />
                        </form>              
        </fieldset>
        
        <br />       
                <b><fmt:message key="jsp.students.assigntostudyyear" />:</b><br><br>
             
             
             
                        <input type="radio" name="operation"  id="operation_assign" value="assignstudents" checked="checked"
                    onclick="document.getElementById('academicYearId2').disabled = null;
                             document.getElementById('primaryStudyId2').disabled = null;
                             document.getElementById('studyGradeTypeId2').disabled = null;
                             document.getElementById('studyYearId2').disabled = null;
                             document.getElementById('operationEl').value = 'assignstudents';
                             document.getElementById('operation_button').value = '<fmt:message key="jsp.button.assignstudents" />';
                             "/>
                        <label for="operation_assign">
                        <fmt:message key="jsp.selectoption.assignstudents" />
                        </label>
                        <br/>
                
                        <input type="radio" name="operation"  id="operation_remove" value="removestudents" checked="checked"
                    onclick="document.getElementById('academicYearId2').disabled = 'disabled';
                             document.getElementById('primaryStudyId2').disabled = 'disabled';
                             document.getElementById('studyGradeTypeId2').disabled = 'disabled';
                             document.getElementById('studyYearId2').disabled = 'disabled';
                             document.getElementById('operationEl').value = 'removestudents';
                             document.getElementById('operation_button').value = '<fmt:message key="jsp.button.removestudents" />';
                             "/>  
                        <label for="operation_remove">
                        <fmt:message key="jsp.selectoption.removestudents" />
                        </label>
        <br />&nbsp;
        
        <form name="secondaryValuesForm" id="secondaryValuesForm" action="<c:url value='${action}'/>" method="post" target="_self">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                    <input type="hidden" name="studyYearId" value="${studyYearId}" />
                    <input type="hidden" name="loadStudents" value="loadStudents" />                    
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    
                <select id="primaryStudyId2" name="primaryStudyId2" style="width:150px;" onchange="this.form.submit();">
                <option value="0"><fmt:message key="jsp.general.selectstudy" /></option>
                    <c:forEach var="oneStudy" items="${dropDownListStudies}">
                                <c:choose>
                                <c:when test="${(primaryStudyId2 != null && primaryStudyId2 != 0) }"> 
                                    <c:choose>
                                        <c:when test="${oneStudy.id == primaryStudyId2}"> 
                                            <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                               </c:otherwise>
                               </c:choose>
                            </c:forEach>
                </select>

                <select id="studyGradeTypeId2" name="studyGradeTypeId2" style="width:160px;" onchange="this.form.submit();">
                    <option value="0"><fmt:message key="jsp.general.selectstudygrade" /></option>
                    <c:forEach var="studyGradeType" items="${allStudyGradeTypes2}">
                           <c:choose>
                               <c:when test="${(studyGradeTypeId2 != null && studyGradeTypeId2 != 0 
                                    && studyGradeType.id == studyGradeTypeId2) }"> 
                                    <option value="${studyGradeType.id}" selected="selected">
                                </c:when>
                                <c:otherwise>
                                    <option value="${studyGradeType.id}">
                                </c:otherwise>
                           </c:choose>
                           <c:forEach var="study" items="${dropDownListStudies}">
                                <c:choose>
                                    <c:when test="${study.id == studyGradeType.studyId}" >
                                        ${study.studyDescription}
                                    </c:when>
                                </c:choose>
                           </c:forEach>
                           <c:forEach var="gradeType" items="${allGradeTypes}">
                                <c:choose>
                                    <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}" >
                                        - ${gradeType.description}</option>
                                    </c:when>
                                </c:choose>
                           </c:forEach>
                        </c:forEach>
                </select>

                <select name="studyYearId2" id="studyYearId2" style="width:150px;" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.general.selectstudyyear" /></option>
                        <c:forEach var="studyYear" items="${allStudyYears2}">
                        <c:choose>
                        <c:when test="${studyYearId != studyYear.id}">
                            <c:choose>
                            <c:when test="${(studyGradeTypeId2 == null) }"> 
                                <c:choose>
                                    <c:when test="${(studyYearId2 != null && studyYearId2 != 0 
                                        && studyYear.id == studyYearId2) }"> 
                                        <option value="${studyYear.id}" selected="selected">${studyYear.yearNumberVariation} - ${studyYear.yearNumber}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${studyYear.id}">${studyYear.yearNumberVariation} - ${studyYear.yearNumber}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${(studyGradeTypeId2 == studyYear.studyGradeTypeId) }"> 
                                        <c:choose>
                                            <c:when test="${(studyYearId2 != null && studyYearId2 != 0 
                                                    && studyYear.id == studyYearId2) }"> 
                                                <option value="${studyYear.id}" selected="selected">${studyYear.yearNumberVariation} - ${studyYear.yearNumber}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${studyYear.id}">${studyYear.yearNumberVariation} - ${studyYear.yearNumber}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                           </c:otherwise>
                           </c:choose>
                           </c:when>
                           </c:choose>
                        </c:forEach>
                    </select>
                

                <select name="academicYearId2" id="academicYearId2" style="width:130px;" onchange="this.form.submit();">
                    <option value="0"><fmt:message key="jsp.general.selectacademicyear" /></option>
                      <c:forEach var="year" items="${allAcademicYears}">                          
                        <c:choose>
                          <c:when test="${year.id == academicYearId2}">
                             <option value="${academicYear.id}" selected="selected">${academicYear.description}</option>
                           </c:when>
                         <c:otherwise>
                            <option value="${academicYear.id}">${academicYear.description}</option>                            
                          </c:otherwise>
                        </c:choose>
                     </c:forEach>
                </select>
                </form>
                <br />
                <input type="submit" id="operation_button" value="<fmt:message key='jsp.button.assignstudents' />"
                onclick="validateSecondaryValuesForm()"
                />
                <br />&nbsp;
                <br />&nbsp;
                <br />
        <br />&nbsp;
        
        <c:set var="allEntities" value="${allStudents}" scope="page" />

        <a href="#bottom" id="top"><fmt:message key="jsp.href.gotobottom" /></a>
        <div id="abc">&nbsp;</div>
        
        
        
        <form name="operationForm" id="operationForm" action="<c:url value='${action}'/>" method="get" target="_self">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                    <input type="hidden" name="studyYearId" value="${studyYearId}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="primaryStudyId2" value="${primaryStudyId2}" />
                    <input type="hidden" name="studyGradeTypeId2" value="${studyGradeTypeId2}" />
                    <input type="hidden" name="studyYearId2" value="${studyYearId2}" />
                    <input type="hidden" name="academicYearId2" value="${academicYearId2}" />                    
                    <input type="hidden" name="searchValue" value="${searchValue}" />
                    <input type="hidden" name="operation" id="operationEl" value="assignstudents" />
        
        <table class="tabledata" id="TblData">
           
            <th>
               <label for="checker"><fmt:message key="jsp.general.selectall" /></label>
                <input name="checker" 
                       id="checker" 
                       checked="checked" 
                       onclick="javascript:checkAll('studentId');" 
                       type="checkbox">
            </th>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.studyplans.broken" /></th>

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
                                    <a href="<c:url value='/college/student/personal.view?tab=0&panel=0&from=students&studentId=${student.studentId}'/>">
                                    ${student.surnameFull}</a>
                                </c:when>
                                <c:otherwise>
                                    ${student.surnameFull}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${student.birthdate}" /></td>
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
