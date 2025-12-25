<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.time.*"%>

<%
User user = (User)session.getAttribute("user");

AbsenceRequest.AbsenceType absenceType = AbsenceRequest.AbsenceType.valueOf(request.getParameter("absenceType").toUpperCase());
LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

RequestDAO rd = new RequestDAO();
UserDAO ud = new UserDAO();
//calculate the time interaval of absence in days
int requestedAbsenceDays = AbsenceRequest.countWeekdays(startDate,endDate);
Employee employee = ud.fetchEmployeeDetails(user);
if (requestedAbsenceDays > employee.getDaysOffRemaining() && employee.getDaysOffRemaining() > 0) {
    request.setAttribute("flag", "Requested absence days surpass your remaining days off! You have " + employee.getDaysOffRemaining() + " days off remaining"); %>
    <jsp:forward page = "absenceRequest.jsp"/>
<%  return;
} else if (employee.getDaysOffRemaining() == 0) {
    request.setAttribute("flag", "You have no remaining days off!"); %>
    <jsp:forward page = "absenceRequest.jsp"/>
<%  return;
}
Request req = new Request(user.getId(),employee.getManagerId(),LocalDate.now(),Request.Status.PENDING);
try {
    int lastInsertedRequestId = rd.insertRequest(req);
    AbsenceRequest absence = new AbsenceRequest(lastInsertedRequestId,req.getEmployeeId(),req.getManagerId(),
    req.getDate(),req.getStatus(),startDate,endDate,absenceType);
    rd.insertAbsenceRequest(absence);
    response.sendRedirect("employeeDashboard.jsp");
} catch (Exception e) {
    out.println(e.getMessage());
    return;
}
%>