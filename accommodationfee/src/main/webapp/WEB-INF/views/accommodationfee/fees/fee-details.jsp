<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version 
1.1 (the "License"), you may not use this file except in compliance with 
the License. You may obtain a copy of the License at 
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College accommodationfee module code.

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

<div class="Accordion" id="Accordion0" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
			<div class="AccordionPanelContent">



            <form:form method="post" modelAttribute="accommodationFeeForm">

                <%--Display Error Message at this point --%>
                <p><form:errors path="" cssClass="errorwide"/></p>

                <fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.roomCharges" />
					</legend>
					<table>
                        <tr>
                            <td class="label"><fmt:message key="jsp.accommodation.hostelType" /></td>
                            <td class="required">
                                <form:select path="accommodationFee.hostelTypeCode">
                                    <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                    <form:options items="${accommodationFeeForm.allHostelTypes}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.hostelTypeCode" cssClass="error" /></td>
					    </tr>
                        <tr>
                            <td class="label"><fmt:message key="jsp.accommodation.roomtype" /></td>
                            <td class="required">
                                <form:select path="accommodationFee.roomTypeCode">
                                    <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                    <form:options items="${accommodationFeeForm.allRoomTypes}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.roomTypeCode" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td class="label"><fmt:message key="jsp.accommodation.academicYear" /></td>
                            <td class="required"><form:select path="accommodationFee.academicYearId">
                                    <form:option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </form:option>
                                    <form:options items="${accommodationFeeForm.allAcademicYears}" itemValue="id" itemLabel="description" />
                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.academicYearId" cssClass="error" /></td>
                        </tr>
                        <%-- FEE UNIT: (subject) / CTU / studyGradeType --%>
                        <tr>
                            <td class="label"><fmt:message key="jsp.fee.feeunit" /></td>
                            <td class="required">
                                <form:select path="accommodationFee.feeUnitCode">
                                    <form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
                                    <form:options items="${accommodationFeeForm.allFeeUnits}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.feeUnitCode" cssClass="error" /></td>
                        </tr>

                        <tr>
                            <td class="label"><fmt:message key="jsp.accommodation.amount" /></td>
                            <td class="required"><form:input path="accommodationFee.feeDue" /></td>
                            <td><form:errors path="accommodationFee.feeDue" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td class="label"><fmt:message key="jsp.accommodation.numberOfInstallments" /></td>
                            <td class="required">
                                <form:select path="accommodationFee.numberOfInstallments">
                                    <form:option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </form:option>
                                    <c:forEach begin="1" end="10" var="i">
                                    <form:option value="${i}"><c:out value='${i}'/></form:option>
                                    </c:forEach>

                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.numberOfInstallments" cssClass="error" /></td>
                        </tr>

						<tr>
                            <td class="label"><fmt:message key="jsp.accommodation.active" /></td><td><form:select path="accommodationFee.active">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                </form:select>
                            </td>
                            <td><form:errors path="accommodationFee.active" cssClass="error" /></td>
                        </tr>

						<tr>
							<td>&nbsp;</td>
							<td>
                                <input type="submit" value="<fmt:message key="jsp.accommodation.save" />" name="save" <c:out value='${disabled}'/> />
                                <input type="reset"	value="<fmt:message key="jsp.accommodation.reset" />" name="reset" />
                            </td>
						</tr>
						
					</table>
				</fieldset>
			</form:form>





    
    
		</div><%-- AccordionPanelContent --%>
	</div><%-- AccordionPanel --%>
</div><%-- Accordion0 --%>

 <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
</script>
