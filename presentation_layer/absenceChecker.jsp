<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>

<%
// we need a way to define the absence interval of an employee in case of an accepted absence request
// send redirect to ReviewAbsence.jsp
String updatedStatus = request.getParameter("action");
int absenceRequestId = Integer.parseInt(request.getParameter("requestId"));
RequestDAO rd = new RequestDAO();
if ("reject".equals(updatedStatus)) {
    rd.updateRequestStatus(absenceRequestId,"rejected"); %>
    <jsp:forward page = "ReviewAbsence.jsp"/>
<% } else {
    rd.updateRequestStatus(absenceRequestId,"accepted");
    AbsenceRequest absenceRequest = rd.fetchAbsenceDataByRequestId(absenceRequestId);
    try {
        rd.insertDaysOff(absenceRequestId,absenceRequest.getStartDate(),absenceRequest.getEndDate());
        rd.updateDaysOffRemainingByRequestId(absenceRequest.getStartDate(),absenceRequest.getEndDate());
    } catch (Exception e) {
        out.println(e.getMessage());
        return;
    } 
    response.sendRedirect("ReviewAbsence.jsp");
} %>