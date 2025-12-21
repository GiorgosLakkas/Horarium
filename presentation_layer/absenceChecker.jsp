<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.time.*"%>

<%
//we need to explicitely handle exceptions when caught
String updatedStatus = request.getParameter("action");
int shiftChangeRequestId = Integer.parseInt(request.getParameter("requestId"));
RequestDAO rd = new RequestDAO();
if ("reject".equals(updatedStatus)) {
    rd.updateRequestStatus(shiftChangeRequestId,"rejected"); %>
    <jsp:forward page = "ReviewShiftChange.jsp"/>
<% } else { 
    rd.updateRequestStatus(shiftChangeRequestId,"accepted");
    ShiftChangeRequest shiftRequest = rd.fetchShiftChangeDataByRequestId(shiftChangeRequestId);
    ShiftDAO sh = new ShiftDAO();
    //shift with the date of the old_shift_date date in the ShiftChangeRequest
    //this one throws exception if no old shift with this data exists => need to show the employee a list of their shifts in the specific day of the week they choose
    //they are restricted to choose an existant on, so that exceptions are surpassed successfully
    Shift oldShift = sh.fetchShiftDataFromRequestByEmployeeId(shiftRequest.getOldShiftDate());
    Shift newShift = new Shift(oldShift.getEmployeeId(),
    oldShift.getManagerId(),oldShift.getCalendarId(),
    shiftRequest.getStartingTime().toLocalTime(),shiftRequest.getEndingTime().toLocalTime(),shiftRequest.getNewShiftDate());
    try {
        sh.removeShift(oldShift);
        sh.insertShift(newShift);
    } catch (Exception e) {
        //out.println(oldShift.getShiftId() + " " + e.getMessage());
        if (e.getMessage().equals("No shift was removed") || e.getMessage().equals("No shift at this date exists")) {
            sh.insertShift(newShift);
        }
        return;
    } 
    session.setAttribute("flag",oldShift.getEmployeeId());
    response.sendRedirect("CalendarEdit.jsp");
    //if it does not work => return to forward
}
    %>