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
Employee employee = ud.fetchEmployeeDetails(user);
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