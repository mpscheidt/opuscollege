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

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>
    
    <c:set var="navigationSettings" value="${studyGradeTypeSubjectBlockForm.navigationSettings}" scope="page" />
    <c:set var="studyGradeType" value="${studyGradeTypeSubjectBlockForm.studyGradeType}" />

    <%-- authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_STUDYGRADETYPES','UPDATE_STUDYGRADETYPES')">
        <c:set var="editStudyGradeTypes" value="${true}"/>
    </sec:authorize>
    <c:if test="${not editStudyGradeTypes}">
        <sec:authorize access="hasRole('READ_STUDYGRADETYPES')">
            <c:set var="showStudyGradeTypes" value="${true}"/>
        </sec:authorize>
    </c:if>

    <div id="tabcontent">

        <fieldset><legend> 
            <a href="<c:url value='/college/studies.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
	       <a href="<c:url value='/college/study.view?tab=0&panel=0&studyId=${studyGradeType.studyId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	    			<c:choose>
	    				<c:when test="${studyGradeType.studyDescription != null && studyGradeType.studyDescription != ''}" >
        					${fn:substring(studyGradeType.studyDescription,0,initParam.iTitleLength)}
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.href.new" />
						</c:otherwise>
					</c:choose>
					</a> /
	    			<a href="<c:url value='/college/studygradetype.view?tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studyGradeTypeId=${studyGradeType.id}&studyId=${studyGradeType.studyId}&currentPageNumber=${navigationSettings.currentPageNumber}&from=subjectblockstudygradetype'/>">
	    			<c:choose>
	    				<c:when test="${studyGradeType.gradeTypeCode != null && studyGradeType.gradeTypeCode != ''}" >
                            ${studyGradeType.gradeTypeDescription}
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.href.new" />
						</c:otherwise>
					</c:choose>
					</a>
        			&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studygradetypesubjectblock" /> 
        </legend></fieldset>

<%-- <c:set var="commandGradeTypeCode" value="${studyGradeTypeSubjectBlockForm.studyGradeType.gradeTypeCode}" scope="page" /> --%>
<%-- <c:set var="commandStudyId" value="${studyGradeTypeSubjectBlockForm.studyGradeType.studyId}" scope="page" /> --%>

<div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
    </ul>
    <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent">
            <div class="Accordion" id="Accordion1" tabindex="0">
                <div class="AccordionPanel">
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.studygradetypesubjectblock" /></div>
                        <div class="AccordionPanelContent">

                            <%--Display error messages --%>
                            <form:errors path="studyGradeTypeSubjectBlockForm.*" cssClass="errorwide" element="p"/>

<%--                         	<c:choose>        
				            	<c:when test="${ not empty showStudyGradeTypeSubjectBlockError }">
				                	<p align="left" class="error">
				            			${showStudyGradeTypeSubjectBlockError}
				            		</p>
				            </c:when>
				            </c:choose> --%>
				            
                            <form:form modelAttribute="studyGradeTypeSubjectBlockForm" method="post">
                            <input type="hidden" id="submitter" name="submitter" value="" />

                            <table>

<%@ include file="../../includes/navigation_privileges.jsp"%>

<c:set var="organization" value="${studyGradeTypeSubjectBlockForm.organization}" />
<c:if test="${showInstitutions}">
          <tr>
              <td class="label"><b><fmt:message key="jsp.general.university" /></b></td>
              <td class="required">
              <form:select path="organization.institutionId" onchange="document.getElementById('organization.branchId').value='0';
                                                    document.getElementById('organization.organizationalUnitId').value='0';
                                                    document.getElementById('studyId').value='0';
                                                    document.getElementById('subjectBlockStudyGradeType.subjectBlock.id').value='0';
                                                    document.getElementById('submitter').value=this.id;
                                                    this.form.submit();">
                  <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                  <c:forEach var="oneInstitution" items="${organization.allInstitutions}">
                    <form:option value="${oneInstitution.id}" label="${oneInstitution.institutionDescription}" />
<%--                     <c:choose>
                     <c:when test="${ oneInstitution.id == institutionId }"> 
                         <option value="${oneInstitution.id}" selected="selected">${oneInstitution.institutionDescription}</option>
                      </c:when>
                      <c:otherwise>
                          <option value="${oneInstitution.id}">${oneInstitution.institutionDescription}</option>
                      </c:otherwise>
                     </c:choose> --%>
                  </c:forEach>
              </form:select>
              </td> 
         </tr>
</c:if>

<c:if test="${showBranches}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.branch" /></b></td>
                <td class="required">
                <form:select path="organization.branchId" onchange="document.getElementById('organization.organizationalUnitId').value='0';
                                                    document.getElementById('studyId').value='0';
                                                    document.getElementById('subjectBlockStudyGradeType.subjectBlock.id').value='0';
                                                    document.getElementById('submitter').value=this.id;
                                                    this.form.submit();">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="oneBranch" items="${organization.allBranches}">
                        <form:option value="${oneBranch.id}" label="${oneBranch.branchDescription}" />
<%--                        <c:choose>
                            <c:when test="${ oneBranch.id == branchId }"> 
                                <option value="${oneBranch.id}" selected="true">${oneBranch.branchDescription}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${oneBranch.id}">${oneBranch.branchDescription}</option>
                            </c:otherwise>
                        </c:choose> --%>
                    </c:forEach>
                </form:select>
                </td>
           </tr>
</c:if>
        
<c:if test="${showOrgUnits}">
             <tr>
                 <td class="label"><b><fmt:message key="jsp.general.organizationalunit" /></b></td>
                 <td class="required">
                 <form:select path="organization.organizationalUnitId" onchange="document.getElementById('studyId').value='0';
                                                                                        document.getElementById('subjectBlockStudyGradeType.subjectBlock.id').value='0';
                                                                                        document.getElementById('submitter').value=this.id;
                                                                                        this.form.submit();">
                     <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                     <c:forEach var="oneOrganizationalUnit" items="${organization.allOrganizationalUnits}">
                        <form:option value="${oneOrganizationalUnit.id}" label="${oneOrganizationalUnit.organizationalUnitDescription}"></form:option>
<%--                         <c:choose>
                             <c:when test="${ oneOrganizationalUnit.id == organizationalUnitId }"> 
                                 <option value="${oneOrganizationalUnit.id}" selected="selected">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                             </c:when>
                             <c:otherwise>
                                 <option value="${oneOrganizationalUnit.id}">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                             </c:otherwise>
                         </c:choose> --%>
                     </c:forEach>
                 </form:select>
                 </td>
            </tr>
</c:if>                            
                            <!--  STUDY ID -->
                                        <c:choose>
                                            <c:when test="${editStudyGradeTypes}">
                                    
                                                
					                           <!--  <input type="hidden" id="studyId" value="${studyGradeType.studyId}" />  -->                                                     
                                               
                                                    <tr>
                                                        <td width="200" class="label"><fmt:message key="jsp.general.study" /></td>
                                                        <td class="required">
                                                        
                                            			<form:select path="studyId" onchange="
                                                                            			document.getElementById('subjectBlockStudyGradeType.subjectBlock.id').value='0';
                                                                                        document.getElementById('submitter').value=this.id;
                                            			                                this.form.submit();">
                                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                            <c:forEach var="oneStudy" items="${studyGradeTypeSubjectBlockForm.allStudies}">
                                                                <c:choose>
                                                                    <c:when test="${studyGradeTypeSubjectBlockForm.studyId == oneStudy.id}"> 
                                                                        <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                       <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                                                    </c:otherwise>
                                                                </c:choose>        
                                                            </c:forEach>
                                                        </form:select>
                                                        </td> 
                                                        <td></td>   
                                                   </tr>
                                        </c:when>
                                        </c:choose>
                            

                                <!--  SUBJECT BLOCK -->
                             <tr>
                                 <td width="200" class="label"><fmt:message key="jsp.general.subjectblock" /></td>
                                 <td class="required">
                                 <form:select path="subjectBlockStudyGradeType.subjectBlock.id" >
                                     <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                     <!-- loop through all subjectblocks linked to the selected study -->
                                            <c:forEach var="oneSubjectBlock" items="${studyGradeTypeSubjectBlockForm.allSubjectBlocks}">
                                                <c:set var="disabled" value="" scope="page" />
                                                <!-- if new subjectblockstudygradetype is already a linked to the studyGradeType: don't show the subject -->
                                                <c:forEach var="oneSubjectBlockId" items="${studyGradeTypeSubjectBlockForm.allSubjectBlockIdsForStudyGradeType}">
                                                    <c:choose>
                                                        <c:when test="${(status.value == 0 && oneSubjectBlock.id == oneSubjectBlockId)}">
                                                            <c:set var="disabled" value="disabled" scope="page" />
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <c:choose>
                                             	<c:when test="${disabled == ''}">
                                                    <form:option value="${oneSubjectBlock.id}"><c:out value="${oneSubjectBlock.subjectBlockDescription}" /></form:option>
<%--                                                   	<c:choose>
                                                  			<c:when test="${status.value == oneSubjectBlock.id}">
                                                          		<option value="${oneSubjectBlock.id}" selected="selected">${oneSubjectBlock.subjectBlockDescription}</option>
                                                      		</c:when>
                                                  			<c:otherwise>
                                                               <option value="${oneSubjectBlock.id}">${oneSubjectBlock.subjectBlockDescription}</option>
                                                 			</c:otherwise>
                                                  	</c:choose> --%>
                                                 </c:when>
                                             </c:choose>
                                          </c:forEach>
                                 </form:select>
                                 </td> 
                                 <td>
                                    <form:errors path="subjectBlockStudyGradeType.subjectBlock.id" cssClass="error"/>
<%--                                     <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach> --%>
                                 </td>
<%--                                  </spring:bind> --%>
                             </tr>

                             <!--  CARDINAL TIME UNIT NUMBER -->
                             <tr>
                                <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
                                <td>
                                 <form:select path="subjectBlockStudyGradeType.cardinalTimeUnitNumber" >
                                    <option value="0"><fmt:message key="jsp.selectbox.notapplicable" /></option>
                                    <c:forEach begin="1" end="${studyGradeTypeSubjectBlockForm.maxNumberOfCardinalTimeUnits}" var="current">
                                        <form:option value="${current}">${current}</form:option>
<%--                                        <c:choose>
                                            <c:when test="${status.value == current}">
                                               <option value="${current}" selected="selected">${current}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${current}">${current}</option>
                                            </c:otherwise>
                                        </c:choose> --%>
                                    </c:forEach>
                                </form:select>
                                </td> 
                                <td> 
                                    <form:errors path="subjectBlockStudyGradeType.cardinalTimeUnitNumber" cssClass="error"/>
<%--                                 <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach> --%>
                                </td>
                            </tr>

                            <!-- RIGIDITYTYPE -->
                            <tr>
                                <td class="label"><fmt:message key="jsp.subject.rigiditytype" /></td>
                                <td class="required">
                                    <form:select path="subjectBlockStudyGradeType.rigidityTypeCode">
                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                        <c:forEach var="rigidityType" items="${studyGradeTypeSubjectBlockForm.allRigidityTypes}">
                                            <form:option value="${rigidityType.code}" label="${rigidityType.description}"></form:option>
<%--                                        
                                            <c:choose>
                                                <c:when test="${rigidityType.code == status.value}">
                                                    <option value="${rigidityType.code}" selected="selected">${rigidityType.description}</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${rigidityType.code}">${rigidityType.description}</option>
                                                </c:otherwise>
                                            </c:choose> --%>
                                        </c:forEach>
                                    </form:select>
                                </td>
                                <td>
                                    <form:errors path="subjectBlockStudyGradeType.rigidityTypeCode" cssClass="error"/>
<%--                                 <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach> --%>
                                </td>
                            </tr>

                            <!--  ACTIVE -->
                            <tr>
                                <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                <td>
                                    <form:select path="subjectBlockStudyGradeType.active">
                                        <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                        <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
<%--                                        <c:choose>
                                            <c:when test="${'Y' == status.value}">
                                                <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                <option value="N"><fmt:message key="jsp.general.no" /></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                            </c:otherwise>
                                        </c:choose> --%>
                                    </form:select>
                                </td>
                                <td>
                                    <form:errors path="subjectBlockStudyGradeType.active" cssClass="error"/>
<%--                                     <c:forEach var="error" items="${status.errorMessages}"><span class="error"> ${error}</span></c:forEach> --%>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">&nbsp;</td>
                                <td><input type="button" name="submitformdata"
                                    value="<fmt:message key="jsp.button.submit" />"
                                    onclick="this.form.submit();" /></td>
                                <td class="label">&nbsp;</td>
                            </tr>
                                
                            </table>
                            </form:form>
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
    </script></div>

<%@ include file="../../footer.jsp"%>

