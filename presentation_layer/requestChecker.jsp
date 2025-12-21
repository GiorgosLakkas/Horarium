<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>

<%


User user = (User) session.getAttribute("user");
String sourceStr = request.getParameter("source");
int source = 0;
try {
    source = Integer.parseInt(sourceStr);
} catch (NumberFormatException e) {
    // handle error
    source = -1; 

}
if (source == 1) {
    String type = request.getParameter("absenceType");
    String start = request.getParameter("startDate");
    String end = request.getParameter("endDate");
    

    out.println(user.getName());
    out.println(type);
    out.println(start);
    out.println(end);
    out.println(source);


} else {
    String oldDay = request.getParameter("oldDay");
    String newDay = request.getParameter("newDay");
    String start = request.getParameter("startTime");
    String end = request.getParameter("endTime");
    

    out.println(user.getName());
    out.println(oldDay);
    out.println(newDay);
    out.println(start);
    out.println(end);
    out.println(source);

}

%>
