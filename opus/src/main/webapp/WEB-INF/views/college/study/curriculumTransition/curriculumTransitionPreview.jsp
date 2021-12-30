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
 * author : Markus Pscheidt
--%>

<%@ include file="../../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.curriculumtransition.preview.header</c:set>
<%@ include file="../../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../../menu.jsp"%>
        
    <div id="tabcontent">
    
    <fieldset>
        <legend><fmt:message key="jsp.curriculumtransition.preview.header"/></legend>

        <p align="center">
            <fmt:message key="jsp.curriculumtransition.preview.introduction"/>
        </p>
    </fieldset>

    <form:form modelAttribute="curriculumTransitionForm" method="post" name="curriculumTransitionForm">

        <p><form:errors path="" cssClass="error"/></p>

        <table class="tabledata" id="TblData">
            <tr>
                <td width="20" style="vertical-align:bottom">
                    <form:checkbox id="checker" path="checker"
                                onclick="javascript:checkAll('data.selectedStudyGradeTypeIds');
                                    checkAll('data.selectedSubjectBlockIds');
                                    checkAll('data.selectedSubjectIds');
                                    checkAll('data.endGradesSelectedForTransfer');"
                                />
                </td>
                <th><fmt:message key="jsp.curriculumtransition.studygradetypes"/></th>
                <th><fmt:message key="jsp.curriculumtransition.associatedsubjects"/></th>
                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                    <th><fmt:message key="jsp.curriculumtransition.associatedsubjectblocks"/></th>
                </c:if>
            </tr>
            <c:forEach var="studyGradeTypeCT" items="${curriculumTransitionForm.data.eligibleStudyGradeTypes}">
                <tr>
                    <td>
                        <form:checkbox path="data.selectedStudyGradeTypeIds" value="${studyGradeTypeCT.originalId}"/>
                    </td>
                    <td class="label">
                        <c:set var="studyGradeType" value="${curriculumTransitionForm.idToStudyGradeTypeMap[studyGradeTypeCT.originalId]}" />
                        <c:out value="${studyGradeType.studyDescription}"/>,
                        <c:out value="${curriculumTransitionForm.codeToGradeTypeMap[studyGradeType.gradeTypeCode].description}"/>,
                        <c:out value="${curriculumTransitionForm.codeToStudyTimeMap[studyGradeType.studyTimeCode].description}"/>,
                        <c:out value="${curriculumTransitionForm.codeToStudyFormMap[studyGradeType.studyFormCode].description}"/>
                        <br/>
                    </td>
                    <td>
                        <c:forEach var="ssgt" items="${commonSubjectStudyGradeTypes}">
                            <c:if test="${ssgt.studyGradeTypeId == studyGradeTypeCT.originalId}">
                                <c:out value="${ssgt.subject.subjectDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                        <c:forEach var="ssgt" items="${subjectStudyGradeTypesForSGTs}">
                            <c:if test="${ssgt.studyGradeTypeId == studyGradeTypeCT.originalId}">
                                <c:out value="${ssgt.subject.subjectDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                    <td>
	                        <c:forEach var="sbsgt" items="${commonSubjectBlockStudyGradeTypes}">
	                            <c:if test="${sbsgt.studyGradeType.id == studyGradeTypeCT.originalId}">
	                                <c:out value="${sbsgt.subjectBlock.subjectBlockDescription}"/><br/>
	                            </c:if>
	                        </c:forEach>
	                        <c:forEach var="sbsgt" items="${subjectBlockStudyGradeTypesForStudyGradeTypes}">
	                            <c:if test="${sbsgt.studyGradeType.id == studyGradeTypeCT.originalId}">
	                                <c:out value="${sbsgt.subjectBlock.subjectBlockDescription}"/><br/>
	                            </c:if>
	                        </c:forEach>
	                    </td>
                    </c:if>
                </tr>
            </c:forEach>

            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
            <tr>
                <td/>
                <th><fmt:message key="jsp.curriculumtransition.subjectblocks"/></th>
                <th><fmt:message key="jsp.curriculumtransition.associatedstudygradetypes"/></th>
                <th><fmt:message key="jsp.curriculumtransition.associatedsubjects"/></th>
            </tr>
            <c:forEach var="subjectBlockCT" items="${curriculumTransitionForm.data.eligibleSubjectBlocks}">
                <tr>
                    <td>
                        <form:checkbox path="data.selectedSubjectBlockIds" value="${subjectBlockCT.originalId}"/>
                    </td>
                    <td class="label">
                        <c:forEach var="sb" items="${allSubjectBlocks}">
                            <c:if test="${sb.id == subjectBlockCT.originalId}">
                                    <c:out value="${sb.subjectBlockCode}"/>:
                                    <c:out value="${sb.subjectBlockDescription}"/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <c:forEach var="sbsgt" items="${commonSubjectBlockStudyGradeTypes}">
                            <c:if test="${sbsgt.subjectBlock.id == subjectBlockCT.originalId}">
                                <c:out value="${sbsgt.studyGradeType.studyDescription}"/>,
                                <c:out value="${curriculumTransitionForm.codeToGradeTypeMap[sbsgt.studyGradeType.gradeTypeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyTimeMap[sbsgt.studyGradeType.studyTimeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyFormMap[sbsgt.studyGradeType.studyFormCode].description}"/>
                                <br/>
                            </c:if>
                        </c:forEach>
                        <c:forEach var="sbsgt" items="${subjectBlockStudyGradeTypesForSubjectBlocks}">
                            <c:if test="${sbsgt.subjectBlock.id == subjectBlockCT.originalId}">
                                <c:out value="${sbsgt.studyGradeType.studyDescription}"/>,
                                <c:out value="${curriculumTransitionForm.codeToGradeTypeMap[sbsgt.studyGradeType.gradeTypeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyFormMap[sbsgt.studyGradeType.studyFormCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyTimeMap[sbsgt.studyGradeType.studyTimeCode].description}"/>
                                <br/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <c:forEach var="ssb" items="${commonSubjectSubjectBlocks}">
                            <c:if test="${ssb.subjectBlock.id == subjectBlockCT.originalId}">
                                <c:out value="${ssb.subject.subjectCode}"/>:
                                <c:out value="${ssb.subject.subjectDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                        <c:forEach var="ssb" items="${subjectSubjectBlocksForSubjectBlocks}">
                            <c:if test="${ssb.subjectBlock.id == subjectBlockCT.originalId}">
                                <c:out value="${ssb.subject.subjectCode}"/>:
                                <c:out value="${ssb.subject.subjectDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                    </td>
                </tr>
            </c:forEach>
            <tr/>   <%-- blank line to have a bit of vertical space --%>
            </c:if> <%-- appUseOfSubjectBlocks --%>
            
            <tr>
                <td/>
                <th><fmt:message key="jsp.curriculumtransition.subjects"/></th>
                <th><fmt:message key="jsp.curriculumtransition.associatedstudygradetypes"/></th>
                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                    <th><fmt:message key="jsp.curriculumtransition.associatedsubjectblocks"/></th>
                </c:if>
            </tr>
            <c:forEach var="subjectCT" items="${curriculumTransitionForm.data.eligibleSubjects}">
                <tr>
                    <td>
                        <form:checkbox path="data.selectedSubjectIds" value="${subjectCT.originalId}"/>
                    </td>
                    <td class="label">
                        <c:forEach var="s" items="${allSubjects}">
                            <c:if test="${s.id == subjectCT.originalId}">
                                <c:out value="${s.subjectCode}"/>:
                                <c:out value="${s.subjectDescription}"/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <c:forEach var="ssgt" items="${commonSubjectStudyGradeTypes}">
                            <c:if test="${ssgt.subjectId == subjectCT.originalId}">
                                <c:out value="${ssgt.studyDescription}"/>,
                                <c:out value="${curriculumTransitionForm.codeToGradeTypeMap[ssgt.studyGradeType.gradeTypeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyTimeMap[ssgt.studyGradeType.studyTimeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyFormMap[ssgt.studyGradeType.studyFormCode].description}"/>
                                <br/>
                            </c:if>
                        </c:forEach>
                        <c:forEach var="ssgt" items="${subjectStudyGradeTypesForSubjects}">
                            <c:if test="${ssgt.subjectId == subjectCT.originalId}">
                                <c:out value="${ssgt.studyDescription}"/>,
                                <c:out value="${curriculumTransitionForm.codeToGradeTypeMap[ssgt.studyGradeType.gradeTypeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyTimeMap[ssgt.studyGradeType.studyTimeCode].description}"/>,
                                <c:out value="${curriculumTransitionForm.codeToStudyFormMap[ssgt.studyGradeType.studyFormCode].description}"/>
                                <br/>
                            </c:if>
                        </c:forEach>
                    </td>
                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                    <td>
                        <c:forEach var="ssb" items="${commonSubjectSubjectBlocks}">
                            <c:if test="${ssb.subject.id == subjectCT.originalId}">
                                <c:out value="${ssb.subjectBlock.subjectBlockCode}"/>:
                                <c:out value="${ssb.subjectBlock.subjectBlockDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                        <c:forEach var="ssb" items="${subjectSubjectBlocksForSubjects}">
                            <c:if test="${ssb.subject.id == subjectCT.originalId}">
                                <c:out value="${ssb.subjectBlock.subjectBlockCode}"/>:
                                <c:out value="${ssb.subjectBlock.subjectBlockDescription}"/><br/>
                            </c:if>
                        </c:forEach>
                    </td>
                    </c:if>
                </tr>
            </c:forEach>
            
            <c:if test="${curriculumTransitionForm.data.nrOfGradesEligibleForTransfer > 0}">
                <tr/>   <%-- blank line to have a bit of vertical space --%>
                
                <tr>
                    <td/>
                    <th><fmt:message key="jsp.general.endgrades"/></th>
                    <th></th>
                    <th></th>
                </tr>
                <tr>
                    <td>
                        <form:checkbox path="data.endGradesSelectedForTransfer"/>
                    </td>
                    <td>
                        <fmt:message key="jsp.general.endgrades"/>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
            </c:if>            
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>                
        
            <table width="100%">
                <tr>
                    <td align="center">
                        <input type="submit" name="backToInitButton" value="<fmt:message key='jsp.curriculumtransition.goback'/>"/>
                        <input type="submit" name="transferButton" value="<fmt:message key='jsp.curriculumtransition.transfer'/>"
                        <c:if test="${curriculumTransitionForm.data.eligibleStudyGradeTypeCount==0 
                            && curriculumTransitionForm.data.eligibleSubjectBlockCount==0 
                            && curriculumTransitionForm.data.eligibleSubjectCount==0
                            && curriculumTransitionForm.data.nrOfGradesEligibleForTransfer==0}">
                            disabled="disabled"
                        </c:if>
                        />
                    </td>
                </tr>
            </table>
    </form:form>
    </div>
  
</div>

<%@ include file="../../../includes/javascriptfunctions.jsp"%>
<%@ include file="../../../footer.jsp"%>
