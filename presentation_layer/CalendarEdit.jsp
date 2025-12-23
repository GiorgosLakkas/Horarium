<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
%>
    <jsp:forward page="forcedLogin.jsp"/>
<%
        return;
    }

    int manager_id = user.getId();

    JobCalendarDAO jobdao = new JobCalendarDAO();
    ShiftDAO sdao = new ShiftDAO();
    UserDAO udao = new UserDAO();

    LocalDate today = LocalDate.now();
    JobCalendar current = null;
    try {
        current = jobdao.getCurrentJobCalendar(today, manager_id);
    } catch (Exception e) {
        current = null;
    }

    int calendar_id = (current != null) ? current.getCalendarId() : -1;

    // Fetch employees for dropdown
    List<Employee> employees = udao.fetchEmployeesByManagerId(manager_id);
    Map<Integer, String> employeeNames = new HashMap<>();
    for (Employee e : employees) employeeNames.put(e.getId(), e.getSurname());

    // Build calendar JSON like managerDashboard + extra fields needed for edit (shiftId, date)
    Map<String, List<Map<String, String>>> jsCalendar = new HashMap<>();

    if (current != null) {
        List<Shift> shifts = sdao.retrieveShifts(manager_id);
        shifts.removeIf(s -> s.getCalendarId() != calendar_id);

        current.fillJobCalendar(shifts);
        Map<String, List<Shift>> calendar = current.getJobCalendar();

        for (Map.Entry<String, List<Shift>> entry : calendar.entrySet()) {
            List<Map<String, String>> shiftList = new ArrayList<>();

            for (Shift s : entry.getValue()) {
                Map<String, String> shiftMap = new HashMap<>();
                shiftMap.put("shiftId", String.valueOf(s.getShiftId()));
                shiftMap.put("date", String.valueOf(s.getDate())); // yyyy-MM-dd

                shiftMap.put("start", String.valueOf(s.getStartTime())); // HH:mm
                shiftMap.put("end", String.valueOf(s.getEndTime()));

                shiftMap.put("employeeId", String.valueOf(s.getEmployeeId()));
                shiftMap.put("employee", employeeNames.getOrDefault(s.getEmployeeId(), ""));
                shiftMap.put("time", s.getStartTime() + " – " + s.getEndTime());

                shiftList.add(shiftMap);
            }

            // "Mon","Tue"... keys to match weeklyCalendar.js
            jsCalendar.put(entry.getKey().substring(0, 3), shiftList);
        }
    }

    // Employees JSON for dropdown
    List<Map<String, String>> jsEmployees = new ArrayList<>();
    for (Employee e : employees) {
        Map<String, String> em = new HashMap<>();
        em.put("id", String.valueOf(e.getId()));
        em.put("name", e.getSurname());
        jsEmployees.add(em);
    }

    Gson gson = new Gson();
    String jsonCalendar = gson.toJson(jsCalendar);
    String jsonEmployees = gson.toJson(jsEmployees);
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Edit Calendar</title>

  <link rel="stylesheet" href="css/base.css" />
  <link rel="stylesheet" href="css/calendarNikou.css" />
  <link rel="stylesheet" href="css/calendarEdit.css" />
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>

<body style="display:block; padding:40px; background-color:var(--bg); color:var(--text);">

  <div style="margin-bottom: 30px;">
    <img src="images/logo.png" alt="Company Logo" style="width: 85px; height: auto;">
  </div>

  <div style="display:flex; gap:40px; align-items:flex-start;">

    <!-- LEFT: week calendar (ίδια εμφάνιση με managerDashboard) -->
    <section style="flex: 2;">
      <div class="calendar-header" style="justify-content: space-between;">
        <h2 id="weekRange" style="margin:0;"></h2>
        <div class="nav">
          <button class="week-btn" id="prevWeek">&lt;</button>
          <button class="week-btn" id="nextWeek">&gt;</button>
        </div>
      </div>

      <div class="week-calendar" id="weekCalendar"></div>

      <div style="margin-top: 18px; display:flex; gap:10px; align-items:center;">
        <button class="btn" id="submitChanges" style="width:auto;">Submit Changes</button>
        <span id="saveStatus" style="opacity:0.8;"></span>
      </div>
    </section>

    <!-- RIGHT: add shift panel -->
    <aside style="flex:1; min-width: 360px;">
      <div style="background-color:#1a2332; padding:28px 22px; border-radius:20px; box-shadow:0 10px 30px rgba(0,0,0,0.4);">
        <h2 style="color: var(--accent); text-align:center; margin-bottom: 18px; font-size: 24px;">Add / Edit Shift</h2>

        <div style="display:flex; flex-direction:column; gap:14px;">
          <div>
            <label style="display:block; margin-bottom:6px; font-weight:600;">Day</label>
            <select id="daySelect" style="width:100%; padding:12px; background:#0f1724; color:white; border:1px solid #334155; border-radius:10px;">
              <option value="">-- Select Day --</option>
              <option value="MON">MON</option>
              <option value="TUE">TUE</option>
              <option value="WED">WED</option>
              <option value="THU">THU</option>
              <option value="FRI">FRI</option>
              <option value="SAT">SAT</option>
              <option value="SUN">SUN</option>
            </select>
          </div>

          <div style="display:flex; gap:10px;">
            <div style="flex:1;">
              <label style="display:block; margin-bottom:6px; font-weight:600;">Start</label>
              <input id="startTime" type="time" placeholder="HH:MM" ="width:100%; padding:12px; background:#0f1724; color:white; border:1px solid #334155; border-radius:10px;">
            </div>
            <div style="flex:1;">
              <label style="display:block; margin-bottom:6px; font-weight:600;">End</label>
              <input id="endTime" type="time" placeholder="HH:MM" ="width:100%; padding:12px; background:#0f1724; color:white; border:1px solid #334155; border-radius:10px;">
            </div>
          </div>

          <div>
            <label style="display:block; margin-bottom:6px; font-weight:600;">Employee</label>
            <select id="employeeSelect" style="width:100%; padding:12px; background:#0f1724; color:white; border:1px solid #334155; border-radius:10px;">
              <option value="">-- Select Employee --</option>
            </select>
          </div>

          <button class="btn" id="addShiftBtn">Add Shift</button>

          <hr class="panel-sep" />

              <label>Remove shift (from selected day)</label>
              <select id="removeShiftSelect">
                <option value="">-- Select Shift --</option>
              </select>
              <button class="btn btn-danger" id="removeShiftBtn" type="button">Remove Shift</button>

        </div>
      </div>
    </aside>

  </div>

  <!-- server data -->
  <script id="shifts-data" type="application/json"><%= jsonCalendar %></script>
  <script id="employees-data" type="application/json"><%= jsonEmployees %></script>
  <script id="calendar-id" type="text/plain"><%= calendar_id %></script>

  <!-- NOTE: άλλο αρχείο από weeklyCalendar.js -->
  <script src="js/calendarEdit.js" defer></script>

</body>
</html>
