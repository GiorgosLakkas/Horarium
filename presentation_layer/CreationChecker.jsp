<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application_layer.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.*" %>
<%@ page import = "java.util.*"%>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.OffsetDateTime" %>




<%
    User user = (User) session.getAttribute("user");
    String shiftList = request.getParameter("shiftsData");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String dateCreatedStr = request.getParameter("dateSubmitted");
    //String managerIdStr = request.getParameter("userId");


    if (shiftList == null || shiftList.trim().equals("[]")) {
        request.setAttribute("error", "You have not submitted any Shifts");
        %><jsp:forward page="CalendarCreation.jsp" /><%
        return;
    } else {
        // Parse dates
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr);
        LocalDate dateCreated = LocalDate.parse(dateCreatedStr);
        int managerId = user.getId();
    
        // Create job calendar
        JobCalendar jobCalendar = new JobCalendar(managerId, dateCreated, startDate, endDate);
        JobCalendarDAO dao = new JobCalendarDAO();
        int calendarId = dao.insertJobCalendarReturnMaxId(jobCalendar);
    
        // Process shifts
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
    
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile( "\\{\\\"day\\\":\\\"(.*?)\\\",\\\"start\\\":\\\"(.*?)\\\",\\\"end\\\":\\\"(.*?)\\\",\\\"employee\\\":\\\"(.*?)\\\"\\}" ); 
        
        java.util.regex.Matcher matcher = pattern.matcher(shiftList);
        List<Shift> shiftListFinal = new ArrayList<>();
    
        while (matcher.find()) {
            String datestr = matcher.group(1);
            String startStr = matcher.group(2);
            String endStr = matcher.group(3);
            String employeeStr = matcher.group(4);
    
            LocalTime start = LocalTime.parse(startStr, formatter);
            LocalTime end   = LocalTime.parse(endStr, formatter);
            LocalDate date = OffsetDateTime.parse(datestr).toLocalDate();

            int employeeId = Integer.parseInt(employeeStr);
            Shift shift = new Shift(employeeId, managerId, calendarId, start, end, date);
            shiftListFinal.add(shift);
        }
    
        ShiftDAO sdao = new ShiftDAO();
        sdao.putShiftsToDatabase(shiftListFinal);
    }
%> <jsp:forward page="CalendarCreation.jsp" />


