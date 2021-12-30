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

<c:set var="screentitlekey">jsp.general.study</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <!-- authorizations -->
    <sec:authorize access="hasRole('READ_STUDY_ADDRESSES')">
       <c:set var="showAddresses" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_STUDYGRADETYPES')">
        <c:set var="authorizedToEditStudyGradeTypes" value="${true}"/>
    </sec:authorize>

    <spring:bind path="studyForm.study.id">
        <c:set var="studyId" value="${status.value}" scope="page" />
    </spring:bind>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>
    
    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <spring:bind path="studyForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studyForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <div id="tabcontent">

        <form>
            <fieldset><legend>
                <a href="<c:url value='/college/studies.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.studies.header" /></a>&nbsp;&gt;
                <spring:bind path="studyForm.study.studyDescription">
                <c:choose>
                    <c:when test="${not empty status.value}" >
                        <c:out value="${fn:substring(status.value,0,initParam.iTitleLength)}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="general.add.study" />
                    </c:otherwise>
                </c:choose>
                </spring:bind>
            </legend>

            </fieldset>
        </form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.study" /></li>               
                <spring:bind path="studyForm.study.id">
                <c:choose>
                    <c:when test="${'' != status.value && 0 != status.value && showAddresses}">
                       <li class="TabbedPanelsTab"><fmt:message key="jsp.general.addresses" /></li>
                    </c:when>
                </c:choose>
                </spring:bind>     
            </ul>

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.study" /></div>
                            <div class="AccordionPanelContent">
                            
                               <c:choose>
                                    <c:when test="${(not empty studyForm.txtErr)}">             
                                        <p align="left" class="error">
                                                <c:out value="${studyForm.txtErr }"/>
                                        </p>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${(not empty studyForm.txtMsg)}"> 
                                        <p align="left" class="msg">
                                            <c:out value="${studyForm.txtMsg }"/>
                                        </p>
                                    </c:when>
                                </c:choose>

                                <form name="formdata" method="post" >
                                    <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />

                                    <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>

                                    <table>     
                                        <!-- DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="general.study.name" /></td>
                                            <spring:bind path="studyForm.study.studyDescription">
                                            <td class="required">
                                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- ACADEMIC FIELD -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.academicfield" /></td>
                                            <spring:bind path="studyForm.study.academicFieldCode">
                                            <td>
                                                <select name="${status.expression}">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="academicField" items="${allAcademicFields}">
                                                        <c:choose>
                                                            <c:when test="${academicField.code == status.value}">
                                                                <option value="${academicField.code}" selected="selected"><c:out value="${academicField.description}"/></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${academicField.code}"><c:out value="${academicField.description}"/></option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
<%-- #780: put the two dates under water                                        <!-- DATE OF ESTABLISHMENT -->
                                         <tr>
                                            <td class="label"><fmt:message key="jsp.general.dateofestablishment" /></td>
                                            <spring:bind path="studyForm.study.dateOfEstablishment">
                                                <td>
                                                <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                <table>
                                                    <tr>
                                                        <td><fmt:message key="jsp.general.month" /></td>
                                                        <td><fmt:message key="jsp.general.year" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${status.value == ''}">
                                                                    <input type="hidden" id="doe_day" name="doe_day" size="2" maxlength="2" value="01" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <input type="hidden" id="doe_day" name="doe_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}}" />" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <input type="text" id="doe_month" name="doe_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateMonthDate('study.dateOfEstablishment','month',document.getElementById('doe_month').value);" />
                                                        </td>
                                                        <td><input type="text" id="doe_year" name="doe_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateMonthDate('study.dateOfEstablishment','year',document.getElementById('doe_year').value);" /></td>
                                                    </tr>
                                                </table>
                                                </td>
                                                <td>
                                                    <fmt:message key="jsp.general.message.dateformat.month" />
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                </td>
                                            </spring:bind>
                                        </tr>

                                        
                                        <!-- START DATE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                                            <spring:bind path="studyForm.study.startDate">
                                            <td>
                                            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                            <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${status.value == ''}">
                                                                <input type="hidden" id="start_day" name="start_day" size="2" maxlength="2" value="01" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="hidden" id="start_day" name="start_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}}" />" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <input type="text" id="start_month" name="start_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateMonthDate('study.startDate','month',document.getElementById('start_month').value);" />
                                                    </td>
                                                    <td><input type="text" id="start_year" name="start_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateMonthDate('study.startDate','year',document.getElementById('start_year').value);" /></td>
                                                </tr>
                                            </table>
                                            </td>
                                            <td>
                                                <fmt:message key="jsp.general.message.dateformat.month" />
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr> --%>
                                        
                                        <!-- MOZAMBICAN SITUATION -->
                                        <c:choose>
                                            <c:when test="${studyForm.endGradesPerGradeType == 'N'}">
                                                
                                                <!-- MINIMUM MARK / GRADE SUBJECT -->
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.minimummark" /></td>
                                                    <spring:bind path="studyForm.study.minimumMarkSubject">
                                                    <td class="required">
                                                    <input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" /></td>
                                                    <td>
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    </td>
                                                    </spring:bind>
                                                </tr>
                                           

                                                <!-- MAXIMUM MARK / GRADE SUBJECT -->
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.maximummark" /></td>
                                                    <spring:bind path="studyForm.study.maximumMarkSubject">
                                                    <td class="required">
                                                    <input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" /></td>
                                                    <td>
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    </td>
                                                    </spring:bind>
                                                </tr>
                                            
                                                <!-- BR's PASSING SUBJECT -->
                                       
                                                <spring:bind path="studyForm.study.BRsPassingSubject">
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.brspassing" /> <fmt:message key="jsp.general.subjects" /></td>
                                                    <td class="required">
                                                    <input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" /></td>
                                                    <td>
                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    </td>
                                                </tr>
                                                </spring:bind>
                                                
                                            </c:when>
                                        </c:choose>

                                        <!-- ACTIVE -->
                                        <spring:bind path="studyForm.study.active">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
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
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                        </spring:bind>

                                        <!-- SUBMIT BUTTON -->
                                        <tr><td class="label">&nbsp;</td>
                                        <td><input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
                                        </td></tr>    
                                    </table>
                                </form>

                                <%-- STUDY GRADE TYPES --%>
                                <c:if test="${not empty studyForm.study.id && studyForm.study.id != 0}">
                                    <sec:authorize access="hasRole('READ_STUDYGRADETYPES')">

                                        <!-- GRADETYPES -->
                                        <table>
                                            <tr><td colspan="2">&nbsp;</td></tr>
                                            
                                            <tr>
                                                <td class="header"><fmt:message key="jsp.study.gradetypes" />
                                                &nbsp;&nbsp;&nbsp;
										        <c:if test="${accessContextHelp}">
										             <a class="white" href="<c:url value='/help/RegistrationStudyGradeType.pdf'/>" target="_blank">
										                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
										             </a>&nbsp;
										        </c:if>
                                                </td>
                                                <td align="right">
                                                    <sec:authorize access="hasRole('CREATE_STUDYGRADETYPES')">
                                                        <a class="button" href="<c:url value='/college/studygradetype.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyId=${studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="general.add.studyprogram" /></a>
                                                    </sec:authorize>
                                                </td>
                                            </tr>
                                        
                                            <tr>
                                                <td colspan="2">
                                                <table class="tabledata2" id="TblData2_studygradetypes">
                                                    <tr>
                                                          <th><fmt:message key="jsp.general.code" /></th>
                                                          <th><fmt:message key="jsp.general.gradetypeallover" /></th>
                                                          <th class="width1"><fmt:message key="jsp.general.academicyear" /></th>
                                                          <th><fmt:message key="jsp.general.studytime" /></th>
                                                          <th><fmt:message key="jsp.general.studyform" /></th>
                                                          <c:if test="${appUseOfPartTimeStudyGradeTypes == 'Y'}">
                                                            <th><fmt:message key="jsp.general.studyintensity" /></th>
                                                          </c:if>
                                                          <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
                                                          <th><fmt:message key="jsp.general.timeunits" /></th>
                                                          <th><fmt:message key="jsp.general.contact" /></th>
                                                          <th><fmt:message key="jsp.general.active" /></th>
                                                    </tr>
                                                    <c:forEach var="studyGradeType" items="${studyForm.study.studyGradeTypes}">
                                                        <tr>
                                                            <td>
                                                                <c:out value="${studyGradeType.studyGradeTypeCode}"/>
                                                            </td>
                                                            <td>

                                                                <c:choose>
                                                                    <c:when test="${authorizedToEditStudyGradeTypes}">
                                                                        <c:forEach var="gradeType" items="${allGradeTypes}">
                                                                            <c:choose>
                                                                               <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}">
                                                                                    <a href="<c:url value='/college/studygradetype.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeType.id}&amp;studyId=${studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                                    <c:out value="${gradeType.description}"/>
                                                                                    </a>
                                                                                </c:when>
                                                                            </c:choose>
                                                                        </c:forEach>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${gradeType.description}"/>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:forEach var="academicYear" items="${studyForm.allAcademicYears}">
                                                                   <c:choose>
                                                                   <c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
                                                                        <c:out value="${academicYear.description}"/>
                                                                    </c:when>
                                                                   </c:choose>
                                                                </c:forEach>                                                        
                                                            </td>
                                                            <td>
                                                                <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                   <c:choose>
                                                                   <c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
                                                                        <c:out value="${studyTime.description}"/>
                                                                    </c:when>
                                                                   </c:choose>
                                                                </c:forEach>          
                                                            </td>
                                                            <td>
                                                                <c:forEach var="studyForm" items="${allStudyForms}">
                                                                   <c:choose>
                                                                   <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
                                                                        <c:out value="${studyForm.description}"/>
                                                                    </c:when>
                                                                   </c:choose>
                                                                </c:forEach>          
                                                            </td>
                                                            <c:if test="${appUseOfPartTimeStudyGradeTypes == 'Y'}">
                                                                <td>
                                                                    <c:forEach var="studyIntensity" items="${allStudyIntensities}">
                                                                       <c:choose>
                                                                       <c:when test="${studyIntensity.code == studyGradeType.studyIntensityCode}">
                                                                            <c:out value="${studyIntensity.description}"/>
                                                                        </c:when>
                                                                       </c:choose>
                                                                    </c:forEach>          
                                                                </td>
                                                            </c:if>
                                                            <td>
                                                                <c:out value="${studyForm.codeToCardinalTimeUnitMap[studyGradeType.cardinalTimeUnitCode].description}"/>
                                                            </td>
                                                            <td>
                                                                <c:out value="${studyGradeType.numberOfCardinalTimeUnits}"/>
                                                            </td>
                                                            <td>
                                                                <c:forEach var="contact" items="${allContacts}">
                                                                   <c:choose>
                                                                    <c:when test="${contact.personId == studyGradeType.contactId}">
                                                                        <c:out value="${contact.surnameFull}, ${contact.firstnamesFull}"/>
                                                                    </c:when>
                                                                   </c:choose>
                                                                </c:forEach>                                                        
                                                            </td>
                                                            <td>
                                                                <c:out value="${studyGradeType.active}"/>
                                                            </td>
                                                            <td class="buttonsCell">
                                                                <c:choose>
                                                                    <c:when test="${authorizedToEditStudyGradeTypes}">
                                                                        <a class="imageLink" href="<c:url value='/college/studygradetype.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeType.id}&amp;studyId=${studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                    </c:when>
                                                                </c:choose>
                                                            </td>
                                                            <sec:authorize access="hasRole('DELETE_STUDYGRADETYPES')">
                                                                <td class="buttonsCell">
                                                                    <a class="imageLink" href="<c:url value='/college/studygradetype_delete.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyGradeTypeId=${studyGradeType.id}&amp;studyId=${studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                                                        onclick="return confirm('<fmt:message key="jsp.gradetypes.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                </td>
                                                            </sec:authorize>
                                                        </tr>
                                                    </c:forEach>
                                                 </table>
                                            
                                            <script type="text/javascript">alternate('TblData2_studygradetypes',true)</script>
                                            </td>
                                        </tr> 
                                        </table>
                                    </sec:authorize>
                                </c:if>
                                
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 0 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                                        

                <%-- ADDRESSES --%>
                <spring:bind path="studyForm.study.id">
                <c:choose>
                    <c:when test="${'' != status.value && 0 != status.value && showAddresses}">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion1" tabindex="0">

                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab"><fmt:message key="jsp.general.addresses" /></div>
                            <div class="AccordionPanelContent">

                                <c:choose>        
                                    <c:when test="${ not empty studyForm.txtErr }">       
                                        <p align="left" class="error">
                                            <c:out value="${studyForm.txtErr}"/>
                                        </p>
                                   </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${(not empty studyForm.txtMsg)}"> 
                                        <p align="left" class="msg">
                                            <c:out value="${studyForm.txtMsg}"/>
                                        </p>
                                    </c:when>
                                </c:choose>

                        
                                 <c:set var="countAddressTypes" value="0" scope="page" />
                                 <c:set var="countUsedAddressTypes" value="0" scope="page" />
                                 
                                 <spring:bind path="studyForm.study.addresses">
                                    <c:forEach var="addressType" items="${studyForm.allAddressTypes}">
                                        <c:set var="countAddressTypes" value="${countAddressTypes + 1}" scope="page" />
                                        <c:forEach var="address" items="${status.value}">
                                            <c:choose>
                                                <c:when test="${addressType.code == address.addressTypeCode }">
                                                    <c:set var="countUsedAddressTypes" value="${countUsedAddressTypes + 1}" scope="page" />
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </c:forEach>
                                </spring:bind>
                                
                                <c:set var="addressNewString" scope="page" value="/college/address.view?newForm=true&amp;tab=1&amp;panel=0&amp;from=study&amp;studyId=${studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}" />

                                <table>
                                    <sec:authorize access="hasRole('CREATE_STUDY_ADDRESSES')">
                                        <c:choose>
                                            <c:when test="${countAddressTypes != countUsedAddressTypes}">
                                                <tr>
                                                    <td class="label"><fmt:message key="jsp.general.addresses" /></td>
                                                    <td colspan="2" align="right">
                                                        <a class="button" href="<c:url value='${addressNewString}'/>"><fmt:message key="jsp.href.add" /></a>
                                                    </td>
                                                </tr>
                                            </c:when>
                                         </c:choose>
                                     </sec:authorize>

                                    <spring:bind path="studyForm.study.addresses">
                                        <c:forEach var="address" items="${status.value}">
                                            
                                            <c:set var="addressViewString" scope="page" value="/college/address.view?newForm=true&amp;tab=1&amp;panel=0&amp;from=study&amp;studyId=${studyId}&amp;addressId=${address.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}" />
                                            <c:set var="addressDeleteString" scope="page" value="/college/address_delete.view?newForm=true&amp;tab=1&amp;panel=0&amp;from=study&amp;studyId=${studyId}&amp;addressId=${address.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}" />
                                                
                                            <tr>
                                                <td colspan="2">
                                                    <c:forEach var="addressType" items="${studyForm.allAddressTypes}">
                                                        <c:choose>
                                                            <c:when test="${ addressType.code == address.addressTypeCode }">
                                                                <c:out value="${addressType.description}"/>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td>
                                               <td>
                                                    <sec:authorize access="hasRole('UPDATE_STUDY_ADDRESSES')">
                                                        <a href="<c:url value='${addressViewString}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                    </sec:authorize>
                                                    <sec:authorize access="hasRole('DELETE_STUDY_ADDRESSES')">
                                                        &nbsp;&nbsp;
                                                        <a href="<c:url value='${addressDeleteString}'/>" onclick="return confirm('<fmt:message key="jsp.addresses.delete.confirm" />')">
                                                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                        </a>
                                                    </sec:authorize>
                                               </td>
                                            </tr>
                                         
                                            <%@ include file="../../includes/addressData.jsp"%>

                                        </c:forEach>
                                    </spring:bind>
                                </table>

                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 1 -->
                    </div>
                    
                    <script type="text/javascript">
                        var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                    </script>
                    
                <!--  end tabbedpanelscontent -->
                </div>
                    </c:when>
                </c:choose>     
                </spring:bind> 

            <!--  end tabbed panelscontentgroup -->    
            </div>
            
        <!--  end tabbed panel -->    
        </div>
        
    <!-- end tabcontent -->
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
        Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
        Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>
   
<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

