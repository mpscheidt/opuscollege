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
<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%-- in some, but not all JSPs the standard includes are included directly --%>
<%@ include file="./includes/standardincludes.jsp"%>


<%--
response.setHeader("Cache-Control","no-store, no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
--%>

<html xmlns="http://www.w3.org/1999/xhtml">

<jsp:useBean class="org.uci.opus.config.OpusConstants" id="opusConstants" scope="application" />

<%
// used beans:
//out.println("<font color=\"red\">" + opusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED + "</font>");

ServletContext context = this.getServletContext();

String preferredLanguage = "";
preferredLanguage = org.uci.opus.util.OpusMethods.getPreferredLanguage(request);

List < org.uci.opus.college.domain.AppConfigAttribute > appConfig = 
       (List < org.uci.opus.college.domain.AppConfigAttribute >) session.getAttribute("appConfig");
String iFeeDiscountPercentages = (String) session.getAttribute("iFeeDiscountPercentages");
String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");
%>

<%-- TODO: replace all references to web.xml context params with like ${initParam.iCountry}
     Note: initParam is an implicit object provided by JSTL --%>
<c:set var="prefLanguage" value="<%= preferredLanguage %>" />
<c:set var="appFeeDiscountPercentages" value="<%= iFeeDiscountPercentages %>" />
<c:set var="appUseOfPartTimeStudyGradeTypes" value="<%= iUseOfPartTimeStudyGradeTypes %>" />

<%-- TODO get rid of this looping business; see also appConfigMap which is set into the session in OpusMethods --%>
<c:forEach var="appConfigAttribute" items="${appConfig}">
   <c:if test="${fn:toLowerCase(appConfigAttribute.appConfigAttributeName) == 'useofsubjectblocks'}">
       <c:set var="appUseOfSubjectBlocks" value="${appConfigAttribute.appConfigAttributeValue}"/>
   </c:if>
   <c:if test="${fn:toLowerCase(appConfigAttribute.appConfigAttributeName) == 'useofsubsidies'}">
      <c:set var="appUseOfSubsidies" value="${appConfigAttribute.appConfigAttributeValue}"/>
   </c:if>
   <c:if test="${fn:toLowerCase(appConfigAttribute.appConfigAttributeName) == 'useofscholarshipdecisioncriteria'}">
      <c:set var="appUseOfScholarshipDecisionCriteria" value="${appConfigAttribute.appConfigAttributeValue}"/>
   </c:if>
</c:forEach>

<c:set var="INSTITUTION_TYPE_SECONDARY_SCHOOL" value="<%= opusConstants.INSTITUTION_TYPE_SECONDARY_SCHOOL %>" />
<c:set var="INSTITUTION_TYPE_HIGHER_EDUCATION" value="<%= opusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION %>" />

<c:set var="GRADE_TYPE_SECONDARY_SCHOOL" value="<%= opusConstants.GRADE_TYPE_SECONDARY_SCHOOL %>" />

<%-- gradetypes for educationLevelCode --%>
<c:set var="GRADE_TYPE_BACHELOR" value="<%= opusConstants.GRADE_TYPE_BACHELOR %>" />
<c:set var="GRADE_TYPE_MASTER" value="<%= opusConstants.GRADE_TYPE_MASTER %>" />
<c:set var="STUDYPLAN_STATUS_WAITING_FOR_PAYMENT" value="<%= opusConstants.STUDYPLAN_STATUS_WAITING_FOR_PAYMENT %>" />
<c:set var="STUDYPLAN_STATUS_WAITING_FOR_SELECTION" value="<%= opusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION %>" />
<c:set var="STUDYPLAN_STATUS_APPROVED_ADMISSION" value="<%= opusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION %>" />
<c:set var="STUDYPLAN_STATUS_REJECTED_ADMISSION" value="<%= opusConstants.STUDYPLAN_STATUS_REJECTED_ADMISSION %>" />
<c:set var="STUDYPLAN_STATUS_TEMPORARILY_INACTIVE" value="<%= opusConstants.STUDYPLAN_STATUS_TEMPORARILY_INACTIVE %>" />
<c:set var="STUDYPLAN_STATUS_GRADUATED" value="<%= opusConstants.STUDYPLAN_STATUS_GRADUATED %>" />
<c:set var="STUDYPLAN_STATUS_WITHDRAWN" value="<%= opusConstants.STUDYPLAN_STATUS_WITHDRAWN %>" />

<c:set var="CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT %>" />
<c:set var="CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME %>" />
<c:set var="CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION %>" />
<c:set var="CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION %>" />
<c:set var="CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED %>" />
<c:set var="CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE" value="<%= opusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE %>" />

<c:set var="PROGRESS_STATUS_GRADUATE" value="<%= opusConstants.PROGRESS_STATUS_GRADUATE %>" />

<c:set var="ATTACHMENT_RESULT" value="<%= opusConstants.ATTACHMENT_RESULT %>" />

<c:set var="screentitle">
    <c:if test="${not empty screentitledetails}"><c:out value="${screentitledetails} -" /></c:if>
    <c:if test="${not empty screentitlekey}"><fmt:message key="${screentitlekey}"/> </c:if>
</c:set>

<head>
    <title>
        <c:if test="${not empty screentitle}"><c:out value="${screentitle} -" /></c:if>
        ${initParam.iAppname}
    </title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    
    <jwr:style src="/styles/college.css" /> 
    <jwr:style src="/styles/college1024.css" /> 
    <jwr:style src="/styles/smoothness.css" />
    <jwr:style src="/styles/mainUniversity.css" />

    <jwr:script src="/bundles/college.js" />  
    <jwr:script src="/bundles/jquerycomp.js" />  
    
    <script type="text/javascript">
        // choose optional extra stylesheets:
        chooseStyle();

        // Link for msg.html
        popupLink = "<c:url value='/static/msg.html' />";
        
    </script>

    <%-- 
        Using jawr and ckeditor together requires setting the ckeditor basepath 
        so that ckeditor is ably to load additional components, as described here:
        https://java.net/jira/browse/JAWR-352
     --%>
    <script type="text/javascript">
    window.CKEDITOR_BASEPATH = '<%= pageContext.getServletContext().getContextPath()+"/lib/ckeditor/"%>';
    </script>
    <jwr:script src="/bundles/wysiwyg.js" />


    <!-- Piwik -->
    <c:if test="${not empty initParam.PIWIK_URL and not empty initParam.PIWIK_SITE_ID}">
        <script type="text/javascript">
              var _paq = _paq || [];
              _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
              _paq.push(['setUserId', '${opusUserRole.userName}']);
              _paq.push(['trackPageView']);
              _paq.push(['enableLinkTracking']);
              (function() {
                var u="${initParam.PIWIK_URL}";
                        _paq.push(['setTrackerUrl', u+'piwik.php']);
                        _paq.push(['setSiteId', ${initParam.PIWIK_SITE_ID}]);
                        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
                        g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
                      })();
        </script>
        <noscript><p><img src="${initParam.PIWIK_URL}?idsite=${initParam.PIWIK_SITE_ID}" style="border:0;" alt="" /></p></noscript>
    </c:if>

</head>
