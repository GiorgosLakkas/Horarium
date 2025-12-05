<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>

<%
    User user = (User) session.getAttribute("user");
    String shiftList = request.getParameter("shiftsData");
    String start = request.getParameter("startDate");
    String end = request.getParameter("endDate");

    if (shiftList == null || shiftList.trim().equals("[]")) {
        request.setAttribute("error", "You have not submitted any Shifts");
%>  <jsp:forward page="CalendarCreation.jsp" />
<%
        return;
    }
%>



<!-- <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Calendar Submission</title>
</head>
<body>
    <h2>Week Submitted</h2>
    <p>Start Date: <%= start %></p>
    <p>End Date: <%= end %></p>

    <h3>Shifts JSON:</h3>
    <pre><%= shiftList %></pre>
</body>
</html> -->
