<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application_layer.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.*" %>
<%@ page import = "java.util.*"%>


<%
    User user = (User) session.getAttribute("user");
    String shiftList = request.getParameter("shiftsData");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String dateCreatedStr = request.getParameter("dateSubmitted");
    //String managerIdStr = request.getParameter("userId");

    LocalDate startDate = LocalDate.parse(startDateStr);
    LocalDate endDate = LocalDate.parse(endDateStr);
    LocalDate dateCreated = LocalDate.parse(dateCreatedStr);
    int managerId = user.getId();
    


    if (shiftList == null || shiftList.trim().equals("[]")) {
        request.setAttribute("error", "You have not submitted any Shifts");
%>  <jsp:forward page="CalendarCreation.jsp" />
<%
        return;
    }

    JobCalendar jobCalendar = new JobCalendar(managerId, dateCreated, startDate, endDate);
    JobCalendarDao dao = new JobCalendarDao();
    int calendarId = dao.inserJobCalendarReturnMaxId(jobCalendar);



    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
    if (shiftList != null && !shiftList.equals("[]")) {
    
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
            "\\{\\\"day\\\":\\\"(.*?)\\\",\\\"start\\\":\\\"(.*?)\\\",\\\"end\\\":\\\"(.*?)\\\",\\\"employee\\\":\\\"(.*?)\\\"\\}"
        );    
        java.util.regex.Matcher matcher = pattern.matcher(shiftList);
        
        List<Shift> shiftListFinal = new ArrayList<>();

        while (matcher.find()) {
            //String day = matcher.group(1);
            String startStr = matcher.group(2);
            String endStr = matcher.group(3);
            String employeeStr = matcher.group(4);

            LocalTime start = LocalTime.parse(startStr, formatter);
            LocalTime end = LocalTime.parse(endStr, formatter);
            int employeeId = Integer.parseInt(employeeStr);
            Shift shift = new Shift(employeeId, managerId, calendarId, start, end, dateCreated);
            shiftListFinal.add(shift);
        }
        ShiftDAO sdao = new ShiftDAO();
        sdao.putShiftsToDatabase(shiftListFinal);
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
    <p>Start Date: <%= startDate %></p>
    <p>End Date: <%= endDate %></p>
    <p>End Date: <%= managerId %></p>

    <h3>Shifts JSON:</h3>
    <pre><%= shiftList %></pre>
</body>
</html>  -->
