<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>

<%!
    public static class ShiftPayload {
        public String shiftId;
        public String employeeId;
        public String start;
        public String end;
        public String date;
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.setStatus(401);
        out.print("Not logged in");
        return;
    }

    int managerId = user.getId();

    String calendarIdStr = request.getParameter("calendarId");
    String shiftsDataJson = request.getParameter("shiftsData");
    String deletedIdsJson = request.getParameter("deletedIds");

    int calendarId;
    try {
        calendarId = Integer.parseInt(calendarIdStr);
    } catch (Exception e) {
        response.setStatus(400);
        out.print("Missing/invalid calendarId");
        return;
    }

    if (calendarId <= 0) {
        response.setStatus(400);
        out.print("No active calendar to edit");
        return;
    }

    ShiftDAO sdao = new ShiftDAO();
    Gson gson = new Gson();

    try {
        // ---------- DELETE ----------
        if (deletedIdsJson != null && !deletedIdsJson.trim().isEmpty() && !deletedIdsJson.trim().equals("[]")) {
            java.lang.reflect.Type listType = new TypeToken<List<String>>(){}.getType();
            List<String> deletedIds = gson.fromJson(deletedIdsJson, listType);

            if (deletedIds != null) {
                Set<String> uniq = new LinkedHashSet<>(deletedIds);
                for (String idStr : uniq) {
                    if (idStr == null) continue;
                    idStr = idStr.trim();
                    if (idStr.isEmpty()) continue;

                    int shiftId;
                    try {
                        shiftId = Integer.parseInt(idStr);
                    } catch (Exception ignore) {
                        continue;
                    }

                    Shift sh = new Shift();
                    sh.setShiftId(shiftId);
                    sdao.removeShift(sh);
                }
            }
        }

        // ---------- INSERT/UPDATE ----------
        if (shiftsDataJson != null && !shiftsDataJson.trim().isEmpty() && !shiftsDataJson.trim().equals("[]")) {
            java.lang.reflect.Type listType = new TypeToken<List<ShiftPayload>>(){}.getType();
            List<ShiftPayload> shifts = gson.fromJson(shiftsDataJson, listType);

            if (shifts != null) {
                for (ShiftPayload p : shifts) {
                    if (p == null) continue;
                    if (p.employeeId == null || p.start == null || p.end == null || p.date == null) continue;

                    int employeeId;
                    LocalTime start;
                    LocalTime end;
                    LocalDate date;

                    try {
                        employeeId = Integer.parseInt(p.employeeId.trim());
                        start = LocalTime.parse(p.start.trim());
                        end = LocalTime.parse(p.end.trim());
                        date = LocalDate.parse(p.date.trim());
                    } catch (Exception ignore) {
                        continue;
                    }

                    if (p.shiftId == null || p.shiftId.trim().isEmpty()) {
                        Shift newShift = new Shift(employeeId, managerId, calendarId, start, end, date);
                        try { sdao.insertShift(newShift); } catch (Exception ignore) {}
                    } else {
                        int shiftId;
                        try { shiftId = Integer.parseInt(p.shiftId.trim()); }
                        catch (Exception ignore) { continue; }

                        Shift updated = new Shift(shiftId, employeeId, managerId, calendarId, start, end, date);
                        sdao.updateShift(updated);
                    }
                }
            }
        }

        out.print("OK");
    } catch (Exception e) {
        response.setStatus(500);
        out.print("Server error: " + e.getMessage());
    }
%>
