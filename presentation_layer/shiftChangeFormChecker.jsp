<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.time.*"%>
<%@ page import = "java.time.format.*" %>

<%
User user = (User)session.getAttribute("user");

int shiftId = Integer.parseInt(request.getParameter("shiftId"));
LocalDate date = LocalDate.parse(request.getParameter("newDay"));
LocalDateTime startTime = LocalDateTime.parse(date + " " + request.getParameter("startTime"),DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
LocalDateTime endTime = LocalDateTime.parse(date + " " + request.getParameter("endTime"),DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
//need to firstly insert the request to the Request table and then to the ShiftChangeRequest
//for date_created we should use the current date provided by java.time
RequestDAO rd = new RequestDAO();
ShiftDAO sd = new ShiftDAO();
//shift object will be used for providing critical data for the shiftChangeRequest
Shift shift = sd.fetchShiftById(shiftId);
Request req = new Request(user.getId(),shift.getManagerId(),LocalDate.now(),Request.Status.PENDING);
try {
    int lastInsertedRequestId = rd.insertRequest(req);
    ShiftChangeRequest shiftChange = new ShiftChangeRequest(lastInsertedRequestId,req.getEmployeeId(),req.getManagerId(),
    req.getDate(),req.getStatus(),shift.getDate(),date,startTime,endTime);
    rd.insertShiftChangeRequest(shiftChange);
    response.sendRedirect("employeeDashboard.jsp");
} catch (Exception e) {
    out.println(e.getMessage());
    return;
}
%>