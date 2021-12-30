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

<c:set var="screentitlekey">general.classgroup</c:set>
<%@ include file="../../header.jsp"%>

<body>

<c:set var="classgroup" value="${classgroupForm.classgroup}" />

<!-- necessary spring binds for organization and navigationSettings
     regarding form handling through includes -->
<c:set var="organization" value="${classgroupForm.organization}" />
<c:set var="navigationSettings" value="${classgroupForm.navigationSettings}" />

<%-- <c:set var="tab" value="${navigationSettings.tab}" /> --%>
<%-- <c:set var="panel" value="${navigationSettings.panel}" /> --%>
<c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

 <div id="tabcontent">

  <form>
    <fieldset><legend>
        <a href="<c:url value='/college/classgroups.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.classgroups.header" /></a>&nbsp;&gt;
        <c:choose>
            <c:when test="${classgroupForm.classgroup.id ne 0}" >
                <c:out value="${fn:substring(classgroupForm.classgroup.description,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
    </legend>
    </fieldset>
  </form>

  <form:form name="formdata" modelAttribute="classgroupForm" method="post">
   <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
<%--    <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value='<c:out value="${classgroupForm.navigationSettings.tab}" />' /> --%>

   <form:errors cssClass="error" element="p" />

   <div id="tp1" class="TabbedPanel"  onclick="document.getElementsByName('navigationSettings.tab')[0].value=tp1.getCurrentTabIndex();">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="general.classgroup" /></li>               
        <c:if test="${classgroup.id != 0}">
            <li class="TabbedPanelsTab"><fmt:message key="jsp.general.subjects" /></li>
        </c:if>               
    </ul>

    <div class="TabbedPanelsContentGroup">

     <%-- CLASSGROUP --%>
     <div class="TabbedPanelsContent">
      <div class="Accordion" id="Accordion0" tabindex="0">

       <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="general.classgroup" /></div>
		<div class="AccordionPanelContent">

    		<%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>

    		<table>
    			<!-- STUDY -->
    			<tr>
                    <td class="label"><fmt:message key="jsp.general.study" /></td>
    				<td class="required">
    					<form:select path="studyId" onchange="
                            document.getElementById('classgroup.studyGradeTypeId').value='0';
                            document.formdata.submit();">
    						<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    						<c:forEach var="oneStudy" items="${classgroupForm.allStudies}">
                                <form:option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></form:option>
    						</c:forEach>
                        </form:select>
                    </td>
    				<td><form:errors path="studyId" cssClass="error" /></td>
    			</tr>

    			<!-- ACADEMIC YEAR -->
    			<tr>
                    <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
    				<td class="required">
    						<c:forEach var="academicYear" items="${classgroupForm.allAcademicYears}">
    						</c:forEach>
    					<form:select path="academicYearId" onchange="
                            document.getElementById('classgroup.studyGradeTypeId').value='0';
                            document.formdata.submit();">
    						<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    						<c:forEach var="academicYear" items="${classgroupForm.allAcademicYears}">
    							<option value="${academicYear.id}" ${academicYear.id != 0 && academicYear.id == classgroupForm.academicYearId ? 'selected="selected"' : ''}><c:out value="${academicYear.description}"/></option>
    						</c:forEach>
                        </form:select>
                    </td>
    				<td><form:errors path="academicYearId" cssClass="error" /></td>
    			</tr>

    			<!-- STUDYGRADETYPE -->
    			<tr>
                    <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
    				<td class="required">
    					<form:select path="classgroup.studyGradeTypeId" onchange="document.formdata.submit();">
    						<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
    						<c:forEach var="studyGradeType" items="${classgroupForm.allStudyGradeTypes}">
    							<option value="${studyGradeType.id}" ${studyGradeType.id == classgroupForm.classgroup.studyGradeTypeId ? 'selected="selected"' : ''}>
    <%--                                                             <c:out value="${studyGradeType.gradeTypeDescription}"/> --%>
                                    <c:out value="${classgroupForm.codeToGradeTypeMap[studyGradeType.gradeTypeCode].description}"/>,
                                    <c:out value="${classgroupForm.codeToStudyFormMap[studyGradeType.studyFormCode].description}"/>,
                                    <c:out value="${classgroupForm.codeToStudyTimeMap[studyGradeType.studyTimeCode].description}"/>
                                </option>
    						</c:forEach>
                        </form:select>
                    </td>
    				<td>
    				<form:errors path="classgroup.studyGradeTypeId" cssClass="error" />
    				</td>
    			</tr>
    
    			<!-- DESCRIPTION -->
    			<tr>
    				<td class="label"><fmt:message key="jsp.general.name" /></td>
    				<td class="required"><form:input path="classgroup.description" htmlEscape="true"/></td>
    				<td><form:errors path="classgroup.description" cssClass="error" /></td>
    			</tr>
    
    			<!-- SUBMIT BUTTON -->
    			<tr>
    				<td class="label">&nbsp;</td>
    				<td><input type="submit" value="<fmt:message key='jsp.button.submit' />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" /></td>
    			</tr>
    		</table>

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

        <%-- SUBJECTS --%>
        <c:if test="${classgroup.id != 0}">
            <div class="TabbedPanelsContent">
                <div class="Accordion" id="Accordion1" tabindex="0">

                    <div class="AccordionPanel">
                      <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjects" /></div>
                        <div class="AccordionPanelContent">

                        <table class="tabledata2" id="TblData2_subjects">
                            <tr>
                                <th>
                                    <input type="checkbox" id="checker" /><fmt:message key='jsp.general.all' />
                                    <script>
                                        $("#checker").change(function () {
                                        	$('[name=subjectIds]').prop('checked', this.checked);
                                        });                                    
                                    </script>
                                </th>
                                <th><fmt:message key="jsp.general.code" /></th>
                                <th><fmt:message key="jsp.general.description" /></th>
                            </tr>
                            <c:forEach var="subject" items="${classgroupForm.allSubjects}">
                                <tr>
                                    <td>
                                        <form:checkbox path="subjectIds" value="${subject.id}"/>
                                    </td>
                                    <td>
                                        ${subject.subjectCode}
                                    </td>
                                    <td>
                                        ${subject.subjectDescription}
                                    </td>
                                </tr>
                            </c:forEach>

                            <!-- SUBMIT BUTTON -->
                            <tr>
                                <td colspan="3" style="text-align: center;"><input type="submit" value="<fmt:message key='jsp.button.submit' />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" /></td>
                            </tr>
                        </table>
                        <script type="text/javascript">alternate('TblData2_subjects',true)</script>                

                        <!--  end accordionpanelcontent -->
                        </div>
                    <!--  end accordionpanel -->
                    </div>

                <!-- end of accordion 2 -->
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
        </c:if>

     <!--  end tabbed panelscontentgroup -->    
     </div>

    <!--  end tabbed panel -->    
    </div>
  </form:form>

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

