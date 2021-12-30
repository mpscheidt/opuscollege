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

<c:set var="screentitlekey">jsp.general.fastinput</c:set>
<%@ include file="../../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />

<body>

<%@ include file="../../includes/javascriptfunctions.jsp"%>
<script type="text/javascript">

    <%--
    // Function: checkZeroValues
    // If any of the filter values is 0, disable student input fields
    --%>
    function checkZeroValues() {

        disabled = false;
        <%-- look for selects (except the optional classgroupId) with 0 values --%>
        jQuery("select").not("#classgroupId, table#details  *").each(function (i) { 

            <%--alert(this.name + " : " + this.value);--%>
            if (this.value == 0) {

                disabled = true;
                return false;
            }

        });

        <%--go to every input and update its disabled state
        //alert("checking form elements");--%>
        jQuery("table#details *").filter("select , input").each(
                function(i) {

                    var element = jQuery(this);
                    this.disabled = disabled;
                    
                    if(disabled){
                        element.addClass("disabled");
                    } else {
                        element.removeClass("disabled");
                    }
                });

    }

    jQuery(document).ready( function() {

        <%--add function to every select tag of class required--%>
            jQuery("select").not("table#details  *").change(function (i) { 
                checkZeroValues();

            });

                checkZeroValues();
                
        });
</script>
<div id="tabwrapper">

	<%@ include file="../../menu.jsp"%>
	
    <c:set var="gradeTypeIsBachelor" value="${false}" />
    <c:set var="gradeTypeIsMaster" value="${false}" />

    <c:if test="${selectedStudyGradeType != null && selectedStudyGradeType != ''}"> 
        <c:forEach var="gradeType" items="${allGradeTypes}">
            <c:if test="${selectedStudyGradeType.gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_BACHELOR}" >
                <c:set var="gradeTypeIsBachelor" value="${true}" />
            </c:if>
            <c:if test="${selectedStudyGradeType.gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_MASTER}" >
                <c:set var="gradeTypeIsMaster" value="${true}" />
            </c:if>
        </c:forEach>
    </c:if>

<div id="tabcontent">

<fieldset>
    <legend>
        <a class="imageLink" href="#" onclick="openPopupWindow('<b><fmt:message key="jsp.href.info" />: <fmt:message key="jsp.general.fastinput" /></b><br/><fmt:message key="jsp.student.fastinput.help1" />\r\n<fmt:message key="jsp.student.fastinput.help2" />\r\n<fmt:message key="jsp.student.fastinput.help3" />');">
            <img src="<c:url value='/images/info.gif' />"
                alt="<fmt:message key="jsp.href.info" />"
                title="<fmt:message key="jsp.href.info" />" />
        </a>
        <fmt:message key="jsp.general.fastinput" />
    </legend>

<table>

    <form name="personaldata" method="post">
        <c:set var="formaction" value="personaldata" scope="request" />
        <jsp:include page="../../includes/institutionBranchOrganizationalUnitSelectDetail.jsp" flush="true"/>
    </form>

    <!-- start of primary study -->
    <form name="primaryStudyFilter" method="post">
        <input type="hidden" name="institutionId" value="${institutionId}" />
        <input type="hidden" name="branchId" value="${branchId}" />
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="studyGradeTypeId" value="0" />
        <input type="hidden" name="academicYearId" value="0" />
        <input type="hidden" name="cardinalTimeUnitNumber" value="0" />
        <input type="hidden" name="classgroupId" value="0" />
      <table>
      <tr>
        <td class="label" width="200"><fmt:message key="jsp.general.primarystudy"/></td>
        <td class="required">
        <select id="primaryStudyId" name="primaryStudyId" onchange="document.primaryStudyFilter.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneStudy" items="${dropDownListStudies}">
                <c:choose>
                    <c:when test="${oneStudy.id == primaryStudyId}">
                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                    </c:when>
                    <c:otherwise>
                        <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
        </td>
      </tr>
      </table>
    </form>
    <!-- end of primary study -->
    <!-- start of academic year -->
    <form name="academicYearFilter" method="post" target="_self">
        <input type="hidden" name="institutionId" value="${institutionId}" />
        <input type="hidden" name="branchId" value="${branchId}" />
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
        <input type="hidden" name="studyGradeTypeId" value="0" />
        <input type="hidden" name="cardinalTimeUnitNumber" value="0" />
        <input type="hidden" name="classgroupId" value="0" />
      <table>
      <tr>
        <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
        <td class="required">
        <select id="academicYearId" name="academicYearId" onchange="document.academicYearFilter.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="year" items="${allAcademicYears}">                          
                <c:choose>
                <c:when test="${year.id == academicYearId}">
                    <option value="${year.id}" selected="selected"><c:out value="${year.description}"/></option>
                </c:when>
                <c:otherwise>
                    <option value="${year.id}"><c:out value="${year.description}"/></option>                            
                </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
        </td>
      </tr>
      </table>
    </form>
    <!-- end of academic year -->
    <!-- start of study gradetypes -->
    <form name="studyGradeTypeFilter" method="post" target="_self">
        <input type="hidden" name="institutionId" value="${institutionId}" />
        <input type="hidden" name="branchId" value="${branchId}" />
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
        <input type="hidden" name="academicYearId" value="${academicYearId}" />
        <input type="hidden" name="cardinalTimeUnitNumber" value="0" />
        <input type="hidden" name="classgroupId" value="0" />
      <table>
      <tr>
        <td class="label" width="200"><fmt:message key="jsp.general.studygradetype" /></td>
        <td class="required">
        <select id="studyGradeTypeId" name="studyGradeTypeId" onchange="document.studyGradeTypeFilter.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                <c:choose>
                    <c:when test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
                                    && studyGradeType.id == studyGradeTypeId) }">
                        <c:set var="selectedGradeType" value="${allGradeTypesMap[studyGradeType.gradeTypeCode]}" scope="page" />            
                        <option value="${studyGradeType.id}" selected="selected" />
                        <c:set var="selectedStudyGradeType" value="${studyGradeType}"/>
                    </c:when>
                    <c:otherwise>
                        <option value="${studyGradeType.id}" />
                    </c:otherwise>
                </c:choose>
                <c:out value="
                ${allGradeTypesMap[studyGradeType.gradeTypeCode]} -
                ${allStudyFormsMap[studyGradeType.studyFormCode]} -
                ${allStudyTimesMap[studyGradeType.studyTimeCode]}
                "/>
            </c:forEach>
        </select>
        </td>
      </tr>
      </table>
    </form>
    <!-- end of grade types -->
    <!-- cardinal time units -->
    <form name="cardinalTimeUnitFilter" method="post" target="_self">
        <input type="hidden" name="institutionId" value="${institutionId}" />
        <input type="hidden" name="branchId" value="${branchId}" />
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
        <input type="hidden" name="academicYearId" value="${academicYearId}" />
        <input type="hidden" name="classgroupId" value="0" />
        <input type="hidden" name="resetSubjectsAndSubjectBlocks" value="true" />
      <table>
      <tr>
        <td class="label" width="200"><fmt:message key="jsp.general.timeunit" /></td>
        <td class="required">
        <select id="cardinalTimeUnitNumber" name="cardinalTimeUnitNumber" onchange="document.cardinalTimeUnitFilter.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach begin="1" end="${selectedStudyGradeType.numberOfCardinalTimeUnits}" varStatus="status">
                <c:choose>
                    <c:when test="${(cardinalTimeUnitNumber == status.count) }">
                        <option value="${status.count}" selected="selected"/>
                    </c:when>
                    <c:otherwise>
                        <option value="${status.count}"/>
                    </c:otherwise>
                </c:choose>
                <c:out value="
                ${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]}
                ${status.count}
                "/>
            </c:forEach>
        </select>
        </td>
      </tr>
      </table>
    </form>
    <!-- end of cardinal time units -->
    <!-- classgroups -->
    <form name="classgroupFilter" method="post" target="_self">
        <input type="hidden" name="institutionId" value="${institutionId}" />
        <input type="hidden" name="branchId" value="${branchId}" />
        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
        <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
        <input type="hidden" name="academicYearId" value="${academicYearId}" />
        <input type="hidden" name="cardinalTimeUnitNumber" value="${cardinalTimeUnitNumber}" />
      <table>
      <tr>
        <td class="label" width="200"><fmt:message key="general.classgroup" /></td>
        <td>
        <select id="classgroupId" name="classgroupId" onchange="this.form.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="classgroup" items="${selectedStudyGradeType.classgroups}">
                <c:set var="classgroupselected" value="${classgroupId == classgroup.id ? 'selected' : ''}"/>
                <option value="${classgroup.id}" ${classgroupselected}>${classgroup.description}</option>
            </c:forEach>
        </select>
        </td>
      </tr>
      </table>
    </form>
    <!-- end of classgroups -->
    
</table>
</fieldset>


<form:form modelAttribute="fastStudentInputForm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add" />
    <input type="hidden" name="institutionId" value="${institutionId}" />
    <input type="hidden" name="branchId" value="${branchId}" />
    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
    <input type="hidden" name="academicYearId" value="${academicYearId}" />
    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
    <input type="hidden" name="subjectBlockStudyGradeTypeId" value="${subjectBlockStudyGradeTypeId}" />
    <input type="hidden" name="classgroupId" value="${classgroupId}" />



<fieldset>
    <legend>
        <fmt:message key="jsp.fastinput.subscription"/>
    </legend>
    <table style="width:100%;">
        <tr>
            <td colspan="2">
                <fmt:message key="jsp.general.max.numberofsubjects.cardinaltimeunit" />: ${fastStudentInputForm.maxNumberOfSubjects}
                <form:hidden path="maxNumberOfSubjects" /> <%-- so that the value is not discarded, but remains in the form object --%>
            </td>
        </tr>
        <tr>
            <%@ include file="includes/subjectAndBlockSGTSelection.jsp"%>
        </tr>
    </table>

</fieldset>
<%-- Give feedback if student successfully created, but only if no errors occurred,
     because otherwise a previously successfully created student might be displayed
     although we already try to create another student. --%>
<c:if test="${not status.error
            and empty fastStudentInputError 
            and not empty successfullyCreatedStudent}">
    <table style="width:735px;" >
        <spring:bind path = "*">
            <tr><td class="successful">
                <fmt:message key="jsp.student.fastinput.success"/>: 
                <c:out value="${successfullyCreatedStudent.studentCode}: ${successfullyCreatedStudent.firstnamesFull} ${successfullyCreatedStudent.surnameFull}"/>
                <a href="<c:url value='/college/student/personal.view?newForm=true&studentId=${successfullyCreatedStudent.studentId}&tab=0&panel=0'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
            </td></tr>
            <tr/>
        </spring:bind>
    </table>
</c:if> 
<%-- give feedback if error occurred outside validation error --%>
<c:if test="${not empty fastStudentInputError}">
    <table style="width:735px;" >
        <tr>
            <td class="error">
                <c:out value="${fastStudentInputError}"/>
            </td>
        <tr/>
    </table>
</c:if>

<!-- here started form:form previously -->

    <fieldset>
<!--            <legend>Student Fields</legend>-->
        <table id="details">
            <tr><form:errors path="" cssClass="error"/></tr>
            <tr>
                <td class="label"><form:label for="student.studentCode" path="student.studentCode" ><fmt:message key="jsp.general.studentcode" /></form:label></td>
                <td><form:input path="student.studentCode"/> <form:errors path="student.studentCode" /></td>
                <td>
                    <c:if test="${fastStudentInputForm.studentCodeWillBeGenerated}">
                        <fmt:message key="jsp.general.message.codegenerated"/>
                    </c:if>
                    <form:errors path="student.studentCode" cssClass="error"/>
                </td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.surnameFull" path="student.surnameFull"><fmt:message key="jsp.general.surname" /></form:label></td>
                <td class="required"><form:input path="student.surnameFull" /></td>
                <td><form:errors path="student.surnameFull" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.firstnamesFull" path="student.firstnamesFull"><fmt:message key="jsp.general.firstnames" /></form:label></td>
                <td class="required"><form:input path="student.firstnamesFull" /></td>
                <td><form:errors path="student.firstnamesFull" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.genderCode" path="student.genderCode"><fmt:message key="jsp.general.gender" /></form:label></td>
                <td class="required"><form:select path="student.genderCode">
                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                    <form:options items="${allGenders}" itemValue="code" itemLabel="description"/>
                </form:select></td>
                <td><form:errors path="student.genderCode" cssClass="error"/></td>
            </tr>
            <!-- start of birth date -->
            <tr>
                <td class="label"><form:label for="birth_day" path="student.birthdate"><fmt:message key="jsp.general.birthdate"/></form:label></td>
                <td class="required"><form:hidden path="student.birthdate"/>
                    <table>
                        <tr>
                            <td><fmt:message key="jsp.general.day" /></td>
                            <td><fmt:message key="jsp.general.month" /></td>
                            <td><fmt:message key="jsp.general.year" /></td>
                        </tr>
                        <tr>
                            <spring:bind path="student.birthdate">
                            <td><input type="text" id="birth_day"
                                name="birth_day" size="2" maxlength="2"
                                value="<c:out value="${fn:substring(status.value,8,10)}" />"
                                onchange="updateFullDate('student.birthdate','day',document.getElementById('birth_day').value);" /></td>
                            <td><input type="text" id="birth_month"
                                name="birth_month" size="2" maxlength="2"
                                value="<c:out value="${fn:substring(status.value,5,7)}" />"
                                onchange="updateFullDate('student.birthdate','month',document.getElementById('birth_month').value);" /></td>
                            <td><input type="text" id="birth_year"
                                name="birth_year" size="4" maxlength="4"
                                value="<c:out value="${fn:substring(status.value,0,4)}" />"
                                onchange="updateFullDate('student.birthdate','year',document.getElementById('birth_year').value);" /></td>
                            </spring:bind>
                        </tr>
                    </table>
                </td>
                <td>
                    <fmt:message key="jsp.general.message.dateformat" />
                    <form:errors path="student.birthdate" cssClass="error"/>
                </td>
            </tr>
            <!-- end of date -->
            <%-- scholarship flag --%>
            <sec:authorize access="hasAnyRole('UPDATE_SCHOLARSHIP_FLAG')">
                <tr>
                    <spring:bind path="student.scholarship">
                        <td class="label"><fmt:message key="jsp.general.scholarship.appliedfor" /></td>
                        <td>
                           <select name="${status.expression}" id="${status.expression}">
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
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </spring:bind>
                </tr>
            </sec:authorize>
            
            <tr>
                 <td class="label"><form:label for="student.sourceOfFunding" path="student.sourceOfFunding"><fmt:message key="jsp.general.sourceOfFunding" /></form:label></td>
                 <!-- <td><form:radiobutton label="Autofinanciamento" value="Autofinanciamento" path="student.sourceOfFunding"/></td>-->
                 <!-- <td><form:radiobutton label="Bolsa" value="Bolsa" path="student.sourceOfFunding"/></td>  -->  
                <td><form:errors path="student.sourceOfFunding" cssClass="error"/>
	                <form:select path="student.sourceOfFunding">
	                   <form:option value="Autofinanciamento"><fmt:message key="jsp.general.selffunding" /> </form:option>
	                   <form:option value="Bolsa"><fmt:message key="jsp.general.scholarship" /></form:option>
	                </form:select>
                </td>
            </tr>

            <tr>
                <td class="label"><form:label for="emailAddress" path="student.addresses[0].emailAddress"><fmt:message key="jsp.general.email" /></form:label></td>
                <td <c:if test="${initParam.iEmailAddressRequired}">class="required"</c:if> >
                    <form:input id="emailAddress" path="student.addresses[0].emailAddress" />
                </td>
                <td><form:errors path="student.addresses[0].emailAddress" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="mobilePhone" path="student.addresses[0].mobilePhone"><fmt:message key="jsp.general.mobile" /></form:label></td>
                <td <c:if test="${initParam. iMobilePhoneRequired}">class="required"</c:if> >
                    <form:input id="mobilePhone" path="student.addresses[0].mobilePhone" />
                </td>
                <td><fmt:message key="jsp.message.format.mobilephone" />&nbsp;
                    <form:errors path="student.addresses[0].mobilePhone" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.provinceOfBirthCode" path="student.provinceOfBirthCode"><fmt:message key="jsp.general.provinceofbirth" /></form:label></td>
                <td><form:select path="student.provinceOfBirthCode">
                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                    <form:options items="${allProvincesOfBirth}" itemValue="code" itemLabel="description"/>
                </form:select></td>
                <td><form:errors path="student.provinceOfBirthCode" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.provinceOfOriginCode" path="student.provinceOfOriginCode"><fmt:message key="jsp.general.provinceoforigin" /></form:label></td>
                <td><form:select path="student.provinceOfOriginCode">
                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                    <form:options items="${allProvincesOfOrigin}" itemValue="code" itemLabel="description"/>
                </form:select></td>
                <td><form:errors path="student.provinceOfOriginCode" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.previousInstitutionProvinceCode" path="student.previousInstitutionProvinceCode"><fmt:message key="jsp.general.previousinstitutionprovince" /></form:label></td>
                <td><form:select path="student.previousInstitutionProvinceCode">
                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                    <form:options items="${allPreviousInstitutionProvinces}" itemValue="code" itemLabel="description"/>
                </form:select></td>
                <td><form:errors path="student.previousInstitutionProvinceCode" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.identificationTypeCode" path="student.identificationTypeCode"><fmt:message key="jsp.general.identificationtype" /></form:label></td>
                <td class="required"><form:select path="student.identificationTypeCode">
                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                    <form:options items="${allIdentificationTypes}" itemValue="code" itemLabel="description"/>
                </form:select></td>
                <td><form:errors path="student.identificationTypeCode" cssClass="error"/></td>
            </tr>
            <tr>
                <td class="label"><form:label for="student.identificationNumber" path="student.identificationNumber"><fmt:message key="jsp.general.identificationnumber" /></form:label></td>
                <td class="required"><form:input path="student.identificationNumber" /></td>
                <td><form:errors path="student.identificationNumber" cssClass="error"/></td>
            </tr>

            <%--  APPPLICATION NUMBER --%>
            <c:if test="${opusInit.iApplicationNumber == 'Y'}">
                <tr>
                    <td class="label"><form:label for="applicationNumber" path="student.studyPlans[0].applicationNumber"><fmt:message key="jsp.general.applicationnumber" /></form:label></td>
                    <td><form:input id="applicationNumber" path="student.studyPlans[0].applicationNumber" /></td>
                    <td><form:errors path="student.studyPlans[0].applicationNumber" cssClass="error"/></td>
                </tr>
            </c:if>

            <%--  FOREIGN STUDENT --%>
            <tr>
               <td class="label"><form:label for="student.foreignStudent" path="student.foreignStudent"><fmt:message key="jsp.general.foreignstudent" /></form:label></td>
               <td>
                    <form:select path="student.foreignStudent">
                    <form:option value="N"><fmt:message key='jsp.general.no' /></form:option>
                    <form:option value="Y"><fmt:message key='jsp.general.yes' /></form:option>
                    </form:select>
                </td>
               <td><form:errors path="student.foreignStudent" cssClass="error"/></td>
            </tr>
                     
            <%-- PREV INSTITUTION DIPLOMA PHOTOGRAPH / SCAN --%>
            <tr>
                <td class="label"><form:label for="previousDiplomaFile" path="student.previousInstitutionDiplomaPhotograph"><fmt:message key="jsp.general.previousinstitutiondiplomaphotograph" /></form:label></td>
<%--                <td><form:input id="student.previousInstitutionDiplomaPhotograph" path="student.previousInstitutionDiplomaPhotograph" /></td> --%>
                <td>
                    <input type="file" id="previousDiplomaFile" name="previousDiplomaFile"/>
                </td>
                <td>
	                <form:errors path="student.previousInstitutionDiplomaPhotograph" cssClass="error"/>
                    <fmt:message key="jsp.general.formats" />: jpg, jpeg, pdf, doc, rtf
                </td>
            </tr>
            
            <tr>
                <td class="label"><form:label for="student.healthIssues" path="student.healthIssues"><fmt:message key="jsp.general.healthissues" /></form:label></td>
                <td><form:textarea path="student.healthIssues" cols="25" rows="6"/></td>
                <td><form:errors path="student.healthIssues" cssClass="error"/></td>
            </tr>

            <%--  SECONDARY SCHOOL SUBJECTS
            <c:if test="${gradeTypeIsBachelor}"> 
                <tr>
                     <td class="label"><form:label for="student.studyPlans[0].secondarySchoolSubjectGroups" path="student.studyPlans[0].secondarySchoolSubjectGroups"><fmt:message key="jsp.general.secondaryschoolsubjects" /></form:label></td>
                     <td><form:input id="student.studyPlans[0].secondarySchoolSubjectGroups" path="student.studyPlans[0].secondarySchoolSubjectGroups" /></td>
                     <td><form:errors path="student.studyPlans[0].secondarySchoolSubjectGroups" cssClass="error"/></td>
                </tr>
                
	        </c:if>
	        --%>
	        
            <tr>
                <td colspan="2"></td>
                <td>
                <input value="<fmt:message key='jsp.button.addstudent'/>" type="submit" />
                </td>
            </tr>
        </table>
    </fieldset>
</form:form>



</div>

</div>

<%@ include file="../../footer.jsp"%>