<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>


<!DOCTYPE html>
<html lang="en">
<%
  User user = (User)session.getAttribute("user");
  if (user == null || "manager".equals(UserDAO.defineUserType(user.getId()))) { 
      %><jsp:forward page="forcedLogin.jsp"/><%
  }
  

  LocalDate date = LocalDate.now();
  int employee_id = user.getId();
  UserDAO udao = new UserDAO();
  Employee emp = udao.fetchEmployeeDetails(user);

  int manager_id = emp.getManagerId();

  JobCalendarDAO jobdao = new JobCalendarDAO();
  ShiftDAO sdao = new ShiftDAO();



  
  // Fetch current calendar safely
  JobCalendar current = jobdao.getCurrentJobCalendar(date, manager_id);
  
  // Prepare empty maps in case there is no calendar
  Map<String, List<Shift>> calendar = new HashMap<>();
  
  
  if (current != null) {
      int calendar_id = current.getCalendarId();
  
      
      List<Employee> employees = udao.fetchEmployeesByManagerId(manager_id);
      List<Shift> shifts = sdao.retrieveShifts(manager_id);
  
      shifts.removeIf(s -> s.getCalendarId() != calendar_id);
      shifts.removeIf(s -> s.getEmployeeId() != employee_id);

      current.fillJobCalendar(shifts);
  
      calendar = current.getJobCalendar();
  }
  
  List<Employee> employees = udao.fetchEmployeesByManagerId(manager_id);
  Map<Integer, String> employeeNames = new HashMap<>();
  for (Employee e : employees) {
      employeeNames.put(e.getId(), e.getSurname());
  }
  
  Map<String, List<Map<String,String>>> jsCalendar = new HashMap<>();
  for (Map.Entry<String, List<Shift>> entry : calendar.entrySet()) {
      List<Map<String,String>> shiftList = new ArrayList<>();
      for (Shift s : entry.getValue()) {
          Map<String,String> shiftMap = new HashMap<>();
          shiftMap.put("time", s.getStartTime() + " – " + s.getEndTime());
          shiftMap.put("employee", employeeNames.getOrDefault(s.getEmployeeId(), ""));
          shiftList.add(shiftMap);
      }
      jsCalendar.put(entry.getKey().substring(0,3), shiftList);
  }

  Gson gson = new Gson();
  String jsonCalendar = gson.toJson(jsCalendar);

%>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Horarium | Manager Dashboard</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/dashboard.css">
<link rel="stylesheet" href="css/manager.css">
<link rel="stylesheet" href="css/responsive.css">
<link rel="stylesheet" href="css/calendarNikou.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>

<body class="dashboard-body">
  <div class="dashboard-container">

    <aside class="sidebar">
      <div style="margin-bottom: 30px;">
        <a href="employeeDashboard.jsp">
          <img src="images/logo.png" alt="Company Logo" style="width: 150px; height: auto;">
        </a>
      </div>
      

      <div class="clock-container">
        <div id="clock" class="clock-time">--:--:--</div>
        <div id="date-line" class="clock-date">Loading...</div>
      </div>

      <ul class="menu">
        <li><a href="#" class="active"><i class="fa-solid fa-house"></i> Home</a></li>
        <li>
          <details>
            <summary><i class="fa-solid fa-inbox"></i> My Stats</summary>
            <ul class="menu" style="padding-left: 10px;">
              <li><a href="EmployeeInfo.jsp"><i class="fa-solid fa-arrows-rotate"></i> Employee Information</a></li>
              <li><a href="myRequests.jsp"><i class="fa-solid fa-user-clock"></i> Request History</a></li>
            </ul>
          </details>
        </li>        <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>

    <main class="main-content">
      <header class="header">
        <div class="profile-section">
          <img src="images/member1.png" alt="Profile" class="profile-icon">
          <h1>Welcome, <%=user.getUsername()%> </h1>
        </div>
        <button class="request-btn" onclick="window.location.href='request.jsp'">
          <i class="fa-solid fa-paper-plane"></i> Make Request
        </button>        
      </header>
      

      <section class="calendar-section">
        <div class="calendar-header">
          <h2 id="weekRange"></h2>
        </div>
      
        <div class="week-calendar" id="weekCalendar"></div>
        

      </section>
      
    </main>
  </div>


  <script id="shifts-data" type="application/json">
    <%= jsonCalendar %>
  </script>
  <script src="js/managerDashboard.js" defer></script>
  <script src="js/weeklyCalendar.js" defer></script>
  <script src="js/clock.js" defer></script>

</body>
</html>