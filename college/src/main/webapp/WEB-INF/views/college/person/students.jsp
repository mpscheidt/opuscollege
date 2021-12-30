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

<c:set var="screentitlekey">jsp.students.header</c:set>
<c:if test="${not empty admissionFlow}"><c:set var="screentitlekey">jsp.menu.flow.admission</c:set></c:if>
<c:if test="${not empty continuedRegistrationFlow}"><c:set var="screentitlekey">jsp.menu.flow.continuedregistration</c:set></c:if>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <sec:authorize access="hasRole('TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR')">
        <c:set var="toggleCutOffPointAdmissionBachelor" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('PROGRESS_ADMISSION_FLOW')">
        <c:set var="progressAdmissionFlow" value="${true}"/>
    </sec:authorize>
<%--    <sec:authorize access="hasRole('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR')">
        <c:set var="toggleCutOffPointContinuedRegistrationBachelor" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER')">
        <c:set var="toggleCutOffPointContinuedRegistrationMaster" value="${true}"/>
    </sec:authorize> --%>
    <sec:authorize access="hasRole('PROGRESS_CONTINUED_REGISTRATION_FLOW')">
        <c:set var="progressContinuedRegistrationFlow" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('FINALIZE_ADMISSION_FLOW')">
        <c:set var="finalizeAdmissionFlow" value="${true}"/>
    </sec:authorize>
    <sec:authorize access="hasRole('FINALIZE_CONTINUED_REGISTRATION_FLOW')">
        <c:set var="finalizeContinuedRegistrationFlow" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('UPDATE_STUDENTS','READ_STUDENTS') or ${opusUser.personId == student.personId}">
        <c:set var="showEditStudent" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

        
	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
	<spring:bind path="studentsForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="studentsForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studentsForm.studySettings">
        <c:set var="studySettings" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studentsForm.studentStatusCode">
        <c:set var="studentStatusCode" value="${status.value}" scope="page" />
    </spring:bind>  

    <spring:bind path="studentsForm.genderCode">
        <c:set var="genderCode" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studentsForm.dropDownListStudies">
        <c:set var="dropDownListStudies" value="${status.value}" scope="page" />
    </spring:bind>  
    
	<spring:bind path="studentsForm.allStudyGradeTypes">
        <c:set var="allStudyGradeTypes" value="${status.value}" scope="page" />
    </spring:bind>  

	<spring:bind path="studentsForm.allAcademicYears">
        <c:set var="allAcademicYears" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studentsForm.studySettings.studyPlanStatus.code">
        <c:set var="studyPlanStatusCode" value="${status.value}" scope="page" />
    </spring:bind>    
    <spring:bind path="studentsForm.cardinalTimeUnitStatusCode">
        <c:set var="cardinalTimeUnitStatusCode" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studentsForm.relativeOfStaffMember">
        <c:set var="relativeOfStaffMember" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studentsForm.ruralAreaOrigin">
        <c:set var="ruralAreaOrigin" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studentsForm.foreignStudent">
        <c:set var="foreignStudent" value="${status.value}" scope="page" />
    </spring:bind>  

    <div id="tabcontent">
   
		<fieldset>
		<legend>
			<fmt:message key="jsp.students.header" />
			<c:if test="${admissionFlow != null && admissionFlow != ''}">
			     &nbsp;-&nbsp;<fmt:message key="jsp.menu.flow.admission" />
			</c:if>
			<c:if test="${continuedRegistrationFlow != null && continuedRegistrationFlow != ''}">
                &nbsp;-&nbsp;<fmt:message key="jsp.menu.flow.continuedregistration" />
            </c:if>
			&nbsp;&nbsp;&nbsp;
			<c:if test="${accessContextHelp && admissionFlow == 'Y'}">
                 <a class="white" href="<c:url value='/help/AdmissionFlow.pdf'/>" target="_blank">
                    <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                 </a>&nbsp;
            </c:if>
            <c:if test="${accessContextHelp && continuedRegistrationFlow == 'Y'}">
                <a class="white" href="<c:url value='/help/ContinuedRegistrationFlow.pdf'/>" target="_blank">
                   <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                </a>&nbsp;
            </c:if>
            <sec:authorize access="hasRole('GENERATE_STUDENT_REPORTS')">
   				<c:set var="reportQueryString" value="" scope="page" />
   				<c:choose>
   					<c:when test="${organization.institutionId != null && institutionId != '' && organization.institutionId != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.institution.id=${organization.institutionId}" scope="page" />
   					</c:when>
   				</c:choose>
   				<c:choose>
   					<c:when test="${organization.branchId != null && organization.branchId != '' && organization.branchId != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.branch.id=${organization.branchId}" scope="page" />
   					</c:when>
   				</c:choose>
   				<c:choose>
   					<c:when test="${organization.organizationalUnitId != null && organization.organizationalUnitId != '' && organization.organizationalUnitId != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.organizationalUnit.id=${organization.organizationalUnitId}" scope="page" />
   					</c:when>
   				</c:choose>
   				<c:choose>
   					<c:when test="${studySettings.studyId != null && studySettings.studyId != '' && studySettings.studyId != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.study.id=${studySettings.studyId}" scope="page" />
   					</c:when>
   				</c:choose>
   				<c:choose>
   					<c:when test="${studySettings.studyGradeTypeId != null && studyDetails.studyGradeTypeId != '' && studySettings.studyGradeTypeId != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.studyGradeType.id=${studySettings.studyGradeTypeId}" scope="page" />
   					</c:when>
   				</c:choose>
	       		<c:choose>
   					<c:when test="${studySettings.cardinalTimeUnitNumber != null && studySettings.cardinalTimeUnitNumber != '' && studySettings.cardinalTimeUnitNumber != '0' }">
   						<c:set var="reportQueryString" value="${reportQueryString}&amp;where.studyPlanCardinalTimeUnit.cardinalTimeUnitNumber=${studySettings.cardinalTimeUnitNumber}" scope="page" />
   					</c:when>
   				</c:choose>
                <c:if test="${not empty studySettings.classgroupId && studySettings.classgroupId != '0'}">
                    <c:set var="reportQueryString" value="${reportQueryString}&amp;where.studentclassgroup.classgroupid=${studySettings.classgroupId}" scope="page" />
                </c:if>
				<a class="white" href="<c:url value='/college/reports.view?reportName=person/students.pdf${reportQueryString}'/>" target="_blank">
				    <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
	            </a>
	            
            </sec:authorize>		
		</legend>

            <form name="organizationandnavigation" id="organizationandnavigation" method="post" action="${navigationSettings.action}">
                <input type="hidden" name="admissionFlow" id="admissionFlow" value="<c:out value="${admissionFlow}" />" />                
                <input type="hidden" name="continuedRegistrationFlow" id="continuedRegistrationFlow" value="<c:out value="${continuedRegistrationFlow}" />" />
        		<table>
					<tr>
						<td>
							<%@ include file="../../includes/organizationAndNavigationAndStudySettings.jsp"%>
							<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS', 'READ_ORG_UNITS','READ_BRANCHES','READ_INSTITUTIONS')">
                                <%@ include file="../../includes/studySettings.jsp"%>
                             </sec:authorize>
                            <c:if test="${continuedRegistrationFlow == 'Y'}">
                                <%@ include file="../../includes/cardinalTimeUnitStatus.jsp"%>
                            </c:if>
						</td>
						<td>
                        <c:if test="${admissionFlow == 'Y' || continuedRegistrationFlow == 'Y'}">
                            <%@ include file="../../includes/relativeOfStaffMemberFilter.jsp"%>
                        </c:if>
                        <c:if test="${admissionFlow == 'Y'}">
                            <%@ include file="../../includes/ruralAreaOriginFilter.jsp"%>
                        </c:if>
                        <c:if test="${admissionFlow == 'Y' || continuedRegistrationFlow == 'Y'}">
                            <%@ include file="../../includes/foreignStudentFilter.jsp"%>
                        </c:if>
						<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','READ_ORG_UNITS','READ_BRANCHES','READ_INSTITUTIONS')">
                              <%@ include file="../../includes/studentStatus.jsp"%>
                        </sec:authorize>
                        
                        <%@ include file="../../includes/personGenderFilterTable.jsp"%>
                        <%@ include file="../../includes/searchValue.jsp"%>
						</td>
					</tr>
         		</table>
		  </form> 

        <c:choose>        
     		<c:when test="${ not empty studentsForm.txtErr}">       
       	       <p align="left" class="errorwide">
       	            <fmt:message key="jsp.error.student.delete" /> <c:out value="${studentsForm.txtErr}"/>
       	       </p>
      	 	</c:when>
    	</c:choose>
    	<c:choose>        
     		<c:when test="${ not empty studentsForm.txtMsg }">       
       	       <p align="right" class="msgwide">
       	            <c:out value="${studentsForm.txtMsg}"/>
       	       </p>
      	 	</c:when>
    	</c:choose>
		</fieldset>
		
<%-- 		<c:set var="allEntities" value="${studentsForm.allStudents}" scope="page" /> --%>
		<c:set var="redirView" value="students" scope="page" />
<%-- 		<c:set var="entityNumber" value="0" scope="page" /> --%>
        <c:set var="selectedGradeType" value="${studyGradeType.gradeTypeCode}" scope="page" />
        <c:set var="gradeTypeIsBachelor" value="${false}" />
        <c:set var="gradeTypeIsMaster" value="${false}" />

        <c:forEach var="gradeType" items="${allGradeTypes}">
            <c:if test="${selectedGradeType eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_BACHELOR}" >
                <c:set var="gradeTypeIsBachelor" value="${true}" />
            </c:if>
            <c:if test="${selectedGradeType eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_MASTER}" >
                <c:set var="gradeTypeIsMaster" value="${true}" />
            </c:if>
        </c:forEach>

        <form name="formdata" method="post">

        <!-- ADMISSION & CNTD REGISTRATION: MAX NUMBER OF STUDENTS / NUMBER OF STUDENTS SELECTED -->
        <c:if test="${(admissionFlow == 'Y' || continuedRegistrationFlow == 'Y')
                && studyGradeType != null && studyGradeType != '' 
                && studySettings.studyGradeTypeId != '0'
                && studySettings.cardinalTimeUnitNumber != null
                && studySettings.cardinalTimeUnitNumber != '' && studySettings.cardinalTimeUnitNumber != '0'
                && studyPlanStatusCode != null && studyPlanStatusCode != ''
                }">
	        <div id="StudentFilter">
	            <table>
	                <tr>
	                   <td class="label">
	                       <fmt:message key="jsp.numberofstudents.studygradetype.ctu.selected" />:
	                   </td>
	                   <td><c:out value="${numberOfRegisteredStudents}"/></td>
	                </tr>
	                <tr>
	                   <td class="label">
	                       <fmt:message key="jsp.numberofstudents.studygradetype.ctu.maximum" />:
	                   </td>
	                   <td><c:out value="${studyGradeType.maxNumberOfStudents}"/></td>
	                </tr>
	            </table>
	            <br />
	        </div>
        </c:if> 
        
        <%-- ADMISSION SELECTS --%>
        
        <c:if test="${admissionFlow == 'Y' && outsideAdmissionPeriod}">
            <div id="StudentFilter">
                <table>
                    <tr>
                        <td class="msgwide">
                            <fmt:message key="jsp.subscribetosubjects.outside.admission.period"/>
                            <br/>
                            (<fmt:message key="jsp.general.startdate"/>: <fmt:formatDate value="${admissionRegistrationConfig.startOfAdmission}" type="date"/> 
                            <fmt:message key="jsp.general.enddate"/>: <fmt:formatDate value="${admissionRegistrationConfig.endOfAdmission}" type="date"/>)
                        </td>
                    </tr>
                </table>
                <br />
           </div>
        </c:if> 

        <c:choose>
            <c:when test="${finalizeAdmissionFlow && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                        && studySettings.studyGradeTypeId != '0' 
                        && studySettings.cardinalTimeUnitNumber != null
                        && studySettings.cardinalTimeUnitNumber != ''   
                        && gradeTypeIsBachelor}">
            
	            <div id="StudentFilter">       
	                                      
	                <script type="text/javascript">
	                    function submitCutOffPointAdmissionBachelor() {
	                        document.getElementById('setCutOffPointAdmissionBachelor').value = "true";
	                        document.formdata.submit();
	                    }
	                </script>                                 
	               
	                <table>
	                <tr><td colspan="2" class="label"><fmt:message key="jsp.cutoffpoint" /> <fmt:message key="jsp.general.initialadmission" /> BSc/BA</td></tr>
	                <tr><td width="300">
                       <fmt:message key="jsp.cutoffpoint.admission.female" />: <c:out value="${studentsForm.admissionBachelorCutOffPointCreditFemale}"/>
                       <br /><fmt:message key="jsp.cutoffpoint.admission.male" />: <c:out value="${studentsForm.admissionBachelorCutOffPointCreditMale}"/>
                       <br /><fmt:message key="jsp.cutoffpoint.admission.relatives.female" />: <c:out value="${studentsForm.admissionBachelorCutOffPointRelativesCreditFemale}"/>
                       <br /><fmt:message key="jsp.cutoffpoint.admission.relatives.male" />: <c:out value="${studentsForm.admissionBachelorCutOffPointRelativesCreditMale}"/>
                       <br /><fmt:message key="jsp.cutoffpoint.admission.ruralareas" />: <c:out value="${studentsForm.admissionBachelorCutOffPointCreditRuralAreas}"/>
                       </td>
                       <td width="300">
                       <spring:bind path="studentsForm.cutOffPointAdmissionBachelor">
                           <input id="${status.expression}" name="${status.expression}" type="text" width="10" value="<c:out value="${status.value}" />" />
                       </spring:bind>
                           <input type="hidden" id="setCutOffPointAdmissionBachelor" name="setCutOffPointAdmissionBachelor" value="false" />                                
                           <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.set" />" onclick="submitCutOffPointAdmissionBachelor()" />
                            <br />(<fmt:message key="jsp.general.choose.between" />: ${appConfigManager.secondarySchoolSubjectsHighestGrade * appConfigManager.secondarySchoolSubjectsCount} <fmt:message key="jsp.general.and" /> ${appConfigManager.secondarySchoolSubjectsLowestGrade * appConfigManager.secondarySchoolSubjectsCount}  + <fmt:message key="jsp.cutoffpoint.admission.female" /> <fmt:message key="jsp.general.or" /> <fmt:message key="jsp.cutoffpoint.admission.male" />)
                        </td>
                    </tr>
                    </table>   

                </div>
            </c:when>
        </c:choose> 
        
        <c:choose>
            <c:when test="${finalizeAdmissionFlow && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                && studySettings.cardinalTimeUnitNumber != ''  
                && !gradeTypeIsBachelor}">
            <div id="StudentFilter">
            <table>
            <tr>
            <td class="label">
                <fmt:message key="jsp.general.nextstudyplanstatus" />
            </td>
            <td>
                <select id="nextStudyPlanStatusCode" name="nextStudyPlanStatusCode">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="studyPlanStatus" items="${allStudyPlanStatuses}">
                        <c:if test="${studyPlanStatus.code == STUDYPLAN_STATUS_APPROVED_ADMISSION}">
                            <option value="${studyPlanStatus.code}"><c:out value="${studyPlanStatus.description}"/></option>
                        </c:if>
                    </c:forEach>
                </select>
             </td>
             </tr></table>
            </div>
            </c:when>
        </c:choose>
         
        <c:choose>
            <c:when test="${(progressAdmissionFlow && 
                studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_PAYMENT
                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                && studySettings.cardinalTimeUnitNumber != ''   
            )}">
            <div id="StudentFilter">
            <table><tr>
            <td class="label">
                <fmt:message key="jsp.general.nextstudyplanstatus" />
            </td>
            <td>
                <select id="nextStudyPlanStatusCode" name="nextStudyPlanStatusCode">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="studyPlanStatus" items="${allStudyPlanStatuses}">
                        <c:if test="${studyPlanStatus.code == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            || studyPlanStatus.code == STUDYPLAN_STATUS_REJECTED_ADMISSION }">
                            <option value="${studyPlanStatus.code}"><c:out value="${studyPlanStatus.description}"/></option>
                        </c:if>
                    </c:forEach>
                </select>
             </td>
             </tr></table>
            </div>
            </c:when>
        </c:choose>
        
        <%-- CONTINUED REGISTRATION SELECTS --%>
        <c:if test="${continuedRegistrationFlow == 'Y' && outsideRegistrationPeriod}">
            <div id="StudentFilter">
                <table>
                    <tr>
                        <td class="msgwide">
                            <fmt:message key="jsp.subscribetosubjects.outside.registration.period"/>
                            <br/>
                            (<fmt:message key="jsp.general.startdate"/>: <fmt:formatDate value="${admissionRegistrationConfig.startOfRegistration}" type="date"/> 
                            <fmt:message key="jsp.general.enddate"/>: <fmt:formatDate value="${admissionRegistrationConfig.endOfRegistration}" type="date"/>)
                        </td>
                    </tr>
                </table>
                <br />
           </div>
        </c:if> 

<%-- MP 2013-05-13: "waiting for selection" status is disabled for cardinal time units, since it is not used anywhere;
             *                quota allocation at UNZA needs to be done outside the system (based on Opus reports), since it is a complex process            
        <c:choose>
            <c:when test="${continuedRegistrationFlow == 'Y' && toggleCutOffPointContinuedRegistrationBachelor 
                        && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                        && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                        && studySettings.cardinalTimeUnitNumber != ''  
                        && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                        && gradeTypeIsBachelor}">
            
                <div id="StudentFilter">       
                                          
                <script type="text/javascript">
                    function submitCutOffPointContinuedRegistrationBachelor() {
                        document.getElementById('setCutOffPointContinuedRegistrationBachelor').value = "true";
                        document.formdata.submit();
                    }
                </script>                                 
                 
                <table>
                   <tr><td class="label">
                        <fmt:message key="jsp.cutoffpoint" /> <fmt:message key="jsp.general.continuedregistrationstatus" /> BSc/BA:
                        </td></tr>
                    <tr><td width="300">
                        <fmt:message key="jsp.cutoffpoint.continuedregistration.female" />: ${studentsForm.cntdRegistrationBachelorCutOffPointCreditFemale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.male" />: ${studentsForm.cntdRegistrationBachelorCutOffPointCreditMale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.relatives.female" />: ${studentsForm.cntdRegistrationBachelorCutOffPointRelativesCreditFemale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.relatives.male" />: ${studentsForm.cntdRegistrationBachelorCutOffPointRelativesCreditMale}
                        </td>
                        <td width="300">
	                       <spring:bind path="studentsForm.cutOffPointContinuedRegistrationBachelor">
	                           <input id="${status.expression}" name="${status.expression}" type="text" width="10" value="<c:out value="${status.value}" />" />
	                       </spring:bind>
	                       <input type="hidden" id="setCutOffPointContinuedRegistrationBachelor" name="setCutOffPointContinuedRegistrationBachelor" value="false" />                                
	                       <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.set" />" onclick="submitCutOffPointContinuedRegistrationBachelor()" />
	                       <br />(<fmt:message key="jsp.general.choose.between" /> ${minimumGrade} <fmt:message key="jsp.general.and" /> ${maximumGrade} * ${studyGradeType.numberOfSubjectsPerCardinalTimeUnit} (<fmt:message key="jsp.general.numberofsubjects.cardinaltimeunit" />) + <fmt:message key="jsp.cutoffpoint.continuedregistration.female" /> <fmt:message key="jsp.general.or" /> <fmt:message key="jsp.cutoffpoint.continuedregistration.male" />)
                        </td>
                    </tr>
                </table>
                </div>
                
            </c:when>
        </c:choose> 
        
        <c:choose>
            <c:when test="${continuedRegistrationFlow == 'Y' && toggleCutOffPointContinuedRegistrationMaster && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                        && cardinalTimeUnitStatusCode != ''
                        && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                        && studySettings.cardinalTimeUnitNumber != ''  
                        && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                        && (gradeTypeIsMaster)}">
            
                <div id="StudentFilter">       
                                          
                    <script type="text/javascript">
                        function submitCutOffPointContinuedRegistrationMaster() {
                            document.getElementById('setCutOffPointContinuedRegistrationMaster').value = "true";
                            document.formdata.submit();
                        }
                    </script>                                 
                    
                    <table>
                    <tr><td class="label" colspan="2"> 
                    <fmt:message key="jsp.cutoffpoint" /> <fmt:message key="jsp.general.continuedregistrationstatus" /> MSc/MA:
                    </td>
                    </tr> 
                    <tr>
                        <td>  
                        <fmt:message key="jsp.cutoffpoint.continuedregistration.female" />: ${studentsForm.cntdRegistrationMasterCutOffPointCreditFemale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.male" />: ${studentsForm.cntdRegistrationMasterCutOffPointCreditMale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.relatives.female" />: ${studentsForm.cntdRegistrationMasterCutOffPointRelativesCreditFemale}
                        <br /><fmt:message key="jsp.cutoffpoint.continuedregistration.relatives.male" />: ${studentsForm.cntdRegistrationMasterCutOffPointRelativesCreditMale}
                    </td>
                    <td>
                        <spring:bind path="studentsForm.cutOffPointContinuedRegistrationMaster">
                           <input id="${status.expression}" name="${status.expression}" type="text" width="10" value="<c:out value="${status.value}" />" />
                        </spring:bind>
                        <input type="hidden" id="setCutOffPointContinuedRegistrationMaster" name="setCutOffPointContinuedRegistrationMaster" value="false" />                                
                        <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.set" />" onclick="submitCutOffPointContinuedRegistrationMaster()" />
                        <br />(<fmt:message key="jsp.general.choose.between" />: ${minimumGrade} <fmt:message key="jsp.general.and" /> ${maximumGrade} + <fmt:message key="jsp.cutoffpoint.continuedregistration.female" /> <fmt:message key="jsp.general.or" /> <fmt:message key="jsp.cutoffpoint.continuedregistration.male" />)
                    </td>
                    </tr>
                    </table>
                </div>
            </c:when>
        </c:choose> --%> 
           
        <c:choose>
            <c:when test="${continuedRegistrationFlow == 'Y' 
                && progressContinuedRegistrationFlow && studySettings.studyGradeTypeId != '0' 
                && studySettings.cardinalTimeUnitNumber != null
                && studySettings.cardinalTimeUnitNumber != '' 
                    && (
                    (cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
                            || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                            || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE)
                         
              )}">
            <div id="StudentFilter">
            <table>
            <tr>
            <td class="label">
                <fmt:message key="jsp.general.nextcardinaltimeunitstatus" />
            </td>
            <td>
                <select id="nextCardinalTimeUnitStatusCode" name="nextCardinalTimeUnitStatusCode">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="cardinalTimeUnitStatus" items="${allCardinalTimeUnitStatuses}">
	                    <c:if test="${cardinalTimeUnitStatus.code != cardinalTimeUnitStatusCode
	                        && cardinalTimeUnitStatus.code != CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION
                            && cardinalTimeUnitStatus.code != CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED
                            && cardinalTimeUnitStatus.code != CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
                            }">
                            <option value="${cardinalTimeUnitStatus.code}"><c:out value="${cardinalTimeUnitStatus.description}"/></option>
                        </c:if>
	                </c:forEach>
                </select>
             </td>
             </tr></table>
            </div>
            </c:when>
            
        </c:choose> 
        
        <c:choose>
            <c:when test="${continuedRegistrationFlow == 'Y' && finalizeContinuedRegistrationFlow && 
                cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION
                && studySettings.cardinalTimeUnitNumber != null
                && studySettings.cardinalTimeUnitNumber != '' 
                }">
            <div id="StudentFilter">
            <table>
            <tr>
            <td class="label">
                <fmt:message key="jsp.general.nextcardinaltimeunitstatus" />
            </td>
            <td>
                <select id="nextCardinalTimeUnitStatusCode" name="nextCardinalTimeUnitStatusCode">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="cardinalTimeUnitStatus" items="${allCardinalTimeUnitStatuses}">
                        <c:if test="${cardinalTimeUnitStatus.code == CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION
                            || cardinalTimeUnitStatus.code == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED }">
                            <option value="${cardinalTimeUnitStatus.code}"><c:out value="${cardinalTimeUnitStatus.description}"/></option>
                        </c:if>
                    </c:forEach>
                </select>
            </td>
            </tr></table>
            </div>
            </c:when>
        </c:choose>      
       
        <c:choose>
            <c:when test="${admissionFlow == 'Y' && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                            && studySettings.cardinalTimeUnitNumber != ''  
                            && (gradeTypeIsBachelor)
                        ||
                        (admissionFlow == 'Y' && progressAdmissionFlow && studySettings.studyGradeTypeId != '0' 
                            && studySettings.cardinalTimeUnitNumber != ''  
                                && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_PAYMENT)
                        ||
                        (admissionFlow == 'Y' && finalizeAdmissionFlow && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                            && studySettings.cardinalTimeUnitNumber != ''  
                            && !gradeTypeIsBachelor)
                    || (continuedRegistrationFlow == 'Y' && progressContinuedRegistrationFlow)
                                && (cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
                                        || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                                        || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE
                                )
                    || (continuedRegistrationFlow == 'Y' && finalizeContinuedRegistrationFlow 
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != '' 
                                && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION
                        )
                }">
                <br />

                <script type="text/javascript">
                    function submitStudentList() {
                        document.getElementById('submitStudentSelection').value = "true";
                        document.formdata.submit();                                                       
                    }
                </script>
                <input type="hidden" name="submitStudentSelection" id="submitStudentSelection" value="false" />
                <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="submitStudentList()" />
            </c:when>  
        </c:choose>
        
        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${studentsForm.studentCount}" scope="page" />
        <%@ include file="../../includes/pagingHeaderInterface.jsp"%>           

        <table class="tabledata" id="TblData">
            <tr>
                <c:choose>
                    <c:when test="${admissionFlow == 'Y' && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != ''   
                                && gradeTypeIsBachelor
                            ||
                            (admissionFlow == 'Y' && progressAdmissionFlow && studySettings.studyGradeTypeId != '0' 
                                && not empty studySettings.cardinalTimeUnitNumber  
                                    && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_PAYMENT)
                            ||
                            (admissionFlow == 'Y' && finalizeAdmissionFlow && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != ''   
                                && !gradeTypeIsBachelor)
                            }">
                        <th><fmt:message key="jsp.href.add" /></th>
                    </c:when>
                </c:choose>
                <%-- <c:if test="${continuedRegistrationFlow eq 'Y' 
                                && toggleCutOffPointContinuedRegistrationBachelor 
                                && cardinalTimeUnitStatusCode eq CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                                && studySettings.cardinalTimeUnitNumber eq '1'
                                && gradeTypeIsBachelor}">
                     <th>&nbsp;</th>
                 </c:if> --%>
              
                <th><fmt:message key="jsp.general.code" /></th>
                <th><fmt:message key="jsp.general.title" /></th>
                <th><fmt:message key="jsp.general.firstnames" /></th>
                <th><fmt:message key="jsp.general.surname" /></th>
                <th><fmt:message key="jsp.general.birthdate" /></th>
                <th><fmt:message key="jsp.general.studyplans" /></th>
                <th class="width1"><fmt:message key="jsp.general.relativeofstaffmember" /></th>
                <th class="width1"><fmt:message key="jsp.general.ruralareaorigin" /></th>
                <th class="width1"><fmt:message key="jsp.general.foreignstudent" /></th>
                <th class="width1"><fmt:message key="jsp.general.studentfeespaid" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <c:choose>
                    <c:when test="${admissionFlow == 'Y'  && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                            && studySettings.cardinalTimeUnitNumber != ''  
                            && gradeTypeIsBachelor}">
                        <th><fmt:message key="jsp.general.secondaryschoolsubjects" /></th>
                    </c:when>
                </c:choose>
                <%--<c:choose>
                    <c:when test="${(continuedRegistrationFlow == 'Y' && toggleCutOffPointContinuedRegistrationBachelor && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != ''  
                                && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                                && gradeTypeIsBachelor)
                            ||
                            (continuedRegistrationFlow == 'Y' && toggleCutOffPointContinuedRegistrationMaster && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != ''  
                                && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                                && gradeTypeIsMaster)}">
                        <th><fmt:message key="jsp.general.results" /></th>
                    </c:when>
                </c:choose> --%>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
            </tr>
            <c:forEach var="student" items="${studentsForm.allStudents}" varStatus="rowIndex">
<%-- 				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" /> --%>
<%--             	<c:choose> --%>
<%--             		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >                                        --%>
	                <tr>
	                   <%-- CUT OFF POINT ADMISSION / FINALIZE ADMISSION --%>
                        <c:choose>
                            <c:when test="${admissionFlow == 'Y' && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                            && studySettings.cardinalTimeUnitNumber != ''  
                            && (gradeTypeIsBachelor)
                        ||
                        (admissionFlow == 'Y' && progressAdmissionFlow && studySettings.studyGradeTypeId != '0' 
                            && studySettings.cardinalTimeUnitNumber != '' 
                                && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_PAYMENT)}">
                            <td>
                                <input type="hidden" id="studentsForm.allStudents[${rowIndex.index}].id" name="studentsForm.allStudents[${rowIndex.index}].id" value="<c:out value="${studentsForm.allStudents[rowIndex.index].id}" />" />                
                                <spring:bind path="studentsForm.allStudents[${rowIndex.index}].proceedToAdmissionProgressStatus">
                                    <input type="checkbox" name="${status.expression}" checked="checked" value="true" />
                                </spring:bind>
                            </td>
                            </c:when>
                        </c:choose>
                        
                        <%-- ADMISSION PROGRESS --%>
                        <c:choose>
                            <c:when test="${
                        (admissionFlow == 'Y' && finalizeAdmissionFlow && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                            && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                            && studySettings.cardinalTimeUnitNumber != '' 
                            && !gradeTypeIsBachelor)}">
                            <td>
                                <input type="hidden" id="studentsForm.allStudents[${rowIndex.index}].id" name="studentsForm.allStudents[${rowIndex.index}].id" value="<c:out value="${studentsForm.allStudents[rowIndex.index].id}" />" />                
                                <spring:bind path="studentsForm.allStudents[${rowIndex.index}].proceedToAdmissionFinalizeStatus">
                                    <input type="checkbox" name="${status.expression}" checked="checked" value="true" />
                                </spring:bind>
                            </td>
                            </c:when>
                        </c:choose>
                        
                        <%-- CONTINUED REGISTRATION PROGRESS --%>
                        <c:choose>
                            <c:when test="${
                                continuedRegistrationFlow == 'Y' && progressContinuedRegistrationFlow
                                && (cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
			                            || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
			                            || cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE
			                    )
			             }">
                            <td>
                                <input type="hidden" id="studentsForm.allStudents[${rowIndex.index}].id" name="studentsForm.allStudents[${rowIndex.index}].id" value="<c:out value="${studentsForm.allStudents[rowIndex.index].id}" />" />                
                                <spring:bind path="studentsForm.allStudents[${rowIndex.index}].proceedToContinuedRegistrationProgressStatus">
                                    <input type="checkbox" name="${status.expression}" checked="checked" value="true" />
                                </spring:bind>
                            </td>
                            </c:when>
                        </c:choose>
                        
                        <%-- CONTINUED REGISTRATION FINALIZE --%>
                        <c:choose>
                            <c:when test="${continuedRegistrationFlow == 'Y' && finalizeContinuedRegistrationFlow 
                                && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                && studySettings.cardinalTimeUnitNumber != ''   
                                && cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION
                            }">
                            <td>
                                <input type="hidden" id="studentsForm.allStudents[${rowIndex.index}].id" name="studentsForm.allStudents[${rowIndex.index}].id" value="<c:out value="${studentsForm.allStudents[rowIndex.index].id}" />" />                
                                <spring:bind path="studentsForm.allStudents[${rowIndex.index}].proceedToContinuedRegistrationFinalizeStatus">
                                    <input type="checkbox" name="${status.expression}" checked="checked" value="true" />
                                </spring:bind>
                            </td>
                            </c:when>
                        </c:choose>
                        
                        <%-- STUDENT CODE --%>
                        <td><c:out value="${student.studentCode}"/></td>

                        <%-- CIVIL TITLE --%>
	                    <td>
	                    <c:forEach var="civilTitle" items="${allCivilTitles}">
	                       <c:choose>
	                            <c:when test="${civilTitle.code == student.civilTitleCode }">
	                                <c:out value="${civilTitle.description}"/>
	                            </c:when>
	                       </c:choose>
	                    </c:forEach>
                        </td>

                        <%-- FIRST NAMES --%>
	                    <td><c:out value="${student.firstnamesFull}"/></td>

                        <%-- SURNAME --%>
	                    <td>
                            <c:choose>
                                <c:when test="${showEditStudent or opusUser.personId == student.personId}">
                                    <a href="<c:url value='/college/student/personal.view?newForm=true&amp;from=students&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;searchValue=${navigationSettings.searchValue}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                    <c:out value="${student.surnameFull}"/></a>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${student.surnameFull}"/>
                                </c:otherwise>
                            </c:choose>
	                    </td>

                        <%-- BIRTH DATE --%>
	                    <td><fmt:formatDate pattern="dd/MM/yyyy" value="${student.birthdate}" /></td>

                        <%-- STUDY PLANS --%>
	                    <td>
                            <c:forEach var="studyPlan" items="${student.studyPlans}" varStatus="loopStatus">
<%--                                 <c:set var="staffMember" value="${idToStaffMemberMap[testTeacher.staffMemberId]}" /> --%>
<%--                                 <c:out value="${studyPlan.id}"/> --%>
                                <a href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${student.studentId}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                    <c:set var="study" value="${studentsForm.idToStudyMap[studyPlan.studyId]}" />
                                    <c:out value="${study.studyDescription}"/>
                                    -
                                    <c:set var="spGradeType" value="${studentsForm.codeToGradeTypeMap[studyPlan.gradeTypeCode]}" />
                                    <c:out value="${spGradeType.description}"/>
<%--                                     <c:forEach var="oneGradeType" items="${allGradeTypes}"> --%>
<%--                                         <c:choose> --%>
<%--                                             <c:when test="${studyPlan.gradeTypeCode == oneGradeType.code}"> --%>
<%--                                                 <c:out value="${oneGradeType.description}"/> --%>
<%--                                             </c:when> --%>
<%--                                         </c:choose> --%>
<%--                                     </c:forEach> --%>
                                    <c:if test="${!loopStatus.last}"><br/></c:if>
                                </a>
                            </c:forEach>
	                    </td>

                        <%-- RELATIVE OF STAFF MEMBER --%>
	                    <td>
                            <c:choose>
                                <c:when test="${student.relativeOfStaffMember == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <%-- RURAL AREA --%>
                        <td>
                            <c:choose>
                                <c:when test="${student.ruralAreaOrigin == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <%-- FOREIGN STUDENT --%>
                        <td>
                            <c:choose>
                                <c:when test="${student.foreignStudent == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <%-- PAID FEES? --%>
                        <c:set var="studentBalanceAvailable" value="${not empty student.studentBalanceInformation and not empty student.studentBalanceInformation.balance}" />
	                    <td>
                            <c:choose>
                                <c:when test="${not studentBalanceAvailable}">
                                    <fmt:message key="jsp.general.unknown" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="paidPercentage" value="${student.studentBalanceInformation.paidPercentage}%" /> 
                                    <c:choose>
                                        <c:when test="${student.hasMadeSufficientPayments}">
                                            <fmt:message key="jsp.general.yes" />&nbsp;(<c:out value="${paidPercentage}"/>)
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:message key="jsp.general.no" />&nbsp;(<c:out value="${paidPercentage}"/>)
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <%-- ACTIVE --%>
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
                        <!--  CUT OFF POINT ADMISSION - SEC SCHOOL SUBJECTS -->
                        <c:choose>
                            <c:when test="${finalizeAdmissionFlow && toggleCutOffPointAdmissionBachelor && studyPlanStatusCode == STUDYPLAN_STATUS_WAITING_FOR_SELECTION
                        && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                        && studySettings.cardinalTimeUnitNumber != '' 
                        && (gradeTypeIsBachelor)}">
                            <td>
                                <c:forEach var="studyPlan" items="${student.studyPlans}">
                                    <!--  stored allgradesscore -->
                                    <b>${studyPlan.allGradesScore}</b><br />
                                    <c:forEach var="gradedSecondarySchoolSubject" items="${studyPlan.gradedSecondarySchoolSubjects}" varStatus="status">
                                        ${gradedSecondarySchoolSubject.description}(${gradedSecondarySchoolSubject.grade}<c:if test="${not empty gradedSecondarySchoolSubject.level}"> - <c:out value="${gradedSecondarySchoolSubject.level}"/></c:if>)<c:if test="${not status.last}">,</c:if>  
                                        <c:if test="${ status.last}"><br /><br /></c:if>
                                    </c:forEach>
                                    
                                </c:forEach>
                            </td>
                            </c:when>
                        </c:choose> 
                        <%--<!--  CUT OFF POINT CNTD REGISTRATION - SUBJECT RESULTS -->
                        <c:choose>
                            <c:when test="${(cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                                        && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                        && studySettings.cardinalTimeUnitNumber != '' 
                                        && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                                        && (gradeTypeIsBachelor))
                                    ||
                                    (cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION
                                        && studySettings.studyGradeTypeId != '0' && studySettings.cardinalTimeUnitNumber != null
                                        && studySettings.cardinalTimeUnitNumber != '' 
                                        && studySettings.cardinalTimeUnitNumber != '0' && studySettings.cardinalTimeUnitNumber != '1'
                                        && gradeTypeIsMaster)
                                }">
                            <td>
                                <c:forEach var="studyPlan" items="${student.studyPlans}">
                                    <!--  stored allgradesscore -->
                                    <b>${studyPlan.allGradesScore}</b><br />
                                    <c:forEach var="studyPlanCardinalTimeUnit" items="${studyPlan.studyPlanCardinalTimeUnits}">
	                                    <c:forEach var="subjectResult" items="${studyPlanCardinalTimeUnit.subjectResults}" varStatus="status">
	                                        <c:forEach var="subject" items="${studyPlanCardinalTimeUnit.subjects}">
	                                           <c:if test="${subject.id == subjectResult.subjectId}">
	                                               ${subject.subjectDescription}
	                                           </c:if>
	                                        </c:forEach>
	                                        &nbsp;(${studentsForm.subjectResultFormatter[subjectResult]})<c:if test="${not status.last}">,</c:if>  
	                                        <c:if test="${status.last}"><br /><br /></c:if>
	                                    </c:forEach>
	                                </c:forEach>
                                </c:forEach>
                            </td>
                            </c:when>
                        </c:choose> --%>                           
	                    <td class="buttonsCell">
                            <c:if test="${showEditStudent}">
                                <a class="imageLink" href="<c:url value='/college/student/personal.view?newForm=true&amp;from=students&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;searchValue=${navigationSettings.searchValue}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                            </c:if>                            
	                    </td>   
                        <td class="buttonsCell">
                            <sec:authorize access="hasRole('DELETE_STUDENTS') and ${opusUser.personId != student.personId}">
                                    <a class="imageLink" href="<c:url value='/college/student_delete.view?newForm=true&amp;studentId=${student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                                    onclick="return confirm('<fmt:message key="jsp.students.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                            </sec:authorize>
                        </td>                               
	                </tr>
<%-- 	            	</c:when> --%>
<%-- 	            </c:choose> --%>
            </c:forEach>
        </table>        
        
		<script type="text/javascript">alternate('TblData',true)</script>                
        
        <%@ include file="../../includes/pagingFooterNew.jsp"%>
        <br />
        <br />

        </form>
    </div>

</div>

<%@ include file="../../footer.jsp"%>
