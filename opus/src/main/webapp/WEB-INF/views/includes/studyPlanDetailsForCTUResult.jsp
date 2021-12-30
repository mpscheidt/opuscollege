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

	<!--   SUBJECT RESULTS LIST for this CARDINAL TIME UNIT -->
	<table class="tabledata2" id="TblData_subjectresults">
       <tr>
            <th class="width1"><fmt:message key="jsp.general.academicyear" /></th>
            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                <th><fmt:message key="jsp.general.subjectblock" /></th>
            </c:if>
            <th><fmt:message key="jsp.general.subject" /></th>
            <th class="width1"><fmt:message key="table.header.credit" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th><fmt:message key="jsp.general.subjectresult" /></th>
            <th>&nbsp;</th>
        </tr>

        <c:forEach var="studyPlanDetail" items="${cardinalTimeUnitResultForm.allStudyPlanDetails}">

			<%-- SUBJECTBLOCK: all subjects for the subject block are displayed in a separate line 
                 TODO: Make an include that displays a line, which serves for subject block subjects as well as single subjects
            --%>
            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                <c:if test="${studyPlanDetail.subjectBlockId != 0}">
                    <c:set var="rowDisplayed" value="${true}" />
                    <c:forEach var="subjectBlock" items="${cardinalTimeUnitResultForm.allSubjectBlocks}" >
                        <c:choose>
                            <c:when test="${subjectBlock.id == studyPlanDetail.subjectBlockId}" >
                                 <c:forEach var="subjectSubjectBlock" items="${cardinalTimeUnitResultForm.allSubjectSubjectBlocks}"  >
                                  <c:choose>
                                        <c:when test="${studyPlanDetail.subjectBlockId == subjectSubjectBlock.subjectBlockId}" >
                                            <c:forEach var="subject" items="${cardinalTimeUnitResultForm.allSubjects}" >
                                                <c:set var="subjectResultSave" value="" scope="page" />
                                                <c:choose>
                                                    <c:when test="${subject.id == subjectSubjectBlock.subject.id}" >
                                                        <c:set var="authorizationKey" value="${studyPlanDetail.id}-${subject.id}" />
                                                        <c:set var="authorization" value="${cardinalTimeUnitResultForm.subjectResultAuthorizationMap[authorizationKey]}" scope="page" />

                                                        <c:choose>
                                                            <c:when test="${authorization.update}">
                                                                <fmt:message var="linkText" key="result.edit"></fmt:message>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:message var="linkText" key="result.view.details"></fmt:message>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <tr>
                                                        <td>
                                                           <c:forEach var="academicYear" items="${cardinalTimeUnitResultForm.allAcademicYears}">
                                                              <c:choose>
                                                                 <c:when test="${academicYear.id == subject.currentAcademicYearId}">
                                                                    <c:out value="${academicYear.description}"/>
                                                                 </c:when>
                                                              </c:choose>
                                                            </c:forEach> 
                                                        </td>
                                                        <td>
                                                            <c:forEach var="study" items="${cardinalTimeUnitResultForm.allStudies}">
                                                                <c:if test="${study.id == subjectBlock.primaryStudyId}" >
                			                           				<c:forEach var="orgUnit" items="${allOrganizationalUnits}">
                			                           					<c:if test="${study.organizationalUnitId == orgUnit.id}">
                			                           						<c:out value="${orgUnit.organizationalUnitDescription}"/> / 
                			                           					</c:if>
                			                           				</c:forEach>
                			                           				<c:out value="${study.studyDescription}"/> - 
                				                           		</c:if>
                			                           		</c:forEach>
                                                            <c:out value="${subjectBlock.subjectBlockDescription}"/> 
                                                            <c:forEach var="academicYear" items="${cardinalTimeUnitResultForm.allAcademicYears}">
                                                               <c:choose>
                                                               <c:when test="${academicYear.id == subjectBlock.currentAcademicYearId}">
                                                            		<c:out value="(${academicYear.description})"/>
                                                                </c:when>
                                                               </c:choose>
                                                            </c:forEach> 	
                                                        </td>
                               							<td><c:out value="${subject.subjectDescription}"/></td>
                               							<td><c:out value="${subject.creditAmount}"/></td>
                                                        <td><c:out value="${subject.active}"/></td>
                                                        <td>
                                                            <c:if test="${studyPlanDetail.exempted}">
                                                                <fmt:message key="general.exempted"/>
                                                            </c:if>
                                                            <table>
                                                                <c:forEach var="subjectResult" items="${cardinalTimeUnitResultForm.allSubjectResultsForStudyPlanCardinalTimeUnit}">
                                                                    <c:choose>
                                                                        <c:when test="${subjectResult.subjectId == subject.id 
                                                                                      and subjectResult.studyPlanDetailId == studyPlanDetail.id}">
                                                                            <tr>
                                                                                <td>
                                                                                    <c:if test="${not authorization.read and not studypLanCardinalTimeUnit.resultsPublished}">
                                                                                        (<fmt:message key="jsp.general.hidden" />)
                                                                                    </c:if>
                                                                                    <c:if test="${authorization.read}">
                                                                                        <a title="${linkText}" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;subjectResultId=${subjectResult.id}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                                            <c:out value="${cardinalTimeUnitResultForm.subjectResultFormatter[subjectResult]}"/>
                                                                                            <c:choose>
                                                                                                <c:when test="${subject.resultType eq ATTACHMENT_RESULT}">
                                                                                                    <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullAREndGradeCommentsForGradeType}">
                                                                                                      <c:if test="${endGrade.code == subjectResult.endGradeComment}">
                                                                                                           - <c:out value="${endGrade.comment}"/>
                                                                                                      </c:if>
                                                                                                      </c:forEach>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullEndGradeCommentsForGradeType}">
                                                                                                      <c:if test="${endGrade.code == subjectResult.endGradeComment}">
                                                                                                           - <c:out value="${endGrade.comment}"/>
                                                                                                      </c:if>
                                                                                                      </c:forEach>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </a>
                                                                                        (<fmt:formatDate pattern="dd/MM/yyyy" value="${subjectResult.subjectResultDate}" />)
                                                                                    </c:if>
                                                                                </td>
                                                                                <td class="buttonsCell"  style="white-space: nowrap;">
                                                                                    <c:if test="${authorization.read or authorization.update}">
                                                                                   		<a class="imageLink" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;subjectResultId=${subjectResult.id}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                                            <img src="<c:url value='/images/edit.gif'/>" alt="${linkText}" title="${linkText}" />
                                                                                        </a>
                                                                                    </c:if>
                                                                                    <c:if test="${authorization.delete}">
                                                                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/cardinaltimeunitresult/delete.view?newForm=true&amp;subjectResultId=${subjectResult.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=${navigationSettings.tab}&amp;panel=${panel}'/>">
                                                                                            <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                                        </a>
                                                                                    </c:if>
                                                                                    <sec:authorize access="hasAnyRole('RESULT_HISTORY')">
	                                                                                     <a class="imageLinkPaddingLeft" href="<c:url value='/college/cardinaltimeunitresult/subjectHistory/${subjectResult.subjectId}/${subjectResult.studyPlanDetailId}'/>">
	                                                                                         <img src="<c:url value='/images/historylog.png'/>" alt="<fmt:message key="jsp.href.logs" />" title="<fmt:message key="jsp.href.logs" />" />
	                                                                                     </a>
                                                                                     </sec:authorize>
                                                                                </td>
                                                                            </tr>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </table>

                                                        </td>
                                                        <td class="buttonsCell">
                                                        <c:if test="${empty studyPlanCardinalTimeUnit.progressStatusCode
                                                                        and studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode eq CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED}">
                                                              <c:if test="${authorization.create}">
                                                                 <a class="button" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                  <fmt:message key="jsp.href.add" />
                                                                  </a>
                                                              </c:if>
                                                         </c:if>
                                                        </td>
                                                        </tr>
                                                    </c:when>
                                                </c:choose>

                                            </c:forEach>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                </c:if>
            </c:if>

<%--  SUBJECT within a cardinal time unit --%>		
            <c:if test="${studyPlanDetail.subjectId != 0}">
                <c:set var="rowDisplayed" value="${true}" />

                <c:forEach var="subject" items="${cardinalTimeUnitResultForm.allSubjects}" >
                    <c:set var="subjectResultSave" value="" scope="page" />
                    <c:choose>
                         <c:when test="${subject.id == studyPlanDetail.subjectId}" >
                            <c:set var="authorizationKey" value="${studyPlanDetail.id}-${subject.id}" />
                            <c:set var="authorization" value="${cardinalTimeUnitResultForm.subjectResultAuthorizationMap[authorizationKey]}" scope="page" />

                            <c:choose>
                                <c:when test="${authorization.update}">
                                    <fmt:message var="linkText" key="result.edit"></fmt:message>
                                </c:when>
                                <c:otherwise>
                                    <fmt:message var="linkText" key="result.view.details"></fmt:message>
                                </c:otherwise>
                            </c:choose>

                            <tr>
                            <td>
                                <c:forEach var="academicYear" items="${cardinalTimeUnitResultForm.allAcademicYears}">
                                  <c:choose>
                                     <c:when test="${academicYear.id == subject.currentAcademicYearId}">
                                        <c:out value="${academicYear.description}"/>
                                     </c:when>
                                  </c:choose>
                                </c:forEach>
                            </td>
                            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                <td>&nbsp;</td>
                            </c:if>
                            <td>
                                <c:forEach var="study" items="${cardinalTimeUnitResultForm.allStudies}">
                                    <c:if test="${study.id == subject.primaryStudyId}" >
                           				<c:forEach var="orgUnit" items="${allOrganizationalUnits}">
                           					<c:if test="${study.organizationalUnitId == orgUnit.id}">
                           						<c:out value="${orgUnit.organizationalUnitDescription}"/> / 
                           					</c:if>
                           				</c:forEach>
                           				<c:out value="${study.studyDescription}"/> - 
	                           		</c:if>
                           		</c:forEach>
                                <c:out value="${subject.subjectDescription}"/>
                            </td>
                            <td><c:out value="${subject.creditAmount}"/></td>
                            <td><c:out value="${subject.active}"/></td>
                            <td>
                                <c:if test="${studyPlanDetail.exempted}">
                                    <fmt:message key="general.exempted"/>
                                </c:if>
                                <table width="100%">
                                     <c:forEach var="subjectResult" items="${cardinalTimeUnitResultForm.allSubjectResultsForStudyPlanCardinalTimeUnit}">
                                         <c:choose>
                                             <c:when test="${subjectResult.subjectId == subject.id
                                                      and subjectResult.studyPlanDetailId == studyPlanDetail.id}">
                                                 <tr>
                                                 <td>
                                                    <c:if test="${not authorization.read and not studypLanCardinalTimeUnit.resultsPublished}">
                                                        (<fmt:message key="jsp.general.hidden" />)
                                                    </c:if>
                                                    <c:if test="${authorization.read}">
                                                        <a title="${linkText}" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;subjectResultId=${subjectResult.id}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                            <c:out value="${cardinalTimeUnitResultForm.subjectResultFormatter[subjectResult]}"/>
                                                            <c:choose>
                                                                <c:when test="${subject.resultType eq ATTACHMENT_RESULT}">
                                                                    <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullAREndGradeCommentsForGradeType}">
                                                                      <c:if test="${endGrade.code == subjectResult.endGradeComment}">
                                                                           - <c:out value="${endGrade.comment}"/>
                                                                      </c:if>
                                                                      </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullEndGradeCommentsForGradeType}">
                                                                      <c:if test="${endGrade.code == subjectResult.endGradeComment}">
                                                                           - <c:out value="${endGrade.comment}"/>
                                                                      </c:if>
                                                                      </c:forEach>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </a>
                                                        (<fmt:formatDate pattern="dd/MM/yyyy" value="${subjectResult.subjectResultDate}" />)
                                                    </c:if>
                                                 </td>
                                                 <td class="buttonsCell" style="white-space: nowrap;">
                                                     <c:if test="${authorization.read or authorization.update}">
                                                     	<a class="imageLink" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;subjectResultId=${subjectResult.id}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                            <img src="<c:url value='/images/edit.gif'/>" alt="${linkText}" title="${linkText}" />
                                                     	</a>
                                                     </c:if>
                                                     <c:if test="${authorization.delete}">
                                                     	<a class="imageLinkPaddingLeft" href="<c:url value='/college/cardinaltimeunitresult/delete.view?newForm=true&amp;subjectResultId=${subjectResult.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=${navigationSettings.tab}&amp;panel=${panel}'/>">
                                                            <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                     	</a>
                                                     </c:if>
                                                 </td>
                                                 </tr>
                                             </c:when>   
                                         </c:choose>
                                    </c:forEach>
                                </table>
                            </td>

                            <td class="buttonsCell">
                                 <c:if test="${authorization.create}">
                                	<a class="button" href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=cardinaltimeunitresult&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectId=${subject.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                	    <fmt:message key="jsp.href.add" />
                                	</a>
                                </c:if>
                            </td>
                        </tr>
                        </c:when>
                    </c:choose>
                </c:forEach> 
            </c:if> <!-- end of subject within a cardinal time unit -->
     	</c:forEach>

    </table>
    <script type="text/javascript">alternate('TblData_subjectresults',true)</script>
