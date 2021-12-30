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
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<div id="header">

    <div id="homeLink">
        <a href="<c:url value='/college/start.view?newForm=true'/>">
            <%-- initParam is an implicit object provided by JSTL --%>
            <img src='<c:url value="${initParam.initMenuLogo}" />' alt='<fmt:message key="jsp.general.home" />' title='<fmt:message key="jsp.general.home" />' /> 
        </a>
    </div>

    <div id="HelpMenu">
        <fmt:message key="jsp.general.user" />: <c:out value="${userFullName}"/>

        <%--
            If user has more then one role display them in a select box else use plain text
         --%>
        <c:choose>
          <c:when test="${fn:length(opusUserRoles) > 1}">
            (
            <select style="border:none;background: transparent;font-weight:bold; width:200px" onchange="document.location=this.value">
                <c:forEach var="oneOpusUserRole" items="${opusUserRoles}" varStatus="status">
                    <c:choose>
                        <c:when test="${opusUserRole.id == oneOpusUserRole.id}">
                            <option selected="selected" value="<c:url value='/college/start.view?opusUserRoleId=${oneOpusUserRole.id}&amp;newForm=true'/>">
                                <c:out value="${oneOpusUserRole.roleDescription}"/>
                                &nbsp;- <c:out value="${oneOpusUserRole.organizationalUnit}"/>
                                &nbsp;(<c:out value="${oneOpusUserRole.branchDescription}"/>)
                            </option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:url value='/college/start.view?opusUserRoleId=${oneOpusUserRole.id}&amp;newForm=true'/>">
                                <c:out value="${oneOpusUserRole.roleDescription}"/>
                                &nbsp;- <c:out value="${oneOpusUserRole.organizationalUnit}"/>
                                &nbsp;(<c:out value="${oneOpusUserRole.branchDescription}"/>)
                            </option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </select>
            )
          </c:when>
          <c:otherwise>
                (<c:out value="${opusUserRoles[0].roleDescription}"/>)
          </c:otherwise>
        </c:choose>
        <c:set var="reportQueryString" value="where.role.role='${opusUserRole.role}'" scope="page" />
        <a class="white" href="<c:url value='/college/reports.view?reportName=Privileges.pdf&amp;${reportQueryString}'/>" target="_blank">
            <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
        </a>

        <c:url value="/logout" var="logoutUrl">
            <c:if test="${not empty tenantCode}">
                <c:param name="tenant" value="${tenantCode}"/>
            </c:if>
        </c:url>

        <p id="Language">
            <%@ include file="includes/languageSelector.jsp"%>
            | <a href="<c:out value='${logoutUrl}'/>"><fmt:message key="jsp.menu.logout" /></a>
            | <a href="http://www.opuscollege.net/instruction" target="_blank"><fmt:message key="jsp.general.message.help" /></a>
            |
        </p>
    </div>
 
    <div id="Menu2">
        <ul id="MenuBar2" class="MenuBarHorizontal">
        <c:choose>
            <c:when test="${modules != null && modules != ''}">
                <c:forEach var="module" items="${modules}">
                    <c:choose>
                        <c:when test="${not empty module.menu}">
                            <jsp:include page="${module.menu}" flush="true"/>
                        </c:when>
                    </c:choose>
                </c:forEach>
            </c:when>
        </c:choose>
        </ul>
    </div> 

</div>
    

<div id="Menu">
        <ul id="MenuBar1" class="MenuBarHorizontal">
            
            <sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS', 'UPDATE_STUDYPLAN_RESULTS','READ_STUDYPLAN_RESULTS', 'DELETE_STUDYPLAN_RESULTS'
                                                                            ,'CREATE_SUBJECTS_RESULTS', 'READ_SUBJECTS_RESULTS', 'UPDATE_SUBJECTS_RESULTS', 'DELETE_SUBJECTS_RESULTS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_SUBJECTS','UPDATE_RESULTS_ASSIGNED_SUBJECTS','READ_RESULTS_ASSIGNED_SUBJECTS','DELETE_RESULTS_ASSIGNED_SUBJECTS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_EXAMINATIONS','READ_RESULTS_ASSIGNED_EXAMINATIONS','UPDATE_RESULTS_ASSIGNED_EXAMINATIONS','DELETE_RESULTS_ASSIGNED_EXAMINATIONS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_TESTS', 'READ_RESULTS_ASSIGNED_TESTS', 'UPDATE_RESULTS_ASSIGNED_TESTS', 'DELETE_RESULTS_ASSIGNED_TESTS')
                                                                            ">
                <li>
                <c:choose>
                    <c:when test="${menuChoice == 'exams'}">
                        <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.general.results" />&nbsp;&nbsp;|</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="MenuBarItem"><fmt:message key="jsp.general.results" />&nbsp;&nbsp;|</a>
                    </c:otherwise>
                </c:choose>
                    <ul>
                        <li><a href="<c:url value='/college/studyplanresults.view?newForm=true&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.studyplanresults" /></a></li>

                        <sec:authorize access="hasAnyRole('CREATE_SUBJECTS_RESULTS', 'READ_SUBJECTS_RESULTS', 'UPDATE_SUBJECTS_RESULTS', 'DELETE_SUBJECTS_RESULTS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_SUBJECTS','UPDATE_RESULTS_ASSIGNED_SUBJECTS','READ_RESULTS_ASSIGNED_SUBJECTS','DELETE_RESULTS_ASSIGNED_SUBJECTS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_EXAMINATIONS','READ_RESULTS_ASSIGNED_EXAMINATIONS','UPDATE_RESULTS_ASSIGNED_EXAMINATIONS','DELETE_RESULTS_ASSIGNED_EXAMINATIONS'
                                                                            ,'CREATE_RESULTS_ASSIGNED_TESTS', 'READ_RESULTS_ASSIGNED_TESTS', 'UPDATE_RESULTS_ASSIGNED_TESTS', 'DELETE_RESULTS_ASSIGNED_TESTS')
                                                                            ">
                            <li><a href="<c:url value='/college/subjectsresults.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.resultssubjects" /></a></li>
                        </sec:authorize>
                    </ul>
                </li> 
            </sec:authorize>


            <sec:authorize access="hasAnyRole('CREATE_STUDENTS', 'READ_STUDENTS', 'READ_STUDENTS_SAME_STUDYGRADETYPE', 'UPDATE_STUDENTS', 'DELETE_STUDENTS'
                                            ,'TRANSFER_STUDENTS', 'UPDATE_PROGRESS_STATUS'
                                            , 'CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL', 'CREATE_STUDYPLANDETAILS_PENDING_APPROVAL', 'APPROVE_SUBJECT_SUBSCRIPTIONS', 'FINALIZE_ADMISSION_FLOW')">
            <li>
                <c:choose>
                    <c:when test="${menuChoice == 'students'}">
                        <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.students" />&nbsp;&nbsp;|</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.students" />&nbsp;&nbsp;|</a>
                    </c:otherwise>
                </c:choose>
                <ul>
                    <sec:authorize access="hasRole('student')">
                        <li><a href="<c:url value='/college/student/personal/mydetails.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.personaldata" /></a></li>
                        <li><a href="<c:url value='/college/student/subscription/mydetails.view?newForm=true&amp;tab=2'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.subscriptiondata" /></a></li>
                    </sec:authorize>
                    <sec:authorize access="!hasRole('student')">
                        <li><a href="<c:url value='/college/students.view?newForm=true&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
<%--                         <li><a href="<c:url value='/college/studentsclassgroup.view?newForm=true&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="studentsclassgroup.header" /></a></li> --%>
                    </sec:authorize>
                    <sec:authorize access="hasRole('CREATE_STUDENTS')">
                        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a>
                            <ul>
                                <li><a href="<c:url value='/college/student/personal.view?newForm=true&amp;tab=0&amp;panel=0&amp;searchValue='/>" class="MenuBarItemSubmenu" title="<fmt:message key='jsp.menu.title.detailed' />"><fmt:message key="jsp.menu.detailed" /></a></li>
                                <c:forEach var="addStudentScreenExtension" items="${collegeWebExtensions.addStudentScreenExtensions}">
                                    <li><a href="<c:url value='${addStudentScreenExtension.href}'/>" class="MenuBarItemSubmenu" title="<fmt:message key='${addStudentScreenExtension.descriptionKey}' />"><fmt:message key="${addStudentScreenExtension.titleKey}" /></a></li>
                                </c:forEach>
                            </ul>
                        </li>
                    </sec:authorize>
                    
                    <sec:authorize access="hasAnyRole('TRANSFER_STUDENTS','UPDATE_PROGRESS_STATUS','CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','SUBSCRIBE_TO_SUBJECTS_PENDING_APPROVAL','APPROVE_SUBJECT_SUBSCRIPTIONS', 'FINALIZE_ADMISSION_FLOW')">
<!--                         <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.massassignments" /></a> -->
<!--                             <ul> -->
                                <sec:authorize access="hasAnyRole('TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR','PROGRESS_ADMISSION_FLOW','FINALIZE_ADMISSION_FLOW')">
                                    <li><a href="<c:url value='/college/students.view?newForm=true&amp;admissionFlow=Y&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.flow.admission" /></a></li>
                                </sec:authorize>
                                <sec:authorize access="hasAnyRole('TRANSFER_STUDENTS','UPDATE_PROGRESS_STATUS','CREATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL')">
                                    <li><a href="<c:url value='/college/person/transferStudents.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.transferstudents" /></a></li>
                                </sec:authorize>
                                <sec:authorize access="hasAnyRole('PROGRESS_CONTINUED_REGISTRATION_FLOW','FINALIZE_CONTINUED_REGISTRATION_FLOW')">
                                    <li><a href="<c:url value='/college/students.view?newForm=true&amp;continuedRegistrationFlow=Y&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.flow.continuedregistration" /></a></li>
                                </sec:authorize>
                                <sec:authorize access="hasAnyRole('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','APPROVE_SUBJECT_SUBSCRIPTIONS', 'FINALIZE_ADMISSION_FLOW')">
                                    <li><a href="<c:url value='/college/person/subscribeToSubjects.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.subscribe.to.subjects" /></a></li>
                                </sec:authorize>
<%--                             <li><a href="<c:url value='/college/massassignment.view'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.assignstudyyears" /></a></li> --%>
<%--                             <li><a href="<c:url value='/college/studentsstatuses.view?newForm=true'/>" class="MenuBarItemSubmenu" title="<fmt:message key='jsp.menu.title.assignstatuses' />"><fmt:message key="jsp.menu.assignstatuses" /></a></li> --%>
<!--                             </ul> -->
<!--                         </li> -->
                    </sec:authorize>
                   
                </ul>
            </li>
            </sec:authorize> 
            
            <sec:authorize access="hasAnyRole('CREATE_STUDIES','READ_STUDIES','UPDATE_STUDIES','DELETE_STUDIES'
                                            ,'CREATE_SUBJECTS','READ_SUBJECTS','UPDATE_SUBJECTS','DELETE_SUBJECTS'
                                            ,'CREATE_SUBJECTBLOCKS','READ_SUBJECTBLOCKS','UPDATE_SUBJECTBLOCKS','DELETE_SUBJECTBLOCKS'
                                            ,'TRANSFER_CURRICULUM'
                                            ,'CREATE_ACADEMIC_YEARS','READ_ACADEMIC_YEARS','UPDATE_ACADEMIC_YEARS','DELETE_ACADEMIC_YEARS')">
            <li>
                <c:choose>
                    <c:when test="${menuChoice == 'studies'}">
                        <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.general.curriculum" />&nbsp;&nbsp;|</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="MenuBarItem"><fmt:message key="jsp.general.curriculum" />&nbsp;&nbsp;|</a>
                    </c:otherwise>
                </c:choose>
                <ul>
                    <sec:authorize access="hasAnyRole('CREATE_STUDIES','READ_STUDIES','UPDATE_STUDIES','DELETE_STUDIES')">
                        <c:url var="studiesUrl" value='/college/studies.view?newForm=true'/>
                        <li><a href="<c:out value='${studiesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.studies" /></a>
                            <ul>
                                <li><a href="<c:out value='${studiesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <sec:authorize access="hasRole('CREATE_STUDIES')">
                                   <li><a href="<c:url value='/college/study.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                </sec:authorize>
                            </ul>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('CREATE_SUBJECTS','READ_SUBJECTS','UPDATE_SUBJECTS','DELETE_SUBJECTS')">
                        <c:url var="subjectsUrl" value="/college/subjects.view">
                            <c:param name="newForm" value="${true}"/>
                            <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                            <c:param name="searchValue" value="" />
                        </c:url>
                        <li><a href="<c:out value='${subjectsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.subjects" /></a>
                            <ul>
                                <li><a href="<c:out value='${subjectsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <sec:authorize access="hasRole('CREATE_SUBJECTS')">
                                   <li><a href="<c:url value='/college/subject.view?tab=0&amp;panel=0&amp;searchValue=&amp;newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                </sec:authorize>
                            </ul>
                        </li>
                    </sec:authorize>

                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                    <sec:authorize access="hasAnyRole('CREATE_SUBJECTBLOCKS','READ_SUBJECTBLOCKS','UPDATE_SUBJECTBLOCKS','DELETE_SUBJECTBLOCKS')">
                            <c:url var="subjectBlocksUrl" value="/college/subjectblocks.view">
                                <c:param name="newForm" value="${true}"/>
                                <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                                <c:param name="searchValue" value="" />
                            </c:url>
	                        <li><a href="<c:out value='${subjectBlocksUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.subjectblocks" /></a>
	                            <ul>
	                                <li><a href="<c:out value='${subjectBlocksUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
	                                <sec:authorize access="hasRole('CREATE_SUBJECTBLOCKS')">
	                                   <li><a href="<c:url value='/college/subjectblock.view?newForm=true&amp;tab=0&amp;panel=0&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
	                                </sec:authorize>
	                            </ul>
	                        </li>
	                    </sec:authorize>
                    </c:if>

                    <sec:authorize access="hasAnyRole('CREATE_CLASSGROUPS','READ_CLASSGROUPS','UPDATE_CLASSGROUPS','DELETE_CLASSGROUPS')">
                        <c:url var="classgroupsUrl" value='/college/classgroups.view'>
                            <c:param name="newForm" value="${true}"/>
                            <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                            <c:param name="searchValue" value="" />
                        </c:url>
                        <li><a href="<c:out value='${classgroupsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.classgroups" /></a>
                            <ul>
                                <li><a href="<c:out value='${classgroupsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <sec:authorize access="hasRole('CREATE_CLASSGROUPS')">
                                   <li><a href="<c:url value='/college/classgroup.view?tab=0&amp;panel=0&amp;searchValue=&amp;newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                </sec:authorize>
                            </ul>
                        </li>
                    </sec:authorize>

                    <sec:authorize access="hasRole('TRANSFER_CURRICULUM')">
                        <li><a href="<c:url value='/college/study/curriculumTransition/init.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.curriculumtransition" /></a></li>
                    </sec:authorize>

                    <sec:authorize access="hasAnyRole('CREATE_ACADEMIC_YEARS','READ_ACADEMIC_YEARS','UPDATE_ACADEMIC_YEARS','DELETE_ACADEMIC_YEARS')">
                        <c:url var="academicYearsUrl" value='/college/academicyears.view?newForm=true'/>
                        <li><a href="<c:out value='${academicYearsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.academicyears" /></a>
<%--                            <ul>
                                <li><a href="<c:url value='/college/academicyears.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <sec:authorize access="hasRole('CREATE_ACADEMIC_YEARS')">
                                    <li><a href="<c:url value='/college/academicyear.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                </sec:authorize>
                            </ul> --%>
                        </li>
                    </sec:authorize>
                </ul>
            </li> 
            </sec:authorize>
            
            <sec:authorize access="hasAnyRole('CREATE_STAFFMEMBERS','READ_STAFFMEMBERS','UPDATE_STAFFMEMBERS','DELETE_STAFFMEMBERS')"> 
            <li>
                <c:choose>
                    <c:when test="${menuChoice == 'staffmembers'}">
                        <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.staffmembers" />&nbsp;&nbsp;|</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.staffmembers" />&nbsp;&nbsp;|</a>
                    </c:otherwise>
                </c:choose>
                <ul>
                    <li><a href="<c:url value='/college/staffmembers.view?newForm=true&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                    <sec:authorize access="hasRole('CREATE_STAFFMEMBERS')">
                            <li><a href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=0&amp;panel=0&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                    </sec:authorize>
                </ul>
            </li> 
            </sec:authorize>

            <sec:authorize access="hasAnyRole('CREATE_INSTITUTIONS','READ_INSTITUTIONS','UPDATE_INSTITUTIONS','DELETE_INSTITUTIONS', 
                                            'CREATE_BRANCHES','READ_BRANCHES','UPDATE_BRANCHES','DELETE_BRANCHES',
                                            'CREATE_ORG_UNITS','READ_ORG_UNITS','READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','UPDATE_PRIMARY_AND_CHILD_ORG_UNITS','DELETE_ORG_UNITS')">
                <li>
                    <c:choose>
                        <c:when test="${menuChoice == 'institutions'}">
                            <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.header.institutions" />&nbsp;&nbsp;|</a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.header.institutions" />&nbsp;&nbsp;|</a>
                        </c:otherwise>
                    </c:choose>
                    <ul>
                        <sec:authorize access="hasAnyRole('CREATE_INSTITUTIONS','READ_INSTITUTIONS','UPDATE_INSTITUTIONS','DELETE_INSTITUTIONS')">
                            <c:url var="institutionsUrl" value='/college/institutions.view'>
                                <c:param name="newForm" value="${true}"/>
                                <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                                <c:param name="searchValue" value="" />
                            </c:url>
                            <li><a href="<c:out value='${institutionsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.institutions" /></a>
                                <ul>
                                    <li><a href="<c:out value='${institutionsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                    <sec:authorize access="hasRole('CREATE_INSTITUTIONS')">
                                        <li><a href="<c:url value='/college/institution.view?newForm=true&amp;institutionTypeCode=${INSTITUTION_TYPE_HIGHER_EDUCATION}&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                    </sec:authorize>
                                </ul>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="hasAnyRole('CREATE_BRANCHES','READ_BRANCHES','UPDATE_BRANCHES','DELETE_BRANCHES')">
                            <c:url var="branchesUrl" value='/college/branches.view'>
                                <c:param name="newForm" value="${true}"/>
                                <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                                <c:param name="searchValue" value="" />
                            </c:url>
                            <li><a href="<c:out value='${branchesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.branches" /></a>
                                <ul>
                                    <li><a href="<c:out value='${branchesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                    <sec:authorize access="hasAnyRole('CREATE_BRANCHES')">
                                        <li><a href="<c:url value='/college/branch.view?newForm=true&amp;institutionTypeCode=${INSTITUTION_TYPE_HIGHER_EDUCATION}&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                    </sec:authorize>
                                </ul>
                            </li>
                        </sec:authorize><%--branches menu sec --%>
                        <sec:authorize access="hasAnyRole('CREATE_ORG_UNITS','READ_ORG_UNITS','READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','DELETE_ORG_UNITS')">
                            <c:url var="orgunitsUrl" value='/college/organizationalunits.view'>
                                <c:param name="newForm" value="${true}"/>
                                <c:param name="institutionTypeCode" value="${INSTITUTION_TYPE_HIGHER_EDUCATION}" />
                                <c:param name="searchValue" value="" />
                            </c:url>
                            <li><a href="<c:out value='${orgunitsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.organizationalunits" /></a>
                                <ul>
                                <li><a href="<c:out value='${orgunitsUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <sec:authorize access="hasAnyRole('CREATE_ORG_UNITS')">    
                                    <li><a href="<c:url value='/college/organizationalunit.view?newForm=true&amp;tab=0&amp;panel=0&amp;institutionTypeCode=${INSTITUTION_TYPE_HIGHER_EDUCATION}&amp;unitLevel=1&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                </sec:authorize>
                                </ul>
                            </li>
                        </sec:authorize><%--organizational unit menu sec --%>
                    </ul>
                </li>
            </sec:authorize><%--institutions menu sec --%> 

            <sec:authorize access="hasRole('ADMINISTER_SYSTEM')">
                <li>
                    <c:choose>
                        <c:when test="${menuChoice == 'admin'}">
                            <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.admin" />&nbsp;&nbsp;|</a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.admin" />&nbsp;&nbsp;|</a>
                        </c:otherwise>
                    </c:choose>
                    <ul>
                        
                        <li><a href="<c:url value='/college/lookuptables.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.lookuptables" /></a></li>
                        
                        <%--logs menu   ! under water ! - - % >
                        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.logs" /></a>
                            <ul>
                                <li><a href="<c:url value='/college/logmailerrors.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.mailerrors" /></a></li>
                                <li><a href="<c:url value='/college/logrequesterrors.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.requesterrors" /></a></li>
                            </ul>
                        </li>
                        < % - -logs menu - - % >

                        <li><a href="<c:url value='/college/mailconfigitems.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.mailconfig" /></a></li>
                        under water until here --%>

                        <%-- DB upgrades are now run automatically on server startup, so the db upgrade screen should not be neede anymore
                        <li><a href="<c:url value='/college/module/dbupgrade.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.module.dbupgrade" /></a></li>
                         --%>

                        <%-- DEACTIVATED, not working
                        <li><a href="<c:url value='/college/imports.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.import" /></a></li>
                        <li><a href="<c:url value='/college/exports.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.export" /></a></li>
						--%>
						
						<%--endgrades menu --%>
                        <c:url var="endgradesUrl" value='/college/endgrades.view'>
                            <c:param name="newForm" value="${true}"/>
                        </c:url>
                        <li><a href="<c:out value='${endgradesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.endgrades" /></a>
                            <ul>
                                <li><a href="<c:out value='${endgradesUrl}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <li><a href="<c:url value='/college/endgrade.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                            </ul>
                        </li>
                        <%--endgrades menu --%>

                        <%-- Secondary schools menu --%>
                        <sec:authorize access="hasAnyRole('CREATE_SECONDARY_SCHOOLS','READ_SECONDARY_SCHOOLS','DELETE_SECONDARY_SCHOOLS','UPDATE_SECONDARY_SCHOOLS')"> 
                            <li>
                                <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.secondaryschools" /></a>
                                <ul>
                                    <li><a href="<c:url value='/college/institutions.view?newForm=true&amp;institutionTypeCode=${INSTITUTION_TYPE_SECONDARY_SCHOOL}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                    
                                    <sec:authorize access="hasRole('CREATE_SECONDARY_SCHOOLS')">
                                    <li><a href="<c:url value='/college/institution.view?newForm=true&amp;institutionTypeCode=${INSTITUTION_TYPE_SECONDARY_SCHOOL}'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                    </sec:authorize>
                                </ul>
                            </li>
                        </sec:authorize>
                        <%-- Secondary schools menu --%>

                        <%-- secondary school subjects: it only makes sense to show this part when at least one sec.subject can be selected --%>
                        <c:if test="${appConfigManager.secondarySchoolSubjectsCount > 0}">
                            <%-- SecondarySchoolSubjects Menu --%>
                            <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.secondaryschoolsubjects" /></a>
                                <ul>
                                    <li><a href="<c:url value='/college/secondaryschoolsubjects.view?newForm=true&amp;institutionTypeCode=${ INSTITUTION_TYPE_HIGHER_EDUCATION }&amp;searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                    <sec:authorize access="hasRole('CREATE_SUBJECTS')">
                                       <li><a href="<c:url value='/college/secondarySchoolSubject.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                    </sec:authorize>
                                </ul>
                            </li>
                            <%-- End of SecondarySchoolSubjects Menu --%>
                        </c:if>
    
                        <%-- Discipline groups menu --%> 
                        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.disciplinegroups" /></a>
                            <ul>
                                <li><a href="<c:url value='/college/disciplinegroups.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                <li><a href="<c:url value='/college/disciplinegroup.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>

                            </ul>
                        </li>
                        <%-- End of Discipline group Menu --%>

                        <%--appconfig menu --%>
                        <li>
                            <a href="<c:url value='/college/appconfig.view?newForm=true'/>" class="MenuBarItemSubmenu">
                                <fmt:message key="jsp.menu.appconfig" />
                            </a>
                        </li>
                        <%--appconfig menu --%>

                        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.roles" /></a>
                            <ul>

                            <%--roles menu --%>
                                <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.roles" /></a>
                                    <ul>
                                        <li><a href="<c:url value='/college/roles.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                                        <li><a href="<c:url value='/college/role.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                                    </ul>
                                </li>
                            <%--roles menu --%>

                            <%--privileges menu --%>
                            <li>
                            	<a href="<c:url value='/college/privileges.view?newForm=true'/>" class="MenuBarItemSubmenu">
                            		<fmt:message key="jsp.menu.privileges" />
                            	</a>
                            </li>
                            <%--privileges menu --%>

                            </ul>
                        </li>

                        <%--reports menu --%>
                       	<li>
              				<a href="<c:url value='/college/report/reports.view?newForm=true&amp;viewName=admin/reports'/>" class="MenuBarItemSubmenu">
              					<fmt:message key="jsp.menu.reports" />
              				</a>
              			 </li>
          			    <%--reports menu --%>

                        <%--extension points menu --%>
                        <li>
                            <a href="<c:url value='/college/collegeextensions.view'/>" class="MenuBarItemSubmenu">
                                <fmt:message key="jsp.menu.extensionpoints" />
                            </a>
                        </li>
                        <%--college extensions menu --%>
                    </ul>

                </li>
            </sec:authorize>

<%--         <sec:authorize access="hasAnyRole('GENERATE_STUDENT_REPORTS','GENERATE_STATISTICS')">  --%>
            <li>
            
                <c:choose>
                    <c:when test="${menuChoice == 'report'}">
                        <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.reports" />&nbsp;&nbsp;|</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.reports" />&nbsp;&nbsp;|</a>
                    </c:otherwise>
                </c:choose>
                <ul>
<%--                     <sec:authorize access="hasRole('GENERATE_STUDENT_REPORTS')">  --%>
                        <li><a href="<c:url value='/report/studentsreportsoverview.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.students" /></a></li>
                        <li><a href="<c:url value='/report/curriculumreportsoverview.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.curriculum" /></a></li>
<%--                     </sec:authorize> --%>
                    <sec:authorize access="hasRole('GENERATE_STATISTICS')"> 
                        <li><a href="<c:url value='/report/statisticsoverview.view?newForm=true'/>?viewName=admin_statisticsreports&amp;newForm=true" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.statistics" /></a></li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('GENERATE_HISTORY_REPORTS')"> 
                        <li><a href="<c:url value='/report/historyreport.view'/>" ><fmt:message key="jsp.menu.history" /></a></li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ADMINISTER_SYSTEM')"> 
                        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.admin" /></a>
                        <ul>
                            <li><a href="<c:url value='/college/report/reports.view'/>?viewName=admin/admin_studentsreports&amp;newForm=true" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.students" /></a></li>
                            <li><a href="<c:url value='/college/report/reports.view'/>?viewName=admin/admin_curriculumreports&amp;newForm=true" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.curriculum" /></a></li>
                            <li><a href="<c:url value='/college/report/reports.view'/>?viewName=admin/admin_statisticsreports&amp;newForm=true" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.statistics" /></a></li>
                        </ul>
                        </li>
                    </sec:authorize> 
                 
                </ul>
            </li>
<%--         </sec:authorize>  --%>

    </ul>
</div>

<script type="text/javascript">
<!--
    var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"<c:url value='/images/trans.gif' />", imgRight:"<c:url value='/images/trans.gif' />"});
    var MenuBar2 = new Spry.Widget.MenuBar("MenuBar2", {imgDown:"<c:url value='/images/trans.gif' />", imgRight:"<c:url value='/images/trans.gif' />"});

//-->
</script>
