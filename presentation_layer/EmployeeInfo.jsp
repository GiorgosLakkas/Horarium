<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.util.regex.*" %>


<!DOCTYPE html>
<html lang="en">
<%
  User user = (User)session.getAttribute("user");
  if (user == null) { %> 
    <jsp:forward page = "forcedLogin.jsp"/>
<% } %>

<head>
  <meta charset="UTF-8" />
  <title>Horarium | Employee Info</title>

  <!-- Common styles + theme -->
  <link rel="stylesheet" href="css/global.css" />
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/dashboard.css">
  <link rel="stylesheet" href="css/calendarNikou.css">
  <link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="css/calendar-skin.css" />
  
  <!-- Employee info stats CSS -->
  <link rel="stylesheet" href="css/employeeinfo.css" />

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>

<body class="dashboard-body">
  <div class="dashboard-container">

    <!-- Sidebar -->
    <aside class="sidebar">
      <img src="images/logo.png" alt="Horarium Logo" class="sidebar-logo">

      <!-- Live Clock -->
      <div class="clock-container">
        <div id="clock" class="clock-time">--:--:--</div>
        <div id="date-line" class="clock-date">Loading...</div>
      </div>

      <!-- Menu -->
      <ul class="menu">
        <li><a href="employeeDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>

        <li>
          <details open>
            <summary><i class="fa-solid fa-chart-pie"></i> My Stats</summary>
            <ul class="menu" style="padding-left: 10px;">
              <li><a href="EmployeeInfo.jsp" class="active"><i class="fa-solid fa-user"></i> Employee Information</a></li>
              <li><a href="myRequests.jsp"><i class="fa-solid fa-file-lines"></i> Request History</a></li>
            </ul>
          </details>
        </li>

        <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">

      <!-- Header -->
      <header class="header">
        <div class="profile-section">
          <img src="images/member1.png" alt="Profile" class="profile-icon">
          <h1>Welcome, <%=user.getName() + " " + user.getSurname()%></h1>
        </div>
      </header>

      <!-- =======================
           Employee Stats Content
      ========================== -->
      <section class="stats-section">


      <%
      RequestDAO rd = new RequestDAO();
        List<Request> requests = new ArrayList<>();
        requests = rd.retriveEmployeeRequests(user.getId()); 
        int approved_requests = 0;
        int declined_requests = 0;
        int total_requests = 0;

        for (Request r : requests) {
          total_requests ++;

          if (Request.Status.ACCEPTED == r.getStatus()){
              approved_requests ++;
        }else if(Request.Status.REJECTED == r.getStatus()){
              declined_requests++;
        }
      }
      %>

        <!-- CENTERED STATS PANEL -->
        <div class="stats-tabs" id="statsTabs"
            data-approved="<%= approved_requests %>"
            data-declined="<%= declined_requests %>"
            data-managers=""
            data-shift7=""
            data-remaining=""
            data-total="<%= total_requests %>">
          
          <!-- SECTION 1: REQUESTS -->
          <div class="stats-section-box">
            <div class="stats-section-title">
              <i class="fa-solid fa-list-check"></i>
              Requests
            </div>

            <div class="stat-grid">
              <div class="stat-card">
                <span class="stat-label">Approved</span>
                <span class="stat-value positive" id="totalApproved"><%= approved_requests %></span>   
              </div>

              <div class="stat-card">
                <span class="stat-label">Declined</span>
                <span class="stat-value negative" id="totalDeclined"><%= declined_requests %></span>
              </div>

              <div class="stat-card span-2">
                <span class="stat-label">Total Requests(Including Pending)</span>
                <span class="stat-value" id="totalRequests"><%= total_requests %></span>
              </div>
            </div>
          </div>

          <%UserDAO usrD = new UserDAO();
            Employee emp = usrD.fetchEmployeeDetails(user);
            int usedDays = 40 - emp.getDaysOffRemaining();
          %>

          <!-- SECTION 2: WORKLOAD & LEAVE -->
          <div class="stats-section-box">
            <div class="stats-section-title">
              <i class="fa-solid fa-briefcase-clock"></i>
              Workload & Managers
            </div>

            <div class="stat-grid">
              <div class="stat-card span-2">
                <span class="stat-label">Assigned managers</span>
                <span class="stat-value" id="assignedManagers"><%=usrD.getManagerNameDetailsById(emp.getManagerId())%></span>
              </div>
              <% JobCalendarDAO jd = new JobCalendarDAO();
                JobCalendar jobCalendar= jd.fetchCurrentJobCalendar(LocalDate.now());
                ShiftDAO sd = new ShiftDAO();
                List<Shift> weeklyShifts = new ArrayList<>();
                weeklyShifts = sd.fetchAllWeeklyShiftsByEmployeeId(jobCalendar,user.getId());
              %>
              <div class="stat-card span-2">
                <span class="stat-label">Shifts this week</span>
                <span class="stat-value" id="shift7"><%=weeklyShifts.size()%></span>
              </div>
              <!-- NEW Leave Info -->
              <div class="stat-card span-2">
                <span class="stat-label">Leave days</span>
                <div class="leave-summary">
                  <span>Remaining: <span class="stat-value" id="remDays"><%= emp.getDaysOffRemaining() %></span></span>
                  <span>Used: <span class="stat-value" id="usedDays"><%= usedDays%></span></span>
                  <span>Total: <span class="stat-value" id="totalDays">40</span></span>
                </div>
              </div>

            </div>
          </div>

        </div>
        <!-- END STATS PANEL -->

      </section>

    </main>
  </div>

  <!-- Scripts -->
  <script src="js/clock.js" defer></script>

</body>
</html>
