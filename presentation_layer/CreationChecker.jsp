<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.*" %>
<%@ page import = "java.util.*"%>


<%
    User user = (User) session.getAttribute("user");
    String shiftList = request.getParameter("shiftsData");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String dateSubmittedStr = request.getParameter("dateSubmitted");
    String managerId = request.getParameter("userId");

    LocalDate startDate = LocalDate.parse(startDateStr);
    LocalDate endDate = LocalDate.parse(endDateStr);
    LocalDate dateSubmitted = LocalDate.parse(dateSubmittedStr);

    if (shiftList == null || shiftList.trim().equals("[]")) {
        request.setAttribute("error", "You have not submitted any Shifts");
%>  <jsp:forward page="CalendarCreation.jsp" />
<%
        return;
    }

    //JobCalendar jobCalendar = new JobCalendar(id )

    if (shiftList != null && !shiftList.equals("[]")) {
    
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
            "\\{\\\"day\\\":\\\"(.*?)\\\",\\\"start\\\":\\\"(.*?)\\\",\\\"end\\\":\\\"(.*?)\\\",\\\"employee\\\":\\\"(.*?)\\\"\\}"
        );    
        java.util.regex.Matcher matcher = pattern.matcher(shiftList);
        
        List<Shift> shiftListFinal = new ArrayList<>();

        while (matcher.find()) {
            String day = matcher.group(1);
            String start = matcher.group(2);
            String end = matcher.group(3);
            String employee = matcher.group(4);

    
            out.println("Day: " + day + ", " + start + "-" + end + ", Employee: " + employee + "<br>");
        }
    }

%>


<!-- 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Calendar Submission</title>
</head>
<body>
    <h2>Week Submitted</h2>
    <p>Start Date: <%= startDate %></p>
    <p>End Date: <%= endDate %></p>

    <h3>Shifts JSON:</h3>
    <pre><%= shiftList %></pre>
</body>
</html>  -->
