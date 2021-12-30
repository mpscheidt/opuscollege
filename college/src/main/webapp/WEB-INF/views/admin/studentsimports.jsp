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

<%@ include file="../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />
<body>
<%@ include file="../includes/javascriptfunctions.jsp"%>
<script type="text/javascript">
jQuery(function() {
    
    jQuery.ajaxSetup({

        async: false,
        timeout: 30000,      
        beforeSend:function(req) {
            //alert('GLOBAL:beforeSend')
        },
  
        complete:function(req) {
         //alert('GLOBAL:complete');
        }
  
  
    })


  //  new AjaxUpload('upload_button_id', {action: '/colle/imports'});
});
    
</script>
<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.students.header.studentsselection" />
        </legend>
                        <p>&nbsp;</p>
                      <form name="fileForm"  ENCTYPE='multipart/form-data' method="post">
                           <input type="hidden" name="operation" value="getfile" />
                          <input type="file" name="file"/>
                          
                          <br />
                            <input type="submit" id="operation_button" value="<fmt:message key='jsp.button.submit' />"/>
                          
                        </form>              

        </fieldset>
        
       
                <br />
                   
                <%-- Only show the students table and the import form if there is any student to show--%>
                
                  <c:choose>                 
                    <c:when test="${(not empty showStudents) && (not empty importStudents)}">
                    <h3> <fmt:message key="jspm.import.select.students" /></h3>
                
                <input type="submit" id="operation_button" value="<fmt:message key='jsp.button.import' />"/>            
                            <c:set var="allEntities" value="${importStudents}" scope="page" />
        <c:set var="redirView" value="students" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>

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
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.studyplans.broken" /></th>
            <th><fmt:message key="jsp.general.active" /></th>

            <c:forEach var="student" items="${importStudents}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <tr>
                          <td>
                            <input  type="checkbox" name="studentId" checked="checked" value="${student.studentId}" />
                        </td>
                        <td>${student.studentCode}</td>
                        <td>${student.firstnamesFull}</td>
                        <td>
                                    ${student.surnameFull}
                        </td>
                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${student.birthdate}" /></td>
                        <td>
                            <c:forEach var="study" items="${allStudies}">
                                <c:choose>
                                    <c:when test="${study.id == student.primaryStudyId}">
                                        ${study.studyDescription}
                                    </c:when>
                                </c:choose>
                             </c:forEach>
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
                            <c:choose>
                                <c:when test="${student.active == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooter.jsp"%>
    
        <br /><br />
                            
                            
                    </c:when>                 
                </c:choose>    
        
                <%-- Only show the students table and the import form if there is any student to show--%>
                
                  <c:choose>                 
                    <c:when test="${not empty errorStudents}">
                
                    <h3> <fmt:message key="jsp.import.problems" /></h3>

                            <c:set var="allEntities" value="${errorStudents}" scope="page" />
        <c:set var="redirView" value="students" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblDataError">
            
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.remarks" /></th>

            <c:forEach var="student" items="${errorStudents}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <tr>
                          
                        <td>${student.studentCode}</td>
                        <td>${student.firstnamesFull}</td>
                        <td>
                                    ${student.surnameFull}
                        </td>
                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${student.birthdate}" /></td>
                        <td>
                            <c:forEach var="study" items="${allStudies}">
                                <c:choose>
                                    <c:when test="${study.id == student.primaryStudyId}">
                                        ${study.studyDescription}
                                    </c:when>
                                </c:choose>
                             </c:forEach>
                        </td>
                        <td><b>${student.remarks} &nbsp;</b></td>
                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblDataError',true)</script>

        <%@ include file="../includes/pagingFooter.jsp"%>
    
        <br /><br />
                            
                            
                    </c:when>                 
                </c:choose>    
        
             
             
    </div><!-- tabcontent -->

</div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>
