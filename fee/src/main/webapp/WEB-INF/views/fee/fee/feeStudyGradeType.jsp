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

    <spring:bind path="feeStudyGradeTypeForm.navigationSettings">
        <c:set var="navSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <div id="tabcontent">

        <form:form modelAttribute="feeStudyGradeTypeForm" method="POST" >
<%--            <input type="hidden" name="tab_fee" value="0" /> 
            <input type="hidden" name="panel_fee" value="0" />
            <input type="hidden" name="save_to_database" id="save_to_database" value="true" />
            <input type="hidden" name="category_code" id="category_code" value="" /> --%>
    		<fieldset>
    			<legend>
                	<a href="<c:url value='/fee/feesstudies.view?currentPageNumber=${navSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
	    			<a href="<c:url value='/fee/feesstudy.view?newForm=true&tab=0&panel=0&from=fees_studies&studyId=${feeStudyGradeTypeForm.study.id}&currentPageNumber=${navSettings.currentPageNumber}'/>">
		    			<c:choose>
		    				<c:when test="${not empty feeStudyGradeTypeForm.study.studyDescription}" >
	            				${fn:substring(feeStudyGradeTypeForm.study.studyDescription,0,initParam.iTitleLength)}
							</c:when>
						</c:choose>
					</a>&nbsp;
<%--	    			<spring:bind pafeemand.id"> --%>
		    			<c:choose>
		    				<c:when test="${feeStudyGradeTypeForm.fee.id != 0}" >
<%--	            				<spring:bind path="feeStudyGradeTypeForm.fee.studyGradeTypeId">
	            				<c:choose>
	            				   <c:when test="${not empty feeStudyGradeTypeForm.fee.studyGradeTypeId}"> --%>
	            				       ${feeStudyGradeTypeForm.studyGradeType.studyDescription}
<%--	            				   </c:when>
	            				</c:choose>
	            				</spring:bind> --%>
							</c:when>
							<c:otherwise>
								<fmt:message key="jsp.href.new" />
							</c:otherwise>
						</c:choose>
<%--					</spring:bind> --%>
					&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.menu.fees" /> 
				</legend>
				
                <p><form:errors path="" cssClass="errorwide"/></p>
<%--                <c:choose>
                    <c:when test="${ not empty showFeeEditError }">       
                        <p align="left" class="error">
                            ${showFeeEditError}
                        </p>
                    </c:when>
                </c:choose> --%>

			</fieldset>
<%--		</form> --%>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
                <c:if test="${feeStudyGradeTypeForm.fee.id != 0}">
                	<li class="TabbedPanelsTab"><fmt:message key="general.deadlines" /></li>
                </c:if>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.fee" /></div>
                                <div class="AccordionPanelContent">

                                    <table>

                                        <%--  StudyGradeTypeId --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                                            <spring:bind path="fee.studyGradeTypeId"> 
                                            <td class="required">
                                                <input type="hidden" id="studyGradeTypeChanged" value="" />
                                                <select name="${status.expression}" id="${status.expression}"  onchange="this.form.save_to_database.value='false';document.getElementById('studyGradeTypeChanged').value='true';form.submit()">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    
                                                    
                                                    <c:forEach var="studyGradeType" items="${feeStudyGradeTypeForm.allStudyGradeTypesForFees}">
                                                        <c:set var="studyGradeTypeString">
                                                            <fmt:message key="format.gradetype.academicyear.studyform.studytime">
                                                                <fmt:param value="${studyGradeType.gradeTypeDescription}" />
                                                                <fmt:param value="${feeStudyGradeTypeForm.idToAcademicYearMap[studyGradeType.currentAcademicYearId].description}" />
                                                                <fmt:param value="${feeStudyGradeTypeForm.codeToStudyFormMap[studyGradeType.studyFormCode].description}" />
                                                                <fmt:param value="${feeStudyGradeTypeForm.codeToStudyTimeMap[studyGradeType.studyTimeCode].description}" />
                                                            </fmt:message>
                                                        </c:set>
                                                        <c:choose>
                                                            <c:when test="${studyGradeType.id == status.value}">
                                                                <option value="${studyGradeType.id}" selected="selected">${studyGradeTypeString}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${studyGradeType.id}">${studyGradeTypeString}</option>
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

                                        <%-- FEE CATEGORY --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.category" /></td>
                                            <spring:bind path="fee.categoryCode">
                                            <td class="required">
                                            <select name="${status.expression}" onchange="submitWhenNewRecord(this.form,'${fee.id}')">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="feeCategory" items="${feeStudyGradeTypeForm.allFeeCategories}">
                                                    <c:choose>
                                                        <c:when test="${feeCategory.code == status.value}">
                                                            <option value="${feeCategory.code}" selected="selected">${feeCategory.description}</option>
                                                        </c:when>
                                                    <c:otherwise>
                                                        <option value="${feeCategory.code}">${feeCategory.description}</option>
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

                                        <%-- FEE UNIT: subject / CTU / studyGradeType --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.fee.feeunit" /></td>
                                            <td class="required">
                                                <form:select path="fee.feeUnitCode" onchange="
                                                    document.getElementById('fee.cardinalTimeUnitNumber').value=0;
                                                    document.getElementById('fee.studyIntensityCode').value=0;
                                                    document.getElementById('fee.cardinalTimeUnitNumber').disabled =  (value=='4') ? 'disabled' : '';
                                                    document.getElementById('fee.studyIntensityCode').disabled =  (value=='4') ? 'disabled' : '';
                                                    " >
                                                    <form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
                                                    <form:options items="${feeStudyGradeTypeForm.allFeeUnits}" itemValue="code" itemLabel="description" />
                                                </form:select>
                                            </td>
                                            <td><form:errors path="fee.feeUnitCode" cssClass="error" /></td>
                                        </tr>

                                        <%-- CARDINALTIMEUNITNUMBER: 0 (any), 1, 2, 3, ... --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                                            <td>
                                                <form:select path="fee.cardinalTimeUnitNumber">
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
                                            <td><form:errors path="fee.cardinalTimeUnitNumber" cssClass="error" /></td>
                                        </tr>
                                        
                                        <%-- NATIONALITY GROUP --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.nationalitygroup" /></td>
                                            <td>
                                                <form:select path="fee.nationalityGroupCode">
                                                    <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                    <form:options items="${feeStudyGradeTypeForm.allNationalityGroups}" itemValue="code" itemLabel="description" />
                                                </form:select>
                                            </td>
                                            <td><form:errors path="fee.nationalityGroupCode" cssClass="error" /></td>
                                        </tr>
                                        
                                        <tr>
                                            <td>&nbsp;</td>
                                        </tr>
                                        
                                        <%-- STUDY INTENSITY --%>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
                                            <td>
                                                <form:select path="fee.studyIntensityCode">
                                                    <form:option value="0"><fmt:message key="jsp.general.any" /></form:option>
                                                    <form:options items="${feeStudyGradeTypeForm.allStudyIntensities}" itemValue="code" itemLabel="description" />
                                                </form:select>
                                            </td>
                                            <td><form:errors path="fee.studyIntensityCode" cssClass="error" /></td>
                                        </tr>
                                        
                                        <tr>
                                            <td>&nbsp;</td>
                                        </tr>
                                        
                                        <!-- FEE DUE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.feedue" /></td>
                                            <spring:bind path="fee.feeDue">
                                            <td class="required">
                                                <input type="text" name="${status.expression}" size="12" maxlength="12" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

                       					<!-- NUMBEROFINSTALMENTS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofinstallments" /></td>
                                            <spring:bind path="fee.numberOfInstallments">
                                            <td>
                                                <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" onblur="javascript:if (this.value == null || (this.value).trim() == '') this.value=0;" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

                                        <!-- ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="fee.active">
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
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

	                                    <tr>
	                                       	<td class="label">&nbsp;</td>
	                                    	<td colspan=3><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
	                                    </tr>

	                                </table>
                                
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                        </script>
                    </div><%--details tab --%>
                    
                    <%--deadlines tab --%>
                    <c:if test="${feeStudyGradeTypeForm.fee.id != 0}">
			  			<div class="TabbedPanelsContent">
 							 <%@ include file="feeStudyGradeType-deadlines.jsp"%>
     					</div><%-- TabbedPanelsContent dead lines tab--%>
     				</c:if>     
            </div>
        </div>
        </form:form>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
         tp1.showPanel(${navSettings.tab});
          
        function submitWhenNewRecord(form,id){
            if(id == 0 || id == ''){
            	   form.studyGradeTypeId.value = '0';
            	   form.save_to_database.value='false';
            	   form.submit();
            }
            return;
        }    
     </script>
</div>

<%@ include file="../../footer.jsp"%>

