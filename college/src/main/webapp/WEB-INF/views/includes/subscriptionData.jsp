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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:set var="form" value="${studentForm}" />

<div class="AccordionPanel">
    <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.studyplans" /></div>
    <div class="AccordionPanelContent">
        
<%--         <c:choose>        
            <c:when test="${ not empty studentForm.txtErr }">       
               <p align="left" class="error">
                    <fmt:message key="jsp.error.studyplan.delete" /> ${studentForm.txtErr}
               </p>
            </c:when>
        </c:choose>--%>

        <form:form method="post" modelAttribute="studentForm.studentFormShared">
<%--        <input type="hidden" name="tab_studyplan" value="${accordion}" />
        <input type="hidden" name="panel_studyplan" value="0" />
        <input type="hidden" name="submitFormObject_studyplandata" id="submitFormObject_studyplandata" value="" /> --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="0" />
        <table>

            <tr>
                <td class="label"><fmt:message key="jsp.general.dateofenrolment" /></td>
                <spring:bind path="student.dateOfEnrolment">
                <td class="required">
                 <table>
                    <tr>
                        <td><fmt:message key="jsp.general.day" /></td>
                        <td><fmt:message key="jsp.general.month" /></td>
                        <td><fmt:message key="jsp.general.year" /></td>
                    </tr>
                    <c:if test="${editSubscriptionData}">
                    
	                     <tr>
	                        <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="${status.value}" />
                                <input type="text" id="enrolment_day" name="enrolment_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('studentFormShared.student.dateOfEnrolment','day',document.getElementById('enrolment_day').value);"  /></td>
	                        <td><input type="text" id="enrolment_month" name="enrolment_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentFormShared.student.dateOfEnrolment','month',document.getElementById('enrolment_month').value);" /></td>
	                        <td><input type="text" id="enrolment_year" name="enrolment_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('studentFormShared.student.dateOfEnrolment','year',document.getElementById('enrolment_year').value);" /></td>
	                    </tr>
	                </c:if>
	                <c:if test="${showSubscriptionData}">
	                   <tr>
                            <td>${fn:substring(status.value,8,10)}</td>
                            <td>${fn:substring(status.value,5,7)}</td>
                            <td>${fn:substring(status.value,0,4)}</td>
                        </tr>
	                </c:if>
                 </table>
                 </td>
                 <td>
                     <fmt:message key="jsp.general.message.dateformat" />
                     <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                 </td>
                     </spring:bind>
            </tr>
            
            <tr>
                <td class="label"><fmt:message key="jsp.general.subscriptionrequirements.fulfilled" /></td>
<%--                 <spring:bind path="student.subscriptionRequirementsFulfilled"> --%>
                <c:if test="${editSubscriptionData}">
	                <td>
                        <form:select path="student.subscriptionRequirementsFulfilled">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:option value="N">
                                <spring:message code="jsp.general.no" />
                            </form:option>
                            <form:option value="Y">
                                <spring:message code="jsp.general.yes" />
                            </form:option>
                        </form:select>
<%--                        <c:choose>
	                            <c:when test="${'Y' == status.value}">
	                                <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
	                                <option value="N"><fmt:message key="jsp.general.no" /></option>
	                            </c:when>
	                            <c:otherwise>
	                                <option value="Y"><fmt:message key="jsp.general.yes" /></option>
	                                <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
	                            </c:otherwise>
	                           </c:choose>
	                    </select> --%>
	                </td>
	            </c:if>
	            <c:if test="${showSubscriptionData}">
                    <c:choose>
                        <c:when test="${'Y' == status.value}">
                            <td><fmt:message key="jsp.general.yes" /></td>
                        </c:when>
                        <c:otherwise>
                            <td><fmt:message key="jsp.general.no" /></td>
                        </c:otherwise>
                    </c:choose>
                    <td></td>
                </c:if>
                <td><form:errors cssClass="error" path="student.subscriptionRequirementsFulfilled"/></td>
<%--                 </spring:bind> --%>
            </tr>
            
            <spring:bind path="student.scholarship">
            <tr>
                <td class="label"><fmt:message key="jsp.general.scholarship.appliedfor" /></td>
                <td>
                    <c:choose>
                            <c:when test="${'Y' == status.value}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                    </c:choose>
                    <c:if test="${editSubscriptionData}">
	                    &nbsp;&nbsp;&nbsp;
	                    <b>
	                    <c:choose>
	                        <c:when test="${modules != null && modules != ''}">
	                            <c:forEach var="module" items="${modules}">
	                                <c:choose>
	                                    <c:when test="${fn:toLowerCase(module.module) == 'scholarship'}">
	                                        <c:set var="scholarshipModulePresent" value="Y" scope="page" />
	                                        <a href="<c:url value='/scholarship/scholarshipstudent.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${studentId}'/>"><fmt:message key="jsp.general.edit" /> <fmt:message key="jsp.general.scholarship" /> <fmt:message key="jsp.menu.student" /></a>
	                                    </c:when>
	                                </c:choose>
	                            </c:forEach>
	                        </c:when>
	                    </c:choose>
	                    <c:choose>
	                        <c:when test="${scholarshipModulePresent != 'Y'}">
	                            <fmt:message key="jsp.general.alter.scholarships" />:<br /><fmt:message key="jsp.general.implement.scholarshipsmodule" /> (<fmt:message key="jsp.general.contact.administrator" />)
	                        </c:when>
	                    </c:choose>
	                   </b>
	                </c:if>
                </td>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                </td>
                </tr>
                </spring:bind>
                
                <c:if test="${editSubscriptionData}">
                    <tr>
                        <td class="label">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td><input type="button" name="submitstudyplandata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
                    </tr>
               </c:if>
           </table>
           </form:form>

<%--             <tr> --%>
            <table>
                <tr>
                    <td class="header">
                        <fmt:message key="jsp.general.studentstatus" />
                    </td>
                    <td colspan="2" align="right">
                        <c:if test="${editSubscriptionData}">
                            <a class="button" href="<c:url value='/college/studentstudentstatus.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <table class="tabledata2" id="TblData2_studentstatuses">
                        <tr>
                            <th><fmt:message key="jsp.general.startdate" /></th>
                            <th><fmt:message key="jsp.general.studentstatus" /></th>
                            <th/>
                        </tr>
                        <c:forEach var="studentStudentStatus" items="${student.studentStudentStatuses}">
                            <tr>
                                <td>
	                                <c:if test="${editSubscriptionData}">
	                                    <a href="<c:url value='/college/studentstudentstatus.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${studentId}&studentStudentStatusId=${studentStudentStatus.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	                                    <fmt:formatDate value="${studentStudentStatus.startDate}" pattern="dd/MM/yyyy"/>
	                                    </a>
	                                </c:if>
	                                <c:if test="${showSubscriptionData}">
	                                    <fmt:formatDate value="${studentStudentStatus.startDate}" pattern="dd/MM/yyyy"/>
	                                </c:if>
                                </td>
                                <td>
                                    <c:out value="${webLookups.map['studentStatus'][studentStudentStatus.studentStatusCode].description}"/>
                                </td>
                                <td class="buttonsCell">
	                                <c:if test="${editSubscriptionData}">
		                                <a class="imageLink" href="<c:url value='/college/studentstudentstatus.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${studentId}&studentStudentStatusId=${studentStudentStatus.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
		                                    <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
		                                </a>
		                                <a class="imageLinkPaddingLeft" href="<c:url value='/college/studentstudentstatus_delete.view'/>?<c:out value='tab=2&panel=0&studentId=${studentId}&studentStudentStatusId=${studentStudentStatus.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studentstudentstatus.delete.confirm" />')">
		                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
		                                </a>
		                            </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </table>
                        <script type="text/javascript">alternate('TblData2_studentstatuses',true)</script>
                    </td>
                </tr>

                <!--  STUDYPLANS -->
                <tr><td colspan="3">&nbsp;</td></tr>
                <c:choose>        
                    <c:when test="${ not empty showStudyPlanError }">       
                       <tr>
                           <td align="left" colspan="3">
                               <p class="error">
                                   <fmt:message key="jsp.error.studyplan.delete" />
                                   <c:out value="${showStudyPlanError}"/>
                               </p>
                            </td>
                       </tr>
                   </c:when>
                </c:choose>

                <tr>
                    <td class="header" colspan="2"><fmt:message key="jsp.general.studyplans" />
                        <c:choose>
                            <c:when test="${not empty student.studyPlans}">
                                &nbsp;
                                <a class="button" href="<c:url value='/college/studyplanresult.view'/>?<c:out value='newForm=true&tab=0&panel=0&from=student&studentId=${studentId}'/>">
                                    <fmt:message key="jsp.general.resultsoverview" />
                                </a>
                            </c:when>
                        </c:choose> 
                    </td>
                    <sec:authorize access="hasRole('CREATE_STUDY_PLANS')">
                        <td align="right">
                            <a class="button" href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                        </td>
                    </sec:authorize>
                </tr>
                <tr>
                    <td colspan="3">
                        <table class="tabledata2" id="TblData2_studyplans">
                        <tr>
                            <th><fmt:message key="jsp.general.description" /></th>
                            <th><fmt:message key="jsp.general.studygradetype" /></th>
                            <th><fmt:message key="jsp.general.studyplanstatus" /></th>
                            <th>&nbsp;</th>
                        </tr>
    
                        <c:forEach var="studyPlan" items="${student.studyPlans}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${editSubscriptionData || personId == opusUser.personId}">
                                            <a href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=0&panel=0&studentId=${studentId}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                            <c:out value="${studyPlan.studyPlanDescription}"/>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${studyPlan.studyPlanDescription}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:forEach var="study" items="${studentForm.studyPlanStudies}">
                                        <c:choose>
                                            <c:when test="${studyPlan.studyId == study.id}">
                                                <c:out value="${study.studyDescription}"/>
                                                    <c:forEach var="oneGradeType" items="${allGradeTypes}">
                                                        <c:choose>
                                                            <c:when test="${studyPlan.gradeTypeCode == oneGradeType.code}">
                                                                - <c:out value="${oneGradeType.description}"/>
                                                            </c:when>
                                                        </c:choose>
                                                     </c:forEach>
                                             </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:forEach var="studyPlanStatus" items="${allStudyPlanStatuses}">
                                          <c:choose>
                                              <c:when test="${studyPlan.studyPlanStatusCode == studyPlanStatus.code}">
                                                  <c:out value="${studyPlanStatus.description}"/>
                                              </c:when>
                                          </c:choose>
                                     </c:forEach>
                                    
                                </td>
                                <td class="buttonsCell">
                                    <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                                        <a class="imageLink" href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${studentId}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                            <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    </c:if>
                                    <sec:authorize access="hasRole('DELETE_STUDY_PLANS')">
                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/student/deleteStudyplan.view'/>?<c:out value='tab=2&panel=0&studentId=${studentId}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studyplan.delete.confirm" />')">
                                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                        </a>
                                    </sec:authorize>
                                </td>
                            </tr>
                        </c:forEach>
                        </table>
                        <script type="text/javascript">alternate('TblData2_studyplans',true)</script>
                    </td>
                </tr>
            </table>
        </div> <!--  end accordionpanelcontent -->
    </div> <!--  end accordionpanel -->
    
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.previousinstitution.information" /></div>
        <div class="AccordionPanelContent">
            <form:form method="post" modelAttribute="studentForm.studentFormShared">
                <input type="hidden" id="submitter" name="submitter" value="" />

                <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
                <input type="hidden" name="studentFormShared.navigationSettings.panel" value="1" />

            <table>
            <tr>
                <spring:bind path="student.previousInstitutionId">
                    <td class="label"><fmt:message key="jsp.general.previousinstitution" /></td>
                    <td>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	                    <select id="${status.expression}" name="${status.expression}" onchange="alterPrevInstFields();">
    	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    	                        <c:forEach var="institution" items="${studentForm.allPreviousInstitutions}">
    	                           <c:choose>
    	                            <c:when test="${institution.id == status.value}">
    	                                <option value="${institution.id}" selected="selected"><c:out value="${institution.institutionDescription}"/></option>
    	                            </c:when>
    	                            <c:otherwise>
    	                                <option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></option>
    	                            </c:otherwise>
    	                           </c:choose>
    	                        </c:forEach>
    	                    </select>
    	                </c:if>
    	                <c:if test="${showSubscriptionData && personId != opusUser.personId}">
    	                   <c:forEach var="institution" items="${studentForm.allPreviousInstitutions}">
    	                       <c:if test="${institution.id == status.value}">
                                    <c:out value="${institution.institutionDescription}"/>
                               </c:if>
                            </c:forEach>
    	                </c:if>
                    </td> 
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </spring:bind>
            </tr>
            <tr>
                <td class="label"></td>
                <td colspan="2">
                <table>
                    <tr><td class="label" colspan="2">
                        <fmt:message key="jsp.general.message.previousinstitution" />
                        </td>
                    </tr>
                    <tr>
                        <spring:bind path="student.previousInstitutionName">
                            <td><fmt:message key="jsp.general.previousinstitutionname" /></td>
                            <td>
                                <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                                    <input type="text" id="${status.expression}" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                </c:if>
                                <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                                    <c:out value="${status.value}"/>
                                </c:if>
                            </td>
                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                        </spring:bind>
                    </tr>
                    <tr>
                        <spring:bind path="student.previousInstitutionCountryCode">
                        <td><fmt:message key="jsp.general.previousinstitutioncountry" /></td>
                        <td>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	                    <select id="${status.expression}" name="${status.expression}" onchange="document.getElementById('submitter').value='previousInstitutionCountryCode'; this.form.submit();">
    	                         <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    	                         <c:forEach var="previousInstitutionCountry" items="${studentForm.previousInstitutionAddressLookup.allCountries}">
                                   <c:choose>
                                    <c:when test="${previousInstitutionCountry.code == status.value}">
                                        <option value="${previousInstitutionCountry.code}" selected="selected"><c:out value="${previousInstitutionCountry.description}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${previousInstitutionCountry.code}"><c:out value="${previousInstitutionCountry.description}"/></option>
                                    </c:otherwise>
                                    </c:choose>
    	                        </c:forEach> 
    	                    </select>
    	                </c:if>
                        <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                           <c:forEach var="previousInstitutionCountry" items="${studentForm.previousInstitutionAddressLookup.allCountries}">
                               <c:if test="${previousInstitutionCountry.code == status.value}">
                                    <c:out value="${previousInstitutionCountry.description}"/>
                               </c:if>
                            </c:forEach>
                        </c:if>
                        
                        </td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                        </spring:bind>
                    </tr>
                    <tr>
                        <spring:bind path="student.previousInstitutionProvinceCode">
                        <td><fmt:message key="jsp.general.previousinstitutionprovince" /></td>
                        <td>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	                    <select id="${status.expression}" name="${status.expression}" onchange="document.getElementById('submitter').value='previousInstitutionProvinceCode'; this.form.submit();">
    	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    	                        <c:forEach var="previousInstitutionProvince" items="${studentForm.previousInstitutionAddressLookup.allProvinces}">
    	                           <c:choose>
    	                            <c:when test="${previousInstitutionProvince.code == status.value}">
    	                                <option value="${previousInstitutionProvince.code}" selected="selected"><c:out value="${previousInstitutionProvince.description}"/></option>
    	                            </c:when>
    	                            <c:otherwise>
                                        <option value="${previousInstitutionProvince.code}"><c:out value="${previousInstitutionProvince.description}"/></option>
    	                            </c:otherwise>
    	                           </c:choose>
    	                        </c:forEach> 
    	                    </select>
    	                </c:if>
                        <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                           <c:forEach var="previousInstitutionProvince" items="${studentForm.previousInstitutionAddressLookup.allProvinces}">
                               <c:if test="${previousInstitutionProvince.code == status.value}">
                                    <c:out value="${previousInstitutionProvince.description}"/>
                               </c:if>
                            </c:forEach>
                        </c:if>
                        </td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                        </spring:bind>
                    </tr>
                    <tr>
                        <spring:bind path="student.previousInstitutionDistrictCode">
                        <td><fmt:message key="jsp.general.previousinstitutiondistrict" /></td>
                        <td>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	                    <select id="${status.expression}" name="${status.expression}">
    	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    	                        <c:forEach var="previousInstitutionDistrict" items="${studentForm.previousInstitutionAddressLookup.allDistricts}">
    	                           <c:choose>
    	                            <c:when test="${previousInstitutionDistrict.code == status.value}">
    	                                <option value="${previousInstitutionDistrict.code}" selected="selected"><c:out value="${previousInstitutionDistrict.description}"/></option>
    	                            </c:when>
    	                            <c:otherwise>
                                        <option value="${previousInstitutionDistrict.code}"><c:out value="${previousInstitutionDistrict.description}"/></option>
    	                            </c:otherwise>
    	                           </c:choose>
    	                        </c:forEach> 
    	                    </select>
    	                </c:if>
                        <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                           <c:forEach var="previousInstitutionDistrict" items="${studentForm.previousInstitutionAddressLookup.allDistricts}">
                               <c:if test="${previousInstitutionDistrict.code == status.value}">
                                    <c:out value="${previousInstitutionDistrict.description}"/>
                               </c:if>
                            </c:forEach>
                        </c:if>
                        </td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                        </spring:bind>
                    </tr>
                    <tr>
                        <spring:bind path="student.previousInstitutionTypeCode">
                        <td><fmt:message key="jsp.general.previousinstitutioneducationtype" /></td>
                        <td>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	                    <select id="${status.expression}" name="${status.expression}">
    	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    	                        <c:forEach var="educationType" items="${allEducationTypes}">
    	                           <c:choose>
    	                            <c:when test="${educationType.code == status.value}">
    	                                <option value="${educationType.code}" selected="selected"><c:out value="${educationType.description}"/></option>
    	                            </c:when>
    	                            <c:otherwise>
    	                                <option value="${educationType.code}"><c:out value="${educationType.description}"/></option>
    	                            </c:otherwise>
    	                           </c:choose>
    	                        </c:forEach>
    	                    </select>
    	                </c:if>
                        <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                           <c:forEach var="educationType" items="${allEducationTypes}">
                               <c:if test="${educationType.code == status.value}">
                                    <c:out value="${educationType.description}"/>
                               </c:if>
                            </c:forEach>
                        </c:if>
                        </td> 
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                        </spring:bind>
                    </tr>
                </table>
                </td>
                </tr>
                <tr>
                    <spring:bind path="student.previousInstitutionFinalGradeTypeCode">
                    <td class="label"><fmt:message key="jsp.general.previousinstitutionfinalgradetype" /></td>
                    <td>
                    <c:if test="${editSubscriptionData || personId == opusUser.personId}">
	                    <select name="${status.expression}">
	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                        <c:forEach var="gradeType" items="${allGradeTypes}">
	                           <c:choose>
	                            <c:when test="${gradeType.code == status.value}">
	                                <option value="${gradeType.code}" selected="selected"><c:out value="${gradeType.description}"/></option>
	                            </c:when>
	                            <c:otherwise>
	                                <option value="${gradeType.code}"><c:out value="${gradeType.description}"/></option>
	                            </c:otherwise>
	                           </c:choose>
	                        </c:forEach>
	                    </select>
	                </c:if>
                    <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                        <c:forEach var="gradeType" items="${allGradeTypes}">
                           <c:if test="${gradeType.code == status.value}">
                                <c:out value="${gradeType.description}"/>
                           </c:if>
                        </c:forEach>
                    </c:if>
                    </td> 
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    </td>
                    </spring:bind>
                </tr>
                <tr>
                    <spring:bind path="student.previousInstitutionDiplomaPhotographRemarks">
                    <td class="label"><fmt:message key="jsp.general.previousinstitutionphotographremarks" /></td>
                    <td>
                    <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                        <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                     </c:if>
                     <c:if test="${showSubscriptionData && personId != opusUser.personId}">
                        <c:out value="${status.value}"/>
                     </c:if>
                    </td>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                   </td>
                    </spring:bind>
                </tr>
                <c:if test="${editSubscriptionData || personId == opusUser.personId}">
    	            <tr>
    	                <td class="label">&nbsp;</td>
    	                <td>&nbsp;</td>
    	                <td><input type="button" name="submitpreviousinstitutiondata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
    	            </tr>
    	        </c:if>
            </table>
        </form:form>
    </div>  <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->


<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.previousinstitutiondiplomaphotograph" /></div>
    <div class="AccordionPanelContent">
         <c:choose>        
            <c:when test="${ not empty showPhotoTypeError }">       
                <tr>
                    <td align="left" colspan="2">
                        <p class="errorwide">
                            <c:out value="${showPhotoTypeError}"/>
                        </p>
                    </td>
                </tr>
            </c:when>
        </c:choose>
        <form name="previnstdiplomaphotographdata" id="previnstdiplomaphotographdata" action="<c:url value='/college/photographdata.view'/>" enctype='multipart/form-data' method="post">
<%--            <input type="hidden" name="tab_studyplan" value="${accordion}" /> 
            <input type="hidden" name="panel_previnstdiplomaphotographdata" value="2" />
             <input type="hidden" name="submitFormObject_previnstdiplomaphotographdata" id="submitFormObject_previnstdiplomaphotographdata" value="" /> --%>
            <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value="${accordion}" />
            <input type="hidden" id="navigationSettings.panel" name="navigationSettings.panel" value="2" />

        <table>
            <tr><td colspan="2">&nbsp;</td></tr>
            
            <tr>
                <td class="label"><fmt:message key="jsp.general.previousinstitutiondiplomaphotograph" /></td>
                <td>
                <fmt:message key="jsp.general.formats" />: jpg, jpeg, pdf, doc, rtf
                </td>
            </tr>
            <c:choose>        
                <c:when test="${ not empty showDocTypeError}">       
                    <tr>
                        <td align="left" colspan="2">
                            <p class="error">
                                <c:out value="${showDocTypeError}"/>
                            </p>
                        </td>
                    </tr>
                </c:when>
            </c:choose>
            <tr><td>&nbsp;</td>
                <td valign="top">     
                    <script type="text/javascript">
                        function deletePreviousInstitutionDiplomaPhotograph() {
                            document.previnstdiplomaphotographdata.deletephoto.value = "true";
                            document.previnstdiplomaphotographdata.submit();
                        }
                    </script>
                    <!-- getter in Person-class, showing whether person has document of previous institution or not -->        
                    <%-- MoVe outcommented due to errors in fileDisplayController --%>
                    <c:if test="${studentFormShared.student.hasPrevInstDiplomaPhoto}">
                        <a href="<c:url value='/college/photographview.view'/>?<c:out value='newForm=true&personId=${personId}&tab=2&panel=2&photo_type=previnstdiplomaphotograph&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                            <fmt:message key="jsp.general.previousinstitutiondiplomaphotograph" /> <fmt:message key="jsp.general.of" /> <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                        </a>
                        <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                            <a href="JavaScript:deletePreviousInstitutionDiplomaPhotograph()"
                                onclick="return confirm('<fmt:message key="jsp.photograph.delete.confirm" />')">
                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                            </a>
                        </c:if>
                    </c:if>
                </td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>  
            <c:if test="${editSubscriptionData || personId == opusUser.personId}">
	            <tr>
	                <td class="label">
                        <%-- For the FileUploadController: tab, panel etc. --%>
                        <input type="hidden" name="tab" value="${accordion}" />
                        <input type="hidden" name="panel" value="2" />
                        <input type="hidden" name="from" value="student" />
                        <input type="hidden" name="photo_type" value="previnstdiplomaphotograph" />
                        <input type="hidden" name="personId" value="${personId}" />
                        <input type="hidden" name="deletephoto" value="false" />
	                    <spring:bind path="studentFormShared.student.hasPrevInstDiplomaPhoto">
	                        <c:choose>
	                            <c:when test="${status.value}">
	                                <fmt:message key="jsp.href.edit" />
	                            </c:when>
	                            <c:otherwise>
	                                <fmt:message key="jsp.href.add" />
	                            </c:otherwise>
	                        </c:choose>
	                    </spring:bind>
	                </td>
	                <td>
	                   <input type="file" name="file" />
	                </td>
	            </tr>
	            <tr>
	               <td colspan="2" align="right"><input type="button" name="previnstdiplomaphotographdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.previnstdiplomaphotographdata.submit();" /><br /><br /></td>
	            </tr>
            </c:if> 
        </table>
        </form>
         
    </div>  <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->
