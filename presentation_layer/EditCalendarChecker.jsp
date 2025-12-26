<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.reflect.TypeToken" %>


<%
  User user = (User)session.getAttribute("user");
  if (user == null) { %> 
    <jsp:forward page = "forcedLogin.jsp"/>
<% }

    int managerId = user.getId();
    String calendarIdStr = request.getParameter("calendarId");
    String shiftsDataJson = request.getParameter("shiftsData");
    String deletedIdsJson = request.getParameter("deletedIds");

    int calendarId = Integer.parseInt(calendarIdStr);
    ShiftDAO sdao = new ShiftDAO();
    Gson gson = new Gson();
    try {
        // ---------- DELETE ----------
        if (deletedIdsJson != null && !deletedIdsJson.trim().isEmpty() && !deletedIdsJson.trim().equals("[]")) {
            List<String> deletedIds = gson.fromJson(
                deletedIdsJson,
                new TypeToken<List<String>>() {}.getType()
            );

            if (deletedIds != null) {
                // Collect valid IDs into a List of Integers
                List<Integer> idsToDelete = new ArrayList<>();
                Set<String> uniq = new LinkedHashSet<>(deletedIds);

                for (String idStr : uniq) {
                    if (idStr == null) continue;
                    idStr = idStr.trim();
                    if (idStr.isEmpty()) continue;
                    try {
                        idsToDelete.add(Integer.parseInt(idStr));
                    } catch (NumberFormatException e) {
                        // ignore malformed ID
                    }
                }
                List<Shift> shiftsToBeRemoved = new ArrayList<>();
                for (int id : idsToDelete) {
                    //out.println(id);
                    shiftsToBeRemoved.add(sdao.fetchShiftById(id));
                }
                // Call the new Batch Delete method ONCE
                if (!shiftsToBeRemoved.isEmpty()) {
                    sdao.removeShiftsInEdit(shiftsToBeRemoved);
                }
            }
        }
        // ----------------------------------------------------
        // INSERT/UPDATE 
        // ----------------------------------------------------
        if (shiftsDataJson != null && !shiftsDataJson.trim().isEmpty() && !shiftsDataJson.trim().equals("[]")) {
            List<ShiftEditDTO> dtos = gson.fromJson(
                shiftsDataJson,
                new TypeToken<List<ShiftEditDTO>>() {}.getType()
            );
            if (dtos != null) {
                for (ShiftEditDTO dto : dtos) {
                    if (dto == null) continue;
                    //out.println(dto);
                    if (dto.isNew()) {
                        sdao.insertShift(dto.toShiftForInsert(managerId, calendarId));
                    } else {
                        continue;
                    }
                }
            }
        }
        //this is for js to understand that everything went well and redirection to dashboard should be performed
        out.println("ok");
    } catch (Exception e) {
        out.print(e.getMessage());
    }
%>
