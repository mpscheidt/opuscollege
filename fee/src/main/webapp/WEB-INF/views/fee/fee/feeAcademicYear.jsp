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

The Original Code is Opus-College fee module code.

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
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

   <c:set var="navigationSettings" value="${feeAcademicYearForm.navigationSettings}" scope="page" />
    
    <div id="tabcontent">
    		<fieldset>
    			<legend>
                	<a href="<c:url value='/fee/feebranches.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
	    			<a href="<c:url value='/fee/feebranch.view?newForm=true&tab=0&panel=0&branchId=${feeAcademicYearForm.branch.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
		    			<c:choose>
		    				<c:when test="${not empty feeAcademicYearForm.branch.branchDescription}" >
	            				${fn:substring(feeAcademicYearForm.branch.branchDescription,0,initParam.iTitleLength)}
							</c:when>
						</c:choose>
					</a>
	    			
		    			<c:choose>
		    				<c:when test="${feeAcademicYearForm.fee.id != 0}" >
	            				<c:choose>
	            				   <c:when test="${feeAcademicYearForm.fee.academicYearId != 0}">
	            				       &nbsp;(${feeAcademicYearForm.academicYear.description})
	            				   </c:when>
	            				</c:choose>
							</c:when>
							<c:otherwise>
								<fmt:message key="jsp.href.new" />
							</c:otherwise>
						</c:choose>
					&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.menu.fees" /> 
				</legend>
				
                <c:choose>        
                    <c:when test="${ not empty showFeeEditError }">       
                        <p align="left" class="error">
                            ${showFeeEditError}
                        </p>
                    </c:when>
                </c:choose>

			</fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
                
                <c:if test="${feeAcademicYearForm.fee.id != 0}">
                	<li class="TabbedPanelsTab"><fmt:message key="general.deadlines" /></li>
                </c:if>                              
            </ul>

            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion1" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.fee" /></div>
                            <div class="AccordionPanelContent">

                            <form:form name="feedata" method="POST" commandName="feeAcademicYearForm.fee" cssStyle="padding-top:20px">
                                <input type="hidden" name="tab_fee" value="0" /> 
                                <input type="hidden" name="panel_fee" value="0" />
                                <form:hidden path="branchId"/>

                                <table>

                                    <%--  AcademicYear --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                        <td class="required">
                                            <form:select path="academicYearId">
                                                <form:option value=""><fmt:message key="jsp.selectbox.choose"/></form:option>
                                                    <c:forEach var="academicYear" items="${feeAcademicYearForm.allAcademicYears}">
                                                        <form:option value="${academicYear.id}">${academicYear.description}</form:option>
                                                    </c:forEach>
                                                </form:select>
                                        </td>
                                        <form:errors path="academicYearId" cssClass="error" element="td"/> 
                                    </tr>

                                    <%-- FEE CATEGORY --%>
									<tr>
										<td class="label"><fmt:message key="jsp.general.category" /></td>
										<td class="required">
                                        	<form:select path="categoryCode" >
                                            	<form:option value=""><fmt:message key="jsp.selectbox.choose"/></form:option>
                                            	<c:forEach var="feeCategory" items="${feeAcademicYearForm.feeCategories}">
	                                      			<form:option value="${feeCategory.code}" >${feeCategory.description}</form:option>
			                                	</c:forEach>
                                        	</form:select>
                                        </td>
                                       	<form:errors path="categoryCode" cssClass="error" element="td"/>
									</tr>
									
									<%-- FEE DUE --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.feedue" /></td>
                                        <td class="required">
                                        	<form:input path="feeDue" size="20" maxlength="12" />
                                        </td> 
                                       	<form:errors path="feeDue" cssClass="error" element="td"/>
                                    </tr>
                                    
                                     <%-- EDUCATION AREA --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.educationarea" /></td>
                                        <td>
                                            <form:select path="educationAreaCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allEducationAreas}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="educationAreaCode" cssClass="error" /></td>
                                    </tr>
                                    
                                     <%-- EDUCATION LEVEL --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.educationlevel" /></td>
                                        <td>
                                            <form:select path="educationLevelCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allEducationLevels}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="educationLevelCode" cssClass="error" /></td>
                                    </tr>
                                    
                                    <%-- NATIONALITY GROUP --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.nationalitygroup" /></td>
                                        <td>
                                            <form:select path="nationalityGroupCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allNationalityGroups}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="nationalityGroupCode" cssClass="error" /></td>
                                    </tr>

									<%-- STUDY INTENSITY --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
                                        <td>
                                            <form:select path="studyIntensityCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allStudyIntensities}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="studyIntensityCode" cssClass="error" /></td>
                                    </tr>
                                    
                                    <%-- STUDY TIME --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.studytime" /></td>
                                        <td>
                                            <form:select path="studyTimeCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allStudyTimes}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="studyTimeCode" cssClass="error" /></td>
                                    </tr>
                                    
                                    <%-- STUDY FORM --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.studyform" /></td>
                                        <td>
                                            <form:select path="studyFormCode">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allStudyForms}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="studyFormCode" cssClass="error" /></td>
                                    </tr>
                                    
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>

                                    <%-- FEE UNIT: subject / CTU / studyGradeType --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.fee.feeunit" /></td>
                                        <td class="required">
                                            <form:select path="feeUnitCode">
                                                <form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
                                                <form:options items="${feeAcademicYearForm.allFeeUnits}" itemValue="code" itemLabel="description" />
                                            </form:select>
                                        </td>
                                        <td><form:errors path="feeUnitCode" cssClass="error" /></td>
                                    </tr>

                                    <%-- CARDINALTIMEUNITNUMBER: 0 (any), 1, 2, 3, ... --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                                        <td>
                                            <form:select path="cardinalTimeUnitNumber">
                                                <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                <form:option value="1">1</form:option>
                                                <form:option value="2">2</form:option>
                                                <form:option value="3">3</form:option>
                                                <form:option value="4">4</form:option>
                                                <form:option value="5">5</form:option>
                                                <form:option value="6">6</form:option>
                                                <form:option value="7">7</form:option>
                                                <form:option value="8">8</form:option>
                                                <form:option value="9">9</form:option>
                                                <form:option value="10">10</form:option>
                                                <form:option value="11">11</form:option>
                                                <form:option value="12">12</form:option>
                                                <form:option value="13">13</form:option>
                                                <form:option value="14">14</form:option>
                                                <form:option value="15">15</form:option>
                                                <form:option value="16">16</form:option>
                                                <form:option value="17">17</form:option>
                                                <form:option value="18">18</form:option>
                                                <form:option value="19">19</form:option>
                                                <form:option value="20">20</form:option>
                                            </form:select>
                                        </td>
                                        <td><form:errors path="cardinalTimeUnitNumber" cssClass="error" /></td>
                                    </tr>
                                    
                                                                            
                                    
                                    
                   					<%-- NUMBEROFINSTALMENTS --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.numberofinstallments" /></td>
                                        <td>
                                        	<form:input path="numberOfInstallments" size="20" maxlength="10" onblur="javascript:if (this.value == null || (this.value).trim() == '') this.value=0;" />
                                        </td>
                                        <form:errors path="numberOfInstallments" cssClass="error" element="td"/> 
                                    </tr>
                                    
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                                                                                                  
                                    <%-- ACTIVE --%>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.active" /></td>
                                        <td>
                                         	<form:select path="active">
         										<form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
         										<form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
      										</form:select>
                                        </td>
                                        <form:errors path="active" cssClass="error" element="td"/>
                                    </tr>

                                    <tr>
                                       	<td class="label">&nbsp;</td>
                                    	<td colspan="3"><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                    </tr>

                                </table>
                            </form:form>
                            </div>
                        </div>
                    </div>
                    <script type="text/javascript">
                        var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                    </script>
                </div>     <%--details tab --%>
                
                <%--deadlines tab --%>
                <c:if test="${feeAcademicYearForm.fee.id != 0}">
		  			<div class="TabbedPanelsContent">
						<%@ include file="feeAcademicYear-deadlines.jsp"%>
 					</div><%-- TabbedPanelsContent dead lines tab--%>
     			</c:if>
    
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
    </script>
</div>

<%@ include file="../../footer.jsp"%>

