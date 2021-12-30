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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <!-- page vars -->
    <c:set var="studyGradeTypeId"  value="${studyGradeTypeForm.studyGradeType.id}" scope="page" />
    <c:set var="gradeTypeCode"  value="${studyGradeTypeForm.studyGradeType.gradeTypeCode}" scope="page" />
    <c:set var="commandCardinalTimeUnitCode" value="${studyGradeTypeForm.studyGradeType.cardinalTimeUnitCode}" scope="page" />

    <%-- authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_STUDYGRADETYPES','UPDATE_STUDYGRADETYPES')">
        <c:set var="editStudyGradeTypes" value="${true}"/>
    </sec:authorize>
    <c:if test="${not editStudyGradeTypes}">
        <sec:authorize access="hasRole('READ_STUDYGRADETYPES')">
            <c:set var="showStudyGradeTypes" value="${true}"/>
        </sec:authorize>
    </c:if>
    
    <sec:authorize access="hasRole('UPDATE_STUDYGRADETYPE_RFC')">
        <c:set var="editStudyGradeTypeRFC" value="${true}"/>
    </sec:authorize>
     <c:if test="${not editStudyGradeTypeRFC}">
	   <sec:authorize access="hasRole('CREATE_STUDYGRADETYPE_RFC')">
	        <c:set var="createStudyGradeTypeRFC" value="${true}"/>
	    </sec:authorize>
    </c:if>
        <c:set var="gradeTypeIsBachelor" value="${false}" />
        <c:set var="gradeTypeIsMaster" value="${false}" />

        <c:forEach var="gradeType" items="${allGradeTypes}">
            <c:if test="${gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_BACHELOR}" >
                <c:set var="gradeTypeIsBachelor" value="${true}" />
            </c:if>
            <c:if test="${gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_MASTER}" >
                <c:set var="gradeTypeIsMaster" value="${true}" />
            </c:if>
        </c:forEach>
        
        
    <div id="tabcontent">

        <form>        
            <fieldset>
                <legend>
                    <a href="<c:url value='/college/studies.view?currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.studies.header" /></a>&nbsp;&gt;
                    <a href="<c:url value='/college/study.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyId=${studyGradeTypeForm.study.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>">
                            <c:out value="${fn:substring(studyGradeTypeForm.study.studyDescription,0,initParam.iTitleLength)}"/>
                    </a>
                    &gt;
                    <c:choose>
                        <c:when test="${not empty studyGradeTypeForm.studyGradeType.gradeTypeCode}" >
                            ${studyGradeTypeForm.studyGradeType.gradeTypeCode}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="general.add.studyprogram" />
                        </c:otherwise>
                    </c:choose>
                     
                </legend>
            </fieldset>
        </form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.studygradetype" /></div>
                                <div class="AccordionPanelContent">

                                    <c:choose>
                                        <c:when
                                            test="${ not empty showStudyGradeTypeError }">
                                            <p align="left" class="error">
                                                <c:out value="${showStudyGradeTypeError}"/>
                                            </p>
                                        </c:when>
                                    </c:choose>
                                    <c:choose>
                                        <c:when
                                            test="${ not empty showSubjectStudyGradeTypeError }">
                                            <p align="left" class="error">
                                                <c:out value="${showSubjectStudyGradeTypeError}"/>
                                            </p>
                                        </c:when>
                                    </c:choose>
                                    <c:choose>
                                          <c:when test="${ not empty showStudyGradeTypeMessage }">
                                             <p align="left" class="msg">
                                                <c:out value="${showStudyGradeTypeMessage}"/>
                                             </p>
                                         </c:when>
                                     </c:choose>

                                	<form method="post" name="gtform" id="gtform">
                                    <input type="hidden" value="true" name="submitFormObject" id="submitFormObject" />
                                
                                    <input type="hidden" name="tab_studygradetype" value="1" /> 
                                    <input type="hidden" name="panel_studygradetype" value="0" />
                                    <input type="hidden" name="currentPageNumber" value="${studyGradeTypeForm.navigationSettings.currentPageNumber}" />
                                    
                                    <table>
                                    	<!-- Program code -->
                                    	<tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                   			<spring:bind path="studyGradeTypeForm.studyGradeType.studyGradeTypeCode">
	                                            <td>
		                                            <input type="text" name="${status.expression}" value="<c:out value="${status.value}" />" />
	                                            </td>
	                                            <td>
		                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
	                                            </td>
                                   			</spring:bind>
                                    	</tr>

                                        <!--  GRADE TYPE CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.gradeTypeCode">
                                            <td class="required">
                                            <select name="${status.expression}" onchange="postFormNoSubmit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                 <c:forEach var="oneGradeType" items="${allGradeTypes}">
                                                    <c:set var="disabled" value="" scope="page" />
                                                    <c:forEach var="studyGradeType" items="${studyGradeTypeForm.allStudyGradeTypesForStudy}">
                                                       <%--  <c:choose>
                                                            <c:when test="${(status.value == 0 && studyGradeType.gradeTypeCode == oneGradeType.code)
                                                                        || (status.value != 0 && status.value != oneGradeType.code && studyGradeType.gradeTypeCode == oneGradeType.code)}">
                                                                <c:set var="disabled" value="disabled" scope="page" />
                                                            </c:when>
                                                        </c:choose> --%>
                                                    </c:forEach>
                                                    <%--<c:choose>
                                                        <c:when test="${disabled == ''}"> --%>
                                                            <c:choose>
                                                                <c:when test="${oneGradeType.code == status.value}">
                                                                    <option value="${oneGradeType.code}" selected="selected"><c:out value="${oneGradeType.description}"/></option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option value="${oneGradeType.code}"><c:out value="${oneGradeType.description}"/></option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                    <%--     </c:when>
                                                   </c:choose> --%>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td width="40%"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
      
                                  		<!--  CURRENT ACADEMIC YEAR -->
                                      	<tr>
                                		<td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                		<spring:bind path="studyGradeTypeForm.studyGradeType.currentAcademicYearId">
                                		<td class="required">
                                            <select name="${status.expression}" id="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="academicYear" items="${studyGradeTypeForm.allAcademicYears}">
                                                     <c:choose>
                                                         <c:when test="${academicYear.id == status.value}">
                                                             <option value="${academicYear.id}" selected="selected"><c:out value="${academicYear.description}"/></option> 
                                                         </c:when>
                                                         <c:otherwise>
                                                             <option value="${academicYear.id}"><c:out value="${academicYear.description}"/></option> 
                                                         </c:otherwise>
                                                     </c:choose>
                                                </c:forEach>
                                            </select>
                                		</td>
                                        <td>
                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                            ${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                	</tr>

				                       <!-- STUDY TIME -->
				                        <tr>
				                            <td class="label"><fmt:message key="jsp.general.studytime" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.studyTimeCode">
                                            <td class="required">
                                            <select name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
				                                   <c:forEach var="studyTime" items="${allStudyTimes}">
				                                       <c:choose>
				                                           <c:when test="${studyTime.code == status.value}">
				                                               <option value="${studyTime.code}" selected="selected"><c:out value="${studyTime.description}"/></option>
				                                           </c:when>
				                                           <c:otherwise>
				                                           		<option value="${studyTime.code}"><c:out value="${studyTime.description}"/></option>
				                                           </c:otherwise>
				                                       </c:choose>
				                                   </c:forEach>
                                      		</select>
                                            </td> 
                                          	<td>
                                          		<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
				                       </tr>

                                       <!-- STUDY FORM -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.studyform" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.studyFormCode">
                                            <td class="required">
                                            <select name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                   <c:forEach var="studyForm" items="${allStudyForms}">
                                                       <c:choose>
                                                           <c:when test="${studyForm.code == status.value}">
                                                               <option value="${studyForm.code}" selected="selected"><c:out value="${studyForm.description}"/></option>
                                                           </c:when>
                                                           <c:otherwise>
                                                                <option value="${studyForm.code}"><c:out value="${studyForm.description}"/></option>
                                                           </c:otherwise>
                                                       </c:choose>
                                                   </c:forEach>
                                            </select>
                                            </td> 
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                       </tr>
 
                                        <!-- STUDY INTENSITY -->
                                        <c:if test="${appUseOfPartTimeStudyGradeTypes == 'Y'}">
	                                        <tr>
	                                            <td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
	                                            <spring:bind path="studyGradeTypeForm.studyGradeType.studyIntensityCode">
	                                            <td class="required">
	                                            <select name="${status.expression}">
	                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
	                                                   <c:forEach var="studyIntensity" items="${allStudyIntensities}">
	                                                       <c:choose>
	                                                           <c:when test="${studyIntensity.code == status.value}">
	                                                               <option value="${studyIntensity.code}" selected="selected"><c:out value="${studyIntensity.description}"/></option>
	                                                           </c:when>
	                                                           <c:otherwise>
	                                                                <option value="${studyIntensity.code}"><c:out value="${studyIntensity.description}"/></option>
	                                                           </c:otherwise>
	                                                       </c:choose>
	                                                   </c:forEach>
	                                            </select>
	                                            </td> 
	                                            <td>
	                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
	                                                </c:forEach>
	                                            </td>
	                                            </spring:bind>
	                                        </tr>
                                        </c:if>
                                        
 				                        <!-- CARDINAL TIME UNIT -->
				                        <tr>
				                            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.cardinalTimeUnitCode">
                                            <td class="required">
                                            <select name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
				                                   <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}">
				                                       <c:choose>
				                                           <c:when test="${cardinalTimeUnit.code == status.value}">
				                                               <option value="${cardinalTimeUnit.code}" selected="selected"><c:out value="${cardinalTimeUnit.description}"/></option>
				                                           </c:when>
				                                           <c:otherwise>
				                                           	<option value="${cardinalTimeUnit.code}"><c:out value="${cardinalTimeUnit.description}"/></option>
				                                           </c:otherwise>
				                                       </c:choose>
				                                   </c:forEach>
                                      		</select>
                                            </td>
                                          	<td>
                                          		<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind> 
				                       </tr>
                                        
                                        <!--  NUMBER OF CARDINAL TIME UNITS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofcardinaltimeunits" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.numberOfCardinalTimeUnits">
                                            <td class="required">
                                            <script type="text/javascript">
                                                // The function changeNumberOfCardinalTimeUnits checks to make sure no filled  
                                                // out rows are removed before the user is asked for confirmation.
                                                function changeNumberOfCardinalTimeUnits() {

                                                    if (checkSurplusCtusFilled()) {

                                                    	var proceed = confirm('<fmt:message key="jsp.general.numberofcardinaltimeunits.contract.sure" />');

                                                        if (proceed) {
                                                            
                                                            postFormNoSubmit();
                                                        } else {
                                                            
                                                            // revert to previousNofCtus (this was set in selectbox onclick)
                                                        	document.getElementById('studyGradeType.numberOfCardinalTimeUnits').value = previousNofCtus;
                                                        }                                                    

                                                    } else {
                                                    	postFormNoSubmit();
                                                    }
                                                }
                                                
                                                function postFormNoSubmit() {
                                                	// post form (and let server change the cardinal timeunit list).
                                             	   document.getElementById('submitFormObject').value=false;
                                             	   document.gtform.submit();
                                                }

                                                // previousNofCtus value is filled by 'onclick' event (which is fired BEFORE the value change)
                                                var previousNofCtus;
                                                
                                                // Check if any of the rows that are to be removed are already filled out.
                                                function checkSurplusCtusFilled() {

                                                	// nofCtus value is filled after 'onChange' event (which is fired AFTER the value change)    
                                                    var nofCtus = document.getElementById('studyGradeType.numberOfCardinalTimeUnits').value;

                                                    // Only if previousNofCtus > nofCtus
                                                    for (i = nofCtus; i <= previousNofCtus; i++) {

                                                        var idElectiveSubject = 'studyGradeType.cardinalTimeUnitStudyGradeTypes[' + i + '].numberOfElectiveSubjects';
                                                        var idElectiveSubjectBlock = 'studyGradeType.cardinalTimeUnitStudyGradeTypes[' + i + '].numberOfElectiveSubjectBlocks';
                                                        
                                                        if (document.getElementById(idElectiveSubject) != null && document.getElementById(idElectiveSubject).value > 0) {
                                                            return true;
                                                        }

                                                        if (document.getElementById(idElectiveSubjectBlock) != null && document.getElementById(idElectiveSubjectBlock).value > 0) {
                                                            return true;
                                                        }                                                    
                                                    }
                                                    return false;
                                                }
                                            </script>
                                            <select name="${status.expression}" id="${status.expression}" onclick="previousNofCtus=this.value" onchange="changeNumberOfCardinalTimeUnits()">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="1" end="${iMaxCardinalTimeUnits}" var="current">
                                                    <c:choose>
                                                        <c:when test="${status.value == current}">
                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}"><c:out value="${current}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        <!--  MAX NUMBER OF CARDINAL TIME UNITS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.max.numberofcardinaltimeunits" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.maxNumberOfCardinalTimeUnits">
                                            <td>
                                            <select name="${status.expression}" id="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="1" end="${iMaxCardinalTimeUnits}" var="current">
                                                    <c:choose>
                                                        <c:when test="${status.value == current}">
                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}"><c:out value="${current}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        
                                       
                                        <script type="text/javascript">
                                                // previousMaxNumberOfCtus value is filled by 'onclick' event (which is fired BEFORE the value change)
                                                var previousMaxNumberOfCtus;
                                            
                                                function changeMaxNumberOfSubjectsPerCardinalTimeUnit(statusExpression) {
                                                    
                                                    var currentMaxNumberOfCtus = document.getElementById(statusExpression).value;

                                               		// maxNumberOfSubjectsPerCardinalTimeUnit changed:
                                                    if (previousMaxNumberOfCtus > currentMaxNumberOfCtus) {
                                                    	if (statusExpression == 'studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit') {
	                                                        var proceed = confirm('<fmt:message key="jsp.general.electivesubjects.contract.sure" />');
	
	                                                        if (!proceed) {
	                                                            // revert to previousMaxNumberOfCtus (this was set in selectbox onclick)
	                                                            document.getElementById('studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit').value = previousMaxNumberOfCtus;
	                                                        } else {
	                                                        	document.getElementById('studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit').value = currentMaxNumberOfCtus;
	                                                        	document.getElementById('studyGradeType.numberOfSubjectsPerCardinalTimeUnit').value = currentMaxNumberOfCtus;

	                                                        	// lists are adjusted serverside
	                                                            postFormNoSubmit();
	                                                        }
                                                    	} else {

                                                    		// Check MaxNumberOfFailedSubjects dependency:
                                                        	checkMaxNumberOfFailedSubjectsPerCardinalTimeUnit(statusExpression);
                                                            
                                                    		// lists are adjusted serverside
	                                                        postFormNoSubmit();
                                                    	}
                                                    } else {
                                                    	document.getElementById('studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit').value = currentMaxNumberOfCtus;
                                                        // lists are adjusted serverside
                                                        postFormNoSubmit();
                                                    }
                                                	
                                                }
                                        </script>
                                        	
                                        <!--  NUMBER OF SUBJECTS PER CARDINAL TIME UNIT -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofsubjects.cardinaltimeunit" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.numberOfSubjectsPerCardinalTimeUnit">
                                            <td>
                                            <select name="${status.expression}" id="${status.expression}" onclick="previousMaxNumberOfCtus=document.getElementById('studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit').value" onchange="changeMaxNumberOfSubjectsPerCardinalTimeUnit('${status.expression}')">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="1" end="${iMaxSubjectsPerCardinalTimeUnit}" var="current">
                                                    <c:choose>
                                                        <c:when test="${status.value == current}">
                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}"><c:out value="${current}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> 
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        <!--  MAX NUMBER OF SUBJECTS PER CARDINAL TIME UNIT -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.max.numberofsubjects.cardinaltimeunit" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit">
                                            <td>
                                            <select name="${status.expression}" id="${status.expression}" onclick="previousMaxNumberOfCtus=this.value" onchange="changeMaxNumberOfSubjectsPerCardinalTimeUnit('${status.expression}')">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="1" end="${iMaxSubjectsPerCardinalTimeUnit}" var="current">
                                                    <c:choose>
                                                        <c:when test="${status.value == current}">
                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}"><c:out value="${current}"/></option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> 
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!--  MAX NUMBER OF FAILED SUBJECTS PER CARDINAL TIME UNIT -->
                                        
                                        <script type="text/javascript">              

                                            // Use 'statusExpression' in order to prevent hard-coded id's 
                                            function checkMaxNumberOfFailedSubjectsPerCardinalTimeUnit(statusExpression) {

                                            	var maxNumberOfFailedSubjectsPerCardinalTimeUnit = document.getElementById('studyGradeType.maxNumberOfFailedSubjectsPerCardinalTimeUnit').value;
                                                var numberOfSubjectsPerCardinalTimeUnit = document.getElementById(statusExpression).value;                                                

                                                if (maxNumberOfFailedSubjectsPerCardinalTimeUnit > numberOfSubjectsPerCardinalTimeUnit) {
                                                        
                                                    alert('<fmt:message key="jsp.general.max.numberoffailedsubjects.cardinaltimeunit.sure" />');
                                                    document.getElementById('studyGradeType.maxNumberOfFailedSubjectsPerCardinalTimeUnit').value = 0;
                                                }      
                                            }
                                        </script>
                                                                                
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.max.numberoffailedsubjects.cardinaltimeunit" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.maxNumberOfFailedSubjectsPerCardinalTimeUnit">
                                            <td>
                                            
                                            <!-- When numberOfSubjectsPerCardinalTimeUnit already has a value, use it as max for failed subjects -->
                                            <!-- When numberOfSubjectsPerCardinalTimeUnit has no value yet, use config parameter (session) as max for failed subjects -->
                                            <c:choose>                                               
                                               <c:when test="${studyGradeTypeForm.studyGradeType.numberOfSubjectsPerCardinalTimeUnit > 0}">                                                                                        
                                                <select name="${status.expression}" id="${status.expression}">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach begin="1" end="${studyGradeTypeForm.studyGradeType.numberOfSubjectsPerCardinalTimeUnit}" var="current">
                                                        <c:choose>
                                                            <c:when test="${status.value == current}">
                                                               <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${current}"><c:out value="${current}"/></option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>                                            
                                                </c:when>                                                
                                                <c:otherwise>
                                                <select name="${status.expression}" id="${status.expression}">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach begin="1" end="${iMaxFailedSubjectsPerCardinalTimeUnit}" var="current">
                                                        <c:choose>
                                                            <c:when test="${status.value == current}">
                                                               <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${current}"><c:out value="${current}"/></option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>   
                                                </c:otherwise>
                                            </c:choose>                                            
                                            
                                            </td> 
                                            <td> 
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>                                        

                                        <!-- BR's PASSING SUBJECT -->
                                        <c:choose>
                                        	<c:when test="${studyGradeTypeForm.endGradesPerGradeType == 'N'}">
		                                        <tr>
		                                            <td class="label"><fmt:message key="jsp.general.brspassing" /> <fmt:message key="jsp.general.subjects" /></td>
		                                            <spring:bind path="studyGradeTypeForm.studyGradeType.BRsPassingSubject">
		                                            <td>
		                                            <input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" /></td>
		                                            <td>
		                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
		                                            </td>
		                                            </spring:bind>
		                                        </tr>
		                                    </c:when>
		                                </c:choose>

                                        <!--  MAX NUMBER OF STUDENTS -->
                                        <c:if test="${modules != null && modules != ''}">
                                            <c:forEach var="module" items="${modules}">
                                                <c:if test="${fn:toLowerCase(module.module) == 'admission'}">
                                                    <tr>
                                                        <td class="label"><fmt:message key="jsp.general.max.numberofstudents" /></td>
                                                        <spring:bind path="studyGradeTypeForm.studyGradeType.maxNumberOfStudents"> 
	                                                        <td>
	                                                            <input type="text" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" />
	                                                        </td> 
	                                                        <td>
	                                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
	                                                        </td>
                                                        </spring:bind>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        
                                        <!--  DISCIPLINE GROUP -->
                                        <c:if test="${modules != null && modules != ''}">
                                            <c:forEach var="module" items="${modules}">
                                                <c:if test="${fn:toLowerCase(module.module) == 'fee'}">
                                                    <c:if test="${gradeTypeIsMaster}">
                                                    <tr>
                                                        <td class="label"><fmt:message key="jsp.general.disciplinegroup" /></td>
                                                        <spring:bind path="studyGradeTypeForm.studyGradeType.disciplineGroupCode"> 
                                                        <td>
                                                            <select name="${status.expression}" id="${status.expression}">
                                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:forEach var="oneGroup" items="${studyGradeTypeForm.allDisciplineGroups}">
                                                                    <c:choose>
                                                                        <c:when test="${status.value == oneGroup.code}">
                                                                           <option value="${oneGroup.code}" selected="selected"><c:out value="${oneGroup.description}"/></option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${oneGroup.code}"><c:out value="${oneGroup.description}"/></option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                            </td> 
                                                            <td> 
                                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                                </c:forEach>
                                                            </td>
                                                        </spring:bind>
                                                    </tr>
                                                    </c:if>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        
                                        <!--  CONTACT -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.contact" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.contactId"> 
                                            <td>
                                            <select name="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="contact" items="${studyGradeTypeForm.allContacts}">
                                                    <c:set var="contactText">${contact.surnameFull}, ${contact.firstnamesFull}</c:set>
                                                    <c:choose>
                                                        <c:when test="${contact.personId == status.value}">
                                                            <option value="${contact.personId}"  selected="selected"><c:out value="${contactText}"/></option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${contact.personId}"><c:out value="${contactText}"/></option>
                                                        </c:otherwise>
                                                    </c:choose> 
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        <!--  ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="studyGradeTypeForm.studyGradeType.active">
                                            <td>
                                            <select name="${status.expression}">
                                                <c:choose>
                                                    <c:when test="${'Y' == status.value}">
                                                        <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                        <option value="N"><fmt:message key="jsp.general.no" /></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                        <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                                    </c:otherwise>
                                                   </c:choose>
                                            </select>
                                            </td>
                                            <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- CARDINALTIMEUNITS FOR STUDYGRADETYPE -->
                                        <c:if test="${studyGradeTypeForm.studyGradeType.cardinalTimeUnitStudyGradeTypes != null}">               
											<tr><td colspan="3">&nbsp;</td></tr>
											<tr>
	                                            <td class="header" colspan="3">
	                                            <fmt:message key="jsp.general.electivesubjects" />
	                                             <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                                                    &nbsp;<fmt:message key="jsp.general.and" />&nbsp;<fmt:message key="jsp.general.electivesubjectblocks" />
	                                                </c:if>
	                                            </td>
	                                            
	                                        </tr>
	                                        <tr><td colspan="3">
	                                            <table class="tabledata2" id="TblData2_cardinalTimeUnitStudyGradeType">   
	                                            <tr>
	                                                <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
	                                                <th><fmt:message key="jsp.general.electivesubjects" /></th>
	                                                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                                                    <th><fmt:message key="jsp.general.electivesubjectblocks" /></th>
	                                                </c:if>
	                                            </tr>                                        
	                                       
	                                            <c:forEach var="cardinalTimeUnitStudyGradeType" items="${studyGradeTypeForm.studyGradeType.cardinalTimeUnitStudyGradeTypes}" varStatus="rowIndex">                                        
	                                                <tr>
	                                                    <td> &nbsp;
	                                                        <input type="hidden" id="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].id" name="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].id" value="<c:out value="${cardinalTimeUnitStudyGradeType.id}" />" />
	                                                        <input type="hidden" id="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].studyGradeTypeId" name="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].studyGradeTypeId" value="<c:out value="${cardinalTimeUnitStudyGradeType.studyGradeTypeId}" />" />
	                                                        <input type="hidden" id="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].cardinalTimeUnitNumber" value="<c:out value="${cardinalTimeUnitStudyGradeType.cardinalTimeUnitNumber}" />" />                                                
	                                                        <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}" >
	                                                             <c:choose>
	                                                                 <c:when test="${cardinalTimeUnit.code == commandCardinalTimeUnitCode}" >
	                                                                     <c:out value="${cardinalTimeUnit.description}"/>
	                                                                 </c:when>
	                                                             </c:choose>
	                                                        </c:forEach>
	                                                        <c:out value="${cardinalTimeUnitStudyGradeType.cardinalTimeUnitNumber}"/>
	                                                    </td>                                                                                                     
	                                                    <td>
	                                                        <c:choose>
	                                                        <c:when test="${editStudyGradeTypes}">
	    
	                                                            <select name="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].numberOfElectiveSubjects"
	                                                                    id="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].numberOfElectiveSubjects" 
	                                                                    style="width : 60px;">
	                                                                <c:forEach begin="0" end="${studyGradeTypeForm.studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit}" var="current">
	                                                                    <c:choose>
	                                                                        <c:when test="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjects == current}">
	                                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            <option value="${current}"><c:out value="${current}"/></option>
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </c:forEach>
	                                                            </select>
	                                                            
	                                                        </c:when>  
	                                                        <c:otherwise>                                            
	                                                            <c:out value="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjects}"/>
	                                                        </c:otherwise>
	                                                        </c:choose>
	                                                    </td>
	                                                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
		                                                    <td>                                                
		                                                        <c:choose>
		                                                        <c:when test="${editStudyGradeTypes}">
		    
		                                                            <select name="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].numberOfElectiveSubjectBlocks"
		                                                                    id="studyGradeType.cardinalTimeUnitStudyGradeTypes[${rowIndex.index}].numberOfElectiveSubjectBlocks" 
		                                                                    style="width : 60px;">
		                                                                <c:forEach begin="0" end="${studyGradeTypeForm.studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit}" var="current">
		                                                                    <c:choose>
		                                                                        <c:when test="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjectBlocks == current}">
		                                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
		                                                                        </c:when>
		                                                                        <c:otherwise>
		                                                                            <option value="${current}"><c:out value="${current}"/></option>
		                                                                        </c:otherwise>
		                                                                    </c:choose>
		                                                                </c:forEach>
		                                                            </select>
		                                                            
		                                                        </c:when>  
		                                                        <c:otherwise>
		                                                            <c:out value="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjectBlocks}"/>
		                                                        </c:otherwise>
		                                                        </c:choose>
		                                                    </td>
	                                                    </c:if>
	                                                </tr>
	                                            </c:forEach>
	                                            </table>
	    
	                                            <script type="text/javascript">alternate('TblData2_cardinalTimeUnitStudyGradeType',true);</script>
	                                        
	                                        </td></tr>
                                        </c:if>                                                                            

                                    <tr><td class="label">&nbsp;</td><td align="right"><input type="submit" value="<fmt:message key="jsp.button.submit" />" /></td><td></td></tr>

                                    <!-- secondary school subjects: it only makes sense to show this part when at least one sec.subject can be selected -->
                                    <c:if test="${studyGradeTypeId != 0 && appConfigManager.secondarySchoolSubjectsCount > 0}">

                                        <!-- SECONDARY SCHOOL SUBJECT GROUPS (only for BSC and BA studygradetypes)-->
                                        <c:if test="${gradeTypeIsBachelor}">

                                            <tr><td colspan="3"><br /><hr /></td></tr>
                                            <tr>
                                                <td class="header" colspan="2">
                                                <fmt:message key="jsp.general.secondaryschoolsubjects" /> (<fmt:message key="jsp.register" />)
                                                </td>
                                                <td align="right">
                                                    <a class="button" href="<c:url value='/college/studygradetypesecondaryschoolsubjects.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">

                                                <table class="tabledata2" id="secondarySchoolSubjectGroupTblData">
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.secondaryschoolsubjects.min" /></th>
                                                        <th><fmt:message key="jsp.general.secondaryschoolsubjects.max" /></th>
                                                        <th><fmt:message key="jsp.general.secondaryschoolsubjects.group" /></th>
                                                        <th></th>
                                                    </tr>    
                                                    <c:forEach var="secondarySchoolSubjectGroup" items="${studyGradeTypeForm.allSecondarySchoolSubjectGroups}">
                                                    <tr>
                                                        <td><c:out value="${secondarySchoolSubjectGroup.minNumberToGrade}"/></td>
                                                        <td><c:out value="${secondarySchoolSubjectGroup.maxNumberToGrade}"/></td>
                                                        <td> 
                                                        <c:forEach var="secondarySchoolSubject" items="${secondarySchoolSubjectGroup.secondarySchoolSubjects}" varStatus="status">
                                                            <c:out value="${secondarySchoolSubject.description}"/><c:if test="${not status.last}">,</c:if>  
                                                        </c:forEach>
                                                        </td>                                                        
                                                        <td align="right"> 
                                                             <a href="<c:url value='/college/studygradetypesecondaryschoolsubjects.view?editExistingGroup=true&amp;groupId=${secondarySchoolSubjectGroup.id}&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a> &nbsp;
                                                             <a href="<c:url value='/college/studygradetypesecondaryschoolsubjects.view?deleteSecondarySchoolSubjectGroup=true&amp;groupId=${secondarySchoolSubjectGroup.id}&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.general.secondaryschoolsubjects.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                        </td>                                                    
                                                    </tr>
                                                    </c:forEach>

                                                </table>
                                                <script type="text/javascript">alternate('secondarySchoolSubjectGroupTblData',true)</script>

                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:if>

                                    <%-- end hiding RFCs for Milestone 3.3    
                                    <!-- rfc list and button -->
                                    <c:if test="${studyGradeTypeId != 0}">
                                        <tr><td colspan="3"><br /><hr /></td></tr>
                                    
                                        <tr>
                                            <td colspan="2" class="header"><fmt:message key="jsp.general.rfc.header" /></td>
                                            <td align="right">
                                            <c:choose>
                                            <c:when test="${editStudyGradeTypeRFC || createStudyGradeTypeRFC}">
                                                <a href="#" class="button" onclick="showHideAll();return false;" style="margin-bottom : 4px;"/><fmt:message key="jsp.href.add" /> <fmt:message key="jsp.general.rfc" /></a>&nbsp;
                                            </c:when>
                                            </c:choose>
                                            </td>    
                                        </tr>
                                        
                                        <tr>
                                            <td colspan="3">&nbsp;
                                            
                                                <table class="tabledata2" id="TblData2_RfcList">   
                                                <tr>
                                                    <th><fmt:message key="jsp.general.rfc" /></th>
                                                    <th><fmt:message key="jsp.general.rfc.comments" /></th>
                                                    <th> &nbsp;<fmt:message key="jsp.general.status" /></th>
                                                </tr>                                        
                                           
                                                <c:forEach var="rfc" items="${studyGradeTypeForm.rfcs}" varStatus="rowIndex">                                        
                                                    <tr>
                                                        <td> ${rfc.text} </td>
                                                        <td> 
                                                        <input type="hidden" id="rfcs[${rowIndex.index}].id" value="<c:out value="${rfc.id}" />" />
                                                        
                                                        <c:choose>
                                                        <c:when test="${editStudyGradeTypeRFC}">
                                                            <textarea id="rfcs[${rowIndex.index}].comments" name="rfcs[${rowIndex.index}].comments" rows="2"  
                                                                  cols="35" style="border: 1px solid #666; margin-bottom : 2px;">${rfc.comments}</textarea>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${rfc.comments}
                                                        </c:otherwise>
                                                        </c:choose>
                                                        
                                                        </td>
                                                        <td> &nbsp;
                                                        <c:choose>
                                                        <c:when test="${editStudyGradeTypeRFC}">
                                                           <select name="rfcs[${rowIndex.index}].statusCode" id="rfcs[${rowIndex.index}].statusCode" width="120" style="width: 120px">                                                                   
                                                               <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                               <c:forEach var="status" items="${allRfcStatuses}">
                                                                   <c:choose>
                                                                       <c:when test="${rfc.statusCode == status.code}">
                                                                           <option value="${status.code}" selected="selected">${status.description}</option>
                                                                       </c:when>
                                                                       <c:otherwise>
                                                                        <option value="${status.code}">${status.description}</option>
                                                                       </c:otherwise>
                                                                   </c:choose>
                                                               </c:forEach>
                                                           </select>
                                                         </c:when>
                                                        <c:otherwise>
                                                             <c:forEach var="status" items="${allRfcStatuses}">
                                                               <c:choose>
                                                                   <c:when test="${rfc.statusCode == status.code}">
                                                                       ${status.description}
                                                                   </c:when>
                                                               </c:choose>
                                                           </c:forEach>
                                                        </c:otherwise>
                                                        </c:choose>
                                                        </td>
                                                    </tr>                                                  
                                                </c:forEach>                                                    
                                                </table>                                                        
                                                <script type="text/javascript">alternate('TblData2_RfcList',true);</script>
                                                
                                                <input type="hidden" name="rfclistsave" id="rfclistsave" value="false" />
                                                <script type="text/javascript" type="text/javascript">

                                                        // init again:
                                                        document.getElementById('rfclistsave').value = "false";
    
                                                        function saveRfcList() {
                                                            document.getElementById('rfclistsave').value = "true";
                                                            document.gtform.submit();                                                       
                                                        }
                                                 </script>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="right">
                                            <c:choose>
                                                <c:when test="${editStudyGradeTypeRFC}">
                                                <input type='submit' onclick="saveRfcList()" value='<fmt:message key="jsp.button.submit" /> <fmt:message key="jsp.general.rfcs" />' />
                                                </c:when>
                                            </c:choose>                                                      
                                        	</td>
                                        </tr>
                                        <spring:bind path="studyGradeTypeForm.rfc.text">
                                        <tr>
                                            <td colspan="3">
                                                <span class="more" id="rfcheader"><fmt:message key="jsp.general.requestforchange.add"/></span>
                                                <input type="hidden" name="rfcsave" id="rfcsave" value="false" />
                                                <textarea id="${status.expression}" name="${status.expression}" class="more" rows="6" cols="70" style="border: 1px solid #666; margin-bottom : 6px;">${status.value}</textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="right">                                                            
                                                <input class="more" id="showHideButton" value="<fmt:message key="jsp.button.submit" />" name="save" onclick="saveRfc()" type='submit' value='<fmt:message key="button.submit" />' />

                                                <script type="text/javascript" type="text/javascript">

                                                    // init again:
                                                    document.getElementById('rfcsave').value = "false";

                                                    function showHideAll() {
                                                        showHide('${status.expression}');
                                                        showHide('showHideButton');
                                                        showHide('rfcheader');
                                                    }

                                                    function saveRfc() {
                                                        document.getElementById('rfcsave').value = "true";
                                                        document.gtform.submit();                                                       
                                                    }
                                                </script>
                                            </td>
                                        </tr>
                                        </spring:bind>
                                      </c:if>
                                    end hiding RFCs for Milestone 3.3 --%>
                                                                            
                                    <!-- don't show subjects and prerequisites when inserting a new studyGradeType -->
                                    <c:if test="${studyGradeTypeId != 0}">
                                       
                                       <tr><td colspan="3"><br /><hr /></td></tr>
                                    
                                        <c:choose>        
                                            <c:when test="${ not empty showStudyGradeTypeSubjectError }">       
                                               <tr>
                                                   <td align="left" class="error" colspan="3">
                                                      <c:out value="${showStudyGradeTypeSubjectError}"/>
                                                    </td>
                                               </tr>
                                           </c:when>
                                        </c:choose>
                                           
                                        <!-- SUBJECTs FOR STUDYGRADETYPE -->
                                        <tr>
                                            <td class="header" colspan="2"><fmt:message key="jsp.general.subjectstudygradetype" /></td>
                                            <td align="right">
                                                <a class="button" href="<c:url value='/college/studygradetypesubject.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <table class="tabledata2" id="TblData2_studygradetypesubjects">

                                                <tr>
                                                    <th><fmt:message key="jsp.general.code" /></th>
                                                    <th><fmt:message key="jsp.general.subject" /></th>

                                                    <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}" >
                                                            <c:choose>
                                                            	<c:when test="${cardinalTimeUnit.code == commandCardinalTimeUnitCode}" >
                                                    				<th><c:out value="${cardinalTimeUnit.description}"/></th>
                                                    			</c:when>
                                                    		</c:choose>
                                                   	</c:forEach>
                                                   	<th><fmt:message key="jsp.subject.rigiditytype" /></th>
                                                    <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                        <th><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></th>
                                                    </c:if>
                                                    <th>&nbsp;</th>
                                                </tr>
                                                    <c:forEach var="oneSubjectStudyGradeType" items="${studyGradeTypeForm.studyGradeType.subjectsStudyGradeType}">
                                                        <c:set var="subject" value="${oneSubjectStudyGradeType.subject}" />
<%--                                                         <c:forEach var="subject" items="${studyGradeTypeForm.allSubjects}" > --%>
<%--                                                             <c:choose> --%>
<%--                                                                 <c:when test="${subject.id == oneSubjectStudyGradeType.subjectId}" > --%>
                                                                    <tr>
                                                                        <td><c:out value="${subject.subjectCode}"/></td>
                                                                        <c:set var="subjectString">
                                                                            <fmt:message key="format.primarystudydescription.subjectdescription.academicyear.studytime">
                                                                                <fmt:param value="${subject.primaryStudy.studyDescription}" />
                                                                                <fmt:param value="${subject.subjectDescription}" />
                                                                                <fmt:param value="${studyGradeTypeForm.idToAcademicYearMap[subject.currentAcademicYearId].description}" />
                                                                                <fmt:param value="${studyGradeTypeForm.codeToStudyTimeMap[subject.studyTimeCode].description}" />
                                                                            </fmt:message>
                                                                        </c:set>
                                                                        <td>
                                                                        	<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectId=${subject.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>">
<%--                                                                         		${subject.subjectDescription } --%>
                                                                                <c:out value="${subjectString}"/>
                                                                        	</a>
                                                                        </td>
                                                                        <td>
                                                                        <c:choose>
                                                                            <c:when test="${oneSubjectStudyGradeType.cardinalTimeUnitNumber != '0' }">
                                                                            <c:out value="${oneSubjectStudyGradeType.cardinalTimeUnitNumber}"/>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <fmt:message key="jsp.general.any" />
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        </td>
                                                                        <td>
                                                                        
 																		<c:forEach var="rigidityType" items="${allRigidityTypes}">
			                                                    			<c:choose>
			                                                        			<c:when test="${rigidityType.code == oneSubjectStudyGradeType.rigidityTypeCode}">
			                                                            			${rigidityType.description}
			                                                        			</c:when>
			                                                    			</c:choose>
			                                        					</c:forEach>                                                                        
                                                                        </td>
                                                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
	                                                                        <td>
	                                                                        <c:forEach var="importanceType" items="${allImportanceTypes}">
	                                                                            <c:choose>
	                                                                                <c:when test="${importanceType.code == oneSubjectStudyGradeType.importanceTypeCode}">
	                                                                                    <c:out value="${importanceType.description}"/>
	                                                                                </c:when>
	                                                                            </c:choose>
	                                                                        </c:forEach> 
	                                                                        </td>        
                                                                        </c:if>
                                                                        <td align="right">
                                                                 			<%-- <a href="<c:url value='/college/studygradetypesubject.view?tab=0&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectStudyGradeType.id}&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a> --%>
                                                                        	&nbsp;&nbsp;&nbsp;<a href="<c:url value='/college/studygradetypesubject_delete.view?newForm=true&amp;tab=1&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectStudyGradeType.id}&amp;subjectId=${subject.id}&amp;studyId=${studyGradeTypeForm.study.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"  
                                                                        onclick="return confirm('<fmt:message key="jsp.subjects.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                        </td>
                                                                    </tr>
<%--                                                                 </c:when> --%>
<%--                                                             </c:choose> --%>
<%--                                                         </c:forEach> --%>
                                                    </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('TblData2_studygradetypesubjects',true)</script>
                                                </td>
                                                </tr>
<%--                                            <tr><td>&nbsp;</td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr> --%>
                                        
                                    <!-- end of only show subjectStudyGradeType parts, if studyGradeType exists -->

                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                            <c:if test="${ not empty showSubjectBlockStudyGradeTypeError }">       
                                               <tr>
                                                   <td align="left" class="error" colspan="3">
                                                      <c:out value="${showSubjectBlockStudyGradeTypeError}"/>
                                                    </td>
                                               </tr>
                                            </c:if>
                                        </c:if>
                                        
                                        
                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                        <!-- SUBJECTBLOCK STUDYGRADETYPES -->
                                        <tr>
                                            <td class="header" colspan="2" ><fmt:message key="jsp.general.subjectblockstudygradetype" /></td>
                                            <td align="right">
                                                <a class="button" href="<c:url value='/college/studygradetypesubjectblock.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;gradeTypeCode=${gradeTypeCode}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <table class="tabledata2" id="TblData2_subjectblocksstudygradetype">

                                                    <tr>
                                                        <th><fmt:message key="jsp.general.code" /></th>
                                                        <th><fmt:message key="jsp.general.subjectblock" /></th>
                                                        <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}" >
                                                                <c:choose>
                                                                	<c:when test="${cardinalTimeUnit.code == commandCardinalTimeUnitCode}" >
                                                        			<th><c:out value="${cardinalTimeUnit.description}"/></th>
                                                        			</c:when>
                                                        		</c:choose>
                                                       	</c:forEach>
                                                       	<th><fmt:message key="jsp.subject.rigiditytype" /></th>
                                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                            <th><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></th>
                                                        </c:if>
                                                        <th>&nbsp;</th>
                                                    </tr>
                                                    <c:forEach var="oneSubjectBlockStudyGradeType" items="${studyGradeTypeForm.studyGradeType.subjectBlocksStudyGradeType}">
                                                        <c:set var="subjectBlock" value="${oneSubjectBlockStudyGradeType.subjectBlock}" />

<%--                                                         <c:forEach var="subjectBlock" items="${studyGradeTypeForm.allSubjectBlocks}" > --%>
<%--                                                             <c:choose> --%>
<%--                                                                 <c:when test="${subjectBlock.id == oneSubjectBlockStudyGradeType.subjectBlock.id}" > --%>
                                                                    <tr>
                                                                        <td><c:out value="${subjectBlock.subjectBlockCode}"/></td>
                                                                        <%-- show primary study of subject block, otherwise it's hard to see if it originates from a different study --%>
                                                                        <c:set var="subjectBlockString">
                                                                            <fmt:message key="format.primarystudydescription.subjectblockdescription.academicyear.studytime">
                                                                                <fmt:param value="${subjectBlock.primaryStudy.studyDescription}" />
                                                                                <fmt:param value="${subjectBlock.subjectBlockDescription}" />
                                                                                <fmt:param value="${studyGradeTypeForm.idToAcademicYearMap[subjectBlock.currentAcademicYearId].description}" />
                                                                                <fmt:param value="${studyGradeTypeForm.codeToStudyTimeMap[subjectBlock.studyTimeCode].description}" />
                                                                            </fmt:message>
                                                                        </c:set>
                                                                        <td>
                                                                        	<a href="<c:url value='/college/subjectblock.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectBlockId=${subjectBlock.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>">
<%--                                                                         	${subjectBlock.subjectBlockDescription } --%>
                                                                                <c:out value="${subjectBlockString}"/>
                                                                        	</a>
                                                                        </td>
                                                                        <td>
                                                                        <c:choose>
                                                                            <c:when test="${oneSubjectBlockStudyGradeType.cardinalTimeUnitNumber != '0' }">
                                                                                <c:out value="${oneSubjectBlockStudyGradeType.cardinalTimeUnitNumber}"/>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <fmt:message key="jsp.general.any" />
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        </td>
                                                                        <td>
                                                                        
 																		<c:forEach var="rigidityType" items="${allRigidityTypes}">
			                                                    			<c:choose>
			                                                        			<c:when test="${rigidityType.code == oneSubjectBlockStudyGradeType.rigidityTypeCode}">
			                                                            			<c:out value="${rigidityType.description}"/>
			                                                        			</c:when>
			                                                    			</c:choose>
			                                        					</c:forEach>                                                                        
                                                                        </td>
                                                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                                            <td>
                                                                            <c:forEach var="importanceType" items="${allImportanceTypes}">
                                                                                <c:choose>
                                                                                    <c:when test="${importanceType.code == oneSubjectBlockStudyGradeType.importanceTypeCode}">
                                                                                        <c:out value="${importanceType.description}"/>
                                                                                    </c:when>
                                                                                </c:choose>
                                                                            </c:forEach> 
                                                                            </td>        
                                                                        </c:if>
                                                                        <td align="right">
  				                        									<%-- <a href="<c:url value='/college/studygradetypesubjectblock.view?tab=0&panel=0&subjectBlockStudyGradeTypeId=${oneSubjectBlockStudyGradeType.id}&studyGradeTypeId=${studyGradeTypeId}&primaryStudyId=${studyGradeTypeForm.study.id}&gradeTypeCode=${gradeTypeCode}&currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a> --%>
                                                                      		&nbsp;&nbsp;&nbsp;<a href="<c:url value='/college/studygradetypesubjectblock_delete.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectBlockStudyGradeTypeId=${oneSubjectBlockStudyGradeType.id}&amp;studyGradeTypeId=${studyGradeTypeId}&amp;subjectBlockId=${subjectBlock.id}&amp;studyId=${studyGradeTypeForm.study.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"  
                                                                        onclick="return confirm('<fmt:message key="jsp.subjectblocks.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>                                                                        
                                                                        </td>
                                                                    </tr>
<%--                                                                 </c:when> --%>
<%--                                                             </c:choose> --%>
<%--                                                         </c:forEach> --%>
                                                    </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('TblData2_subjectblocksstudygradetype',true)</script>
                                                </td>
                                            </tr>
                                            
<%--                                            <tr><td>&nbsp;</td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </tr> --%>
                                            </c:if>
                                            
                                        <!-- Prerequisites for StudyGradeType -->
                                        <tr><td colspan="3">&nbsp;</td></tr>
                                        <tr><td colspan="3"><br /><hr /></td></tr>
                                        <tr>
                                            <td colspan="2" class="header"><fmt:message key="jsp.general.studygradetypeprerequisites" /></td>
                                            <td align="right">
                                                <a class="button" href="<c:url value='/college/studygradetypeprerequisite.view?newForm=true&amp;tab=0&amp;panel=0&amp;from=studygradetype&amp;studyGradeTypeId=${studyGradeTypeId}&amp;primaryStudyId=${studyGradeTypeForm.study.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <table class="tabledata2" id="TblData2_prerequisites">
                                                <tr>
                                                    <th><fmt:message key="jsp.general.study" /></th>
                                                    <th ><fmt:message key="jsp.general.gradetypeallover" /></th>
                                                    <th>&nbsp;</th>
                                                </tr>
                                                <spring:bind path="studyGradeTypeForm.studyGradeType.studyGradeTypePrerequisites">
                                                    <c:forEach var="oneStudyGradeType" items="${status.value}">
                                                        <c:set var="study" value="${oneStudyGradeType.study}" />
<%--                                                         <c:forEach var="study" items="${studyGradeTypeForm.allStudies}" > --%>
<%--                                                             <c:choose> --%>
<%--                                                                 <c:when test="${study.id == oneStudyGradeType.requiredStudyId}" > --%>
                                                                    <tr>
                                                                        <td><c:out value="${study.studyDescription}"/></td>
                                                                        <td>
                                                                            <c:forEach var="gradeType" items="${allGradeTypes}">
                                                                                <c:choose>
                                                                                    <c:when test="${oneStudyGradeType.requiredGradeTypeCode == gradeType.code}">
                                                                                        <c:out value="${gradeType.description}"/>
                                                                                    </c:when>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </td>
                                                                        <td align="right">
                                                                        &nbsp;&nbsp;&nbsp;<a href="<c:url value='/college/studygradetypeprerequisite_delete.view?newForm=true&amp;tab=1&amp;panel=0&amp;from=studygradetype&amp;requiredStudyId=${oneStudyGradeType.requiredStudyId}&amp;requiredGradeTypeCode=${oneStudyGradeType.requiredGradeTypeCode}&amp;studyGradeTypeId=${studyGradeTypeId }&amp;studyId=${studyGradeTypeForm.study.id}&amp;currentPageNumber=${studyGradeTypeForm.navigationSettings.currentPageNumber}'/>"  
                                                                        onclick="return confirm('<fmt:message key="jsp.studygradetypeprerequisite.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                        </td>
                                                                    </tr>
<%--                                                                 </c:when> --%>
<%--                                                             </c:choose> --%>
<%--                                                         </c:forEach> --%>
                                                    </c:forEach>
                                                </spring:bind>
                                                </table>
                                                <script type="text/javascript">alternate('TblData2_prerequisites',true)</script>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                        <!-- end  -->
                                        
                                            <!-- end of only show added lists, if studyGradeType exists -->

                                        </c:if>
                                </table>

                                </form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                        </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

