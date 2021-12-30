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

The Original Code is Opus-College admission module code.

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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!-- isELIgnored="false" -->

<html>

<jsp:useBean class="org.uci.opus.config.OpusConstants" id="opusConstants" scope="session" />

<%
// used beans:
//out.println("<font color=\"red\">" + opusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED + "</font>");

ServletContext context = this.getServletContext();
 
String preferredLanguage = "";

preferredLanguage = org.uci.opus.util.OpusMethods.getPreferredLanguage(request);

%>

<c:set var="prefLanguage" value="<%= preferredLanguage %>" />

<c:set var="foreignStudent" value="N" />
<c:set var="relativeOfStaffMember" value="N" />
<c:set var="ruralAreaOrigin" value="N" />

<c:set var="GRADE_TYPE_SECONDARY_SCHOOL" value="<%= opusConstants.GRADE_TYPE_SECONDARY_SCHOOL %>" />
<%-- gradetypes for educationLevelCode --%>
<c:set var="GRADE_TYPE_BACHELOR" value="<%= opusConstants.GRADE_TYPE_BACHELOR %>" />
<c:set var="GRADE_TYPE_MASTER" value="<%= opusConstants.GRADE_TYPE_MASTER %>" />

<c:set var="DISCIPLINEGROUP_CODE_MA_HRM" value="<%= opusConstants.DISCIPLINEGROUP_CODE_MA_HRM %>" />
<c:set var="DISCIPLINEGROUP_CODE_MBA_GENERAL" value="<%= opusConstants.DISCIPLINEGROUP_CODE_MBA_GENERAL %>" />
<c:set var="DISCIPLINEGROUP_CODE_MBA_FINANCIAL" value="<%= opusConstants.DISCIPLINEGROUP_CODE_MBA_FINANCIAL %>" />
<c:set var="DISCIPLINEGROUP_CODE_MSC_PM" value="<%= opusConstants.DISCIPLINEGROUP_CODE_MSC_PM %>" />

<head>
    <title><c:out value='${initParam.iAppname}'/></title>
    <jwr:style src="/styles/college.css" />
    <jwr:style src="/styles/college1024.css" /> 
    <jwr:style src="/styles/smoothness.css" />

    <jwr:script src="/bundles/college.js" />  
    
    <script type="text/javascript">
        // choose optional extra stylesheets:
        chooseStyle();

        // Link for msg.html
        popupLink = "<c:url value='/static/msg.html' />";
        
    </script>

    <jwr:script src="/bundles/jquerycomp.js" /> <%-- MP: TODO: jquery probably not used here --%>

<!-- USE THIS IF ACCORDIONs may NOT collapse
 	<style type="text/css" media="all">
		.Accordion {
		  overflow: visible !important;
		}
		
		.AccordionPanelContent {
		  display: block !important;
		  overflow: visible !important;
		  height: auto !important;
		}
	</style> -->
</head>

<body>
    <div id="tabwrapper">
        <div id="header">
            <div id="homeLink">
                <a href="<c:url value='/college/start.view?newForm=true'/>">
<%--                    <img src='<c:url value="/images/trans.gif" />' width='150' height='50' alt='<fmt:message key="jsp.general.home" />' title='<fmt:message key="jsp.general.home" />' />--%>
                     <img src='<c:url value="${initParam.initMenuLogo}" />' alt='<fmt:message key="jsp.general.home" />' title='<fmt:message key="jsp.general.home" />' /> 
                </a>
            </div>
            
            <div id="HelpMenu">
                <fmt:message key="jsp.general.initialadmission" />
                <p id="Language">
                    <%@ include file="../includes/languageSelector.jsp"%>
                    <%-- %>| <a href="http://www.opuscollege.net/instruction" target="_blank"><fmt:message key="jsp.general.message.help" /></a> --%>
                    <c:if test="${modules != null && modules != ''}">
				        <c:forEach var="module" items="${modules}">
				            <c:choose>
				                <c:when test="${fn:toLowerCase(module.module) == 'cbu'}">
				                  | <a class="white" href="<c:url value='/help/RequestAdmissionFormCBU.pdf'/>" target="_blank">
                                    <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                                </a>   
                                <c:set var="helpFileWritten" value="Y" />
				                </c:when>
				            </c:choose>
				        </c:forEach>
                    </c:if>
                    <c:if test="${helpFileWritten != 'Y'}">
	                    | <a class="white" href="<c:url value='/help/RequestAdmissionForm.pdf'/>" target="_blank">
	                    <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
	                    </a>
                    </c:if>
                    |
                </p>
            </div>
                
            <div id="Menu2">
                <ul id="MenuBar2" class="MenuBarHorizontal"></ul>
            </div>
           
            <div id="Menu">
                <ul id="MenuBar1" class="MenuBarHorizontal"></ul>
            </div>
           
            <script type="text/javascript">
            <!--    
                var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"images/trans.gif", imgRight:"images/trans.gif"});
                var MenuBar2 = new Spry.Widget.MenuBar("MenuBar2", {imgDown:"images/trans.gif", imgRight:"images/trans.gif"});
            //-->
            </script>  
        </div>

<c:choose>
    <c:when test="${modules != null && modules != ''}">
        <c:forEach var="module" items="${modules}">
            <c:choose>
                <c:when test="${fn:toLowerCase(module.module) == 'admission'}">

                    <spring:bind path="requestAdmissionForm.student">
                        <c:set var="student" value="${status.value}" scope="page" />
                    </spring:bind>
                    <spring:bind path="requestAdmissionForm.navigationSettings">
                        <c:set var="navigationSettings" value="${status.value}" scope="page" />
                    </spring:bind>
                    <spring:bind path="requestAdmissionForm.address">
                        <c:set var="address" value="${status.value}" scope="page" />
                    </spring:bind>
                    <spring:bind path="requestAdmissionForm.studyPlanCardinalTimeUnit.studyGradeTypeId">
                        <c:set var="studyGradeTypeId" value="${status.value}" scope="page" />
                    </spring:bind>
                    <spring:bind path="requestAdmissionForm.studyPlanCardinalTimeUnit.cardinalTimeUnitNumber">
                        <c:set var="cTUNumber" value="${status.value}" scope="page" />
                    </spring:bind>
                    <spring:bind path="requestAdmissionForm.secondarySchoolSubjectGroups">
                        <c:set var="secondarySchoolSubjectGroups" value="${status.value}" scope="page" />
                    </spring:bind>
                     <spring:bind path="requestAdmissionForm.ungroupedSecondarySchoolSubjects">
                        <c:set var="ungroupedSecondarySchoolSubjects" value="${status.value}" scope="page" />
                    </spring:bind>
        
                    <div id="tabcontent">
                    
                    <fieldset>
		                <legend></legend>
		                <p class="msgwide">
                                <fmt:message key="jsp.register.introduction.text1" />
                                <br /><fmt:message key="jsp.register.introduction.text2" />
                                <br /><fmt:message key="jsp.register.introduction.text3" />
                                <br /><fmt:message key="jsp.register.introduction.text4" />
                        </p>
                        
                        <c:if test="${ not empty requestAdmissionForm.txtErr }">       
                            <p class="error">
                                <c:out value='${requestAdmissionForm.txtErr}'/>
                            </p>
                        </c:if> 
		            </fieldset>
		                
        <c:set var="accordion" value="0"/>
        
       
        <form:form method="post" action="request_admission.view"
                        commandName="requestAdmissionForm" enctype="multipart/form-data"  name="formdata">
            <input type="hidden" id="navigationSettings.tab" value="0" />
            <input type="hidden" name="navigationSettings.panel" id="navigationSettings.panel" value="<c:out value='${navigationSettings.panel}'/>" />        
            <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                                            
        <div id="tp1" class="TabbedPanel">
            <div class="TabbedPanelsContentGroup">

<!-- ---------------------------------------------------------------------------------------------------- -->           
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
                            <div class="AccordionPanelContent">
                                <%@ include file="../includes/personDataAdmission.jsp" %>
                            </div> <!-- einde accordionpanelcontent -->
                        </div> <!-- einde accordionpanel -->

                        <!-- address -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.address" /></div>
                            <div class="AccordionPanelContent">
                                <%@ include file="../includes/addressDataAdmission.jsp" %>
                            </div> <!-- einde accordionpanelcontent -->
                        </div> <!-- einde accordionpanel -->

                        <!-- background -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.background" /></div>
                            <div class="AccordionPanelContent">
                                <%@ include file="../includes/personBackgroundAdmission.jsp" %>
                            </div> <!-- einde accordionpanelcontent -->
                        </div> <!-- einde accordionpanel -->

                        <!-- identificationData -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.identification" /></div>
                            <div class="AccordionPanelContent">        
                                <%@ include file="../includes/identificationDataAdmission.jsp" %>
                            </div>
                        </div>

                         <%-- PREV INSTITUTION --%>
                         <%@ include file="../includes/previousInstitutionData.jsp" %>
                     
                        <!-- subscriptionData -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.subscriptiondata" /></div>
                            <div class="AccordionPanelContent">        
                                <%@ include file="../includes/subscriptionDataAdmission.jsp" %>           
                                
                                <c:if test="${ not empty requestAdmissionForm.txtErr }">       
		                            <p class="error">
		                                <c:out value='${requestAdmissionForm.txtErr}'/>
		                            </p>
	                            </c:if> 
	                            
                                <table> 
                                   <tr>
                                        <td class="label">&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td><input type="button" name="submitRequestData" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('navigationSettings.panel').value='5';document.getElementById('submitFormObject').value='true';document.formdata.submit();" /></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        </div> <!-- end of accordion 1 -->
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                {defaultPanel: 0,
                                 useFixedPanelHeights: false,
                                 nextPanelKeyCode: 78 /* n key */,
                                 previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                        </div> <!--  end tabbedpanelscontent -->

                    </div> <!-- tabbedPanelsContentGroup -->
                </div>  <!-- end tabbedPanel -->
                        
                    </div> <!-- tabbedPanelsContentGroup -->
                </div>  <!-- end tabbedPanel -->
               </form:form>   
            </div>  <!-- end tabcontent --> 
            
            <script type="text/javascript">
                var tp1 = new Spry.Widget.TabbedPanels("tp1");
                tp1.showPanel(${navigationSettings.tab});
                Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
                Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
            </script>

                </c:when>
            </c:choose>
        </c:forEach>
    </c:when>
    <c:otherwise>
        Admission module is not activated for your system. Please activate our request for admission at the academic office.
    </c:otherwise>
</c:choose>
    
    </div> <!-- end tabwrapper -->

    <div id="footer">
        <a class="white" href="http://www.opuscollege.net" target="_blank"><fmt:message key="jsp.footer.poweredby" /> <fmt:message key="jsp.footer.ru" /> &amp; <fmt:message key="jsp.footer.mec" /> 
        <br />&amp; <fmt:message key="jsp.footer.ucm" /> &amp; <fmt:message key="jsp.footer.cbu" /> &amp; <fmt:message key="jsp.footer.unza" />
        </a>
    </div>

    <noscript>
        <html>
        <body>
            JavaScript is turned off in your web browser. Turn it on to take full advantage of this site, then refresh the page.
        </body>
        </html>
    </noscript>

</body>
</html>
