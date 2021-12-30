
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<div class="AccordionPanel">
  <div class="AccordionPanelTab"><fmt:message key="general.primavera" /></div>
    <div class="AccordionPanelContent">  
        <table border="1" align="center" style="width: 100%">
            <thead>
				<tr>
					<th align="center">Modulo</th>
					<th align="center">TipoDoc</th>
					<th align="center">DataDoc</th>
					<th align="center">DataVenc</th>
					<th align="center">DataLiq</th>
					<th align="center">ValorTotal</th>
					<th align="center">ValorPendente</th>
					<th align="center">DescDoc</th>
				</tr>
			</thead>

			<tbody>
                <c:forEach var="primaveraResults" items="${studentPrimaveraForm.primavera.result}">
                    <tr>
                        <td> <c:out value="${primaveraResults.modulo}"></c:out></td>
                        <td><c:out value="${primaveraResults.tipoDoc}"></c:out></td>
                        <td><c:out value="${primaveraResults.dataDoc}"></c:out></td>
                        <td><c:out value="${primaveraResults.dataVenc}"></c:out></td>
                        <td><c:out value="${primaveraResults.dataDoc}"></c:out></td>
                        <td><c:out value="${primaveraResults.dataLiq}"></c:out></td>
                        <td><c:out value="${primaveraResults.valorPendente}"></c:out></td>
                        <td><c:out value="${primaveraResults.descDoc}"></c:out></td>
                    </tr>
                </c:forEach>
			</tbody>
		</table>

    </div> 
</div> 
