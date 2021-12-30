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
       
    <div id="tabcontent">    

    <!-- bread crumbs path -->
    <form>
        <fieldset><legend> 
            <a href="<c:url value='/college/studies.view?currentPageNumber=${secondarySchoolSubjectGroupForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
    	    <a href="<c:url value='/college/study.view?tab=0&panel=0&studyId=${secondarySchoolSubjectGroupForm.studyGradeType.studyId}&currentPageNumber=${secondarySchoolSubjectGroupForm.navigationSettings.currentPageNumber}'/>">
    	    			<c:choose>
    	    				<c:when test="${secondarySchoolSubjectGroupForm.studyGradeType.studyDescription != null && secondarySchoolSubjectGroupForm.studyGradeType.studyDescription != ''}" >
            					${fn:substring(secondarySchoolSubjectGroupForm.studyGradeType.studyDescription,0,initParam.iTitleLength)}
    						</c:when>
    						<c:otherwise>
    							<fmt:message key="jsp.href.new" />
    						</c:otherwise>
    					</c:choose>
    					</a> /
    	    			<a href="<c:url value='/college/studygradetype.view?tab=${secondarySchoolSubjectGroupForm.navigationSettings.tab}&panel=${secondarySchoolSubjectGroupForm.navigationSettings.panel}&studyGradeTypeId=${secondarySchoolSubjectGroupForm.studyGradeType.id}&studyId=${secondarySchoolSubjectGroupForm.studyGradeType.studyId}&currentPageNumber=${secondarySchoolSubjectGroupForm.navigationSettings.currentPageNumber}&from=studygradetypesecondaryschoolsubjects'/>">
    	    			<c:choose>
    	    				<c:when test="${not empty secondarySchoolSubjectGroupForm.studyGradeType.gradeTypeCode}" >
                                ${secondarySchoolSubjectGroupForm.studyGradeType.gradeTypeCode}
    						</c:when>
    						<c:otherwise>
    							<fmt:message key="jsp.href.new" />
    						</c:otherwise>
    					</c:choose>
    					</a>
            			&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.secondaryschoolsubjects" /> 
        </legend></fieldset>
    </form>

    <div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
    </ul>
    <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent">
            <div class="Accordion" id="Accordion1" tabindex="0">
                <div class="AccordionPanel">
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.secondaryschoolsubjects" /></div>
                        <div class="AccordionPanelContent">

                           <form name="formdata" method="post">

                           <input type="hidden" name="submitFormObject" id="submitFormObject" value="false" />
                           <input type="hidden" id="addSubject" name="addSubject" value="false" />
                           <input type="hidden" id="removeSubject" name="removeSubject" value="false" />
                           <input type="hidden" id="removeSecondarySchoolSubjectId" name="removeSecondarySchoolSubjectId" value="false" />                           

                           <table>
                           
                            <!--  MIN NOF OBLIGATED SUBJECTS -->                            
                            <tr>
                                <td class="label" width="220"><fmt:message key="jsp.general.secondaryschoolsubjects.min" /></td>
                                <td class="required">
                                <spring:bind path="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.minNumberToGrade">
                                    <script type="text/javascript">
                                        // previousMinNumberToGrade value is filled by 'onclick' event (which is fired BEFORE the value change)
                                        var previousMinNumberToGrade;
                                    
                                        function changeMinNumberToGrade() {
                                            
                                            var currentMaxNumberToGrade = document.getElementById('secondarySchoolSubjectGroup.maxNumberToGrade').value;
                                            var currentMinNumberToGrade = document.getElementById('secondarySchoolSubjectGroup.minNumberToGrade').value;

                                            if (currentMinNumberToGrade != '' && currentMaxNumberToGrade != '' && currentMaxNumberToGrade < currentMinNumberToGrade) {

                                                alert('<fmt:message key="jsp.general.secondaryschoolsubjects.minIsLargerThanMax" />');
                                                document.getElementById('secondarySchoolSubjectGroup.minNumberToGrade').value = previousMinNumberToGrade;
                                            }
                                        }

                                      </script>
                                    <select name="${status.expression}" id="${status.expression}" onclick="previousMinNumberToGrade=this.value" onchange="changeMinNumberToGrade()">
                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>                                 
                                      <c:forEach var="i" begin="0" end="${appConfigManager.secondarySchoolSubjectsCount}">         
                                      <c:choose>
                                          <c:when test="${status.value == i }">
                                              <option value="${i}" selected="selected">${i}</option>
                                          </c:when>
                                          <c:otherwise>
                                              <option value="${i}">${i}</option>
                                          </c:otherwise>
                                      </c:choose>
                                      </c:forEach>                                           
                                    </select>
                                    
                                    <c:forEach var="error" items="${status.errorMessages}">
                                        <span class="error">${error}</span>
                                    </c:forEach>
                                    
                                </spring:bind>
                                </td>
                                <td width="300"></td>
                            </tr>
                            <!--  MAX NOF OBLIGATED SUBJECTS -->
                            <tr>
                                <td class="label" width="220"><fmt:message key="jsp.general.secondaryschoolsubjects.max" /></td>
                                <td class="required">
                                <spring:bind path="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.maxNumberToGrade">
                                      <script type="text/javascript">
                                        // previousMaxNumberToGrade value is filled by 'onclick' event (which is fired BEFORE the value change)
                                        var previousMaxNumberToGrade;
                                    
                                        function changeMaxNumberToGrade() {
                                            
                                            var currentMaxNumberToGrade = document.getElementById('secondarySchoolSubjectGroup.maxNumberToGrade').value;
                                            var currentMinNumberToGrade = document.getElementById('secondarySchoolSubjectGroup.minNumberToGrade').value;

                                            if (currentMinNumberToGrade != '' && currentMaxNumberToGrade != '' && currentMaxNumberToGrade < currentMinNumberToGrade) {

                                                alert('<fmt:message key="jsp.general.secondaryschoolsubjects.minIsLargerThanMax" />');
                                                document.getElementById('secondarySchoolSubjectGroup.maxNumberToGrade').value = previousMaxNumberToGrade;
                                            }
                                        }

                                      </script>
                                    <select name="${status.expression}" id="${status.expression}" onclick="previousMaxNumberToGrade=this.value" onchange="changeMaxNumberToGrade()">
                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>                                    
                                      <c:forEach var="i" begin="1" end="${appConfigManager.secondarySchoolSubjectsCount}">         
                                      <c:choose>
                                          <c:when test="${status.value == i }">
                                              <option value="${i}" selected="selected">${i}</option>
                                          </c:when>
                                          <c:otherwise>
                                              <option value="${i}">${i}</option>
                                          </c:otherwise>
                                      </c:choose>
                                      </c:forEach>
                                    </select>
                                    
                                    <c:forEach var="error" items="${status.errorMessages}">
                                        <span class="error">${error}</span>
                                    </c:forEach>
                                    
                                </spring:bind>
                                </td>
                                <td></td>
                            </tr>    
                                                       
                            <!--  SECONDARY SCHOOL SUBJECTS -->
                            <tr>
                                <td class="label" width="220" style="padding-top : 6px;"><fmt:message key="jsp.general.secondaryschoolsubjects" /></td>
                                <td style="padding-top : 6px;" colspan="2">                                
                                <c:choose>
                                    <c:when test="${fn:length(secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects) > 0}">

                                    <table id="secondarySchoolSubjectTblData" width="520">
                                    <tr>
                                        <th><fmt:message key="jsp.general.secondaryschoolsubject" /></th>
                                        <c:if test="${appConfigManager.secondarySchoolSubjectsWeight}">
                                            <th><fmt:message key="jsp.general.secondaryschoolsubjects.weight" /></th>
                                        </c:if>
                                        <th><fmt:message key="jsp.general.secondaryschoolsubjects.minimumGradePoint" /></th>
                                        <th><fmt:message key="jsp.general.secondaryschoolsubjects.maximumGradePoint" /></th>
                                        <th></th>
                                    </tr>
                                    <c:forEach var="secondarySchoolSubject" items="${secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects}" varStatus="rowIndex">
                                    
                                        <input type="hidden" id="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].id" name="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].id" value="<c:out value="${secondarySchoolSubject.id}" />" />
                                        <input type="hidden" id="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].secondarySchoolSubjectGroupId" name="secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].secondarySchoolSubjectGroupId" value="<c:out value="${secondarySchoolSubject.secondarySchoolSubjectGroupId}" />" />
                                   
                                    <tr>
                                        <td>${secondarySchoolSubject.description}</td>
                                        
                                        <!--  WEIGHT -->
                                        <c:choose>
                                            <c:when test="${appConfigManager.secondarySchoolSubjectsWeight}">
	                                        <td class="required">
		                                        <style>
		                                            .selectnumber {
		                                                font-size: 0.9em;
		                                                width: 80px;
		                                            }
		                                        </style>
	                                            <select name="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].weight" id="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].weight" class="selectnumber">
	                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                                                <c:forEach begin="${secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.minWeight}" end="${secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.maxWeight}" var="current">
	                                                    <c:choose>
	                                                        <c:when test="${secondarySchoolSubject.weight == current}">
	                                                           <option value="${current}" selected="selected">${current}</option>
	                                                        </c:when>
	                                                        <c:otherwise>
	                                                            <option value="${current}">${current}</option>
	                                                        </c:otherwise>
	                                                    </c:choose>
	                                                </c:forEach>
	                                            </select>
	                                        </td>
	                                        </c:when>
	                                        <c:otherwise>
	                                            <input type="hidden" name="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].weight" id="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].weight" value="1">
	                                        </c:otherwise>
	                                    </c:choose>
                                        <td class="required">
                                        
                                        <script type="text/javascript">
                                        // previousMinMaxGradePoints value is filled by 'onclick' event (which is fired BEFORE the value change)
                                        var previousMinMaxGradePoints;
                                    
                                        function checkMinMaxGradePoints(index, id) {
                                            
                                            var highestGradePointValue = document.getElementById('secondarySchoolSubjectGroup.secondarySchoolSubjects[' + index + '].minimumGradePoint').value;
                                            var lowestGradePointValue  = document.getElementById('secondarySchoolSubjectGroup.secondarySchoolSubjects[' + index + '].maximumGradePoint').value;

                                            if (highestGradePointValue > lowestGradePointValue && highestGradePointValue != '' && lowestGradePointValue != '') {

                                                alert('<fmt:message key="jsp.general.secondaryschoolsubjects.highestIsLargerThanLowest" />');
                                                document.getElementById(id).value = previousMinMaxGradePoints;
                                            }
                                        }
                                        </script>

	                                        <!--  minimumGradePoint (that is: HighestGradeOfSecondarySchoolSubjects!!) -->
                                            <select name="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].minimumGradePoint" id="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].minimumGradePoint" class="selectnumber" onclick="previousMinMaxGradePoints=this.value" onchange="checkMinMaxGradePoints(${rowIndex.index}, this.id)">
                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="${appConfigManager.secondarySchoolSubjectsHighestGrade}" end="${appConfigManager.secondarySchoolSubjectsLowestGrade}" var="current">
                                                    <c:choose>
                                                        <c:when test="${secondarySchoolSubject.minimumGradePoint == current}">
                                                           <option value="${current}" selected="selected">${current}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}">${current}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                                                                
                                        </td>
                                        <td class="required">
                                        
	                                        <!--  maximumGradePoint (that is: LowestGradeOfSecondarySchoolSubjects!! ) -->
                                            <select name="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].maximumGradePoint" id="secondarySchoolSubjectGroup.secondarySchoolSubjects[${rowIndex.index}].maximumGradePoint" class="selectnumber" onclick="previousMinMaxGradePoints=this.value" onchange="checkMinMaxGradePoints(${rowIndex.index}, this.id)">
                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach begin="${appConfigManager.secondarySchoolSubjectsHighestGrade}" end="${appConfigManager.secondarySchoolSubjectsLowestGrade}" var="current">
                                                    <c:choose>
                                                        <c:when test="${secondarySchoolSubject.maximumGradePoint == current}">
                                                           <option value="${current}" selected="selected">${current}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}">${current}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                                                                
                                        </td>
                                        <td align="right"><a href="JavaScript:removeSubject('${secondarySchoolSubject.id}')" onclick="return confirm('<fmt:message key="jsp.general.secondaryschoolsubject.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a></td>
                                    </tr>                                      
                                    </c:forEach>
                                    </table>
                                    <script type="text/javascript">alternate('secondarySchoolSubjectTblData', true)</script>
                                </c:when>
                            </c:choose>                                    
                                </td>
                           </tr>    
                           <tr>
                                <td class="label" width="220" style="padding-top : 6px;"></td>
                                <td style="padding-top : 6px;">
                                <script type="text/javascript">

                                    function addSubjectToGroup() {
                                        document.getElementById('addSubject').value = 'true';
                                        document.formdata.submit();                                            
                                    }

                                    function removeSubject(removeSecondarySchoolSubjectId) {
                                        document.getElementById('removeSubject').value = 'true';
                                        document.getElementById('removeSecondarySchoolSubjectId').value = removeSecondarySchoolSubjectId;
                                        document.formdata.submit();                                            
                                    }                                        
                                </script>           
                                <select name="secondarySchoolSubjectId" id="secondarySchoolSubjectId" onchange="JavaScript:addSubjectToGroup()">
                                    <option value="0" selected="selected"><fmt:message key="jsp.selectbox.choose" /></option>
                                       <c:forEach var="secondarySchoolSubject" items="${secondarySchoolSubjectGroupForm.allSecondarySchoolSubjects}">
                                           <option value="${secondarySchoolSubject.id}">${secondarySchoolSubject.description}</option>                                       
                                       </c:forEach>
                                </select><br />                                
                                </td>
                                <td></td>
                            </tr>
                            
                            
                            <!-- SUBMIT BUTTON -->
                            <tr>
                                <td class="label">&nbsp;</td>
                                <td><br /><br />
                                    <c:choose>
                                        <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                            <script type="text/javascript">
                                                function doSubmit() {

                                                	var totalNofSubjects = ${fn:length(secondarySchoolSubjectGroupForm.secondarySchoolSubjectGroup.secondarySchoolSubjects)};
                                                    var stop = false;
                                                    
                                                    for (i=0; i < totalNofSubjects; i++) {
                                                        
                                                        var minId = 'secondarySchoolSubjectGroup.secondarySchoolSubjects[' + i + '].minimumGradePoint';
                                                        var min = document.getElementById(minId).value;

                                                        var maxId = 'secondarySchoolSubjectGroup.secondarySchoolSubjects[' + i + '].maximumGradePoint';
                                                        var max = document.getElementById(maxId).value;
                                                        
                                                        if (min == 0 || max == 0) {
                                                            stop = true;
                                                        }
                                                    }

                                                    if (document.getElementById('secondarySchoolSubjectGroup.maxNumberToGrade').value == 0) {
                                                    	stop = true;
                                                    }

                                                    if (stop) {
                                                    	alert('<fmt:message key="invalid.required.fields" />');
                                                    } else {
                                                        document.getElementById('submitFormObject').value='true';
                                                        document.formdata.submit();
                                                    }
                                                }
                                            </script>
                                            <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="doSubmit()" />
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td></td>
                            </tr>
                            </table>
                            </form>
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

</div>

<%@ include file="../../footer.jsp"%>

