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
<table class="tabledata2" id="TblData_scholarshipapplications">

     <tr>
          <th colspan=7 align="right">
              <a class="button" href="<c:url value='/scholarship/scholarshipapplication.view?newForm=true&tab=1&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
          </th>
      </tr>

      <tr>
            <th><fmt:message key="scholarship.appliedfor" /></th>
            <th><fmt:message key="scholarship.granted" /></th>
            <c:if test="${appUseOfScholarshipDecisionCriteria == 'Y'}">
                <th><fmt:message key="jsp.general.scholarship.decisioncriteria" /></th>
            </c:if>
            <th><fmt:message key="jsp.general.observation" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th><fmt:message key="jsp.general.complaints" /></th>
            <th><fmt:message key="jsp.general.studyplan" /> - <fmt:message key="jsp.general.timeunit" /></th>            
            <th></th>
        </tr> 

		<spring:bind path="command.scholarships">
		<c:forEach var="scholarshipApplication" items="${status.value}">
 		    <tr>
                <td>
                  <!-- The scholarship and type of scholarship the student applied for -->        
                    <c:forEach var="scholarship" items="${allScholarships}">
                        <c:choose>
                           <c:when test="${scholarship.id == scholarshipApplication.scholarshipAppliedForId}">
                               <c:forEach var="scholarshipType" items="${allScholarshipTypes}">
                                   <c:choose>
                                       <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                           ${scholarshipType.description} - 
                                              <c:forEach var="academicYear" items="${allAcademicYears}">
                                                   <c:choose>
                                                       <c:when test="${scholarship.sponsor.academicYearId == academicYear.id}">
                                                           ${academicYear.description}
                                                        </c:when>
                                                   </c:choose>
                                               </c:forEach>                                             
                                       </c:when>
                                   </c:choose>
                               </c:forEach>
                           </c:when>
                        </c:choose>
                    </c:forEach>
                </td>
       
                <td>
                <!-- What scholarship is granted to the student (can be different than the one applied for -->
                <c:forEach var="scholarship" items="${allScholarships}">
                       <c:choose>
                           <c:when test="${scholarship.id == scholarshipApplication.scholarshipGrantedId}">
                               <c:forEach var="scholarshipType" items="${allScholarshipTypes}">
                                   <c:choose>
                                       <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                           ${scholarshipType.description}
                                             <c:forEach var="academicYear" items="${allAcademicYears}">
                                                   <c:choose>
                                                       <c:when test="${scholarship.sponsor.academicYearId == academicYear.id}">
                                                           ${academicYear.description}
                                                        </c:when>
                                                   </c:choose>
                                             </c:forEach>                                              
                                       </c:when>
                                   </c:choose>
                               </c:forEach>
                           </c:when>
                        </c:choose>
                    </c:forEach>
                </td>
                <c:if test="${appUseOfScholarshipDecisionCriteria == 'Y'}">
	                <td>
	                    <!-- Criteria for rejection or acceptance of the scholarship  -->
	                <c:forEach var="decisionCriterium" items="${allDecisionCriteria}">
	                        <c:choose>
	                           <c:when test="${decisionCriterium.code == scholarshipApplication.decisionCriteriaCode}">
	                               ${decisionCriterium.description}
	                           </c:when>
	                        </c:choose>
	                    </c:forEach>
	                </td>
                </c:if>
                <td>
                    <!--Observations about the scholarships  -->
                    <c:set var="observationLink" value="/${initParam.iAppname}/scholarship/observation.view?scholarshipApplicationId=${scholarshipApplication.id}&currentPageNumber=${currentPageNumber}" scope="page" />
                    <a href="#" onclick="openObservationWindow('${observationLink}');" title="${scholarshipApplication.observation}">
                        ${fn:substring(scholarshipApplication.observation,0,initParam.iTitleLength)} ... 
                    </a>
                </td>       

                <!-- Active flag -->
                <td>
                    <fmt:message key="${stringToYesNoMap[scholarshipApplication.active]}"/>
                </td>

                <td>
                    <!--  possible list of complaints -->
                    <c:choose>
                        <c:when test="${scholarshipApplication.complaints[0] != null}" >
                            <c:set var="complaintsString" value="${complaintsHeader}\n" scope="page" />
                            <c:forEach var="complaint" items="${scholarshipApplication.complaints}">
                                <fmt:formatDate var="cpltDate" value="${complaint.complaintDate}" pattern="yyyy-MM-dd"/>
                                <c:set var="complaintsString" value="${complaintsString}\n${cpltDate}" scope="page" />
                                <c:set var="complaintsString" value="${complaintsString}\t${complaint.reason}" scope="page" />
                                <c:set var="complaintsString" value="${complaintsString}\t${complaint.result}" scope="page" />
                                <c:set var="complaintsString" value="${complaintsString}\t${complaint.complaintStatusCode}" scope="page" />
                                <c:set var="complaintsString" value="${complaintsString}\t${complaint.active}" scope="page" />
                            </c:forEach>
                            <a href="#" onclick="openPopupWindow('${complaintsString}');">
                            <fmt:message key="jsp.general.complaints" />
                            </a>
                        </c:when>
                    </c:choose>
                </td> 
                <td>
                  <!-- The studyplanCTU -->
                    <c:forEach var="studyPlanCardinalTimeUnits4Display" items="${allStudyPlanCardinalTimeUnits4Display}">
                        <c:choose>
                           <c:when test="${studyPlanCardinalTimeUnits4Display.studyPlanCardinalTimeUnit.id == scholarshipApplication.studyPlanCardinalTimeUnitId}">
                                   ${studyPlanCardinalTimeUnits4Display.studyPlan.studyPlanDescription} - ${studyPlanCardinalTimeUnits4Display.timeUnit}
                           </c:when>
                        </c:choose>
                    </c:forEach>
                </td>                     
                <td class="buttonsCell">
                   <a href="<c:url value='/scholarship/scholarshipapplication.view?newForm=true&tab=1&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&scholarshipApplicationId=${scholarshipApplication.id}&currentPageNumber=${currentPageNumber}'/>">
                          <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                      &nbsp;&nbsp;
                      <a href="<c:url value='/scholarship/scholarshipapplication_delete.view?tab=1&panel=0&studentId=${student.studentId}&scholarshipStudentId=${commandScholarshipStudentId}&scholarshipApplicationId=${scholarshipApplication.id}&currentPageNumber=${currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.scholarshipapplication.delete.confirm" />')">
                          <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                      </a>
                </td>
            </tr>
        
		</c:forEach>
	   </spring:bind>

</table>
<script type="text/javascript">alternate('TblData_scholarshipapplications',true)</script>
	   
